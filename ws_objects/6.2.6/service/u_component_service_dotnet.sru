HA$PBExportHeader$u_component_service_dotnet.sru
forward
global type u_component_service_dotnet from u_component_service
end type
end forward

global type u_component_service_dotnet from u_component_service
end type
global u_component_service_dotnet u_component_service_dotnet

type variables
oleobject com_wrapper

end variables

forward prototypes
protected function integer xx_initialize ()
protected function integer xx_shutdown ()
public function integer xx_do_service ()
end prototypes

protected function integer xx_initialize ();integer li_sts
str_attributes lstr_attributes


if debug_mode then
	log.log(this, "xx_do_source()", "Debug Mode", 2)
end if

// Get the XML document for the component attributes
lstr_attributes = get_attributes()
f_attribute_add_attribute(lstr_attributes, "patient_workplan_item_id", string(patient_workplan_item_id))

li_sts = initialize_dotnet_wrapper(lstr_attributes)

return li_sts



end function

protected function integer xx_shutdown ();
TRY
	com_wrapper.disconnectobject( )
CATCH (throwable lt_error)
	log.log(this, "xx_do_source()", "Error disconnecting ConnectClass (" + lt_error.text + ")", 4)
	return -1
END TRY


DESTROY com_wrapper


return 1


end function

public function integer xx_do_service ();string ls_results_xml
string ls_new_xml
integer li_sts
str_patient_material lstr_material
long ll_material_id
blob lbl_temp
string ls_xslt
string ls_xml_data
u_xml_script lo_xml
str_attributes lstr_attributes
str_context lstr_context
u_xml_document lo_document
long ll_xml_script_id
str_patient_materials lstr_patient_materials

lstr_context = f_current_context()

setnull(ls_xslt)

get_attribute("ls_xslt_material_id", ll_material_id)
lstr_material = f_get_patient_material(ll_material_id, true)
if isnull(lstr_material.material_id) then
	ls_xslt = string(lstr_material.material_object)
end if

lstr_attributes = get_attributes()

li_sts = f_attribute_get_materials(lstr_attributes, true, lstr_patient_materials)

get_attribute("xml_script_id", ll_xml_script_id)
lo_xml = CREATE u_xml_script
li_sts = lo_xml.create_xml(patient_workplan_item_id, &
									ll_xml_script_id, &
									"JMJComponentData", &
									lstr_context, &
									lstr_attributes,&
									lstr_patient_materials, &
									lo_document)
ls_xml_data = lo_document.xml_string
if isnull(ls_xml_data) then
	log.log(this, "xx_do_source()", "Error getting xml data", 4)
	return -1
end if


TRY
	ls_results_xml = com_wrapper.DoService(ls_xml_data)
CATCH (throwable lt_error)
	log.log(this, "xx_do_source()", "Error calling com source (" + lt_error.text + ")", 4)
	dotnet_create_test_case()
	return -1
END TRY
if debug_mode then
	dotnet_create_test_case()
end if

if isnull(ls_results_xml) or ls_results_xml = "" then return 0

if isnumber(ls_results_xml) then
	li_sts = integer(ls_results_xml)
	return li_sts
end if

// If we need to transform the xml, do it here
if len(ls_xslt) > 0 then
	TRY
		ls_new_xml = common_thread.eprolibnet4.TransformXML(ls_results_xml, ls_xslt)
	CATCH (throwable lt_error2)
		log.log(this, "xx_do_source()", "Error calling com source (" + lt_error2.text + ")", 4)
		return -1
	END TRY
	if len(ls_new_xml) > 0 then
		ls_results_xml = ls_new_xml
	else
		log.log(this, "get_results()", "Error transforming xml", 3)
	end if
end if

// We have XML returned
//li_sts = read_data(ls_results_xml, "")
//if li_sts < 0 then
//	log.log(this, "get_results()", "Error reading xml documents", 4)
//	return -1
//end if

return 1


end function

on u_component_service_dotnet.create
call super::create
end on

on u_component_service_dotnet.destroy
call super::destroy
end on

