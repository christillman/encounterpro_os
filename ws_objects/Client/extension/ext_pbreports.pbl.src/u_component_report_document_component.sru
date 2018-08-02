$PBExportHeader$u_component_report_document_component.sru
forward
global type u_component_report_document_component from u_component_report
end type
end forward

global type u_component_report_document_component from u_component_report
end type
global u_component_report_document_component u_component_report_document_component

type variables
long display_script_id


end variables

forward prototypes
public function integer xx_printreport ()
end prototypes

public function integer xx_printreport ();string ls_document_component_id
u_component_document luo_document
integer li_sts
integer i, j
str_attributes lstr_attributes
//boolean lb_found
string ls_message
string ls_destination
string ls_file
unsignedlong lul_pid
string ls_report_printer
boolean lb_suppress_display
string ls_context_object
boolean lb_document

// If we have a wia_device_id then we don't need an external_source
ls_document_component_id = get_attribute("document_component_id")
if isnull(ls_document_component_id) then
	log.log(this, "u_component_report_document_component.xx_printreport.0019", "No document component specified", 4)
	printreport_status = -1
	return -1
end if

ls_destination = get_attribute("DESTINATION")
if lower(ls_destination) = "screen" then
	get_attribute("suppress_display", lb_suppress_display, false)
else
	lb_suppress_display = false
end if

lstr_attributes = get_attributes()

f_attribute_add_attribute(lstr_attributes, "report_id", report_id)

// The report object overrides the current context object
if len(report_object) > 0 then
	f_attribute_add_attribute(lstr_attributes, "context_object", report_object)
end if


luo_document = component_manager.get_component(ls_document_component_id, lstr_attributes)
if isnull(luo_document) then
	log.log(this, "u_component_report_document_component.xx_printreport.0019", "error getting component (" + ls_document_component_id + ")", 4)
	printreport_status = -1
	return -1
end if

TRY
	li_sts = luo_document.create_document()
	if li_sts < 0 then
		log.log(this, "u_component_report_document_component.xx_printreport.0019", "Error calling document component (" + ls_document_component_id + ")", 4)
		printreport_status = -1
		return -1
	end if
CATCH (exception le_error)
	log.log(this, "u_component_report_document_component.xx_printreport.0019", "Error calling document component (" + ls_document_component_id + "): " + le_error.text, 4)
	printreport_status = -1
	return -1
END TRY

// Get the first document
lb_document = false
if luo_document.document_count > 0 then
	lb_document = true
	document_file = luo_document.document[1]
	if luo_document.document_count > 1 then
		ls_message = string(luo_document.document_count) + " documents were returned from the document component.  The first document will be used for the report "
		ls_message += "and subsequent documents will be ignored."
		log.log(this, "u_component_report_document_component.xx_printreport.0019", ls_message, 3)
	end if
end if

component_manager.destroy_component(luo_document)

if not lb_document then
	printreport_status = 0
	return 0
end if

CHOOSE CASE lower(ls_destination)
	CASE "file"
		// the file is already there so we're done
		printreport_status = 1
		return 1
	CASE "screen"
		if not lb_suppress_display then
			ls_file = f_temp_file(document_file.extension)
			log.file_write(document_file.attachment, ls_file)
			f_open_file(ls_file, false)
		end if
	CASE ELSE // default destination is printer
		// Save to a file
		ls_file = f_temp_file(document_file.extension)
		log.file_write(document_file.attachment, ls_file)
		
		// Set the desired printer
		ls_report_printer = get_attribute("printer")
		if len(ls_report_printer) > 0 then
			common_thread.set_printer(ls_report_printer)
		end if
			
		
		// Print the file
		f_open_file_with_process(ls_file, "print", false, lul_pid)
		
		// Set the printer back to the default
		common_thread.set_default_printer()
END CHOOSE


printreport_status = 1
return 1




end function

on u_component_report_document_component.create
call super::create
end on

on u_component_report_document_component.destroy
call super::destroy
end on

event constructor;call super::constructor;report_type = "RTF"

end event

