// Count number of pixels in a set of images

// User inputs
///////////////////////////////////

input_path = "/Users/johngodlee/Desktop/input/";

output_path = "/Users/johngodlee/Desktop/output/";

///////////////////////////////////
// END user inputs

list = getFileList(input_path);

for (i=0; i<(list.length); i++) {

	open(""+input_path+list[i]+"");

	run("8-bit");

	setThreshold(0, 255);
	setOption("BlackBackground", false);
	run("Convert to Mask");

	makeRectangle(0, 0, getWidth, getHeight);

	run("Analyze Particles...", "size=0-Infinity show=[Bare Outlines] display add");

	image_id = getImageID();
	selectImage(image_id);
	close();
}

saveAs("Results", ""+output_path+"results.xls");
