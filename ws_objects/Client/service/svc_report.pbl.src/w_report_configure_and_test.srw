$PBExportHeader$w_report_configure_and_test.srw
forward
global type w_report_configure_and_test from w_window_base
end type
type st_title from statictext within w_report_configure_and_test
end type
type cb_run_report from commandbutton within w_report_configure_and_test
end type
type cb_exit from commandbutton within w_report_configure_and_test
end type
type cb_configure_report from commandbutton within w_report_configure_and_test
end type
type dw_config_items from u_dw_pick_list within w_report_configure_and_test
end type
type st_1 from statictext within w_report_configure_and_test
end type
type cb_configure_document from commandbutton within w_report_configure_and_test
end type
type cb_test_file from commandbutton within w_report_configure_and_test
end type
type cb_document_properties from commandbutton within w_report_configure_and_test
end type
type cb_report_runtime from commandbutton within w_report_configure_and_test
end type
type st_report_title from statictext within w_report_configure_and_test
end type
type st_report_document_title from statictext within w_report_configure_and_test
end type
type st_2 from statictext within w_report_configure_and_test
end type
type str_working_file from structure within w_report_configure_and_test
end type
end forward

type str_working_file from structure
	string		attribute
	string		value
	str_patient_material		material
	string		working_file
	str_file_attributes		working_file_attributes
	boolean		working_file_updated
	unsignedlong		process_id
end type

global type w_report_configure_and_test from w_window_base
integer x = 439
integer y = 592
integer width = 2610
integer height = 1552
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
st_title st_title
cb_run_report cb_run_report
cb_exit cb_exit
cb_configure_report cb_configure_report
dw_config_items dw_config_items
st_1 st_1
cb_configure_document cb_configure_document
cb_test_file cb_test_file
cb_document_properties cb_document_properties
cb_report_runtime cb_report_runtime
st_report_title st_report_title
st_report_document_title st_report_document_title
st_2 st_2
end type
global w_report_configure_and_test w_report_configure_and_test

type variables
// This is the document workplan item which tracks the generation and sending of the document to recipients
// outside of EncounterPRO
u_component_wp_item_document wp_item_document

// This is the config object that defines what goes into the document when it is created
u_component_report report

// This is the document engine that uses the settings from the report (datafile) component and
// actually produces a document
u_component_document report_document

str_attributes report_runtime_attributes

string test_directory

private long working_file_count = 0
private str_working_file working_file[]

//private string document_component_id

boolean document_elements_available
str_document_elements document_elements


end variables

forward prototypes
public function integer refresh ()
public subroutine test_item (string ps_config_item_type, string ps_attribute, string ps_value, string ps_description)
public function integer run_rtf_report (long pl_display_script_id)
public subroutine update_item (long pl_row, string ps_config_item_type, string ps_attribute, string ps_value, string ps_description)
public subroutine add_config_item (string ps_config_item_type, str_attribute pstr_attribute)
public function integer get_document_elements ()
public function integer initialize_from_document (u_component_wp_item_document puo_document)
public function str_attributes report_runtime_attributes ()
public subroutine edit_item (string ps_config_item_type, string ps_attribute, string ps_value, string ps_description, long pl_attribute_sequence, string ps_component_id)
public subroutine document_objects_menu ()
end prototypes

public function integer refresh ();string ls_value
long ll_rowcount
long j
u_ds_data luo_attributes
str_attributes lstr_attributes
integer li_sts
long i
long ll_row
string ls_attribute
boolean lb_mapping_found
str_attribute lstr_mapping_attribute
boolean lb_selection_script
string ls_document_component_type

// If we have a document component then destroy it
if isvalid(report_document) and not isnull(report_document) then
	component_manager.destroy_component(report_document)
end if

// Get a new document component so that any function using the document component has one that
// reflects any recent config changes
report_document = report.document_component()
if isnull(report_document) then
	log.log(this, "w_report_configure_and_test.refresh:0024", "error getting component (" + report.report_id + ")", 4)
	return -1
end if

if isnull(report_document) then
	st_report_document_title.visible = false
	cb_configure_document.visible = false
	cb_test_file.visible = false
else
	st_report_document_title.text = report_document.component_description + ":"
	st_report_document_title.visible = true
	cb_configure_document.visible = true
	
	// This is a document report, now see if the document component is a .NET component
	SELECT component_type
	INTO :ls_document_component_type
	FROM dbo.fn_components()
	WHERE component_id = :report_document.component_id;
	if not tf_check() then return -1

	if lower(ls_document_component_type) = "document" then
		// This is a .NET document component so enable the test file button
		cb_test_file.visible = true
	end if
	
	// Get the document elements
	get_document_elements()
end if


lb_mapping_found = false
lb_selection_script = false

