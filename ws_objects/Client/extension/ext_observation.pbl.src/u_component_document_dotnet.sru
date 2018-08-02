$PBExportHeader$u_component_document_dotnet.sru
forward
global type u_component_document_dotnet from u_component_document
end type
end forward

global type u_component_document_dotnet from u_component_document
end type
global u_component_document_dotnet u_component_document_dotnet

type variables

end variables

forward prototypes
protected function integer xx_do_source ()
protected function integer xx_initialize ()
protected function integer xx_shutdown ()
public function integer xx_configure_document ()
protected function string xx_get_test_case ()
public function string xx_get_document_elements ()
end prototypes

protected function integer xx_do_source ();string ls_results_xml
string ls_new_xml
integer li_sts
str_patient_material lstr_material
long ll_material_id
blob lbl_temp
string ls_xslt
u_xml_script lo_xml
str_attributes lstr_attributes
str_context lstr_context
u_xml_document lo_document
long ll_xml_script_id
long ll_patient_workplan_item_id
str_patient_materials lstr_patient_materials
string ls_message

lstr_attributes = get_attributes()

lstr_context = f_attributes_to_context(lstr_attributes)
if isnull(lstr_context.cpr_id) or lower(lstr_context.context_object) = "general" then
	lstr_context = f_current_context()
end if


setnull(ls_xslt)

get_attribute("ls_xslt_material_id", ll_material_id)
lstr_material = f_get_patient_material(ll_material_id, true)
if isnull(lstr_material.material_id) then
	ls_xslt = string(lstr_material.material_object)
end if


li_sts = f_attribute_get_materials(lstr_attributes, true, lstr_patient_materials)

get_attribute("document_patient_workplan_item_id", ll_patient_workplan_item_id)

get_attribute("xml_script_id", ll_xml_script_id)
lo_xml = CREATE u_xml_script
li_sts = lo_xml.create_xml(ll_patient_workplan_item_id, &
									ll_xml_script_id, &
									"JMJComponentData", &
									lstr_context, &
									lstr_attributes,&
									lstr_patient_materials, &
									lo_document)
dotnet_xml_data = lo_document.xml_string
if isnull(dotnet_xml_data) then
	log.log(this, "u_component_document_dotnet.xx_do_source.0049", "Error getting xml data", 4)
	return -1
end if

TRY
	ls_results_xml = com_wrapper.CreateDocument2(dotnet_xml_data)
CATCH (oleruntimeerror lt_error)
	ls_message += lt_error.text + "~r~n" + lt_error.description
	log.log(this, "u_component_document_dotnet.xx_do_source.0049", "Error calling com source:~r~n" + ls_message, 4)
	dotnet_create_test_case()
	return -1
END TRY
if debug_mode then
	dotnet_create_test_case()
end if

if isnull(ls_results_xml) or ls_results_xml = "" then return 0

if isnumber(ls_results_xml) then
	// If the result is really a number then return the number
	li_sts = integer(ls_results_xml)
	return li_sts
end if

// If we need to transform the xml, do it here
if len(ls_xslt) > 0 then
	TRY
		ls_new_xml = common_thread.eprolibnet4.TransformXML(ls_results_xml, ls_xslt)
	CATCH (oleruntimeerror lt_error2)
		ls_message += lt_error2.text + "~r~n" + lt_error2.description
		log.log(this, "u_component_document_dotnet.xx_do_source.0049", "Error calling TransformXML:~r~n" + ls_message, 4)
		return -1
	END TRY
	if len(ls_new_xml) > 0 then
		ls_results_xml = ls_new_xml
	else
		log.log(this, "u_component_document_dotnet.xx_do_source.0085", "Error transforming xml", 3)
	end if
end if

li_sts = read_data(ls_results_xml, "")
if li_sts < 0 then
	log.log(this, "u_component_document_dotnet.xx_do_source.0085", "Error reading xml documents", 4)
	return -1
end if

return 1


end function

protected function integer xx_initialize ();integer li_sts
str_attributes lstr_attributes


if debug_mode then
	log.log(this, "u_component_document_dotnet.xx_do_source.0049", "Debug Mode", 2)
end if

// Get the XML document for the component attributes
lstr_attributes = get_attributes()
//f_attribute_add_attribute(lstr_attributes, "patient_workplan_item_id", string(patient_workplan_item_id))

li_sts = initialize_dotnet_wrapper(lstr_attributes)

return li_sts



end function

protected function integer xx_shutdown ();
TRY
	com_wrapper.disconnectobject( )
CATCH (throwable lt_error)
	log.log(this, "u_component_document_dotnet.xx_do_source.0049", "Error disconnecting ConnectClass (" + lt_error.text + ")", 4)
	return -1
END TRY


DESTROY com_wrapper


return 1


end function

public function integer xx_configure_document ();string ls_updated_config_xml
string ls_new_xml
integer li_sts
str_patient_material lstr_material
long ll_material_id
blob lbl_temp
u_xml_script lo_xml
str_attributes lstr_attributes
str_context lstr_context
u_xml_document lo_document
long ll_xml_script_id
long ll_patient_workplan_item_id
str_patient_materials lstr_patient_materials
u_xml_document lxml_return_document
string ls_report_id

