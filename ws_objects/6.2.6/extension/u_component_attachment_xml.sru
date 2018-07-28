HA$PBExportHeader$u_component_attachment_xml.sru
forward
global type u_component_attachment_xml from u_component_attachment
end type
end forward

global type u_component_attachment_xml from u_component_attachment
end type
global u_component_attachment_xml u_component_attachment_xml

type variables

end variables

forward prototypes
protected function integer xx_interpret ()
public function integer xx_render (string ps_file_type, ref string ps_file, integer pi_width, integer pi_height)
public function integer xx_display ()
end prototypes

protected function integer xx_interpret ();integer li_sts
str_complete_context lstr_context
str_complete_context lstr_document_context
blob lbl_xml_file
string ls_xml
u_xml_document lo_xml_document

li_sts = get_attachment_blob(lbl_xml_file)
if li_sts <= 0 then return -1

ls_xml = f_blob_to_string(lbl_xml_file)

li_sts = f_get_xml_document(ls_xml, lo_xml_document)
if li_sts <= 0 then return li_sts

li_sts = lo_xml_document.interpret(lstr_context, lstr_document_context)

return li_sts

end function

public function integer xx_render (string ps_file_type, ref string ps_file, integer pi_width, integer pi_height);integer li_sts
str_complete_context lstr_context
blob lbl_xml_file
string ls_xml
u_xml_document lo_xml_document
string ls_rendered
string ls_extension
string ls_render_file
string ls_xform_file
str_patient_material lstr_xform
blob lbl_render_file
boolean lb_sts
str_c_xml_class lstr_xml_class
string ls_stylesheet
long ll_pos

// Get the attachment and make a xml document
li_sts = get_attachment_blob(lbl_xml_file)
if li_sts <= 0 then return -1

ls_xml = f_blob_to_string(lbl_xml_file)

li_sts = f_get_xml_document(ls_xml, lo_xml_document)
if li_sts <= 0 then return li_sts

lstr_xml_class = lo_xml_document.get_xml_class( )

ls_render_file = f_temp_file("xml")

if (lstr_xml_class.render_transform_material_id) > 0 then
	lstr_xform = f_get_patient_material(lstr_xml_class.render_transform_material_id, true)
	ls_xform_file = f_temp_file("xsl")
	li_sts = log.file_write(lstr_xform.material_object , ls_xform_file)
	if li_sts <= 0 then return -1
	
	// <?xml-stylesheet type="text/xsl" href="ccr_display_transform.xsl" ?>
	ls_stylesheet = "<?xml-stylesheet type=~"text/xsl~" href=~"" + ls_xform_file + "~" ?>"

	if left(lefttrim(left(ls_xml, 80)), 2) = "<?" then
		ll_pos = pos(ls_xml, "?>")
		if ll_pos = 0 then
			ls_xml = ls_stylesheet + ls_xml
		else
			ls_xml = replace(ls_xml, ll_pos + 2, 0, ls_stylesheet)
		end if
	else
		ls_xml = ls_stylesheet + ls_xml
	end if

end if

lbl_xml_file = f_xml_to_blob(ls_xml)
li_sts = log.file_write(lbl_xml_file, ls_render_file)
if li_sts <= 0 then return -1

ps_file = ls_render_file

return 1


end function

public function integer xx_display ();integer li_sts
str_complete_context lstr_context
blob lbl_xml_file
string ls_xml
u_xml_document lo_xml_document
string ls_rendered
string ls_extension
string ls_render_file
string ls_xform_file
str_patient_material lstr_xform
blob lbl_render_file
boolean lb_sts
str_c_xml_class lstr_xml_class
string ls_stylesheet
long ll_pos

// Get the attachment and make a xml document
li_sts = get_attachment_blob(lbl_xml_file)
if li_sts <= 0 then return -1

ls_xml = f_blob_to_string(lbl_xml_file)

li_sts = f_get_xml_document(ls_xml, lo_xml_document)
if li_sts <= 0 then return li_sts

lstr_xml_class = lo_xml_document.get_xml_class( )

ls_render_file = f_temp_file("xml")

if (lstr_xml_class.render_transform_material_id) > 0 then
	lstr_xform = f_get_patient_material(lstr_xml_class.render_transform_material_id, true)
	ls_xform_file = f_temp_file("xsl")
	li_sts = log.file_write(lstr_xform.material_object , ls_xform_file)
	if li_sts <= 0 then return -1
	
	// <?xml-stylesheet type="text/xsl" href="ccr_display_transform.xsl" ?>
	ls_stylesheet = "<?xml-stylesheet type=~"text/xsl~" href=~"" + ls_xform_file + "~" ?>"

	if left(lefttrim(left(ls_xml, 80)), 2) = "<?" then
		ll_pos = pos(ls_xml, "?>")
		if ll_pos = 0 then
			ls_xml = ls_stylesheet + ls_xml
		else
			ls_xml = replace(ls_xml, ll_pos + 2, 0, ls_stylesheet)
		end if
	else
		ls_xml = ls_stylesheet + ls_xml
	end if

end if

lbl_xml_file = f_xml_to_blob(ls_xml)
li_sts = log.file_write(lbl_xml_file, ls_render_file)
if li_sts <= 0 then return -1

f_open_browser("file://" + ls_render_file)

return 1


end function

on u_component_attachment_xml.create
call super::create
end on

on u_component_attachment_xml.destroy
call super::destroy
end on

