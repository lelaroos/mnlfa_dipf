library(tidyverse)
library(knitr)

# Simulation conditions
par_df <- readRDS("RDS_objects/par_df.RDS")

# to latex table
kable(par_df, digits = 2, format = 'latex')

# Simulation results
cont_res <- readRDS("RDS_objects/Results/cont_res.RDS")
dich_res <- readRDS("RDS_objects/Results/dich_res.RDS")
tot_res <- cbind(par_df, cont_res, dich_res) 

# to latex table
kable(tot_res, digits = 2, format = 'latex')

