# Macros for ImageJ

Use these Macros by adjusting the user inputs in the script, then running the macro by; `ImageJ -> Plugins -> Macros -> Run..`

`binarize.ijm` takes images in a folder and transforms them to binary images where white is plant material and black is sky.

`count_total_pixels_circle_sel.ijm` counts the total number of pixels in a circular selection of an image.

`count_total_pixels.ijm` counts the total number of pixels in an image.

`gap_frac_circle.ijm` measures the gap fraction of a folder of photos within a circular selection.

`gap_frac_image.ijm` measures the gap fraction of a folder of photos, using the whole image.

`leaf_area.ijm` takes scanned images of leaves and measures the area of each leaf, with rules for including shapes of certain size and circularity.

`binarize_gap_frac_blue_channel.ijm` is a variant of `gap_frac_image.ijm` where the binarization takes place on only the blue channel of the image. An excel file of the results and a binarized blue channel image are created as output.

`imagej_inbuilt_functions.pdf` is a copy of the list of in-built macro functions available in ImageJ.