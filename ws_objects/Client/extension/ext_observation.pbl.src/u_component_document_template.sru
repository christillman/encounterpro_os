$PBExportHeader$u_component_document_template.sru
forward
global type u_component_document_template from u_component_document
end type
end forward

global type u_component_document_template from u_component_document
end type
global u_component_document_template u_component_document_template

type variables

end variables

forward prototypes
protected function integer xx_do_source () throws exception
protected function integer xx_initialize ()
public function integer xx_configure_document ()
public function string xx_get_document_elements ()
public function str_document_templates get_document_templates ()
public function str_document_elements scan_templates_for_document_elements (str_document_templates pstr_document_templates)
public function integer save_document_templates (str_document_templates pstr_templates)
public function integer scan_templates_and_resolve_fields (readonly str_document_templates pstr_document_templates)
end prototypes

protected function integer xx_do_source () throws exception;string ls_document_element_xml
string ls_document
string ls_document_description
string ls_document_filetype
str_document_templates lstr_document_templates
str_document_files lstr_document_files
str_document_file lstr_compressed_document_file
str_document_file lstr_output_document_file
long i
integer li_sts
string ls_merge
string ls_document_filename
blob lbl_document_data
string ls_encoding
string ls_compression
boolean lb_add_cr_at_eof
exception le_exception

lstr_document_templates = get_document_templates()
if lstr_document_templates.template_count <= 0 then return 1

ls_document_description = get_attribute("document_description")
if isnull(ls_document_description) then
	ls_document_description = lstr_document_templates.template[1].description
end if

ls_document_filename = get_attribute("document_filename")
if isnull(ls_document_filename) then
	ls_document_filename = lstr_document_templates.template[1].templatefile.filename
end if

ls_document_filetype = get_attribute("document_filetype")
if isnull(ls_document_filetype) then
	ls_document_filetype = lstr_document_templates.template[1].templatefile.filetype
end if

ls_encoding = get_attribute("output_file_encoding")

// Set the document objects
TRY
	set_document_context_objects()
CATCH (exception le_error)
	log.log(this, "u_component_document_template.xx_do_source:0043", "Error setting document clinical objects (" + le_error.text + ")" , 4)
	THROW le_error
END TRY


// Set the document objects
TRY
	// Scan the template materials for document fields
	li_sts = scan_templates_and_resolve_fields(lstr_document_templates)
	if li_sts < 0 then
		le_exception = CREATE exception
		le_exception.text = "Error Resolving Templates"
		THROW le_exception
	end if
	if li_sts = 0 then return 1  // No data so return success
CATCH (exception le_error2)
	log.log(this, "u_component_document_template.xx_do_source:0059", "Error resolving templates: " + le_error2.text, 4)
	THROW le_error2
END TRY

get_attribute("add_cr_at_eof", lb_add_cr_at_eof, false)
if lb_add_cr_at_eof then
	for i = 1 to lstr_document_templates.template_count
		if len(lstr_document_templates.template[i].resultstring) > 0 then
			lstr_document_templates.template[i].resultstring += "~r~n"
		end if
	next
end if


ls_merge = get_attribute("merge")
if isnull(ls_merge) then ls_merge = "CONCATENATE CRLF"

