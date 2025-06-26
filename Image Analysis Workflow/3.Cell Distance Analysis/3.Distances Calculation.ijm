// Select the input directories
imageDir = getDirectory("Choose the directory with image files");
roiZipDir = getDirectory("Choose the directory with Distance Analysis ROI.zip files");

outputDir = getDirectory("Choose output directory to save results");

imageList = getFileList(imageDir);
roiZipList = getFileList(roiZipDir);

if (imageList.length != roiZipList.length) {
    print("The number of files in the directories do not match!");
    exit("Check the directories and ensure they have the same number of files.");
}

// Function to calculate median
function calculateMedian(array) {
    array = Array.sort(array);
    len = lengthOf(array);
    if (len % 2 == 0) {
        return (array[len/2 - 1] + array[len/2]) / 2;
    } else {
        return array[Math.floor(len/2)];
    }
}

// Function to calculate mean
function calculateMean(array) {
    sum = 0;
    for (i = 0; i < array.length; i++) {
        sum += array[i];
    }
    return sum / array.length;
}

for (i = 0; i < imageList.length; i++) {
    // Construct the file paths
    imagePath = imageDir + imageList[i];
    roiZipPath = roiZipDir + roiZipList[i];
    
    open(imagePath);
    run("Set Scale...", "distance=2.5 known=1 unit=micron");
  	run("Remove Overlay"); 
    
    roiManager("Reset");
    run("Create Selection");
	roiManager("Add");

    
    roiManager("Open", roiZipPath);
    CurrentImageID = getImageID();
    selectImage(CurrentImageID);
    run("Remove Overlay");
    getPixelSize(unit, pixelWidth, pixelHeight);
    run("Set Scale...", "distance=1 known=1 unit=pixel");

    distances = newArray();
    
    roiManager("select", 0);
    getSelectionCoordinates(x, y);
    run("Set Measurements...", "centroid redirect=None decimal=1");
    for (selection = 1; selection < roiManager("count"); selection++) {
        roiManager("select", selection);
        run("Measure");
        xc = getResult("X", nResults() - 1);
        yc = getResult("Y", nResults() - 1);
        pos = 9999999999999;
        for (line = 0; line < x.length; line++) {
            dx = xc - x[line];
            dy = yc - y[line];
            d = sqrt((dx * dx) + (dy * dy));
            if (d < pos) { 
                pos = d;
            }
        }
        micronDistance = pos * pixelWidth;
        if (micronDistance < 100) {
            distances = Array.concat(distances, micronDistance);
        }
    }
    
    if (distances.length > 0) {
        medianDistance = calculateMedian(distances);
        meanDistance = calculateMean(distances);
    } else {
        medianDistance = "N/A";
        meanDistance = "N/A";
    }
    
    outputFile = File.open(outputDir + imageList[i] + "_distances.txt");
    print(outputFile, "Image: " + imageList[i]);
    print(outputFile, "Median Distance (< 100 microns): " + medianDistance + " " + unit);
    print(outputFile, "Mean Distance (< 100 microns): " + meanDistance + " " + unit);
    File.close(outputFile);
    
    close("*");
}

print("All files processed successfully!");
