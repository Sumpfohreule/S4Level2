########################################################################################################################
importAggregateData <- function(xlsx.file) {
    full.data.list <- list()
    for (sub.plot.type in c("Buche", "Fichte", "Freiland")) {
        tryCatch({
                sub.plot.table <- as.data.table(
                    read.xlsx(xlsx.file,
                        sheet = sub.plot.type,
                        startRow = 3,
                        colNames = FALSE,
                        skipEmptyCols = FALSE
                    )
                )
                column.names <- names(read.xlsx(xlsx.file, sheet = sub.plot.type, rows = 1))[1:ncol(sub.plot.table)]
                setnames(sub.plot.table, column.names)
                sub.plot.table[, Datum := as.POSIXctFixed(Datum * 60 * 60 * 24, origin = "1899-12-30", tz = "UTC")]
                sub.plot.table[, Datum := roundPOSIXct(Datum,
                        in.seconds = 5 * 60,
                        round.fun = round)]
                long.sub.plot.table <- melt(sub.plot.table, id.vars = "Datum")
                long.sub.plot.table[, SubPlot := as.factor(sub.plot.type)]
                full.data.list[[sub.plot.type]] <- long.sub.plot.table
            }, error = function(e) {
                message <- geterrmessage(e)
                if (!str_detect(message, "Cannot find sheet named"))
                    stop(e)
            }
        )
    }
    return(rbindlist(full.data.list))
}
