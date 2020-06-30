########################################################################################################################
# TODO: Include check if first row is strings
readADLM <- function(path) {
    in.table <- data.table::as.data.table(openxlsx::read.xlsx(path))
    in.table <- in.table[-1]
    for (col.name in names(in.table)) {
        in.table[, (col.name) := as.numeric(get(col.name))]
    }
    in.table[, Datum := MyUtilities::as.POSIXctFixed(Datum * 60 * 60 * 24, tz = "UTC",
            origin = "1899-12-30")]
    in.table[, Datum := lubridate::round_date(Datum, "1 mins")]
    data.table::setkey(in.table, Datum)
    return(in.table)
}
