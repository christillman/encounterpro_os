$PBExportHeader$u_component_xml_handler_documenttemplatelist.sru
forward
global type u_component_xml_handler_documenttemplatelist from u_component_xml_handler_base
end type
end forward

global type u_component_xml_handler_documenttemplatelist from u_component_xml_handler_base
end type
global u_component_xml_handler_documenttemplatelist u_component_xml_handler_documenttemplatelist

type variables

end variables

forward prototypes
protected function integer xx_interpret_xml ()
protected function integer xx_initialize ()
public function str_document_template_file get_template_file_type (str_element pstr_element)
public function str_document_template get_template_type (str_element pstr_element)
public function str_document_templates get_nestedtemplatetype (str_element pstr_element)
end prototypes

protected function integer xx_interpret_xml ();PBDOM_ELEMENT lo_root
PBDOM_ELEMENT lo_from_block
PBDOM_ELEMENT lo_to_block
PBDOM_ELEMENT lo_elem[]
str_element lstr_element
integer li_sts
int i
string ls_root
string ls_tag
string ls_value
long ll_count
str_document_templates lstr_document_templates

lstr_document_templates.template_count = 0

TRY
	lo_root = xml.XML_Document.GetRootElement()
	ls_root = lo_root.getname()
	
	lo_root.GetChildElements(ref lo_elem)
	ll_count = UpperBound(lo_elem)
	
CATCH (pbdom_exception lo_error)
	log.log(this, "u_component_xml_handler_documenttemplatelist.xx_interpret_xml:0024", "Error - " + lo_error.text, 4)
	return -1
END TRY


for i = 1 to ll_count
	ls_tag = lo_elem[i].getname()
	ls_value = lo_elem[i].gettexttrim( )
	
	CHOOSE CASE lower(ls_tag)
		CASE "template"
			lstr_document_templates.template_count += 1
			lstr_element = get_element(lo_elem[i])
			lstr_document_templates.template[lstr_document_templates.template_count] = get_template_type(lstr_element)
	END CHOOSE
next

document_payload = lstr_document_templates

return 1


end function

protected function integer xx_initialize ();

return 1

end function

public function str_document_template_file get_template_file_type (str_element pstr_element);string ls_description
str_document_template_file lstr_document_template_file
long i
string ls_date_and_time
string ls_amount
string ls_unit
long ll_amount
date ld_date
string ls_id
integer li_sts
string ls_temp
str_element lstr_element
string ls_hexdata

setnull(lstr_document_template_file.filename)
setnull(lstr_document_template_file.filetype)
setnull(lstr_document_template_file.templatedata)
setnull(lstr_document_template_file.modifieddate)

if not pstr_element.valid then return lstr_document_template_file

// Assume that this is a "Name" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "filename"
			lstr_document_template_file.filename = pstr_element.child[i].gettexttrim()
		CASE "filetype"
			lstr_document_template_file.filetype = pstr_element.child[i].gettexttrim()
		CASE "templatedata"
			ls_hexdata = pstr_element.child[i].gettexttrim()
			if len(ls_hexdata) > 0 then
				lstr_document_template_file.templatedata = common_thread.inv_CoderObject.HexDecode(ls_hexdata)
			end if
		CASE "modifieddate"
			lstr_document_template_file.modifieddate = f_xml_datetime(pstr_element.child[i].gettexttrim())
	END CHOOSE
next


return lstr_document_template_file


end function

public function str_document_template get_template_type (str_element pstr_element);string ls_description
str_document_template lstr_document_template
long i
string ls_date_and_time
string ls_amount
string ls_unit
long ll_amount
date ld_date
string ls_id
integer li_sts
string ls_temp
str_element lstr_element

setnull(lstr_document_template.description)
setnull(lstr_document_template.sortsequence)
setnull(lstr_document_template.templatefile.filename)
setnull(lstr_document_template.templatefile.filetype)
setnull(lstr_document_template.templatefile.templatedata)
setnull(lstr_document_template.templatefile.modifieddate)
lstr_document_template.templates.template_count = 0

if not pstr_element.valid then return lstr_document_template

// Assume that this is a "Name" template
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "description"
			lstr_document_template.description = pstr_element.child[i].gettexttrim()
		CASE "sortsequence"
			lstr_document_template.sortsequence = long(pstr_element.child[i].gettexttrim())
		CASE "templatefile"
			lstr_element = get_element(pstr_element.child[i])
			lstr_document_template.templatefile = get_template_file_type(lstr_element)
		CASE "templates"
			lstr_element = get_element(pstr_element.child[i])
			lstr_document_template.templates = get_nestedtemplatetype(lstr_element)
	END CHOOSE
next


return lstr_document_template


end function

public function str_document_templates get_nestedtemplatetype (str_element pstr_element);string ls_description
str_document_templates lstr_document_templates
long i
string ls_date_and_time
string ls_amount
string ls_unit
long ll_amount
date ld_date
string ls_id
integer li_sts
string ls_temp
str_element lstr_element

lstr_document_templates.template_count = 0

if not pstr_element.valid then return lstr_document_templates

// Assume that this is a "Name" template
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "template"
			lstr_element = get_element(pstr_element.child[i])
			lstr_document_templates.template_count += 1
			lstr_document_templates.template[lstr_document_templates.template_count] = get_template_type(lstr_element)
	END CHOOSE
next


return lstr_document_templates


end function

on u_component_xml_handler_documenttemplatelist.create
call super::create
end on

on u_component_xml_handler_documenttemplatelist.destroy
call super::destroy
end on