CHOOSE CASE upper(ls_merge)
	CASE "ZIP"
		lstr_compressed_document_file.filename = ls_document_filename
		lstr_compressed_document_file.filetype = "zip"
		lstr_compressed_document_file.filedescription = ls_document_description
		setnull(lstr_compressed_document_file.filedata)
		
		for i = 1 to lstr_document_templates.template_count
			if len(lstr_document_templates.template[i].resultstring) > 0 then
				lstr_document_files.file_count += 1
				if len(lstr_document_templates.template[i].templatefile.filename) > 0 then
					lstr_document_files.file[lstr_document_files.file_count].filename = lstr_document_templates.template[i].templatefile.filename
				else
					lstr_document_files.file[lstr_document_files.file_count].filename = f_string_to_filename(lstr_document_templates.template[i].description)
				end if
				lstr_document_files.file[lstr_document_files.file_count].filetype = lstr_document_templates.template[i].templatefile.filetype
				lstr_document_files.file[lstr_document_files.file_count].filedescription = lstr_document_templates.template[i].description
				lstr_document_files.file[lstr_document_files.file_count].filedata = f_string_to_blob(lstr_document_templates.template[i].resultstring, ls_encoding)
			end if
		next
		
		li_sts = f_compress_documents(lstr_compressed_document_file, lstr_document_files)
		if li_sts <= 0 then
			log.log(this, "u_component_document_template.xx_do_source:0099", "Error merging documents with compression", 4)
			return -1
		end if
		
		// The compressed file becomes the document file
		lstr_output_document_file = lstr_compressed_document_file
	CASE "CONCATENATE", "CONCATENATE CRLF"
		lstr_output_document_file.filename = ls_document_filename
		lstr_output_document_file.filetype = ls_document_filetype
		lstr_output_document_file.filedescription = ls_document_description
		ls_document = ""
		for i = 1 to lstr_document_templates.template_count
			if len(lstr_document_templates.template[i].resultstring) > 0 then
				if len(ls_document) > 0 and upper(ls_merge) = "CONCATENATE CRLF" then ls_document += "~r~n"
				ls_document += lstr_document_templates.template[i].resultstring
			end if
		next
		lstr_output_document_file.filedata = f_string_to_blob(ls_document, ls_encoding)
END CHOOSE


ls_compression = get_attribute("document_compression")
if not isnull(ls_compression) and lower(ls_compression) <> "none" then
	lstr_compressed_document_file.filename = ls_document_filename
	lstr_compressed_document_file.filetype = lower(ls_compression)
	setnull(lstr_compressed_document_file.filedata)
	
	lstr_document_files.file_count = 1
	lstr_document_files.file[1] = lstr_output_document_file
	li_sts = f_compress_documents(lstr_compressed_document_file, lstr_document_files)
	if li_sts <= 0 then
		log.log(this, "u_component_document_template.xx_do_source:0130", "Error compressing document", 4)
		return -1
	end if
	
	// The compressed file becomes the document file
	lstr_output_document_file = lstr_compressed_document_file
end if

// Create the attachment structure for the document
observation_count = 1
observations[1].result_count = 0
observations[1].attachment_list.attachment_count = 1
observations[1].attachment_list.attachments[1].attachment_type = "FILE"
observations[1].attachment_list.attachments[1].filename = lstr_output_document_file.filename
observations[1].attachment_list.attachments[1].extension = lstr_output_document_file.filetype
observations[1].attachment_list.attachments[1].attachment_comment_title = lstr_output_document_file.filedescription
observations[1].attachment_list.attachments[1].attachment = lstr_output_document_file.filedata
observations[1].attachment_list.attachments[1].attached_by_user_id = current_user.user_id

return 1

end function

protected function integer xx_initialize ();integer li_sts
str_attributes lstr_attributes


return 1



end function

public function integer xx_configure_document ();string ls_document_element_xml
string ls_report_id
string ls_document
string ls_document_description
string ls_document_extension
str_document_templates lstr_document_templates
w_component_template_config lw_window

lstr_document_templates = get_document_templates()

get_attribute("report_id", ls_report_id)

// Let the user add/remove/edit/order the document templates

openwithparm(lw_window, this, "w_component_template_config")


return 1


end function

public function string xx_get_document_elements ();string ls_document_element_xml
string ls_report_id
str_document_elements lstr_document_elements
str_document_templates lstr_document_templates

lstr_document_templates = get_document_templates()

get_attribute("report_id", ls_report_id)

// Scan the template materials for document fields
lstr_document_elements = scan_templates_for_document_elements(lstr_document_templates)

