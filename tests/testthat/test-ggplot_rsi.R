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

context("ggplot_rsi.R")

test_that("ggplot_rsi works", {

  skip_on_cran()
  
  skip_if_not("ggplot2" %in% rownames(installed.packages()))

  library(dplyr)
  library(ggplot2)

  # data should be equal
  expect_equal(
    (example_isolates %>% select(AMC, CIP) %>% ggplot_rsi())$data %>% summarise_all(resistance) %>% as.double(),
    example_isolates %>% select(AMC, CIP) %>% summarise_all(resistance) %>% as.double()
  )

  print(example_isolates %>% select(AMC, CIP) %>% ggplot_rsi(x = "interpretation", facet = "antibiotic"))
  print(example_isolates %>% select(AMC, CIP) %>% ggplot_rsi(x = "antibiotic", facet = "interpretation"))

  expect_equal(
    (example_isolates %>% select(AMC, CIP) %>% ggplot_rsi(x = "interpretation", facet = "antibiotic"))$data %>% summarise_all(resistance) %>% as.double(),
    example_isolates %>% select(AMC, CIP) %>% summarise_all(resistance) %>% as.double()
  )

  expect_equal(
    (example_isolates %>% select(AMC, CIP) %>% ggplot_rsi(x = "antibiotic", facet = "interpretation"))$data %>% summarise_all(resistance) %>% as.double(),
    example_isolates %>% select(AMC, CIP) %>% summarise_all(resistance) %>% as.double()
  )

  expect_equal(
    (example_isolates %>% select(AMC, CIP) %>% ggplot_rsi(x = "antibiotic", facet = "interpretation"))$data %>% summarise_all(count_resistant) %>% as.double(),
    example_isolates %>% select(AMC, CIP) %>% summarise_all(count_resistant) %>% as.double()
  )

  # support for scale_type ab and mo
  expect_equal(class((data.frame(mo = as.mo(c("e. coli", "s aureus")),
                                 n = c(40, 100)) %>%
                        ggplot(aes(x = mo, y = n)) +
                        geom_col())$data),
               "data.frame")
  expect_equal(class((data.frame(ab = as.ab(c("amx", "amc")),
                                 n = c(40, 100)) %>%
                        ggplot(aes(x = ab, y = n)) +
                        geom_col())$data),
               "data.frame")

})
