ImageDirectory = getDirectory("Choose a Directory with Images");
ImagesList = getFileList(ImageDirectory);
NumImages = ImagesList.length;
for (t = 0; t < NumImages; t += 1) {
	CurrentImage = ImagesList[t];
	open(ImageDirectory + CurrentImage);
	run("8-bit");
	setOption("BlackBackground", true);
	setOption("ScaleConversions", true);
	run("Make Binary");
	run("Analyze Particles...", "size=10-infinity show=Overlay summarize");
	close();
}


Dialog.create("Complete");
Dialog.addMessage("Script Complete");
Dialog.show();
//run("Quit");

