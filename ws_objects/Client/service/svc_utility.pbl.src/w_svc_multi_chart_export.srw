$PBExportHeader$w_svc_multi_chart_export.srw
forward
global type w_svc_multi_chart_export from w_window_base
end type
type st_title from statictext within w_svc_multi_chart_export
end type
type cb_export_now from commandbutton within w_svc_multi_chart_export
end type
type st_path from statictext within w_svc_multi_chart_export
end type
type st_billing_title from statictext within w_svc_multi_chart_export
end type
type st_path_title from statictext within w_svc_multi_chart_export
end type
type cb_pick_location from commandbutton within w_svc_multi_chart_export
end type
type dw_perform from u_dw_pick_list within w_svc_multi_chart_export
end type
type cb_cancel from commandbutton within w_svc_multi_chart_export
end type
type cb_export_from_server from commandbutton within w_svc_multi_chart_export
end type
type st_export_to_files_title from statictext within w_svc_multi_chart_export
end type
type st_send_to_printer_title from statictext within w_svc_multi_chart_export
end type
type st_separator_page_title from statictext within w_svc_multi_chart_export
end type
type st_printer from statictext within w_svc_multi_chart_export
end type
type st_export_to_files from statictext within w_svc_multi_chart_export
end type
type st_separator_page from statictext within w_svc_multi_chart_export
end type
type st_send_to_printer from statictext within w_svc_multi_chart_export
end type
type st_printer_title from statictext within w_svc_multi_chart_export
end type
type st_exclude_title from statictext within w_svc_multi_chart_export
end type
type st_exclude_date_range from statictext within w_svc_multi_chart_export
end type
type st_pick_patients from statictext within w_svc_multi_chart_export
end type
type st_picked from statictext within w_svc_multi_chart_export
end type
type st_pick_provider from statictext within w_svc_multi_chart_export
end type
type gb_which_patients from groupbox within w_svc_multi_chart_export
end type
type str_picked_patient from structure within w_svc_multi_chart_export
end type
end forward

type str_picked_patient from structure
	string		cpr_id
	string		patient_name
end type

global type w_svc_multi_chart_export from w_window_base
integer width = 2962
integer height = 1936
windowtype windowtype = response!
string button_type = "COMMAND"
integer max_buttons = 3
event cancelled ( )
st_title st_title
cb_export_now cb_export_now
st_path st_path
st_billing_title st_billing_title
st_path_title st_path_title
cb_pick_location cb_pick_location
dw_perform dw_perform
cb_cancel cb_cancel
cb_export_from_server cb_export_from_server
st_export_to_files_title st_export_to_files_title
st_send_to_printer_title st_send_to_printer_title
st_separator_page_title st_separator_page_title
st_printer st_printer
st_export_to_files st_export_to_files
st_separator_page st_separator_page
st_send_to_printer st_send_to_printer
st_printer_title st_printer_title
st_exclude_title st_exclude_title
st_exclude_date_range st_exclude_date_range
st_pick_patients st_pick_patients
st_picked st_picked
st_pick_provider st_pick_provider
gb_which_patients gb_which_patients
end type
global w_svc_multi_chart_export w_svc_multi_chart_export

type variables
u_component_service service

boolean export_to_files = true
boolean send_to_printer = false
string printer
boolean print_separator_page = true


string pick_type = "PROVIDER"

private long picked_patient_count
private str_picked_patient picked_patient[]

string primary_provider_user_id

real exclude_date_range_amount = 7
string exclude_date_range_unit_id = "DAY"

boolean export_cancelled = false

string export_service = "Chart Export"
string export_user_id = "#JMJ"

end variables

forward prototypes
public function integer dump_patient ()
public subroutine refresh_screen ()
public function long export_patients (boolean pb_from_server)
end prototypes

event cancelled();
export_cancelled = true

end event

