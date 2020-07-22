# Hemiphot example workflow
# John Godlee (johngodlee@gmail.com)
# 2018_08_02

# Preamble ----

# Packages
library(tiff)
source("Hemiphot-master/Hemiphot.R")
source("fov_func.R")

# Load an image ----
img_file_list <- list.files("test_img", pattern = ".tif", full.names = TRUE)

img_list <- lapply(img_file_list, readTIFF)

# Read a single image as an example
img <- img_list[[1]]

# Convert to Hemiphot format
##' A matrix of pixel values, with dimensions and circular radius
hemi <- Image2Hemiphot(img)

# Draw circle of image ----
circle_rad <- fov.px(deg_theta = 60, focal_length_mm = 8, pixel_pitch_um = 5.95)

# Set the circle on the image 
hemi_hemi <- SetCircle(hemi, 
  cx = (dim(img)[2] / 2), cy = (dim(img)[1] / 2), cr = circle_rad)

# Check the circle is sensible
PlotHemiImage(image = hemi_hemi, draw.circle = T)

# Visualise the concentric circles over which canopy openness is calculated ----
PlotHemiImage(hemi_hemi, draw.circle = T)
DrawCircles(hemi_hemi[[2]], hemi_hemi[[3]], hemi_hemi[[4]])

# Calculate canopy metrics ----

# Calculate gap fraction over each degree of the set circle
gap_frac <- CalcGapFractions(hemi_hemi)

# Calculate canopy openness
canopy_open <- CalcOpenness(fractions = gap_frac)
canopy_open

# Calculate LAI according to LiCOR methods
canopy_lai <- CalcLAI(fractions = gap_frac, width = 6)
canopy_lai

# Plot solar tracks
days <- seq(15,360,30)  #roughly each mid of the 12 months
PlotHemiImage(hemi_hemi, draw.circle = T)
DrawSolarTracks(hemi_hemi, lat = -15, d = days, magn.corr = 0)

# Calculate available light (PAR)
rad <- CalcPAR.Day(hemi_hemi, lat = -15, lon = 14, time.zone = 0,
  d = 174, tau = 0.6, uoc = 0.15,
  magn.corr = 0, draw.tracks = T, full.day = T)
PlotPAR.Day(radiation = rad, real.time = F)
PlotPAR.Day(radiation = rad, real.time = T)

rad <- CalcPAR.Day(hemi_hemi, lat = -15, d = days,
  tau = 0.65, uoc = 0.15,
  draw.tracks = F, full.day = F)
rad

# Plot available light throughout the day
par(mfrow = c(1,2))

Rad = CalcPAR.Year(hemi_hemi, lat = 52, tau = 0.6, uoc = 0.15, magn.corr = 0)

PlotPAR.Year(radiation = Rad)

Rad = CalcPAR.Year(hemi_hemi, lat = 0, tau = 0.6, uoc = 0.15, magn.corr = 0)

PlotPAR.Year(radiation = Rad)

par(mfrow = c(1,1))

# ----------------------------------
# Batch workflow -------------------
# ----------------------------------

# Create empty dataframe and fill it with zeroes
all_data <- data.frame(matrix(data = 0, nrow = length(img_list), ncol = 7))
names(all_data) = c("File", "CanOpen", "LAI", "DirectAbove", "DiffAbove",
  "DirectBelow", "DiffBelow")

# Fill first column with image names
all_data[,1] = img_file_list 

# Location parameters
location.latitude <- -15
location.altitude <- 200
location.day <- 30
location.days <- seq(15,360,30) 

# Image parameters
location.cx <- dim(img_list[[1]])[2] / 2  # x coordinate of center
location.cy <- dim(img_list[[1]])[1] / 2  # y coordinate of center
location.cr <- fov.px(60, 8, 5.95)  # Circle radius of interest

# Atmospheric parameters
location.tau <- 0.6  # Atmospheric transmissivity - Normally set at 0.6, but can vary between 0.4-0.6 in the tropics
location.uoc <- 0.15  # Amount of direct light that is used as diffuse light in the Uniform Ovecast Sky (UOC)

# Start the batch loop
for(i in 1:length(img_file_list)){    
  # read file
  image <- readTIFF(img_file_list[i])
  
  # convert to Hemi image
  image <- Image2Hemiphot(image)
  
  # set circle parameters
  image <- SetCircle(image, cx = location.cx, cy = location.cy, cr = location.cr)
  
  gap.fractions <- CalcGapFractions(image)
  all_data[i,2] = CalcOpenness(fractions = gap.fractions)
  
  # calculate LAI according to Licor's LAI Analyzer 
  all_data[i,3] = CalcLAI(fractions = gap.fractions)
  
  # Photosynthetic Photon Flux Density (PPDF, umol m-1 s-1) P
  rad <- CalcPAR.Day(im = image,
    lat = location.latitude, d = days,
    tau = location.tau, uoc = location.uoc, 
    draw.tracks = F, full.day = F)

  all_data[i,4] = rad[1]
  all_data[i,5] = rad[2]
  all_data[i,6] = rad[3]
  all_data[i,7] = rad[4]
}

# Look at the output
all_data
