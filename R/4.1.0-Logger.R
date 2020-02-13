########################################################################################################################
#' @include URI.R
setClass(Class = "Logger", slots = c(
        SourceFilePattern = "character",
        SourceFiles = "data.frame"),
    contains = "DataStructure"
)

setMethod("initialize", signature = "Logger", definition = function(
        .Object,
        unique_name = class(.Object),
        uri,
        local_directory,
        paths,
        pattern) {

      .Object <- callNextMethod(.Object,
          unique_name = unique_name,
          uri = uri,
          local_directory = local_directory,
          paths = paths)
      .Object@SourceFilePattern <- pattern
      .Object@SourceFiles = initialSourceFilesTable()
      .Object
    }
)


########################################################################################################################
#' @include getSourceFilePattern.R
setMethod("getSourceFilePattern", signature = "Logger", definition = function(.Object) {
        return(.Object@SourceFilePattern)
    }
)

#' @include getSourceFileTable.R
setMethod("getSourceFileTable", signature = "Logger", definition = function(.Object) {
        return(.Object@SourceFiles)
    }
)

########################################################################################################################
#' @include saveData.R
setMethod("saveData", signature = "Logger", definition = function(.Object, data) {
        out.dir <- getLocalDirectory(.Object)
        dir.create(out.dir, showWarnings = FALSE)
        file.name <- getOutputFile(.Object)
        saveRDS(data, file = file.path(out.dir, file.name))
        cat("File '", file.name, "' saved in location '", out.dir, "'\n", sep = "")
    }
)

#' @include getData.R
setMethod("getData", signature = "Logger", definition = function(.Object, start.date, end.date) {
        data <- loadData(.Object)
        if (!is.null(data)) {
            data <- data[Datum >= as.POSIXct(start.date, tz = "UTC") &
                    Datum < as.POSIXct(end.date, tz = "UTC")]
        }
        return(data)
    }
)

#' @include loadData.R
setMethod("loadData", signature = "Logger", definition = function(.Object) {
        path <- getLocalDirectory(.Object)
        file.name <- getOutputFile(.Object)
        object.path <- file.path(path, file.name)
        if (file.exists(object.path)) {
            object <- readRDS(file = object.path)
            return(object)
        } else {
            # Returning NULL in case that no data exists yet, so getData etc. don't break if only partial data was
            # initialized
            return(NULL)
        }
    }
)

#' @include updateFilePaths.R
setMethod("updateFilePaths", signature = "Logger", definition = function(.Object) {
        all.files <- dir(getSourcePaths(.Object), full.names = TRUE, recursive = TRUE)
        select.files <- all.files[stringr::str_detect(basename(all.files), pattern = getSourceFilePattern(.Object))]
        file.table <- data.table::data.table(
            file = basename(select.files),
            path = as.factor(dirname(select.files)))
        data.table::setkey(file.table, path, file)
        source.table <- getSourceFileTable(.Object)[file.table]
        source.table[is.na(imported), imported := FALSE]
        source.table[is.na(skip), skip := FALSE]
        .Object@SourceFiles <- source.table
        .Object
    }
)

#' @include updateData.R
setMethod("updateData", signature = "Logger", definition = function(.Object) {
        source.files <- getSourceFileTable(.Object)
        # only use import files which are new to reduce processing time
        if (source.files[, FALSE %in% (imported | skip)]) {
            new.data.list <- list()
            for (index in source.files[, which(imported == FALSE & skip == FALSE)]) {
                current.file.path <- source.files[index, file.path(path, file)]
                tryCatch({
                        new.data <- importRawLoggerFile(.Object, current.file.path)
                        new.data[value == 9999 | value == -9999, value := NA]
                        new.data <- new.data[!is.na(value)]
                        new.data[, ":=" (
                                Plot = as.factor(getPlotName(.Object)),
                                SubPlot = as.factor(getSubPlotName(.Object)),
                                Logger = as.factor(getName(.Object)))]
                        non.duplicates <- new.data[new.data[, !duplicated(Datum), by = variable][, V1]]
                        date.col <- unique(non.duplicates[, Datum])
                        if (length(date.col) == 1 && is.na(date.col)) {
                            source.files[index, skip := TRUE]
                            stop("Date column was not imported correctly (Only NA's)")
                        }
                        if (nrow(non.duplicates) != nrow(new.data)) {
                            new.data <- non.duplicates
                            rm(non.duplicates)
                            new.data.list[[source.files[index, file]]] <- new.data
                            source.files[index, ":=" (
                                    imported = TRUE,
                                    comment = MyUtilities::appendString(comment, "Duplicate dates within file removed!"))]
                        } else if (stringr::str_detect(names(new.data)[2], "^X[.][0-9]{1,2}")) {
                            source.files[index, skip := TRUE]
                        } else {
                            new.data.list[[source.files[index, file]]] <- new.data
                            rm(new.data)
                            source.files[index, imported := TRUE]
                        }
                    }, error = function(err) {
                        source.files[index, ":=" (
                                skip = TRUE,
                                comment = MyUtilities::appendString(comment, geterrmessage()))]
                    }, warning = function(warn) {
                        source.files[index, ":=" (
                                skip = TRUE,
                                comment = MyUtilities::appendString(comment, warn[["message"]]))]
                    }
                )
                # Skip files for which there is no mapping of columns to sensors yet
            }

            new.data.table <- data.table::rbindlist(new.data.list, use.names = TRUE, fill = FALSE)
            rm(new.data.list)

            if (nrow(new.data.table) > 0) {
                new.data.table <- remapSensorNames(.Object, long.l2.table = new.data.table)
                complete.table <- data.table::rbindlist(list(loadData(.Object), new.data.table), use.names = TRUE, fill = FALSE)
                data.table::setcolorder(complete.table, c("Plot", "SubPlot", "Logger", "variable"))
                data.table::setkey(complete.table, Plot, SubPlot, Logger, variable, Datum)

                # Drops duplicated rows (same Date and variable but maybe different value!)
                complete.table <- unique(complete.table, by = c("Datum", "variable"))
                saveData(.Object, data = complete.table)
            }
        }
        .Object
    }
)

#' resetToInitialization.R
setMethod("resetToInitialization", signature = "Logger", definition = function(.Object) {
        .Object <- callNextMethod(.Object)
        .Object@SourceFiles <- initialSourceFilesTable()
        .Object
    }
)
