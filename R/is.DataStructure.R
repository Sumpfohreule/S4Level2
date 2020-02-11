########################################################################################################################
is.DataStructure <- function(x) {
    is_DataStructure <- inherits(x, what = "DataStructure")
    return(is_DataStructure)
}
