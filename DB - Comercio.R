#####################################################################################################
##
## Networks and the Macroeconomy: An Empirical Approach - Data cleaning
## 
## Data: Encuesta Anual de Comercio https://www.inegi.org.mx/sistemas/bie/
## Author: José Luis Rodríguez-Guzmán
## Date: June 26th, 2020
##
#####################################################################################################

## Settings

# Libraries

library(dplyr)
library(reshape2)
library(openxlsx)

# Data

data <- read.csv("C:/Users/jlrod/Downloads/comercio - pot.csv" , header = TRUE) # Loading EAC with pot data
data1 <- read.csv("C:/Users/jlrod/Downloads/comercio - ingreso.csv" , header = TRUE) # Loading EAC with ingreso data

# Functions

source("C:/Users/jlrod/Documents/Networks and the macroeconomy/make_long_annual.R") # To call the make_long_annual 
                                                                                    # function

## Data cleaning

# List of SCIAN codes related to each sector/subsector:

codes <- rlang::exprs(  
  .data$sector == "com_mayor" ~ "43" , 
  .data$sector == "mayor_alim_beb" ~ "431" ,
  .data$sector == "mayor_alim" ~ "4311" ,
  .data$sector == "mayor_beb" ~ "4312" ,
  .data$sector == "mayor_tex_cal" ~ "432" ,
  .data$sector == "mayor_textiles_calzado" ~ "4321" ,
  .data$sector == "mayor_farma_et_al" ~ "433" ,
  .data$sector == "mayor_farma" ~ "4331" ,
  .data$sector == "mayor_perf_cos_joy" ~ "4332" ,
  .data$sector == "mayor_disc_jug_depor" ~ "4333" ,
  .data$sector == "mayor_editorial" ~ "4334" ,
  .data$sector == "mayor_electrodom" ~ "4335" ,
  .data$sector == "mayor_mat_prima" ~ "434" ,
  .data$sector == "mayor_mp_agro_for" ~ "4341" ,
  .data$sector == "mayor_mp_industria" ~ "4342" ,
  .data$sector == "mayor_mp_desecho" ~ "4343" ,
  .data$sector == "mayor_maq_equipo" ~ "435" ,
  .data$sector == "mayor_me_agro_for_pes" ~ "4351" ,
  .data$sector == "mayor_me_industria" ~ "4352" ,
  .data$sector == "mayor_me_comercio" ~ "4353" ,
  .data$sector == "mayor_me_general" ~ "4354" ,
  .data$sector == "mayor_camiones_partes" ~ "436" ,
  .data$sector == "mayor_camiones_partes_refacciones" ~ "4361" ,
  .data$sector == "mayor_inter" ~ "437" ,
  .data$sector == "mayor_inter_sin_digital" ~ "4371" ,
  .data$sector == "mayor_inter_digital" ~ "4372" ,
  .data$sector == "com_menor" ~ "46" ,
  .data$sector == "menor_alim_beb" ~ "461" ,
  .data$sector == "menor_alim" ~ "4611" ,
  .data$sector == "menor_beb" ~ "4612" ,
  .data$sector == "menor_auto_dep" ~ "462" ,
  .data$sector == "menor_autoserv" ~ "4621" ,
  .data$sector == "menor_departamental" ~ "4622" ,
  .data$sector == "menor_tex_et_al" ~ "463" ,
  .data$sector == "menor_tex_et_al_sin_ropa" ~ "4631" ,
  .data$sector == "menor_ropa_bis" ~ "4632" ,
  .data$sector == "menor_calzado" ~ "4633" ,
  .data$sector == "menor_salud" ~ "464" ,
  .data$sector == "menor_cuidado_salud" ~ "4641" ,
  .data$sector == "menor_papel_personal" ~ "465" ,
  .data$sector == "menor_perf_joy" ~ "4651" ,
  .data$sector == "menor_espar" ~ "4652" ,
  .data$sector == "menor_editorial" ~ "4653" ,
  .data$sector == "menor_mascotas_regalos" ~ "4654" ,
  .data$sector == "menor_domesticos" ~ "466" ,
  .data$sector == "menor_muebles" ~ "4661" ,
  .data$sector == "menor_comp_com" ~ "4662" ,
  .data$sector == "menor_deco_int" ~ "4663" ,
  .data$sector == "menor_usados" ~ "4664" ,
  .data$sector == "menor_ferreteria" ~ "467" ,
  .data$sector == "menor_ferreteria_tlap_vidrios" ~ "4671" ,
  .data$sector == "menor_vehiculos" ~ "468" ,
  .data$sector == "menor_auto_cam" ~ "4681" ,
  .data$sector == "menor_partes_refacc" ~ "4682" ,
  .data$sector == "menor_motos" ~ "4683" ,
  .data$sector == "menor_combus_ace_gras" ~ "4684" ,
  .data$sector == "menor_internet_catalogo" ~ "469" ,
  .data$sector == "menor_inter_catalogo" ~ "4691"
  )

data <- make_long_annual(data , codes , pot , from = "2008-01-01" , to = "2019-02-01") # To make a long panel with
                                                                                       # annual pot data

data1 <- make_long_annual(data1 , codes , ingreso , from = "2008-01-01" , to = "2019-02-01") # To make a long panel with
                                                                                            # annual ingreso data

def_data <- left_join(data , data1 , by = c("year" = "year" ,  # To merge the pot and ingreso data
                                        "code" = "code" ,
                                        "sector" = "sector"))

def_data <- def_data %>%
  mutate(produc = ingreso/pot) %>% # To calculate productivity
  filter(code %in% c("43" , "431" , "4311" , "46" , "461" , "4611")) # To filter the codes included in input-output matrix

write.xlsx(def_data , file = "DB-Comercio.xlsx") # To write the xlsx file
