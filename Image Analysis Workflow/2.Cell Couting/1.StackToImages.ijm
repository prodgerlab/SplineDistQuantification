Directory = getDirectory("Choose the folder containing Whole Tissue Images");
Images = getFileList(Directory);

SaveFolderDAPI= getDirectory ("Choose a save folder for DAPI");
SaveFolderCD207= getDirectory ("Choose a save folder for CD207");
SaveFolderCD68= getDirectory ("Choose a save folder for CD68");
SaveFolderCD11c= getDirectory ("Choose a save folder for CD11c");

NumImages = Images.length;
for (t = 0; t < NumImages; t += 1) {
	CurrentImage = Images[t];
	open(Directory + CurrentImage);
	CurrentImageID = getImageID();
	selectImage(CurrentImageID);
	FileName = getTitle(); 
	RootName = substring(FileName,0,lengthOf(FileName)-4); 
	run("Stack to Images");
	saveAs("Tiff", SaveFolderDAPI + RootName + "-DAPI"); 
	run("Close");
	saveAs("Tiff", SaveFolderCD207 + RootName + "-CD207"); 
	run("Close");
	saveAs("Tiff", SaveFolderCD11c + RootName + "-CD11c"); 
	run("Close");
	saveAs("Tiff", SaveFolderCD68 + RootName + "-CD68"); 
	run("Close");
	run("Close All");
}


Dialog.create("Complete");
Dialog.addMessage("Script Complete");
Dialog.show();
//run("Quit");


