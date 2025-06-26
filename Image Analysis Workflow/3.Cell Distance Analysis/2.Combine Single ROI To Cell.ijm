// Select the input directories
imageDir = getDirectory("Choose the directory with image files");
roiDir = getDirectory("Choose the directory with Basal/Apical .roi files");
roiZipDir = getDirectory("Choose the directory with ROI.zip files for a given cell type");

// Select the output directory to save the combined ROI .zip files
outputDir = getDirectory("Choose output directory to save Distance Analysis ROI.zip files");

imageList = getFileList(imageDir);
roiList = getFileList(roiDir);
roiZipList = getFileList(roiZipDir);

if (imageList.length != roiList.length || imageList.length != roiZipList.length) {
    print("The number of files in the directories do not match!");
    exit("Check the directories and ensure they have the same number of files.");
}

for (i = 0; i < imageList.length; i++) {
    // Construct the file paths
    imagePath = imageDir + imageList[i];
    roiPath = roiDir + roiList[i];
    roiZipPath = roiZipDir + roiZipList[i];
    
    open(imagePath);
    
    roiManager("Reset");
    
    roiManager("Open", roiPath);
    
    roiManager("Open", roiZipPath);
    
    savePath = outputDir + imageList[i] + "_combined.zip";
    roiManager("Save", savePath);
    
    print("Combined ROI file saved to: " + savePath);
    
    // Close the current image
    close("*");
}

print("All files processed successfully!");
