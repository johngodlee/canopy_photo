// User inputs
///////////////////////////////////

input_path = "/Users/johngodlee/Desktop/input/";

output_path = "/Users/johngodlee/Desktop/output/";

///////////////////////////////////
// END user inputs


list = getFileList(input_path);


for (i=0; i<(list.length); i++){
	open(""+input_path+list[i]+"");

        image_name = getTitle();

	run("Split Channels");

	selectWindow(image_name+" (blue)");

	setAutoThreshold("Huang dark");

	run("Convert to Mask");

	saveAs("Jpeg", output_path+"blue_"+image_name);

	run("Analyze Particles...", "summarize add");

	close("*");
}

saveAs("Results", ""+output_path+"results.xls");
