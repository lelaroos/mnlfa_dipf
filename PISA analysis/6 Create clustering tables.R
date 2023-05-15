library(tidyverse)
library(xtable)
library(knitr)


pisa43 <- readRDS("RDS objects/pisa43.RDS")

pisa43 <- pisa43 %>% 
  drop_na(ESCS) %>%  # Remove NA's on ESCS
  mutate(item_score = case_when(is.na(item_score) ~ 0, # NA = score 0
                                item_score == 2 ~ 1, # change polytomous to dichotomous
                                TRUE ~ item_score)) 

# Expected clustering -----------------------------------------------------
domains <- pisa43 %>% 
  distinct(item_id, content) %>% 
  arrange(.,content)

# creat latex table
print(xtable(domains), 
      include.rownames=FALSE)


# Add clustering that was found -------------------------------------------
cls_cont <- readRDS("RDS objects/cls_cont.RDS")
cls_dich <- readRDS("RDS objects/cls_dich.RDS")

# clustering results
cls_res <- as.data.frame(cbind(cls_cont, cls_dich)) %>% 
  rownames_to_column(., "item_id")

# put together and sort
cls <- domains %>% 
  left_join(cls_res, by = "item_id") %>% 
  arrange(.,cls_dich) %>% 
  arrange(.,cls_cont)

# to latex table
print(xtable(cls), 
      include.rownames=FALSE)
