########################################################################################################################
#' @include 0.0.0-Level2URI.R
setClass(Class = "Plot", slots = c(
    Name = "character",
    Level2URI = "Level2URI",
    LocalDirectory = "character",
    CorrectedAggregatePath = "character",
    SubPlots = "list"
))

Plot <- function(name,
                 local_directory,
                 corrected.aggregate.path) {
    .Object <- new("Plot")
    .Object@Name <- name
    .Object@LocalDirectory = local_directory
    .Object@Level2URI = Level2URI(name)
    .Object <- setCorrectedAggregatePath(.Object, corrected.aggregate.path)
    .Object
}


########################################################################################################################
#' @include setCorrectedAggregatePath.R
setMethod("setCorrectedAggregatePath", signature = "Plot", definition = function(.Object, corrected.aggregate.path) {
    if (!dir.exists(corrected.aggregate.path))
        stop("Provided path for aggregated and corrected output data does not exist\n'",
             corrected.aggregate.path, "'")
    .Object@CorrectedAggregatePath = corrected.aggregate.path
    .Object
})

#' @include setLocalDirectory.R
setMethod("setLocalDirectory", signature = "Plot", definition = function(.Object, local_directory) {
    .Object@LocalDirectory <- local_directory
    .Object
})

#' @include createAndAddMultipleSubPlots.R
setMethod("createAndAddMultipleSubPlots", signature = "Plot", definition = function(.Object, sub_plot_names) {
    plot_name <- getPlotName(getURI(.Object))
    plot_directory <- getLocalDirectory(.Object)
    for (sub_plot_name in sub_plot_names) {
        sub_plot_uri <- Level2URI(file.path(plot_name, sub_plot_name))
        sub_plot_directory = file.path(plot_directory, sub_plot_name)
        .SubPlot <- new("SubPlot", name = sub_plot_name, uri = sub_plot_uri, local_directory = sub_plot_directory)
        .Object <- addSubPlot(.Object, .SubPlot)
    }
    .Object
})

#' @include addSubPlot.R
setMethod("addSubPlot", signature = "Plot", definition = function(.Object, .SubPlot) {
    sub_plot_name <- getName(.SubPlot)
    if (class(.SubPlot) != "SubPlot") {
        stop("'.SubPlot' needs to be of type SubPlot, however is of type: ", class(.SubPlot))
    } else if (sub_plot_name %in% names(.Object@SubPlots)) {
        stop("Can't add SubPlot '", sub_plot_name, "' as it already exists.")
    }
    sub_plot_directory <- file.path(getLocalDirectory(.Object), getName(.SubPlot))
    .SubPlot <- setLocalDirectory(.SubPlot, sub_plot_directory)

    .Object@SubPlots[[sub_plot_name]] <- .SubPlot
    .Object
})

#' @include replaceObjectByURI.R
setMethod("replaceObjectByURI", signature = "Plot", definition = function(.Object, .ReplacementObject) {
    .TargetURI <- getURI(.ReplacementObject)
    target_uri_level <- getURI_Depth(.TargetURI)
    if (target_uri_level == 1) {
        stop("Replacing Plot by itself is not implemented yet")
    } else if (target_uri_level == 2) {
        # Replacement target is a SubPlot which is immediate part of Plot
        .ChangedSubPlot <- .ReplacementObject
    } else {
        # Replacement target is deeper within the hierarchy
        sub_plot_uri <- .TargetURI %>%
            getSubPlotName() %>%
            Level2URI(getName(.Object), .)
        .ChangedSubPlot <- getObjectByURI(.Object, sub_plot_uri)
        .ChangedSubPlot <- replaceObjectByURI(.ChangedSubPlot, .ReplacementObject)
    }
    .Object <- replaceListObject(.Object, .ChangedSubPlot)
    .Object
})