//// get attributes from c_report_attribute
//luo_attributes = Create u_ds_data
//luo_attributes.Set_dataobject("dw_report_attribute")
//li_sts = luo_attributes.Retrieve(report.report_id)
//If tf_check() Then
//	f_attribute_ds_to_str(luo_attributes,lstr_attributes)
//End If
//
//DESTROY luo_attributes

// Refresh report object attibutes
report.get_report_attributes(gnv_app.office_id)

lstr_attributes = report.get_attributes()

dw_config_items.reset()

for i = 1 to lstr_attributes.attribute_count
	ls_attribute = lower(lstr_attributes.attribute[i].attribute)
	if right(ls_attribute, 11) = "material_id" then
		add_config_item("File", lstr_attributes.attribute[i])
	end if
	
	if right(ls_attribute, 13) = "xml_script_id" then
		add_config_item("XML Script", lstr_attributes.attribute[i])
	end if

	if right(ls_attribute, 17) = "display_script_id" then
		add_config_item("RTF Script", lstr_attributes.attribute[i])
	end if

	if right(ls_attribute, 18) = "document_field_map" then
		add_config_item("Field Map", lstr_attributes.attribute[i])
		lb_mapping_found = true
	end if

	if right(ls_attribute, 31) = "context_object_selection_script" then
		add_config_item("Selection Script", lstr_attributes.attribute[i])
		lb_selection_script = true
	end if
next

// Now add instance config items from the wp_item_document
if not isnull(wp_item_document) then
	lstr_attributes = wp_item_document.get_attributes()
	
	for i = 1 to lstr_attributes.attribute_count
		ls_attribute = lower(lstr_attributes.attribute[i].attribute)
		if right(ls_attribute, 31) = "context_object_selection_script" then
			add_config_item("Local Selection Script", lstr_attributes.attribute[i])
			lb_selection_script = true
		end if
	next
end if

if document_elements_available and not lb_mapping_found then
	lstr_mapping_attribute.attribute = "document_field_map"
	setnull(lstr_mapping_attribute.attribute_sequence)
	add_config_item("Field Map", lstr_mapping_attribute)
end if

if lb_selection_script and not isnull(report_document) then
	setnull(lstr_mapping_attribute.attribute)
	setnull(lstr_mapping_attribute.attribute_sequence)
	add_config_item("Document Objects", lstr_mapping_attribute)
end if


// Set the updated_flag for any that have already been updated
for i = 1 to working_file_count
	if not fileexists(working_file[i].working_file) then continue
	
	if working_file[i].working_file_updated then
//		filecopy(working_file, display_file, true)
		// If the working file has been updated then set the dw flag
		ll_rowcount = dw_config_items.rowcount()
		for j = 1 to ll_rowcount
			ls_attribute = dw_config_items.object.attribute[j]
			ls_value = dw_config_items.object.value[j]
			if ls_attribute = working_file[i].attribute and ls_value =  working_file[i].value then
				dw_config_items.object.updated_flag[j] = 1
				exit
			end if
		next
	end if
next	


return 1

end function

public subroutine test_item (string ps_config_item_type, string ps_attribute, string ps_value, string ps_description);long ll_row
string ls_id
str_popup popup
str_display_script lstr_display_script
long ll_xml_script_id
long ll_display_script_id
long ll_material_id
integer li_sts
u_xml_script lo_xml
u_xml_document lo_document
string ls_tempfile
long pl_patient_workplan_item_id
str_patient_materials lstr_patient_materials

if not isnull(current_service) then
	pl_patient_workplan_item_id = current_service.patient_workplan_item_id
else
	setnull(pl_patient_workplan_item_id)
end if

CHOOSE CASE lower(ps_config_item_type)
	CASE "file"
		ll_material_id = long(ps_value)
	CASE "xml script"
		ll_xml_script_id = long(ps_value)

		li_sts = f_attribute_get_materials(report_runtime_attributes(), true, lstr_patient_materials)

		lo_xml = CREATE u_xml_script

		li_sts = lo_xml.create_xml(pl_patient_workplan_item_id, &
										ll_xml_script_id, &
										"ComponentAttributes", &
										f_current_context(), &
										report_runtime_attributes(),&
										lstr_patient_materials, &
										lo_document)
		
		ls_tempfile = test_directory + f_string_to_filename(ps_description) + ".xml"
		
		li_sts = lo_document.save_to_file(ls_tempfile)
		if li_sts < 0 then return
		
		f_open_file(ls_tempfile, true)
		
	CASE "rtf script"
		ll_display_script_id = long(ps_value)

		run_rtf_report(ll_display_script_id)
END CHOOSE


return


end subroutine

public function integer run_rtf_report (long pl_display_script_id);String 					ls_report_id
String 					ls_component_id
u_component_report 	luo_report
str_attributes 			lstr_attributes
integer li_sts

ls_report_id = "4B657EFA-AB67-482B-9FAB-1764440DF116" // generic rtf report
ls_component_id = "RPT_RTF"

