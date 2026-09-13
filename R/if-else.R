library(tidyverse)

my_word <- "hello"
if(nchar(my_word) <= 5){
  print("Its a short string")
}else if(nchar(myword) <= 8){
  print("Its a mid length string")
}else{
  print("Its a long string")
}


x <- 6
y <- if (x<5) 0 else 10

?ifelse

y <- ifelse(x<5, 0, 10)
y

library(readr)
library(dplyr)  # Required for %>% and mutate()

plant_updates <- read_csv("Dataset/plant_updates.csv")
View(plant_updates)


plants_new <- plant_updates %>%
  mutate(name_best = ifelse(!is.na(name_2017), name_2017, scientific_name), 
         c_best=ifelse(!is.na(c_2017), c_2017, c))

View(plants_new)

install.packages("skimr")
library(skimr)
skim(plants_new)

skimr::skim(plants_new)
