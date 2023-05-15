library(tidyverse)
library(mnlfa)

pisa43_wide <- readRDS("RDS objects/pisa43_wide.RDS")

items <- pisa43_wide %>%
  select(starts_with('M')) %>% 
  colnames()

# moderation effects for items
formula_int <- ~1 + ESCS_dich
formula_slo <- ~1

# covariates for trait
formula_mean <- ~ 0 + ESCS_dich
formula_sd <- ~1


# Mod1 : 0.25 reg --------------------------------------------

# regularization parameters 
regular_lam <- c(.25, 0)
regular_type <- c("mcp","none")

mod1 <- mnlfa::mnlfa(dat=pisa43_wide, items = items, 
                     item_type="1PL", formula_int=formula_int,
                     formula_slo=formula_slo, formula_mean=formula_mean, 
                     formula_sd=formula_sd,
                     regular_lam=regular_lam, regular_type=regular_type,
                     conv = 1e-04)
mod1$ic$AIC

# All DIF parameters went to 0


# Mod2: 0.1 reg ---------------------------------------------

# regularization parameters 
regular_lam <- c(.1, 0)
regular_type <- c("mcp","none")

mod2 <- mnlfa::mnlfa(dat=pisa43_wide, items = items, 
                     item_type="1PL", formula_int=formula_int,
                     formula_slo=formula_slo, formula_mean=formula_mean, 
                     formula_sd=formula_sd,
                     regular_lam=regular_lam, regular_type=regular_type,
                     conv = 1e-04)
mod2$ic$AIC

# All DIF parameters went to 0 again

# Mod 3: 0.05 reg ---------------------------------------------------------

# regularization parameters 
regular_lam <- c(.05, 0)
regular_type <- c("mcp","none")

mod3 <- mnlfa::mnlfa(dat=pisa43_wide, items = items, 
                     item_type="1PL", formula_int=formula_int,
                     formula_slo=formula_slo, formula_mean=formula_mean, 
                     formula_sd=formula_sd,
                     regular_lam=regular_lam, regular_type=regular_type,
                     conv = 1e-04)
mod3$ic$AIC

# All DIF parameters went to 0 again

# Mod 4: 0.03 reg ---------------------------------------------------------

# regularization parameters 
regular_lam <- c(.03, 0)
regular_type <- c("mcp","none")

mod4 <- mnlfa::mnlfa(dat=pisa43_wide, items = items, 
                     item_type="1PL", formula_int=formula_int,
                     formula_slo=formula_slo, formula_mean=formula_mean, 
                     formula_sd=formula_sd,
                     regular_lam=regular_lam, regular_type=regular_type,
                     conv = 1e-04)
mod4$ic$AIC

# All DIF parameters went to 0 again

# Mod 5: 0.02 reg ---------------------------------------------------------

# regularization parameters 
regular_lam <- c(.02, 0)
regular_type <- c("mcp","none")

mod5 <- mnlfa::mnlfa(dat=pisa43_wide, items = items, 
                     item_type="1PL", formula_int=formula_int,
                     formula_slo=formula_slo, formula_mean=formula_mean, 
                     formula_sd=formula_sd,
                     regular_lam=regular_lam, regular_type=regular_type,
                     conv = 1e-04)
mod5$ic$AIC

# All DIF parameters went to 0 again 


# Mod 4: 0.01 reg ---------------------------------------------------------

# regularization parameters 
regular_lam <- c(.01, 0)
regular_type <- c("mcp","none")

mod4 <- mnlfa::mnlfa(dat=pisa43_wide, items = items, 
                     item_type="1PL", formula_int=formula_int,
                     formula_slo=formula_slo, formula_mean=formula_mean, 
                     formula_sd=formula_sd,
                     regular_lam=regular_lam, regular_type=regular_type,
                     conv = 1e-04)
mod4$ic$AIC

# So: set to 0.01





