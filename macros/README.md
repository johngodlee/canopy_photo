# Macros for ImageJ

Use these Macros by adjusting the user inputs in the script, then running the macro by; `ImageJ -> Plugins -> Macros -> Run..`

`binarize.ijm` takes images in a folder and transforms them to `.tif` binary images where black is plant material and white is sky.

`binarize_blue_channel.ijm` is a variant of `binarize.ijm` where the binarization takes place on only the blue channel of the image. A binarized blue channel `.tif` image are created as output.

`gap_frac_image.ijm` measures the gap fraction of a folder of photos, using the whole image. Produces a `.csv` of the gap fraction of the images.

`gap_frac_circle.ijm` measures the gap fraction of a folder of photos within a circular selection. Produces a `.csv` of the gap fraction of the circular selection.

`leaf_area.ijm` takes scanned images of leaves and measures the area of each leaf, with rules for including shapes of certain size and circularity. Produces a `.csv` of the areas of each leaf.

`imagej_inbuilt_functions.pdf` is a copy of the list of in-built macro functions available in ImageJ.