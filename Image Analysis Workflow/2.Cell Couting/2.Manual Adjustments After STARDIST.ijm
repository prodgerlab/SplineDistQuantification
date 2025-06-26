// Get the path of the folders
chanFolder = getDirectory("Choose the folder containing images for single channel marker (CD68,CD11c,or CD207");
dapiFolder = getDirectory("Choose the folder containing DAPI images");
roiFolder = getDirectory("Choose the folder containing ROI for either dermis/epidermis");
outputDir = getDirectory("Choose the folder containing the ROIs from SplineDist");

// Get the list of files in the folders
chanFiles = getFileList(chanFolder);
dapiFiles = getFileList(dapiFolder);
roiFiles = getFileList(roiFolder);
outputFiles = getFileList(outputDir);

run("Cell Counter");

for (i = 0; i < chanFiles.length; i++) {
    // Get the current chan filename
    CurrentImagechan = chanFiles[i];
    ImageNamechan = substring(CurrentImagechan, 0, 7); // Extract the first 9 characters

    for (k = 0; k < dapiFiles.length; k++) {
        // Get the current DAPI filename
        CurrentImageDAPI = dapiFiles[k];
        ImageNameDAPI = substring(CurrentImageDAPI, 0, 7); // Extract the first 9 characters

        for (j = 0; j < roiFiles.length; j++) {
            // Get the current ROI filename
            CurrentROI = roiFiles[j];
            ROIName = substring(CurrentROI, 0, 7); // Extract the first 9 characters

            for (m = 0; m < outputFiles.length; m++) {
                // Get the current output filename
                Currentoutput = outputFiles[m];
                OutputName = substring(Currentoutput, 0, 7); // Extract the first 9 characters

                // Check if all filenames match
                if (ImageNamechan == ImageNameDAPI && ImageNamechan == ROIName && ImageNamechan == OutputName) {

                    
                    open(chanFolder + CurrentImagechan);
                    imageID = substring(CurrentImagechan, 0, 7);
                    resetMinAndMax();
                    run("Enhance Contrast", "saturated=0.35");
                    rename("chan");
                    open(roiFolder + CurrentROI);
                    roiManager("Select", 0);
                    run("Clear Outside");
                    //roiManager("Delete");
                    //selectWindow("ROI Manager");
                    //run("Close");

                    open(dapiFolder + CurrentImageDAPI);   
                    resetMinAndMax();
                    run("Enhance Contrast", "saturated=0.35");
                    rename("DAPI");                                    
                    selectWindow("ROI Manager");
                    roiManager("Select", 0);
                    run("Clear Outside");
                    roiManager("Delete");
                    selectWindow("ROI Manager");
                    run("Close");

                    run("Merge Channels...", "c1=chan c2=DAPI create");
                   
                    open(outputDir + Currentoutput);
                    selectWindow("ROI Manager");
                    roiManager("Show All");
            
                    // Update the image display
                    updateDisplay();
                    
                    // Use the Cell Counter Tool to count additional cells SPLINEDIST missed
                  
                    waitForUser("Initialize. Select All in ROI Manager. Count any cells that were missed with Counter Type 2. Count false positives with Counter Type 3. When finished, Click Results then OK");

                   // Get the Image ID and counts for Type 2 and Type 3
                    countType2 = getResult("Type 2", 3);
                    countType3 = getResult("Type 3", 3); 

                    // Print results to the log
                    print("" + imageID + ", Added Cells, " + countType2 + ", Removed Cells, " + countType3);

                    // Close everything
                    run("Close All");
                    roiManager("reset");
                    selectWindow("Results");
                    run("Close");
                    
                    // Move to the next image set
                    break; // Exit the innermost loop to proceed to the next image set
                }
            }
        }
    }
}

// Notify user when processing is complete
print("Processing complete.");
