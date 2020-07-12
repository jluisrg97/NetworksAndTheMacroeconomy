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

# Data----

data <- read.csv("C:/Users/jlrod/Documents/Networks and the macroeconomy/NetworksAndTheMacroeconomy/SCIAN-TIGIE-RESUMEN.csv" , 
                 header = TRUE) # Aquí estoy importanto la hoja con la relación SCIAN 4 dígitos <-> TIGIE 6 dígitos

hs2012 <- as.character(unlist(data)) # Este objeto incluye los repetidos

hs2012 <- hs2012[!is.na(hs2012)] # Eliminamos NAs

hs2012 <- as.data.frame(hs2012) # Creamos dataframe para operar con dplyr

hs2012_rep <- hs2012 %>%  # Filtramos todos los códigos que se repiten
  group_by(hs2012) %>%
  filter(n() >= 2)

hs2012_rep <- as.character(unlist(unique(hs2012_rep))) # Creamos vector de strings

load("usa_mex_chi.Rda") # Cargamos los datos descargados de importaciones de USA provenientes de México y China

comtrade_test <- comtrade_data %>%    
  filter(!commodity_code %in% hs2012_rep) # Filtramos los códigos 
