aodn_wfs <- function() {
  sprintf("WFS:https://geoserver-123.aodn.org.au/geoserver/ows?SERVICE=WFS&REQUEST=GetFeature&VERSION=1.0.0&userId=%s", Sys.getenv("AODN_USER"))
}

aodn_layers <- function() {
  vapour::vapour_layer_names(aodn_wfs())
}


aodn_ccpr <- function() {
  cpr <- tibble::as_tibble(vapour::vapour_read_fields(aodn_wfs(), "imos:cpr_zooplankton_abundance_raw_data"))
  cpr
}
