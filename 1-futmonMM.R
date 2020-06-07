########################################################################################################################
devtools::load_all()

########################################################################################################################
target.year <- 2019
data_path = "/home/polarfalke/Data/Temp/level2"
.Level2 <- loadL2Object(data_path)

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
    createMMFiles()
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

accumulateMMFiles(target.year, file.path(getwd(), "Data", "output"))
