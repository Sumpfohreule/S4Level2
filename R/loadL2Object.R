########################################################################################################################
loadL2Object <- function(plot.name = NULL) {
  plot.dir <- file.path(.S4Level2.PATH, "Data/structure")
  tryCatch(.Object <- readRDS(file = file.path(plot.dir, "Level2.rds")), 
      error = function(e) {
        stop("'", plot.name, "' does not seem to exist. Either initialize the Object (new(...)) or correct the path ",
            "(setwd(...) or plot name.")
      }
  )
  if (!is.null(plot.name)) {
      if (!(plot.name %in% names(getPlotList(.Object))))
          stop("The plot with the name '", plot.name, "' has not been initialized.\n",
              "  Check spelling and plot_setup_files")
      .Object <- getPlotList(.Object)[[plot.name]]
  }
  return(.Object)
}
