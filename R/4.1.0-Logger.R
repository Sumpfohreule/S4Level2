########################################################################################################################
#' @include 0.0.0-Level2URI.R
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
})


########################################################################################################################
#' @include getSourceFilePattern.R
setMethod("getSourceFilePattern", signature = "Logger", definition = function(.Object) {
  return(.Object@SourceFilePattern)
})

#' @include getSourceFileTable.R
setMethod("getSourceFileTable", signature = "Logger", definition = function(.Object) {
  return(.Object@SourceFiles)
})

########################################################################################################################
setGeneric("setSourceFileTable", def = function(.Object, new_table) {
  standardGeneric("setSourceFileTable")
})

setMethod("setSourceFileTable", signature = "Logger", definition = function(.Object, new_table) {
  .Object@SourceFiles <- new_table
  .Object
})

#' @include saveData.R
setMethod("saveData", signature = "Logger", definition = function(.Object, data) {
  out.dir <- getLocalDirectory(.Object)
  dir.create(out.dir, showWarnings = FALSE)
  file.name <- getOutputFile(.Object)
  saveRDS(data, file = file.path(out.dir, file.name))
})

#' @include getLoggerData.R
setMethod("getLoggerData", signature = "Logger", definition = function(.Object, start.date, end.date) {
  data <- loadData(.Object)
  if (!is.null(data)) {
    data <- data %>%
      filter(Datum >= as.POSIXct(start.date, tz = "UTC")) %>%
      filter(Datum < as.POSIXct(end.date, tz = "UTC"))
  }
  return(data)
})

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
})

#' @include updateFilePaths.R
setMethod("updateFilePaths", signature = "Logger", definition = function(.Object) {
  current_table <- getSourceFileTable(.Object) %>%
    mutate(path = as.character(path))

  new_table <- .Object %>%
    getSourcePaths() %>%
    dir(full.names = TRUE, recursive = TRUE) %>%
    purrr::map_df(~ list(file = basename(.x), path = dirname(.x))) %>%
    filter(stringr::str_detect(file, pattern = getSourceFilePattern(.Object))) %>%
    data.table::as.data.table() %>%
    full_join(current_table, ., by = c("path", "file")) %>%
    mutate(across(imported | skip, ~ if_else(is.na(.x), FALSE, .x))) %>%
    arrange(path, file) %>%
    data.frame()
  .Object@SourceFiles <- new_table
  .Object
})


#' @include updateData.R
setMethod("updateData", signature = "Logger", definition = function(.Object) {
  source_file_table <- getSourceFileTable(.Object)
  new_files <- source_file_table %>%
    mutate(index = row_number()) %>%
    filter(FALSE == (imported | skip))

  if (nrow(new_files) > 0) {
    new.data.list <- list()
    applied_import <- new_files %>%
      purrr::pmap(~ with(list(...), file.path(path, file))) %>%
      purrr::map(~ .importOrLogError(.Object, .x))
    error_on_import <- applied_import %>%
      purrr::map_lgl(is.character)
    error_map_indices <- new_files[error_on_import, "index"]

    source_file_table[error_map_indices, "skip"] <- TRUE
    source_file_table[error_map_indices, "comment"] <- applied_import %>%
      purrr::keep(error_on_import) %>%
      unlist()

    data_map_indices <- new_files[!error_on_import, "index"]
    source_file_table[data_map_indices, "imported"] <- TRUE
    .Object@SourceFiles <- source_file_table

    new_data <- applied_import %>%
      purrr::keep(!error_on_import) %>%
      data.table::rbindlist(use.names = TRUE, fill = FALSE)

    if (nrow(new_data) > 0) {
      .Object %>%
        remapSensorNames(new_data) %>%
        list(loadData(.Object), .) %>%
        data.table::rbindlist(use.names = TRUE, fill = FALSE) %>%
        data.table::setcolorder(c("Plot", "SubPlot", "Logger", "variable")) %>%
        data.table::setkey(Plot, SubPlot, Logger, variable, Datum) %>%
        unique(by = c("Datum", "variable")) %>%
        saveData(.Object, data = .)
    }
  }
  .Object
})

.importOrLogError <- function(.Object, path) {
  tryCatch({
    new.data <- importRawLoggerFile(.Object, path) %>%
      mutate_at(vars(-Datum), na_if, y = 9999) %>%
      mutate_at(vars(-Datum), na_if, y = -9999) %>%
      group_by(variable) %>%
      distinct(Datum, .keep_all = TRUE) %>%
      filter_at(vars(-Datum), any_vars(!is.na(.))) %>%
      mutate(Plot = as.factor(getPlotName(.Object))) %>%
      mutate(SubPlot = as.factor(getSubPlotName(.Object))) %>%
      mutate(Logger = as.factor(getName(.Object))) %>%
      data.table::as.data.table()

    all_dates_na <- new.data %>%
      pull(Datum) %>%
      unique() %>%
      is.na() %>%
      all()

    if (all_dates_na) {
      stop("Date column was not imported correctly (Only NA's)")
    }
    return(new.data)
  },
  error = function(err) {
    closeAllConnections()
    return(geterrmessage())
  }, warning = function(w) {
    closeAllConnections()
    return(w[["message"]])
  })
}

#' @include resetFailedImports.R
setMethod("resetFailedImports", signature = "Logger", definition = function(.Object) {
  .Object <- getSourceFileTable(.Object) %>%
    mutate(skip = FALSE) %>%
    mutate(comment = "") %>%
    setSourceFileTable(.Object, .)
  .Object
})

#' resetToInitialization.R
setMethod("resetToInitialization", signature = "Logger", definition = function(.Object) {
  .Object <- callNextMethod(.Object)
  .Object@SourceFiles <- initialSourceFilesTable()
  .Object
})
