$PBExportHeader$u_component_report.sru
forward
global type u_component_report from u_component_base_class
end type
end forward

global type u_component_report from u_component_base_class
end type
global u_component_report u_component_report

type variables
string report_id
long printer_resolution_x
long printer_resolution_y
u_ds_report report_datastore
u_rich_text_edit rtf
string report_type = "DW"
string report_object

// Report Properties
string sql

pointer oldpointer

string description

private string report_printer

str_external_observation_attachment document_file

str_complete_context report_context

string config_object_type

long printreport_status

end variables

forward prototypes
public function boolean xx_displayable ()
public function boolean xx_printable ()
public subroutine substitute_tokens (ref string ps_string)
public function integer setupreport (string ps_report_id)
protected function integer xx_setupreport ()
public function integer xx_printreport ()
public function integer apply_dw_attributes (u_ds_report pds_datastore)
public function integer printreport (string ps_report_id, str_attributes pstr_attributes)
protected function integer print_datastore ()
protected function integer base_initialize ()
public function integer xx_document_create ()
public function integer get_report_attributes (string ps_office_id)
public function integer set_report_attribute (string ps_attribute, string ps_value, string ps_component_id)
public function integer apply_dw_attribute (u_ds_report pds_datastore, string ps_attribute, string ps_value)
public function integer document_cancel_old ()
public function integer document_confirm_receipt_old ()
public function integer document_create_old ()
public function integer document_send_old ()
public function integer document_view_old ()
public function u_component_document document_component ()
end prototypes

public function boolean xx_displayable ();//////////////////////////////////////////////////////////////////////////////////////
//
//	Return: boolean 
//
//	Description: Check whether the report can be generated local
// returns 'True' if report can be generated local and 'False' if not.
//
// Created By:Sumathi Chinnasamy										Creation dt: 10/12/99
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////
boolean lb_displayable

If ole_class Then
	string ls_error
	TRY
		lb_displayable = ole.is_displayable()
	CATCH (throwable lo_error)
		ls_error = "Error determining if report is displayable"
		if not isnull(lo_error.text) then
			ls_error += " (" + lo_error.text + ")"
		end if
		log.log(this, "u_component_report.xx_displayable:0023", ls_error, 4)
		lb_displayable = false
	END TRY
	
	return lb_displayable
Else
	// since no display functionality in all report decendent class for patient and 
	// encounter reports, right now this option is always set to false
	Return true
End if

end function

public function boolean xx_printable ();//////////////////////////////////////////////////////////////////////////////////////
//
//	Return: boolean 
//
//	Description: Check whether the report can be printed local
// returns 'True' if report can be generated local and 'False' if not.
//
// Created By:Sumathi Chinnasamy										Creation dt: 10/12/99
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////
boolean lb_printable

If ole_class Then
	string ls_error
	TRY
		lb_printable = ole.is_printable()
	CATCH (throwable lo_error)
		ls_error = "Error determining if report is displayable"
		if not isnull(lo_error.text) then
			ls_error += " (" + lo_error.text + ")"
		end if
		log.log(this, "u_component_report.xx_printable:0023", ls_error, 4)
		lb_printable = false
	END TRY
	
	return lb_printable
Else
	Return true
End If
end function

public subroutine substitute_tokens (ref string ps_string);integer i
str_attributes lstr_attributes

lstr_attributes = get_attributes()

// We define a token as an attribute at least three bytes long and starting and ending with "%"

for i = 1 to lstr_attributes.attribute_count
	if left(lstr_attributes.attribute[i].attribute, 1) = "%" and right(lstr_attributes.attribute[i].attribute, 1) = "%" and len(lstr_attributes.attribute[i].attribute) >= 3 then
		ps_string = f_string_substitute(ps_string, lstr_attributes.attribute[i].attribute, lstr_attributes.attribute[i].value)
	end if
next