#' @include replaceListObject.R
setMethod("replaceListObject", signature = "Plot", definition = function(.Object, .ListObject) {
    if (!is.SubPlot(.ListObject)) {
        stop(".ListObject has to be of class 'SubPlot'!")
    }
    existing_plot_names <- names(getSubPlotList(.Object))
    replacement_sub_plot_name <- getName(.ListObject)
    if (!(replacement_sub_plot_name %in% existing_plot_names)) {
        stop("Can't replace Plot with name ", replacement_sub_plot_name, " because it is missing.")
    }
    .Object@SubPlots[[replacement_sub_plot_name]] <- .ListObject
    .Object
})

#' @include addDataStructure.R
setMethod("addDataStructure", signature = "Plot", definition = function(.Object, .DataStructure, .URI) {
    if (!is.DataStructure(.DataStructure)) {
        stop("Paramter .DataStructure is not of class DataStructure")
    }
    sub.plot <- getSubPlotName(.URI)
    if (!(sub.plot %in% names(.Object@SubPlots))) {
        stop("Provided sub.plot '", sub.plot, "' has not been initialized as one of this plots SubPlot!")
    }
    .Object@SubPlots[[sub.plot]] <- addDataStructure(.Object@SubPlots[[sub.plot]], .DataStructure = .DataStructure)
    .Object
})


########################################################################################################################
#' @include getName.R
setMethod("getName", signature = "Plot", definition = function(.Object) {
    .Object@Name
})

#' @include getURI.R
setMethod("getURI", signature = "Plot", definition = function(.Object) {
    .Object@Level2URI
})

#' @include getLocalDirectory.R
setMethod("getLocalDirectory", signature = "Plot", definition = function(.Object) {
    saved_local_directory <- .Object@LocalDirectory
    return(saved_local_directory)
})

#' @include getOutputDirectory.R
setMethod("getOutputDirectory", signature = "Plot", definition = function(.Object) {
    plot_name <- getName(.Object)
    output_directory <- getLocalDirectory(.Object) %>%
        file.path("../..", plot_name)
    return(output_directory)
})

#' @include getCorrectedAggregatePath.R
setMethod("getCorrectedAggregatePath", signature = "Plot", definition = function(.Object) {
    .Object@CorrectedAggregatePath
})

#' @include getSubPlotList.R
setMethod("getSubPlotList", signature = "Plot", definition = function(.Object) {
    .Object@SubPlots
})

#' @include getObjectByURI.R
setMethod("getObjectByURI", signature = "Plot", definition = function(.Object, level2_uri) {
    level2_uri <- Level2URI(level2_uri)
    uri_depth <- getURI_Depth(level2_uri)
    if (uri_depth < 1) {
        stop("Provided level2_uri has a depth of less than 1, so it can't be contained in a Plot or below.\nURI: ", level2_uri)
    } else if (uri_depth > 1) {
        sub_plot_name <- getSubPlotName(level2_uri)
        selected_sub_plot <- getSubPlotList(.Object)[[sub_plot_name]]
        lower_object <- getObjectByURI(.Object = selected_sub_plot, level2_uri)
        return(lower_object)
    } else if (getPlotName(level2_uri) != getName(.Object)) {
        stop("Can't get this Object of type Plot (Depth = 1) with the given URI because of different names.\nURI: ", level2_uri)
    } else {
        return(.Object)
    }
})


########################################################################################################################
setGeneric("loadCorrectedData", def = function(.Object, sheet_names, years = NULL) {
    standardGeneric("loadCorrectedData")
})

