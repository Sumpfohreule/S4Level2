target.year <- 2019
data_path = "/home/polarfalke/Data/Temp/level2_0"
.Level2 <- loadL2Object(data_path)
no_sr_below_0 <- function(x) x %>% mutate(value = if_else(variable == "SR" & value < 0, true = 0, false = value))

.Level2 %>%
    getObjectByURI(Level2URI("Altensteig")) %>%
    getCorrectedAggregatePath() %>%
    file.path(target.year) %>%
    MyUtilities::getLastModifiedFile() %>%
    createMMFiles()

.Level2 %>%
    getObjectByURI(Level2URI("Conventwald")) %>%
    getCorrectedAggregatePath() %>%
    file.path(target.year) %>%
    MyUtilities::getLastModifiedFile() %>%
    createMMFiles(map_function = no_sr_below_0)

.Level2 %>%
    getObjectByURI(Level2URI("Esslingen")) %>%
    getCorrectedAggregatePath() %>%
    file.path(target.year) %>%
    MyUtilities::getLastModifiedFile() %>%
    createMMFiles()

.Level2 %>%
    getObjectByURI(Level2URI("Heidelberg")) %>%
    getCorrectedAggregatePath() %>%
    file.path(target.year) %>%
    MyUtilities::getLastModifiedFile() %>%
    createMMFiles()

.Level2 %>%
    getObjectByURI(Level2URI("Ochsenhausen")) %>%
    getCorrectedAggregatePath() %>%
    file.path(target.year) %>%
    MyUtilities::getLastModifiedFile() %>%
    createMMFiles()

xlsx.file = .Level2 %>%
    getObjectByURI(Level2URI("Rotenfels")) %>%
    getCorrectedAggregatePath() %>%
    file.path(target.year) %>%
    MyUtilities::getLastModifiedFile() %>%
    createMMFiles(sheets = c("Fichte", "Freiland"))

accumulateMMFiles(target.year, output.folder = file.path(getwd(), "data", "output"))
