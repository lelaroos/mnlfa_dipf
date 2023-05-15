library(tidyverse)
library(mnlfa)
data_tot <- readRDS("RDS_objects/data_tot.RDS")
data <- unlist(data_tot, recursive = FALSE)

data1 <- as.data.frame(data[18])
data2 <- as.data.frame(data[7])
data3 <- as.data.frame(data[5])
data4 <- as.data.frame(data[11])
data5 <- as.data.frame(data[13])

# Fit MNLFA -------------------------------------------------------
items <- colnames(data1)[1:20]

# covariates for trait
formula_mean <- ~ 0 + x
formula_sd <- ~1

# moderation effects for items
formula_int <- ~1 + x
formula_slo <- ~1

mnlfa_mod <- function(data){
  mod <- mnlfa::mnlfa(dat = data, items = items, item_type="1PL", 
                      formula_int=formula_int, formula_slo=formula_slo, 
                      formula_mean=formula_mean, formula_sd=formula_sd, 
                      regular_lam=regular_lam, regular_type=regular_type,
                      conv = 1e-04)
  return(mod)
}

# Reg: 0.25 ---------------------------------------------------------------

# regularization parameters for item intercept and item slope, respectively
regular_lam <- c(.25, 0)
regular_type <- c("mcp","none")

mod1 <- mnlfa_mod(data1)
mod2 <- mnlfa_mod(data2)
mod3 <- mnlfa_mod(data3)
mod4 <- mnlfa_mod(data4)
mod5 <- mnlfa_mod(data5)

# too many parameters regularized

# Reg: 0.10 ---------------------------------------------------------------
# regularization parameters for item intercept and item slope, respectively
regular_lam <- c(.1, 0)
regular_type <- c("mcp","none")

mod1 <- mnlfa_mod(data1)
mod2 <- mnlfa_mod(data2)
mod3 <- mnlfa_mod(data3)
mod4 <- mnlfa_mod(data4)
mod5 <- mnlfa_mod(data5)

# too many parameters regularized

# Reg: 0.01 ---------------------------------------------------------------
# regularization parameters for item intercept and item slope, respectively
regular_lam <- c(.01, 0)
regular_type <- c("mcp","none")

mod1 <- mnlfa_mod(data1)
mod2 <- mnlfa_mod(data2)
mod3 <- mnlfa_mod(data3)
mod4 <- mnlfa_mod(data4)
mod5 <- mnlfa_mod(data5)

# So: set to 0.01

