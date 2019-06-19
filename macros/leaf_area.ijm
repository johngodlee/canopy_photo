// Calculate the area of dark objects (leaves) against a white background.


// User inputs
///////////////////////////////////

input_path = "/Users/johngodlee/Desktop/input/";

output_path = "/Users/johngodlee/Desktop/output/";

dpi = 300;

min_obj_size = 0;

max_obj_size = "Infinity"

binarize_first = "TRUE"
// Only set to "FALSE" if a binarized `.tif` is used

algorithm = "Default"

///////////////////////////////////
// END user inputs


list = getFileList(input_path);

for (i=0; i<(list.length); i++) {

	open(""+input_path+list[i]+"");

	file_name = getInfo("image.filename");

	px_cm = (dpi * 10) / 25.4;

	run("8-bit");

	if (binarize_first=="TRUE"){
		setAutoThreshold(algorithm);
		setOption("BlackBackground", false);
		run("Convert to Mask");
	}

	run("Set Scale...", "distance=px_cm known=1 pixel=1 unit=cm global");

	run("Analyze Particles...", "size=min_obj_size-max_obj_size show=[Outlines] display add");

	setOption("Display Label", true);

	saveAs("Results", ""+output_path+file_name+".csv");
	run("Clear Results");

	saveAs("Jpeg", ""+output_path+file_name+"");

	close("*");
}