ps_string = f_attribute_value_substitute_string(ps_string, f_get_complete_context_from_attributes(lstr_attributes), lstr_attributes)


end subroutine

public function integer setupreport (string ps_report_id);// Date Begun: ??/??/??
// Programmer: Mark Copenhaver (MC)
//
// Purpose: 
// Expects: string	ps_report_id				uniquely identifies report
// Returns: integer 									
// Limits:	
// History: 07/02/98 - MSC - Created

report_id = ps_report_id

return xx_setupreport()

end function

protected function integer xx_setupreport ();// Date Begun: ??/??/??
// Programmer: Mark Copenhaver (MC)
//
// Purpose: 
// Expects: 
// Returns: integer 									
// Limits:	
// History: 07/02/98 - MSC - Created
u_ds_data luo_attributes
integer li_sts
integer i
string ls_temp
str_attributes lstr_attributes

if ole_class then
	return ole.setupreport(report_id)
end if

luo_attributes = CREATE u_ds_data
luo_attributes.set_dataobject("dw_report_attribute")
luo_attributes.retrieve(report_id)

f_attribute_ds_to_str(luo_attributes, lstr_attributes)

li_sts = f_get_params(report_id, "Config", lstr_attributes)
if li_sts < 0 then return li_sts

f_attribute_str_to_ds(lstr_attributes, luo_attributes)

// set the report_id for new attributes
for i = 1 to luo_attributes.rowcount()
	ls_temp = luo_attributes.object.report_id[i]
	if isnull(ls_temp) then
		luo_attributes.object.report_id[i] = report_id
		luo_attributes.object.attribute_sequence[i] = i
	end if
next

li_sts = luo_attributes.update()
if li_sts <= 0 then return li_sts

DESTROY luo_attributes

Return 1

end function

public function integer xx_printreport ();// Date Begun: ??/??/??
// Programmer: Mark Copenhaver (MC)
//				   Charles Appel (CA)
// Purpose: 
// Expects: string	ps_report_id				uniquely identifies report
//				long		pi_attribute_count		number of attributes
//    		string	psa_attributes[]			Array of attributes
//				string	psa_values[]				Array of attribute values
// Returns: integer 									
// Limits:	
// History: 07/02/98 - MSC - Created

integer i
string lsa_attributes[]
string lsa_values[]
integer li_count
integer li_sts
str_attributes lstr_attributes

li_sts = common_thread.get_adodb(adodb)
if li_sts <= 0 then
	mylog.log(this, "u_component_report.xx_printreport:0022", "Unable to establish ADO Connection", 4)
	return -1
end if

lstr_attributes = get_attributes()

if sqlca.is_approle_set then
	f_attribute_add_attribute(lstr_attributes, "data_where", sqlca.sys(sqlca.application_role))
end if

li_count = f_attribute_str_to_arrays(lstr_attributes, lsa_attributes, lsa_values)

if ole_class then
	string ls_error
	TRY
		li_sts = ole.printreport(report_id, adodb, li_count, lsa_attributes, lsa_values)
	CATCH (oleruntimeerror lo_error)
		ls_error = "Error printing report"
		if not isnull(lo_error.text) then
			ls_error += " (" + lo_error.text + " : " + lo_error.description + ")"
		end if
		log.log(this, "u_component_report.xx_printreport:0043", ls_error, 4)
		li_sts = -1
	END TRY
	
	return li_sts
else
	return 100
end if

end function

public function integer apply_dw_attributes (u_ds_report pds_datastore);long i
string lsa_attributes[]
string lsa_values[]
long ll_count
string ls_destination
string ls_extension

ll_count = get_attributes(lsa_attributes, lsa_values)

for i = 1 to ll_count
	apply_dw_attribute(pds_datastore, lsa_attributes[i], lsa_values[i])
next

// If the destination is a pdf file then we need to apply all the "pdf." attributes AFTER all the other attributes are applied
ls_destination = upper(get_attribute("destination"))
ls_extension = upper(get_attribute("extension"))
if isnull(ls_extension) then ls_extension = "PDF"

