#!/usr/bin/env sh

set -e

cleanup() {
  rm -f mask.png
}
trap cleanup EXIT

if [ $# -lt 2 ]; then
	printf "Supply >=2 args:\n [1] circle radius in pixels\n [2] image file\n"
    exit 1
fi

if [ -z "${1##*[!0-9]*}" ]; then
	printf "Circle radius must be an integer\n"
	exit 1
fi

rad=$1
diam=$(($rad*2))
shift

convert \
	-size ${diam}x${diam} \
	xc:Black \
	-fill White \
	-draw "circle $rad $rad $rad 1" \
	-alpha Copy mask.png

for i in "$@"; do
	name="${i%.*}"
	convert $i \
		-gravity Center mask.png \
		-compose CopyOpacity \
		-composite \
		-trim ${name}_crop.tif
done
