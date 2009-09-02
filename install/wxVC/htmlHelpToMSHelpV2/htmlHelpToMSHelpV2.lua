-- **********************************************************
-- *
-- * Author:		RJP Computing <rjpcomputing@gmail.com>
-- * Date:			03/20/2007
-- * Version:		2.00
-- * File:			htmlHelpToMSHelpV2.lua
-- * 
-- * Description:	This is a script that takes an old MS HTML 1.x
-- *				indexfile (.hhk) and converts it to a new
-- *				MS Help 2.x (.HxK).
-- * 
-- * Notes:			Uses Lua 5.1.1
-- *				* Removed the DTD declaration in the xml
-- *				  that is generated.
-- * 
-- **********************************************************

AppName = "htmlHelpToMSHelpV2"
AppVersion = "2.01"
DEBUG = false

function PrintUsage( errorMessage )
	if ( errorMessage ) then
		print( "ERROR: " .. errorMessage )
		print( "" )
	end
	
	print( AppName .. " v" .. AppVersion )
	print( "Usage: lua.exe ".. arg[0] .. " <filetoconvert.hhk> [filterdocsetname]" )
	print( "" )
	print( "This will create a new HxK file with the same name as the input file to convert." )
	
	os.exit( 1 )
end

function StripExtention( fileWithExtention )
	local extentionStart = fileWithExtention:find( "%.%a+" )
	return fileWithExtention:sub( 0, ( extentionStart - 1 ) )
end

function CreateHxa( filePath, docSet )
	local contents =
		"<?xml version=\"1.0\"?>\n" ..
		"<HelpAttributes DTDVersion=\"1.0\">\n\n" ..
		"<AttName Id=\"1\" Name=\"DevLang\" Display=\"Yes\" UIString=\"DevLang\" AttType=\"Enum\">\n" ..
				"\t<AttVal Id=\"1_1\" Name=\"C++\" Display=\"Yes\" UIString=\"C++\" />\n" ..
		"</AttName>\n" ..
		"<AttName Id=\"2\" Name=\"Locale\" Display=\"No\" UIString=\"Locale\" AttType=\"Enum\">\n" ..
			"\t<AttVal Id=\"2_1\" Name=\"kbEnglish\" Display=\"No\" UIString=\"English\" />\n" ..
		"</AttName>\n" ..
		"<AttName Id=\"3\" Name=\"TargetOS\" Display=\"No\" UIString=\"TargetOS\" AttType=\"Enum\">\n" ..
			"\t<AttVal Id=\"3_1\" Name=\"Windows\" Display=\"No\" UIString=\"Windows\" />\n" ..
		"</AttName>\n" ..
		"<AttName Id=\"4\" Name=\"TopicType\" Display=\"No\" UIString=\"TopicType\" AttType=\"Enum\">\n" ..
			"\t<AttVal Id=\"4_1\" Name=\"kbArticle\" Display=\"No\" UIString=\"Article\" />\n" ..
			"\t<AttVal Id=\"4_2\" Name=\"kbHowTo\" Display=\"No\" UIString=\"How To\" />\n" ..
			"\t<AttVal Id=\"4_3\" Name=\"kbSyntax\" Display=\"No\" UIString=\"Syntax\" />\n" ..
		"</AttName>\n" ..
		"<AttName Id=\"5\" Name=\"LinkGroup\" Display=\"No\" UIString=\"LinkGroup\" AttType=\"Enum\">\n" ..
			"\t<AttVal Id=\"5_1\" Name=\""..docSet.."Group\" Display=\"No\" UIString=\""..docSet.."\" />\n" ..
		"</AttName>\n" ..
		"<AttName Id=\"6\" Name=\"DocSet\" Display=\"Yes\" UIString=\"DocSet\" AttType=\"Enum\">\n" ..
				"\t<AttVal Id=\"6_1\" Name=\""..docSet.."\" Display=\"Yes\" UIString=\""..docSet.." Library\" />\n" ..
		"</AttName>\n\n" ..
		"</HelpAttributes>\n"
	
	local f = io.open( filePath, "w+" )
	f:write( contents )
	f:close()