if ls_destination = "FILE" and ls_extension = "PDF" then
	for i = 1 to ll_count
		if lower(left(lsa_attributes[i], 4)) = "pdf." then
			apply_dw_attribute(pds_datastore, mid(lsa_attributes[i], 5), lsa_values[i])
		end if
	next
end if

return 1

end function

public function integer printreport (string ps_report_id, str_attributes pstr_attributes);// Date Begun: ??/??/??
// Programmer: Mark Copenhaver (MC)
//				   Charles Appel (CA)
// Purpose: 
// Expects: string	ps_report_id				uniquely identifies report
//				long		pi_attribute_count		number of attributes
//    		string	psa_attributes[]			Array of attributes
//				string	psa_values[]				Array of attribute values
// Returns: integer 									
// Limits:	
// History: 07/02/98 - MSC - Created
integer li_sts
boolean lb_nested
boolean lb_please_wait
str_printer lstr_current_printer
string ls_report_office_id
str_attributes lstr_attributes
u_ds_data	report_attributes
//w_encounterpro_report_rtf lw_rtf
boolean lb_mypatient
string ls_cpr_id
boolean lb_my_printer
string ls_destination

report_id = ps_report_id
if isnull(report_id) then
	mylog.log(this, "u_component_report.printreport:0027", "Report not found (" + ps_report_id + ")", 4)
	printreport_status = -1  // Yuck!  PowerBuilder is sometimes losing the return status so lets set an instance variable as a backup
	return -1
end if

// See if an office_id attribute was passed in
ls_report_office_id = f_attribute_find_attribute(pstr_attributes, "office_id")
if isnull(ls_report_office_id) then ls_report_office_id = office_id

// Get the report attributes from the tables
get_report_attributes(ls_report_office_id)


// Add the context attributes
add_context_attributes()

// Add the passed in attributes
add_attributes(pstr_attributes)

li_sts = 1
lb_nested = false

// If the report is a decendent class then display a "Please Wait" window.
if not ole_class then
	if mylog.display_enabled then
		oldpointer = SetPointer(HourGlass!)
		if isvalid(w_pop_please_wait) then
			lb_please_wait = false
		else
			open(w_pop_please_wait)
			lb_please_wait = true
		end if
	end if
	report_datastore = CREATE u_ds_report
end if

if li_sts > 0 then
	ls_destination = get_attribute("DESTINATION")
	if isnull(ls_destination) then ls_destination = "Printer"
	
	lb_my_printer = false
	
	if lower(ls_destination) = "printer" then
		// Set the printer to the desired printer
		report_printer = get_attribute("printer")
		if len(report_printer) > 0 then
			if common_thread.is_printer_available_on_client(report_printer) and report_printer <> common_thread.current_printer() then
				common_thread.set_printer(report_printer)
				lb_my_printer = true
			end if
		end if
	end if
	
	// Do we need a patient_context?
	lb_mypatient = false
	get_attribute("cpr_id", ls_cpr_id)
	if isnull(current_patient) and not isnull(ls_cpr_id) then
		lb_mypatient = true
		f_set_patient(ls_cpr_id)
	end if
	
	// Print the report
	TRY
		li_sts = 0
		li_sts = xx_printreport()
		if li_sts = 0 then li_sts = printreport_status  //  Yuck.  This is needed because sometimes PowerBuilder isn't passing back the return status from xx_printreport()
	CATCH (throwable le_error)
		log.log(this, "u_component_report.printreport:0094", "Error printing report (" + le_error.text + ")", 3)
		li_sts = -1
	END TRY
	
	if lb_my_printer then
		// Set the printer back to the default
		common_thread.set_default_printer()
	end if
	
	if lb_mypatient then
		f_clear_patient()
	end if
end if

