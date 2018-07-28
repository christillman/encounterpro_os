$PBExportHeader$u_xml_document.sru
forward
global type u_xml_document from nonvisualobject
end type
end forward

global type u_xml_document from nonvisualobject
end type
global u_xml_document u_xml_document

type variables
PBDOM_Document XML_Document
string XML_String
//str_c_xml_class xml_class

any document_payload


end variables

forward prototypes
public function str_c_xml_class get_xml_class ()
public function integer render (ref string ps_rendered, ref string ps_extension)
public function integer add_root (pbdom_element po_root)
public function integer interpret (str_complete_context pstr_from_context, ref str_complete_context pstr_document_context)
public function string child_value (pbdom_element po_parent, string ps_child_tag)
public function string get_value (string ps_tag)
public function integer initialize (string ps_xml)
public function integer initialize (pbdom_document po_document)
public function integer save_to_file (string ps_filename)
end prototypes

public function str_c_xml_class get_xml_class ();string ls_xml_class
integer li_sts
PBDOM_ELEMENT pbdom_root
PBDOM_ATTRIBUTE pbdom_attribute_array2[]
string ls_xml_root_tag
string ls_xml_namespace
string ls_xml_schema
string ls_xml_root_tag_search
string ls_xml_namespace_search
string ls_xml_schema_search
int i
u_ds_data luo_class_selection
long ll_rowcount
str_c_xml_class lstr_xml_class

// Initialize to null to indicate error
setnull(lstr_xml_class.xml_class)

TRY
	pbdom_root = XML_Document.GetRootElement()
CATCH (pbdom_exception lo_error)
	log.log(this, "get_xml_class()", "Error - " + lo_error.text, 4)
	return lstr_xml_class
END TRY

ls_xml_root_tag = pbdom_root.GetName()
setnull(ls_xml_namespace)
setnull(ls_xml_schema)

if pbdom_root.HasAttributes() then
	pbdom_root.GetAttributes(ref pbdom_attribute_array2[])
	for i = 1 to UpperBound(pbdom_attribute_array2)
			//MessageBox("pbdom_attrtibute_array2", pbdom_attribute_array2[i].GetName() + ' ' + & 
			//                                   pbdom_attribute_array2[i].GetText())									  		
		choose case lower(pbdom_attribute_array2[i].GetName())
			case "xmlns"
				ls_xml_namespace = pbdom_attribute_array2[i].GetText()
			case "xsi:schemaLocation"
				ls_xml_schema = pbdom_attribute_array2[i].GetText()
		end choose
	next	
end if

luo_class_selection = CREATE u_ds_data
luo_class_selection.set_dataobject("dw_c_xml_class_selection")
ll_rowcount = luo_class_selection.retrieve()
for i = 1 to ll_rowcount
	ls_xml_root_tag_search = luo_class_selection.object.xml_root_tag[i]
	ls_xml_namespace_search = luo_class_selection.object.xml_namespace[i]
	ls_xml_schema_search = luo_class_selection.object.xml_schema[i]
	
	if not isnull(ls_xml_root_tag_search) then
		if isnull(ls_xml_root_tag) or lower(ls_xml_root_tag) <> lower(ls_xml_root_tag_search) then continue
	end if
	
	if not isnull(ls_xml_namespace_search) then
		if isnull(ls_xml_namespace) or lower(ls_xml_namespace) <> lower(ls_xml_namespace_search) then continue
	end if
	
	if not isnull(ls_xml_schema_search) then
		if isnull(ls_xml_schema) or lower(ls_xml_schema) <> lower(ls_xml_schema_search) then continue
	end if
	
	// If we get here then all three search criteria were either null or matched our XML Document
	ls_xml_class = luo_class_selection.object.xml_class[i]
	
	lstr_xml_class = datalist.get_xml_class(ls_xml_class)
	
	return lstr_xml_class
next

// If we get here then we didn't find a match so search based only on the root element and xml schema which can be found
// in the c_xml_class table

