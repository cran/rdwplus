#' A function to plot a raster from the current GRASS mapset
#' @description Given the name of a raster in the current GRASS mapset, this function will plot it as a \code{stars} object.
#' @param x The name of an object in the current GRASS mapset.
#' @param colours Optional. A colour scale. If not supplied, the default settings in \code{plot.stars} is used. If supplied, \code{length(colours)} must be less than or equal to the number of unique values in the raster.
#' @param out_x Optional. If supplied, the function makes a call to \code{\link{retrieve_raster}} and writes out the raster to the file path \code{out_x}. Otherwise the function will write the layer to \code{tempdir}.
#' @param ... Additional arguments to \code{plot.stars}.
#' @return Nothing.
#' @examples 
#' # Will only run if GRASS is running
#' # You should load rdwplus and initialise GRASS via the initGRASS function
#' if(check_running()){
#' 
#' # Load data set
#' dem <- system.file("extdata", "dem.tif", package = "rdwplus")
#' 
#' # Set environment 
#' set_envir(dem)
#' 
#' # Plot
#' plot_GRASS("dem.tif") # argument must match name of data set in the mapset
#' plot_GRASS("dem.tif", heat.colors(10)) # with different colour scale
#' 
#' }
#' @export
plot_GRASS <- function(x, colours, out_x, ...){
  
  # Check if GRASS is running
  if(!check_running()) stop("There is currently no valid GRASS session. Program halted.")
  
  # Retrieve the raster from the mapset
  if(missing(out_x)){
    out_x <- paste0(tempdir(), "/", x)
    retrieve_raster(x, out_x, TRUE) # allow overwrite of temporary files
  } else {
    retrieve_raster(x, out_x, FALSE) # but not if actual file location specified
  }
  
  # Load into r
  r <- read_stars(out_x)
  
  # Display raster
  if(missing(colours)){
    plot(r) 
  } else {
    # Compute the number of breaks
    computed_breaks <- length(colours) + 1
    plot(r, col = colours, nbreaks = computed_breaks, ...)
  }
  
}
