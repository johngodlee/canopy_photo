// Calculate the gap fraction of a full image

// User inputs
///////////////////////////////////

input_path = "/Users/johngodlee/Desktop/input/";

output_path = "/Users/johngodlee/Desktop/output/";

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
		setAutoThreshold(algorithm);
		setOption("BlackBackground", false);
		run("Convert to Mask");
	}

	run("Invert");

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