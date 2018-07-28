$PBExportHeader$u_component_property_script.sru
forward
global type u_component_property_script from u_component_property
end type
end forward

global type u_component_property_script from u_component_property
end type
global u_component_property_script u_component_property_script

type variables
oleobject scriptobject


end variables

forward prototypes
public function string xx_get_property ()
end prototypes

public function string xx_get_property ();string ls_property
string lsa_attributes[]
string lsa_values[]
integer li_count
integer li_sts
long ll_property
decimal ldc_property
integer i
any laa_attributes[]
any laa_values[]
any la_property

li_count = get_attributes(lsa_attributes, lsa_values)

laa_attributes = lsa_attributes
laa_values = lsa_values

// Set the property_id so script errors will report it
msscript.property_id = property.property_id

msscript.object.AllowUI = false
if isnull(property.script_language) or trim(property.script_language) = "" then
	msscript.object.Language = "VBScript"
else
	msscript.object.Language = property.script_language
end if
//msscript.object.addobject("ADODB_Connection", adodb)
msscript.object.AddCode(property.script)

scriptobject = msscript.object.codeobject


la_property = msscript.object.run(property.function_name, li_count, laa_attributes, laa_values)
CHOOSE CASE lower(classname(la_property))
	CASE "integer"
		ls_property = string(integer(la_property))
	CASE "string"
		ls_property = string(la_property)
	CASE ELSE
		ls_property = ""
END CHOOSE

// Reset property_id
msscript.property_id = 0

//CHOOSE CASE left(upper(property.return_data_type), 3)
//	CASE "STR"
//		la_property = msscript.object.run(property.function_name, li_count, laa_attributes, laa_values)
//		ls_property = string(la_property)
//	CASE "RTF"
//		la_property = msscript.object.run(property.function_name, li_count, laa_attributes, laa_values)
//		ls_property = string(la_property)
//	CASE "HTM"
//		la_property = msscript.object.run(property.function_name, li_count, laa_attributes, laa_values)
//		ls_property = string(la_property)
//	CASE "INT"
//		la_property = msscript.object.run(property.function_name, li_count, laa_attributes, laa_values)
//		ll_property = long(la_property)
//		ls_property = string(ll_property)
//	CASE "DEC"
//		la_property = msscript.object.run(property.function_name, li_count, laa_attributes, laa_values)
//		ldc_property = float(la_property)
//		ls_property = string(ldc_property)
//	CASE ELSE
//		msscript.object.run(property.function_name, li_count, laa_attributes, laa_values)
//		ls_property = "1"
//END CHOOSE


return ls_property

end function

on u_component_property_script.create
call super::create
end on

on u_component_property_script.destroy
call super::destroy
end on

