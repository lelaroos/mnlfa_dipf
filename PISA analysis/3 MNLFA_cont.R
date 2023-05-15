library(tidyverse)
library(mnlfa)
library(dendextend)

pisa43_wide <- readRDS("RDS objects/pisa43_wide.RDS")

# MNLFA package -----------------------------------------------------------
items <- pisa43_wide %>%
  select(starts_with('M')) %>% 
  colnames()

# covariates for trait
formula_mean <- ~ 0 + ESCS
formula_sd <- ~1

# regularization parameters 
regular_lam <- c(.001, 0)
regular_type <- c("mcp","none")

# moderation effects for items
formula_int <- ~1 + ESCS
formula_slo <- ~1

mod <- mnlfa::mnlfa(dat=pisa43_wide, items = items, 
                     item_type="1PL", formula_int=formula_int,
                     formula_slo=formula_slo, formula_mean=formula_mean, 
                     formula_sd=formula_sd,
                     regular_lam=regular_lam, regular_type=regular_type,
                     conv = 1e-04)

# saveRDS(mod, "RDS objects/cont_mod.RDS")

mod <- readRDS("RDS objects/cont_mod.RDS")
# Obtain kappa estimates --------------------------------------------------

item_out <- mod$item

cov_eff <- item_out %>% 
  filter(grepl("ESCS",parm))

kappa_est <- cov_eff$est
names(kappa_est) <- cov_eff$item

# Hierarchical clustering -------------------------------------------------

# set number of clusters
cln <- 4

# distance matrix
dist_mat <- dist(kappa_est, method = 'euclidean')

# hierarchical clustering
hier_cl <- hclust(dist_mat, method = "average")


# Create dendrogram -------------------------------------------------------

# create dendrogram
dend <- as.dendrogram(hier_cl)

# Plotting dendrogram
cols <- c("blue","red","green4", "purple3")

dend %>%
  set("branches_k_color", cols, k = cln) %>% # Color branches by groups
  set("labels_cex", 1) %>%  # Change label size  
  plot(ylab = "Distance",
       ylim = c(0, 0.25))

dend %>% rect.dendrogram(k=cln, border = 8, lty = 5,
                         lower_rect = 0)

# Save clustering ---------------------------------------------------------

# Cutting tree by no. of clusters
cut <- cutree(hier_cl, k = cln)

# sort by item_id
by_name <- cut[sort(names(cut))]

saveRDS(by_name, "RDS objects/cls_cont.RDS")

  