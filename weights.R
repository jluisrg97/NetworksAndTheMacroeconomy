#####################################################################################################
##
## Networks and the Macroeconomy: An Empirical Approach - Data cleaning
## 
## Data: Encuesta Mensual de Servicios https://www.inegi.org.mx/sistemas/bie/
## Author: José Luis Rodríguez-Guzmán
## Date: June 26th, 2020
##
#####################################################################################################

## Settings

# Libraries

library(tabulizer)
library(openxlsx)

areas <- locate_areas("https://www.snieg.mx/DocumentacionPortal/iin/Acuerdo_5_IV_2016/ems/38_MCI_EMS_2014.pdf" ,
                      pages = c(17 , 18 , 19 , 20 , 21))

weights <- extract_tables("https://www.snieg.mx/DocumentacionPortal/iin/Acuerdo_5_IV_2016/ems/38_MCI_EMS_2014.pdf" ,
                          pages = c(17 , 18 , 19 , 20 , 21) ,
                          area = areas ,
                          output = "data.frame")

weights <- reduce(weights , bind_rows)

write.xlsx(weights , file = "weights.xlsx")