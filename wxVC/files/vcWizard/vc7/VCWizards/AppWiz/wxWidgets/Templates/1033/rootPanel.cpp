#include "[!output PROJECT_NAME]Panel.h"

BEGIN_EVENT_TABLE([!output SAFE_PROJECT_NAME]Panel, wxPanel)
	EVT_BUTTON(ID_MAIN_OK, [!output SAFE_PROJECT_NAME]Panel::OnOK)
END_EVENT_TABLE()

[!output SAFE_PROJECT_NAME]Panel::[!output SAFE_PROJECT_NAME]Panel( wxWindow* parent, int id, wxPoint pos, wxSize size, int style )
	: MainPanel( parent, id, pos, size, style )
{
}

[!output SAFE_PROJECT_NAME]Panel::~[!output SAFE_PROJECT_NAME]Panel()
{
}

void [!output SAFE_PROJECT_NAME]Panel::OnOK( wxCommandEvent& event )
{
	wxMessageBox( wxT("OK Button Pressed") );
}