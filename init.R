########################################################################################################################
source("libraries.R")
.S4Level2.PATH <- "O:/TRANSP/IsenbergLars/Projekte/S4Level2"
 memory.limit(4000)

# load all project and utility classes, methods and functions
for (file in dir(file.path(.S4Level2.PATH, "R"),
    pattern = ".R",
    full.names = TRUE,
    recursive = TRUE)) {
    source(file)
}
rm(file)
