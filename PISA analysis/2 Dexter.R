library(tidyverse)
library(dexter)
library(haven)
library(knitr)
library(xtable)

pisa43 <- readRDS("RDS objects/pisa43.RDS")

pisa43 <- pisa43 %>% 
  drop_na(ESCS) %>%  # Remove NA's on ESCS
  mutate(item_score = case_when(is.na(item_score) ~ 0, # NA = score 0
                                item_score == 2 ~ 1, # change polytomous to dichotomous
                                TRUE ~ item_score)) %>% 
  mutate(ESCS_g = ntile(ESCS, 100)) # split ESCS into 100 groups
  

# Start dexter ---------------------------------------------------------
# rename student id
pisa43 <- pisa43 %>%  
  rename(person_id = CNTSTUID) %>% 
  mutate(person_id = as.character(person_id))

# Start dexter project 

responses = pisa43 %>% 
  select(person_id, booklet_id, item_id, item_score, ESCS_g) %>% 
  mutate(response = item_score)

scoring_rules = responses %>% 
  distinct(item_id, response, item_score)

design = responses %>% 
  distinct(booklet_id, item_id)

person_properties = responses %>% 
  distinct(person_id, ESCS_g)

# database
db = start_new_project(scoring_rules, ':memory:')
add_response_data(db = db, data = responses, design = design)
add_person_properties(db, person_properties = person_properties)

# TIA ---------------------------------------------------------------------

tia = tia_tables(db)

# Create table items
tia_items <- tia$items %>% 
  select(-booklet_id, -max_score, -n_persons, -pvalue)

kable(tia_items, digits = 2, format = 'latex')

# Create table booklet
tia_b <- tia$booklets %>% 
  select(-c(booklet_id, n_items, max_booklet_score, n_persons))

kable(tia_b, digits = 2, format = 'latex')

# Interaction model ---------------------------------------------------------------
items <- sort(unique(scoring_rules$item_id))

#int_mod <- fit_inter(db)
#saveRDS(int_mod, "RDS Objects/int_mod.RDS")
int_mod <- readRDS("RDS Objects/int_mod.RDS")

# Create table
int_tab <- coef(int_mod) %>% 
  select(-item_score, -beta_rasch, -fit_IM, -SE_sigma) %>% 
  arrange(item_id)

print(xtable(int_tab), 
      include.rownames=FALSE)

# Plots
for (i in items){
  plot(int_mod, i)
}

# Save plots
for (k in 1:length(items)){
  file_name = paste("Figures/fit_inter/", k, "_plot_inter", items[k], ".jpeg", sep="")
  jpeg(filename = file_name,width = 600, height = 600, quality = 100)
  plot(int_mod, items[k])
  dev.off()
}

# Rasch Model / 1PLM -------------------------------------------------------------------

#enorm_mod <- fit_enorm(db)
#saveRDS(enorm_mod, "RDS Objects/enorm_mod.RDS")
enorm_mod <- readRDS("RDS Objects/enorm_mod.RDS")

# Create table
enorm_tab <- coef(enorm_mod) %>% 
  select(-item_score) %>% 
  arrange(item_id)

print(xtable(enorm_tab), 
      include.rownames=FALSE)

# Plots
for (i in items){
  plot(enorm_mod, i)
}

# Save plots
for (k in 1:length(items)){
  file_name = paste("Figures/fit_enorm/", k, "_plot_enorm", items[k], ".jpeg", sep="")
  jpeg(filename = file_name,width = 600, height = 600, quality = 100)
  plot(enorm_mod, items[k])
  dev.off()
}


# Plot difficulty estimates per ESCS group --------------------------------

# get response data
resp = get_responses(db, columns=c('person_id', 'item_id', 
                                   'item_score', 'ESCS_g'))

# fit Rasch Model in each group
par = list(NA)
par = resp %>%
  group_by(escs_g) %>%
  do({coef(fit_enorm(.))})

# Tibble of difficulty estimates
diff_est = tibble(
  item_id = par$item_id,
  group= par$escs_g,
  beta = par$beta)

# Plot estimates per ESCS group
ggplot(diff_est, aes(x = beta, y = group, col = as.factor(item_id)))+
  xlab("Estimated item difficulty")+
  ylab("ESCS group")+
  geom_point()+
  theme_bw()+
  theme(legend.position = "right")+
  labs(col = "Item id")
