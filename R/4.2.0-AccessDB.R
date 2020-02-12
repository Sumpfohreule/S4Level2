########################################################################################################################
#' @include URI.R
setClass("AccessDB", contains = "DataStructure", slots = c(
        DB_Table_Name = "character",
        Date_Column = "character",
        Last_Import_Date = "POSIXct"))

setMethod("initialize", signature = "AccessDB", definition = function(.Object,
        unique_name = class(.Object),
        uri,
        local_directory,
        paths,
        table.name,
        date.col) {

      .Object <- callNextMethod(.Object,
          unique_name = unique_name,
          uri = uri,
          local_directory = local_directory,
          paths = paths)

      .Object@DB_Table_Name = table.name
      .Object@Date_Column = date.col
      .Object <- setLastImportDate(.Object, as.POSIXct(NA))
      .Object
    }
)


########################################################################################################################
#' @include setLastImportDate.R
setMethod("setLastImportDate", signature = "AccessDB", definition = function(.Object, posixct_date) {
        if (!is.POSIXct(posixct_date)) {
            stop("posixct_date is not of class POSIXct")
        }
        .Object@Last_Import_Date <- posixct_date
        .Object
    }
)


########################################################################################################################
#' @include getData.R
setMethod("getData", signature = "AccessDB", definition = function(.Object, start.date, end.date) {
        directory <- getLocalDirectory(.Object)
        file.name <- getOutputFile(.Object)
        out.table <- readRDS(file.path(directory, file.name))
        if (!is.null(out.table)) {
            out.table <- out.table[Datum >= as.POSIXct(start.date, tz = "UTC") &
                    Datum < as.POSIXct(end.date, tz = "UTC")]
        }
        return(out.table)
    }
)


########################################################################################################################
#' @include updateFilePaths.R
setMethod("updateFilePaths", signature = "AccessDB", definition = function(.Object) {
        # "Empty" method as data is already contained in a single dabase
        .Object
    }
)

#' @include updateData.R
setMethod("updateData", signature = "AccessDB", definition = function(.Object) {
        db.path <- getSourcePaths(.Object)
        if (length(db.path) > 1)
            stop("updateData for AccessDB is not constructed with multiple SourcePaths in mind")
        sql.query <- sprintf("'SELECT * FROM %1$s'", .Object@DB_Table_Name, .Object@Date_Column)
        out.dir <- getLocalDirectory(.Object)
        file.name <- getOutputFile(.Object)
        dir.create(out.dir, showWarnings = FALSE)
        date.column <- "Dat_Zeit"
        access32BitQuery(db.path,
            sql.query = sql.query,
            date.col = date.column,
            out.file = file.path(out.dir, file.name))
        access.data <- readRDS(file.path(out.dir, file.name))
        access.data[, Proto_Dat := NULL]
        flag.cols <- na.omit(str_match(names(access.data), "^x_.*"))
        value.cols <- setdiff(names(access.data), c(date.column, flag.cols))
        access.long <- melt(access.data,
            id.vars = date.column,
            measure.vars = value.cols)
        access.long <- access.long[!is.na(value)]
        access.long[, ":=" (
                Plot = as.factor(getPlotName(.Object)),
                SubPlot = as.factor(getSubPlotName(.Object)),
                Logger = as.factor(getName(.Object)))]
        key.columns <- c("Plot", "SubPlot", "Logger", "variable", date.column)
        setcolorder(access.long, key.columns)
        setkeyv(access.long, key.columns)
        setnames(access.long, date.column, "Datum")
        access.long <- remapSensorNames(.Object, long.l2.table = access.long)

        saveRDS(access.long, file.path(out.dir, file.name))
        cat("File '", file.name, "' saved in location '", out.dir, "'\n", sep = "")
        .Object
    }
)

#' @include resetToInitialization.R
setMethod("resetToInitialization", signature = "AccessDB", definition = function(.Object) {
        .Object <- callNextMethod(.Object)
        .Object <- setLastImportDate(.Object, as.POSIXct(NA))
        .Object
    }
)