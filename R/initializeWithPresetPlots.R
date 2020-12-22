#' Setup function for plot configurations
#'
#' Needs update if Level2 data folders are renamed or move
#'
#' @param preset_id String containing one of the preset ids (FVA_O_TRANSP)
#' @export
initializeWithPresetPlots <- function(preset_id = "FVA_O_TRANSP") {
    preset_path <- system.file("extdata", "plot_xml", preset_id, package = "S4Level2", mustWork = TRUE)
    initializePlotsFromXml(loadL2Object(), preset_path)
}