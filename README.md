# rimos
get stuff from IMOS/AODN in R

u <- "http://geoserver-123.aodn.org.au/geoserver/ows?typeName=imos:argo_profile_data&SERVICE=WFS&outputFormat=JSON&REQUEST=GetFeature&VERSION=1.0.0&CQL_FILTER=INTERSECTS(position%2CPOLYGON((147.07397460938%20-44.989990234375%2C147.07397460938%20-43.891357421875%2C148.15063476563%20-43.891357421875%2C148.15063476563%20-44.989990234375%2C147.07397460938%20-44.989990234375)))%20AND%20oxygen_sensor%20%3D%20true"


system(sprintf("ogrinfo '%s'", u))

library(rgdal)
x <- readOGR(u, "OGRGeoJSON")



