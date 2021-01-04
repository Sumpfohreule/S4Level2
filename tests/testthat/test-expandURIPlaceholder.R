test_that("Expanding an URI returns it unchanged", {
    uri_paths <- c("Al/Fi/ADLM", "Al/Bu/ADLM", "Co/Fi/ADLM", "Co/Bu/ADLM", "Co/Bu/DeltaT", "Co/Bu/AccessDB", "Ro/Fi/ADLM")
    test_struct <- .createDummyLevel2ObjectStructure(uri_paths)

    uri <- Level2URI("Al/Fi/ADLM")
    expect_equal(expandURIPlaceholder(test_struct, uri), list(uri))

})


