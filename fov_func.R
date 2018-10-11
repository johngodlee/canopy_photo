# Functions to ascertain crop angles and pixel radii for equisolid projection fisheye camera lenses
# John Godlee (johngodlee@gmail.com)
# 2018_09_11

# Get a pixel radius for cropping an image to a given view angle

##' deg_theta = the desired radius to be cropped to, in degrees. e.g. a full 180deg fov = 90
##' focal_length_mm = focal length of the camera lens combo, e.g. 8
##' pixel_pitch_um = the pixel pitch, i.e. the number of micrometres per px, e.g. 5.95

fov.px <- function(deg_theta, focal_length_mm, pixel_pitch_um){
	require(NISTunits)
	
	# Convert degrees of theta to radians
	rads_theta <- NISTdegTOradian(deg_theta) 
	
	# Calculate radius of circle drawn by angle of view (rads_theta and max_rads_theta) in mm projected onto the sensor plane
	R <-  2 * focal_length_mm * sin(rads_theta / 2)
	
	# Calculate the px per mm on the sensor, i.e. the pixel pitch
	sensor_px_per_mm_flat <- 1/pixel_pitch_um * 1000
	
	# Multiply the mm radius of the desired circle by the number of pixels per mm on the sensor, to get the number of pixels radius of the desired circle
	pixels_for_theta <- R * sensor_px_per_mm_flat
	
	# Print result
	print(paste("Radius of circle:", round(pixels_for_theta, digits = 0), "px"))
}

# Test of function
# fov.px(deg_theta = 90, focal_length_mm = 8, pixel_pitch_um = 5.95)

# Back calculate theta given the percentage radius crop and other camera info

##' prop_crop = percentage of the projected circular image radius that has been cropped, e.g. 0.59
##' full_circle_radius_px = Radius of the full uncropped circle in pixels, e.g. 1962
##' focal_length_mm = focal length of the camera lens combo, e.g. 8
##' pixel_pitch_um = the pixel pitch, i.e. the number of micrometres per px, e.g. 5.95

fov.theta <- function(prop_crop, full_circle_radius_px, focal_length_mm, pixel_pitch_um){
	require(NISTunits)
	
	# Calculate the number of pixels in the radius of the crop
	px_crop <- full_circle_radius_px * prop_crop
	
	# Calculate the radius of the 
	theta <- 2 * asin(((pixel_pitch_um * px_crop) / (2 * focal_length_mm * 1000)))
	
	deg_theta <- NISTradianTOdeg(theta)
	
	print(paste("Angle of view: ", round(deg_theta, digits = 2), "°", sep = ""))
}

# Test of function
# fov.theta(prop_crop = 0.5, full_circle_radius_px = 1901, focal_length_mm = 8, pixel_pitch_um = 5.95)


