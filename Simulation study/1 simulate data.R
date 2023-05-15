library(tidyverse)
library(knitr)
library(xtable)

# set seed
set.seed(8008)

K <- 20 # number of items
S <- 100 # number of simulations

# Define simulation parameters to vary ------------------------------------
N <- c(500, 1000, 2000) # sample size
DIF_kappa <- c(0.25, 0.5) # DIF strength
cl_k <- c(3, 6, 10) # Size of DIF cluster

# number of simulation conditions
no_cond <- length(N) * length(DIF_kappa) * length(cl_k)

# create lists of simulation parameters
N_col <- rep(N,length.out = no_cond, each = no_cond/length(N))
DIF_col <- rep(DIF_kappa, length.out = no_cond, each = length(cl_k))
cl_col <- rep(cl_k, length.out = no_cond)

# save as dataframe
par_df <- data.frame(N_col, DIF_col, cl_col)

# list of all simulation parameters
sim_par <- list(N_col, DIF_col, cl_col)

# Create list with cluster indicators -------------------------------------
tr_cl <- function(K, cl_k){
  true_cl <- c(rep(1, cl_k), rep(2, K - cl_k))
  return(as.integer(true_cl))
}

# save true clustering
true_cls <- cl_col %>% 
  map(tr_cl, K = K) %>% 
  rep(.,S)

# Create data sets --------------------------------------------------------

# function to simulate a single data set given a set of parameters
sim_data <- function(N, DIF, cl_k){
  
  K <- 20 # number of items
  
  # continuous covariate
  x <- rnorm(N, 0, 1)
  summary(x)
  
  # dichotomize covariate
  xdich <- cut_number(x, n = 2, labels = F)
  
  # split covariate into 4 groups
  xcat <- cut_number(x, n = 4, labels = F)
  
  # latent variable
  eta <- rnorm(N, 0, 1)
  
  ## intercepts 
  # baselines
  nu_0 <- rnorm(K,0, 1)
  
  # covariate effects
  kappa <- rep(0, K)
  kappa[1:cl_k] <- DIF
  
  # person-specific intercepts
  nu <- matrix(nrow = N, ncol = K)
  
  for (n in 1:N){
    for (k in 1:K){
      nu[n,k] <- nu_0[k] + kappa[k] * x[n]
    }
  }
  summary(nu)
  
  ## Expected values per person per item
  mu <- matrix(nrow = N, ncol = K)
  
  for (n in 1:N){
    for (k in 1:K){
      mu[n,k] <- exp(eta[n] + nu[n,k]) / (1 + exp(eta[n] + nu[n,k]))
    }
  }
  
  ## Response data
  Y <- matrix(nrow = N, ncol = K)
  
  for (n in 1:N){
    for (k in 1:K){
      Y[n,k] <- ifelse(mu[n,k] > runif(1,0,1), 1, 0)
    }
  }
  
  data <- as.data.frame(cbind(Y, x, xdich, xcat))
  # add column names
  colnames(data)[1:K] <- paste0("i", 1:K)
  
  # output data
  return(data)
}

# function to simulate data across a list of parameters
sim_cond <- function(sim_par){
  data <- sim_par %>% 
    pmap(sim_data)
  return(data)
}

# simulate all data 
data_tot <- replicate(n = S, 
            expr = sim_cond(sim_par), 
            simplify = FALSE)

# Save data, true clustering, and simulation parameters
saveRDS(data_tot, "RDS_objects/data_tot.RDS")
saveRDS(true_cls, "RDS_objects/true_cls.RDS")
saveRDS(par_df, "RDS_objects/par_df.RDS")
