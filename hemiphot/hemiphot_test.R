# Hemiphot test
# John Godlee (johngodlee@gmail.com)
# 2018_08_02

# Preamble ----

# Set working directory to the location of the source file
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Remove old crap
rm(list = ls())

# Packages and functions ----
library(jpeg)

source("Hemiphot.R")  # Functions
days <- seq(15,360,30)  #roughly each mid of the 12 months

# Load an image ----
hemi_col <- readJPEG("test_img/DSC_7045.jpg", native = F)       #if native = T creates a raster, else an array

# Convert to Hemiphot format ----
hemi_hemi <- Image2Hemiphot(hemi_col)

# Draw the circle ----

# Load a completely white image from the same camera setup
# This needs to be done manually in photoshop or gimp
white <- readJPEG("test_img/white_image.jpg", native = F)  
radius <- max(rowSums(white[,,1] > 0.4) / 2)
hemi_dim <- dim(white)

# Use the radius and assumption that the circle is in the centre of the image to draw the circle
hemi_hemi <- SetCircle(hemi_hemi, cx = (hemi_dim[2] / 2), cy = (hemi_dim[1] / 2), cr = radius)
PlotHemiImage(image = hemi_hemi, draw.circle = T)


# Look at the blue channel, which is best for distinguishing sky and leaves ----
hemi_blue <- SelectRGB(hemi_hemi, "B")

hemi_blue <- SetCircle(hemi_blue, cx = (hemi_dim[2] / 2), cy = (hemi_dim[1] / 2), cr = radius)

PlotHemiImage(hemi_blue, draw.circle = T)

# Threshold the image ----

# Must be experimented with.
threshold <- 0.42

hemi_blue_th <- ThresholdImage(image = hemi_blue, th = threshold, draw.image = T)

# Visualise the concentric circles over which canopy openness is calculated ----

PlotHemiImage(hemi_blue_th, draw.circle = T)
DrawCircles(hemi_blue_th[[2]], hemi_blue_th[[3]], hemi_blue_th[[4]])

# Calculate canopy openness ----

gap_frac <- CalcGapFractions(hemi_blue_th)

canopy_open <- CalcOpenness(fractions = gap_frac)
canopy_open

# Calculate LAI according to LiCOR methods ----

canopy_lai <- CalcLAI(fractions = gap_frac, width = 6)
canopy_lai

# Plot solar tracks ----

PlotHemiImage(hemi_blue_th, draw.circle = T)
DrawSolarTracks(hemi_blue_th, lat = -15, d = 320, magn.corr = 0)
DrawSolarTracks(hemi_blue_th, lat = -15, d = 320, magn.corr = 1)
DrawSolarTracks(hemi_blue_th, lat = -15, d = 320, magn.corr = 5)
DrawSolarTracks(hemi_blue_th, lat = -15, d = 320, magn.corr = 35)
DrawSolarTracks(hemi_blue_th, lat = -15, d = 320, magn.corr = -35)
DrawSolarTracks(hemi_blue_th, lat = -15, d = 320, magn.corr = 55)

PlotHemiImage(hemi_blue_th, draw.circle = T)
DrawSolarTracks(hemi_blue_th, lat = -15, d = days, magn.corr = 0)

PlotHemiImage(hemi_blue_th, draw.circle = T)
DrawSolarTracks(hemi_blue_th, lat = -15, lon = 14, time.zone = 0,
								d = 157, magn.corr = 0, sun.location = T, h = 0.00)

PlotHemiImage(hemi_blue_th, draw.circle = T)
for(i in 3:21){
	DrawSolarTracks(hemi_blue_th, lat = -15, lon = 14, time.zone = 0,
									d = 150, magn.corr = 0, sun.location = T, h = i)
}

# Calculate available light (PAR) ----

rad <- CalcPAR.Day(hemi_blue_th, lat = -15, lon = 14, time.zone = 0,
									d = 174, tau = 0.6, uoc = 0.15,
									magn.corr = 0, draw.tracks = T, full.day = T)

PlotPAR.Day(radiation = rad, real.time = F)
PlotPAR.Day(radiation = rad, real.time = T)

rad <- CalcPAR.Day(hemi_blue_th, lat = -15, d = days,
									 tau = 0.65, uoc = 0.15,
									 draw.tracks = F, full.day = F)
rad

# Plot available light throughout the day
par(mfrow = c(1,2))

Rad = CalcPAR.Year(hemi_blue_th, lat = 52, tau = 0.6, uoc = 0.15, magn.corr = 0)

PlotPAR.Year(radiation = Rad)

Rad = CalcPAR.Year(hemi_blue_th, lat = 0, tau = 0.6, uoc = 0.15, magn.corr = 0)

PlotPAR.Year(radiation = Rad)

par(mfrow = c(1,1))


# ----------------------------------
# Batch workflow -----------------
# ----------------------------------

# List all images in the directory	
all_images <- list.files("test_img/", pattern = ".JPG")

# How many images
img_length = length(all_images)

# Create empty dataframe, 6x7 and fill it with zeroes
all_data = data.frame(matrix(data = 0, nrow = img_length, ncol = 7))
names(all_data) = c("File", "CanOpen", "LAI",
										"DirectAbove", "DiffAbove",
										"DirectBelow", "DiffBelow")
# Fill first column with image names
all_data[,1] = all_images

# Variables setup 

## Location parameters, approximate is good enough for this if working on one site
location.latitude   = -15
location.altitude   = 200
location.day        = 30
location.days       = seq(15,360,30)   # roughly each mid of the 12 months

## Image parameters
### determine using a single image and fill in here for batch processing
location.cx         = (hemi_dim[2] / 2)             # x coordinate of center
location.cy         = (hemi_dim[1] / 2)             # y coordinate of center
location.cr         = radius             # radius of circle
location.threshold  = 0.42  # Must get this to match all images, or maybe could use a lookup table / dictionary

### atmospheric parameters
location.tau        = 0.6  # Atmospheric transmissivity - Normally set at 0.6, but can vary between 0.4-0.6 in the tropics
location.uoc        = 0.15  # Amount of direct light that is used as diffuse light in the Uniform Ovecast Sky (UOC)


# Start the batch loop

t1 = Sys.time()

for(i in 1:img_length){    
	## read file
	image <- readJPEG(paste("test_img/", all_images[i], sep = ""), native = F) 
	
	## conver to Hemi image
	image <- Image2Hemiphot(image)
	
	## set cirlce parameters
	image <- SetCircle(image, cx = location.cx, cy = location.cy, cr = location.cr)
	
	## select blue channel
	image <- SelectRGB(image, "B")
	
	#threshold
	image <- ThresholdImage(im = image, th = location.threshold, draw.image = F)
	
	# canopy openness
	gap.fractions <- CalcGapFractions(image)
	all_data[i,2] = CalcOpenness(fractions = gap.fractions)
	
	## calculate LAI according to Licor's LAI Analyzer 
	all_data[i,3] = CalcLAI(fractions = gap.fractions)
	
	## Photosynthetic Photon Flux Density (PPDF, umol m-1 s-1) P
	rad <- CalcPAR.Day(im = image,
										lat = location.latitude, d = days,
										tau = location.tau, uoc = location.uoc, 
										draw.tracks = F, full.day = F)
	all_data[i,4] = rad[1]
	all_data[i,5] = rad[2]
	all_data[i,6] = rad[3]
	all_data[i,7] = rad[4]
}
t2 = Sys.time()

# How long did it take
(t2 - t1)/img_length

# Look at the output
all_data
