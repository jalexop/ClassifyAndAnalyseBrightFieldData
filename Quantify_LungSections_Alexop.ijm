/*****************************************************************************
 *  Author Dr. Ioannis K. Alexopoulos
 * The author of the macro reserve the copyrights of the original macro.
 * However, you are welcome to distribute, modify and use the program under 
 * the terms of the GNU General Public License as stated here: 
 * (http://www.gnu.org/licenses/gpl.txt) as long as you attribute proper 
 * acknowledgement to the author as mentioned above.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *****************************************************************************
 * Description of macro
 * --------------------
 * 
 * 
 */
requires("1.53d");
// Create dialog, create save folders, and select file(s) to process
Dialog.create("Parameters");
Dialog.addMessage("PixelClassiffication & Quantification");
Dialog.addFile("Select the Ilastik project file", "");
Dialog.addString("Name of saving folder: ", "_predictions_SimpleSegmentation");
Dialog.show();

// Variables of Dialog
ilastik_file=Dialog.getString();
save_folder=Dialog.getString();

sep = File.separator;

	SourceDir = getDirectory("Choose source directory");
	Filelist=getFileList(SourceDir);
	SAVE_DIR=SourceDir;
	save_folder_name_add=File.getName(SourceDir);
	SERIES_2_OPEN=newArray(1);
	SERIES_2_OPEN[0]=1;

save_folder=save_folder+"_"+save_folder_name_add;
// Remove Folders from Filelist array
tmp=newArray();
for(k=0;k<Filelist.length;k++)
{
	if (!File.isDirectory(SourceDir+"/"+Filelist[k]))
	{
		tmp = Array.concat(tmp,Filelist[k]); 
	}
}
Filelist=tmp;

new_folder=SAVE_DIR + sep + save_folder;
File.makeDirectory(new_folder);
run("Input/Output...", "jpeg=85 gif=-1 file=.xls copy_row save_column save_row");
run("Set Measurements...", "area display redirect=None decimal=3");

		SeriesNames=newArray(Filelist.length);
		TissueArea=newArray(Filelist.length);
		InfiltrativeArea=newArray(Filelist.length);
		RegenerativeArea=newArray(Filelist.length);
		ConnectiveArea=newArray(Filelist.length);
		HealthyArea=newArray(Filelist.length);

for (k=0;k<Filelist.length;k++)
{
		run("Bio-Formats Macro Extensions");
		FILE_PATH=SourceDir + sep + Filelist[k];
		options="open=["+ FILE_PATH + "] " + "autoscale color_mode=Default view=Hyperstack stack_order=XYCZT";
		run("Bio-Formats Importer", options);
		FILE_NAME=File.nameWithoutExtension;
		SERIES_NAMES2=replace(FILE_NAME, " ", "_");
		SERIES_NAMES2=replace(SERIES_NAMES2, "/", "_");
		SERIES_NAMES2=replace(SERIES_NAMES2, "\\(", "");
		SERIES_NAMES2=replace(SERIES_NAMES2, "\\)", "_");
		SeriesNames[k]=SERIES_NAMES2;
		SAVE_NAME=FILE_NAME+"_"+SERIES_NAMES2;
		image_name=getTitle();
		getPixelSize(unit, pixelWidth, pixelHeight);
		run("Run Pixel Classification Prediction", "projectfilename="+ilastik_file+" inputimage=["+image_name+"] pixelclassificationtype=Segmentation");
		run("Duplicate...", "title=duplicate");
		run("glasbey_on_dark");
		selectWindow("duplicate");
		setPixel(pixelWidth, pixelHeight, unit);
		saveAs("tif", new_folder+ sep +image_name+"_PixelSegmentation");

		rename("duplicate");
		run("32-bit");
		setThreshold(2.1, 10);
		run("NaN Background");
		run("Measure");
		TissueArea[k]=getResult("Area", 0);
		run("Clear Results");
		
		run("Duplicate...", "title=Infiltrative");
		run("Duplicate...", "title=Regenerative");
		run("Duplicate...", "title=Connective");
		run("Duplicate...", "title=Healthy");
		
		selectWindow("Infiltrative");
		setThreshold(2.5, 3.5);
		run("NaN Background");
		run("Measure");
		InfiltrativeArea[k]=getResult("Area", 0);
		run("Clear Results");
		
		selectWindow("Regenerative");
		setThreshold(3.5, 4.5);
		run("NaN Background");
		run("Measure");
		RegenerativeArea[k]=getResult("Area", 0);
		run("Clear Results");
		
		selectWindow("Connective");
		setThreshold(4.5, 5.5);
		run("NaN Background");
		run("Measure");
		ConnectiveArea[k]=getResult("Area", 0);
		run("Clear Results");
		
		selectWindow("Healthy");
		setThreshold(5.5, 6.5);
		run("NaN Background");
		run("Measure");
		HealthyArea[k]=getResult("Area", 0);
		run("Clear Results");
		
		run("Close All");
		
}

row=0;
for (i=0;i<Filelist.length; i++) 
{
	setResult("Label", row, SeriesNames[i]);
	setResult("Lung Tissue Area", row, TissueArea[i]);
	setResult("Infiltrative Area", row, InfiltrativeArea[i]);
	setResult("Regenerative Area", row, RegenerativeArea[i]);
	setResult("Connective Area", row, ConnectiveArea[i]);
	setResult("Healthy Area", row, HealthyArea[i]);
	
	setResult("% of Infiltration", row, (InfiltrativeArea[i]/TissueArea[i])*100);
	setResult("% of Regeneration", row, (RegenerativeArea[i]/TissueArea[i])*100);
	setResult("% of Connective Tissue", row, (ConnectiveArea[i]/TissueArea[i])*100);
	setResult("% of Healthy Tissue", row, (HealthyArea[i]/TissueArea[i])*100);
	row++;
	updateResults();
}
selectWindow("Results");
saveAs("Results", new_folder+ sep +"Results_ALL.txt");
run("Clear Results");
run("Close All");
