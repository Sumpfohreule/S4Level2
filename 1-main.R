data_location <- "/home/polarfalke/Data/Temp/level2_2"
# level2 <- initializePlotsFromXml(level2, "/home/polarfalke/Data/Temp/level2/")

# data_location <- "w:/level2"
# initializeDefaultPlots(data_location)

# resetDataLocation(data_location)

level2 <- loadL2Object(data_location)
# level2 <- resetToInitialization(level2)
level2 <- updateFilePaths(level2)
level2 <- updateData(level2)
saveL2Object(level2)

# FIXME: save linux configs somewhere!
# TODO: convert RUnit Tests to testthat
# TODO: Make use of AccessDB LastImportDate or remove it and its setter
# TODO: create function to add data to an already aggregated excel where files where missing before (dont overwrite manual changes)
# TODO: Replace getDataStructure, getSubPlot getPlot with a unified Method using Level2URI
# TODO: Check logger name within raw files if existing (e.g. DeltaT)
# TODO: create function for data saving for flexible testing/usage. Maybe split saves up or use database
# TODO: create a summary function to give an overview over the objects
# TODO: maybe add all files (change pattern) (.xlsx) but set not useable to skip (_ed)?
# TODO: Try to replace calculated columns with (protected) excel-formulas (PR SUM and PF values)
# TODO: split variable columns into sensor, position and vertical!
# TODO: make updateFilePaths print some info about added files

# FIXME: change Name attribute for all classes to more informative names!
# FIXME: remove tryCatch and related stuff from createAggregateExcel and replace with summary/message of missing columns
# FIXME: make it possible to excempt loggers from createAggregateExcel
# FIXME: make it possible to exclude single files or time frames from a logger with a comment (with subsequent Data removal)

# TODO: Start specifying public interface for this package
# TODO: remove date_time rounding at import and reimplement on data export where needed!
# TODO: export Excel-Template functionality to its own package and import afterwards
# TODO: replace generic methods like applyToList with more specific once (applyToPlotList, applyToSubPlotList)
# to remove strange intial values by null
# TODO: keep data and source file information consistent! (e.g re-initializing plots but not resetting data)
# TODO: stop throwing error for missing columns in createAggregateExcel -> print a "report" instead
# TODO: Test where overproviding data for getDataForYear was necessary and solve problem
# TODO: make an update with only error-files possible


########################################################################################################################
# Altensteig
at_plot <- level2 %>%
    getPlot(Level2URI("Altensteig")) %>%
    getDataForYear(2019) %>%
    as.data.table()

at.data[, MyUtilities::analyzeDateGaps(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]
at.data[, MyUtilities::calculateDateCompleteness(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]

level2 %>% getPlot(Level2URI("Altensteig")) %>%
    createAggregateExcel(year = 2019)


########################################################################################################################
# Conventwald
co_data <- level2 %>%
    getPlot("Conventwald") %>%
    getDataForYear(2019) %>%
    as.data.table()

co.data[, MyUtilities::analyzeDateGaps(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]
co.data[, MyUtilities::calculateDateCompleteness(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]

level2 %>% getPlot(Level2URI("Conventwald")) %>%
    createAggregateExcel(year = 2019)


########################################################################################################################
# Esslingen
es_data <- level2 %>%
    getPlot("Esslingen") %>%
    getDataForYear(2019) %>%
    as.data.table()

es_data[, MyUtilities::analyzeDateGaps(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]
es_data[, MyUtilities::calculateDateCompleteness(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]

level2 %>% getPlot(Level2URI("Esslingen")) %>%
    createAggregateExcel(year = 2019)


########################################################################################################################
# Heidelberg
hd.data <- level2 %>%
    getPlot("Heidelberg") %>%
    getDataForYear(2019) %>%
    as.data.table()

hd.data[, MyUtilities::analyzeDateGaps(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]
hd.data[, MyUtilities::calculateDateCompleteness(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]

level2 %>% getPlot("Heidelberg") %>%
    createAggregateExcel(year = 2019)


########################################################################################################################
# Ochsenhausen
oc.data <- level2 %>%
    getPlot("Ochsenhausen") %>%
    getDataForYear(2019) %>%
    as.data.table()

oc.data[, MyUtilities::calculateDateCompleteness(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]
oc.data[, MyUtilities::analyzeDateGaps(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]

level2 %>% getPlot(Level2URI("Ochsenhausen")) %>%
    createAggregateExcel(year = 2019)


########################################################################################################################
# Rotenfels
ro.data <- level2 %>%
    getPlot("Rotenfels") %>%
    getDataForYear(2019) %>%
    as.data.table()

ro.data[, MyUtilities::calculateDateCompleteness(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]
ro.data[, MyUtilities::analyzeDateGaps(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]

# TODO RO Fi DeltaT Daten

level2 %>% getPlot(Level2URI("Rotenfels")) %>%
    getDataForYear(2019) %>%
    mutate(value = if_else(
        condition = (variable == "Niederschlag.Casella" &
                    Datum <= as.POSIXct("2019-04-03", tz = "UTC")),
        true = value * 2,
        false = value)) %>%
    createAggregateExcel(year = 2019,
                         round.times = FALSE)
