//Requires Marker A in .xml file format from the previous script, Marker B is in .RoiZip

newImage("Untitled", "8-bit black", 20000, 20000, 1);
xmlDir = getDirectory("Choose a xml Directory"); // Update with your XML files directory path
roiDir = getDirectory("Choose a roi Directory"); // Update with your ROI files directory path
//imgDir = getDirectory("Choose a img Directory"); // Update with your images directory path

xmlFiles = getFileList(xmlDir);
roiFiles = getFileList(roiDir);
//imgFiles = getFileList(imgDir);
results = newArray();


for (i = 0; i < xmlFiles.length; i++) {
    // Define file paths for the current iteration
    //imgFile = imgDir + imgFiles[i];
    xmlFile = xmlDir + xmlFiles[i];
    roiZipFile = roiDir + roiFiles[i];
    

function parseMarkers(xmlText) {
    markers = newArray();  // Initialize an empty array for markers
    
    while (indexOf(xmlText, "<ROI>") != -1) {
        // Extract the X coordinate
        markerX = parseInt(substring(xmlText, indexOf(xmlText, "<X>") + 3, indexOf(xmlText, "</X>")));
        
        // Extract the Y coordinate
        markerY = parseInt(substring(xmlText, indexOf(xmlText, "<Y>") + 3, indexOf(xmlText, "</Y>")));
        
        // Append the X and Y coordinates to the markers array
        markers = Array.concat(markers, markerX);
        markers = Array.concat(markers, markerY);
        
        // Move to the next ROI by trimming the processed portion of the XML
        xmlText = substring(xmlText, indexOf(xmlText, "</ROI>") + 6);
    }
    return markers;  // Return the list of markers (x, y pairs)
}

    
    markers = parseMarkers(xmlText);
    
    roiManager("reset");
    for (j = 0; j < markers.length; j += 2) { // Loop through markers array (x, y pairs)
        x = markers[j];
        y = markers[j + 1];
        makeOval(x - 10, y - 10, 15, 15); // Create circular ROI (adjust size as needed)
        roiManager("Add");
    }
    
    roiManager("reset");
    open(roiZipFile);
    
    insideCount = 0;
    notInsideCount = 0;
    
    for (selection = 0; selection < roiManager("count"); selection++) {
        // Select the current ROI
        roiManager("select", selection);
        
        inside = false;
        
        for (k = 0; k < markers.length; k += 2) {
            x = markers[k];
            y = markers[k + 1];
            
            // Check if the marker (x, y) is inside the current ROI
            if (Roi.contains(x, y)) {
                inside = true; // Set inside flag to true
                break; // Exit loop early if inside is found for efficiency
            }
        }
        
        if (inside) {
           // print("Image " + imgFiles[i] + " ROI " + selection + ": Inside");
            insideCount++;
        } else {
           // print("Image " + imgFiles[i] + " ROI " + selection + ": Not Inside");
            notInsideCount++;
        }
    }
    
    results = Array.concat(results, newArray(xmlFiles[i], insideCount, notInsideCount));
    
    // Close the current image
    //close();/home/prodgerlab/Desktop/Other Cells Analysis/Old Scripts/count rois.ijm
}

// Print the table header
print("Image Name\tInside Count\tNot Inside Count");

// Print the results
for (i = 0; i < results.length; i += 3) {
    print(results[i] + "\t" + results[i+1] + "\t" + results[i+2]);
}