if lstr_document_elements.element_set_count <= 0 then return ""

ls_document_element_xml = f_get_document_elements_xml(lstr_document_elements)

return ls_document_element_xml


end function

public function str_document_templates get_document_templates ();str_patient_material lstr_material
long ll_material_id
str_attributes lstr_attributes
long i
str_document_templates lstr_document_templates
string ls_description
string ls_temp
string ls_report_id
long ll_attribute_sequence
blob lbl_templates
string ls_templates_xml
string ls_beginning
integer li_sts

ls_report_id = get_attribute("report_id")


SELECT max(attribute_sequence)
INTO :ll_attribute_sequence
FROM c_Report_Attribute
WHERE report_id = :ls_report_id
AND attribute = 'document_templates';
if not tf_check() then return lstr_document_templates
if isnull(ll_attribute_sequence) then return lstr_document_templates

SELECTBLOB objectdata
INTO :lbl_templates
FROM c_Report_Attribute
WHERE report_id = :ls_report_id
AND attribute_sequence = :ll_attribute_sequence;
if not tf_check() then return lstr_document_templates

ls_templates_xml = f_blob_to_string(lbl_templates)

// See if it's XML data
ls_beginning = left(trim(ls_templates_xml), 8)
if pos(ls_beginning, "<") > 0 and (pos(ls_templates_xml, "</") > 0 or pos(ls_templates_xml, "/>") > 0) then
	// Convert the previous mapping to structures
	li_sts = f_get_document_templates_from_xml(ls_templates_xml, lstr_document_templates)
	if li_sts < 0 then return lstr_document_templates
end if


return lstr_document_templates

end function

public function str_document_elements scan_templates_for_document_elements (str_document_templates pstr_document_templates);str_document_elements lstr_document_elements
str_document_element_set lstr_document_element_set
string ls_material_string
long i
long j
str_document_template_fields lstr_document_template_fields

// Loop through each template file
for i = 1 to pstr_document_templates.template_count
	// Get the string version of the template file contents
	ls_material_string = f_blob_to_string(pstr_document_templates.template[i].templatefile.templatedata)
	
	// Scan the string for template fields using our standard scanner algorithm
	lstr_document_template_fields = f_scan_string_for_document_elements(ls_material_string)
	
	if lstr_document_template_fields.template_field_count > 0 then
		// If the template file contained fields then create an element set
		lstr_document_elements.element_set_count += 1
		lstr_document_element_set.description = pstr_document_templates.template[i].description
		lstr_document_element_set.element_count = 0
		lstr_document_element_set.maptocollection = true  // Allow mapping to a collection
		setnull(lstr_document_element_set.maptocollectiontype)
		setnull(lstr_document_element_set.collectiondefinition)
		
		// Add an element for each token found
		for j = 1 to lstr_document_template_fields.template_field_count
			lstr_document_element_set.element_count += 1
			lstr_document_element_set.element[lstr_document_element_set.element_count].element = lstr_document_template_fields.template_field[j].description
			lstr_document_element_set.element[lstr_document_element_set.element_count].datatype = lstr_document_template_fields.template_field[j].field_datatype
			lstr_document_element_set.element[lstr_document_element_set.element_count].maxlength = lstr_document_template_fields.template_field[j].field_datalength
		next
		
		lstr_document_elements.element_set[lstr_document_elements.element_set_count] = lstr_document_element_set
	end if
next


return lstr_document_elements

end function

public function integer save_document_templates (str_document_templates pstr_templates);string ls_report_id
long ll_attribute_sequence
blob lbl_templates
string ls_templates_xml

ls_report_id = get_attribute("report_id")

ls_templates_xml = f_get_document_templates_xml(pstr_templates)
lbl_templates = blob(ls_templates_xml)

