$PBExportHeader$u_component_report_external_source.sru
forward
global type u_component_report_external_source from u_component_report
end type
end forward

global type u_component_report_external_source from u_component_report
end type
global u_component_report_external_source u_component_report_external_source

type variables
long display_script_id


end variables

forward prototypes
public function integer xx_printreport ()
end prototypes

public function integer xx_printreport ();string ls_external_source
u_component_observation luo_external_source
integer li_sts
integer i, j
str_attributes lstr_attributes
str_external_source lstr_external_source
boolean lb_found
string ls_message
string ls_component_id
string ls_destination
string ls_file
unsignedlong lul_pid
string ls_report_printer
boolean lb_suppress_display

// If we have a wia_device_id then we don't need an external_source
ls_external_source = get_attribute("external_source")
if isnull(ls_external_source) then
	log.log(this, "u_component_report_external_source.xx_printreport:0019", "Null external source", 4)
	return -1
end if

ls_destination = get_attribute("DESTINATION")
if lower(ls_destination) = "screen" then
	get_attribute("suppress_display", lb_suppress_display, false)
else
	lb_suppress_display = false
end if

lstr_attributes = get_attributes()

f_attribute_add_attribute(lstr_attributes, "external_source", ls_external_source)

// Before we instantiate this external source, make sure it's on this computer
li_sts = common_thread.get_external_source(ls_external_source, lstr_external_source)
if li_sts <= 0 then
	ls_message = 'The specified external source ('
	ls_message += ls_external_source
	ls_message += ') does not exist on this computer.'
	log.log(this, "u_component_report_external_source.xx_printreport:0040", ls_message, 4)
	return -1
end if

ls_component_id = lstr_external_source.component_id

luo_external_source = component_manager.get_component(ls_component_id, lstr_attributes)
if isnull(luo_external_source) then
	log.log(this, "u_component_report_external_source.xx_printreport:0048", "error getting component (" + ls_component_id + ")", 4)
	return -1
end if

li_sts = luo_external_source.do_source()
if li_sts < 0 then
	log.log(this, "u_component_report_external_source.xx_printreport:0054", "Error calling external source (" + ls_external_source + ")", 4)
	return -1
end if

if li_sts = 0 then
	return 0
end if

// Now post the attachments
lb_found = false
for i = 1 to luo_external_source.observation_count
	// Now post the attachments
	for j = 1 to luo_external_source.observations[i].attachment_list.attachment_count
		if lb_found then
			ls_message = "Multiple attachments were returned from a call to an external source ("
			ls_message += ls_external_source + ").  The first attachment will be used for the report "
			ls_message += "and subsequent attachments will be ignored."
			log.log(this, "u_component_report_external_source.xx_printreport:0071", ls_message, 3)
		else
			// Get a local copy to make the coding easier
			document_file = luo_external_source.observations[i].attachment_list.attachments[j]
			lb_found = true
		end if
	next
next

component_manager.destroy_component(luo_external_source)

if not lb_found then return 0

CHOOSE CASE lower(ls_destination)
	CASE "file"
		// the file is already there so we're done
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
		common_thread.set_printer(ls_report_printer)
		
		// Print the file
		f_open_file_with_process(ls_file, "print", false, lul_pid)
		
		// Set the printer back to the default
		common_thread.set_default_printer()
END CHOOSE


return 1




end function

on u_component_report_external_source.create
call super::create
end on

on u_component_report_external_source.destroy
call super::destroy
end on

event constructor;call super::constructor;report_type = "RTF"

end event

