#INCLUDE "PROTHEUS.CH"
User Function TSTTFINI()

	Local oTFINI	:= TFINI():New( "D:\TFINI\TINIGetPValue.INI" )

	ConOut( oTFINI:ClassName() )

	VarInfo( "oTFINI" , oTFINI )	//Saida no Console
	
	ConOut( "" , "" )

 	cPVS1 := oTFINI:GetPropertyValue( "session1" , "PropertyName1" , "NO_FOUND" )
 	ConOut( "cPVS1" , cPVS1 )
 	ConOut( "" , "" )
 	cPVS2 := oTFINI:GetPropertyValue( "session2" , "PropertyName2" , "NO_FOUND" )
 	ConOut( "cPVS2" , cPVS2 )
 	ConOut( "" , "" )
 	cPVS3 := oTFINI:GetPropertyValue( "session3" , "PropertyName3" , "NO_FOUND" )
 	ConOut( "cPVS3" , cPVS3 )
 	ConOut( "" , "" )
 	cPVS4 := oTFINI:GetPropertyValue( "session4" , "PropertyName3" , "NO_FOUND" )
 	ConOut( "cPVS4" , cPVS4 )
 	ConOut( "" , "" )

	cPVS2 := oTFINI:SetPropertyValue( "session2" , "PropertyName2" , "NewValuePropertyValue2" )
	ConOut( "cPVS2" , cPVS2 )
	ConOut( "" , "" )

	cPVS2 := oTFINI:GetPropertyValue( "session2" , "PropertyName2" , "NO_FOUND" )
	ConOut( "cPVS2" , cPVS2 )
	ConOut( "" , "" )

	oTFINI:AddNewSession( "session5" )
	oTFINI:AddNewProperty( "session5" , "PropertyName1" , "PropertyValue1" )
	oTFINI:AddNewProperty( "session5" , "PropertyName2" , "PropertyValue2" )
	oTFINI:AddNewProperty( "session5" , "PropertyName3" , "PropertyValue3" )
	oTFINI:AddNewProperty( "session5" , "PropertyName4" , "PropertyValue4" )
	oTFINI:AddNewProperty( "session5" , "PropertyName5" , "PropertyValue5" )

	cPVS5 := oTFINI:SetPropertyValue( "session5" , "PropertyName4" , "NewValuePropertyValue4" )
	ConOut( "cPVS5" , cPVS5 )
	ConOut( "" , "" )
	
	oTFINI:AddNewSession( "session6" )
	oTFINI:AddNewProperty( "session6" , "PropertyName1" , "PropertyValue1" )
	oTFINI:AddNewProperty( "session6" , "PropertyName2" , "PropertyValue2" )
	oTFINI:AddNewProperty( "session6" , "PropertyName3" , "PropertyValue3" )
	oTFINI:AddNewProperty( "session6" , "PropertyName4" , "PropertyValue4" )
	oTFINI:AddNewProperty( "session6" , "PropertyName5" , "PropertyValue5" )
	oTFINI:AddNewProperty( "session6" , "PropertyName6" , "PropertyValue6" )

	cPVS6 := oTFINI:GetPropertyValue( "session6" , "PropertyName2" , "NO_FOUND" )
	ConOut( "cPVS6" , cPVS6 )
	ConOut( "" , "" )

	oTFINI:AddNewSession( "session7" )
	oTFINI:AddNewProperty( "session7" , "PropertyName1" , "PropertyValue1" )
	oTFINI:AddNewProperty( "session7" , "PropertyName2" , "PropertyValue2" )
	oTFINI:AddNewProperty( "session7" , "PropertyName3" , "PropertyValue3" )
	oTFINI:AddNewProperty( "session7" , "PropertyName4" , "PropertyValue4" )
	oTFINI:AddNewProperty( "session7" , "PropertyName5" , "PropertyValue5" )
	oTFINI:AddNewProperty( "session7" , "PropertyName6" , "PropertyValue6" )
	oTFINI:AddNewProperty( "session7" , "PropertyName7" , "PropertyValue7" )

	VarInfo( "oTFINI" , oTFINI )	//Saida no Console
	ConOut( "" , "" )

	oTFINI:CopySession( "session7" , "session8"  )
	VarInfo( "oTFINI" , oTFINI )	//Saida no Console
	ConOut( "" , "" )


	oTFINI:RemoveSession( "session6" )
	oTFINI:RemoveProperty( "session7", "PropertyName7" )
	
	VarInfo( "AllProperties_Session7" , oTFINI:GetAllProperties( "session7" ) )
	ConOut( "" , "" )

	VarInfo( "AllSessions" , oTFINI:GetAllSessions() )
	ConOut( "" , "" )
	
	ConOut( "SaveAs " , oTFINI:SaveAs( "D:\TFINI\__TINIGetPValue.INI" ) )
	ConOut( "" , "" )

	ConOut( "SaveAsXML " , oTFINI:SaveAsXML() )
	ConOut( "" , "" )
	
Return( NIL )