// Clean up
if not ole_class then
	if mylog.display_enabled then
		if isvalid(w_pop_please_wait) and lb_please_wait then close(w_pop_please_wait)
		if not isnull(oldpointer) then SetPointer(oldpointer)
	end if
	DESTROY report_datastore
end if
Destroy report_attributes

printreport_status = li_sts
return li_sts

end function

protected function integer print_datastore ();string ls_path
string ls_destination
str_popup popup
integer li_sts
string ls_message
string ls_office_id
saveastype le_saveastype
boolean lb_column_headings

apply_dw_attributes(report_datastore)

ls_destination = upper(get_attribute("DESTINATION"))

if ls_destination = "SCREEN" then
	openwithparm(w_encounterpro_report, this)
elseif ls_destination = "FILE" then
	get_attribute("extension", document_file.extension)
	if isnull(document_file.extension) then document_file.extension = "pdf"

	ls_path = f_temp_file(document_file.extension)
	lb_column_headings = true
	
	CHOOSE CASE lower(document_file.extension)
		CASE "xls"
			le_saveastype = Excel!
		CASE "txt"
			le_saveastype = Text!
		CASE "wks"
			le_saveastype = WKS!
		CASE "sql"
			le_saveastype = sqlinsert!
		CASE "psr"
			le_saveastype = PSReport!
		CASE "wmf"
			le_saveastype = WMF!
		CASE "htm", "html"
			le_saveastype = HTMLTable!
		CASE "xml"
			le_saveastype = XML!
			lb_column_headings = false
		CASE "xslfo"
			le_saveastype = XSLFO!
		CASE "pdf"
			le_saveastype = PDF!
			lb_column_headings = false
		CASE ELSE
			log.log(this, "u_component_report.print_datastore:0047", "Invalid save-as extension (" + document_file.extension + ")", 4)
			setnull(document_file.attachment)
			return -1
	END CHOOSE

	li_sts = report_datastore.saveas(ls_path, le_saveastype, lb_column_headings)
	if li_sts <= 0 then
		log.log(this, "u_component_report.print_datastore:0054", "Save to file failed (" + ls_path + ")", 4)
		setnull(document_file.attachment)
		return -1
	end if
	
	li_sts = log.file_read(ls_path, document_file.attachment)
	if li_sts <= 0 then
		log.log(this, "u_component_report.print_datastore:0061", "Error reading file (" + ls_path + ")", 4)
		setnull(document_file.attachment)
		return -1
	end if
	
	document_file.attachment_type = f_attachment_type_from_object_type(document_file.extension)
	setnull(document_file.filename)
	setnull(document_file.attachment_comment)
	document_file.attachment_comment_title = description
	
	return 1
else
	ls_message = "Report_id = " + report_id
	
	ls_message += "~nPrinter = "
	ls_message += common_thread.current_printer()
	
	ls_message += "~nOffice_id = "
	ls_office_id = get_attribute("office_id")
	if isnull(ls_office_id) then
		ls_message += "<None>"
	else
		ls_message += ls_office_id
	end if

	
	log.log_db(this, "u_component_report.print_datastore:0087", "Print Command Starting~n" + ls_message, 2)
	li_sts = report_datastore.print(false)
	if li_sts <= 0 then
		log.log(this, "u_component_report.print_datastore:0090", "Print Command Failed~n" + ls_message, 4)
		return -1
	else
		log.log_db(this, "u_component_report.print_datastore:0093", "Print Command Succeeded~n" + ls_message, 2)
	end if
end if

return 1

end function

protected function integer base_initialize ();string ls_error

TRY
	printer_resolution_x = common_thread.mm.printer_resolution_x()
	printer_resolution_y = common_thread.mm.printer_resolution_y()
CATCH (throwable lo_error)
	ls_error = "Error getting printer resolution"
	if not isnull(lo_error.text) then
		ls_error += " (" + lo_error.text + ")"
	end if
	log.log(this, "u_component_report.base_initialize:0011", ls_error, 4)
