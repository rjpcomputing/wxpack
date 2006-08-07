function OnFinish(selProj, selObj)
{
	try
	{
		var strProjectPath = wizard.FindSymbol('PROJECT_PATH');
		var strProjectName = wizard.FindSymbol('PROJECT_NAME');

		selProj = CreateCustomProject(strProjectName, strProjectPath);
		AddConfig(selProj, strProjectName);
		AddFilters(selProj);

		var InfFile = CreateCustomInfFile();
		AddFilesToCustomProj(selProj, strProjectName, strProjectPath, InfFile);
		InfFile.Delete();

		selProj.Object.Save();
	}
	catch(e)
	{
		if (e.description.length != 0)
			SetErrorInfo(e);
		return e.number
	}
}

function CreateCustomProject(strProjectName, strProjectPath)
{
	try
	{
		var strProjTemplatePath = wizard.FindSymbol('PROJECT_TEMPLATE_PATH');
		var strProjTemplate = '';
		strProjTemplate = strProjTemplatePath + '\\default.vcproj';

		var Solution = dte.Solution;
		var strSolutionName = "";
		if (wizard.FindSymbol("CLOSE_SOLUTION"))
		{
			Solution.Close();
			strSolutionName = wizard.FindSymbol("VS_SOLUTION_NAME");
			if (strSolutionName.length)
			{
				var strSolutionPath = strProjectPath.substr(0, strProjectPath.length - strProjectName.length);
				Solution.Create(strSolutionPath, strSolutionName);
			}
		}

		var strProjectNameWithExt = '';
		strProjectNameWithExt = strProjectName + '.vcproj';

		var oTarget = wizard.FindSymbol("TARGET");
		var prj;
		if (wizard.FindSymbol("WIZARD_TYPE") == vsWizardAddSubProject)  // vsWizardAddSubProject
		{
			var prjItem = oTarget.AddFromTemplate(strProjTemplate, strProjectNameWithExt);
			prj = prjItem.SubProject;
		}
		else
		{
			prj = oTarget.AddFromTemplate(strProjTemplate, strProjectPath, strProjectNameWithExt);
		}
		return prj;
	}
	catch(e)
	{
		throw e;
	}
}