lstr_context = f_current_context()

lstr_attributes = get_attributes()

get_attribute("document_patient_workplan_item_id", ll_patient_workplan_item_id)
get_attribute("report_id", ls_report_id)

li_sts = f_attribute_get_materials(lstr_attributes, true, lstr_patient_materials)

get_attribute("xml_script_id", ll_xml_script_id)
lo_xml = CREATE u_xml_script
li_sts = lo_xml.create_xml(ll_patient_workplan_item_id, &
									ll_xml_script_id, &
									"JMJComponentData", &
									lstr_context, &
									lstr_attributes,&
									lstr_patient_materials, &
									lo_document)
dotnet_xml_data = lo_document.xml_string
if isnull(dotnet_xml_data) then
	log.log(this, "u_component_document_dotnet.xx_configure_document.0037", "Error getting xml data", 4)
	return -1
end if

TRY
	ls_updated_config_xml = com_wrapper.ConfigureDocument(dotnet_xml_data)
CATCH (throwable lt_error)
	log.log(this, "u_component_document_dotnet.xx_configure_document.0037", "Error calling com source (" + lt_error.text + ")", 4)
	dotnet_create_test_case()
	return -1
END TRY
if debug_mode then
	dotnet_create_test_case()
end if

if isnull(ls_updated_config_xml) or ls_updated_config_xml = "" then return 0

li_sts = f_get_xml_document(ls_updated_config_xml, lxml_return_document)
if li_sts <= 0 then return -1

li_sts = f_update_component_datafiles(lxml_return_document, lstr_patient_materials, ls_report_id, id)
if li_sts <= 0 then return -1


DESTROY lxml_return_document

return 1


end function

protected function string xx_get_test_case ();string ls_results_xml
string ls_new_xml
integer li_sts
str_patient_material lstr_material
long ll_material_id
blob lbl_temp
string ls_xslt
u_xml_script lo_xml
str_attributes lstr_attributes
str_context lstr_context
u_xml_document lo_document
long ll_xml_script_id
long ll_patient_workplan_item_id
str_patient_materials lstr_patient_materials
string ls_null

setnull(ls_null)

lstr_context = f_current_context()

setnull(ls_xslt)

get_attribute("ls_xslt_material_id", ll_material_id)
lstr_material = f_get_patient_material(ll_material_id, true)
if isnull(lstr_material.material_id) then
	ls_xslt = string(lstr_material.material_object)
end if

lstr_attributes = get_attributes()

li_sts = f_attribute_get_materials(lstr_attributes, true, lstr_patient_materials)

get_attribute("document_patient_workplan_item_id", ll_patient_workplan_item_id)

get_attribute("xml_script_id", ll_xml_script_id)
lo_xml = CREATE u_xml_script
li_sts = lo_xml.create_xml(ll_patient_workplan_item_id, &
									ll_xml_script_id, &
									"JMJComponentData", &
									lstr_context, &
									lstr_attributes,&
									lstr_patient_materials, &
									lo_document)
dotnet_xml_data = lo_document.xml_string
if isnull(dotnet_xml_data) then
	log.log(this, "u_component_document_dotnet.xx_get_test_case.0046", "Error getting xml data", 4)
	return ls_null
end if

return dotnet_create_test_case()


end function

public function string xx_get_document_elements ();string ls_document_element_xml
string ls_new_xml
integer li_sts
str_patient_material lstr_material
long ll_material_id
blob lbl_temp
u_xml_script lo_xml
str_attributes lstr_attributes
str_context lstr_context
u_xml_document lo_document
long ll_xml_script_id
long ll_patient_workplan_item_id
str_patient_materials lstr_patient_materials
u_xml_document lxml_return_document
string ls_report_id

lstr_context = f_current_context()

lstr_attributes = get_attributes()

get_attribute("document_patient_workplan_item_id", ll_patient_workplan_item_id)
get_attribute("report_id", ls_report_id)

li_sts = f_attribute_get_materials(lstr_attributes, true, lstr_patient_materials)

get_attribute("xml_script_id", ll_xml_script_id)
lo_xml = CREATE u_xml_script
li_sts = lo_xml.create_xml(ll_patient_workplan_item_id, &
									ll_xml_script_id, &
									"JMJComponentData", &
									lstr_context, &
									lstr_attributes,&
									lstr_patient_materials, &
									lo_document)
dotnet_xml_data = lo_document.xml_string
if isnull(dotnet_xml_data) then
	log.log(this, "u_component_document_dotnet.xx_configure_document.0037", "Error getting xml data", 4)
	return ""
end if

TRY
	ls_document_element_xml = com_wrapper.GetDocumentElements(dotnet_xml_data)
CATCH (throwable lt_error)
	log.log(this, "u_component_document_dotnet.xx_configure_document.0037", "Error calling com source (" + lt_error.text + ")", 4)
	dotnet_create_test_case()
	return ""
END TRY
if debug_mode then
	dotnet_create_test_case()
end if

if isnull(ls_document_element_xml) or ls_document_element_xml = "" then return ""


return ls_document_element_xml


end function

on u_component_document_dotnet.create
call super::create
end on

on u_component_document_dotnet.destroy
call super::destroy
end on