luo_report = component_manager.get_component(ls_component_id)
If Isnull(luo_report) Then
	log.log(This, "w_report_configure_and_test.run_rtf_report:0012", "Error getting report component (" + ls_component_id + ")", 4)
	Return -1
End If

// Set the report_id property
luo_report.report_id = ls_report_id 

f_attribute_add_attribute(lstr_attributes, "office_id", gnv_app.office_id)
f_attribute_add_attribute(lstr_attributes, "DESTINATION", "SCREEN")
f_attribute_add_attribute(lstr_attributes, "display_script_id", string(pl_display_script_id))

li_sts = luo_report.printreport(ls_report_id, lstr_attributes)

component_manager.destroy_component(luo_report)

Return 1

end function

public subroutine update_item (long pl_row, string ps_config_item_type, string ps_attribute, string ps_value, string ps_description);long ll_row
str_popup popup
str_popup_return popup_return
str_display_script lstr_display_script
long ll_xml_script_id
long ll_display_script_id
integer li_sts
w_window_base lw_edit_window
long ll_working_file_index
long i
string ls_url
blob lbl_new_file
string ls_new_value
str_patient_material lstr_patient_material

CHOOSE CASE lower(ps_config_item_type)
	CASE "file"
		lstr_patient_material = f_get_patient_material(long(ps_value), true)
		if isnull(lstr_patient_material.material_id) then return
		
		// see if the working file has already been created
		ll_working_file_index = 0
		for i = 1 to working_file_count
			if working_file[i].attribute = ps_attribute and working_file[i].value = ps_value then
				ll_working_file_index = i
				exit
			end if
		next
		if ll_working_file_index = 0 then
			openwithparm(w_pop_message, "Could not find working file")
			return
		end if
		
		openwithparm(w_pop_yes_no, "Are you sure you want to update this file?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		
		setnull(ls_url)
		
		li_sts = log.file_read2(working_file[i].working_file, lbl_new_file, false)
		if li_sts <= 0 then
			openwithparm(w_pop_message, "Could not open working file")
			return
		end if
		
		if lbl_new_file = lstr_patient_material.material_object then
			return
		end if
		
		lstr_patient_material.material_object = lbl_new_file
		li_sts = f_update_material(lstr_patient_material)
		if li_sts <= 0 then return
		
		ls_new_value = string(lstr_patient_material.material_id)
		
		// Now update the new material id in the table, the report object, and the local datawindow
		UPDATE c_Report_Attribute
		SET value = :ls_new_value
		WHERE report_id = :report.report_id
		AND attribute = :ps_attribute
		AND value = :ps_value;
		if not tf_check() then return
		
		report.add_attribute(ps_attribute, ls_new_value)
		
		dw_config_items.object.updated_flag[pl_row] = 0
		dw_config_items.object.value[pl_row] = ls_new_value
	CASE "xml script"
	CASE "rtf script"
END CHOOSE


return


end subroutine

public subroutine add_config_item (string ps_config_item_type, str_attribute pstr_attribute);long ll_row
string ls_description
str_display_script lstr_display_script
long ll_xml_script_id
long ll_display_script_id
long ll_material_id
integer li_sts
str_document_context_objects_info lstr_object_info


CHOOSE CASE lower(ps_config_item_type)
	CASE "document objects"
		li_sts = report_document.document_context_objects_info(lstr_object_info)
		if li_sts < 0 then
			ls_description = "Document Objects"
		elseif lstr_object_info.current_record_count > 0 then
			ls_description = "Document Objects (" + string(lstr_object_info.current_record_count) + ")"
		else
			ls_description = "Document Objects"
		end if
	CASE "local selection script"
		ls_description = "Object Selection SQL Script"
	CASE "selection script"
		ls_description = "Object Selection SQL Script"
	CASE "file"
		ll_material_id = long(pstr_attribute.value)
		
		if ll_material_id > 0 then
			SELECT title + ' (' + extension + ')'
			INTO :ls_description
			FROM c_Patient_Material
			WHERE material_id = :ll_material_id;
			if not tf_check() then return
			if sqlca.sqlcode = 100 then return
		else
			return
		end if
	CASE "xml script"
		ll_xml_script_id = long(pstr_attribute.value)
		if ll_xml_script_id > 0 then
			li_sts = datalist.display_script(ll_xml_script_id, lstr_display_script)
			if li_sts > 0 then
				ls_description = lstr_display_script.context_object + " " + lstr_display_script.description
			else
				return
			end if
		else
			return
		end if
	CASE "rtf script"
		ll_display_script_id = long(pstr_attribute.value)
		if ll_display_script_id > 0 then
			li_sts = datalist.display_script(ll_display_script_id, lstr_display_script)
			if li_sts > 0 then
				ls_description = lstr_display_script.context_object + " " + lstr_display_script.description
			else
				return
			end if
		else
			return
		end if
	CASE "field map"
		ls_description = "Document Field Map"
END CHOOSE

ll_row = dw_config_items.insertrow(0)
dw_config_items.object.description[ll_row] = ls_description
dw_config_items.object.config_item_type[ll_row] = ps_config_item_type
dw_config_items.object.attribute[ll_row] = pstr_attribute.attribute
dw_config_items.object.value[ll_row] = pstr_attribute.value
dw_config_items.object.attribute_sequence[ll_row] = pstr_attribute.attribute_sequence
dw_config_items.object.component_id[ll_row] = pstr_attribute.component_id


return


end subroutine

public function integer get_document_elements ();integer li_sts

document_elements_available = false

li_sts = report_document.get_document_elements(document_elements)
if li_sts < 0 then
	log.log(this, "w_report_configure_and_test.get_document_elements:0007", "Error configuring document component (" + report.report_id + ")", 4)
	return -1
end if

if document_elements.element_set_count > 0 then
	document_elements_available = true
end if

return 1

end function

public function integer initialize_from_document (u_component_wp_item_document puo_document);str_popup popup
string ls_component_id
string ls_report_id
str_attributes lstr_attributes

wp_item_document = puo_document

ls_report_id = puo_document.get_attribute("report_id")
if isnull(ls_report_id) then
	log.log(this, "w_report_configure_and_test.initialize_from_document:0010", "Null report_id", 4)
	Return -1
end if

f_attribute_add_attribute(lstr_attributes, "document_patient_workplan_item_id", string(wp_item_document.patient_workplan_item_id))

// Get the component_id and the SQL query
SELECT component_id
INTO :ls_component_id
FROM c_Report_Definition
WHERE report_id = :ls_report_id;
If Not tf_check() Then Return -1

// If any component defined for selected report then
If Isnull(ls_component_id) Then
	log.log(this, "w_report_configure_and_test.initialize_from_document:0025", "Null component_id (" + ls_report_id + ")", 4)
	Return -1
end if

report = component_manager.get_component(ls_component_id, lstr_attributes)
If Isnull(report) Then
	log.log(This, "w_report_configure_and_test.initialize_from_document:0031", "Error getting report component (" + &
				ls_component_id + ")", 4)
	Return -1
End If

// Set the report_id property
report.report_id = ls_report_id

// Get the report attributes from the tables
report.get_report_attributes(gnv_app.office_id)

// runtime attributes
report_runtime_attributes.attribute_count = 0


return 1

end function

public function str_attributes report_runtime_attributes ();str_attributes lstr_attributes

lstr_attributes = report_runtime_attributes

if not isnull(wp_item_document) then
	f_attribute_add_attributes(lstr_attributes, wp_item_document.get_attributes())

	f_attribute_add_attribute(lstr_attributes, "DESTINATION", "SCREEN")

	// Inform the report and all of it's called object of which workplan item is triggering this document creation
	f_attribute_add_attribute(lstr_attributes, "document_patient_workplan_item_id", string(wp_item_document.patient_workplan_item_id))
	
	// Add some properties of the document to the report attributes
	f_attribute_add_attribute(lstr_attributes, "Document ordered_for", wp_item_document.ordered_for)
end if

return lstr_attributes





end function

public subroutine edit_item (string ps_config_item_type, string ps_attribute, string ps_value, string ps_description, long pl_attribute_sequence, string ps_component_id);long ll_row
str_popup_return popup_return
str_popup popup
str_display_script lstr_display_script
long ll_xml_script_id
long ll_display_script_id
long ll_material_id
integer li_sts
w_window_base lw_edit_window
long ll_working_file_index
long i, j
str_patient_material lstr_patient_material
string ls_temp_filename
string ls_suffix
blob lbl_mapping
str_document_element_context lstr_document_element_context
str_document_elements lstr_document_elements
str_document_elements lstr_document_element_mappings
string ls_mappings
long ll_mapping_item_count
string lsa_mapping_item[]
string ls_property
string ls_element
string ls_beginning
string ls_value
w_window_base lw_window
long ll_set1
long ll_set2
blob lbl_attribute_value
long ll_choice
boolean lb_local_selection_script

CHOOSE CASE lower(ps_config_item_type)
	CASE "document objects"
		document_objects_menu()
	CASE "local selection script"
		popup.title = "Edit SQL for " + ps_description
		popup.item = ps_value
		openwithparm(w_pop_edit_string_multiline, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		
		wp_item_document.set_attribute( ps_attribute, popup_return.items[1])
	CASE "selection script"
		popup.title = "Edit SQL for " + ps_description
		popup.item = ps_value
		openwithparm(w_pop_edit_string_multiline, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		
		// See if there is already a document selection script
		ll_row = dw_config_items.find("lower(config_item_type)='local selection script'", 1, dw_config_items.rowcount())
		if ll_row > 0 then
			lb_local_selection_script = true
		else
			lb_local_selection_script = false
		end if
		
		if ps_value <> popup_return.items[1] and not lb_local_selection_script and not isnull(wp_item_document) then
			popup.data_row_count = 2
			popup.title = "Do you wish to ..."
			popup.items[1] = "Update the " + lower(report.config_object_type) + " definition"
			popup.items[2] = "Use SQL script only for this document instance"
			openwithparm(w_pop_choices_2, popup)
			ll_choice = message.doubleparm
			
			if ll_choice = 2 then
				wp_item_document.set_attribute( ps_attribute, popup_return.items[1])
				return
			end if
		end if
		
		report.set_report_attribute(ps_attribute, popup_return.items[1], ps_component_id)
	CASE "file"
		ll_material_id = long(ps_value)
		
		// see if the working file has already been created
		ll_working_file_index = 0
		for i = 1 to working_file_count
			if working_file[i].attribute = ps_attribute and working_file[i].value = ps_value then
				ll_working_file_index = i
				exit
			end if
		next
		if ll_working_file_index = 0 then
			ll_working_file_index = working_file_count + 1
			
			working_file[ll_working_file_index].attribute = ps_attribute
			working_file[ll_working_file_index].value = ps_value
			working_file[ll_working_file_index].material = f_get_patient_material(ll_material_id, true)
			if isnull(working_file[ll_working_file_index].material.material_id) then return
			
			if upper(working_file[ll_working_file_index].material.extension) = "URL" then
				openwithparm(w_pop_message, "You cannot edit a URL")
				return
			end if
			working_file_count = ll_working_file_index
		end if
		
		for i = 1 to 1000
			if i = 1 then
				ls_suffix = ""
			else
				ls_suffix = "_" + string(i)
			end if
			ls_temp_filename = test_directory + f_string_to_filename(ps_description) + ls_suffix + "." + working_file[ll_working_file_index].material.extension
			if not fileexists(ls_temp_filename) then exit
		next
		
		li_sts = log.file_write(working_file[ll_working_file_index].material.material_object , ls_temp_filename)
		if li_sts <= 0 then return

		// Record the working file and its current file attributes
		working_file[ll_working_file_index].working_file = ls_temp_filename
		log.file_attributes(working_file[ll_working_file_index].working_file, working_file[ll_working_file_index].working_file_attributes)

		f_open_file_with_process(working_file[ll_working_file_index].working_file, "edit", false, working_file[ll_working_file_index].process_id)
		
		timer(2)
	CASE "xml script"
		ll_xml_script_id = long(ps_value)

		popup.data_row_count = 3
		popup.items[1] = string(ll_xml_script_id)
		popup.items[2] = "true"
		popup.items[3] = report.report_id
		
		openwithparm(lw_edit_window, popup, "w_display_script_config")
	CASE "rtf script"
		ll_display_script_id = long(ps_value)

		popup.data_row_count = 3
		popup.items[1] = string(ll_display_script_id)
		popup.items[2] = "true"
		popup.items[3] = report.report_id
		
		openwithparm(lw_edit_window, popup, "w_display_script_config")
	CASE "field map"
		// Make a copy of the document elements
		lstr_document_elements = document_elements
			
		if pl_attribute_sequence > 0 then
			// We already have some mappings so get them and populate the mapped_property field in a copy of the elements structure
			SELECTBLOB objectdata
			INTO :lbl_mapping
			FROM c_Report_Attribute
			WHERE report_id = :report.report_id
			AND attribute_sequence = :pl_attribute_sequence;
			if not tf_check() then return
			
			ls_mappings = f_blob_to_string(lbl_mapping)
			
			// See if it's XML data
			ls_beginning = left(trim(ls_mappings), 8)
			if pos(ls_beginning, "<") > 0 and (pos(ls_mappings, "</") > 0 or pos(ls_mappings, "/>") > 0) then
				// Convert the previous mapping to structures
				li_sts = f_get_document_elements_from_xml(ls_mappings, lstr_document_element_mappings)
				if li_sts < 0 then
					openwithparm(w_pop_message, "Unable to read previous mappings")
				else
					// Transfer any previous mappings to the new mapping
					for ll_set1 = 1 to lstr_document_element_mappings.element_set_count
						for ll_set2 = 1 to lstr_document_elements.element_set_count
							// Transfer the mapping only if the element set name matches
							if lower(lstr_document_element_mappings.element_set[ll_set1].description) = lower(lstr_document_elements.element_set[ll_set2].description) then
								lstr_document_elements.element_set[ll_set2].maptocollection = lstr_document_element_mappings.element_set[ll_set1].maptocollection
								lstr_document_elements.element_set[ll_set2].maptocollectiontype = lstr_document_element_mappings.element_set[ll_set1].maptocollectiontype
								lstr_document_elements.element_set[ll_set2].collectiondefinition = lstr_document_element_mappings.element_set[ll_set1].collectiondefinition
								for i = 1 to lstr_document_element_mappings.element_set[ll_set1].element_count
									for j = 1 to lstr_document_elements.element_set[ll_set2].element_count
										if lower(lstr_document_elements.element_set[ll_set2].element[j].element) = lower(lstr_document_element_mappings.element_set[ll_set1].element[i].element) then
											lstr_document_elements.element_set[ll_set2].element[j].mapped_property_count = lstr_document_element_mappings.element_set[ll_set1].element[i].mapped_property_count
											lstr_document_elements.element_set[ll_set2].element[j].mapped_property = lstr_document_element_mappings.element_set[ll_set1].element[i].mapped_property
										end if
									next
								next
							end if
						next
					next
				end if
			end if
		end if
		
		// Call the mapping screen and pass in the document elements
		lstr_document_element_context.document_elements = lstr_document_elements
		lstr_document_element_context.context = f_get_complete_context()
		lstr_document_element_context.attributes = report_runtime_attributes()
		openwithparm(lw_window, lstr_document_element_context, "w_document_element_mapping_edit")
		lstr_document_elements = message.powerobjectparm
		
		// Construct the new mapping XML document
		ls_mappings = f_get_document_elements_xml(lstr_document_elements)
		
		if len(ls_mappings) > 0 then
			lbl_mapping = blob(ls_mappings)
			ls_value = left(ls_mappings, 255)
			
			// Save the new mapping string
			if isnull(pl_attribute_sequence) then
				INSERT INTO c_Report_Attribute (
					report_id,
					attribute,
					value)
				VALUES (
					:report.report_id,
					'document_field_map',
					:ls_value);
				if not tf_check() then return
				
				SELECT scope_identity()
				INTO :pl_attribute_sequence
				FROM c_1_record;
				if not tf_check() then return
			end if
	
			UPDATE c_Report_Attribute
			SET value = :ls_value
			WHERE report_id = :report.report_id
			AND attribute_sequence = :pl_attribute_sequence;
			if not tf_check() then return

			UPDATEBLOB c_Report_Attribute
			SET objectdata = :lbl_mapping
			WHERE report_id = :report.report_id
			AND attribute_sequence = :pl_attribute_sequence;
			if not tf_check() then return
		end if		
END CHOOSE


return


end subroutine

public subroutine document_objects_menu ();String		lsa_buttons[]
String 		ls_drug_id
String 		ls_description,ls_null
String		ls_top_20_code
Integer		li_sts, li_service_count
Long			ll_null
string ls_property
string ls_literal
long ll_button_pressed
str_document_context_objects_info lstr_object_info

window 				lw_pop_buttons
str_popup 			popup
str_popup 			popup2
str_popup_return 	popup_return

Setnull(ls_null)
Setnull(ll_null)

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_wrench.bmp"
	popup.button_helps[popup.button_count] = "Clear Document Objects"
	popup.button_titles[popup.button_count] = "Clear Document Objects"
	lsa_buttons[popup.button_count] = "CLEAR"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_wrench.bmp"
	popup.button_helps[popup.button_count] = "Execute Document Selection Query"
	popup.button_titles[popup.button_count] = "Execute Query"
	lsa_buttons[popup.button_count] = "EXECUTE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_wrench.bmp"
	popup.button_helps[popup.button_count] = "View Document Objects Query"
	popup.button_titles[popup.button_count] = "View Query" 
	lsa_buttons[popup.button_count] = "VIEWQUERY"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_wrench.bmp"
	popup.button_helps[popup.button_count] = "View Document Objects"
	popup.button_titles[popup.button_count] = "View Objects"
	lsa_buttons[popup.button_count] = "VIEW"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	lsa_buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	ll_button_pressed = message.doubleparm
	if ll_button_pressed < 1 or ll_button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	ll_button_pressed = 1
else
	return
end if

CHOOSE CASE lsa_buttons[ll_button_pressed]
	CASE "CLEAR"
		report_document.clear_document_context_objects()
	CASE "EXECUTE"
		TRY
			report_document.set_document_context_objects()
		CATCH (exception le_error)
			openwithparm(w_pop_message, "Error executing document selection query: " + le_error.text)
		END TRY
	CASE "VIEWQUERY"
		li_sts = report_document.document_context_objects_info(lstr_object_info)
		popup.title = "Document Objects SQL Query"
		popup.item = lstr_object_info.selection_script_substituted
		popup.display_only = true
		openwithparm(w_pop_edit_string_multiline, popup)
	CASE "VIEW"
		popup.title = "Document Objects"
		popup.dataobject = "dw_document_objects_display"
		popup.argument_count = 1
		popup.numeric_argument = true
		popup.argument[1] = string(wp_item_document.patient_workplan_item_id)
		openwithparm(w_pop_display_datawindow, popup)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

Return

end subroutine

event open;call super::open;string ls_temp
str_popup popup
string ls_report_id
string ls_document_component_class
string ls_classname
integer li_sts

ls_classname = message.powerobjectparm.classname()

CHOOSE CASE lower(ls_classname)
	CASE "str_popup"
		popup = message.powerobjectparm
		
		report = popup.objectparm1
		report_runtime_attributes = popup.objectparm2
		
		cb_document_properties.visible = false
		cb_report_runtime.visible = false
		setnull(wp_item_document)
	CASE "u_component_wp_item_document"
		li_sts = initialize_from_document(message.powerobjectparm)
		if li_sts < 0 then
			log.log(this, "w_report_configure_and_test:open", "Error initializing from document", 4)
			close(this)
			return
		end if
		
		cb_document_properties.visible = true
		cb_report_runtime.visible = true
	CASE ELSE
		log.log(this, "w_report_configure_and_test:open", "Invalid caller class (" + ls_classname + ")", 4)
		close(this)
		return
END CHOOSE

//document_patient_workplan_item_id = long(f_attribute_find_attribute(report_attributes, "document_patient_workplan_item_id"))
st_report_title.text = wordcap(report.config_object_type) + ":"
st_title.text = "Configure and Test " + wordcap(report.config_object_type)

ls_report_id = report.report_id
if left(ls_report_id, 1) = "{" then
	ls_report_id = mid(ls_report_id, 2)
end if
if right(ls_report_id, 1) = "}" then
	ls_report_id = left(ls_report_id, len(ls_report_id) - 1)
end if

test_directory = temp_path
if right(test_directory, 1) <> "\" then test_directory += "\"

test_directory += ls_report_id + "\"

if not directoryexists(test_directory) then
	createdirectory(test_directory)
end if

cb_test_file.visible = false

refresh()


end event

on w_report_configure_and_test.create
int iCurrent
call super::create
this.st_title=create st_title
this.cb_run_report=create cb_run_report
this.cb_exit=create cb_exit
this.cb_configure_report=create cb_configure_report
this.dw_config_items=create dw_config_items
this.st_1=create st_1
this.cb_configure_document=create cb_configure_document
this.cb_test_file=create cb_test_file
this.cb_document_properties=create cb_document_properties
this.cb_report_runtime=create cb_report_runtime
this.st_report_title=create st_report_title
this.st_report_document_title=create st_report_document_title
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.cb_run_report
this.Control[iCurrent+3]=this.cb_exit
this.Control[iCurrent+4]=this.cb_configure_report
this.Control[iCurrent+5]=this.dw_config_items
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.cb_configure_document
this.Control[iCurrent+8]=this.cb_test_file
this.Control[iCurrent+9]=this.cb_document_properties
this.Control[iCurrent+10]=this.cb_report_runtime
this.Control[iCurrent+11]=this.st_report_title
this.Control[iCurrent+12]=this.st_report_document_title
this.Control[iCurrent+13]=this.st_2
end on

on w_report_configure_and_test.destroy
call super::destroy
destroy(this.st_title)
destroy(this.cb_run_report)
destroy(this.cb_exit)
destroy(this.cb_configure_report)
destroy(this.dw_config_items)
destroy(this.st_1)
destroy(this.cb_configure_document)
destroy(this.cb_test_file)
destroy(this.cb_document_properties)
destroy(this.cb_report_runtime)
destroy(this.st_report_title)
destroy(this.st_report_document_title)
destroy(this.st_2)
end on

event timer;call super::timer;str_file_attributes lstr_file
integer li_sts
datetime ldt_created
datetime ldt_updated
long i, j
long ll_rowcount
string ls_attribute
string ls_value

for i = 1 to working_file_count
	if not fileexists(working_file[i].working_file) then continue
	
	li_sts = log.file_attributes(working_file[i].working_file, lstr_file)
	if li_sts <= 0 then return
	
	// Compare the updated datetime with one second past the original datetime.
	ldt_created = datetime(working_file[i].working_file_attributes.lastwritedate, relativetime(working_file[i].working_file_attributes.lastwritetime, 1))
	ldt_updated = datetime(lstr_file.lastwritedate, lstr_file.lastwritetime)
	
	if ldt_updated > ldt_created then
//		filecopy(working_file, display_file, true)
		// If the working file has been updated then set the dw flag
		ll_rowcount = dw_config_items.rowcount()
		for j = 1 to ll_rowcount
			ls_attribute = dw_config_items.object.attribute[j]
			ls_value = dw_config_items.object.value[j]
			if ls_attribute = working_file[i].attribute and ls_value =  working_file[i].value then
				dw_config_items.object.updated_flag[j] = 1
				exit
			end if
		next
		working_file[i].working_file_updated = true
		working_file[i].working_file_attributes = lstr_file
		
		get_document_elements()
	end if
next	

end event

type pb_epro_help from w_window_base`pb_epro_help within w_report_configure_and_test
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_report_configure_and_test
end type

type st_title from statictext within w_report_configure_and_test
integer width = 2587
integer height = 88
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Configure and Test Report"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_run_report from commandbutton within w_report_configure_and_test
integer x = 1861
integer y = 1152
integer width = 507
integer height = 88
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Run"
end type

event clicked;integer li_sts

li_sts = report.printreport(report.report_id, report_runtime_attributes())


end event

type cb_exit from commandbutton within w_report_configure_and_test
integer x = 2126
integer y = 1376
integer width = 407
integer height = 108
integer taborder = 30
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Exit"
end type

event clicked;close(parent)


end event

type cb_configure_report from commandbutton within w_report_configure_and_test
integer x = 654
integer y = 1152
integer width = 521
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Configure"
end type

event clicked;str_service_info lstr_service

SELECT configuration_service
INTO :lstr_service.service
FROM c_Config_Object_Type
WHERE config_object_type = :report.config_object_type;
if not tf_check() then return -1

f_attribute_add_attribute(lstr_service.attributes, "config_object_id", report.report_id)

service_list.do_service(lstr_service)

get_document_elements()

refresh()

end event

type dw_config_items from u_dw_pick_list within w_report_configure_and_test
integer x = 50
integer y = 212
integer width = 2505
integer height = 908
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_report_config_item"
boolean border = false
end type

event buttonclicked;call super::buttonclicked;string ls_config_item_type
string ls_value
string ls_attribute
string ls_description
long ll_attribute_sequence
string ls_component_id

ls_config_item_type = object.config_item_type[row]
ls_attribute = object.attribute[row]
ls_value = object.value[row]
ls_description = object.description[row]
ll_attribute_sequence = object.attribute_sequence[row]
ls_component_id = object.component_id[row]

if lower(dwo.name) = "b_edit" then
	edit_item(ls_config_item_type, ls_attribute, ls_value, ls_description, ll_attribute_sequence, ls_component_id)
elseif lower(dwo.name) = "b_test" then
	test_item(ls_config_item_type, ls_attribute, ls_value, ls_description)
elseif lower(dwo.name) = "b_update" then
	update_item(row, ls_config_item_type, ls_attribute, ls_value, ls_description)
end if

refresh()

end event

type st_1 from statictext within w_report_configure_and_test
integer y = 144
integer width = 2587
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Edit Config Item"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_configure_document from commandbutton within w_report_configure_and_test
integer x = 654
integer y = 1268
integer width = 521
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Configure"
end type

event clicked;integer li_sts

li_sts = report_document.configure_document()
if li_sts < 0 then
	log.log(this, "w_report_configure_and_test.cb_configure_document.clicked:0005", "Error configuring document component (" + report.report_id + ")", 4)
	return -1
end if

get_document_elements()

refresh()

return 1

end event

type cb_test_file from commandbutton within w_report_configure_and_test
integer x = 1211
integer y = 1268
integer width = 613
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generate Test File"
end type

event clicked;integer li_sts
string ls_filename
string ls_message
str_popup_return popup_return

ls_filename = report_document.get_test_case()

if isnull(ls_filename) then
	openwithparm(w_pop_message, "Generating test case failed")
	return
end if

if not fileexists(ls_filename) then
	openwithparm(w_pop_message, "Generating test case failed")
	return
end if

clipboard(ls_filename)

ls_message = "Test case generation successful.  Test case file location is ~"" + ls_filename + "~" and has been placed on the clipboard."
ls_message += "  Do you want to open the test case now?"
openwithparm(w_pop_yes_no, ls_message)
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

f_open_file(ls_filename, false)


return 1

end event

type cb_document_properties from commandbutton within w_report_configure_and_test
integer x = 654
integer y = 1384
integer width = 521
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Properties"
end type

event clicked;w_window_base lw_window

openwithparm(lw_window, wp_item_document.patient_workplan_item_id, "w_document_properties")

refresh()

end event

type cb_report_runtime from commandbutton within w_report_configure_and_test
integer x = 1211
integer y = 1152
integer width = 613
integer height = 88
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Runtime Params"
end type

event clicked;integer li_sts
str_attributes lstr_attributes
long i

lstr_attributes = wp_item_document.get_attributes()

li_sts = f_get_params(report.report_id, "Runtime", lstr_attributes)
if li_sts < 0 then return

for i = 1 to lstr_attributes.attribute_count
	wp_item_document.set_attribute(lstr_attributes.attribute[i].attribute, lstr_attributes.attribute[i].value)
next


end event

type st_report_title from statictext within w_report_configure_and_test
integer x = 14
integer y = 1160
integer width = 622
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Report:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_report_document_title from statictext within w_report_configure_and_test
integer x = 14
integer y = 1276
integer width = 622
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Engine:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_report_configure_and_test
integer x = 14
integer y = 1392
integer width = 622
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Document WP Item:"
alignment alignment = right!
boolean focusrectangle = false
end type

