#include <iostream>

#include <wx/cmdline.h>

static const wxCmdLineEntryDesc cmdLineDesc[] =
{
	{ wxCMD_LINE_SWITCH, wxT("h"), wxT("help"), wxT("Show this help message."), wxCMD_LINE_VAL_NONE, wxCMD_LINE_OPTION_HELP },
	{ wxCMD_LINE_SWITCH, wxT("v"), wxT("verbose"), wxT("Show verbose output.") },
	{ wxCMD_LINE_PARAM,  NULL, NULL, wxT("input file"),	wxCMD_LINE_VAL_STRING, wxCMD_LINE_PARAM_MULTIPLE },
	{ wxCMD_LINE_NONE }
};

int main( int argc, char* argv[] )
{
[!if WX_USE_DLL || WX_USE_MONOLITHIC_DLL]
	// Verify that the wxWidgets library was built with the same options
	// as this program. Aborts on fail.
	wxApp::CheckBuildOptions( WX_BUILD_OPTIONS_SIGNATURE, "program" );

[!endif]
	// Initialize the wxWidgets library
	wxInitializer initializer;
	if ( !initializer.IsOk() )
	{
		std::cerr << wxT("Failed to initialize the wxWidgets library, aborting.");
		return 1;
	}
	
	wxCmdLineParser parser( cmdLineDesc, argc, argv );
	if( parser.Parse() )
	{
		// Either the user requested help or there was a syntax error.
		// The help message has been displayed and there is nothing left to do.
		return 2;
	}
	
	wxLog::SetVerbose( parser.Found( wxT("v") ) );
	
	wxString inputFiles;
	for ( size_t param = 0; param < parser.GetParamCount(); ++param )
	{
		inputFiles << parser.GetParam( param ) << wxT(" ");
	}

	wxLogVerbose( wxT("Found the following input files: %s"), inputFiles.c_str() );

	wxLogMessage( wxT("Program Complete") );
	
	return 0;
}
