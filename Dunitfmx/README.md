#A FireMonkey Version of Dunit Testing Which Should work on any Platform  


Originally presented to ADUG 
http://docs.innovasolutions.com.au/Docs/ADUGDelphi/ADUGDecember2014.html
At a stage where it had been tested on Win32, Win64 and Mac OS this code has been further advanced so that it now works on Android devices.

Modifications made here were required because the of the limited file handling on these devioces and the removal of AnsiString from the NextGen compiler and the lack of Menus on Mobile Devices.

This version also does away with the requirement for a startup screen and a modal show of the Gui form.

For a new project make GUITestRunnerFMXMobile the main form, Include the Libraries in the search and add your test code to the project. 

The files FMXListBoxLib and FMXTreeViewLib contain extensions to FireMonkey componants required to interface with TFMXImageList and the DUnit Gui Code.
The Style File StylesForDUnitMobileForm contains the related style changes.

#Note
To be able to view and change the GUITestRunnerFMXMobile you will have to add the two package files in the Imagelist BPLs https://github.com/rogerinnova/Delphi-Firemonkey-Dunit/tree/master/Imagelistpkg

With the introduction of specialised device forms about XE7 there are problems using forms in an earlier version of Delphi so the code has a a Delphi 10 Seattle (D10S) Project and Gui form which has been tested on Android and a couple of back converted XE5 and XE6 versions which should happilly move forward but which I am unable to confirm mobile compatibility.


#A Additions March 
I further developed my DUnit form to reduce the pain of navigating around the very large test framework I was working on. This was in the context of the testing project not the sample DUnit project and so did not get to the github code. I have now added latest form code (Berlin and Tokyo) to the repository. In case someone is interested. I have only every exercised the IOS version on the emulator.

I am happy to help anyone further this project. The main point is that provided you can put together a suitable FMX form the rest of the DUnit code seems to both compile and work.


  
