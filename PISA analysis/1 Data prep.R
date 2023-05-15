library(tidyverse)
library(haven)

pisa43 <- readRDS("RDS objects/pisa43.RDS")


pisa43$ESCS <- as.numeric(pisa43$ESCS)


# Initial ESCS analysis ---------------------------------------------------


# To wide format
pisa43_w <- pisa43 %>% 
  pivot_wider(
    id_cols = c(CNT,CNTSCHID,CNTSTUID, ESCS),
    names_from = item_id,
    values_from = item_score)

# ESCS is the (cont) variable of interest
summary(pisa43_w$ESCS) # count NA's

# Plot ESCS
ggplot(pisa43_w, aes(x=ESCS))+
  geom_density(color="black", fill="lightgrey")+ 
  geom_vline(aes(xintercept=mean(ESCS, na.rm = T)),
              color="red", linetype="dashed")+
  theme_bw()

# Identify polytomously scored items
max <- apply(pisa43_w[,5:26], 2, max, na.rm = T) #calc max
max


# Data preparation --------------------------------------------------------

# Remove NA's on ESCS and dichotomize scores
pisa43 <- pisa43 %>% 
  drop_na(ESCS) %>%  # Remove NA's on ESCS
  mutate(item_score = case_when(is.na(item_score) ~ 0, # NA = score 0
                                item_score == 2 ~ 1, # change polytomous to dichotomous
                                TRUE ~ item_score)) 

# Dichotomize ESCS
pisa43 <- pisa43 %>% 
  mutate(ESCS_dich = cut_number(ESCS, n = 2, labels = FALSE, 
                                .after = ESCS))
 
table(pisa43$ESCS_dich)

# To wide format
pisa43_wide <- pisa43 %>% 
  pivot_wider(
    id_cols = c(CNT,CNTSCHID,CNTSTUID, ESCS, ESCS_dich),
    names_from = item_id,
    values_from = item_score)

pisa43_wide <- as.data.frame(pisa43_wide)

saveRDS(pisa43_wide, "RDS Objects/pisa43_wide.RDS")

