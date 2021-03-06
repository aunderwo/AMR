# ==================================================================== #
# TITLE                                                                #
# Antimicrobial Resistance (AMR) Analysis                              #
#                                                                      #
# SOURCE                                                               #
# https://github.com/msberends/AMR                                     #
#                                                                      #
# LICENCE                                                              #
# (c) 2018-2020 Berends MS, Luz CF et al.                              #
#                                                                      #
# This R package is free software; you can freely use and distribute   #
# it for both personal and commercial purposes under the terms of the  #
# GNU General Public License version 2.0 (GNU GPL-2), as published by  #
# the Free Software Foundation.                                        #
#                                                                      #
# We created this package for both routine data analysis and academic  #
# research and it was publicly released in the hope that it will be    #
# useful, but it comes WITHOUT ANY WARRANTY OR LIABILITY.              #
# Visit our website for more info: https://msberends.github.io/AMR.    #
# ==================================================================== #

context("mic.R")

test_that("mic works", {
  expect_true(as.mic(8) == as.mic("8"))
  expect_true(as.mic("1") > as.mic("<=0.0625"))
  expect_true(as.mic("1") < as.mic(">=32"))
  expect_true(is.mic(as.mic(8)))

  expect_equal(as.double(as.mic(">=32")), 32)
  expect_equal(as.numeric(as.mic(">=32")), 32)
  expect_equal(as.integer(as.mic(">=32")), 32)
  expect_equal(suppressWarnings(as.logical(as.mic("INVALID VALUE"))), NA)

  # all levels should be valid MICs
  expect_silent(as.mic(levels(as.mic(1))))

  expect_warning(as.mic("INVALID VALUE"))

  # print plots, should not raise errors
  barplot(as.mic(c(1, 2, 4, 8)))
  plot(as.mic(c(1, 2, 4, 8)))
  print(as.mic(c(1, 2, 4, 8)))

  expect_equal(summary(as.mic(c(2, 8))), c("Class" = "mic",
                                           "<NA>" = "0",
                                           "Min." = "2",
                                           "Max." = "8"))
})
