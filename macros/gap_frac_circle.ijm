// Calculate the gap fraction of a circular selection of an image

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
	setAutoThreshold("Huang dark");
	run("Convert to Mask");

	makeOval((getWidth/2) - (0.5 * circle_diam),
		(getHeight/2) - (0.5 * circle_diam),
		circle_diam,
		circle_diam);

	file_name = getInfo("image.filename");

	run("Analyze Particles...", "summarize add");

	saveAs("Jpeg", ""+output_path+file_name+"");

	image_id = getImageID();
	selectImage(image_id);
	close();
}

saveAs("Results", ""+output_path+"results.xls");
