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


tomato <- ct_commodity_lookup("tomato" , return_code = TRUE , return_char = TRUE) # Para obtener todos los códigos relativos al tomate

datacom <- ct_search(reporters = "USA" ,
                     partners = c("Mexico" , "China") ,
                     trade_direction = "imports" ,
                     freq = "annual" ,
                     commod_codes = tomato , # Para indicar que queremos el segundo elemento dentro de tomato
                     start_date = "all" ,
                     end_date = "all")


test_hs2012 <- hs2012[1:800] # Me quedo con 40 códigos para hacer los experimentos con el loop sin acabarme las queries :S

iteradores <- seq(1 , 800 , by = 20) # Para saltar los iteradores

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

