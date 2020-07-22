#!/usr/bin/env sh

find . -name "*.drawio" -exec rm -f ../img/{}.pdf \; -exec /Applications/draw.io.app/Contents/MacOS/./draw.io --crop -x -o ../img/{}.pdf {} \;
