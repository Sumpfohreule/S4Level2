########################################################################################################################
is.Level2URI <- function(x) {
    is_level2_uri <- inherits(x, "Level2URI")
    return(is_level2_uri)
}

#' @export
assertthat::on_failure(is.Level2URI) <- function(call, env) {
    paste0(deparse(call$x), " is not a Level2URI")
}
