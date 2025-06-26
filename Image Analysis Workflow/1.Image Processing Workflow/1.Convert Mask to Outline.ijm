// Select the relevant input and output folders

inputFolder = getDirectory("Choose the input folder containing the epidermis mask images");
outputFolder = getDirectory("Choose the output folder to save epidermis mask outlines");

list = getFileList(inputFolder);
for (i = 0; i < list.length; i++) {
    // Open the image
    open(inputFolder + list[i]);
    
    originalImageTitle = getTitle();
    run("Duplicate...", " ");
    duplicatedImageTitle = getTitle();
    setOption("BlackBackground", true);
    run("Dilate");
    run("Calculator Plus", "i1=[" + duplicatedImageTitle + "] i2=[" + originalImageTitle + "] operation=[Subtract: i2 = (i1-i2) x k1 + k2] k1=1 k2=0 create");
    resultImageTitle = getTitle();
    selectWindow(resultImageTitle);
    run("Skeletonize");
    run("Convert to Mask");

    saveAs("Tiff", outputFolder + list[i]);
    close("*");
}
print("Processing complete. Files saved to " + outputFolder);