public function integer dump_patient ();//string ls_path
//integer li_sts
//long ll_count
//string ls_context_object
//long ll_display_script_id
//long i
//long j
//string ls_description
//string ls_savetofile
//integer li_please_wait_index
//long ll_files
//str_encounter_description lstr_encounters[]
//str_treatment_description lstr_treatment
//str_assessment_description lstr_assessment
//long ll_encounter_count
//long ll_perform_flag
//long ll_attachment_count
//long ll_attachment_id
//str_attachment lstr_attachment
//string ls_temp
//
//setnull(lstr_treatment.treatment_id)
//setnull(lstr_assessment.problem_id)
//
//ls_path = st_path.text
//
//if not directoryexists(ls_path) then
//	li_sts = createdirectory(ls_path)
//	if li_sts <= 0 then
//		openwithparm(w_pop_message, "Specified directory does not exist")
//		return -1
//	end if
//end if
//
//
//if right(ls_path, 1) <> "\" then ls_path += "\"
//ls_path += patient_subdir + "\"
//
//if not directoryexists(ls_path) then
//	li_sts = createdirectory(ls_path)
//	if li_sts <= 0 then
//		log.log(this, "w_svc_multi_chart_export.dump_patient:0042", "Error creating directory (" + ls_path + ")", 4)
//		return -1
//	end if
//end if
//
//ll_count = dw_perform.rowcount()
//ll_encounter_count = current_patient.encounters.encounter_list("1=1", lstr_encounters)
//
//ll_attachment_count = current_patient.attachments.rowcount()
//
//// Count the items so the progress bar will be accurate
//ll_files = 0
//for i = 1 to ll_count
//	ls_context_object = dw_perform.object.context_object[i]
//	ll_display_script_id = dw_perform.object.display_script_id[i]
//	ls_description = dw_perform.object.description[i]
//	ll_perform_flag = dw_perform.object.perform_flag[i]
//	if ll_perform_flag = 1 then
//		CHOOSE CASE lower(ls_context_object)
//			CASE "patient"
//				ll_files += 1
//			CASE "encounter"
//				ll_files += ll_encounter_count
//			CASE "attachment"
//				ll_files += ll_attachment_count
//		END CHOOSE
//	end if
//next
//
//li_please_wait_index = f_please_wait_open()
//f_please_wait_progress_bar(li_please_wait_index, 0, ll_files)
//
//
//for i = 1 to ll_count
//	ls_context_object = dw_perform.object.context_object[i]
//	ll_display_script_id = dw_perform.object.display_script_id[i]
//	ls_description = dw_perform.object.description[i]
//	ll_perform_flag = dw_perform.object.perform_flag[i]
//	if ll_perform_flag = 1 then
//		CHOOSE CASE lower(ls_context_object)
//			CASE "patient"
//				ls_savetofile = ls_path + f_string_to_filename(ls_description) + ".rtf"
//				ole_rtf.clear_rtf()
//				ole_rtf.display_script(ll_display_script_id)
//				ole_rtf.recalc_fields()
//				ole_rtf.savedocument(ls_savetofile)
//				f_please_wait_progress_bump(li_please_wait_index)
//			CASE "encounter"
//				for j = 1 to ll_encounter_count
//					ls_savetofile = ls_path + f_string_to_filename(ls_description) 
//					ls_savetofile += "_" + string(lstr_encounters[j].encounter_date, "yyyymmdd")
//					ls_savetofile += ".rtf"
//					ole_rtf.clear_rtf()
//					ole_rtf.display_script(ll_display_script_id, lstr_encounters[j], lstr_assessment, lstr_treatment)
//					ole_rtf.recalc_fields()
//					ole_rtf.savedocument(ls_savetofile)
//					f_please_wait_progress_bump(li_please_wait_index)
//				next
//			CASE "attachment"
//				for j = 1 to ll_attachment_count
//					// Determine the subdirectory
//					lstr_attachment = current_patient.attachments.get_attachment_structure(j)
//					ls_savetofile = ls_path + "Attachments" + "\"
//					
//					// Make sure the attachments subdirectory exists
//					if not directoryexists(ls_savetofile) then
//						li_sts = createdirectory(ls_savetofile)
//						if li_sts <= 0 then
//							log.log(this, "w_svc_multi_chart_export.dump_patient:0110", "Error creating directory (" + ls_savetofile + ")", 4)
//							return -1
//						end if
//					end if
//					
//					// Add the folder subdirectory
//					ls_temp = f_string_to_filename(lstr_attachment.attachment_folder)
//					if len(ls_temp) > 0 then
//						ls_savetofile += ls_temp
//					else
//						ls_savetofile += "No Folder"
//					end if
//					
//					// Make sure the subdirectory exists
//					if not directoryexists(ls_savetofile) then
//						li_sts = createdirectory(ls_savetofile)
//						if li_sts <= 0 then
//							log.log(this, "w_svc_multi_chart_export.dump_patient:0127", "Error creating directory (" + ls_savetofile + ")", 4)
//							return -1
//						end if
//					end if
//					
//					// Add the filename
//					ls_temp = f_string_to_filename(left(lstr_attachment.attachment_tag, 64))
//					if len(ls_temp) > 0 then
//						ls_savetofile += "\" + ls_temp
//					else
//						ls_temp = f_string_to_filename(left(lstr_attachment.attachment_file, 64))
//						if len(ls_temp) > 0 then
//							ls_savetofile += "\" + ls_temp
//						else
//							ls_savetofile += "\" + lstr_attachment.extension + " File"
//						end if
//					end if
//					ls_savetofile += "_" + string(lstr_attachment.attachment_id)
//					ls_savetofile += "_" + string(lstr_attachment.attachment_date, "yyyymmdd")
//					ls_savetofile += "." + lstr_attachment.extension
//					current_patient.attachments.attachment_save_as(lstr_attachment.attachment_id, ls_savetofile)
//					f_please_wait_progress_bump(li_please_wait_index)
//				next
//		END CHOOSE
//	end if
//next
//
//f_please_wait_close(li_please_wait_index)
//
return 1
//
//
end function

