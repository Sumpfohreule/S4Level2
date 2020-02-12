########################################################################################################################
setGeneric("createAggregateExcel", def = function(.Object,
        year,
        round.times = FALSE,
        empty.column.table = data.table(sheet = character(), columns = character())) {
        standardGeneric("createAggregateExcel")
    }
)
