########################################################################################################################
initialSourceFilesTable <- function() {
    source.files.table <- data.table::data.table(
        file = character(),
        path = factor(),
        imported = logical(),
        skip = logical(),
        comment = character())
    data.table::setkey(source.files.table, path, file)
    return(source.files.table)
}