public subroutine refresh_screen ();

if pick_type = "PATIENT" then
	st_pick_patients.backcolor = color_object_selected
	st_pick_provider.backcolor = color_object
	st_picked.backcolor = color_object
	if picked_patient_count > 0 then
		st_picked.text = string(picked_patient_count) + " Patients Selected"
	else
		st_picked.text = "No Patients Selected"
	end if
else
	st_pick_patients.backcolor = color_object
	st_pick_provider.backcolor = color_object_selected
	if len(primary_provider_user_id) > 0 then
		st_picked.text = user_list.user_full_name(primary_provider_user_id)
		st_picked.backcolor = user_list.user_color(primary_provider_user_id)
		if isnull(st_picked.backcolor) or st_picked.backcolor <= 0 then st_picked.backcolor = color_object
	else
		st_picked.text = "No Provider Selected"
		st_picked.backcolor = color_object
	end if
end if

st_exclude_date_range.text = f_pretty_amount_unit(exclude_date_range_amount, exclude_date_range_unit_id)


if export_to_files then
	st_export_to_files.text = "Yes"
else
	st_export_to_files.text = "No"
end if

if send_to_printer then
	st_send_to_printer.text = "Yes"
	st_printer_title.visible = true
	st_printer.visible = true
	st_separator_page.visible = true
	st_separator_page_title.visible = true
else
	st_send_to_printer.text = "No"
	st_printer_title.visible = false
	st_printer.visible = false
	st_separator_page.visible = false
	st_separator_page_title.visible = false
end if

if len(printer) > 0 then
	st_printer.text = printer
else
	st_printer.text = "<Default>"
end if

if print_separator_page then
	st_separator_page.text = "Yes"
