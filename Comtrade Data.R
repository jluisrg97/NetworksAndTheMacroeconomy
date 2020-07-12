#####################################################################################################
##
## Networks and the Macroeconomy: An Empirical Approach - UN Comtrade Data
## 
## Data: UN Comtrade
## Author: José Luis Rodríguez-Guzmán & Nathaly Parra-Nava
## Date: June 25th, 2020
##
#####################################################################################################

## Settings

# Libs----

library(comtradr) # An API for UN Comtrade Data
library(dplyr) # For data wrangling
library(purrr) # For reduce

# Data----

data <- read.csv("C:/Users/jlrod/Documents/Networks and the macroeconomy/NetworksAndTheMacroeconomy/SCIAN-TIGIE-RESUMEN.csv" , 
                 header = TRUE) # Aquí estoy importanto la hoja con la relación SCIAN 4 dígitos <-> TIGIE 6 dígitos

hs2012 <- as.character(unique(unlist(data))) # Para crear un vector string con los códigos únicos que necesitaremos descargar

hs2012 <- hs2012[!is.na(hs2012)] # Eliminamos NAs

test_hs2012 <- hs2012[4001:4793] # Me quedo con 40 códigos para hacer los experimentos con el loop sin acabarme las queries :S

iteradores <- seq(1 , 793 , by = 13) # Para saltar los iteradores

for (i in iteradores) {             # Para cada elemento de test_hs2012, hacer:
  name <- paste("comtrade" , i , sep = "_")  # Un objeto (que será data frame) que se llame comtrade_i, donde i
                                             # es el número de iteración.
  assign(name , ct_search(reporters = "USA" ,
                      partners = c("Mexico" , "China") ,  # Assign se interpreta así:
                      trade_direction = "imports" ,       # assign(nombre del objeto a crear , valores del objeto)
                      freq = "annual" ,                   # Rasultado: Un data frame por iteración.
                      commod_codes = test_hs2012[i:(i+19)] ,  # Extraer la serie del elemento i al i+19
                      start_date = "all" ,             
                      end_date = "all"))
  
  Sys.sleep(1) # Para "dormir" el sistema un segundo                                     
                                                      
  }

comtrade_data <- lapply(ls(pattern = "comtrade_[0-9]+"), function(x) get(x)) # Para que R busque todos los objetos cuyo nombre
                                                                            # comience por "comtrade_" 
comtrade_data <- reduce(comtrade_data , bind_rows)

save(comtrade_data , file = "comtrade.Rda")

# Para los 793 restantes

for (i in iteradores) {             # Para cada elemento de test_hs2012, hacer:
  name <- paste("comtrade" , i , sep = "_")  # Un objeto (que será data frame) que se llame comtrade_i, donde i
  # es el número de iteración.
  assign(name , ct_search(reporters = "USA" ,
                          partners = c("Mexico" , "China") ,  # Assign se interpreta así:
                          trade_direction = "imports" ,       # assign(nombre del objeto a crear , valores del objeto)
                          freq = "annual" ,                   # Rasultado: Un data frame por iteración.
                          commod_codes = test_hs2012[i:(i+12)] ,  # Extraer la serie del elemento i al i+19
                          start_date = "all" ,             
                          end_date = "all"))
  
  Sys.sleep(1) # Para "dormir" el sistema un segundo                                     
  
}

comtrade_data793 <- lapply(ls(pattern = "comtrade_[0-9]+") , function(x) get(x)) # Creando lista de los 793 restantes

comtrade_data793 <- reduce(comtrade_data793 , bind_rows) # Creando dataframe con los 793 restantes

load("comtrade.Rda") # Cargando los primeros 2,000

comtrade_data <- bind_rows(comtrade_data , comtrade_data793) # Juntando ambos dataframes

load("COM-P1.Rda") # Para cargar datos de Nathaly

comtrade_data <- bind_rows(comtrade_data , comtrade_dataN) # Juntando mis datos con los de Nathaly

save(comtrade_data , file = "usa_mex_chi.Rda")

