library(BIEN)
library(data.table)
# currently i cannot run the full download on GDK; dependency issues (RGDAL
# makes BIEN installation impossible). create smaller download subsets instead.
# TAKES ABOUT 4.5h with a proper internet connection :]

# download occurrence number per BIEN species
# spec_counts = BIEN_occurrence_records_per_species() # if au network: make sure connection is 802.1x
# saveRDS(spec_counts, "spec_counts.rds")
spec_counts = readRDS("spec_counts.rds")

# collect the cut off points for 2 mio chunks for download
start=1
cuts=c()
for(i in 1:nrow(spec_counts)){
  tmp = sum(spec_counts$count[start:i])
  if(tmp>2000000){
    start <- i
    cuts= c(cuts, i) # save row numbers for cut offs
  }
  cat(i, "\r")
}
cuts = c(1,cuts) # add 1 for start

# # DOWNLOAD
# for(i in 1:(length(cuts)-1)){
#   chunk = BIEN_occurrence_species(
#     species = spec_counts$scrubbed_species_binomial[cuts[i]:cuts[i+1]], #
#     all.taxonomy = T)  
#   saveRDS(chunk, paste0("bien_", i, ".rds"))
#   cat(i, "\r")
#   rm(chunk)
# }






















# old download script all in one, only runs on cluster for size reasons
# tryCatch({
#   all_bien_occurrences <- BIEN:::.BIEN_sql("SELECT scrubbed_family,
#                                 scrubbed_species_binomial,
#                                 scrubbed_taxon_name_no_author,
#                                 scrubbed_author,
#                                 taxonobservation_id,
#                                 latitude,
#                                 longitude,
#                                 is_centroid
#                                 FROM view_full_occurrence_individual
#                                 WHERE is_geovalid = 1
#                                 AND observation_type IN ('plot', 'plot occurrence','specimen','literature','checklist', 'checklist occurrence')
#                                 AND higher_plant_group NOT IN ('Algae','Bacteria','Fungi')
#                                 AND is_cultivated_observation = 0
#                                 LIMIT 2000000")
#   print(dim(all_bien_occurrences)[1])
# })
# 
# 
# # Remove NAs
# all_bien_occurrences <- as.data.frame(all_bien_occurrences)
# cc <- which(complete.cases(all_bien_occurrences[,c("taxonobservation_id", "latitude", "longitude")]))
# all_bien_occurrences <- all_bien_occurrences[cc,]
# 
# all_bien_occurrences = setDT(all_bien_occurrences)
# date= gsub(" ", "_", date())
# saveRDS(all_bien_occurrences, paste0("bien_occurrences", gsub(" ", "_", date()), ".rds")
