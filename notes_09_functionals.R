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

#'==================================================
#'varying another argument - i.e. not the first

roundiness <- c(0, 1, 2, 3)

map_dbl(roundiness, round, pi)

map_dbl(roundiness, ~ round(x = pi, digits = .x))


#'==================================================
#' purr style - examples


#'==================================================
#'multiple inputs


nums <- c(1.234, 4.324, 7.223)
roundiness <- c(1, 2, 3)

map2_dbl(nums, roundiness, round)

map2_dbl(nums, roundiness, ~round(.x, digits = .y))

#'==================================================
#' walk

bins <- c(5, 10, 15, 20)

par(mfrow = c(2,2))
walk(bins, ~hist(rnorm(100), breaks  = .x))

#'==================================================
#' iterating over values

iwalk(bins, ~hist(rnorm(100), breaks  = .x, main = .y))

bins

bins <- c(5, 10, 15, 20) %>% set_names()

bins

iwalk(bins, ~hist(rnorm(100), breaks  = .x, main = paste0("bins: ", .y)))


#'==================================================
#' Lots of inputs

car_coolness <- function(hwy, cty, displ){
  hwy + cty + displ * 100
}

car_coolness(hwy = 30, cty = 40, displ = 2)

pmap_dbl(list(hwy = c(30, 50),
          cty = c(25, 67),
          displ = c(1, 2)),
     car_coolness)

pmap_dbl(mpg, car_coolness)

# add dots!!!


#'==================================================
#' safely, possibly, quietly

dat <- list(1, 4, "A", 7)

map_dbl(dat, log)

poss_log <- possibly(log, otherwise = NA)

class(poss_log)

map_dbl(dat, poss_log)

#'==================================================
#' reduce and accumulate

x <- c(1, 7, 4, 2)

reduce(x, `+`)

reduce(x, `*`)

accumulate(x, `+`)

cumsum(x)

accumulate(x, `*`)

cumprod(x)

#'==================================================
#'predicate frunctions

df <- tibble(a = c(1, 2, NA, 4),
             b = c("A", "B", "C", "N"),
             c = c(7, 2, NA, 2))

some(df, is.character)
detect(df, is.character)
detect_index(df, is.character)
keep(df, is.character)

# using them...

mpg

cor(mpg)

keep(mpg, is_bare_numeric) %>% cor()

mpg

a <- mpg %>%
  modify_if(is_bare_numeric, round)

# b <- mpg %>%
#   mutate_if(is_bare_numeric, round)
# 
# all_equal(a, b)


# exercise - SPAN
# Implement the span() function from Haskell: given a list x and a predicate function f, span(x, f) returns the location of the longest sequential run of elements where the predicate is true. (Hint: you might find rle() helpful.)

span <- function(x, f){
  r <- rle(unname(map_lgl(x, f)))
  ii <- which.max(r$lengths * r$value)
  sum(r$lengths[1:(ii-1)] + 1)
  }

r <- c(1,3,2,4,5,4,3,3,5,1,2,1,1,1,1)



span(r, function(x) x>2)
span(iris, is.numeric)
span(iris, is.factor)


