setwd("D:/Boss/r_folder")

library(tidyverse)


icustays = read_csv('D:/F2023/mimic-iv-2.2/icu/icustays.csv') %>% 
  group_by(subject_id) %>% summarize(n=n())

#saveRDS(icustays, 'icustays_ids')

# ids of those diabetic patients stayed in ICU
dm_in_icu = read_csv('D:/F2023/mimic-iv-2.2/hosp/diagnosis_icd.csv') %>% 
  filter(subject_id %in% icustays$subject_id) %>% 
  filter(icd_code >= '250' & icd_code <= '259') %>%
  filter(icd_code != '25001') %>% 
  filter(icd_code !='25011') %>% 
  filter(icd_code !='25013') %>%
  filter(icd_code !='25040') %>%
  filter(icd_code !='25041') %>%
  filter(icd_code !='25043') %>%
  filter(icd_code !='25050') %>%
  filter(icd_code !='25051') %>%
  filter(icd_code !='25053') %>%
  filter(icd_code !='25061') %>%
  filter(icd_code !='25063') %>%
  filter(icd_code !='25071') %>%
  filter(icd_code !='25073') %>% 
  group_by(subject_id) %>% summarize(n = n()) %>% 
  select(-n)


# lab events for those diabetic patients 
labt_dm = read_csv('D:/F2023/mimic-iv-2.2/hosp/labevents.csv') %>% 
  filter(subject_id %in% dm_in_icu$subject_id)

# some stats
labt_dm %>%
  group_by(subject_id) %>% 
  summarise(n = n()) %>% 
  summary()

#saveRDS(labt_dm, 'labd_dm.rds')
LABD_DM = readRDS('labd_dm.rds')

cohort_ids = labd_dm %>% 
  group_by(subject_id) %>% count()
  
#saveRDS(cohort_ids, 'cohort_ids.rds')
COHORT_IDS = readRDS('cohort_ids.rds')

# profile for those diabetic patient
PROFILE = read_csv('D:/F2023/mimic-iv-2.2/hosp/patients.csv') %>% 
  filter(subject_id %in% COHORT_IDS$subject_id)

# is older than 40 ratio: No = 451, Yes = 11144
PROFILE %>% 
  mutate(isOlderThan40 = ifelse(anchor_age >= 45, 1, 0)) %>% 
  #filter(isOlderThan40 == 0)
  group_by(isOlderThan40) %>% count()


LABD_DM %>% head()

