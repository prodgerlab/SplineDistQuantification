originalTitle = getTitle();
nameWithoutExtension = originalTitle.substring(0, originalTitle.lastIndexOf("."));
newFileName = nameWithoutExtension + "_CutOutline.tif";

// Specify the full path for saving the image
fullPath = "/media/prodgerlab/One Touch/Final Analysis APM/Factory/Outline/" + newFileName;
saveAs("Tiff", fullPath);
close();
