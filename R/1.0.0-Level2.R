########################################################################################################################
setClass(Class = "Level2",
         slots = c(
             LocalDirectory = "character",
             Plots = "list")
)

#' Constructor function for Level2 Object
#' @param local_directory Directory path where outputs and internal data are stored
Level2 <- function(local_directory) {
    .Object <- new("Level2")
    .Object@LocalDirectory <- local_directory
    .Object
}


########################################################################################################################
#' @include createAndAddPlot.R
setMethod("createAndAddPlot", signature = "Level2", definition = function(
    .Object,
    plot_name,
    corrected.aggregate.path) {

    plot_directory <- file.path(getLocalDirectory(.Object), plot_name)
    .Plot <- Plot(name = plot_name,
                  local_directory = plot_directory,
                  corrected.aggregate.path = corrected.aggregate.path)
    .Object <- addPlot(.Object, .Plot)
    .Object
})

#' @include addPlot.R
setMethod("addPlot", signature = "Level2", definition = function(.Object, .Plot) {
    assertthat::assert_that(is.Plot(.Plot))
    plot_name <- getName(.Plot)
    plot_list <- getPlotList(.Object)
    if (plot_name %in% names(plot_list)) {
        stop("Plot with the same name '", plot_name, "' already exists and would be overwritten")
    }
    plot_directory <- file.path(getLocalDirectory(.Object), plot_name)
    .Plot <- setLocalDirectory(.Plot, plot_directory)
    createDirectoryStructure(.Plot)
    plot_list[[plot_name]] <- .Plot
    .Object@Plots <- plot_list
    .Object
})

#' @include createAndAddMultipleSubPlots.R
setMethod("createAndAddMultipleSubPlots", signature = "Level2", definition = function(
    .Object,
    .PlotURI,
    sub_plot_names) {

    .TargetPlot <- getObjectByURI(.Object, .PlotURI)
    .TargetPlot <- createAndAddMultipleSubPlots(.TargetPlot, sub_plot_names = sub_plot_names)
    .Object <- replaceObjectByURI(.Object, .TargetPlot)

    .Object
})

#' @include createAndAddSubPlot.R
setMethod("createAndAddSubPlot", signature = "Level2", definition = function(.Object, sub_plot_name, .URI) {
    sub_plot_directory <- file.path(getLocalDirectory(.Object), sub_plot_name)
    .SubPlot <- SubPlot(name = sub_plot_name,
                    uri = .URI,
                    local_directory = sub_plot_directory)

    .Object <- addSubPlot(.Object, .SubPlot, .URI = .URI)
    .Object
})

#' @include addSubPlot.R
setMethod("addSubPlot", signature = "Level2", definition = function(.Object, .SubPlot, .URI) {
    if (!is.SubPlot(.SubPlot)) {
        stop("This method can only add objects of class 'SubPlot' to class 'Level2'!")
    }
    plot <- getPlotName(.URI)
    plot_directory <- file.path(getLocalDirectory(.Object), plot, getName(.SubPlot))
    .SubPlot <- setLocalDirectory(.SubPlot, plot_directory)
    createDirectoryStructure(.SubPlot)
    .Object <- applyToList(.Object,
                           apply_function = addSubPlot,
                           .SubPlot = .SubPlot,
                           subset_names = plot)
    .Object
})

#' @include createAndAddLogger.R
setMethod("createAndAddLogger", signature = "Level2", definition = function(
    .Object,
    logger_type,
    source_paths,
    .URI,
    unique_logger_name) {

    logger_name = dplyr::if_else(is.na(unique_logger_name), true = logger_type, false = as.character(unique_logger_name))
    logger_directory <- file.path(getLocalDirectory(.Object), getPlotName(.URI), getSubPlotName(.URI), logger_name)
    .Logger = new(logger_type,
                  unique_name = logger_name,
                  uri = .URI,
                  local_directory = logger_directory,
                  paths = source_paths)

    parent_uri <- Level2URI(dirname(as.character(.URI)))
    .Object <- addDataStructure(
        .Object,
        .DataStructure = .Logger,
        .URI = parent_uri)
    .Object
})

#' @include createAndAddAccessDBObject.R
setMethod("createAndAddAccessDBObject", signature = "Level2", definition = function(
    .Object,
    source_paths,
    .URI,
    table_name,
    date_column,
    unique_logger_name = NA) {

    object_name <- dplyr::if_else(condition = is.na(unique_logger_name),
                                  true = "AccessDB",
                                  false = as.character(unique_logger_name))
    local_directory <- file.path(getLocalDirectory(.Object), getPlotName(.URI), getSubPlotName(.URI), object_name)
    .AccessDB <- new("AccessDB",
                     unique_name = object_name,
                     uri = .URI,
                     local_directory = local_directory,
                     paths = source_paths,
                     table.name = table_name,
                     date.col = date_column)

    .Object <- addDataStructure(.Object, .AccessDB, .URI)
    .Object
})

