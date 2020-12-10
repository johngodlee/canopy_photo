// START user input
///////////////////////////////////
input = "/Users/username/Desktop/input/";
output = "/Users/username/Desktop/output/";
circle_diam = 3925
algorithm = "Default"
///////////////////////////////////
// END user input

setBatchMode(true);

list = getFileList(input);

for (i=0; i<(list.length); i++) {
	open(""+input+list[i]+"");
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
