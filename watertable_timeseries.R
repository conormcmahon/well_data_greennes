
library(tidyverse)
library(raster)
library(rgdal)
library(janitor)

# Load Data
#    Raster of Ground Elevation
DEM <- raster(here::here("data","dem_mosaic_10m.tif"))
#    Dataframe with well-specific information
well_metadata <- read_csv(here::here("data","GWStation_20210304134118.csv")) %>% 
  janitor::clean_names()
well_points <- SpatialPointsDataFrame(coords=(well_metadata[,c("longitude","latitude")]),
                                      data=well_metadata,
                                      proj4string = crs("+proj=longlat +datum=WGS84 +no_defs"))
well_points <- spTransform(well_points, crs(DEM))
well_points$DEM <- raster::extract(DEM, well_points)
#    Dataframe with measurements of water height
well_levels <- read_csv(here::here("data","GWLevel_20210304134118.csv")) %>% 
  janitor::clean_names()
# well_levels <- read_csv("C:/Users/conor/Downloads/groundwater_santa_ynez/GWLevel_santa_ynez.csv") %>% janitor::clean_names()
#       Clean up date formatting
well_levels$msmt_date <- gsub("/","-",well_levels$msmt_date)
well_levels$msmt_date <- sub("\\ .*", "", well_levels$msmt_date)
well_levels$msmt_date <- lubridate::mdy(well_levels$msmt_date)
well_levels$year <- lubridate::year(well_levels$msmt_date)
well_levels$month <- lubridate::month(well_levels$msmt_date)
well_levels$day <- lubridate::day(well_levels$msmt_date)
well_levels$day_of_year <- lubridate::yday(well_levels$msmt_date)
#    How many observations per year? 
annual_data <- well_levels %>% 
  group_by(year) %>%
  summarize(count = n(),
            mean_height = mean(rpe-rdng_rp, na.rm=TRUE),
            stdev_hegith = sd(rpe-rdng_rp, na.rm=TRUE),
            median_hegith = median(rpe-rdng_rp, na.rm=TRUE))
plot(annual_data$year, annual_data$count)
# Plot locations of wells from a particular year
plot(well_points[well_points$site_code %in% well_levels[well_levels$year==2015,]$site_code,])
# Get a timeseries from a single well with the most years covered:
site_data <- well_levels %>% group_by(site_code) %>% summarize(count = length(unique(year)), 
                                                               mean_height = mean(rpe-rdng_rp, na.rm=TRUE), 
                                                               stdev_height = mean(rpe-rdng_rp, na.rm=TRUE))
longest_series_site <- as.character(site_data[which(site_data$count == max(site_data$count))[[1]],][1,1])
ggplot(well_levels[well_levels$site_code==longest_series_site,]) + 
  geom_point(aes(x=year, y=rpe-rdng_rp, col=month)) + 
  scale_color_continuous(viridis(10)) + 
  xlab("Year") +
  ylab("Water Table Elevation")
annual_data_longest <- well_levels[well_levels$site_code==longest_series_site,] %>% 
  group_by(year) %>%
  summarize(mean_height = mean(rpe-rdng_rp))
ggplot(annual_data_longest) + 
  geom_point(aes(x=year, y=mean_height)) + 
  scale_color_continuous(viridis(10)) + 
  xlab("Year") +
  ylab("Water Table Elevation")
well_levels$height_resid <- rep(0, nrow(well_levels))
well_levels$height_z <- rep(0, nrow(well_levels))
for(record in 1:nrow(well_levels))
{
  well_levels[record,]$height_resid <- well_levels[record,]$rpe - well_levels[record,]$rdng_rp - 
    site_data[site_data$site_code == well_levels[record,]$site_code,]$mean_height
  well_levels[record,]$height_z <- well_levels[record,]$height_resid / site_data[site_data$site_code == well_levels[record,]$site_code,]$stdev_height
}
ggplot(well_levels) + geom_boxplot(aes(x=year,y=height_resid,group=year))
annual_data$height_resid <- (well_levels %>% group_by(year) %>% summarize(mean=mean(height_resid,na.rm=TRUE)))$mean
annual_data$height_resid_med <- (well_levels %>% group_by(year) %>% summarize(median=median(height_resid,na.rm=TRUE)))$median
annual_data$height_z <- (well_levels %>% group_by(year) %>% summarize(z=mean(height_z,na.rm=TRUE)))$z
#    Check well elevation
well_levels_stat <- well_levels %>%
  group_by(site_code) %>%
  summarize(rpe = mean(rpe, na.rm=TRUE),
            gse = mean(gse, na.rm=TRUE),
            rdng_ws = mean(rdng_ws, na.rm=TRUE),
            mean_water = mean(rdng_rp),
            sd_water = sd(rdng_rp))
well_points_hgt <- merge(well_levels_stat, well_points, by="site_code")