else
	st_separator_page.text = "No"
end if

end subroutine

public function long export_patients (boolean pb_from_server);long i
long ll_exported
long ll_errors
string ls_message
str_service_info lstr_service
integer li_sts
str_attributes lstr_attributes
long ll_count
long ll_perform_flag
string ls_presets
string ls_temp
long ll_display_script_id
long ll_encounter_id
integer li_step_number
u_ds_data luo_data
integer li_please_wait_index

setnull(ll_encounter_id)
setnull(li_step_number)

// If we're exporting by provider, then get the list of patients for this provider
if pick_type = "PROVIDER" then
	luo_data = CREATE u_ds_data
	luo_data.set_dataobject("dw_export_patients_for_provider")
	picked_patient_count = luo_data.retrieve(primary_provider_user_id, export_service, long(exclude_date_range_amount), exclude_date_range_unit_id)
	
	for i = 1 to picked_patient_count
		picked_patient[i].cpr_id = luo_data.object.cpr_id[i]
		picked_patient[i].patient_name = luo_data.object.patient_name[i]
	next
end if

ll_count = dw_perform.rowcount()

ls_presets = ""
for i = 1 to ll_count
	ll_display_script_id = dw_perform.object.display_script_id[i]
	ll_perform_flag = dw_perform.object.perform_flag[i]
	
	if isnull(ll_display_script_id) or ll_display_script_id <= 0 then ll_display_script_id = 0
	
	ls_temp = string(ll_display_script_id) + "=" + string(ll_perform_flag)
	
	if len(ls_presets) > 0 then ls_presets += ","
	ls_presets += ls_temp
next

f_attribute_add_attribute(lstr_attributes, "script_presets", ls_presets)
f_attribute_add_attribute(lstr_attributes, "export_to_files", f_boolean_to_string(export_to_files))
f_attribute_add_attribute(lstr_attributes, "send_to_printer", f_boolean_to_string(send_to_printer))
if send_to_printer then
	f_attribute_add_attribute(lstr_attributes, "printer", printer)
	f_attribute_add_attribute(lstr_attributes, "print_separator_page", f_boolean_to_string(print_separator_page))
end if

f_attribute_add_attribute(lstr_attributes, "auto_perform", "True")
f_attribute_add_attribute(lstr_attributes, "default_path", st_path.text)


li_please_wait_index = f_please_wait_open()
f_please_wait_progress_bar(li_please_wait_index, 0, picked_patient_count)


for i = 1 to picked_patient_count
	yield()
	if export_cancelled then
		exit
	end if
	
	if pb_from_server then
		li_sts = service_list.order_service(picked_patient[i].cpr_id, &
														ll_encounter_id, &
														export_service, &
														export_user_id, &
														"Export Chart for " + picked_patient[i].patient_name, &
														li_step_number, &
														lstr_attributes)
		if li_sts > 0 then ll_exported += 1
	else
		lstr_service.service = export_service
		lstr_service.attributes = lstr_attributes
		f_attribute_add_attribute(lstr_service.attributes, "cpr_id", picked_patient[i].cpr_id)
		
		li_sts = service_list.do_service(lstr_service)
		if li_sts > 0 then ll_exported += 1
	end if
	
	f_please_wait_progress_bump(li_please_wait_index)
next


f_please_wait_close(li_please_wait_index)


if pb_from_server then
	ls_message = string(ll_exported) + " patient charts sent to server for exporting."
else
	ls_message = string(ll_exported) + " patient charts successfully exported."
end if
if ll_errors > 0 then ls_message += "  " + string(ll_errors) + " unsuccessful exports due to errors (see event viewer for more information)."
if export_cancelled then ls_message += "  Export cancelled by user."

openwithparm(w_pop_message, ls_message)


return ll_exported

end function

