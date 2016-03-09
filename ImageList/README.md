#FMXImage List Test Project

This Folder contains simple projects to demonstrate the TFMXImageList.

The DUnit testing GUI made use of the VCL TImageList and this component was not available to FireMonkey prior to I think Delphi 10 Seattle.

Had we done the conversion in this version the TFMXImageList would not be required. I am maintaining the TFMXImageList for earlier Delphi Versions and hile the upgrade to TImageList would be easy there seems little gain.
I would not use TFMXImageList in new developments after XE8.

The PowerPoint Slides
https://github.com/rogerinnova/Delphi-Firemonkey-Dunit/ImageListsFMX.ppt give some usage notes. 

The BPL Packages have to be installed in the IDE to use the TFMXImageList on a form in the IDE.

The files FMXListBoxLib and FMXTreeViewLib contain extensions to FireMonkey componants required to interface with TFMXImageList and the DUnit Gui Code.
The Style File StylesForDUnitMobileForm contains the related style changes.