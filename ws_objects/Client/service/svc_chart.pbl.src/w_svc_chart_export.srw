$PBExportHeader$w_svc_chart_export.srw
forward
global type w_svc_chart_export from w_window_base
end type
type st_title from statictext within w_svc_chart_export
end type
type cb_finished from commandbutton within w_svc_chart_export
end type
type st_path from statictext within w_svc_chart_export
end type
type st_billing_title from statictext within w_svc_chart_export
end type
type st_path_title from statictext within w_svc_chart_export
end type
type cb_pick_location from commandbutton within w_svc_chart_export
end type
type dw_perform from u_dw_pick_list within w_svc_chart_export
end type
type cb_cancel from commandbutton within w_svc_chart_export
end type
type ole_rtf from u_rich_text_edit within w_svc_chart_export
end type
end forward

global type w_svc_chart_export from w_window_base
integer width = 2962
integer height = 1936
windowtype windowtype = response!
string button_type = "COMMAND"
integer max_buttons = 3
st_title st_title
cb_finished cb_finished
st_path st_path
st_billing_title st_billing_title
st_path_title st_path_title
cb_pick_location cb_pick_location
dw_perform dw_perform
cb_cancel cb_cancel
ole_rtf ole_rtf
end type
global w_svc_chart_export w_svc_chart_export

type variables
u_component_service service

string patient_subdir

boolean auto_perform

boolean export_to_files
boolean send_to_printer
string printer
boolean print_separator_page
long separator_page_display_script_id
end variables

forward prototypes
public function integer dump_patient ()
end prototypes

public function integer dump_patient ();string ls_path
integer li_sts
long ll_count
string ls_context_object
long ll_display_script_id
long i
long j
string ls_description
string ls_savetofile
integer li_please_wait_index
long ll_files
str_encounter_description lstr_encounters[]
str_treatment_description lstr_treatment
str_assessment_description lstr_assessment
long ll_encounter_count
long ll_perform_flag
long ll_attachment_count
long ll_attachment_id
str_attachment lstr_attachment
string ls_temp
unsignedlong lul_printjob
unsignedlong lul_process_id
string ls_separator_text

setnull(lstr_treatment.treatment_id)
setnull(lstr_assessment.problem_id)

ls_path = st_path.text

if not directoryexists(ls_path) then
	li_sts = createdirectory(ls_path)
	if li_sts <= 0 then
		openwithparm(w_pop_message, "Specified directory does not exist")
		return -1
	end if
end if


if right(ls_path, 1) <> "\" then ls_path += "\"
ls_path += patient_subdir + "\"

if not directoryexists(ls_path) then
	li_sts = createdirectory(ls_path)
	if li_sts <= 0 then
		log.log(this, "w_svc_chart_export.dump_patient:0045", "Error creating directory (" + ls_path + ")", 4)
		return -1
	end if
end if

ll_count = dw_perform.rowcount()
ll_encounter_count = current_patient.encounters.encounter_list("1=1", lstr_encounters)

ll_attachment_count = current_patient.attachments.rowcount()

// Count the items so the progress bar will be accurate
ll_files = 0
for i = 1 to ll_count
	ls_context_object = dw_perform.object.context_object[i]
	ll_display_script_id = dw_perform.object.display_script_id[i]
	ls_description = dw_perform.object.description[i]
	ll_perform_flag = dw_perform.object.perform_flag[i]
	if ll_perform_flag = 1 then
		CHOOSE CASE lower(ls_context_object)
			CASE "patient"
				ll_files += 1
			CASE "encounter"
				ll_files += ll_encounter_count
			CASE "attachment"
				ll_files += ll_attachment_count
		END CHOOSE
	end if
next

li_please_wait_index = f_please_wait_open()
f_please_wait_progress_bar(li_please_wait_index, 0, ll_files)

if send_to_printer and len(printer) > 0 then
	common_thread.set_printer(printer)
end if

if send_to_printer and print_separator_page then
	if separator_page_display_script_id > 0 then
		ls_savetofile = f_temp_file("rtf")
		ole_rtf.clear_rtf()
		ole_rtf.display_script(ll_display_script_id)
		ole_rtf.recalc_fields()
		ole_rtf.savedocument(ls_savetofile)
	
		f_open_file_with_process(ls_savetofile, "Print", true, lul_process_id)
	else
		f_print_patient_separator_page()
	end if
end if

