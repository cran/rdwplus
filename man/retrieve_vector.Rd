% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/retrieve_vector.R
\name{retrieve_vector}
\alias{retrieve_vector}
\title{Write a vector layer from the current GRASS mapset to file}
\usage{
retrieve_vector(layer, out_layer, overwrite = FALSE, ...)
}
\arguments{
\item{layer}{The name of the vector layer in the GRASS mapset that is to be written out.}

\item{out_layer}{The name of the shapefile to be created (with .shp file extension).}

\item{overwrite}{A logical indicating whether the output from this function should be allowed to overwrite any existing files. Defaults to \code{FALSE}.}

\item{...}{Additional arguments to \code{v.out.ogr}.}
}
\value{
Nothing.
}
\description{
This function writes a GRASS mapset vector layer (like a shapefile) to file.
}
\examples{
# Will only run if GRASS is running
if(check_running()){

# Load data set
dem <- system.file("extdata", "dem.tif", package = "rdwplus")
stream_shp <- system.file("extdata", "streams.shp", package = "rdwplus")

# Set environment parameters and import data to GRASS
set_envir(dem)
vector_to_mapset(vectors = stream_shp)

# Retrieve raster 
out_name <- paste0(tempdir(), "/", "retrieved_streams.shp")
retrieve_vector("streams", out_layer = out_name, overwrite = TRUE)

}
}