event open;call super::open;long ll_menu_id
long ll_rows
str_popup_return popup_return
string ls_null
long i
long ll_count
long ll_row
string ls_temp
string lsa_patient_reports[]
string ls_patient
string ls_subdir

setnull(ls_null)

setnull(printer)
setnull(primary_provider_user_id)

popup_return.item_count = 1
popup_return.items[1] = "ERROR"

service = message.powerobjectparm

// Set the title and sizes
title = "Export Charts"

if len(st_title.text) > 42 then
	if len(st_title.text) > 60 then
		if len(st_title.text) > 70 then
			st_title.textsize = -10
		else
			st_title.textsize = -12
		end if
	else
		st_title.textsize = -14
	end if
else
	st_title.textsize = -18
end if

ls_temp = service.get_attribute("default_path")
if isnull(ls_temp) then
	// Get the attribute from the chart export service if it wasn't defined for this service
	SELECT max(value)
	INTO :ls_temp
	FROM o_Service_Attribute
	WHERE service = :export_service
	AND attribute = 'default_path';
	if not tf_check() then
		closewithreturn(this, popup_return)
		return
	end if
end if
if len(ls_temp) > 0 then
	if right(ls_temp, 1) <> "\" then ls_temp += "\"
else
	ls_temp = temp_path + "\PatientCharts\"
end if
st_path.text = ls_temp

export_service = service.get_attribute("export_service")
if isnull(export_service) then export_service = "Chart Export"

export_user_id = service.get_attribute("export_user_id")
if isnull(export_user_id) then
	cb_export_from_server.visible = false
	cb_export_now.x = cb_export_from_server.x
end if

st_path_title.text = "Patient reports and attachments will be placed in patient specific sub-directories in the following location:"


//ls_temp = service.get_attribute("patient_reports")
// Actually get the attribute from the chart export service
SELECT max(value)
INTO :ls_temp
FROM o_Service_Attribute
WHERE service = :export_service
AND attribute = 'patient_reports';
if not tf_check() then
	closewithreturn(this, popup_return)
	return
end if
ll_count = f_parse_string(ls_temp, ",", lsa_patient_reports)
for i = 1 to ll_count
	dw_perform.object.context_object[i] = "Patient"
	dw_perform.object.display_script_id[i] = long(lsa_patient_reports[i])
	dw_perform.object.description[i] = datalist.display_script_description(long(lsa_patient_reports[i]))
next

//ls_temp = service.get_attribute("encounter_report")
// Actually get the attribute from the chart export service
SELECT max(value)
INTO :ls_temp
FROM o_Service_Attribute
WHERE service = :export_service
AND attribute = 'encounter_report';
if not tf_check() then
	closewithreturn(this, popup_return)
	return
end if
if not isnull(ls_temp) then
	ll_row = dw_perform.insertrow(0)
	dw_perform.object.context_object[ll_row] = "Encounter"
	dw_perform.object.display_script_id[ll_row] = long(ls_temp)
	dw_perform.object.description[ll_row] = "Include Encounter Reports"
end if

//ls_temp = service.get_attribute("attachment_report")
// Actually get the attribute from the chart export service
SELECT max(value)
INTO :ls_temp
FROM o_Service_Attribute
WHERE service = :export_service
AND attribute = 'attachment_report';
if not tf_check() then
	closewithreturn(this, popup_return)
	return
end if
if not isnull(ls_temp) then
	ll_row = dw_perform.insertrow(0)
	dw_perform.object.context_object[ll_row] = "Patient"
	dw_perform.object.display_script_id[ll_row] = long(ls_temp)
	dw_perform.object.description[ll_row] = "Include Attachment List"
end if

ll_row = dw_perform.insertrow(0)
dw_perform.object.context_object[ll_row] = "Attachment"
dw_perform.object.description[ll_row] = "Include Attachments"

//ole_rtf.set_view_mode("page")

refresh_screen()


end event

