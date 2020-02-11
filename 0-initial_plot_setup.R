########################################################################################################################
# This scripts needs to be run the first time this project is used or changes to plot setup files were made.
# Afterwards updateFilePaths and updateData need to be run again for the changes to take place
setwd("O:/TRANSP/IsenbergLars/Projekte/S4Level2")
source("init.R")
local_directory <- file.path(getwd(), "Data", "structure")
level2 <- new("Level2", local_directory)
saveL2Object(level2)

for(plot.init.file in dir("plot_setup_files", full.names = TRUE)) {
    source(plot.init.file)
}

rm(local_directory, plot.init.file)
