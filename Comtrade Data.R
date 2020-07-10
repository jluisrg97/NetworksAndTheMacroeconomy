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


test_hs2012 <- hs2012[1:40] # Me quedo con 40 códigos para hacer los experimentos con el loop sin acabarme las queries :S

iteradores <- seq(1 , 40 , by = 20) # Para saltar los iteradores

for (i in iteradores) {             # Para cada elemento de test_hs2012, hacer:
  name <- paste("comtrade" , i , sep = "_")  # Un objeto (que será data frame) que se llame comtrade_i, donde i
                                             # es el número de iteración.
  assign(name , ct_search(reporters = "USA" ,
                      partners = c("Mexico" , "China") ,  # Assign se interpreta así:
                      trade_direction = "imports" ,       # assign(nombre del objeto a crear , valores del objeto)
                      freq = "annual" ,                   # Rasultado: Un data frame por iteración.
                      commod_codes = test_hs2012[i:(i+19)] ,  # Extraer la serie del elemento i
                      start_date = "all" ,            # Nota: Cuando las bases salen vacías es porque 
                      end_date = "all"))              # nuestro código tiene dos ceros al final, es decir,
                                                      # en el HS2012 solo se reconoce por los primeros 4 dígitos.
  Sys.sleep(1) # Para "dormir" el sistema un segundo                                     
                                                      # Posteriormente arreglaremos eso.
  }


