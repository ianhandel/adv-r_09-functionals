#' ---
#' title: "Advanced R 09-functionals examples"
#' date: "2019-04-17"
#' author: "ian handel"
#' output: github_document
#' 
#' ---

# ignore errors when knitting
knitr::opts_chunk$set(error = TRUE)

library(tidyverse)
# for purrr, dplyr, ggplot2

library(repurrrsive)
# for data


#'==================================================
#' Exercises


#' as_mapper
?as_mapper

got_chars

got_chars[[1]]

map_chr(got_chars, "name")
map(got_chars, "povBooks")
map(got_chars, list("povBooks", 1))

as_mapper(list("povBooks", 1))

#' exercise 6 

formulas <- list(
  mpg ~ disp,
  mpg ~ I(1 / disp),
  mpg ~ disp + wt,
  mpg ~ I(1 / disp) + wt,
  mpg ~ I(1 / disp) + cyl,
  mpg ~ I(1 / disp) + cyl + wt
)

map(formulas, ~summary(lm(.x, data = mtcars)))

formulas %>% 
  set_names() %>% 
  map(lm, data = mtcars) %>% 
  map_df(broom::glance, .id = "formula") %>% 
  ggplot() +
  aes(x = formula, y = AIC) +
  geom_point() +
  coord_flip()


#'==================================================
#' Importing from Excel

FILE <- "car_data.xlsx"

readxl::excel_sheets(FILE)

SHEETS <- readxl::excel_sheets(FILE) %>% set_names()

map(SHEETS,
    ~readxl::read_excel(path = FILE, sheet = .x))

map_df(SHEETS,
       ~readxl::read_excel(path = FILE, sheet = .x),
       .id = "manufacturer")

cars <- map_df(SHEETS,
               ~readxl::read_excel(path = FILE, sheet = .x),
               .id = "manufacturer")

lm(hwy ~ displ, data = cars)
ggplot(cars) +
  aes(displ, hwy) +
  geom_point()

cars_models <- cars %>% 
  group_by(manufacturer, year) %>% 
  nest() %>% 
  mutate(model = map(data, ~lm(hwy ~ displ, data = .x))) %>% 
  mutate(coefs = map(model, coef)) %>% 
  mutate(displ = map_dbl(coefs, "displ")) 
  
ggplot(cars_models) +
  aes(x = displ, colour = factor(year),
      y = fct_reorder(manufacturer, displ, na.rm = TRUE)) +
  geom_point() +
  labs(x = "change in mpg per litre",
       y = "Manufacturer")

