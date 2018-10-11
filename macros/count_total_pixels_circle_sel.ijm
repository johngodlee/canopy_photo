// Count the total number of pixels in a circular selection, e.g. a full frame hemispherical photo

// User inputs
///////////////////////////////////

input_path = "/Users/johngodlee/Desktop/input/";

output_path = "/Users/johngodlee/Desktop/output/";

circle_diam = 3925

///////////////////////////////////
// END user inputs

list = getFileList(input_path);

for (i=0; i<(list.length); i++) {

	open(""+input_path+list[i]+"");

	run("8-bit");

	setThreshold(0, 255);
	setOption("BlackBackground", false);
	run("Convert to Mask");

	makeOval((getWidth/2) - (0.5 * circle_diam),
		(getHeight/2) - (0.5 * circle_diam),
		circle_diam,
		circle_diam);

	run("Analyze Particles...", "display add");

	image_id = getImageID();
	selectImage(image_id);
	close();
}

saveAs("Results", ""+output_path+"results.xls");
