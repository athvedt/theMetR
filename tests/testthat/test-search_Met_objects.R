test_that("search_Met_objects returns a list when limit >0", {
  expect_equal(typeof(search_Met_objects(q = "dog", limit = 1)), "list")
})

test_that("search_Met_objects does not return a data.frame when limit = 0", {
  expect_false(is.data.frame(search_Met_objects(q = "dog", limit = 0)))
})

test_that("search_Met_objects does not return a data.frame when no objects meet search parameters", {
  expect_false(is.data.frame(search_Met_objects()))
})
