// Calculate the gap fraction of a circular selection of an image

// User inputs
///////////////////////////////////
input_path = "/Users/johngodlee/Desktop/input/";
output_path = "/Users/johngodlee/Desktop/output/";
circle_diam = 3925
binarize_first = "TRUE"
// Only set to "FALSE" if a binarized `.tif` is used
algorithm = "Default"
///////////////////////////////////
// END user inputs

list = getFileList(input_path);

for (i=0; i<(list.length); i++) {
	open(""+input_path+list[i]+"");
	if (binarize_first=="TRUE"){
		run("8-bit");
		setAutoThreshold("Default");
		setOption("BlackBackground", true);
		run("Invert LUT");
		run("Convert to Mask");
	}
	makeOval((getWidth/2) - (0.5 * circle_diam),
		(getHeight/2) - (0.5 * circle_diam),
		circle_diam,
		circle_diam);
	file_name = getInfo("image.filename");
	run("Analyze Particles...", "summarize");
	image_id = getImageID();
	selectImage(image_id);
	close();
	roiManager("reset");
}

selectWindow("Summary"); 
saveAs("Results", ""+output_path+"results.csv"); 
run("Close");
