test_that("Expanding a normal URI returns it unchanged", {
    uri_paths <- c("Al/Fi/ADLM", "Al/Bu/ADLM", "Co/Fi/ADLM", "Co/Bu/ADLM", "Co/Bu/DeltaT", "Co/Bu/AccessDB", "Ro/Fi/ADLM")
    test_struct <- .createDummyLevel2ObjectStructure(uri_paths)

    uri <- Level2URI("Al/Fi/ADLM")
    expect_equal(expandURIPlaceholder(test_struct, uri), list(uri))
})


test_that("Expanding plot in an URI returns only plot uri paths", {
    uri_paths <- c("Al/Fi/ADLM", "Al/Bu/ADLM", "Co/Fi/ADLM", "Co/Bu/ADLM", "Co/Bu/DeltaT", "Co/Bu/AccessDB", "Ro/Fi/ADLM")
    test_struct <- .createDummyLevel2ObjectStructure(uri_paths)

    uri <- Level2URI("*")
    expect_equal(expandURIPlaceholder(test_struct, uri), as.Level2URI(c("Al", "Co", "Ro")))
})

test_that("Expanding plot in an URI with subplot returns all existing plot/subplot URIs", {
    uri_paths <- c("Al/Fi/ADLM", "Al/Bu/ADLM", "Co/Fi/ADLM", "Co/Bu/ADLM", "Co/Bu/DeltaT", "Co/Bu/AccessDB", "Ro/Fi/ADLM")
    test_struct <- .createDummyLevel2ObjectStructure(uri_paths)

    uri <- Level2URI("*/Bu")
    expect_equal(expandURIPlaceholder(test_struct, uri), as.Level2URI(c("Al/Bu", "Co/Bu")))
})

test_that("Expanding plot in an URI with full path returns all existing plot/subplot/logger URIs", {
    uri_paths <- c("Al/Fi/ADLM", "Al/Bu/ADLM", "Co/Fi/ADLM", "Co/Bu/ADLM", "Co/Bu/DeltaT", "Co/Bu/AccessDB", "Ro/Fi/ADLM")
    test_struct <- .createDummyLevel2ObjectStructure(uri_paths)

    uri <- Level2URI("*/Fi/ADLM")
    expect_equal(expandURIPlaceholder(test_struct, uri), as.Level2URI(c("Al/Fi/ADLM", "Co/Fi/ADLM", "Ro/Fi/ADLM")))
})

test_that("Expansion works at the second level, without expanding third level", {
    uri_paths <- c("Al/Fi/ADLM", "Al/Bu/ADLM", "Co/Fi/ADLM", "Co/Bu/ADLM", "Co/Bu/DeltaT", "Co/Bu/AccessDB", "Ro/Fi/ADLM")
    test_struct <- .createDummyLevel2ObjectStructure(uri_paths)

    uri <- Level2URI("Al/*")
    expect_equal(expandURIPlaceholder(test_struct, uri), as.Level2URI(c("Al/Fi", "Al/Bu")))
})

test_that("Expansion works at the third level", {
    uri_paths <- c("Al/Fi/ADLM", "Al/Bu/ADLM", "Co/Fi/ADLM", "Co/Bu/ADLM", "Co/Bu/DeltaT", "Co/Bu/AccessDB", "Ro/Fi/ADLM")
    test_struct <- .createDummyLevel2ObjectStructure(uri_paths)

    uri <- Level2URI("Co/Bu/*")
    expect_equal(expandURIPlaceholder(test_struct, uri), as.Level2URI(c("Co/Bu/ADLM", "Co/Bu/DeltaT")))
})

test_that("Expansion works at the first and third level with the middle beeing fixed", {
    uri_paths <- c("Al/Fi/ADLM", "Al/Bu/ADLM", "Co/Fi/ADLM", "Co/Bu/ADLM", "Co/Bu/DeltaT", "Co/Bu/AccessDB", "Ro/Fi/ADLM")
    test_struct <- .createDummyLevel2ObjectStructure(uri_paths)

    uri <- Level2URI("*/Fi/*")
    expect_equal(expandURIPlaceholder(test_struct, uri), as.Level2URI(c("Al/Fi/ADLM", "Co/Fi/ADLM", "Ro/Fi/ADLM")))
})