###======================================================### 
###    This script performs the process of downloading   ### 
###  occurrences records from GBIF by groups of orders   ### 
###               Cristina Ronquillo 2025                ### 
###======================================================### 
# Load packages
library(rgbif)
library(tidyverse)

mainDir <- "" # write your own path
setwd(mainDir)

# Download occurrences from GBIF - function
# 1) Create a list of scientific names 
list <- c('Cycadopsida', 'Ginkgoopsida')

# 2) Check the name into the gbif backbone and retrieve the usageKey
gbif_taxon_keys <- name_backbone_checklist(list) %>% # match to backbone
                    filter(!matchType == "NONE") %>% # get matched names
                      pull(usageKey)

# 3) Download occurrence based on the key
occ_download(pred_in("taxonKey", gbif_taxon_keys),
             pred_in("occurrenceStatus","PRESENT"), # avoid absences
             pred("hasCoordinate", TRUE), # only records with coordinates values
             pred("hasGeospatialIssue", FALSE), # records with no geospatial issue
             pred_not(pred_in("BASIS_OF_RECORD", # e.g. discard fossils
                              c("FOSSIL_SPECIMEN"))),
             format = "SIMPLE_CSV", # GBIF format - 50 fields
             user = '', # write your GBIF credentials here
             pwd = '',
             email = '')

# 4) Wait until the download process finishes (you will receive an email also)
occ_download_wait('XXXXXXX-XXXXXXXXXXXXXXX') # HERE WRITE YOUR CODE

# 5) Assign the dataset to an object
data <- occ_download_get('XXXXXXX-XXXXXXXXXXXXXXX') %>% 
          occ_download_import()