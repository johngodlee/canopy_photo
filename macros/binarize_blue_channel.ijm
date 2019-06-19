// User inputs
///////////////////////////////////

input_path = "/Users/johngodlee/Desktop/input/";

output_path = "/Users/johngodlee/Desktop/output/";

algorithm = "Default"

///////////////////////////////////
// END user inputs


list = getFileList(input_path);


for (i=0; i<(list.length); i++){

	open(""+input_path+list[i]+"");

	file_name = getInfo("image.filename");

	run("Split Channels");

	selectWindow(file_name+" (blue)");

	setAutoThreshold(algorithm);

	run("Convert to Mask");

	saveAs("tif", ""+output_path+"blue_"+file_name+"");

	close("*");
}