function AddFilters(proj)
{
	try
	{
		// Add the folders to your project
		var strSrcFilter = wizard.FindSymbol('SOURCE_FILTER');
		var group = proj.Object.AddFilter('Source Files');
		group.Filter = strSrcFilter;

		strSrcFilter = wizard.FindSymbol('INCLUDE_FILTER');
		group = proj.Object.AddFilter('Header Files');
		group.Filter = strSrcFilter;

		strSrcFilter = wizard.FindSymbol('RESOURCE_FILTER');
		group = proj.Object.AddFilter('Resource Files');
		group.Filter = strSrcFilter;
		
	}
	catch(e)
	{
		throw e;
	}
}
function AddConfig(proj, strProjectName)
{
	try
	{
		var useDLL = false;
		if( wizard.FindSymbol('WX_USE_MONOLITHIC_DLL') || wizard.FindSymbol('WX_APPTYPE_DLL') || wizard.FindSymbol('WX_USE_DLL') )
		{
			useDLL = true;
		}
		var nCntr;
		for(nCntr = 0; nCntr < 2; nCntr++)
		{
			// Check if it's Debug configuration
			var bDebug = false;
			if( nCntr == 0 )
				bDebug = true;

			// General settings
			var config;
			if(bDebug)
			{ 
				config = proj.Object.Configurations("Debug");
				config.ATLMinimizesCRunTimeLibraryUsage = false;
			}
			else
			{
				config = proj.Object.Configurations("Release");
				config.ATLMinimizesCRunTimeLibraryUsage = true;
			}
			config.IntermediateDirectory = "$(ConfigurationName)";
			config.OutputDirectory = "$(ConfigurationName)";
			if ( wizard.FindSymbol( 'WX_USE_UNICODE' ) )
			{
				config.CharacterSet = charSetUnicode;
			}
			else
			{
				config.CharacterSet = charSetMBCS;
			}
			
			if(wizard.FindSymbol('WX_APPTYPE_DLL'))
			{
				config.ConfigurationType  = typeDynamicLibrary;
			}

			// Compiler settings
			var CLTool = config.Tools('VCCLCompilerTool');
			CLTool.RuntimeTypeInfo = true;
			CLTool.TreatWChar_tAsBuiltInType = false;
			CLTool.Detect64BitPortabilityProblems = true;
			CLTool.WarningLevel = warningLevel_3;
			CLTool.AdditionalIncludeDirectories = "$(WXWIN)/include;$(WXWIN)/additions/include;$(WXWIN)/contrib/include"
			
			var forcedIncludes = "";
			if(wizard.FindSymbol('WX_USE_MONOLITHIC_DLL'))
			{
				forcedIncludes += "$(WXWIN)/lib/vc_dll/msw/wx/setup.h";
			}
			else
			{
				forcedIncludes += " $(WXWIN)/include/msvc/wx/setup.h";
			}
			CLTool.ForcedIncludeFiles = forcedIncludes;
			
			CLTool.PrecompiledHeaderThrough = "$(WXWIN)/include/wx/wxprec.h";
			CLTool.PrecompiledHeaderFile = "$(IntDir)/$(TargetName).pch";
			CLTool.UsePrecompiledHeader = pchOption.pchGenerateAuto;
			
			CLTool.ExceptionHandling = true;
			if(bDebug)
			{
				if( useDLL )
				{
					CLTool.RuntimeLibrary = rtMultiThreadedDebugDLL;
				}
				else
				{
					CLTool.RuntimeLibrary = rtMultiThreadedDebug;
				}
				CLTool.MinimalRebuild = true;
				CLTool.DebugInformationFormat = debugEditAndContinue;
				CLTool.BasicRuntimeChecks = runtimeBasicCheckAll;
				CLTool.Optimization = optimizeDisabled;
			}
			else
			{
				if( useDLL )
				{
					CLTool.RuntimeLibrary = rtMultiThreadedDLL;
				}
				else
				{
					CLTool.RuntimeLibrary = rtMultiThreaded;
				}
				CLTool.DebugInformationFormat = debugDisabled;
			}

			var strDefines = GetPlatformDefine(config);
			strDefines += "STRICT;__WXMSW__;__WX__;";
			if(bDebug)
				strDefines += "_DEBUG;__WXDEBUG;";
			else
				strDefines += "NDEBUG;";
				
			if(wizard.FindSymbol('WX_APPTYPE_CONSOLE'))
			{
				strDefines += "_CONSOLE;wxUSE_GUI=0;";
			}
			else
			{
				strDefines += "_WINDOWS;";
			}
			if( useDLL )
			{
				strDefines += "WXUSINGDLL;";
			}
			CLTool.PreprocessorDefinitions = strDefines;
	
			// Linker settings
			var LinkTool = config.Tools('VCLinkerTool');
			if(wizard.FindSymbol('WX_APPTYPE_CONSOLE'))
			{
				LinkTool.SubSystem = subSystemConsole;
			}
			else
			{
				LinkTool.SubSystem = subSystemWindows;
			}
			LinkTool.TargetMachine = machineX86;
			
			var additionalDepends = "";
			if(bDebug)
			{
				if(wizard.FindSymbol('WX_USE_MONOLITHIC_DLL'))
				{
				    if ( wizard.FindSymbol( 'WX_USE_UNICODE' ) )
				    {
						additionalDepends += "wxmsw26ud.lib ";
					}
					else
					{
					    additionalDepends += "wxmsw26d.lib ";
					}
				}
				LinkTool.LinkIncremental = linkIncrementalYes;
				LinkTool.GenerateDebugInformation = true;
			}
			else
			{
				if(wizard.FindSymbol('WX_USE_MONOLITHIC_DLL'))
				{
					if ( wizard.FindSymbol( 'WX_USE_UNICODE' ) )
				    {
						additionalDepends += "wxmsw26u.lib ";
					}
					else
					{
					    additionalDepends += "wxmsw26.lib ";
					}
				}
				LinkTool.LinkIncremental = linkIncrementalNo;
			}
			additionalDepends += "comctl32.lib rpcrt4.lib winmm.lib wsock32.lib";
			
			if(wizard.FindSymbol('WX_USE_VERSION_RC'))
			{
				additionalDepends += " version.lib"
			}
			
			LinkTool.AdditionalDependencies = additionalDepends;
			
			if(useDLL)
			{
				LinkTool.AdditionalLibraryDirectories = "$(WXWIN)/lib/vc_dll;$(WXWIN)/additions/lib/vc_dll";
			}
			else
			{
				LinkTool.AdditionalLibraryDirectories = "$(WXWIN)/lib/vc_lib;$(WXWIN)/additions/lib/vc_lib";
			}
			
			// Resource settings
			var RCTool = config.Tools("VCResourceCompilerTool");
			RCTool.Culture = rcEnglishUS;
			RCTool.AdditionalIncludeDirectories = "$(IntDir); $(WXWIN)/include";
			if(bDebug)
				RCTool.PreprocessorDefinitions = "_DEBUG";
			else
				RCTool.PreprocessorDefinitions = "NDEBUG";
			
			if(wizard.FindSymbol('WX_USE_AUTOBUILDNUMBER'))
			{
				if(!bDebug)
				{
					var PreBuildTool = config.Tools("VCPreBuildEventTool");
					PreBuildTool.Description = "Incrementing Build Number . . .";
					if ( wizard.FindSymbol('WX_USE_VERSION_RC'))
					{
						var name = wizard.FindSymbol('PROJECT_NAME');
						PreBuildTool.CommandLine = "AutoBuildNumber.exe \"$(ProjectDir)/" + name + ".rc\""
					}
					else
					{
						PreBuildTool.CommandLine = "AutoBuildNumber.exe \"$(ProjectDir)/version.h\" \"#define APP_VERSION_NUMBER\""
					}
				}
			}
		}
	}
	catch(e)
	{
		throw e;
	}
}