for i = 1 to ll_count
	ls_context_object = dw_perform.object.context_object[i]
	ll_display_script_id = dw_perform.object.display_script_id[i]
	ls_description = dw_perform.object.description[i]
	ll_perform_flag = dw_perform.object.perform_flag[i]
	if ll_perform_flag = 1 then
		CHOOSE CASE lower(ls_context_object)
			CASE "patient"
				ls_savetofile = ls_path + f_string_to_filename(ls_description) + ".rtf"
				ole_rtf.clear_rtf()
				ole_rtf.display_script(ll_display_script_id)
				ole_rtf.recalc_fields()
				ole_rtf.savedocument(ls_savetofile)
				if send_to_printer then
					f_open_file_with_process(ls_savetofile, "Print", true, lul_process_id)
				end if
				f_please_wait_progress_bump(li_please_wait_index)
			CASE "encounter"
				for j = 1 to ll_encounter_count
					ls_savetofile = ls_path + f_string_to_filename(ls_description) 
					ls_savetofile += "_" + string(lstr_encounters[j].encounter_date, "yyyymmdd")
					ls_savetofile += ".rtf"
					ole_rtf.clear_rtf()
					ole_rtf.display_script(ll_display_script_id, lstr_encounters[j], lstr_assessment, lstr_treatment)
					ole_rtf.recalc_fields()
					ole_rtf.savedocument(ls_savetofile)
					if send_to_printer then
						f_open_file_with_process(ls_savetofile, "Print", true, lul_process_id)
					end if
					f_please_wait_progress_bump(li_please_wait_index)
				next
			CASE "attachment"
				for j = 1 to ll_attachment_count
					// Determine the subdirectory
					lstr_attachment = current_patient.attachments.get_attachment_structure(j)
					ls_savetofile = ls_path + "Attachments" + "\"
					
					// Make sure the attachments subdirectory exists
					if not directoryexists(ls_savetofile) then
						li_sts = createdirectory(ls_savetofile)
						if li_sts <= 0 then
							log.log(this, "w_svc_chart_export.dump_patient:0136", "Error creating directory (" + ls_savetofile + ")", 4)
							return -1
						end if
					end if
					
					// Add the folder subdirectory
					ls_temp = f_string_to_filename(lstr_attachment.attachment_folder)
					if len(ls_temp) > 0 then
						ls_savetofile += ls_temp
					else
						ls_savetofile += "No Folder"
					end if
					
					// Make sure the subdirectory exists
					if not directoryexists(ls_savetofile) then
						li_sts = createdirectory(ls_savetofile)
						if li_sts <= 0 then
							log.log(this, "w_svc_chart_export.dump_patient:0153", "Error creating directory (" + ls_savetofile + ")", 4)
							return -1
						end if
					end if
					
					// Add the filename
					ls_temp = f_string_to_filename(left(lstr_attachment.attachment_tag, 64))
					if len(ls_temp) > 0 then
						ls_savetofile += "\" + ls_temp
					else
						ls_temp = f_string_to_filename(left(lstr_attachment.attachment_file, 64))
						if len(ls_temp) > 0 then
							ls_savetofile += "\" + ls_temp
						else
							ls_savetofile += "\" + lstr_attachment.extension + " File"
						end if
					end if
					ls_savetofile += "_" + string(lstr_attachment.attachment_id)
					ls_savetofile += "_" + string(lstr_attachment.attachment_date, "yyyymmdd")
					ls_savetofile += "." + lstr_attachment.extension
					current_patient.attachments.attachment_save_as(lstr_attachment.attachment_id, ls_savetofile)
					if send_to_printer then
						f_open_file_with_process(ls_savetofile, "Print", true, lul_process_id)
					end if
					f_please_wait_progress_bump(li_please_wait_index)
				next
		END CHOOSE
	end if
next


if send_to_printer and len(printer) > 0 then
	common_thread.set_default_printer()
end if

f_please_wait_close(li_please_wait_index)

return 1


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
string ls_presets
string lsa_preset[]
integer li_preset_count
string ls_left
string ls_right
string ls_find

setnull(ls_null)


popup_return.item_count = 1
popup_return.items[1] = "ERROR"

service = message.powerobjectparm

// Set the title and sizes
title = current_patient.id_line()

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
if len(ls_temp) > 0 then
	if right(ls_temp, 1) <> "\" then ls_temp += "\"
else
	ls_temp = "c:\temp\PatientCharts\"
end if
st_path.text = ls_temp

patient_subdir = sqlca.fn_string_to_identifier(current_patient.last_name)
if isnull(patient_subdir) then patient_subdir = ""

ls_temp = sqlca.fn_string_to_identifier(current_patient.first_name)
if len(ls_temp) > 0 then patient_subdir += "_" + ls_temp

if len(current_patient.billing_id) > 0 then
	ls_patient = current_patient.billing_id
else
	ls_patient = current_patient.cpr_id
end if
ls_temp = sqlca.fn_string_to_identifier(ls_patient)
if len(ls_temp) > 0 then patient_subdir += "_" + ls_temp

st_path_title.text = "Patient reports and attachments will be placed in the ~"\"
st_path_title.text += patient_subdir + "~" sub-directory in the following location:"


ls_temp = service.get_attribute("patient_reports")
ll_count = f_parse_string(ls_temp, ",", lsa_patient_reports)
for i = 1 to ll_count
	dw_perform.object.context_object[i] = "Patient"
	dw_perform.object.display_script_id[i] = long(lsa_patient_reports[i])
	dw_perform.object.description[i] = datalist.display_script_description(long(lsa_patient_reports[i]))
next

