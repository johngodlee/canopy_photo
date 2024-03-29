// START user input
///////////////////////////////////
input_path = "/Users/user/input/";
output_path = "/Users/user/output/";
///////////////////////////////////
// END user input

list = getFileList(input_path);

for (i=0; i<(list.length); i++) {
	open(""+input_path+list[i]+"");
	file_name = getInfo("image.filename");
	run("Invert LUT");
	run("Analyze Particles...", "summarize");
	image_id = getImageID();
	selectImage(image_id);
	close();
	roiManager("reset");
}

selectWindow("Summary"); 
saveAs("Results", ""+output_path+"results.csv"); 
run("Close");
