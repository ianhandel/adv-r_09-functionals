#' ---
#' title: "Advanced R 09-functionals"
#' date: "2019-04-17"
#' author: "ian handel"
#' output: html_document
#' ---

# ignore errors when knitting
knitr::opts_chunk$set(error = TRUE)

library(tidyverse)
# for purrr, dplyr, ggplot2

library(repurrrsive)
# for data


#'==================================================
#'==================================================
#' The basic idea

x <- c(1, 2, 3)

map(x, sqrt)

#'==================================================
#' Controlling the output

map_dbl(x, sqrt)

map_chr(x, sqrt)

#'==================================================
#' These functions expect a scalar output from .f

pair <- function(y) c(y, y)

pair(2.3)

map_dbl(x, pair)

map(x, pair)

#'==================================================
#' and the right type of output

as.character(3.14)

map_dbl(x, as.character)

map_chr(x, as.character)

#'==================================================
#' anonymous functions

mtcars

#' named function

unique_length <- function(y) length(unique(y))

z <- c(1, 2, 3, 1, 2)

unique_length(z)

map_int(mtcars, unique_length)

#' using anaonymous functions

map_int(mtcars, function(X) length(unique(X)))

map_int(mtcars, ~length(unique(.x)))

#'==================================================
#' Extracting stuff

x <- list(
  list(-1, x = 1, y = c(2), z = "a"),
  list(-2, x = 4, y = c(5, 6), z = "b"),
  list(-3, x = 8, y = c(9, 10, 11))
)

x

map(x, "y")

map(x, 3)

map(x, list("y", 1))

#' NOT

map(x, "y", 1)

#'==================================================
#' Passing other argument to .f

x <- list(a = c(1.1111, 2.2222), b = c(4.44444, 5.5555))

x

map(x, round)

map(x, round, 2)

?round

map(x, round, digits = 1)


