// Specify the input folder containing masks
inputFolder =  getDirectory("Choose the input folder for the cut outlines");

// Specify the output folders
apicalFolder = getDirectory("Choose the save folder for the apical outlines");
basalFolder = getDirectory("Choose the save folder for the basal outlines");
list = getFileList(inputFolder);

for (i = 0; i < list.length; i++) {
    // Open the mask image
    open(inputFolder + list[i]);
    
    run("Make Binary");
    run("Analyze Particles...", "size=10-Infinity exclude clear add");
    run("ROI Manager...");
    waitForUser("Manually select the apical line object in the ROI Manager and click 'OK'.");
	run("Create Mask");
        apicalName = list[i] + "_Apical";
    saveAs("Tiff", apicalFolder + apicalName);
    close();

    waitForUser("Manually select the basal line object in the ROI Manager and click 'OK'.");
    run("Create Mask");
    basalName = list[i] + "_Basal";
    saveAs("Tiff", basalFolder + basalName);
	close();

    close();

    roiManager("reset");
    
}
print("Processing complete.");