on w_svc_multi_chart_export.create
int iCurrent
call super::create
this.st_title=create st_title
this.cb_export_now=create cb_export_now
this.st_path=create st_path
this.st_billing_title=create st_billing_title
this.st_path_title=create st_path_title
this.cb_pick_location=create cb_pick_location
this.dw_perform=create dw_perform
this.cb_cancel=create cb_cancel
this.cb_export_from_server=create cb_export_from_server
this.st_export_to_files_title=create st_export_to_files_title
this.st_send_to_printer_title=create st_send_to_printer_title
this.st_separator_page_title=create st_separator_page_title
this.st_printer=create st_printer
this.st_export_to_files=create st_export_to_files
this.st_separator_page=create st_separator_page
this.st_send_to_printer=create st_send_to_printer
this.st_printer_title=create st_printer_title
this.st_exclude_title=create st_exclude_title
this.st_exclude_date_range=create st_exclude_date_range
this.st_pick_patients=create st_pick_patients
this.st_picked=create st_picked
this.st_pick_provider=create st_pick_provider
this.gb_which_patients=create gb_which_patients
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.cb_export_now
this.Control[iCurrent+3]=this.st_path
this.Control[iCurrent+4]=this.st_billing_title
this.Control[iCurrent+5]=this.st_path_title
this.Control[iCurrent+6]=this.cb_pick_location
this.Control[iCurrent+7]=this.dw_perform
this.Control[iCurrent+8]=this.cb_cancel
this.Control[iCurrent+9]=this.cb_export_from_server
this.Control[iCurrent+10]=this.st_export_to_files_title
this.Control[iCurrent+11]=this.st_send_to_printer_title
this.Control[iCurrent+12]=this.st_separator_page_title
this.Control[iCurrent+13]=this.st_printer
this.Control[iCurrent+14]=this.st_export_to_files
this.Control[iCurrent+15]=this.st_separator_page
this.Control[iCurrent+16]=this.st_send_to_printer
this.Control[iCurrent+17]=this.st_printer_title
this.Control[iCurrent+18]=this.st_exclude_title
this.Control[iCurrent+19]=this.st_exclude_date_range
this.Control[iCurrent+20]=this.st_pick_patients
this.Control[iCurrent+21]=this.st_picked
this.Control[iCurrent+22]=this.st_pick_provider
this.Control[iCurrent+23]=this.gb_which_patients
end on

on w_svc_multi_chart_export.destroy
call super::destroy
destroy(this.st_title)
destroy(this.cb_export_now)
destroy(this.st_path)
destroy(this.st_billing_title)
destroy(this.st_path_title)
destroy(this.cb_pick_location)
destroy(this.dw_perform)
destroy(this.cb_cancel)
destroy(this.cb_export_from_server)
destroy(this.st_export_to_files_title)
destroy(this.st_send_to_printer_title)
destroy(this.st_separator_page_title)
destroy(this.st_printer)
destroy(this.st_export_to_files)
destroy(this.st_separator_page)
destroy(this.st_send_to_printer)
destroy(this.st_printer_title)
destroy(this.st_exclude_title)
destroy(this.st_exclude_date_range)
destroy(this.st_pick_patients)
destroy(this.st_picked)
destroy(this.st_pick_provider)
destroy(this.gb_which_patients)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_svc_multi_chart_export
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_multi_chart_export
integer x = 50
integer y = 1588
end type

type st_title from statictext within w_svc_multi_chart_export
integer width = 2898
integer height = 132
integer textsize = -22
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Multi-Patient Chart Export"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_export_now from commandbutton within w_svc_multi_chart_export
integer x = 1618
integer y = 1680
integer width = 603
integer height = 108
integer taborder = 150
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Export Now"
end type

event clicked;str_popup_return popup_return
long ll_count
string ls_path

