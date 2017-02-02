#' Read CSV from the AODN portal.
#'
#' Returns a data.frame as is with a simple S3 class for future use.
#' @param u AODN CSV URL
#' @param ... arguments passed to methods
#'
#' @return raodn data frame
#' @export
#'
#' @examples
#'
#' d <- read_aodn_csv(collection_url)
#' #library(ggplot2)
#' # ggplot(d[d$pres < 100, ]) + aes(longitude, latitude, col = psal) + geom_point()
#' #ggplot(d) + aes(psal, -pres, col = temp) +
#' # geom_point() +
#' #  facet_wrap(~platform_number)
read_aodn_csv <- function(u, ...) {
 x <- readr::read_csv(u)
  structure(x, class = c("raodn", class(x)))
}

#' Example URL
#' @name collection_url
#' @rdname example-url
NULL




#tx <- "?typeName=imos:argo_profile_data&SERVICE=WFS&outputFormat=csv&REQUEST=GetFeature&VERSION=1.0.0&CQL_FILTER=INTERSECTS(position%2CPOLYGON((142.822265625%20-43.814453125%2C142.822265625%20-42.759765625%2C150.380859375%20-42.759765625%2C150.380859375%20-43.814453125%2C142.822265625%20-43.814453125)))%20AND%20oxygen_sensor%20%3D%20true"
#"       typeName=imos:argo_profile_data&SERVICE=WFS&outputFormat=csv&REQUEST=GetFeature&VERSION=1.0.0&CQL_FILTER=INTERSECTS(position%20POLYGON((-180%20-90,%20-180%2090,%20180%2090,%20180%20-90,%20-180%20-90)))"



#g <- x <- sf:::CPL_sfc_from_wkt("POLYGON((142.822265625 -43.814453125,142.822265625 -42.759765625,150.380859375 -42.759765625,150.380859375 -43.814453125,142.822265625 -43.814453125))")


#strsplit(URLdecode(tx), "&")

gsrv_build_url <- function(
  typeName = "imos:argo_profile_data",
  SERVICE = "WFS",
  outputFormat = "csv",
  REQUEST = "GetFeature",
  VERSION= "1.0.0",
  CQL_FILTER="POLYGON((-180 -90, -180 90, 180 90, 180 -90, -180 -90))") {
  sprintf("typeName=%s&SERVICE=%s&outputFormat=%s&REQUEST=%s&VERSION=%s&CQL_FILTER=INTERSECTS(position,%s)",
          typeName, SERVICE, outputFormat, REQUEST, VERSION, CQL_FILTER)
}

create_time_query <- function(x) {
  x1 <- x2 <- ""
  #AND juld >= '2016-08-16T00:00:00.000Z'
  if (is.finite(x[1])) x1 <- sprintf("AND juld >= %s", format(x[1], "%Y-%m-%dT%H:%M:%S%Z"))
  if (is.finite(x[2])) x2 <- sprintf("AND juld <= %s", format(x[2], "%Y-%m-%dT%H:%M:%S%Z"))
  sprintf("%s %s", x1, x2)
}
xrange <- function(x) c(x@xmin, x@xmax)
yrange <- function(x) c(x@ymin, x@ymax)

#' @importFrom methods new
#' @importFrom utils URLencode
aodn_build_url <- function(ext = new("Extent", xmin = -180, xmax = 180, ymin = -90, ymax = 90),
                           CQL_FILTER = sf::st_as_text(sf::st_polygon(list(as.matrix(expand.grid(xrange(ext), yrange(ext)))[c(1, 3, 4, 2, 1), ]))),
                           time_range = Sys.Date() - c(0, 2)) {
  time_query <- create_time_query(time_range)
  string <- gsrv_build_url(CQL_FILTER = CQL_FILTER)
  u <- sprintf("http://geoserver-123.aodn.org.au/geoserver/ows?%s %s", string, time_query)
  readr::read_csv(URLencode(u))
}
