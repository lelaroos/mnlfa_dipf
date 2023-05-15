library(tidyverse)
library(mnlfa)

pisa43_wide <- readRDS("RDS objects/pisa43_wide.RDS")

items <- pisa43_wide %>%
  select(starts_with('M')) %>% 
  colnames()

# covariates for trait
formula_mean <- ~ 0 + ESCS
formula_sd <- ~1

# moderation effects for items
formula_int <- ~1 + ESCS
formula_slo <- ~1

# Mod0: 0.25 reg ---------------------------------------------

# regularization parameters 
regular_lam <- c(.25, 0)
regular_type <- c("mcp","none")

mod0 <- mnlfa::mnlfa(dat=pisa43_wide, items = items, 
                     item_type="1PL", formula_int=formula_int,
                     formula_slo=formula_slo, formula_mean=formula_mean, 
                     formula_sd=formula_sd,
                     regular_lam=regular_lam, regular_type=regular_type,
                     conv = 1e-04)
mod0$ic$AIC

# too many parameters are regularized


# Mod1: 0.01 reg ---------------------------------------------

# regularization parameters 
regular_lam <- c(.01, 0)
regular_type <- c("mcp","none")

mod1 <- mnlfa::mnlfa(dat=pisa43_wide, items = items, 
                     item_type="1PL", formula_int=formula_int,
                     formula_slo=formula_slo, formula_mean=formula_mean, 
                     formula_sd=formula_sd,
                     regular_lam=regular_lam, regular_type=regular_type,
                     conv = 1e-04)
mod1$ic$AIC

# too many parameters are regularized


# Mod2: 0.005 reg --------------------------------------------

# regularization parameters 
regular_lam <- c(.005, 0)
regular_type <- c("mcp","none")

mod2 <- mnlfa::mnlfa(dat=pisa43_wide, items = items, 
                     item_type="1PL", formula_int=formula_int,
                     formula_slo=formula_slo, formula_mean=formula_mean, 
                     formula_sd=formula_sd,
                     regular_lam=regular_lam, regular_type=regular_type,
                     conv = 1e-04)
mod2$ic$AIC

# too many parameters are regularized

# Mod3: 0.001 reg --------------------------------------------

# regularization parameters 
regular_lam <- c(.001, 0)
regular_type <- c("mcp","none")

mod3 <- mnlfa::mnlfa(dat=pisa43_wide, items = items, 
                     item_type="1PL", formula_int=formula_int,
                     formula_slo=formula_slo, formula_mean=formula_mean, 
                     formula_sd=formula_sd,
                     regular_lam=regular_lam, regular_type=regular_type,
                     conv = 1e-04)
mod3$ic$AIC

# so: set to 0.001

