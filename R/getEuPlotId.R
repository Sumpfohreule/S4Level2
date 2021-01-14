########################################################################################################################
getEuPlotId <- function(plot.name, sub.plot.name) {
    if (!(plot.name %in% PLOT_IDS[, "plot"])) {
        stop(sprintf("Für den anggegebene Plot '%s' existieren keine Eu Ids", plot.name))
    } else if (!(sub.plot.name %in% PLOT_IDS[, "sub.plot"])) {
        stop(sprintf("Für den anggegebene SubPlot '%s' existieren keine Eu Ids", sub.plot.name))
    }
    PLOT_IDS %>%
        filter(plot == plot.name) %>%
        filter(sub.plot == sub.plot.name) %>%
        pull(id) %>%
        purrr::walk(~ if (is.na(.x)) {
                stop(sprintf("Plot '%s' hat keien Eu Id für den SubPlot '%s'", plot.name, sub.plot.name))
            })
}
