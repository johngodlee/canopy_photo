#' Calculate pixel radius of angular field of view for equisolid projection
#'
#' @param deg_theta desired radius to be cropped to, in degrees
#' @param focal_length_mm focal length of the camera lens combo
#' @param pixel_pitch_um pixel pitch, i.e. the number of micrometres per px
#'
#' @return integer value of pixel length of crop radius
#' 
#' @examples
#' fov.px(60, 8, 5.95)
#' 
#' @importFrom NISTunits NISTdegTOradian
#' 
fov.px <- function(deg_theta, focal_length_mm, pixel_pitch_um){
  # Convert degrees of theta to radians
  rads_theta <- NISTunits::NISTdegTOradian(deg_theta) 
  
  # Calculate radius of circle drawn by angle of view (rads_theta and max_rads_theta) in mm projected onto the sensor plane
  R <-  2 * focal_length_mm * sin(rads_theta / 2)
  
  # Calculate the px per mm on the sensor, i.e. the pixel pitch
  sensor_px_per_mm_flat <- 1/pixel_pitch_um * 1000
  
  # Multiply the mm radius of the desired circle by the number of pixels per mm on the sensor, to get the number of pixels radius of the desired circle
  pixels_for_theta <- round(R * sensor_px_per_mm_flat, 0)
  
  return(pixels_for_theta)
}

