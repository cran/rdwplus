% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/point_to_raster.R
\name{point_to_raster}
\alias{point_to_raster}
\title{Convert outlet of a watershed from shapefile format into raster format}
\usage{
point_to_raster(outlets, out, overwrite = FALSE, max_memory = 300)
}
\arguments{
\item{outlets}{A shapefile of outlets in the current GRASS mapset.}

\item{out}{The name of the output raster.}

\item{overwrite}{A logical indicating whether the output should be allowed to overwrite existing files. Defaults to \code{FALSE}.}

\item{max_memory}{Max memory used in memory swap mode (MB). Defaults to \code{300}.}
}
\value{
Nothing. A file called \code{out} will be created in the current GRASS mapset.
}
\description{
Given a shapefile of outlet(s), this function will convert its contents into a raster.
}
\examples{
# Will only run if GRASS is running
if(check_running()){

# Load data set
dem <- system.file("extdata", "dem.tif", package = "rdwplus")
sites <- system.file("extdata", "site.shp", package = "rdwplus")

# Set environment parameters and import data to GRASS
set_envir(dem)
vector_to_mapset(vectors = sites)

# Point to raster
point_to_raster(outlets = "site", out = "sites_rast.tif", overwrite = TRUE)

# Check conversion success
vibe_check()

}
}
