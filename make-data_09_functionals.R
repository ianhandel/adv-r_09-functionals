# write excel demo

library(tidyverse)
library(fs)
library(writexl)


mpg %>% 
  split(mpg$manufacturer) %>% 
  write_xlsx(path = "car_data.xlsx")