ll_count = export_patients(false)
if ll_count <= 0 then return

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type st_path from statictext within w_svc_multi_chart_export
integer x = 160
integer y = 308
integer width = 2473
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type st_billing_title from statictext within w_svc_multi_chart_export
integer x = 1646
integer y = 492
integer width = 955
integer height = 100
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 7191717
string text = "Include"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_path_title from statictext within w_svc_multi_chart_export
integer x = 160
integer y = 232
integer width = 2473
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "Patient reports and attachments will be placed in the following location:"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_pick_location from commandbutton within w_svc_multi_chart_export
integer x = 2647
integer y = 308
integer width = 133
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ". . ."
end type

event clicked;integer li_sts

li_sts = getfolder("Select Location For Patient Export", st_path.text)



end event

type dw_perform from u_dw_pick_list within w_svc_multi_chart_export
integer x = 1435
integer y = 596
integer width = 1381
integer height = 956
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_dump_patient_perform"
boolean vscrollbar = true
end type

event clicked;call super::clicked;long ll_perform_flag

if row <= 0 then return

ll_perform_flag = object.perform_flag[row]
if ll_perform_flag = 1 then
	object.perform_flag[row] = 0
else
	object.perform_flag[row] = 1
end if

end event

type cb_cancel from commandbutton within w_svc_multi_chart_export
integer x = 37
integer y = 1680
integer width = 443
integer height = 108
integer taborder = 170
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;str_popup_return popup_return
integer li_sts
string ls_description


popup_return.item_count = 1
popup_return.items[1] = "CANCEL"

closewithreturn(parent, popup_return)

end event

type cb_export_from_server from commandbutton within w_svc_multi_chart_export
integer x = 2272
integer y = 1680
integer width = 603
integer height = 108
integer taborder = 160
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Export from Server"
end type

event clicked;str_popup_return popup_return
long ll_count
string ls_path

ll_count = export_patients(true)
if ll_count <= 0 then return

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type st_export_to_files_title from statictext within w_svc_multi_chart_export
integer x = 197
integer y = 1104
integer width = 517
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "Export To Files:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_send_to_printer_title from statictext within w_svc_multi_chart_export
integer x = 197
integer y = 1232
integer width = 517
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "Send To Printer:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_separator_page_title from statictext within w_svc_multi_chart_export
boolean visible = false
integer x = 69
integer y = 1488
integer width = 645
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "Print Separator Page:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_printer from statictext within w_svc_multi_chart_export
boolean visible = false
integer x = 750
integer y = 1344
integer width = 590
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "<Default>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_printer
ls_printer = common_thread.select_printer()

if len(ls_printer) > 0 then
	printer = ls_printer
end if

refresh_screen()

end event

type st_export_to_files from statictext within w_svc_multi_chart_export
integer x = 750
integer y = 1088
integer width = 238
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if export_to_files then
	export_to_files = false
	text = "No"
else
	export_to_files = true
	text = "Yes"
end if


end event

type st_separator_page from statictext within w_svc_multi_chart_export
boolean visible = false
integer x = 750
integer y = 1472
integer width = 238
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if print_separator_page then
	print_separator_page = false
	text = "No"
else
	print_separator_page = true
	text = "Yes"
end if


end event

type st_send_to_printer from statictext within w_svc_multi_chart_export
integer x = 750
integer y = 1216
integer width = 238
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if send_to_printer then
	send_to_printer = false
	text = "No"
	st_printer_title.visible = false
	st_printer.visible = false
	st_separator_page_title.visible = false
	st_separator_page.visible = false
else
	send_to_printer = true
	text = "Yes"
	st_printer_title.visible = true
	st_printer.visible = true
	st_separator_page_title.visible = true
	st_separator_page.visible = true
end if


end event

type st_printer_title from statictext within w_svc_multi_chart_export
boolean visible = false
integer x = 430
integer y = 1360
integer width = 283
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "Printer:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_exclude_title from statictext within w_svc_multi_chart_export
integer x = 311
integer y = 800
integer width = 878
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "Exclude if already exported within"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_exclude_date_range from statictext within w_svc_multi_chart_export
integer x = 521
integer y = 864
integer width = 375
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "7 Days"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return