ls_temp = service.get_attribute("encounter_report")
if not isnull(ls_temp) then
	ll_row = dw_perform.insertrow(0)
	dw_perform.object.context_object[ll_row] = "Encounter"
	dw_perform.object.display_script_id[ll_row] = long(ls_temp)
	dw_perform.object.description[ll_row] = "Include Encounter Reports"
end if

ls_temp = service.get_attribute("attachment_report")
if not isnull(ls_temp) then
	ll_row = dw_perform.insertrow(0)
	dw_perform.object.context_object[ll_row] = "Patient"
	dw_perform.object.display_script_id[ll_row] = long(ls_temp)
	dw_perform.object.description[ll_row] = "Include Attachment List"
end if

ll_row = dw_perform.insertrow(0)
dw_perform.object.context_object[ll_row] = "Attachment"
dw_perform.object.description[ll_row] = "Include Attachments"

// Set any presets that were passed in
ls_presets = service.get_attribute("script_presets")
if len(ls_presets) > 0 then
	li_preset_count = f_parse_string(ls_presets, ",", lsa_preset)
	for i = 1 to li_preset_count
		f_split_string(lsa_preset[i], "=", ls_left, ls_right)
		if long(ls_left) > 0 then
			ls_find = "display_script_id=" + ls_left
		else
			ls_find = "isnull(display_script_id)"
		end if
		ll_row = dw_perform.find(ls_find, 0, dw_perform.rowcount())
		if ll_row > 0 then
			dw_perform.object.perform_flag[ll_row] = long(ls_right)
		end if
	next
end if

service.get_attribute("export_to_files", export_to_files, true)
service.get_attribute("send_to_printer", send_to_printer, false)
service.get_attribute("printer", printer)
service.get_attribute("print_separator_page", print_separator_page, false)
separator_page_display_script_id = long(service.get_attribute("separator_page_display_script_id"))

ole_rtf.set_view_mode("page")

service.get_attribute("auto_perform", auto_perform)
if auto_perform or gnv_app.cpr_mode = "SERVER" then
	visible = false
	cb_finished.EVENT post clicked()
end if


end event

on w_svc_chart_export.create
int iCurrent
call super::create
this.st_title=create st_title
this.cb_finished=create cb_finished
this.st_path=create st_path
this.st_billing_title=create st_billing_title
this.st_path_title=create st_path_title
this.cb_pick_location=create cb_pick_location
this.dw_perform=create dw_perform
this.cb_cancel=create cb_cancel
this.ole_rtf=create ole_rtf
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.cb_finished
this.Control[iCurrent+3]=this.st_path
this.Control[iCurrent+4]=this.st_billing_title
this.Control[iCurrent+5]=this.st_path_title
this.Control[iCurrent+6]=this.cb_pick_location
this.Control[iCurrent+7]=this.dw_perform
this.Control[iCurrent+8]=this.cb_cancel
this.Control[iCurrent+9]=this.ole_rtf
end on

on w_svc_chart_export.destroy
call super::destroy
destroy(this.st_title)
destroy(this.cb_finished)
destroy(this.st_path)
destroy(this.st_billing_title)
destroy(this.st_path_title)
destroy(this.cb_pick_location)
destroy(this.dw_perform)
destroy(this.cb_cancel)
destroy(this.ole_rtf)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_svc_chart_export
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_chart_export
end type

type st_title from statictext within w_svc_chart_export
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
string text = "Export Patient Chart"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_finished from commandbutton within w_svc_chart_export
integer x = 2441
integer y = 1680
integer width = 443
integer height = 108
integer taborder = 150
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Export"
end type

event clicked;str_popup_return popup_return
integer li_sts
string ls_path

li_sts = dump_patient()

if auto_perform or gnv_app.cpr_mode = "SERVER" then
	if li_sts <= 0 then
		log.log(this, "w_svc_chart_export.cb_finished.clicked:0009", "Export Patient Chart Failed (" + service.cpr_id + ")", 4)
		popup_return.item_count = 1
		popup_return.items[1] = "ERROR"
	else
		popup_return.item_count = 1
		popup_return.items[1] = "OK"
	end if
else
	if li_sts <= 0 then
		openwithparm(w_pop_message, "Export Patient Chart Failed")
		return
	else
		openwithparm(w_pop_message, "Export Patient Chart Succeeded")
	end if
	
	popup_return.item_count = 1
	popup_return.items[1] = "OK"
end if


closewithreturn(parent, popup_return)

end event

type st_path from statictext within w_svc_chart_export
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

type st_billing_title from statictext within w_svc_chart_export
integer x = 955
integer y = 464
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

type st_path_title from statictext within w_svc_chart_export
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

type cb_pick_location from commandbutton within w_svc_chart_export
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

type dw_perform from u_dw_pick_list within w_svc_chart_export
integer x = 745
integer y = 568
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

type cb_cancel from commandbutton within w_svc_chart_export
integer x = 41
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

type ole_rtf from u_rich_text_edit within w_svc_chart_export
boolean visible = false
integer x = 123
integer y = 560
integer width = 2610
integer height = 1028
integer taborder = 21
boolean process_local = true
end type

