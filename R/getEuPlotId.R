########################################################################################################################
getEuPlotId <- function(plot.name, sub.plot.name) {
    plot.id.table <- data.table(
        plot = rep(c("Altensteig", "Conventwald", "Esslingen", "Heidelberg", "Ochsenhausen"), each = 2), 
        sub.plot = rep(c("Buche", "Fichte"), times = 5),
        id = c(859, 819, 856, 806, 862, 812, 852, 802, 858, 808))
    return(plot.id.table[plot == plot.name & sub.plot == sub.plot.name, id])
}