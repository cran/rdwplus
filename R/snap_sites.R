#' A function to snap survey sites to a stream raster and a flow accumulation raster
#' @description This function takes a set of survey site locations and snaps them to the highest-value cell within a flow accumulation raster, within a specified distance. Note that this function calls \code{r.stream.snap}, which is a GRASS GIS add-on. It can be installed through the GRASS GUI.
#'
#' @param sites File name for a shapefile containing the locations of the survey sites in the current GRASS mapset.
#' @param stream Name of a stream raster in the current GRASS mapset. This can either be formatted to have NoData in non-stream cells or 0s in non-stream cells. 
#' @param flow_acc Name of a flow accumulation raster in the current GRASS mapset. 
#' @param max_move The maximum distance in cells that any site can be moved to snap it to the flow accumulation grid.
#' @param out Name of the output in the current GRASS mapset. Note that this function will add a column called \code{snap_dist} to the attribute table of the input sites, which indicates how far each site was snapped.
#' @param overwrite Whether the output should be allowed to overwrite any existing files. Defaults to \code{FALSE}.
#' @param max_memory Max memory (in) used in memory swap mode. Defaults to \code{300} Mb.
#' @param ... Additional arguments to \code{r.stream.snap}.
#' @return Nothing.
#' @examples 
#' # Will only run if GRASS is running
#' # You should load rdwplus and initialise GRASS via the initGRASS function
#' if(check_running()){
#' # Retrieve paths to data sets
#' dem <- system.file("extdata", "dem.tif", package = "rdwplus")
#' lus <- system.file("extdata", "landuse.tif", package = "rdwplus")
#' sts <- system.file("extdata", "site.shp", package = "rdwplus")
#' stm <- system.file("extdata", "streams.shp", package = "rdwplus")
#'
#' # Set environment 
#' set_envir(dem)
#'
#' # Get other data sets (stream layer, sites, land use, etc.)
#' raster_to_mapset(lus)
#' vector_to_mapset(c(stm, sts))
#'
#' # Reclassify streams
#' out_stream <- paste0(tempdir(), "/streams.tif")
#' rasterise_stream("streams", out_stream, TRUE)
#' reclassify_streams("streams.tif", "streams01.tif", overwrite = TRUE)
#'
#' # Burn in the streams to the DEM
#' burn_in("dem.tif", "streams01.tif", "burndem.tif", overwrite = TRUE)
#'
#' # Fill dem
#' fill_sinks("burndem.tif", "filldem.tif", "fd1.tif", "sinks.tif", overwrite = TRUE)
#'
#' # Derive flow direction and accumulation grids
#' derive_flow("dem.tif", "fd.tif", "fa.tif", overwrite = T)
#'
#' # Derive a new stream raster from the FA grid
#' derive_streams("dem.tif", "fa.tif", "new_stm.tif", "new_stm", min_acc = 200, overwrite = T)
#'
#' # Snap sites to streams and flow accumulation
#' snap_sites("site", "new_stm.tif", "fa.tif", 2, "snapsite", T)
#' }
#' @export 
snap_sites <- function(sites, stream, flow_acc, max_move, out, overwrite = FALSE, max_memory = 300, ...){
  
  # Check if a GRASS session exists
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  # Call GRASS function
  flags <- "quiet"
  if(overwrite) flags <- c(flags, "overwrite")
  execGRASS(
    "r.stream.snap",
    flags = flags,
    parameters = list(
      input = sites,
      stream_rast = stream,
      accumulation = flow_acc, 
      output = out,
      radius = max_move,
      memory = max_memory,
      ...
    )
  )
  
  # Compute snapping distance for each feature
  execGRASS(
    "v.db.addcolumn",
    flags = "quiet",
    parameters = list(
      map = sites,
      columns = "snap_dist double precision"
    )
  )
  execGRASS(
    "v.distance",
    flags = flags,
    parameters = list(
      to = out,
      from = sites,
      from_type = "point",
      to_type = "point",
      upload = "dist",
      column = "snap_dist"
    )
  )  
  
  # Retrieve data sets in temporary files, join the attribute tables in R
  out_orig <- paste0(tempdir(), "/", sites, ".shp")
  out_new  <- paste0(tempdir(), "/", out, ".shp")
  retrieve_vector(c(sites, out), c(out_orig, out_new), overwrite = T)
  out_orig_sf <- read_sf(out_orig)
  out_orig_sf <- out_orig_sf[, -grep("^cat$", names(out_orig_sf))]# maybe not safe?
  out_new_sf  <- read_sf(out_new)
  out_new_sf  <- out_new_sf[, -grep("^cat$", names(out_new_sf))]
  out_new_sf <- cbind(out_new_sf, st_drop_geometry(out_orig_sf))
  
  # Export again and send to mapset
  write_sf(out_new_sf, out_new)
  vector_to_mapset(out_new, overwrite = T)
  
  # Return nothing
  invisible()
  
}