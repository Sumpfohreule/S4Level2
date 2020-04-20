########################################################################################################################
#' @export Level2
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
    }
)

#' @include addPlot.R
setMethod("addPlot", signature = "Level2", definition = function(.Object, .Plot) {
        if (!is.Plot(.Plot))
            stop("Can only add objects of class 'Plot' to class 'Level2'!")
        plot_directory <- file.path(getLocalDirectory(.Object), getName(.Plot))
        .Plot <- setLocalDirectory(.Plot, plot_directory)
        .Object@Plots[[getName(.Plot)]] <- .Plot
        .Object
    }
)

#' @include createAndAddMultipleSubPlots.R
setMethod("createAndAddMultipleSubPlots", signature = "Level2", definition = function(.Object,
        .PlotURI,
        sub_plot_names) {

        .TargetPlot <- getPlot(.Object, .PlotURI)
        .TargetPlot <- createAndAddMultipleSubPlots(.TargetPlot, sub_plot_names = sub_plot_names)
        .Object <- replaceObjectByURI(.Object, .TargetPlot)

        .Object
    }
)

#' @include createAndAddSubPlot.R
setMethod("createAndAddSubPlot", signature = "Level2", definition = function(.Object, sub_plot_name, .URI) {
		sub_plot_directory <- file.path(getLocalDirectory(.Object), sub_plot_name)
        .SubPlot <- new("SubPlot",
            name = sub_plot_name,
            uri = .URI,
            local_directory = sub_plot_directory)

        .Object <- addSubPlot(.Object, .SubPlot, .URI = .URI)
        .Object
    }
)

#' @include addSubPlot.R
setMethod("addSubPlot", signature = "Level2", definition = function(.Object, .SubPlot, .URI) {
        if (!is.SubPlot(.SubPlot)) {
            stop("This method can only add objects of class 'SubPlot' to class 'Level2'!")
        }
        plot <- getPlotName(.URI)
        plot_directory <- file.path(getLocalDirectory(.Object), plot, getName(.SubPlot))
        .SubPlot <- setLocalDirectory(.SubPlot, plot_directory)

        .Object <- applyToList(.Object,
            apply_function = addSubPlot,
            .SubPlot = .SubPlot,
            subset_names = plot)
        .Object
    }
)

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

        .Object <- addDataStructure(.Object, .DataStructure = .Logger, .URI)
        .Object
    }
)

#' @include createAndAddAccessDBObject.R
setMethod("createAndAddAccessDBObject", signature = "Level2", definition = function(.Object,
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
    }
)

#' @include addDataStructure.R
setMethod("addDataStructure", signature = "Level2", definition = function(.Object, .DataStructure, .URI) {
        if (!is.DataStructure(.DataStructure)) {
            stop("Passed paramter .DataStructure is not of class Logger")
        }
        .SubPlot <- getSubPlot(.Object, .URI)
        .SubPlot <- addDataStructure(.SubPlot, .DataStructure = .DataStructure, .URI = .URI)
        .Object <- replaceObjectByURI(.Object, .SubPlot)
        .Object
    }
)

#' @include addSensorMapping.R
setMethod("addSensorMapping", signature = "Level2", definition = function(.Object,
        pattern,
        replacement,
        origin.date,
        .URI) {

        if (getURI_Depth(.URI) < 3) {
            stop("URI needs to contain a DataStructure to add a Sensor Mapping to")
        }
        .DataStructure <- getDataStructure(.Object, .URI)
        .DataStructure <- addSensorMapping(.DataStructure, pattern = pattern, replacement = replacement)

        .Object <- replaceObjectByURI(.Object, .DataStructure)
        .Object
    }
)

#' @include replaceObjectByURI.R
setMethod("replaceObjectByURI", signature = "Level2", definition = function(.Object, .ReplacementObject) {
		.TargetURI <- getURI(.ReplacementObject)
        target_uri_level <- getURI_Depth(.TargetURI)
        if (target_uri_level == 0) {
            stop("Replacing Level2 by itself is not implemented yet")
        } else if (target_uri_level == 1) {
            # Replacement target is a Plot which is immediate part of Level2
            .ChangedPlot <- .ReplacementObject
        } else {
            # Replacement target is deeper within the hierarchy
            .ChangedPlot <- getPlot(.Object, .TargetURI)
            .ChangedPlot <- replaceObjectByURI(.ChangedPlot, .ReplacementObject)
        }
        .Object <- replaceListObject(.Object, .ChangedPlot)
        .Object
    }
)

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
    }
)

########################################################################################################################
#' @include getName.R
setMethod("getName", signature = "Level2", definition = function(.Object) {
        as.character(class(.Object))
    }
)

