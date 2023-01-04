##################################
# Small data object construction #
##################################

setwd('C:/Users/vince/OneDrive/Documents/WD/Programming/Shiny/package/SQE')
library(here)
here()

#### main dataset ----

setwd('C:/Users/vince/OneDrive/Documents/WD/ICRISAT/BCNAM/sorghum_BCNAM_pipeline/results/database')
load(file = 'database.RData')

# list of unique QTL positions
QTL_list <- as.list(unique(DB$QTL_un_id))
names(QTL_list) <- unique(DB$QTL_un_id)


# Best EC stat
setwd('C:/Users/vince/OneDrive/Documents/WD/ICRISAT/BCNAM/Results/pheno_x_EC')
load('EC_best_list.RData')
tr_nm <- c('FLAG', 'PH', 'PED', 'PAN', 'YIELD')
for(i in 1:length(EC_best_list)){names(EC_best_list[[i]]) <- tr_nm}

# list of EC matrix Mali
setwd('C:/Users/vince/OneDrive/Documents/WD/ICRISAT/BCNAM/data/climate/met_data_Mali')
load(file = 'met_list_all_grid_ext.RData')
load(file = 'lat_lon.RData')

setwd('C:/Users/vince/OneDrive/Documents/WD/ICRISAT/BCNAM/data/Mali_map')
load('Mali_layer.RData')



#### smallare data objects ----

# list of possible traits
trait_list <- list(`Flag leaf appearance` = 'FLAG',
                  `Plant height` = 'PH',
                  `Peduncle length` = 'PED',
                  `Panicle length` = 'PAN',
                  `Grain weight` = 'GWGH',
                  `Grain yield` = 'YIELD')

chr_list <- vector(mode = 'list', length = 10)
for(i in 1:10) chr_list[[i]] <- i
names(chr_list) <- as.character(1:10)

pop_list <- list(`Grinkan 2012` = 'GR2012',
                   `Grinkan 2013` = 'GR2013',
                   `Kenin-Keni 2012` = 'KK2012',
                   `Kenin-Keni 2013` = 'KK2013')

unit_lk <- c('[dd]', '[cm]', '[cm]', '[cm]', '[g]', '[kg/ha]') # need to be defined at a higher level (later)
names(unit_lk) <- c('FLAG', 'PH', 'PAN', 'PED', 'GWGH', 'YIELD')

tr_nm_ext <- c('Flag leaf', 'Plant height', 'Panicle length', 'Peduncle length',
               'Grain weight', 'Grain yield')
names(tr_nm_ext) <- c('FLAG', 'PH', 'PAN', 'PED', 'GWGH', 'YIELD')

EC_ref <- c('rain', 'hum', 'VPD', 'SPV', 'ETP', 'PETP', 'Tmin', 'Tmax',
            'Trange', 'DD', 'FRUE', 'hSun', 'photoperiod', 'solarRad', 'photothermal')

c_EC <- paste0(EC_ref, "_sign")
# c_M <- c("pop", "par", "log10_main", "log10_QxE")

EC_fct_lk <- c('sum', rep('mean', 8), 'sum', 'mean', 'sum', 'mean', 'sum', 'sum')
names(EC_fct_lk) <- EC_ref

setwd(here())

usethis::use_data(DB, EC_best_list, lat_lon, met_list_ext, Mali_layer, trait_list,
                  chr_list, pop_list, unit_lk, tr_nm_ext, c_EC, EC_fct_lk, QTL_list,
                  overwrite = TRUE, internal = TRUE)
