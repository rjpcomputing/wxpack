#ifndef STDWX_H_INCLUDED
#define STDWX_H_INCLUDED

#if (_MSC_VER >= 1400) // VC8+
 #ifndef _CRT_NONSTDC_NO_DEPRECATE
  #define _CRT_NONSTDC_NO_DEPRECATE
 #endif
#endif // VC8+

#ifdef _MSC_VER
	#include <msvc/wx/setup.h>
	
	//Necessary Windows Libraries
	#pragma comment( lib, "comctl32.lib" )
	#pragma comment( lib, "rpcrt4.lib" ) 
	#pragma comment( lib, "winmm.lib" )
	#pragma comment( lib, "wsock32.lib" )
#endif

#if ( defined(USE_PCH) && !defined(WX_PRECOMP) )
    #define WX_PRECOMP
#endif // USE_PCH

// basic wxWidgets headers
#include <wx/wxprec.h>

#ifdef __BORLANDC__
	#pragma hdrstop
#endif

#ifndef WX_PRECOMP
	#include <wx/wx.h>
#endif

#ifdef USE_PCH
	// put here all your rarely-changing header files
#endif // USE_PCH

#endif // STDWX_H_INCLUDED
