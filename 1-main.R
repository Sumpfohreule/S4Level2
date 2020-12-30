# connectToExistingDataLocation("/home/polarfalke/Data/Temp/level2")
updateDatabase()
# resetDataLocation(data_location)
# level2 <- resetToInitialization(level2)
# level2 <- resetFailedImports(level2)

output_path <- "/home/polarfalke/Data/Nextcloud/Arbeit/FVA/O/PROJEKT/NIEDER/Logger/"
# output_path <- "W:/Nextcloud"

# FIXME: melt.data.table warning with new AccessDB (Co Freiland)
# FIXME: Combining two loggers (Conventwald Freiland ADLM + AccessDB) breaks Datetimes!
# FIXME: Check why variable is not of type factor before SensorMapping!

# TODO: Find slow parts in code and consider replacing with data.table
#   TODO: Probably better to replace regex for remapping with literal replacements
# TODO: summary of all source/target variables for each subplot
# TODO: consider adding selection on updateDatabase or remove it from updateData
# TODO: Think about what functionalities could be better split up from this package
# TODO: Try to replace calculated columns with (protected) excel-formulas (PR SUM and PF values)
# TODO: Use saved constants instead loading data or "Magic Numbers"
# TODO: Use any and all instead of "TRUE %in% (... %in% ...)" checks
# TODO: create function to add data to an already aggregated excel where files where missing before (don't overwrite manual changes)
# TODO: Make use of AccessDB LastImportDate or remove it and its setter
# TODO: updateInitialization function for added loggers etc.
# TODO: create a summary function to give an overview over the objects
# TODO: convert RUnit Tests to testthat
# TODO: Check logger name within raw files if existing (e.g. DeltaT)
# TODO: create function for data saving for flexible testing/usage. Maybe split saves up or use database
# TODO: maybe add all files (change pattern) (.xlsx) but set not usable to skip (_ed)?
# TODO: split variable columns into sensor, position and vertical!
# TODO: make updateFilePaths print some info about added files
# TODO: change Name attribute for all classes to more informative names!
# TODO: make it possible to exclude single files or time frames from a logger with a comment (with subsequent Data removal)
# TODO: remove date_time rounding at import and reimplement on data export where needed!
# TODO: replace generic methods like applyToList with more specific once (applyToPlotList, applyToSubPlotList)
# to remove strange initial values by null (Error prone!)
# TODO: keep data and source file information consistent! (e.g re-initializing plots but not resetting data) -> database
# TODO: Test where over providing data for getDataForYear was necessary and solve problem

# TODO: change getData and getDataForYear to only internally use Level2 object
# TODO: remove createAggregateExcel
# TODO: remove functions used for cumsum columns which are exported to new package
# - deleteDataLocation -> Only data.location files (if others print) and remove path variable
# - getData
# - getDataForYear
# - updateData

########################################################################################################################
# Altensteig
at_data <- loadL2Object() %>%
    getObjectByURI(Level2URI("Altensteig")) %>%
    getDataForYear(2020) %>%
    as.data.table()

at_data[, MyUtilities::analyzeDateGaps(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]
at_data[, MyUtilities::calculateDateCompleteness(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]


########################################################################################################################
# Conventwald
co_data <- loadL2Object() %>%
    getObjectByURI("Conventwald") %>%
    getDataForYear(2019) %>%
    as.data.table()

co_data[, MyUtilities::analyzeDateGaps(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]
co_data[, MyUtilities::calculateDateCompleteness(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]


########################################################################################################################
# Esslingen
es_data <- loadL2Object() %>%
    getObjectByURI("Esslingen") %>%
    getDataForYear(2020) %>%
    as.data.table()

es_data[, MyUtilities::analyzeDateGaps(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]
es_data[, MyUtilities::calculateDateCompleteness(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]


########################################################################################################################
# Heidelberg
hd_data <- loadL2Object() %>%
    getObjectByURI("Heidelberg") %>%
    getDataForYear(2020) %>%
    as.data.table()

hd_data[, MyUtilities::analyzeDateGaps(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]
hd_data[, MyUtilities::calculateDateCompleteness(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]


########################################################################################################################
# Ochsenhausen
oc_data <- loadL2Object() %>%
    getObjectByURI("Ochsenhausen") %>%
    getDataForYear(2020) %>%
    as.data.table()

oc_data[, MyUtilities::analyzeDateGaps(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]
oc_data[, MyUtilities::calculateDateCompleteness(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]


########################################################################################################################
# Rotenfels
ro_data <- loadL2Object() %>%
    getObjectByURI("Rotenfels") %>%
    getDataForYear(2020) %>%
    as.data.table()
ro_data[, MyUtilities::analyzeDateGaps(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]
ro_data[, MyUtilities::calculateDateCompleteness(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]