if len(ls_templates_xml) > 0 then
	SELECT max(attribute_sequence)
	INTO :ll_attribute_sequence
	FROM c_Report_Attribute
	WHERE report_id = :ls_report_id
	AND attribute = 'document_templates';
	if not tf_check() then return -1
	if isnull(ll_attribute_sequence) then 
		INSERT INTO c_Report_Attribute (
			report_id,
			attribute,
			component_attribute)
		VALUES (
			:ls_report_id,
			'document_templates',
			'N');
		if not tf_check() then return -1
		
		SELECT scope_identity()
		INTO :ll_attribute_sequence
		FROM c_1_record;
		if not tf_check() then return -1
	end if
	
	UPDATEBLOB c_Report_Attribute
	SET objectdata = :lbl_templates
	WHERE report_id = :ls_report_id
	AND attribute_sequence = :ll_attribute_sequence;
	if not tf_check() then return -1
else
	return 0
end if

return 1

end function

public function integer scan_templates_and_resolve_fields (readonly str_document_templates pstr_document_templates);str_document_elements lstr_mapped_document_elements
string ls_material_string
long ll_template_index
long ll_field_index
str_document_template_fields lstr_document_template_fields
string ls_template
string ls_document
string ls_report_id
long ll_attribute_sequence
blob lbl_field_map
string ls_document_field_map
str_property_value lstr_property_value
boolean lb_set_found
long ll_set_index
boolean lb_element_found
long ll_element_index
str_attributes lstr_attributes
string ls_field_value
integer li_sts
boolean lb_add_cr
long ll_key_index
str_complete_context lstr_context
str_document_element_set_collection lstr_collection
boolean lb_got_results
long ll_document_patient_workplan_item_id

ls_document = ""
lstr_context = f_get_complete_context()
lstr_attributes = get_attributes()
get_attribute("add_cr_between_templates", lb_add_cr, true)

// Get the field mappings
ls_report_id = get_attribute("report_id")
if isnull(ls_report_id) or len(ls_report_id) < 36 then
	log.log(this, "u_component_document_template.scan_templates_and_resolve_fields:0035", "No report_id", 4)
	return -1
end if
f_attribute_add_attribute(lstr_attributes, "report_id", ls_report_id)

// We must have a document_patient_workplan_item_id attribute
get_attribute("document_patient_workplan_item_id", ll_document_patient_workplan_item_id)
if isnull(ll_document_patient_workplan_item_id) then
	log.log(this, "u_component_document_template.scan_templates_and_resolve_fields:0043", "document_patient_workplan_item_id attribute not found", 4)
	return -1
end if
f_attribute_add_attribute(lstr_attributes, "document_patient_workplan_item_id", string(ll_document_patient_workplan_item_id))

SELECT max(attribute_sequence)
INTO :ll_attribute_sequence
FROM c_Report_Attribute
WHERE report_id = :ls_report_id
AND attribute = 'document_field_map'
AND DATALENGTH(objectdata) > 0;
if not tf_check() then return -1

if ll_attribute_sequence > 0 then
	SELECTBLOB objectdata
	INTO :lbl_field_map
	FROM c_Report_Attribute
	WHERE report_id = :ls_report_id
	AND attribute_sequence = :ll_attribute_sequence;
	if not tf_check() then return -1
	
	ls_document_field_map = f_blob_to_string(lbl_field_map)
	li_sts = f_get_document_elements_from_xml(ls_document_field_map, lstr_mapped_document_elements)
	if li_sts < 0 then
		log.log(this, "u_component_document_template.scan_templates_and_resolve_fields:0067", "Unable to read document element mappings", 4)
	end if
end if