END TRY


return 1

end function

public function integer xx_document_create ();

return 1


end function

public function integer get_report_attributes (string ps_office_id);str_attributes lstr_attributes
u_ds_data	report_attributes
long i
blob lbl_value
string ls_attribute
long ll_attribute_sequence
long ll_count

SELECT description, sql, report_type, config_object_type
INTO :description, :sql, :report_object, :config_object_type
FROM c_Report_Definition
WHERE report_id = :report_id
USING cprdb;
if not tf_check() then return -1
if cprdb.sqlcode = 100 then
	mylog.log(this, "u_component_report.get_report_attributes:0016", "Report not found (" + report_id + ")", 4)
	return -1
end if


// get attributes from c_report_attribute
report_attributes = Create u_ds_data
report_attributes.Set_dataobject("dw_c_report_all_attribute")
ll_count = report_attributes.Retrieve(report_id)
if ll_count < 0 then return -1

f_attribute_ds_to_str(report_attributes,lstr_attributes)

// Get the big values and put them into the attributes structure
report_attributes.setfilter("big_data='Y'")
report_attributes.filter()
for i = 1 to report_attributes.rowcount()
	ls_attribute = report_attributes.object.attribute[i]
	ll_attribute_sequence = report_attributes.object.attribute_sequence[i]
	
	SELECTBLOB objectdata
	INTO :lbl_value
	FROM c_Report_Attribute
	WHERE report_id = :report_id
	AND attribute_sequence = :ll_attribute_sequence;
	if not tf_check() then return -1
	
	f_attribute_add_attribute(lstr_attributes, ls_attribute, f_blob_to_string(lbl_value))
next
report_attributes.setfilter("")
report_attributes.filter()




if len(ps_office_id) > 0 then
	// get attributes from o_report_attribute
	report_attributes.Set_dataobject("dw_o_report_attribute")
	report_attributes.Settransobject(sqlca)
	ll_count = report_attributes.Retrieve(report_id, ps_office_id)
	If ll_count < 0 then return -1
	
	f_attribute_ds_to_str(report_attributes,lstr_attributes)
end if

// Add the table attributes
add_attributes(lstr_attributes)

return 1

end function

public function integer set_report_attribute (string ps_attribute, string ps_value, string ps_component_id);str_attributes lstr_attributes
u_ds_data	report_attributes
long i
blob lbl_value
string ls_value
string ls_attribute
long ll_attribute_sequence
long ll_count


ll_attribute_sequence = sqlca.sp_set_report_attribute(report_id, ps_attribute, ps_value, ps_component_id)
if not tf_check() then return -1

ls_value = left(ps_value, 255)

if len(ps_value) > 255 then
	lbl_value = f_string_to_blob(ps_value, "UTF-16LE")
	UPDATEBLOB c_Report_Attribute
	SET objectdata = :lbl_value
	WHERE report_id = :report_id
	AND attribute_sequence = :ll_attribute_sequence;
	if not tf_check() then return -1
	
	UPDATE c_Report_Attribute
	SET value = :ls_value
	WHERE report_id = :report_id
	AND attribute_sequence = :ll_attribute_sequence;
	if not tf_check() then return -1
else
	UPDATE c_Report_Attribute
	SET value = :ls_value,
			objectdata = NULL
	WHERE report_id = :report_id
	AND attribute_sequence = :ll_attribute_sequence;
	if not tf_check() then return -1
end if

add_attribute(ps_attribute, ps_value)

return 1

end function

public function integer apply_dw_attribute (u_ds_report pds_datastore, string ps_attribute, string ps_value);integer li_sts
string ls_text_field
string ls_sts
string ls_current_value

li_sts = 1

