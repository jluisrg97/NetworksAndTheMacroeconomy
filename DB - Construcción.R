#####################################################################################################
##
## Networks and the Macroeconomy: An Empirical Approach - Data cleaning
## 
## Data: Encuesta Anual de Empresas de Construcción https://www.inegi.org.mx/sistemas/bie/
## Author: José Luis Rodríguez-Guzmán
## Date: June 25th, 2020
##
#####################################################################################################

## Settings

# Libraries

library(dplyr)
library(reshape2)
library(openxlsx)

# Data

data <- read.csv("C:/Users/jlrod/Downloads/construc.csv" , header = TRUE) # Loading ENEC
data1 <- read.csv("C:/Users/jlrod/Downloads/construccion_valor_produccion.csv" , header = TRUE) # Loading ENEC

# Functions 

source("C:/Users/jlrod/Documents/Networks and the macroeconomy/make_long_annual.R")  

## Cleaning dataset

# SCIAN codes

codes <- rlang::exprs(
  .data$sector == "edif" ~  "236" ,
  .data$sector == "ing" ~ "237" ,
  .data$sector == "especial" ~ "238"
)

data <- data %>%
  melt(id.vars = "periodo") %>% # Reshaping from wide to long
  rename(sector = variable , 
         pot = value) %>%
  mutate(code = if_else(sector == "total" , "23" , # The code will be 23 for the total construction sector
                        if_else(sector == "edif" , "236" , # The code will be 236 for edification subsector
                                if_else(sector == "ing" , "237" , # The code will be 237 for  civil engineering 
                                                                  # construction subsector
                                        if_else(sector == "especial" , "238" , NA_character_))))) %>% # The code will be 238 for the  
                                                                                        #  subsector of specialized works for construction 
  group_by(code) %>% # To generate an operation for each code/sector
  mutate(date = seq(from = as.Date("2006-01-01") , to = as.Date("2019-02-01") , by = "month") , # To create a date variable because R 
                                                                                                # is very tricky with external date formats
         year = format(date , "%Y")) %>% # To create a variable with the years
  select(date , year , code , sector , pot) %>% # To rearrange our variables and drop "Periodo" because is not a date to R
  filter(year <= 2018) %>% # To drop 2019 data 
  group_by(year , code , sector) %>% # Grouping by each year and sector/subsector
  summarise(pot = mean(pot)) %>% # Annualizing the total occupied people by annual mean
  arrange(code) %>% # Arranging by code
  filter(sector != "total")

data1 <- make_long_annual(data = data1 , codes = codes , var_name = valor_produccion , from = "2006-01-01" , to = "2019-02-01")

def_data <- left_join(data , data1 , by = c("year" = "year" ,
                                               "code" = "code" ,
                                               "sector" = "sector")) %>%
  mutate(produc = valor_produccion/pot)

## Writing Excel file

write.xlsx(def_data , file = "DB-Construccion-con-valor-de-produccion.xlsx")
  






  