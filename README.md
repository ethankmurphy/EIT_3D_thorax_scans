# EIT_3D_thorax_scans
Matlab functions that take a raw iPhone from Heges 3D scanning app and labels 32 electrodes on a chest belt. The main function, run_multiview_labeling.m, performs the following steps:
* Load, crop, and fixes up the 3D scan and save it as a Matlab file
* Via clicking obtains the locations of all the electrodes
* Then the scan is levels and a smooth fit to the surface is constructed
  * The times are recorded
  * The simple smooth surface, the 3D scan, and the electrodes locations are saved

There is an example mat-file, 1675357621o1471639_crop.mat, accompanying the code, which is the cropped/processed results prior to find electrodes. A raw file was not included due to its size (100+ MB). An example of the cropping is given below: 
![crop_example](https://user-images.githubusercontent.com/87721360/219489294-35bcaa3c-45ac-4705-ac4f-593a9c660ca5.PNG)

The clicking/finding electrodes is dependent on your setup. Our setup for the 32-electrode belt consisted of white and colored stickers. The colored stickers skipped 4 electrodes and were located on 7, 12, 17, 22, 27, and 32 - each with a different color (see below). 
![belt_description](https://user-images.githubusercontent.com/87721360/219490218-88046684-a4b1-4011-aea8-fd2b72f635c4.png)

The codes run_multiview_prj_alg_v3.m and ord_elecs.m located in the mfiles folder use these assumptions to create a logical sequence for clicking and then for ordering the electrodes. There is a while loop that continues until all electrodes are labeled. Note for our example electrodes 1-5 are obscured by the clasp and are located 1-5 from right to left starting just left of the pink sticker (electode 32). The cropping figure is shown below, 6 views below, where if something is clicked on it is automatically updated in any other subplot where its visible. 
![clicking_electrodes_example](https://user-images.githubusercontent.com/87721360/219491227-ba5c5152-1c63-445c-925e-9cbf73e4f0e9.PNG)

The final output looks something like this
![example_3Dscan_processed](https://user-images.githubusercontent.com/87721360/219486568-4cdbe6f9-fca5-4499-be2e-188814e60ef1.png)
