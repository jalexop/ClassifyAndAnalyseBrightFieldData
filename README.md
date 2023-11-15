System Requirements
--------------------------
The Fiji macro requires an ImageJ/Fiji installation (minimum version 1.53) as well as an Ilastik installation.
The software has been tested on an Ubuntu 20.04 operating system running ImageJ/Fiji version 1.54f and an Ilastik version 1.4.0
The software does not require any non-standard hardware. However, because of Ilastik installation, 64bit processor and a minimum of 8GB of RAM are required.


Installation Guide
--------------------------
For the installation of ImageJ/Fiji, please follow the instructions provided at https://fiji.sc website:
Download Fiji for the required operating system and unpack the .zip file at a location with read and write permissions. 

For the installation of Ilastik, please follow the instructions provided at the following address:
https://www.ilastik.org/documentation/basics/installation

The provided Fiji macro, does not require any installation and can be opened with drag and drop in Fiji window. However, it is required to install the ilastik plugin in Fiji and locate the executable file of Ilastik.

Depending on the network connection speed, the installation of ImageJ / Fiji and Ilastik can last a few minutes on a normal desktop computer. The macro does not require any installation.


Demo
--------------------------

Instructions
In order to run the software on the demo data provided, and upon successful installation of the required software please follow the steps below:
1) Open Fiji and drag & drop on Fiji window the .ijm provide file (Quantify_LungSections_Alexop.ijm)
2) Click on Run button and on the dialogue window select the classification file (MassonsStaining_Classification_6Classes.ilp) which at the same folder as the macro file. Give a unique name for the output folder (otherwise, any previous results from the same data set with the same default output folder name will be overwritten).
3) Next select the folder with the demo images and select open

Expected output
The macro will generate an extra folder within the input folder (DemoDataSet) which will contain all the output image files in .tif format as well as a tab-separated .txt file with all quantifications. The classified images will have pixels with 6 different intensities: intensity 1=Background, intensity 2=non-lung tissue, intensity 3=infiltrative area, intensity 4=regenerative area, intensity 5=connective tissue, intensity 6=healthy tissue.

Expected runtime on a normal computer
The expected runtime of the demo dataset is around 10min.


Instructions for use
--------------------------
The same instructions provided above can be followed in order to run the software on our data.
