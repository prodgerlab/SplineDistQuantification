// Select the relevant input and out folders
basalLineFolder = getDirectory("Select Basal Line Folder");
epidermisMaskFolder = getDirectory("Select Epidermis Mask Folder");
outputFolder = getDirectory("Select Output Folder for 100um Dermis Masks");
basalLineList = getFileList(basalLineFolder);
for (i = 0; i < basalLineList.length; i++) {
    // Open the basal line mask
    basalLinePath = basalLineFolder + basalLineList[i];
    open(basalLinePath);
    
    
    run("Invert");
    run("Distance Map");
    setAutoThreshold("Default dark");
    setThreshold(0, 250);
    run("Convert to Mask");
    rename("BasalLine");
    
    matchString = substring(basalLineList[i], 0, 9);
        epidermisList = getFileList(epidermisMaskFolder);
    for (j = 0; j < epidermisList.length; j++) {
        if (startsWith(epidermisList[j], matchString)) {
            // Open the matching epidermis mask
            epidermisMaskPath = epidermisMaskFolder + epidermisList[j];
            open(epidermisMaskPath);
            rename("EpidermisMask");
            imageCalculator("Subtract create", "BasalLine", "EpidermisMask");
            selectWindow("Result of BasalLine");
            rename("Subtraction");
            run("Make Binary");
            waitForUser("Adjust Image as needed and press ok");
            run("Analyze Particles...", "size=10-Infinity exclude clear add");
            run("ROI Manager...");
            waitForUser("Manually select the dermis in the ROI Manager and click 'OK'.");
            run("Create Mask");
            outputFilePath = outputFolder + matchString + "_subtraction.tif";
            saveAs("Tiff", outputFilePath);
            close("EpidermisMask");
            close("Subtraction");
            close("BasalLine");
            run("Close All");
            roiManager("Delete");
            
        }
    }
    
    run("Close All");
}

print("Processing complete. Modified mask saved to " + outputFolder);