// Loop through each template file, scan it and resolve all the field mappings
for ll_template_index = 1 to pstr_document_templates.template_count
	// Find the element set for this template
	lb_set_found = false
	for ll_set_index = 1 to lstr_mapped_document_elements.element_set_count
		if lower(lstr_mapped_document_elements.element_set[ll_set_index].description) = lower(pstr_document_templates.template[ll_template_index].description) then
			lb_set_found = true
			exit
		end if
	next
	
	// We found an element set so get the collection for it
	if lb_set_found then
		lstr_collection = f_resolve_collection(lstr_mapped_document_elements.element_set[ll_set_index], lstr_context, lstr_attributes)
	else
		// Otherwise just resolve each field against the EDAS root
		lstr_collection.collectiontype = "EDAS"
		lstr_collection.collectionobject = "Root"
		lstr_collection.collectionobjectcount = 1
		lstr_collection.collectionobjectkey[1] = ""
	end if		

	// Loop through the collection objects ad resolve the fields
	for ll_key_index = 1 to lstr_collection.collectionobjectcount
		// Get the string version of the template file contents
		ls_material_string = f_blob_to_string(pstr_document_templates.template[ll_template_index].templatefile.templatedata)
		
		// Scan the string for template fields using our standard scanner algorithm
		lstr_document_template_fields = f_scan_string_for_document_elements(ls_material_string)
		
		ls_template = lstr_document_template_fields.template_string
		
		// Loop through the fields backwards so that the field offsets stay correct
		for ll_field_index = lstr_document_template_fields.template_field_count to 1 step -1
			if lb_set_found then
				lb_element_found = false
				for ll_element_index = lstr_mapped_document_elements.element_set[ll_set_index].element_count to 1 step -1
					if lower(lstr_mapped_document_elements.element_set[ll_set_index].element[ll_element_index].element) = lower(lstr_document_template_fields.template_field[ll_field_index].description) then
						lb_element_found = true
						exit
					end if
				next
				
				if lb_element_found then
					// We found the element mapped to this template field, so resolve it
					lstr_property_value = f_resolve_field_mapping_from_object(lstr_collection, &
																								ll_key_index, &
																								lstr_mapped_document_elements.element_set[ll_set_index].element[ll_element_index], &
																								lstr_context, &
																								lstr_attributes)
					if len(lstr_property_value.display_value) > 0 then
						ls_field_value = lstr_property_value.display_value
					else
						// The mapped element resolved to nothing
						ls_field_value = ""
					end if
				else
					// We never found a mapped element for this template field
					ls_field_value = ""
				end if
			else
				// We never found an element_set for this template
				ls_field_value = ""
			end if
			
			// We have resolved the field into a value or an empty string.  Now replace the field token with the value.
			if lstr_document_template_fields.template_field[ll_field_index].field_datalength > 0 then
				if lower(lstr_document_template_fields.template_field[ll_field_index].field_datatype) = "number" then
					// Left pad numeric data
					ls_field_value = fill(" ", lstr_document_template_fields.template_field[ll_field_index].field_datalength) + ls_field_value
					ls_field_value = right(ls_field_value, lstr_document_template_fields.template_field[ll_field_index].field_datalength)
				else
					// Right pad non-numeric data
					ls_field_value = ls_field_value + fill(" ", lstr_document_template_fields.template_field[ll_field_index].field_datalength)
					ls_field_value = left(ls_field_value, lstr_document_template_fields.template_field[ll_field_index].field_datalength)
				end if
			end if
			ls_template = replace(ls_template, lstr_document_template_fields.template_field[ll_field_index].field_start, lstr_document_template_fields.template_field[ll_field_index].field_length, ls_field_value)
		next
		
		// If the add_cr_between_templates was true 
		if len(ls_document) > 0 and lb_add_cr then
			ls_document += "~r~n"
		end if
		ls_document += ls_template
	next
	
	if len(ls_document) > 0 then
		lb_got_results = true
		pstr_document_templates.template[ll_template_index].resultstring = ls_document
		ls_document = ""
	end if
next

if lb_got_results then
	return 1
end if

return 0


end function

on u_component_document_template.create
call super::create
end on

on u_component_document_template.destroy
call super::destroy
end on

