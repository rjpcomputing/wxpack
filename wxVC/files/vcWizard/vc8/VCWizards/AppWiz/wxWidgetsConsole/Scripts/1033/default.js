
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
		PchSettings(selProj);
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
		if( wizard.FindSymbol('WX_USE_MONOLITHIC_DLL') || wizard.FindSymbol('WX_USE_DLL') )
		{
			useDLL = true;
		}
		
		// Setup the project twice, once for the Debug configuration, once for Release
		var i;
		for ( i = 0; i < 2; i++ )
		{
			// Do debug configuration first
			var isDebug;
			var config;
			if ( 0 == i )
			{
			    isDebug = true;
                config = proj.Object.Configurations("Debug");
            }
            else
            {
                isDebug = false;
                config = proj.Object.Configurations("Release");
            }
            
			// General settings			
			config.ATLMinimizesCRunTimeLibraryUsage = true;
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

			// Compiler settings
			var CLTool = config.Tools('VCCLCompilerTool');
			CLTool.RuntimeTypeInfo = true;
			CLTool.TreatWChar_tAsBuiltInType = false;
			CLTool.Detect64BitPortabilityProblems = true;
			CLTool.WarningLevel = warningLevel_3;
			CLTool.AdditionalIncludeDirectories = "$(WXWIN)/include;$(WXADDITIONS)/include;$(WXWIN)/contrib/include"
			
			// Forced includes and precompiled header
			var forcedIncludes = "$(WXWIN)/include/wx/wxprec.h;"
			if ( wizard.FindSymbol('WX_USE_MONOLITHIC_DLL') )
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
			CLTool.UsePrecompiledHeader = pchCreateUsingSpecific;
			
			// Debug settings, runtime library
			if ( isDebug )
			{
				if ( useDLL )
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
				if ( useDLL )
				{
					CLTool.RuntimeLibrary = rtMultiThreadedDLL;
				}
				else
				{
					CLTool.RuntimeLibrary = rtMultiThreaded;
				}
				CLTool.DebugInformationFormat = debugDisabled;
			}

            // Preprocessor definitions
			var strDefines = GetPlatformDefine( config );
			strDefines += "_CONSOLE;wxUSE_GUI=0;STRICT;__WXMSW__;__WX__;_CRT_SECURE_NO_DEPRECATE;";
			
			if ( isDebug )
			{
				strDefines += "_DEBUG;__WXDEBUG__;";
			}
			else
			{
				strDefines += "NDEBUG;";
			}
			
			if ( useDLL )
			{
				strDefines += "WXUSINGDLL;";
			}
			CLTool.PreprocessorDefinitions = strDefines;
	
			// Linker settings
			var LinkTool = config.Tools('VCLinkerTool');
			LinkTool.SubSystem = subSystemConsole;
			LinkTool.TargetMachine = machineX86;
			
			// Additional libraries
			var additionalDepends = "comctl32.lib rpcrt4.lib winmm.lib wsock32.lib ";
			
			/*
			if(wizard.FindSymbol('WX_USE_VERSION_RC'))
			{
				additionalDepends += "version.lib "
			}
			*/
			
			if ( isDebug )
			{
				if ( wizard.FindSymbol('WX_USE_MONOLITHIC_DLL') )
				{
				    if ( wizard.FindSymbol( 'WX_USE_UNICODE' ) )
				    {
						additionalDepends += "wxmsw28ud.lib";
					}
					else
					{
					    additionalDepends += "wxmsw28d.lib";
					}
				}
				LinkTool.LinkIncremental = linkIncrementalYes;
				LinkTool.GenerateDebugInformation = true;
			}
			else
			{
				if ( wizard.FindSymbol('WX_USE_MONOLITHIC_DLL') )
				{
					if ( wizard.FindSymbol( 'WX_USE_UNICODE' ) )
				    {
						additionalDepends += "wxmsw28u.lib";
					}
					else
					{
					    additionalDepends += "wxmsw28.lib";
					}
				}
				LinkTool.LinkIncremental = linkIncrementalNo;
			}			
			LinkTool.AdditionalDependencies = additionalDepends;
			
			// Additional library directories
			if ( useDLL )
			{
				LinkTool.AdditionalLibraryDirectories = "$(WXWIN)/lib/vc_dll;$(WXADDITIONS)/lib/vc_dll";
			}
			else
			{
				LinkTool.AdditionalLibraryDirectories = "$(WXWIN)/lib/vc_lib;$(WXADDITIONS)/lib/vc_lib";
			}
			
			// As of VC8, manifests are used with executables to inform the operating system of its DLL dependencies
			// This covers ATL, MFC, Standard C++, and CRT libraries, see the MSDN topic "Visual C++ Libraries as Shared Side-by-Side Assemblies" for details
			// But, this manifest is unnecessary for statically linked programs
			if( !useDLL )
			{
				LinkTool.GenerateManifest = false;
				
				var ManifestTool = config.Tools('VCManifestTool');
				ManifestTool.EmbedManifest = false;			
			}
			
			// Resource settings
			/*
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
			*/
		}
	}
	catch(e)
	{
		throw e;
	}
}

function PchSettings(proj)
{
	// TODO: specify pch settings
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
		// The only file is main.cpp, and the name is fine
		return strName; 
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
		var projItems = proj.ProjectItems

		var strTemplatePath = wizard.FindSymbol('TEMPLATES_PATH');

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
				if(strExt==".bmp" || strExt==".ico" || strExt==".gif" || strExt==".rtf" || strExt==".css")
					bCopyOnly = true;
				wizard.RenderTemplate(strTemplate, strFile, bCopyOnly);
				proj.Object.AddFile(strFile);
			}
		}
		strTextStream.Close();
	}
	catch(e)
	{
		throw e;
	}
}
