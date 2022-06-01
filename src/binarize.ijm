// User inputs
///////////////////////////////////
input_path = "/Users/user/input/";
output_path = "/Users/user/output/"
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
	saveAs("Tiff", ""+output_path+file_name+"_binary");
	close("*");
}
