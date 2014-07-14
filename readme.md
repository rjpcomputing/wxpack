## Steps

* Tweak setup.h
* Update version in wxCompiled, wxVC, wxAdditions, wxPack .iss
* Download the latest version of the CHM help files for wxWidgets and extract the zip to 'support/'.
* Update to the latest wxWidgets Git tag.
	* git submodule init
	* git submodule update
	* cd wxwidgets
	* git checkout WX_2_8_12
	* cd ..
	* git add wxwidgets
	* git commit -m "moved submodule to WX_2_8_12"
	* git push
