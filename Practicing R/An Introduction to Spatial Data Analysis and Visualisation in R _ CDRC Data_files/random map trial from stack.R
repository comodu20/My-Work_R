library(sf)

# the given data above
my.df <- read.table(text="
                    longitude    latitude
                    128.6979    -7.4197
                    153.0046    -4.7089
                    104.3261    -6.7541
                    124.9019    4.7817
                    126.7328    2.1643
                    153.2439    -5.6500
                    142.8673    23.3882
                    152.6890    -5.5710",
                    header=TRUE)

# Convert data frame to sf object
my.sf.point <- st_as_sf(x = my.df, 
                        coords = c("longitude", "latitude"),
                        crs = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")

# simple plot
plot(my.sf.point)

# interactive map:
library(mapview)
mapview(my.sf.point)

# convert to sp object if needed
my.sp.point <- as(my.sf.point, "Spatial")
