########################################################################################################################
#' @include 0.0.0-Level2URI.R
setClass("SubPlot", slots = c(
    Name = "character",
    Level2URI = "Level2URI",
    LocalDirectory = "character",
    Loggers = "list"
))

SubPlot <- function(name, uri, local_directory) {
    .Object <- new("SubPlot")
    .Object@Name <- name
    .Object@Level2URI = Level2URI(getPlotName(uri), getSubPlotName(uri))
    .Object@LocalDirectory <- local_directory
    .Object
}


########################################################################################################################
#' @include addDataStructure.R
setMethod("addDataStructure", signature = "SubPlot", definition = function(.Object, .DataStructure) {
    if (!is.DataStructure(.DataStructure)) {
        "Parameter .DataStructure is not of class Logger"
    }

    already.included <- FALSE
    for (.ExistingLogger in .Object@Loggers) {
        already.included <- getName(.ExistingLogger) == getName(.DataStructure)
        if (already.included) {
            stop("Logger to be added has the same name as an existing one in specified subplot")
        }
    }

    data_structure_directory <- file.path(getLocalDirectory(.Object), getName(.DataStructure))
    .DataStructure <- setLocalDirectory(.DataStructure, data_structure_directory)

    .Object@Loggers[[getName(.DataStructure)]] <- .DataStructure
    .Object
})

#' @include setLocalDirectory.R
setMethod("setLocalDirectory", signature = "SubPlot", definition = function(.Object, local_directory) {
    .Object@LocalDirectory <- local_directory
    .Object
})

#' @include replaceListObject.R
setMethod("replaceListObject", signature = "SubPlot", definition = function(.Object, .ListObject) {
    if (!is.DataStructure(.ListObject)) {
        stop(".ListObject has to be of class 'DataStructure'!")
    }
    existing_data_structure_names <- names(getDataStructureList(.Object))
    replacement_data_structure_name <- getName(.ListObject)
    if (!(replacement_data_structure_name %in% existing_data_structure_names)) {
        stop("Can't replace Plot with name ", replacement_data_structure_name, " because it is missing.")
    }
    .Object@Loggers[[replacement_data_structure_name]] <- .ListObject
    .Object
})

#' @include replaceObjectByURI.R
setMethod("replaceObjectByURI", signature = "SubPlot", definition = function(.Object, .ReplacementObject) {
    .TargetURI <- getURI(.ReplacementObject)
    target_uri_level <- getURI_Depth(.TargetURI)
    if (target_uri_level == 2) {
        stop("Replacing Plot by itself is not implemented yet")
    } else if (target_uri_level == 3) {
        # Replacement target is a SubPlot which is immediate part of Plot
        .ChangedDataStructure <- .ReplacementObject
    }
    .Object <- replaceListObject(.Object, .ChangedDataStructure)
    .Object
})

########################################################################################################################
#' @include getName.R
setMethod("getName", signature = "SubPlot", definition = function(.Object) {
    .Object@Name
})

#' @include getURI.R
setMethod("getURI", signature = "SubPlot", definition = function(.Object) {
    .Object@Level2URI
})

#' @include getLocalDirectory.R
setMethod("getLocalDirectory", signature = "SubPlot", definition = function(.Object) {
    return(.Object@LocalDirectory)
})

#' @include getDataStructureList.R
setMethod("getDataStructureList", signature = "SubPlot", definition = function(.Object) {
    return(.Object@Loggers)
})

#' @include getDataStructure.R
setMethod("getDataStructure", signature = "SubPlot", definition = function(.Object, .Level2URI) {
    logger = getDataStructureName(.Level2URI)
    if (!logger %in% names(.Object@Loggers))
        stop(sprintf("Logger '%s' is not contained within Subplot '%s'", logger, getName(.Object)))
    .Logger <- .Object@Loggers[[logger]]
    return(.Logger)
})

#' @include getSourceFileTable.R
setMethod("getSourceFileTable", signature = "SubPlot", definition = function(.Object) {
    list <- list()
    for (.Logger in .Object@Loggers) {
        logger.name <- getName(.Logger)
        source.table <- getSourceFileTable(.Logger)
        source.table[, logger := as.factor(logger.name)]
        list[[logger.name]] <- source.table
    }
    return(data.table::rbindlist(list))
})

#' @include getObjectByURI.R
setMethod("getObjectByURI", signature = "SubPlot", definition = function(.Object, level2_uri) {
    level2_uri <- Level2URI(level2_uri)
    uri_depth <- getURI_Depth(level2_uri)
    if (uri_depth < 2) {
        stop("Provided level2_uri has a depth of less than 1, so it can't be contained in a SubPlot or below.\nURI: ", level2_uri)
    } else if (uri_depth > 2) {
        # data_structure_name <- getDataStructureName(level2_uri)
        data_structure <- getDataStructure(.Object, level2_uri)
        lower_object <- getObjectByURI(data_structure, level2_uri)
        return(lower_object)
    } else if (getSubPlotName(level2_uri) != getName(.Object)) {
        stop("Can't get this Object of type SubPlot (Depth = 1) with the given URI because of different names.\nURI: ", level2_uri)
    } else {
        return(.Object)
    }
})

#' @include getChildURIs.R
setMethod("getChildURIs", signature = "SubPlot", definition = function(.Object) {
    getDataStructureList(.Object) %>%
        purrr::map(~ getURI(.x))
})

########################################################################################################################
#' @include createDirectoryStructure.R
setMethod("createDirectoryStructure", signature = "SubPlot", definition = function(.Object) {
    sub_plot_directory <- getLocalDirectory(.Object)
    dir.create(sub_plot_directory, showWarnings = FALSE)

    applyToList(.Object, createDirectoryStructure)
    invisible(return(.Object))
})

#' @include updateFilePaths.R
setMethod("updateFilePaths", signature = "SubPlot", definition = function(.Object) {
    for(logger.name in names(.Object@Loggers)) {
        .Object@Loggers[[logger.name]] <- updateFilePaths(.Object@Loggers[[logger.name]])
    }
    .Object
})

#' @include updateData.R
setMethod("updateData", signature = "SubPlot", definition = function(.Object) {
    for(logger.name in names(.Object@Loggers)) {
        .Object@Loggers[[logger.name]] <- updateData(.Object@Loggers[[logger.name]])
    }
    .Object
})

#' @include resetFailedImports.R
setMethod("resetFailedImports", signature = "SubPlot", definition = function(.Object) {
    .Object <- applyToList(.Object, resetFailedImports)
    .Object
})

#' @include resetToInitialization.R
setMethod("resetToInitialization", signature = "SubPlot", definition = function(.Object) {
    for(logger.name in names(.Object@Loggers)) {
        .Object@Loggers[[logger.name]] <- resetToInitialization(.Object@Loggers[[logger.name]])
    }
    .Object
})

#' @include applyToList.R
setMethod("applyToList", signature = "SubPlot", definition = function(.Object, apply_function, ..., subset_names) {
    DataStructureList <- getDataStructureList(.Object)
    if (!is.null(subset_names)) {
        subset_vector <- names(DataStructureList) %in% subset_names
        DataStructureList <- DataStructureList[subset_vector]
        if (length(subset_names) != length(DataStructureList)) {
            stop("Some subset_names have not been found in Plots")
        }
    }
    for (.DataStructure in DataStructureList) {
        .Updated_DataStructure <- apply_function(.DataStructure, ...)
        .Object <- replaceListObject(.Object, .Updated_DataStructure)
    }
    .Object
})

