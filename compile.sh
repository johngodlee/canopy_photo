#!/bin/bash

# A simple pandoc script to generate a `.pdf` from the `hemi_photo_guide.md`

pandoc -f markdown -t html5 --css=pandoc_tweak.css -H pandoc_tweak.css --standalone -o hemi_photo_guide.html hemi_photo_guide.md

wkhtmltopdf hemi_photo_guide.html hemi_photo_guide.pdf