end

function CreateHxv( filePath )
	local preamble =
		"<?xml version=\"1.0\"?>\n" ..
		"<VTopicSet DTDVersion=\"1.0\">\n"
	local f = io.open( filePath, "w+" )
	f:write( preamble )
	return f
end

function WriteVirtualTopic( filePointer, term, url, docSet )
	local topic =
		"\t<VTopic Url=\""..url.."\" RLTitle=\""..term.."\" Title=\""..term.."\">\n" ..
			"\t\t<Attr Name=\"LinkGroup\" Value=\""..docSet.."Group\"/>\n" ..
			"\t\t<Attr Name=\"DocSet\" Value=\""..docSet.."\"/>\n" ..
			"\t\t<Attr Name=\"Package\" Value=\""..docSet.."\"/>\n" ..
			"\t\t<Attr Name=\"HelpPriority\" Value=\"1\"/>\n" ..
			"\t\t<Attr Name=\"TopicType\" Value=\"kbSyntax\"/>\n" ..
			"\t\t<Attr Name=\"TopicType\" Value=\"kbRef\"/>\n" ..
			"\t\t<Attr Name=\"DevLang\" Value=\"C++\"/>\n" ..
			"\t\t<Attr Name=\"DevLangVers\" Value=\"kbLangCPP\"/>\n" ..
			"\t\t<Attr Name=\"Locale\" Value=\"kbEnglish\"/>\n" ..
			"\t\t<Attr Name=\"TargetOS\" Value=\"Windows\"/>\n" ..
			"\t\t<Attr Name=\"TargetOSVers\" Value=\"kbWinOS\"/>\n" ..
			"\t\t<Keyword Index=\"F\" Term=\""..term.."\"/>\n" ..
			"\t\t<Keyword Index=\"K\" Term=\""..term.."\"/>\n" ..
			"\t\t<FTSText>"..term.."</FTSText>\n" ..
		"\t</VTopic>\n"
	
	filePointer:write( topic )
end

function FinalizeHxv( filePointer, keywords, docSet )
	for term, url in pairs( keywords )
	do 
		WriteVirtualTopic( filePointer, term, url, docSet )
	end
	
	-- Close the main xml node.
	filePointer:write( "</VTopicSet>" )
	
	-- Close the file because we are done with it.
	filePointer:close()
end

function CreateHxk( filePath )
	local preamble =
		"<?xml version=\"1.0\" encoding=\"Windows-1252\"?>\n" ..
		"<HelpIndex Name = \"K\"\n" ..
			"\t\tDTDVersion = \"1.0\"\n" ..
			"\t\tVisible = \"Yes\"\n" ..
			"\t\tLangId = \"1033\">\n"
	local f = io.open( filePath, "w+" )
	f:write( preamble )
	return f
end

function WriteKeyword( filePointer, term, url )
	WriteTerm( filePointer, term )
	WriteURL( filePointer, url )
	filePointer:write( "\t</Keyword>\n" )
end

function WriteTerm( filePointer, term )
	filePointer:write( string.format( "\t<Keyword Term = \"%s\">\n", term ) )
end

function WriteURL( filePointer, url )
	filePointer:write( string.format( "\t\t<Jump Url = \"%s\"/>\n", url ) )
end

function FinalizeHxk( filePointer, keywords )
	for term, url in pairs( keywords )
	do 
		WriteKeyword( filePointer, term, url )
	end
	
	-- Close the main xml node.
	filePointer:write( "</HelpIndex>" )
	
	-- Close the file because we are done with it.
	filePointer:close()
end

function IsTerm( s )
	local lowerS = s:lower()
	-- Just check is the line starts with...
	if ( lowerS:find( "<param name=\"name\" value=\"" ) ) then
		return true
	else
		return false
	end