#' @include getPlot.R
setMethod("getPlot", signature = "Level2", definition = function(.Object, .URI) {
        plot_name <- getPlotName(.URI)
        .Plot <- getPlotList(.Object)[[plot_name]]
        .Plot
    }
)

#' @include getPlotList.R
setMethod("getPlotList", signature = "Level2", definition = function(.Object) {
        return(.Object@Plots)
    }
)

#' @include getSubPlot.R
setMethod("getSubPlot", signature = "Level2", definition = function(.Object, .URI) {
        .Plot <- getPlot(.Object, .URI)
        .SubPlot <- getSubPlot(.Plot, .URI)
        .SubPlot
    }
)

#' @include getDataStructure.R
setMethod("getDataStructure", signature = "Level2", definition = function(.Object, .URI) {
        Plots <- getPlotList(.Object)
        plot = getPlotName(.URI)
        if (!plot %in% names(Plots))
            stop(sprintf("Plot '%s' is not contained within the Level2 Object", plot))
        data <- getDataStructure(Plots[[plot]], .URI = .URI)
        return(data)
    }
)

#' @include getLocalDirectory.R
setMethod("getLocalDirectory", signature = "Level2", definition = function(.Object) {
        return(.Object@LocalDirectory)
    }
)

#' @include getOutputFile.R
setMethod("getOutputFile", signature = "Level2", definition = function(.Object) {
        return(paste0(getName(.Object), ".rds"))
    }
)

#' @include getOutputDirectory.R
setMethod("getOutputDirectory", signature = "Level2", definition = function(.Object) {
    return(file.path("..", getLocalDirectory(.Object)))
})


########################################################################################################################
#' @include getData.R
setMethod("getData", signature = "Level2", definition = function(
        .Object,
        start.date,
        end.date,
        plot,
        sub.plot,
        logger.name,
        as.wide.table) {
        Plots <- getPlotList(.Object)
        if (length(Plots) > 0) {
            list <- list()
            if (!is.null(plot)) {
                Plots <- Plots[plot]
            }
            for (.Plot in Plots) {
                list[[getName(.Plot)]] <- getData(
                    .Object = .Plot,
                    start.date = start.date,
                    end.date = end.date,
                    sub.plot = sub.plot,
                    logger.name = logger.name)
            }
            data <- data.table::rbindlist(list)
            rm(list)
            data.table::setkey(data, Plot, SubPlot, Logger, variable, Datum)
            if (as.wide.table) {
                data <- data.table::dcast(data, Plot + SubPlot + Logger + Datum ~ variable)
            }
            return(data)
        } else {
            return(NULL)
        }
    }
)

#' @include updateFilePaths.R
setMethod("updateFilePaths", signature = "Level2", definition = function(.Object) {
        .Object <- applyToList(.Object, updateFilePaths)
        .Object
    }
)

#' Includes new data from Loggers
#'
#' Use this function if new data should be included from the defined locations and loggers
#'
#' @include updateData.R
#' @param .Object An S4 Object of type Level2
#' @param plot An optional string containing a plot name which is part of the .Object to only update this
#' @param sub.plot An optional string containing a sub.plot name to only update it. Needs \code{plot} to be defined
#' @export
setMethod("updateData", signature = "Level2", definition = function(.Object, plot, sub.plot) {
        .Plots <- getPlotList(.Object)
        if (is.null(plot)) {
            plot.names = names(.Plots)
        } else {
            plot.names = plot
        }
        for(plot.name in plot.names) {
            .Plots[[plot.name]] <- updateData(.Object@Plots[[plot.name]], sub.plot)
        }
        .Object
    }
)

#' @include resetToInitialization.R
setMethod("resetToInitialization", signature = "Level2", definition = function(.Object) {
        .Plots <- getPlotList(.Object)
        .Object <- applyToList(.Object, resetToInitialization)
        .Object
    }
)

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
    }
)

#' @include saveL2Object.R
setMethod("saveL2Object", signature = "Level2", definition = function(.Object) {
        createDirectoryStructure(.Object)

        plot.dir <- getLocalDirectory(.Object)
        file.name <- getOutputFile(.Object)
        saveRDS(.Object, file = file.path(plot.dir, file.name))
        cat("Object '", file.name, "' created in '", plot.dir, "'\n", sep = "")
    }
)

#' @include createDirectoryStructure.R
setMethod("createDirectoryStructure", signature = "Level2", definition = function(.Object) {
        plot.dir <- getLocalDirectory(.Object)
        dir.create(plot.dir, showWarnings = FALSE)
        applyToList(.Object, createDirectoryStructure)
        invisible(return(.Object))
    }
)