popup.title = st_exclude_title.text
popup.data_row_count = 2
popup.items[1] = string(exclude_date_range_amount)
popup.items[2] = exclude_date_range_unit_id
openwithparm(w_pop_appointment_time, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 2 then return


exclude_date_range_amount = real(popup_return.items[1])
exclude_date_range_unit_id = popup_return.items[2]

text = f_pretty_amount_unit(exclude_date_range_amount, exclude_date_range_unit_id)




end event

type st_pick_patients from statictext within w_svc_multi_chart_export
integer x = 219
integer y = 528
integer width = 480
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Pick Patients"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
long ll_choice
long i
long ll_exclude_date_range_amount
string ls_cpr_id
string ls_patient_name
boolean lb_yes_to_all
long ll_count

backcolor = color_object_selected
st_pick_provider.backcolor = color_object

pick_type = "PATIENT"


if picked_patient_count > 0 then
	popup.data_row_count = 2
	popup.title = "You have already selected some patients.  Do you want to clear the previous selections or select additional patients?"
	popup.items[1] = "Clear previous selections"
	popup.items[2] = "Select additional patients"
	openwithparm(w_pop_choices_2, popup)
	ll_choice = message.doubleparm
	if ll_choice = 1 then
		picked_patient_count = 0
	end if
end if


open(w_patient_select_multi)
popup_return = message.powerobjectparm
if popup_return.item_count <= 0 then return

ll_exclude_date_range_amount = long(exclude_date_range_amount)
lb_yes_to_all = false

for i = 1 to popup_return.item_count
	ls_cpr_id = popup_return.items[i]
	ls_patient_name = sqlca.fn_patient_full_name(ls_cpr_id)
	
	if not lb_yes_to_all then
		// Check how recent these patients were exported
		SELECT count(*)
		INTO :ll_count
		FROM p_Patient_WP_Item
		WHERE cpr_id = :ls_cpr_id
		AND item_type = 'Service'
		AND ordered_service = :export_service
		AND status = 'Completed'
		AND dbo.fn_date_add_interval(end_date, :ll_exclude_date_range_amount, :exclude_date_range_unit_id) > dbo.get_client_datetime();
		if not tf_check() then return
		
		if ll_count > 0 then
			popup.title = "The selected patient '" + ls_patient_name + "' has been recently exported."
			popup.title += "  Do you wish to include this patient in this export batch?"
			popup.data_row_count = 3
			popup.items[1] = "No"
			popup.items[2] = "Yes"
			popup.items[3] = "Yes To All"
			openwithparm(w_pop_choices_3, popup)
			ll_choice = message.doubleparm
			
			if ll_choice = 1 then continue
			if ll_choice = 3 then lb_yes_to_all = true
		end if
	end if
	
	picked_patient_count += 1
	picked_patient[picked_patient_count].cpr_id = ls_cpr_id
	picked_patient[picked_patient_count].patient_name = ls_patient_name
next

refresh_screen()

end event

type st_picked from statictext within w_svc_multi_chart_export
integer x = 329
integer y = 664
integer width = 782
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "No Patients Selected"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_pick_provider from statictext within w_svc_multi_chart_export
integer x = 768
integer y = 528
integer width = 480
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Pick Provider"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;u_user luo_user_id

backcolor = color_object_selected
st_pick_patients.backcolor = color_object

pick_type = "PROVIDER"

luo_user_id = user_list.pick_user(false, false, false)

if not isnull(luo_user_id) then
	primary_provider_user_id = luo_user_id.user_id
end if

refresh_screen()

end event

type gb_which_patients from groupbox within w_svc_multi_chart_export
integer x = 105
integer y = 444
integer width = 1230
integer height = 556
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "Which Patients"
end type

