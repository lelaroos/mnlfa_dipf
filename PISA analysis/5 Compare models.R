library(tidyverse)
library(knitr)

cont_mod <- readRDS("RDS objects/cont_mod.RDS")
dich_mod <- readRDS("RDS objects/dich_mod.RDS")


# Time --------------------------------------------------------------------
cont_t <- cont_mod$time$diff_time
dich_t <- difftime(dich_mod$time$s2, dich_mod$time$s1, units = "mins")

# how much longer?
as.numeric(dich_t)/as.numeric(cont_t)

# Regularized Parameters ----------------------------------------------------------

# Function to obtain the names of the items 
# for which the ESCS effect was regularized

obt_reg <- function(mod){
  reg <- mod$item %>% 
    filter(regul == 1) %>% 
    select(parm) %>% 
    unlist()
  return(reg)
}

obt_reg(cont_mod)
obt_reg(dich_mod)