#' @include addDataStructure.R
setMethod("addDataStructure", signature = "Level2", definition = function(.Object, .DataStructure, .URI) {
    if (!is.DataStructure(.DataStructure)) {
        stop("Passed paramter .DataStructure is not of class Logger")
    }
    sub_plot_uri <- .URI %>%
        as.character() %>%
        dirname() %>%
        Level2URI()
    .SubPlot <- getObjectByURI(
        .Object,
        level2_uri = sub_plot_uri)
    .SubPlot <- addDataStructure(.SubPlot, .DataStructure = .DataStructure, .URI = .URI)
    .Object <- replaceObjectByURI(.Object, .SubPlot)
    .Object
})

#' @include addSensorMapping.R
setMethod("addSensorMapping", signature = "Level2", definition = function(
    .Object,
    pattern,
    replacement,
    origin.date,
    .URI) {

    if (getURI_Depth(.URI) < 3) {
        stop("URI needs to contain a DataStructure to add a Sensor Mapping to")
    }
    .DataStructure <- getObjectByURI(.Object, .URI)
    .DataStructure <- addSensorMapping(.DataStructure, pattern = pattern, replacement = replacement)
    .Object <- replaceObjectByURI(.Object, .ReplacementObject = .DataStructure)
    .Object
})

#' @include replaceObjectByURI.R
setMethod("replaceObjectByURI", signature = "Level2", definition = function(.Object, .ReplacementObject) {
    .TargetURI <- getURI(.ReplacementObject)
    target_uri_level <- getURI_Depth(.TargetURI)
    if (target_uri_level == 0) {
        stop("Replacing Level2 by itself is not implemented")
    } else if (target_uri_level == 1) {
        # Replacement target is a Plot which is immediate part of Level2
        .ChangedPlot <- .ReplacementObject
    } else {
        # Replacement target is deeper within the hierarchy
        plot_uri <- getPlotName(.TargetURI) %>%
            Level2URI()
        .ChangedPlot <- getObjectByURI(.Object, plot_uri)
        .ChangedPlot <- replaceObjectByURI(.Object = .ChangedPlot, .ReplacementObject)
    }
    .Object <- replaceListObject(.Object, .ChangedPlot)
    .Object
})

#' @include replaceListObject.R
setMethod("replaceListObject", signature = "Level2", definition = function(.Object, .ListObject) {
    if (!is.Plot(.ListObject)) {
        stop(".ListObject has to be of class 'Plot'!")
    }
    existing_plot_names <- names(getPlotList(.Object))
    replacement_plot_name <- getName(.ListObject)
    if (!(replacement_plot_name %in% existing_plot_names)) {
        stop("Can't replace Plot with name ", replacement_plot_name, " because it is missing.")
    }
    .Object@Plots[[replacement_plot_name]] <- .ListObject
    .Object
})

########################################################################################################################
#' @include getName.R
setMethod("getName", signature = "Level2", definition = function(.Object) {
    as.character(class(.Object))
})

#' Return the list of Plots from an Level2 object
#'
#' @param .Object An Level2 object
#' @return A list of Plot objects
#' @include getPlotList.R
setMethod("getPlotList", signature = "Level2", definition = function(.Object) {
    return(.Object@Plots)
})

#' @include getLocalDirectory.R
setMethod("getLocalDirectory", signature = "Level2", definition = function(.Object) {
    return(.Object@LocalDirectory)
})

#' @include getOutputFile.R
setMethod("getOutputFile", signature = "Level2", definition = function(.Object) {
    return(paste0(getName(.Object), ".rds"))
})

#' @include getOutputDirectory.R
setMethod("getOutputDirectory", signature = "Level2", definition = function(.Object) {
    return(file.path("..", getLocalDirectory(.Object)))
})

#' @include getObjectByURI.R
setMethod("getObjectByURI", signature = "Level2", definition = function(.Object, level2_uri) {
    level2_uri <- Level2URI(level2_uri)
    getPlotList(.Object)[[getPlotName(level2_uri)]] %>%
        getObjectByURI(level2_uri)
})

#' @include getChildURIs.R
setMethod("getChildURIs", signature = "Level2", definition = function(.Object) {
    getPlotList(.Object) %>%
        purrr::map(~ getChildURIs(.x)) %>%
        purrr::flatten()
})

setGeneric(name = "expandURIPlaceholder", def = function(.Object, uri) {
    standardGeneric("expandURIPlaceholder")
})