end

function IsURL( s )
	local lowerS = s:lower()
	-- Just check is the line starts with...
	if ( lowerS:find( "<param name=\"local\" value=\"" ) ) then
		return true
	else
		return false
	end
end

function FindTerm( s )
	local lowerS = s:lower()
	local subStart = lowerS:find( "ue=\"", -lowerS:len() ) + 4
	local subEnd = lowerS:find( "\"", subStart )
	
	return s:sub( subStart, subEnd - 1 )
end

function FindURL( s )
	local lowerS = s:lower()
	local subStart = lowerS:find( "ue=\"", -lowerS:len() ) + 4
	local subEnd = lowerS:find( "\"", subStart )
	
	return s:sub( subStart, subEnd - 1 )
end

function ParseFile( fileName )
	local keywords = {}
	local term
	local url
	
	for line in io.lines( fileName )
	do
		-- Check if the line is a "term" line.
		if ( IsTerm( line ) ) then
			term = FindTerm( line )
		end
		
		-- Check if the line is a "url" line.
		if ( IsURL( line ) ) then
			url = FindURL( line )
		end
		
		-- Check to see if there are both values to save into the table.
		if ( term and url ) then
			keywords[term] = url
			-- Reset the variables so we can do the check later.
			term = nil
			url = nil
		end
	end
	
	--for k,v in pairs(keywords) do print("Keywords key: "..k, "val: "..v) end
	-- Return the key/value table of keyword terms/urls.
	return keywords
end

-- Debug helper functions
function LogMsg( message )
	if ( DEBUG == true ) then
		print( os.date() .. ": " .. message )
	end
end

-- Main entry point
function main( fileToConvert, docSet )
	local hxkFileName
	local hxvFileName
	local hxaFileName
	local filterDocSetName
	
	if ( docSet ) then
		filterDocSetName = docSet
	end
	
	-- check for correct number of parameters.
	if ( fileToConvert ) then
		print( "File to convert: " .. fileToConvert )
		
		-- Check for input file to have a .hhk extention.
		if ( not fileToConvert:find( ".hhk" ) ) then
			PrintUsage( "The input file '" .. fileToConvert .. "' must have an extention of .hhk." )
		end
		
		-- Creating the needed file names.
		local tempFileName = StripExtention( fileToConvert )
		LogMsg( "fileToConvert '" .. fileToConvert .. "' with the extention removed:  " .. tempFileName )
		hxkFileName = tempFileName .. ".HxK"
		hxvFileName = tempFileName .. ".HxV"
		hxaFileName = tempFileName .. ".HxA"
		
		-- Create the needed filter DocSet name.
		if ( not filterDocSetName ) then
			filterDocSetName = tempFileName
			LogMsg( "filterDocSetName created from the fileToConvert file name." )
		end
		print( "Filter DocSet value: " .. filterDocSetName )
		
		LogMsg( "Starting the parse process" )
		local keywrds = ParseFile( fileToConvert )
		
		LogMsg( "Creating HxK file: " .. hxkFileName )
		local hxkFP = CreateHxk( hxkFileName )
		
		LogMsg( "Writing out HxK file" )
		FinalizeHxk( hxkFP, keywrds )
		
		LogMsg( "Creating HxV file: " .. hxvFileName )
		local hxvFP = CreateHxv( hxvFileName )
		
		LogMsg( "Writing out HxV file" )
		FinalizeHxv( hxvFP, keywrds, filterDocSetName )
		
		LogMsg( "Creating HxA file: " .. hxaFileName )
		CreateHxa( hxaFileName, filterDocSetName )
		
		--LogMsg( "Writing out HxA file" )
		--FinalizeHxa( hxaFP, filterDocSetName )
	else
		PrintUsage( "Not enough parameters." )
	end
	
	print( "Time of execution: " .. os.clock () .. " seconds" )
	os.exit( 0 )
end

main( arg[1], arg[2] )

