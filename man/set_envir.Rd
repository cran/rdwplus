% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/set_envir.R
\name{set_envir}
\alias{set_envir}
\title{Set environment parameters from a GIS layer.}
\usage{
set_envir(layer)
}
\arguments{
\item{layer}{A \code{Raster*} object or the file path to a GIS layer that should be used to set environment parameters such as cell size, extent, etc.}
}
\value{
Nothing. Displays current environment settings.
}
\description{
This function simplifies the process of setting up a GRASS environment with parameters such as cell snapping, size and mapset extent.
}
\examples{
# Will only run if GRASS is running
if(check_running()){

# Load data set
dem <- system.file("extdata", "dem.tif", package = "rdwplus")

# Set environment 
set_envir(dem)

# Get environment metadata
gmeta()

}
}
