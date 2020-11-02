########################################################################################################################
getEuPlotId <- function(plot.name, sub.plot.name) {
    eu_plot_map <- data.frame(
        plot = rep(c("Altensteig", "Conventwald", "Esslingen", "Heidelberg", "Ochsenhausen", "Rotenfels"), each = 2),
        sub.plot = rep(c("Buche", "Fichte"), times = 6),
        id = c(859, 819, 856, 806, 862, 812, 852, 802, 858, 808, NA, 801))

    if (!(plot.name %in% eu_plot_map[, "plot"])) {
        stop(sprintf("Für den anggegebene Plot '%s' existieren keine Eu Ids", plot.name))
    } else if (!(sub.plot.name %in% eu_plot_map[, "sub.plot"])) {
        stop(sprintf("Für den anggegebene SubPlot '%s' existieren keine Eu Ids", sub.plot.name))
    }
    eu_plot_map %>%
        filter(plot == plot.name) %>%
        filter(sub.plot == sub.plot.name) %>%
        pull(id) %>%
        purrr::walk(~ if (is.na(.x)) {
                stop(sprintf("Plot '%s' hat keien Eu Id für den SubPlot '%s'", plot.name, sub.plot.name))
            })
}
