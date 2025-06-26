folder = getDirectory("Choose directory containing ROI.zip files for marker A");
fileList = getFileList(folder);

for (f = 0; f < fileList.length; f++) {
    if (endsWith(fileList[f], ".zip")) {
        // Set the current roi.zip file path
        roiFile = folder + fileList[f];
        roiManager("reset");
        roiManager("open", roiFile);
        roiCount = roiManager("count");

        outputFile = folder + replace(fileList[f], ".zip", "_coordinates.xml");

        xml = "<ROICoordinates>\n";

        run("Clear Results");

        for (i = 0; i < roiCount; i++) {
            roiManager("select", i); // Select the current ROI
            run("Measure"); // Measure to get the X and Y centroid coordinates

            xCentroid = getResult("X", nResults-1);
            yCentroid = getResult("Y", nResults-1);

            xml += "\t<ROI>\n";
            xml += "\t\t<Centroid>\n";
            xml += "\t\t\t<X>" + xCentroid + "</X>\n";
            xml += "\t\t\t<Y>" + yCentroid + "</Y>\n";
            xml += "\t\t</Centroid>\n";
            xml += "\t</ROI>\n";

            // Clear the Results table for the next measurement
            run("Clear Results");
        }

        xml += "</ROICoordinates>";

        File.saveString(xml, outputFile);

        print("XML file saved successfully at: " + outputFile);
    }
}

print("Processing complete.");
