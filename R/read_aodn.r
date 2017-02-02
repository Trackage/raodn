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
