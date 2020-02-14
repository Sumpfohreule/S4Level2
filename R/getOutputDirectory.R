########################################################################################################################
setGeneric("getOutputDirectory", def = function(.Object) {
        standardGeneric("getOutputDirectory")
    }
)

# setMethod("getOutputDirectory", signature = "missing", definition = function() {
#         return(file.path(.S4Level2.PATH, "Data/output"))
#     }
# )