SELECT min(xml_class)
INTO :ls_xml_class
FROM c_XML_Class
WHERE root_element = :ls_xml_root_tag
AND ISNULL(xml_schema, '<NULL>') = ISNULL(:ls_xml_schema, '<NULL>');
if not tf_check() then return lstr_xml_class

if isnull(ls_xml_class) then
	log.log(this, "get_xml_class()", "XML Class not found", 4)
	return lstr_xml_class
end if

lstr_xml_class = datalist.get_xml_class(ls_xml_class)
if isnull(lstr_xml_class.xml_class) then
	log.log(this, "get_xml_class()", "XML Class not valid (" + ls_xml_class + ")", 4)
	return lstr_xml_class
end if

return lstr_xml_class


end function

public function integer render (ref string ps_rendered, ref string ps_extension);integer li_sts
str_c_xml_class lstr_xml_class
str_patient_material lstr_material
string ls_xslt
string ls_render_file
blob lbl_render_file

ps_extension = "xml"

lstr_xml_class = get_xml_class()
if isnull(lstr_xml_class.xml_class) then
	ps_rendered = xml_string
else
	lstr_material = f_get_patient_material(lstr_xml_class.render_transform_material_id , true)
	if isnull(lstr_material.material_id) then
		ps_rendered = xml_string
	else
		ls_xslt = f_blob_to_string(lstr_material.material_object)
		
		TRY
			ps_rendered = common_thread.eprolibnet4.TransformXML(xml_string, ls_xslt)
		CATCH (throwable lo_error)
			log.log(this, "xx_render()", "Error transforming xml file", 3)
			setnull(ps_rendered)
		END TRY
		
		if isnull(ps_rendered) or len(ps_rendered) = 0 then
			ps_rendered = xml_string
		else
			ps_extension = lstr_xml_class.render_transform_extension
		end if
	end if
end if

return 1


end function

public function integer add_root (pbdom_element po_root);string ls_xml
string ls_file
blob lbl_xml
integer li_sts
boolean lb_success
string ls_root

ls_root = po_root.getname()

if not isvalid(xml_document) or isnull(xml_document) then
	xml_document = CREATE pbdom_document
	xml_document.newdocument(ls_root)
end if

TRY
	po_root.setdocument(xml_document)
CATCH (throwable lo_error)
	log.log(this, "add_root()", "Error setting root (" + lo_error.text + ")", 4)
	return -1
END TRY

// Now determine the xml string
ls_file = f_temp_file("xml")
TRY
	lb_success = xml_document.savedocument(ls_file)
	if not lb_success then
		log.log(this, "add_root()", "Error saving document", 4)
		return -1
	end if
CATCH (throwable lo_error2)
	log.log(this, "add_root()", "Error saving document (" + lo_error2.text + ")", 4)
	return -1
END TRY

li_sts = log.file_read(ls_file, lbl_xml)
if li_sts <= 0 then
	log.log(this, "add_root()", "Error reading document", 4)
	return -1
end if

xml_string = f_blob_to_string(lbl_xml)

DO WHILE true
	if isnull(xml_string) or xml_string = "" then
		setnull(xml_string)
		log.log(this, "add_root()", "No XML String Generated", 4)
		return -1
	end if
	if left(xml_string, 1) = "<" then exit
	
	xml_string = mid(xml_string, 2)
LOOP

return 1


end function

public function integer interpret (str_complete_context pstr_from_context, ref str_complete_context pstr_document_context);//
// Parameters:
//		pstr_from_context			The context from which the document is to be interpreted.  If some aspect
//										of the document needs a context (e.g. observation results need a treatment context)
//										then this context will be used if the document itself does not supply
//										then necessary context
//
//
//		pstr_document_context	The context provided by the document itself.  This is passed back
//										to the caller in case the caller wants to use the document's own
//										context to determine where to post the document
//
//
//
//
//

