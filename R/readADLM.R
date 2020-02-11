########################################################################################################################
# TODO: Include check if first row is strings
readADLM <- function(path) {
    in.table <- as.data.table(read.xlsx(path))
    in.table <- in.table[-1]
    for (col.name in names(in.table)) {
        in.table[, (col.name) := as.numeric(get(col.name))]
    }
    in.table[, Datum := as.POSIXctFixed(Datum * 60 * 60 * 24, tz = "UTC",
            origin = "1899-12-30")]
    in.table[, Datum := roundPOSIXct(Datum, 60)]
    setkey(in.table, Datum)
    return(in.table)
}