if lower(left(ps_attribute, 5)) = "text." then
	ls_text_field = mid(ps_attribute, 6)

	// apply token substitution before updating datastore
	substitute_tokens(ps_value)
	
	ls_sts = pds_datastore.Modify(ls_text_field + ".text='" + ps_value + "'")
	if ls_sts <> "" then
		mylog.log(this, "u_component_report.apply_dw_attribute:0016", "Error Applying Repoort Attribute (" + ps_attribute + ", " + ps_value + ") - " + ls_sts, 4)
		li_sts = -1
	end if
end if

if lower(left(ps_attribute, 11)) = "datawindow." then
	ls_current_value = pds_datastore.describe(ps_attribute)
	ls_sts = pds_datastore.modify(ps_attribute + "=" + ps_value)
	if ls_sts <> "" then
		mylog.log(this, "u_component_report.apply_dw_attribute:0025", "Error Applying Repoort Attribute (" + ps_attribute + ", " + ps_value + ") - " + ls_sts, 4)
		li_sts = -1
	end if
end if

if left(lower(ps_attribute), 8) = "dwmodify" then
	ls_sts = pds_datastore.modify(ps_value)
	if ls_sts <> "" then
		mylog.log(this, "u_component_report.apply_dw_attribute:0033", "Error Applying Repoort Attribute (" + ps_attribute + ", " + ps_value + ") - " + ls_sts, 4)
		li_sts = -1
	end if
end if

return li_sts


end function

public function integer document_cancel_old ();return 1

end function

public function integer document_confirm_receipt_old ();return 1

end function

public function integer document_create_old ();return 1

end function

public function integer document_send_old ();return 1

end function

public function integer document_view_old ();long ll_attachment_id
boolean lb_auto_create
integer li_sts

get_attribute("attachment_id", ll_attachment_id)
if isnull(ll_attachment_id) then
	get_attribute("auto_create", lb_auto_create, true)
	if lb_auto_create then
//		li_sts = document_create()
		if li_sts <= 0 then return li_sts
		get_attribute("attachment_id", ll_attachment_id)
		if isnull(ll_attachment_id) then
			log.log(this, "u_component_report.document_view_old:0013", "Document created but not found", 4)
			return -1
		end if
	else
		log.log(this, "u_component_report.document_view_old:0017", "Document not found", 4)
		return -1
	end if
end if

li_sts = f_display_attachment(ll_attachment_id)
if li_sts > 0 then
end if

return 1

end function

public function u_component_document document_component ();integer li_sts
str_attributes lstr_attributes
u_component_document luo_document
string ls_document_component_id
long ll_document_patient_workplan_item_id
u_ds_data luo_attributes

ls_document_component_id = get_attribute("document_component_id")
if isnull(ls_document_component_id) then
	setnull(luo_document)
	return luo_document
end if

lstr_attributes = get_attributes()

// Make sure the report_id is in the attributes
f_attribute_add_attribute(lstr_attributes, "report_id", report_id)

luo_document = component_manager.get_component(ls_document_component_id, lstr_attributes)
if isnull(luo_document) then
	log.log(this, "u_component_report.document_component:0021", "error getting component (" + ls_document_component_id + ")", 4)
	setnull(luo_document)
	return luo_document
end if

// If we have a parent workplan item then get the attributes from it and add them to the document component
get_attribute("document_patient_workplan_item_id", ll_document_patient_workplan_item_id)
if ll_document_patient_workplan_item_id > 0 then
	// get attributes from c_report_attribute
	luo_attributes = Create u_ds_data
	luo_attributes.Set_dataobject("dw_patient_workplan_item_attributes_data")
	li_sts = luo_attributes.Retrieve(ll_document_patient_workplan_item_id)
	If tf_check() Then
		f_attribute_ds_to_str(luo_attributes,lstr_attributes)
	End If
	
	DESTROY luo_attributes
	
	luo_document.add_attributes(lstr_attributes)
end if


return luo_document


end function

on u_component_report.create
call super::create
end on

on u_component_report.destroy
call super::destroy
end on

event constructor;call super::constructor;setnull(oldpointer)

end event

