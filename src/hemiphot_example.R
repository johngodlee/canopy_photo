# Hemiphot example workflow
# John Godlee (johngodlee@gmail.com)
# 2020-12-10

# Packages
library(tiff)
source("Hemiphot-master/Hemiphot.R")
source("fov_func.R")

# Load images
img_file_list <- list.files("test_img", pattern = ".tif", full.names = TRUE)

img_list <- lapply(img_file_list, readTIFF)

# Create empty dataframe for results, filled with zeroes 
all_data <- data.frame(matrix(data = 0, nrow = length(img_list), ncol = 7))
names(all_data) = c("File", "CanOpen", "LAI", "DirectAbove", "DiffAbove",
  "DirectBelow", "DiffBelow")

# Fill first column with image names
all_data[,1] = img_file_list 

# Define parameters
location.latitude <- -15
location.altitude <- 200
location.day <- 30
location.days <- seq(15,360,30) # middle of each month 

# Define image circle parameters
location.cx <- dim(img_list[[1]])[2] / 2  # x coordinate of center
location.cy <- dim(img_list[[1]])[1] / 2  # y coordinate of center
location.cr <- fov.px(60, 8, 5.95)  # Circle radius of interest

# Define atmospheric parameters
##' Atmospheric transmissivity - Normally 0.6, but varies 0.4-0.6 in tropics
location.tau <- 0.6  
##' direct light used as diffuse light in Uniform Overcast Sky (UOC)
location.uoc <- 0.15  

# For each file:
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
