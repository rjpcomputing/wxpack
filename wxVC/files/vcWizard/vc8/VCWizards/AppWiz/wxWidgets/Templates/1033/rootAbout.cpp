#include "[!output PROJECT_NAME].h"
#include "[!output PROJECT_NAME]About.h"
[!if WX_USE_AUTOBUILDNUMBER]
[!if WX_USE_VERSION_RC]
#include "fileversion.h"
[!else]
#include "version.h"
[!endif]
[!endif]

// About dialog's event loop.
// Not needed because we only have a default OK button.
//BEGIN_EVENT_TABLE( [!output SAFE_PROJECT_NAME]About, AboutDlg )
	//EVT_BUTTON( wxID_OK, [!output SAFE_PROJECT_NAME]About::OnOK )
//END_EVENT_TABLE()

[!output SAFE_PROJECT_NAME]About::[!output SAFE_PROJECT_NAME]About( wxWindow* parent )
	: AboutDlg( parent, -1 )
{
[!if WX_USE_AUTOBUILDNUMBER]
[!if WX_USE_VERSION_RC]
	wxFileVersion ver;
	
	// Open the current executable's version information.
	ver.Open();
	
	// Get the file version.
	wxString fileVersion = ver.GetFixedFileVersion( true );
	
	// Set the version label.
	m_staticVersion->SetLabel( m_staticVersion->GetLabel() + wxT(" ") + fileVersion );
[!else]
	m_staticVersion->SetLabel( m_staticVersion->GetLabel() + wxT(" " APP_VERSION_NUMBER) );
[!endif]
[!endif]
}
