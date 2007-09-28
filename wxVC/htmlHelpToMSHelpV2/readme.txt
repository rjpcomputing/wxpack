How to create Microsofts Help 2.x help from a HTML Help v1.x (.chm) file.
--------------------------------------------------------------------------------

!! Purpose
Give the needed steps to create MS Help 2.x help from a HTML Help v1.x (.chm).
This has only been tested to work on the wxWidgets Help file (wx.chm).

!! Prerequisites
* FAR : Used to compile and sort the H2 help file
	- http://helpware.net
* Visual Studio SDK : Used by FAR to convert the HTML Help v1.x file (.chm) to H2 (.HxS)
	- http://msdn.microsoft.com/vstudio/extend/
* Keytools : Used to decompile the HTML Help file and create the needed HTML Help project file (.hhp).
	- http://www.keyworks.net/keytools.htm
* H2Reg : H2Reg.exe is a small utility (180K), that allows you to register MS Help 2.x Collections
	- http://www.helpware.net/mshelp2/h2reg.htm
* Lua v5.1.1+ : Used to run the custom script I wrote to convert the HTML Help v1.x index file correctly.
	- http://lua.org
* htmlHelpToMSHelpV2.lua v2.00 : Custom script to convert the HTML Help v1.x index file to H2 format correctly.

!! Steps
# Use 'Keytools' to decompile the HTML Help v1.x file (.chm).
# Fix the .hhk file:
## Search for all occurances of "<A HREF=" and on those lines only the function name is needed.
# Copy the .hhk file to where htmlHelpToMSHelpV2.lua is stored.
# Open a command prompt and navigate to where 'htmlHelpToMSHelpV2.lua' is stored.
# Type \\
	@@lua htmlHelpToMSHelpV2.lua <file.hhk> [filterdocsetname]@@
# Open 'FAR'
## Select @@Authoring -> H2 Utilities...@@ (Shift+Ctrl+2)
## Select the @@Convert 1.x@@ tab.
## Fill in the @@.Chm or .Hhp Input File:@@ box with the location you decompiled the .chm file with 'Keytools'.
## Fill in the @@Project Output Folder:@@ box with the location you want the new MS Help 2.x files stored.
## Click the @@Run HxConv.exe@@ button. After this finishes the project has been converted.
# Copy the @@htmlHelpToMSHelpV2.lua@@ created .HxK file to the FAR Project Output Folder. Overwrite the existing one.
# Copy the 'wx_A.hxk', 'wx_F.hxk', and 'wx_N.hxk' to the FAR Project Output Folder.
# Add these lines to the wx.HxC file: ( right around the <TOCDef File="wx.HxT"/>)
## <AttributeDef File="wx.HxA"/>
## <VTopicDef File="wx.HxV"/>
## <KeywordIndexDef File="wx_A.hxk"/>
## <KeywordIndexDef File="wx_F.hxk"/>
## <KeywordIndexDef File="wx_N.hxk"/>
# In 'FAR'
## Select @@Authoring -> H2 Project Editor...@@ (Ctrl+Alt+2)
## Select the .HxC file in the @@Project Output Folder:@@ location you converted the HTML Help v1.x file (.chm).
## Fill in the details for the @@H2 Project -> General@@ dialog as needed.
## Select @@Command -> Edit Index File...@@ (Ctrl+I)
## In the "Index Editor" that opens select @@TOC -> Sort...@@ (Shift+Ctrl+Z)
## A dialog opens and you should be able to just to click @@OK@@. Just in case make sure 'Ignore Case' is checked and "Sort Type" is set to 'Text'.
## Select @@File -> Save...@@ (Ctrl+S) and exit the "Index Editor".
# In the "H2 Project Editor" select the @@Compile@@ item.
## Click the @@Compile Project@@ button.
## If asked save the changes.
## As long as there were no errors you can click @@Close@@ on the compile log dialog.
# Close FAR. You are done with it.
# Now the MS Help v2.x files are created. Just copy @@*.HxC, *.HxF, *.HxK, *.HxS, *.HxT@@ to there final resting spot. (ie. C:\Program Files\Help Files)
# Place @@H2Reg.exe@@, @@H2Reg.ini@@, and @@H2Reg_Cmd.ini@@ in the same directory as your compiled MS Help v2.x files.
# Open the @@H2Reg_Cmd.ini@@ in any text editor and change the settings to match your MS Help v2.x files. (ex: if your name has wxWidgets.284 and you now are on version wxWidgets.285)
# Register the help files by running the H2Reg.exe from the command line.
** Register (install)
*** @@$ H2Reg.exe -r cmdfile=H2Reg_Cmd.ini@@
** Unregister (uninstall)
*** @@$ H2Reg.exe  -u cmdfile=H2Reg_Cmd.ini@@
>>frame<<
You are now done.
>><<