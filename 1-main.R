setwd("O:/TRANSP/IsenbergLars/Projekte/S4Level2")
rm(list = ls(all.names = TRUE))
source("init.R")

#source("0-initial_plot_setup.R")
.Level2 <- loadL2Object()
#.Level2 <- resetToInitialization(loadL2Object())
.Level2 <- updateFilePaths(.Level2)
.Level2 <- updateData(.Level2)
saveL2Object(.Level2)


# FIXME: change Name attribute for all classes to more informative names!
# FIXME: remove tryCatch and related stuff from createAggregateExcel and replace with summary/message of missing columns
# FIXME: make an update with only error-files possible
# FIXME: make it possible to excempt loggers from createAggregateExcel
# FIXME: make it possible to exclude single files or time frames from a logger with a comment (with subsequent Data removal)

# TODO: export Excel-Template functionality to its own package and import afterwards
# TODO: replace generic methods like applyToList with more specific once (applyToPlotList, applyToSubPlotList)
# to remove strange intial values by null
# TODO: remove .S4Level2.PATH constant from all methods
# TODO: keep data and source file information consistent! (e.g re-initializing plots but not resetting data)
# TODO: remove name Level2 as it is not needed (return class name instead if needed)
# TODO: Try to replace calculated columns with (protected) excel-formulas
# TODO: stop throwing error for missing columns in createAggregateExcel -> print a "report" instead
# TODO: Check logger name within raw files if existing (e.g. DeltaT)
# TODO: maybe add all files (change pattern) (.xlsx) but set not useable to skip (_ed)?
# TODO: Package the Project
# TODO: create "facade" of functions to hide implementation
# TODO: split variable columns into sensor, position and vertical!
# TODO: create function for data saving for flexible testing/usage. Maybe split saves up or use database
# TODO: create a summary function to give an overview over the objects
# TODO: check if date_time rounding should not be done at import!


########################################################################################################################
# Altensteig
at.data <- getData(loadL2Object("Altensteig"),
    start.date = "2018-01-01",
    end.date = "2019-01-01",
    as.wide.table = TRUE)
at.data[SubPlot == "Freiland"]

at.data[, analyzeDateGaps(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]
at.data[, calculateDateCompleteness(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]

createAggregateExcel(
    .Object = loadL2Object("Altensteig"),
    year = 2019)


########################################################################################################################
# Conventwald
co.data <- getData(loadL2Object("Conventwald"),
    start.date = "2018-01-01",
    end.date = "2019-01-01",
    as.wide.table = TRUE)

co.data[, analyzeDateGaps(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]
co.data[, calculateDateCompleteness(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]

createAggregateExcel(
    .Object = loadL2Object("Conventwald"),
    year = 2019)


########################################################################################################################
# Esslingen
es.data <- getData(loadL2Object("Esslingen"),
    start.date = "2018-01-01",
    end.date = "2019-01-01",
    as.wide.table = TRUE)

es.data[, analyzeDateGaps(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]
es.data[, calculateDateCompleteness(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]

# TODO: Update 2019 TinyTag data (Some files to convert on M:/Bu-Labor/Lars_Temp)
# TODO: Update Bu DeltaT 2019 (Jan/Feb, Mai, August/September)
# TODO: Update Fi Envilog 2019 (Mai - September)
createAggregateExcel(
    .Object = loadL2Object("Esslingen"),
    year = 2019)


########################################################################################################################
# Heidelberg
hd.data <- getData(loadL2Object("Heidelberg"),
    start.date = "2018-01-01",
    end.date = "2019-01-01",
    as.wide.table = TRUE)
hd.data[, analyzeDateGaps(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]
hd.data[, calculateDateCompleteness(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]

# TODO: HD BU ADLM auf Sicherheitsauslese warten (ab 18.06.2019 keine Daten)
# FIXME: HD BU DeltaT fehlende Daten (10.09.2019)

createAggregateExcel(
    .Object = loadL2Object("Heidelberg"),
    year = 2019)


########################################################################################################################
# Ochsenhausen
oc.data <- getData(loadL2Object("Ochsenhausen"),
    start.date = "2018-01-01",
    end.date = "2019-01-01",
    as.wide.table = FALSE)

oc.data[, calculateDateCompleteness(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]
oc.data[, analyzeDateGaps(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]

createAggregateExcel(
    .Object = loadL2Object("Ochsenhausen"),
    year = 2019)


########################################################################################################################
# Rotenfels
ro.data <- getData(.Object = loadL2Object("Rotenfels"),
    start.date = "2018-01-01",
    end.date = "2019-01-01",
    as.wide.table = TRUE)

ro.data[, calculateDateCompleteness(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]
ro.data[, analyzeDateGaps(unique(Datum), extend.to.full.year = TRUE), by = .(Plot, SubPlot, Logger)]

# TODO RO Fi DeltaT Daten

createAggregateExcel(
    .Object = loadL2Object("Rotenfels"),
    year = 2019,
    round.times = FALSE)


