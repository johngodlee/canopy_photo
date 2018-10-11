// Calculate the area of dark objects (leaves) against a white background.


// User inputs
///////////////////////////////////

input_path = "/Users/johngodlee/Desktop/input/";

output_path = "/Users/johngodlee/Desktop/output/";

dpi = 300;

min_obj_size = 0.7;

max_obj_size = "Infinity"

///////////////////////////////////
// END user inputs


list = getFileList(input_path);

for (i=0; i<(list.length); i++) {

	open(""+input_path+list[i]+"");

	file_name = getInfo("image.filename");

	px_cm = (dpi * 10) / 25.4;

	run("8-bit");

	setAutoThreshold("Default");
	setOption("BlackBackground", false);
	run("Convert to Mask");

	run("Set Scale...", "distance=px_cm known=1 pixel=1 unit=cm global");

	run("Analyze Particles...", "size=min_obj_size-max_obj_size show=[Bare Outlines] display add");

	setOption("Display Label", true);

	saveAs("Results", ""+output_path+file_name+".xls");
	run("Clear Results");

	saveAs("Jpeg", ""+output_path+file_name+"");

	image_id = getImageID();
	selectImage(image_id);
	close();
}
