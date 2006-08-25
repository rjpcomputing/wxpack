#include "[!output PROJECT_NAME].h"
#include "[!output PROJECT_NAME]Frame.h"

IMPLEMENT_APP( MyApp );

bool MyApp::OnInit()
{
[!if WX_USE_FORMBUILDER]
	[!output SAFE_PROJECT_NAME]Frame* frame = new [!output SAFE_PROJECT_NAME]Frame();
[!else]
	[!output SAFE_PROJECT_NAME]Frame* frame = new [!output SAFE_PROJECT_NAME]Frame( 0L, wxT("[!output PROJECT_NAME]") );
[!endif]
	frame->SetIcon( wxICON( amain ) );
	frame->Show();
	return true;
}
