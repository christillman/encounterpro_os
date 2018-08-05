$PBExportHeader$u_component_observation_com_document.sru
forward
global type u_component_observation_com_document from u_component_observation
end type
end forward

global type u_component_observation_com_document from u_component_observation
end type
global u_component_observation_com_document u_component_observation_com_document

type variables

end variables

forward prototypes
protected function integer xx_do_source ()
end prototypes

protected function integer xx_do_source ();string ls_results_xml
string ls_new_xml
integer li_sts
str_attributes lstr_attributes
string ls_xml
str_patient_material lstr_material
long ll_material_id
string ls_com_id
string ls_temp
blob lbl_temp
boolean lb_connected
string ls_xslt
oleobject lo_com_document
boolean lb_debug_mode
string ls_access_level

setnull(ls_xslt)

get_attribute("lb_debug_mode", lb_debug_mode)

if lb_debug_mode then
	log.log(this, "u_component_observation_com_document.xx_do_source:0022", "Debug Mode", 2)
end if

get_attribute("ls_xslt_material_id", ll_material_id)
lstr_material = f_get_patient_material(ll_material_id, true)
if isnull(lstr_material.material_id) then
	ls_xslt = string(lstr_material.material_object)
end if

ls_access_level = get_attribute("access_level")
if isnull(ls_access_level) then
	ls_access_level = "Report"
end if

ls_com_id = get_attribute("com_id")
if isnull(ls_com_id) then
	log.log(this, "u_component_observation_com_document.xx_do_source:0038", "com_id not defined", 4)
	return -1
end if

lo_com_document = CREATE oleobject
if lb_debug_mode then
	log.log(this, "u_component_observation_com_document.xx_do_source:0044", "Attempting to instantiate com object (" + ls_com_id + ")", 2)
end if
li_sts = lo_com_document.connecttonewobject(ls_com_id)
if li_sts = 0 then
	if lb_debug_mode then
		log.log(this, "u_component_observation_com_document.xx_do_source:0049", "instantiation successful (" + ls_com_id + ")", 2)
	end if
else
	log.log(this, "u_component_observation_com_document.xx_do_source:0052", "Error connecting to com source (" + ls_com_id + ", " + string(li_sts) + ")", 4)
	return -1
end if


// We've created the com object, so now get the attributes ready
lstr_attributes = get_attributes()

// Add the current patient context
f_attribute_add_attributes(lstr_attributes, f_get_context_attributes())

// Add the credentials the com object might need to access the database
sqlca.add_credentials(ls_access_level, lstr_attributes)

// Convert the attributes to an XML string
ls_xml = f_attributes_to_xml_string("Context", lstr_attributes)
if isnull(ls_xml) then
	log.log(this, "u_component_observation_com_document.xx_do_source:0069", "Error getting context attributes", 4)
	return -1
end if

TRY
	ls_results_xml = lo_com_document.CreateDocument(ls_xml)
CATCH (throwable lt_error)
	log.log(this, "u_component_observation_com_document.xx_do_source:0076", "Error calling com source (" + lt_error.text + ")", 4)
	return -1
END TRY

if isnull(ls_results_xml) or ls_results_xml = "" then return 0

// If we need to transform the xml, do it here
if len(ls_xslt) > 0 then
	TRY
		ls_new_xml = common_thread.eprolibnet4.TransformXML(ls_results_xml, ls_xslt)
	CATCH (throwable lt_error2)
		log.log(this, "u_component_observation_com_document.xx_do_source:0087", "Error calling com source (" + lt_error2.text + ")", 4)
		return -1
	END TRY
	if len(ls_new_xml) > 0 then
		ls_results_xml = ls_new_xml
	else
		log.log(this, "u_component_observation_com_document.xx_do_source:0093", "Error transforming xml", 3)
	end if
end if

lo_com_document.disconnectobject( )
DESTROY lo_com_document

li_sts = read_data(ls_results_xml, "")
if li_sts < 0 then
	log.log(this, "u_component_observation_com_document.xx_do_source:0102", "Error reading xml documents", 4)
	return -1
end if

return 1


end function

on u_component_observation_com_document.create
call super::create
end on

on u_component_observation_com_document.destroy
call super::destroy
end on

