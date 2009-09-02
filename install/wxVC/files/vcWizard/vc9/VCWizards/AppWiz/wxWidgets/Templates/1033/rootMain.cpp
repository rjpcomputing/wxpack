[!if WX_TEST_SNGLINST]
#include "wx/snglinst.h"
[!endif]
[!if WX_USE_CMDLINE]
#include "wx/datetime.h"
#include "wx/cmdline.h"

// ----------------------------------------------------------------------------
// wxCmdLineParser
// ----------------------------------------------------------------------------

static void ShowCmdLine( const wxCmdLineParser& parser )
{
	wxString s = wxT("Input files: ");

	size_t count = parser.GetParamCount();
	for ( size_t param = 0; param < count; param++ )
	{
		s << parser.GetParam( param ) << ' ';
	}

	s << '\n'
		<< wxT("Verbose:\t") << ( parser.Found(wxT("v")) ? wxT("yes") : wxT("no") ) << '\n'
		<< wxT("Quiet:\t") << ( parser.Found(wxT("q")) ? wxT("yes") : wxT("no") ) << '\n';

	wxString strVal;
	long lVal;
	wxDateTime dt;
	if ( parser.Found( wxT("o"), &strVal ) )
		s << wxT("Output file:\t") << strVal << '\n';
	if ( parser.Found( wxT("i"), &strVal ) )
		s << wxT("Input dir:\t") << strVal << '\n';
	if ( parser.Found( wxT("s"), &lVal ) )
		s << wxT("Size:\t") << lVal << '\n';
	if ( parser.Found( wxT("d"), &dt ) )
		s << wxT("Date:\t") << dt.FormatISODate() << '\n';
	if ( parser.Found( wxT("project_name"), &strVal ) )
		s << wxT("Project:\t") << strVal << '\n';

	wxLogMessage( s );
}

[!if WX_TEST_CMDLINE]
static void TestCmdLineConvert()
{
	static const wxChar *cmdlines[] =
	{
		wxT("arg1 arg2"),
			wxT("-a \"-bstring 1\" -c\"string 2\" \"string 3\""),
			wxT("literal \\\" and \"\""),
	};

	for ( size_t n = 0; n < WXSIZEOF(cmdlines); n++ )
	{
		const wxChar *cmdline = cmdlines[n];
		wxPrintf( wxT("Parsing: %s\n"), cmdline );
		wxArrayString args = wxCmdLineParser::ConvertStringToArgs( cmdline );

		size_t count = args.GetCount();
		wxPrintf( wxT("\targc = %u\n"), count );
		for ( size_t arg = 0; arg < count; arg++ )
		{
			wxPrintf( wxT("\targv[%u] = %s\n"), arg, args[arg].c_str() );
		}
	}
}
[!endif]
[!endif]

int main( int argc, char* argv[] )
{
	wxApp::CheckBuildOptions( WX_BUILD_OPTIONS_SIGNATURE, wxT("program") );

	wxInitializer initializer;
	if ( !initializer )
	{
		fprintf( stderr, wxT("Failed to initialize the wxWidgets library, aborting.") );
		return -1;
	}

[!if WX_TEST_SNGLINST]
	wxSingleInstanceChecker checker;
	if ( checker.Create( wxT(".wxconsole.lock") ) )
	{
		if ( checker.IsAnotherRunning() )
		{
			wxPrintf( wxT("Another instance of the program is running, exiting.\n") );

			return 1;
		}

		// wait some time to give time to launch another instance
		wxPrintf( wxT("Press \"Enter\" to continue...") );
		wxFgetc( stdin );
	}
	else // failed to create
	{
		wxPrintf( wxT("Failed to init wxSingleInstanceChecker.\n") );
	}
[!endif]

[!if WX_TEST_CMDLINE]
	TestCmdLineConvert();
[!endif]

[!if WX_USE_CMDLINE]
	static const wxCmdLineEntryDesc cmdLineDesc[] =
	{
		{ wxCMD_LINE_SWITCH, wxT("h"), wxT("help"), wxT("show this help message"), wxCMD_LINE_VAL_NONE, wxCMD_LINE_OPTION_HELP },
		{ wxCMD_LINE_SWITCH, wxT("v"), wxT("verbose"), wxT("be verbose") },
		{ wxCMD_LINE_SWITCH, wxT("q"), wxT("quiet"),   wxT("be quiet") },
		{ wxCMD_LINE_OPTION, wxT("o"), wxT("output"),  wxT("output file") },
		{ wxCMD_LINE_OPTION, wxT("i"), wxT("input"),   wxT("input dir") },
		{ wxCMD_LINE_OPTION, wxT("s"), wxT("size"),    wxT("output block size"), wxCMD_LINE_VAL_NUMBER },
		{ wxCMD_LINE_OPTION, wxT("d"), wxT("date"),    wxT("output file date"),	wxCMD_LINE_VAL_DATE },
		{ wxCMD_LINE_PARAM,  NULL, NULL, wxT("input file"),	wxCMD_LINE_VAL_STRING, wxCMD_LINE_PARAM_MULTIPLE },
		{ wxCMD_LINE_NONE }
	};

	wxCmdLineParser parser( cmdLineDesc, argc, argv );

	parser.AddOption( wxT("project_name"), wxT(""), wxT("full path to project file"),
		wxCMD_LINE_VAL_STRING,
		wxCMD_LINE_OPTION_MANDATORY | wxCMD_LINE_NEEDS_SEPARATOR );

	switch ( parser.Parse() )
	{
	case -1:
		wxLogMessage( wxT("Help was given, terminating.") );
		break;

	case 0:
		ShowCmdLine( parser );
		break;

	default:
		wxLogMessage( wxT("Syntax error detected, aborting.") );
		break;
	}
[!endif]

	wxUnusedVar( argc );
	wxUnusedVar( argv );
	return 0;
}
