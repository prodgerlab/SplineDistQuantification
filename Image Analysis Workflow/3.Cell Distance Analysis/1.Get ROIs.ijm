ImageDirectory = getDirectory("Choose a Directory with Basal/Apical Image Masks");
OutputDirectory = getDirectory("Choose a Save Folder");
ImagesList = getFileList(ImageDirectory);
NumResults = ImagesList.length;

for (t = 0; t < NumResults; t += 1) {
	roiManager("Reset")
	CurrentImage = ImagesList[t];
	open(ImageDirectory + CurrentImage);
	ImageID = getImageID();
	FileName = getTitle(); 
	RootName = substring(FileName,0,lengthOf(FileName)-4);
	run("Create Selection");
	roiManager("Add");
	roiManager("Select", 0);
	roiManager("Rename", RootName);
	roiManager("Select", 0);
	roiManager("Save", OutputDirectory + RootName + ".zip")
	close("*");
	close("ROI Manager");
}

