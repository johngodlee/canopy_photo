// Calculate the gap fraction of a full image

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
	setAutoThreshold("Huang dark");
	run("Convert to Mask");

	file_name = getInfo("image.filename");

	run("Analyze Particles...", "summarize add");

	saveAs("Jpeg", ""+output_path+file_name+"");

	image_id = getImageID();
	selectImage(image_id);
	close();
}

saveAs("Results", ""+output_path+"results.xls");
