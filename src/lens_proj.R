# Plot of lens projections
# John Godlee (johngodlee@gmail.com)
# 2021-08-06

# Packages
library(ggplot2)

# Define formulas
stereographic <- function(x) {
  2 * tan(x/2)
}

equidistant <- function(x) {
  x
}

equisolid <- function(x) {
  2 * sin(x/2)
}

orthographic <- function(x) {
  sin(x)
}

thoby <- function(x) {
  1.47 * sin(0.713 * x)
}

pdf(file = "lens_proj.pdf", width = 5, height = 5)
ggplot(data = data.frame(x = 0), aes(x = x)) + 
  stat_function(fun = stereographic, colour = "red") + 
  stat_function(fun = equidistant, colour = "black") + 
  stat_function(fun = equisolid, colour = "blue") + 
  stat_function(fun = orthographic, colour = "green") + 
  stat_function(fun = thoby, colour = "purple") + 
  lims(x = c(0,2.5), y = c(0,2.5)) + 
  labs(x = "Angle of incident light (rad)", y = "Radius on image") + 
  theme_bw() + 
  annotate("text", x = 0.3, y = 2.3, label = "Stereographic", colour = "red", hjust = 0) + 
  annotate("text", x = 0.3, y = 2.15, label = "Equidistant", colour = "black", hjust = 0) + 
  annotate("text", x = 0.3, y = 2.0, label = "Equisolid", colour = "blue", hjust = 0) + 
  annotate("text", x = 0.3, y = 1.85, label = "Orthographic", colour = "green", hjust = 0) +
  annotate("text", x = 0.3, y = 1.7, label = "Thoby", colour = "purple", hjust = 0) 
dev.off()

