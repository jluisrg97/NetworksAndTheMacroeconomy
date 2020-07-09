make_long_annual <- function(data , codes , var_name , from , to){
  if(missing(codes)){
    data <- data %>% 
      melt(id.vars = "periodo") %>% # Reshape from wide to long
      rename(sector = variable , # Renaming to make consistent variable names
             "{{var_name}}" := value) %>%
      group_by(sector) %>% # grouping to make operations for each sector
      mutate(date = seq(from = as.Date(from) ,  # Because R is very tricky with external
                        to = as.Date(to) ,    # date formats
                        by = "month") ,
             year = format(date , "%Y")) %>%  # To generate a year variable
      select(year , date , sector , {{var_name}}) %>% # Dropping "periodo" and arranging our columns
      filter(year <= 2018) %>%  # Dropping 2019 data
      group_by(year , sector) %>% # Grouping by year and sector to annualize the data
      summarise("{{var_name}}" := mean({{var_name}})) %>%  # Annualizing using annual mean
      arrange(sector) # Arranging to get a long panel data in correct format 
    return(data)
  } else {
    data <- data %>% 
      melt(id.vars = "periodo") %>% # Reshape from wide to long
      rename(sector = variable , # Renaming to make consistent variable names
             "{{var_name}}" := value) %>%
      mutate(code = case_when(!!!codes)) %>%
      group_by(sector) %>% # grouping to make operations for each code
      mutate(date = seq(from = as.Date(from) ,  # Because R is very tricky with external
                        to = as.Date(to) ,    # date formats
                        by = "month") ,
             year = format(date , "%Y")) %>%  # To generate a year variable
      select(year , date , code , sector , {{var_name}}) %>% # Dropping "periodo" and arranging our columns
      filter(year <= 2018) %>%  # Dropping 2019 data
      group_by(year , code , sector) %>% # Grouping by year, code and sector to annualize the data
      summarise("{{var_name}}" := mean({{var_name}})) %>%  # Annualizing using annual mean
      arrange(code) # Arranging to get a long panel data in correct format 
    return(data)
  }

}
