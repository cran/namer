context("test-name_chunks")

tmp <- tempdir()

test_that("LaTeX special characters are succesfully replaced in filenames", {

  bad_filename <- "11-12-2018_The-%-of-$-on-this-&-that"

  fixed_filename <- clean_latex_special_characters(bad_filename)

  expect_false(grepl("([#$%&_{}])|\\s|~|\\^|[-]{2,}", paste0(fixed_filename, "")))

})

test_that("renaming works", {
  temp_file_path <- file.path(tmp, "test.Rmd")

  file.copy(system.file("examples", "example1.Rmd", package = "namer"),
            temp_file_path)
  name_chunks(temp_file_path)
  lines <- readLines(temp_file_path)
  chunk_info <- get_chunk_info(lines)
  expect_true(all(
    chunk_info$name != ""))
  file.remove(temp_file_path)
})

test_that("renaming with prefix works", {
  temp_file_path <- file.path(tmp, "test.Rmd")

  file.copy(system.file("examples", "example1.Rmd", package = "namer"),
            temp_file_path)
  name_chunks(temp_file_path, prefix = "my-prefix")
  lines <- readLines(temp_file_path)
  chunk_info <- get_chunk_info(lines)
  expect_true(all(grepl("my-prefix", chunk_info$name[-1])))
  file.remove(temp_file_path)
})

test_that("unnaming is advised when needed", {
  temp_file_path <- file.path(tmp, "example4.Rmd")

  file.copy(system.file("examples", "example4.Rmd", package = "namer"),
            temp_file_path)

  expect_error(name_chunks(temp_file_path))
  file.remove(temp_file_path)
})

unlink(tmp)