#' Load the data of corrected files from predefined folders of this plot
#' @param sheet_names String vector to determine which kind of SubPlot should be loaded from each file
#' @param years Numeric vector of years to load from the plot corrected files
#' @return A data.table with all the data combined
setMethod("loadCorrectedData", signature = "Plot", definition = function(.Object, sheet_names, years) {
    full_data <- .Object %>%
        getCorrectedAggregatePath() %>%
        dir(full.names = TRUE) %>%
        purrr::keep(~ is.null(years) || (TRUE %in% (basename(.x) %in% as.character(years)))) %>%
        purrr::map(~ {
            path <- .x
            sheet_names %>%
                purrr::map(~ c(path, .x))
            }) %>%
        purrr::flatten() %>%
        purrr::map(~ {
            tryCatch({
                path <- .x[1]
                sheet <- .x[2]
                wide_import <- MyUtilities::getLastModifiedFile(
                    folder = path,
                    pattern = "\\.xlsx$",
                    recursive = TRUE) %>%
                    MyUtilities::importAggregateExcelSheet(sheet)
                wide_import %>%
                    data.table::setnames(make.unique(names(wide_import))) %>%
                    tidyr::pivot_longer(cols = -Datum, names_to = "variable") %>%
                    mutate(SubPlot = sheet)
            }, error = function(e) {
                if (stringr::str_detect(as.character(e), "Values from 'sheet' are not contained in")) {
                    cat("Skipped file '", basename(.x), "' for sheet '", sheet_names, "' as it was missing.\n", sep = "")
                } else {
                    stop(e)
                }
            })
        }) %>%
        bind_rows() %>%
        mutate_at(vars(SubPlot), as.factor) %>%
        arrange(SubPlot, variable, Datum) %>%
        select(SubPlot, Datum, variable, value)
    return(full_data)
})

#' @include updateFilePaths.R
setMethod("updateFilePaths", signature = "Plot", definition = function(.Object) {
    for(sub.plot.name in names(.Object@SubPlots)) {
        .Object@SubPlots[[sub.plot.name]] <- updateFilePaths(.Object@SubPlots[[sub.plot.name]])
    }
    .Object
})

#' @include updateData.R
setMethod("updateData", signature = "Plot", definition = function(.Object, sub.plot) {
    if (is.null(sub.plot)) {
        sub.plot.names <- names(.Object@SubPlots)
    } else {
        sub.plot.names <- sub.plot
    }
    for(sub.plot.name in sub.plot.names) {
        .Object@SubPlots[[sub.plot.name]] <- updateData(.Object@SubPlots[[sub.plot.name]])
    }
    .Object
})

#' @include createDirectoryStructure.R
setMethod("createDirectoryStructure", signature = "Plot", definition = function(.Object) {
    plot.dir <- getLocalDirectory(.Object)
    dir.create(plot.dir, showWarnings = FALSE)
    output_directory <- getOutputDirectory(.Object)
    dir.create(output_directory)

    applyToList(.Object, createDirectoryStructure)
    invisible(return(.Object))
})

#' @include resetFailedImports.R
setMethod("resetFailedImports", signature = "Plot", definition = function(.Object) {
    .Object <- applyToList(.Object, resetFailedImports)
    .Object
})

#' @include resetToInitialization.R
setMethod("resetToInitialization", signature = "Plot", definition = function(.Object) {
    .Object <- applyToList(.Object, apply_function = resetToInitialization)
    .Object
})

#' @include applyToList.R
setMethod("applyToList", signature = "Plot", definition = function(.Object, apply_function, ..., subset_names) {
    SubPlots <- getSubPlotList(.Object)
    if (!is.null(subset_names)) {
        subset_vector <- names(SubPlots) %in% subset_names
        SubPlots <- SubPlots[subset_vector]
        if (length(subset_names) != length(SubPlots)) {
            stop("Some subset_names have not been found in Plots")
        }
    }
    for (.SubPlot in SubPlots) {
        .Updated_Plot <- apply_function(.SubPlot, ...)
        .Object <- replaceListObject(.Object, .Updated_Plot)
    }
    .Object
})

#' @include getSourceFileTable.R
setMethod("getSourceFileTable", signature = "Plot", definition = function(.Object) {
    list <- list()
    for (.SubPlot in .Object@SubPlots) {
        sub.plot.name <- getName(.SubPlot)
        source.table <- getSourceFileTable(.SubPlot)
        source.table[, sub.plot := as.factor(sub.plot.name)]
        list[[sub.plot.name]] <- source.table
    }
    merged.list <- data.table::rbindlist(list)
    data.table::setkey(merged.list, sub.plot, logger, path, file)
    return(merged.list)
})
