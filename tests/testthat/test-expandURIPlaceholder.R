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
    expect_equal(expandURIPlaceholder(test_struct, uri), as.Level2URI(c("Co/Bu/ADLM", "Co/Bu/DeltaT", "Co/Bu/AccessDB")))
})

test_that("Expansion works at the first and third level with the middle beeing fixed", {
    uri_paths <- c("Al/Fi/ADLM", "Al/Bu/ADLM", "Co/Fi/ADLM", "Co/Bu/ADLM", "Co/Bu/DeltaT", "Co/Bu/AccessDB", "Ro/Fi/ADLM")
    test_struct <- .createDummyLevel2ObjectStructure(uri_paths)

    uri <- Level2URI("*/Fi/*")
    expect_equal(expandURIPlaceholder(test_struct, uri), as.Level2URI(c("Al/Fi/ADLM", "Co/Fi/ADLM", "Ro/Fi/ADLM")))
})

test_that("Can expand the first two levels each", {
    uri_paths <- c("Al/Fi/ADLM", "Al/Bu/ADLM", "Co/Fi/ADLM", "Co/Bu/ADLM", "Co/Bu/DeltaT", "Co/Bu/AccessDB", "Ro/Fi/ADLM")
    test_struct <- .createDummyLevel2ObjectStructure(uri_paths)

    uri <- Level2URI("*/*")
    expect_equal(expandURIPlaceholder(test_struct, uri), as.Level2URI(c("Al/Fi", "Al/Bu", "Co/Fi", "Co/Bu", "Ro/Fi")))
})

test_that("Can expand all three levels each", {
    uri_paths <- c("Al/Fi/ADLM", "Al/Bu/ADLM", "Co/Fi/ADLM", "Co/Bu/ADLM", "Co/Bu/DeltaT", "Co/Bu/AccessDB", "Ro/Fi/ADLM")
    test_struct <- .createDummyLevel2ObjectStructure(uri_paths)

    uri <- Level2URI("*/*/*")
    expect_equal(expandURIPlaceholder(test_struct, uri), as.Level2URI(uri_paths))
})

test_that("If fixed plot does not exist, return nothing for it", {
    uri_paths <- c("Al/Fi/ADLM")
    test_struct <- .createDummyLevel2ObjectStructure(uri_paths)

    uri <- Level2URI("Co/*/*")
    expect_equal(expandURIPlaceholder(test_struct, uri), NULL)
})

test_that("If fixed sub_plot does not exist, return nothing for it", {
    uri_paths <- c("Al/Fi/ADLM")
    test_struct <- .createDummyLevel2ObjectStructure(uri_paths)

    uri <- Level2URI("*/Bu/*")
    expect_equal(expandURIPlaceholder(test_struct, uri), NULL)
})
