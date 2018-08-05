$PBExportHeader$u_component_document_xml.sru
forward
global type u_component_document_xml from u_component_document
end type
end forward

global type u_component_document_xml from u_component_document
end type
global u_component_document_xml u_component_document_xml

type variables

end variables

forward prototypes
protected function integer xx_do_source ()
end prototypes

protected function integer xx_do_source ();u_xml_script luo_xml
string ls_root_element
long ll_xml_script_id
u_xml_document lo_xml
integer li_sts
string ls_document_description
str_c_xml_class lstr_xml_class

get_attribute("xml_script_id", ll_xml_script_id)
if isnull(ll_xml_script_id) then
	log.log(this, "u_component_document_xml.xx_do_source:0011", "No XML script specified", 4)
	return -1
end if

luo_xml = CREATE u_xml_script
li_sts = luo_xml.create_xml(ll_xml_script_id, get_attributes(), lo_xml)
if li_sts <= 0 then return -1

ls_document_description = get_attribute("document_description")
if isnull(ls_document_description) then ls_document_description = lstr_xml_class.description

observation_count = 1
observations[1].result_count = 0
observations[1].attachment_list.attachment_count = 1
observations[1].attachment_list.attachments[1].attachment_type = "XML"
observations[1].attachment_list.attachments[1].extension = lstr_xml_class.file_extension
observations[1].attachment_list.attachments[1].attachment_comment_title = ls_document_description
observations[1].attachment_list.attachments[1].attachment = blob(lo_xml.xml_string)

observations[1].attachment_list.attachments[1].attached_by_user_id = current_user.user_id

//document_file.extension = "xml"
//document_file.attachment = blob(ls_xml)
//document_file.attachment_type = f_attachment_type_from_object_type(document_file.extension)
//setnull(document_file.filename)
//setnull(document_file.attachment_comment)
//document_file.attachment_comment_title = description

return 1

end function

on u_component_document_xml.create
call super::create
end on

on u_component_document_xml.destroy
call super::destroy
end on

