test_that("all_Met_objects returns an integer vector when include_IDs is set to TRUE", {
  expect_equal(typeof(all_Met_objects(include_IDs = TRUE)), "integer")
})