function DelFile(fso, strWizTempFile)
{
	try
	{
		if (fso.FileExists(strWizTempFile))
		{
			var tmpFile = fso.GetFile(strWizTempFile);
			tmpFile.Delete();
		}
	}
	catch(e)
	{
		throw e;
	}
}

function CreateCustomInfFile()
{
	try
	{
		var fso, TemplatesFolder, TemplateFiles, strTemplate;
		fso = new ActiveXObject('Scripting.FileSystemObject');

		var TemporaryFolder = 2;
		var tfolder = fso.GetSpecialFolder(TemporaryFolder);
		var strTempFolder = tfolder.Drive + '\\' + tfolder.Name;

		var strWizTempFile = strTempFolder + "\\" + fso.GetTempName();

		var strTemplatePath = wizard.FindSymbol('TEMPLATES_PATH');
		var strInfFile = strTemplatePath + '\\Templates.inf';
		wizard.RenderTemplate(strInfFile, strWizTempFile);

		var WizTempFile = fso.GetFile(strWizTempFile);
		return WizTempFile;
	}
	catch(e)
	{
		throw e;
	}
}

function GetTargetName(strName, strProjectName)
{
	try
	{
		var strTarget = strName;
		var strResPath = "res\\";
		
		if(strName.substr(0, 4) == "root")
		{
			var nNameLen = strName.length;
			if(strName == "root.ico" || strName == "root.exe.Manifest")
			{
				strTarget = strResPath + strProjectName + strName.substr(4, nNameLen - 4);
			}
			else
			{
				strTarget = strProjectName + strName.substr(4, nNameLen - 4);
			}
		}
		else if(strName.substr(0, 4) == "safe")
		{
			var nNameLen = strName.length;
			var strSafeProjectName = wizard.FindSymbol('SAFE_PROJECT_NAME');
			strTarget = strSafeProjectName + strName.substr(4, nNameLen - 4);
		}

		return strTarget; 
	}
	catch(e)
	{
		throw e;
	}
}

function AddFilesToCustomProj(proj, strProjectName, strProjectPath, InfFile)
{
	try
	{
		var wxfbFilter;
		if(wizard.FindSymbol('WX_USE_FORMBUILDER'))
		{
			strSrcFilter = wizard.FindSymbol('FORMBUILDER_FILTER');
			wxfbFilter = proj.Object.AddFilter('wxFormBuilder Files');
			wxfbFilter.Filter = strSrcFilter;
		}
		var projItems = proj.ProjectItems

		var strTemplatePath = wizard.FindSymbol('TEMPLATES_PATH');
		var strSafeProjectName = wizard.FindSymbol('SAFE_PROJECT_NAME');

		var strTpl = '';
		var strName = '';

		var strTextStream = InfFile.OpenAsTextStream(1, -2);
		while (!strTextStream.AtEndOfStream)
		{
			strTpl = strTextStream.ReadLine();
			if (strTpl != '')
			{
				strName = strTpl;
				var strTarget = GetTargetName(strName, strProjectName);
				var strTemplate = strTemplatePath + '\\' + strTpl;
				var strFile = strProjectPath + '\\' + strTarget;

				var bCopyOnly = false;  //"true" will only copy the file from strTemplate to strTarget without rendering/adding to the project
				var strExt = strName.substr(strName.lastIndexOf("."));
				if(strExt==".bmp" || strExt==".ico" || strExt==".gif" || strExt==".rtf" || strExt==".css" || strExt== ".exe")
					bCopyOnly = true;
				wizard.RenderTemplate(strTemplate, strFile, bCopyOnly);
				if ( bCopyOnly )
					continue;
				
				if( strTarget == strSafeProjectName + "_GUI.cpp" || strTarget == strSafeProjectName + "_GUI.h" )
				{
					if(wizard.FindSymbol('WX_USE_FORMBUILDER'))
					{
						// Add Files to wxFormBuilder Filter
						wxfbFilter.AddFile(strFile);
					}		
				}
				else
				{
					// Add Files to Project
					proj.Object.AddFile(strFile);
				}
			}
		}
		strTextStream.Close();
	}
	catch(e)
	{
		throw e;
	}
}
