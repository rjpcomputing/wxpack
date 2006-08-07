/*************************************************************
*
* Author:	upCASE (wxForum)
* Source:	http://wxforum.shadonet.com/viewtopic.php?t=8193
* Licence:	wxWidgets Licence
* Comment:	Used to retrieve the version information
*      		from a resource in Windows.
*
*************************************************************/

#ifndef __FILEVERSION_H_
#define __FILEVERSION_H_

#include <wx/wx.h>

#ifdef __WXMSW__

class wxFileVersion
{
public:
	wxFileVersion();
	~wxFileVersion();

	bool    Open( wxString strModuleName = wxEmptyString );
	void    Close();

	wxString QueryValue( wxString strValueName, unsigned long dwLangCharset = 0 );

	wxString GetFileDescription()  { return QueryValue( wxT("FileDescription") );  };
	wxString GetFileVersion()      { return QueryValue( wxT("FileVersion") );      };
	wxString GetInternalName()     { return QueryValue( wxT("InternalName") );     };
	wxString GetCompanyName()      { return QueryValue( wxT("CompanyName") );      };
	wxString GetLegalCopyright()   { return QueryValue( wxT("LegalCopyright") );   };
	wxString GetOriginalFilename() { return QueryValue( wxT("OriginalFilename") ); };
	wxString GetProductName()      { return QueryValue( wxT("ProductName") );      };
	wxString GetProductVersion()   { return QueryValue( wxT("ProductVersion") );   };

	bool     GetFixedInfo( VS_FIXEDFILEINFO& vsffi );
	wxString GetFixedFileVersion( bool HumanlyReadable = false );
	wxString GetFixedProductVersion( bool HumanlyReadable = false );

protected:
	unsigned char*  m_lpVersionData;
	unsigned long   m_dwLangCharset;
};

#endif //__WXMSW__
#endif  // __FILEVERSION_H_
