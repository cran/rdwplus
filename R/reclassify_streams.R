#' Reclassify streams into various formats
#' @description Re-format a stream raster.
#' @param stream Name of a streams raster in the current GRASS mapset. This can be the output from \code{rasterise_stream}. The raster should have NoData values for all non-stream cells. Stream cells can have any other value.
#' @param out The output file.
#' @param out_type Either 'zeros_to_nodata', 'binary', 'unary', or 'none'. See Details below
#' @param overwrite A logical indicating whether the output should be allowed to overwrite any existing files. Defaults to \code{FALSE}.
#' @return Nothing. A file with the name \code{out} will be written to the current GRASS mapset. This raster will be in unsigned integer format.
#' @details 
#' 
#' Given a streams raster, this function will either create a binary streams raster (0 for non-stream cells and 1 for stream cells) or a unary streams raster (1 for stream cells and NoData for all other cells). Another option is to reclassify the streams raster such that stream cells are given the value NoData and non-stream cells are given the value 1.
#' 
#' Do not use raster names containing dashes/hyphens. The underlying call to \code{r.calc} will crash if the raster name contains these symbols because they are misinterpreted as math symbols.
#' 
#' @examples
#' # Will only run if GRASS is running
#' if(check_running()){
#' # Retrieve paths to data sets
#'dem <- system.file("extdata", "dem.tif", package = "rdwplus")
#'lus <- system.file("extdata", "landuse.tif", package = "rdwplus")
#'sts <- system.file("extdata", "site.shp", package = "rdwplus")
#'stm <- system.file("extdata", "streams.shp", package = "rdwplus")
#'
#' # Set environment 
#'set_envir(dem)
#'
#'# Get other data sets (stream layer, sites, land use, etc.)
#'raster_to_mapset(lus)
#'vector_to_mapset(c(stm, sts))
#'
#'# Reclassify streams
#'out_stream <- paste0(tempdir(), "/streams.tif")
#'rasterise_stream("streams", out_stream, TRUE)
#'reclassify_streams("streams.tif", "streams01.tif", overwrite = TRUE)
#' }
#' @export
reclassify_streams <- function(stream, out, out_type = "binary", overwrite = FALSE){
  
  # Check that grass is running
  running <- check_running()
  if(!running) stop("No active GRASS session. Program halted.")
  
  # Check out_type
  if(!out_type %in% c("zeros_to_nodata", "binary", "unary","none")) stop("Invalid option for argument out_type. Must be either 'binary', 'unary', or 'none'.")
  
  # Reclassify based on out_type
  if(out_type == "zeros_to_nodata"){
    # All cells with a value of zero will be reclassified to have a value of NoData
    zeros_to_nodata(stream, out, overwrite)
  }
  if(out_type == "binary"){
    # Ones for stream
    # Zeros for non-stream
    binary(stream, out, overwrite)
  } 
  if(out_type == "none"){
    # NoData for stream
    none(stream, out, overwrite)
  }
  if(out_type == "unary"){
    # Ones for stream
    unary(stream, out, overwrite)
  }
  
  # Return nothing 
  invisible()
  
}