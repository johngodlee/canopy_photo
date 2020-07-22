// Binarize all images with a given algorithm and save

// User inputs
///////////////////////////////////
input_path = "/Users/username/Desktop/input/";
output_path = "/Users/username/Desktop/output/"
algorithm = "Default"
///////////////////////////////////
// END user inputs

list = getFileList(input_path);

for (i=0; i<(list.length); i++) {
	open(""+input_path+list[i]+"");
	file_name = getInfo("image.filename");
	run("8-bit");
	setAutoThreshold(algorithm);
	setOption("BlackBackground", false);
	run("Convert to Mask");
	saveAs("tif", ""+output_path+file_name+"");
	image_id = getImageID();
	selectImage(image_id);
	close();
}