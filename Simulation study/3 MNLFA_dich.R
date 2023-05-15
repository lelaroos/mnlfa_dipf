library(tidyverse)
library(mnlfa)

# set number of items and number of conditions
K <- 20
no_cond <- 18

# Load data ---------------------------------------------------------------
data_tot <- readRDS("RDS_objects/data_tot.RDS")
data <- unlist(data_tot, recursive = FALSE)

# Run MNLFA on data sets --------------------------------------------------
items <- paste0("i", 1:K)
maxit <- 30

# covariates for trait
formula_mean <- ~0 + xdich
formula_sd <- ~1

# moderation effects for items
formula_int <- ~1 + xdich
formula_slo <- ~1

# regularization parameters for item intercept and item slope, respectively
regular_lam <- c(.01, 0)
regular_type <- c("mcp","none")

# define function for fitting mnlfa with these inputs
mnlfa_mod <- function(data){
  mod <- mnlfa::mnlfa(dat = data, items = items, item_type="1PL", 
                      formula_int=formula_int, formula_slo=formula_slo, 
                      formula_mean=formula_mean, formula_sd=formula_sd, 
                      regular_lam=regular_lam, regular_type=regular_type,
                      conv = 1e-04)
  return(mod)
}

# fit MNLFA to all data sets 

models <- map(data, mnlfa_mod)

# saveRDS(models, "RDS_objects/MNLFA_models/dich_mods.RDS")
# models <- readRDS("RDS_objects/MNLFA_models/dich_mods.RDS")

# Obtain kappa estimates --------------------------------------------------

# function to obtain kappa estimates 

obtain_k <- function(model){
  est_k <- model$item %>% 
    filter(grepl("xdich",parm)) %>% # note: "xdich" is the name of the covariate
    select(est) 
  return(est_k)
}

# Obtain kappa's for each model 
kappa_est <- map(models, obtain_k)


# Perform clustering on kappa estimates -----------------------------------

# clustering function
clustering <- function(kappa){
  # distance matrix
  distmat <- dist(kappa, method = 'euclidean')
  
  # fitting hierarchical clustering model
  cl <- hclust(distmat, method = "average")
  
  # cut tree to form two distinct clusters
  final_cl <- cutree(cl, k = 2)
  
  return(final_cl)
}

# perform clustering over all models
cl_res <- map(kappa_est, clustering)

# Compare results with true clustering ------------------------------------
true_cls <- readRDS("RDS_objects/true_cls.RDS")

# Check if obtained and simulated clusters are identical
clusters <- list(cl_res, true_cls)
cl_check <- clusters %>% 
  pmap(identical)

# Create overview
# merge simulation repetitions together again
c <- split(cl_check, ceiling(seq_along(cl_check)/no_cond))

# create dataframe
cl_df <- data.frame(map(c, unlist))

# add means
cl_final <- cl_df %>%
  mutate(no_correct = rowSums(.)) %>% 
  select(no_correct)


# Obtain gamma estimates --------------------------------------------------

# function to obtain gamma estimates
obtain_gamma <- function(model){
  gamma_est <- model$trait %>% 
    filter(grepl("xdich",par)) %>% 
    select(est) %>% 
    as.numeric()
  return(gamma_est)
}

gamma_est <- map(models, obtain_gamma)

# Create overview
# merge simulation repetitions together again
g <- split(gamma_est, ceiling(seq_along(gamma_est)/no_cond))

# create dataframe
gamma_df <- data.frame(map(g, unlist))

# obtain means
gamma_final <- gamma_df %>% 
  mutate(av_gam = rowMeans(.)) %>% 
  select(av_gam)


# Run time ----------------------------------------------------------------

time <- function(mod){
  return(difftime(mod$time$s2, mod$time$s1, units = "secs"))
}

times <- map(models, time)

# Create overview
# merge simulation repetitions together again
t <- split(times, ceiling(seq_along(times)/no_cond))

# create dataframe
times_df <- data.frame(map(t, unlist))

# obtain means
t_final <- times_df %>% 
  mutate(av_t = round(rowMeans(.))) %>% 
  select(av_t)


# Save results ------------------------------------------------------------
results <- cbind(cl_final, gamma_final, t_final)
saveRDS(results, "RDS_objects/Results/dich_res.RDS")