u_component_xml_handler luo_handler
integer li_sts
blob lbl_xml_file
str_c_xml_class lstr_xml_class


lstr_xml_class = get_xml_class()
if isnull(lstr_xml_class.xml_class) then
	log.log(this, "xx_interpret()", "Error finding xml class", 4)
	return -1
end if

luo_handler = component_manager.get_component(lstr_xml_class.handler_component_id)
if isnull(luo_handler) or not isvalid(luo_handler) then
	log.log(this, "xx_interpret()", "Error creating xml handler class (" + lstr_xml_class.xml_handler_class + ")", 4)
	return -1
end if
	
li_sts = luo_handler.interpret_xml(this, pstr_from_context, pstr_document_context)

document_payload = luo_handler.document_payload

DESTROY luo_handler

return li_sts


end function

public function string child_value (pbdom_element po_parent, string ps_child_tag);PBDOM_ELEMENT lo_elem[]
string ls_tag
long ll_count
string ls_temp
string ls_null
long i

setnull(ls_null)

TRY
	po_parent.GetChildElements(ref lo_elem)
	ll_count = UpperBound(lo_elem)
	
CATCH (pbdom_exception lo_error)
	log.log(this, "child_value()", "Error getting children - " + lo_error.text, 4)
	return ls_null
END TRY

for i = 1 to ll_count
	ls_tag = lo_elem[i].getname()

	if lower(ls_tag) = lower(ps_child_tag) then
		ls_temp = lo_elem[i].gettexttrim()
		return ls_temp
	end if
next

return ls_null



end function

public function string get_value (string ps_tag);string ls_null
PBDOM_ELEMENT lo_root
PBDOM_ELEMENT lo_elem[]
datetime ldt_result_expected_date
integer li_sts
long ll_owner_id
int i
string ls_root
string ls_tag
long ll_count
boolean lb_haschildren
PBDOM_ELEMENT lo_actors
string ls_temp

setnull(ls_null)

TRY
	lo_root = XML_Document.GetRootElement()
CATCH (pbdom_exception lo_error)
	log.log(this, "process_xml", "Error getting root - " + lo_error.text, 4)
	return ls_null
END TRY

return child_value(lo_root, ps_tag)


end function

public function integer initialize (string ps_xml);PBDOM_BUILDER pbdombuilder_new
PBDOM_ELEMENT lo_element
blob lbl_xml_file
integer li_sts
string ls_beginning

// Store the string version
xml_string = ps_xml

// Now create the DOM version from the string version
pbdombuilder_new = Create PBDOM_Builder

// Make sure this looks like XML
ls_beginning = left(trim(ps_xml), 8)
if pos(ls_beginning, "<") > 0 and (pos(ps_xml, "</") > 0 or pos(ps_xml, "/>") > 0) then
	TRY
		XML_Document = pbdombuilder_new.BuildFromString(ps_xml)
	CATCH (throwable lo_error)
		log.log(this, "f_get_xml_document()", "Error building XML object (" + lo_error.text + ")", 4)
		return -1
	END TRY
else
	log.log(this, "f_get_xml_document()", "XML string does not look like XML", 4)
	return -1
end if

return 1


end function

public function integer initialize (pbdom_document po_document);PBDOM_BUILDER pbdombuilder_new
PBDOM_ELEMENT lo_element
blob lbl_xml_file
integer li_sts
string ls_beginning

// Store the DOM version
XML_Document = po_document

// Now create the string version from the DOM version
xml_string = f_xml_document_string(XML_Document)
if isnull(xml_string) then
	log.log(this, "initialize()", "Error getting document string", 4)
	return -1
end if

return 1


end function

public function integer save_to_file (string ps_filename);blob lbl_xml
integer li_sts

lbl_xml = f_xml_to_blob(xml_string)

li_sts = log.file_write(lbl_xml, ps_filename)

return li_sts

end function

on u_xml_document.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_xml_document.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