setMethod("expandURIPlaceholder", signature = "Level2", definition = function(.Object, uri) {
    expand_plot <- getPlotName(uri) == "*"
    expand_sub_plot <- getSubPlotName(uri) == "*"
    expand_data_structure <- getDataStructureName(uri) == "*"
    if (expand_plot) {
        uri <- getPlotList(.Object) %>%
            purrr::map(~ {
                existing_subplots <- getSubPlotList(.x) %>%
                    names()
                if (getSubPlotName(uri) %in% c("", existing_subplots)) {
                    .x %>%
                        getName() %>%
                        Level2URI(getSubPlotName(uri), getDataStructureName(uri))
                }
            })
    }
    if (expand_sub_plot) {
        uri <- uri %>%
            purrr::map(~ {
                original_uri <- .x
                .x %>%
                    getPlotName() %>%
                    Level2URI() %>%
                    getObjectByURI(.Object, .) %>%
                    purrr::map(~ getSubPlotList(.x)) %>%
                    purrr::flatten() %>%
                    purrr::map(~ Level2URI(getPlotName(original_uri), getName(.x), getDataStructureName(original_uri)))
            }) %>%
            unlist()
    }
    if (expand_data_structure) {
        uri <- uri %>%
            purrr::map(~ {
                original_uri <- .x
                .x %>%
                    getSubPlotName() %>%
                    Level2URI(getPlotName(original_uri), .) %>%
                    getObjectByURI(.Object, .) %>%
                    purrr::map(~ getDataStructureList(.x)) %>%
                    purrr::flatten() %>%
                    purrr::map(~ Level2URI(getPlotName(original_uri), getSubPlotName(original_uri), getName(.x)))
            }) %>%
            unlist()
    }
    if (length(uri) == 1) {
        uri %>%
            list()
    } else {
        uri %>%
            unname() %>%
            purrr::discard(~ is.null(.x))
    }
})

########################################################################################################################
#' @include updateFilePaths.R
setMethod("updateFilePaths", signature = "Level2", definition = function(.Object) {
    .Object <- applyToList(.Object, updateFilePaths)
    .Object
})

#' Includes new data from Loggers
#'
#' Use this function if new data should be included from the defined locations and loggers
#'
#' @include updateData.R
#' @param .Object An S4 Object of type Level2
#' @param plot An optional string containing a plot name which is part of the .Object to only update this
#' @param sub.plot An optional string containing a sub.plot name to only update it. Needs \code{plot} to be defined
setMethod("updateData", signature = "Level2", definition = function(.Object, plot, sub.plot) {
    .Plots <- getPlotList(.Object)
    if (is.null(plot)) {
        plot.names = names(.Plots)
    } else {
        plot.names = plot
    }
    for(plot.name in plot.names) {
        .Plots[[plot.name]] <- updateData(.Object@Plots[[plot.name]], sub.plot = sub.plot)
    }
    .Object@Plots <- .Plots
    .Object
})

#' @include resetFailedImports.R
setMethod("resetFailedImports", signature = "Level2", definition = function(.Object) {
    .Object <- applyToList(.Object, resetFailedImports)
    .Object
})

#' @include resetToInitialization.R
setMethod("resetToInitialization", signature = "Level2", definition = function(.Object) {
    .Object <- applyToList(.Object, resetToInitialization)
    .Object
})

#' @include applyToList.R
setMethod("applyToList", signature = "Level2", definition = function(.Object, apply_function, ..., subset_names) {
    Plots <- getPlotList(.Object)
    if (!is.null(subset_names)) {
        subset_vector <- names(Plots) %in% subset_names
        Plots <- Plots[subset_vector]
        if (length(subset_names) != length(Plots)) {
            stop("Some subset_names have not been found in Plots")
        }
    }
    for (.Plot in Plots) {
        .Updated_Plot <- apply_function(.Plot, ...)
        .Object <- replaceListObject(.Object, .Updated_Plot)
    }
    .Object
})

#' @include saveL2Object.R
setMethod("saveL2Object", signature = "Level2", definition = function(.Object) {
    plot.dir <- getLocalDirectory(.Object)
    file.name <- getOutputFile(.Object)
    saveRDS(.Object, file = file.path(plot.dir, file.name))
    cat("Object '", file.name, "' created in '", plot.dir, "'\n", sep = "")
})

#' @include createDirectoryStructure.R
setMethod("createDirectoryStructure", signature = "Level2", definition = function(.Object) {
    plot.dir <- getLocalDirectory(.Object)
    dir.create(plot.dir, showWarnings = FALSE)
    applyToList(.Object, createDirectoryStructure)
    invisible(return(.Object))
})
