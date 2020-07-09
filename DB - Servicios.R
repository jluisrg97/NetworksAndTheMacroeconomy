#####################################################################################################
##
## Networks and the Macroeconomy: An Empirical Approach - Data cleaning
## 
## Data: Encuesta mensual de Servicios https://www.inegi.org.mx/sistemas/bie/
## Author: José Luis Rodríguez-Guzmán
## Date: July 2nd, 2020
##
#####################################################################################################

## Settings

# Libs----------------------------------------------------------

library(dplyr)
library(reshape2)
library(openxlsx)

# Data-----------------------------------------------------------

data <- read.csv("C:/Users/jlrod/Downloads/servicios - pot - final.csv" , header = TRUE) # Loading EMS with pot data
data1 <- read.csv("C:/Users/jlrod/Downloads/servicios - ingreso.csv" , header = TRUE) # Loading EMS with ingreso data

# Functions------------------------------------------------------

source("C:/Users/jlrod/Documents/Networks and the macroeconomy/make_long_annual.R") # Loading make_long_annual function

## Data cleaning-------------------------------------------------


# List of SCIAN codes--------------------------------------------

codes <- rlang::exprs(
  .data$sector == "serv_transp_corr_alm" ~ "48-49" ,
  .data$sector == "serv_transp_aereo" ~ "481" ,
  .data$sector == "serv_transp_ferrocarril" ~ "482" ,
  .data$sector == "serv_transp_mar" ~ "483" ,
  .data$sector == "serv_autotransp_carga" ~ "484" ,
  .data$sector == "serv_transp_pasajeros" ~ "485" ,
  .data$sector == "serv_transp_colectivo_local" ~ "4851" ,
  .data$sector == "serv_transp_colectivo_for" ~ "4852" ,
  .data$sector == "serv_transp_relacionados" ~ "488" ,
  .data$sector == "serv_carga_desc_transp_agua" ~ "4883" ,
  .data$sector == "serv_inter_transp_carga" ~ "4885" ,
  .data$sector == "serv_mens_paq" ~ "492" ,
  .data$sector == "serv_mens_paq_for" ~ "4921" ,
  .data$sector == "serv_mens_paq_local" ~ "4922" ,
  .data$sector == "serv_almacenamiento" ~ "493" ,
  .data$sector == "serv_medios_masivos" ~ "51" ,
  .data$sector == "serv_edit_software" ~ "511" ,
  .data$sector == "serv_ed_impresas" ~ "5111" ,
  .data$sector == "serv_ed_rep_software" ~ "5112" ,
  .data$sector == "serv_ind_film_sonido" ~ "512" ,
  .data$sector == "serv_ind_filmica" ~ "5121" ,
  .data$sector == "serv_ind_sonido" ~ "5122" ,
  .data$sector == "serv_radio_tv" ~ "515" ,
  .data$sector == "serv_transm_radio_tv" ~ "5151" ,
  .data$sector == "serv_prog_tv" ~ "5152" ,
  .data$sector == "serv_telecom" ~ "517" ,
  .data$sector == "serv_telecom_alam" ~ "5171" ,
  .data$sector == "serv_telecom_inalam" ~ "5172" ,
  .data$sector == "serv_proc_informacion_hosp" ~ "518" ,
  .data$sector == "serv_proc_inf_hosp" ~ "5181" ,
  .data$sector == "serv_otros_informacion" ~ "519" ,
  .data$sector == "serv_inm_alq" ~ "53" ,
  .data$sector == "serv_inmobiliarios" ~ "531" ,
  .data$sector == "serv_inm_corr_br" ~ "5312" ,
  .data$sector == "serv_alq_muebles" ~ "532" ,
  .data$sector == "serv_alq_auto" ~ "5321" ,
  .data$sector == "serv_alq_maq" ~ "5324" ,
  .data$sector == "serv_alquiler_marc_pat_franq" ~ "533" ,
  .data$sector == "serv_alq_marc_pat_franq" ~ "5331" ,
  .data$sector == "serv_prof_cien_tec" ~ "54" ,
  .data$sector == "serv_prof_cien_tecnicos" ~ "541" ,
  .data$sector == "serv_legales" ~ "5411" ,
  .data$sector == "serv_conta_audit" ~ "5412" ,
  .data$sector == "serv_arq_ing_rel" ~ "5413" ,
  .data$sector == "serv_disenio_esp" ~ "5414" ,
  .data$sector == "serv_disenio_compu" ~ "5415" ,
  .data$sector == "serv_consultoria_adm_cien_tec" ~ "5416" ,
  .data$sector == "serv_inv_cien" ~ "5417" ,
  .data$sector == "serv_publicidad" ~ "5418" ,
  .data$sector == "serv_otros_prof_cien_tec" ~ "5419" ,
  .data$sector == "serv_apoyo_des_rem" ~ "56" ,
  .data$sector == "serv_apoyo_negocios" ~ "561" ,
  .data$sector == "serv_adm_negocios" ~ "5611" ,
  .data$sector == "serv_apoyo_instalaciones" ~ "5612" ,
  .data$sector == "serv_empleo" ~ "5613" ,
  .data$sector == "serv_viajes_res" ~ "5615" ,
  .data$sector == "serv_inv_protec_seg" ~ "5616" ,
  .data$sector == "serv_limpieza" ~ "5617" ,
  .data$sector == "serv_otros_res" ~ "5619" ,
  .data$sector == "serv_manejo_des_rem" ~ "562" ,
  .data$sector == "serv_educativos" ~ "56" ,
  .data$sector == "serv_educacion" ~ "561" ,
  .data$sector == "serv_educ_bas_med_esp" ~ "5611" ,
  .data$sector == "serv_educ_postbachi" ~ "5612" ,
  .data$sector == "serv_educ_superior" ~ "5613" ,
  .data$sector == "serv_educ_oficios" ~ "5615" ,
  .data$sector == "serv_educ_otros" ~ "5616" ,
  .data$sector == "serv_salud_social" ~ "62" ,
  .data$sector == "serv_salud_consultorios" ~ "621" ,
  .data$sector == "serv_consul_med" ~ "6211" ,
  .data$sector == "serv_consul_dent" ~ "6212" ,
  .data$sector == "serv_lab_med_diagnostico" ~ "6215" ,
  .data$sector == "serv_hospitales" ~ "622" ,
  .data$sector == "serv_hosp_generales" ~ "6221" ,
  .data$sector == "serv_hosp_esp" ~ "6223" ,
  .data$sector == "serv_asist_social" ~ "623" ,
  .data$sector == "serv_asilos" ~ "6233" ,
  .data$sector == "serv_orfanatos" ~ "6239" ,
  .data$sector == "serv_espar_cult_dep" ~ "71" ,
  .data$sector == "serv_art_cult_dep" ~ "711" ,
  .data$sector == "serv_eq_depor" ~ "7112" ,
  .data$sector == "serv_prom_inst" ~ "7113" ,
  .data$sector == "serv_agentes_rep" ~ "7114" ,
  .data$sector == "serv_hist_zoo" ~ "712" ,
  .data$sector == "serv_museos_jardines" ~ "7121" ,
  .data$sector == "serv_entretenimiento" ~ "713" ,
  .data$sector == "serv_parques_juegos" ~ "7131" ,
  .data$sector == "serv_juegos_otros" ~ "7132" ,
  .data$sector == "serv_alojamiento_rest" ~ "72" ,
  .data$sector == "serv_alojamiento_temporal" ~ "721" ,
  .data$sector == "serv_hoteles_moteles" ~ "7211" ,
  .data$sector == "serv_camp" ~ "7212" ,
  .data$sector == "serv_pensiones" ~ "7213" ,
  .data$sector == "serv_prep_alimentos_bebidas" ~ "722" ,
  .data$sector == "serv_restaurantes" ~ "7221" ,
  .data$sector == "serv_rest_autoserv" ~ "7222" ,
  .data$sector == "serv_comida_encargo" ~ "7223" ,
  .data$sector == "serv_nocturnos_bares_cantinas" ~ "7224"
)


#  Munging---------------------------------------------

data <- make_long_annual(data , codes , pot , from = "2008-01-01" , to = "2019-02-01") # Reshaping and annualizing pot data

data1 <- make_long_annual(data1 , codes , ingreso , from = "2008-01-01" , to = "2019-02-01") # Reshaping and annualizing ingreso data

def_data <- left_join(data , data1 , by = c("year" = "year" ,     # Merging pot and ingreso datasets
                                            "code" = "code" ,
                                            "sector" = "sector"))

def_data <- def_data %>%
  mutate(productividad = ingreso/pot)  # Computing the productivity as per capita revenue

write.xlsx(def_data , file = "DB-Servicio.xlsx")
