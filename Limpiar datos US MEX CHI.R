#####################################################################################################
##
## Networks and the Macroeconomy: An Empirical Approach - UN Comtrade Data
## 
## Data: Cleaning UN Comtrade - US imports from China & Mexico
## Author: José Luis Rodríguez-Guzmán & Nathaly Parra-Nava
## Date: June 25th, 2020
##
#####################################################################################################

## Settings

# Libs----

library(dplyr)
library(reshape2)
library(stringr)

# Data----

data <- read.csv("C:/Users/jlrod/Documents/Networks and the macroeconomy/NetworksAndTheMacroeconomy/SCIAN-TIGIE-RESUMEN.csv" , 
                 header = TRUE) # Aquí estoy importando la hoja con la relación SCIAN 4 dígitos <-> TIGIE 6 dígitos

load("usa_mex_chi.Rda") # Cargamos los datos descargados de importaciones de USA provenientes de México y China

## Data cleaning----

hs2012 <- as.character(unlist(data)) # Creamos un vector de strings con todos los códigos HS a 6 dígitos que corresponden a códigos SCIAN

hs2012 <- hs2012[!is.na(hs2012)] # Eliminamos NAs

hs2012 <- as.data.frame(hs2012) # Creamos dataframe para operar con dplyr

hs2012_rep <- hs2012 %>%  # Filtramos todos los códigos que se repiten para hacer operaciones posteriormente
  group_by(hs2012) %>%
  filter(n() >= 2)

hs2012_rep <- as.character(unlist(unique(hs2012_rep))) # Creamos vector de strings con todos los valores con frecuencia mayor a 1

comtrade_test <- comtrade_data %>%    
  filter(!commodity_code %in% hs2012_rep) %>% # Filtramos los códigos quedándonos con los que no se repiten
  select(c("classification" , "year" , "trade_flow" , # Para quedarnos con las variables que nos interesan
           "reporter" , "partner" , "commodity_code" ,
           "trade_value_usd")) %>%
  filter(year >= 1994 & year <= 2018) %>% # Filtramos para tener el periodo de interés
  mutate(commodity_code = as.factor(commodity_code) , # Convertimos los códigos de string a factor
         year = format(as.Date(as.character(year) , format = "%Y"),"%Y")) # Convertimos la variable year a formato de fecha en R
  
relacion_scian_hs <- data %>%
  melt() %>% # Hacemos reshape para tener una columna de códigos scian a 4 dígitos y una de HS a 6 dígitos
  rename(code = variable , # Renombramos para tener consistencia con las demás data frames
         commodity_code = value) %>%
  group_by(commodity_code) %>% # Agrupamos para hacer operaciones por cada código
  filter(n() == 1) %>% # Filtramos todos los valores con frecuencia igual a 1 (los no repetidos)
  select(c("commodity_code" , "code")) %>% # Ordenamos
  ungroup() %>% # Desagrupamos para poder realizar operaciones
  mutate(commodity_code = as.factor(commodity_code)) # Convertimos commodity_code de string a factor

relacion_scian_hs$code <- str_remove(relacion_scian_hs$code , "X") # Eliminamos la "X" de los códigos SCIAN

comtrade_usa_mex_chi <- left_join(comtrade_test , relacion_scian_hs , by = "commodity_code") %>% # Hacemos merge de cada código HS con su respectivo SCIAN
  mutate(commodity_code = as.factor(commodity_code) ,
         code = as.factor(code)) %>% # Convertimos commodity_code y code de string a factor
  group_by(year , partner , code) %>% # Agrupamos por año, país socio y código SCIAN
  summarise(trade_value_usd = sum(trade_value_usd)) # Agregamos el valor intercambiado para cada SCIAN como la suma de códigos HS que lo componen

