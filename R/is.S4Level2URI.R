########################################################################################################################
is.Level2URI <- function(x) {
    is_object_an_uri <- inherits(x, "Level2URI")
    return(is_object_an_uri)
}
