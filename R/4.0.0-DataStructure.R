########################################################################################################################
#' @include 0.0.0-Level2URI.R
#' @include data.table_setOldClass.R
#' @export DataStructure
#' @exportClass DataStructure
DataStructure <- setClass("DataStructure", slots = c(
        UniqueName = "character",
        Level2URI = "Level2URI",
        LocalDirectory = "character",
        SourcePaths = "character",
        SensorMappings = "data.table")
)

setMethod("initialize", signature = "DataStructure", definition = function(
                .Object,
                unique_name,
                uri,
                local_directory,
                paths) {
      .Object@UniqueName <- unique_name
      .Object@Level2URI <- uri
      .Object <- setLocalDirectory(.Object, local_directory)
      .Object <- setSourcePaths(.Object, paths)
      .Object <- setSensorMappings(.Object, initializeSensorMappings())
      .Object
    }
)


########################################################################################################################
#' @include setLocalDirectory.R
setMethod("setLocalDirectory", signature = "DataStructure", definition = function(.Object, local_directory) {
		.Object@LocalDirectory <- local_directory
        .Object
    }
)

#' @include setSourcePaths.R
setMethod("setSourcePaths", signature = "DataStructure", definition = function(.Object, paths) {
        for (path in paths) {
            if (!file.exists(path)) {
                stop(paste0("The path '", paths, "' does not exists"))
            }
        }
        .Object@SourcePaths = paths
        .Object
    }
)

#' @include addSensorMapping.R
setMethod("addSensorMapping", signature = "DataStructure", definition = function(
        .Object,
        pattern,
        replacement,
        origin.date) {

        stringr::str_replace("", pattern, replacement) # Early testing of for syntax errors
        new_sensor_mapping <- list(pattern, replacement, as.POSIXct(origin.date, tz = "UTC"))
        combined_sensor_mapping <- data.table::rbindlist(list(getSensorMappings(.Object), new_sensor_mapping))
        .Object <- setSensorMappings(.Object, unique(combined_sensor_mapping))
        .Object
    }
)

#' @include setSensorMappings.R
setMethod("setSensorMappings", signature = "DataStructure", definition = function(.Object, sensor_mapping_table) {
        .Object@SensorMappings <- sensor_mapping_table
        return(.Object)
    }
)

########################################################################################################################
#' @include getName.R
setMethod("getName", signature = "DataStructure", definition = function(.Object) {
        .Object@UniqueName
    }
)

#' @include getPlotName.R
setMethod("getPlotName", signature = "DataStructure", definition = function(.Object) {
        return(getPlotName(.Object@Level2URI))
    }
)

#' @include getURI.R
setMethod("getURI", signature = "DataStructure", definition = function(.Object) {
        .Object@Level2URI
    }
)

#' @include getSourcePaths.R
setMethod("getSourcePaths", signature = "DataStructure", definition = function(.Object) {
        return(.Object@SourcePaths)
    }
)

#' @include getSubPlotName.R
setMethod("getSubPlotName", signature = "DataStructure", definition = function(.Object) {
        return(getSubPlotName(.Object@Level2URI))
    }
)

#' @include getSensorMappings.R
setMethod("getSensorMappings", signature = "DataStructure", definition = function(.Object) {
        return(.Object@SensorMappings)
    }
)

#' @include getLocalDirectory.R
setMethod("getLocalDirectory", signature = "DataStructure", definition = function(.Object) {
        return(.Object@LocalDirectory)
    }
)

#' @include getOutputFile.R
setMethod("getOutputFile", signature = "DataStructure", definition = function(.Object) {
        return(paste0(getName(.Object), ".rds"))
    }
)


########################################################################################################################
#' @include createDirectoryStructure.R
setMethod("createDirectoryStructure", signature = "DataStructure", definition = function(.Object) {
        data_structure_directory <- getLocalDirectory(.Object)
        dir.create(data_structure_directory, showWarnings = FALSE)

        invisible(return(.Object))
    }
)

#' @include remapSensorNames.R
setMethod("remapSensorNames", signature = "DataStructure", definition = function(.Object, long.l2.table) {
        mappings <- getSensorMappings(.Object)
        if (nrow(mappings) > 0) {
            for (mapping.index in 1 : nrow(mappings)) {
                min.date <- mappings[mapping.index, origin.date]
                if (min.date == as.POSIXct("1900-01-01", tz = "UTC")) {
                    long.l2.table[,
                        variable := MyUtilities::remapLevels(variable,
                            pattern = mappings[mapping.index, patterns],
                            replacement = mappings[mapping.index, replacements])]
                } else {
                    long.l2.table[Datum >= min.date,
                        variable := MyUtilities::remapLevels(variable,
                            pattern = mappings[mapping.index, patterns],
                            replacement = mappings[mapping.index, replacements])]
                    long.l2.table[, variable := factor(as.character(variable))]
                }
            }
        }
        return(long.l2.table)
    }
)

#' @include resetToInitialization.R
setMethod("resetToInitialization", signature = "DataStructure", definition = function(.Object) {
        out.dir <- getLocalDirectory(.Object)
        file.name <- getOutputFile(.Object)
        if (file.exists(file.path(out.dir, file.name))) {
            file.remove(file.path(out.dir, file.name))
        }
        .Object
    }
)
