# A Utility to Assist in taking VCL Form Code into Firemonkey Applications
# FireMonkey is Different

This rough tool was used in the initial phases to do a first cut of the VCL GUITestRunner as a FireMonkey FMX file.

It is included here in case you wish to move other VCL forms.

#Introduction

Delphi XE2 introduces Firemonkey - a cross platform framework for visual controls. Unlike the VCL, FireMonkey is independent of the windows messaging system and APIs and is designed to enable Delphi applications to be compiled to run natively on many platforms. As a new visual framework built from scratch FireMonkey has opened up new possibilities not the least of which is 3 D presentation. I am interested in exploring the possibilities but I also want to maintain as much of the IP that I have built up in Delphi applications to date.

Converting most library functions to co-exist with FireMonkey was relatively straight forward but when it came to Innova Solutions 's standard dialogs the job was potentially very tedious and fraught with danger. There are already plans in the community to semi automate this process but the richness of the VCL will means that it is a lot of work. The approach taken here is to have a customisable tool that does the form conversion so that the manual editing can be minimised and the information acquired as each component class is studied and ported can be fed back into the tool for future form. For programmers who tend to limit themselves to a preferred set of components the information learned on one conversion makes future form conversions less hassle.

FMX files are the Fire Monkey Equivalent of Delphi's VCL DFM form files in that they determine the layout and properties of the objects added to the form at design time. If you are starting a Fire Monkey Form from scratch you will probably never be interested in the contents of the FMX file but if you have a VCL form code which you wish to port to a Fire Monkey application it is nice to take as much of the code as possible across and ideally this includes the form layout. Because Fire Monkey visual objects and their properties are very similar in name to the equivalent VCL components a lot can be automatically ported.

#Tool

This application attempts to take a VCL dfm and pas file and capture as much as possible to carry forward to Fire Monkey Pascal and FMX files. The application uses an ini file to map the translations and relies on Delphi itself throwing away properties that do not correctly translate. The application does no more than a search and replace when generating an FMX file from a text based DFM File and making changes to the Pascal files' uses clause to pick up the Fire Monkey components.

If you are interested in looking at this tool, using it or even extending it then the executable, source code and help file are available here.

Originally published as http://www.innovasolutions.com.au/delphistuf/ADUGVCLtoFMXConv.htm

That location also provides for interest the BPL and some early source code of two components that I am attempting to use to replace VCL components which do not yet appear in the FireMonkey suite. These are a TIsBitButton and a TISAdvStringGrid. At the moment I am stuck on how to port the Bitmap to the TIsBitButton. The TISAdvStringGrid enables the VCL dialogs that rely on the TMS Advanced string grid ported to FMX dialogs to compile and function in a limited way. Innova Solutions is hopeful that TMS will soon be releasing FireMonkey grid components but the exercise has been very useful in gaining and insight into FireMonkey components 

