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
boolean controlmenu = false
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
if auto_perform or cpr_mode = "SERVER" then
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
long backcolor = 33538240
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

if auto_perform or cpr_mode = "SERVER" then
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
long backcolor = 33538240
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
long backcolor = 33538240
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


Start of PowerBuilder Binary Data Section : Do NOT Edit
0Bw_svc_chart_export.bin 
2E000000000000000b00001600e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd00000008fffffffe0000000400000005000000060000000700000009fffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff0000000300000000000000000000000000000000000000000000000000000000984507a001ca361e0000000300000bc00000000000500003004c004200430049004e0045004500530045004b000000590000000000000000000000000000000000000000000000000000000000000000000000000002001cffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000001a0000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000002001affffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000001000007d900000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000101001a000000020000000100000004ab949ac111d9ec9740002b9ed2aba90500000000984507a001ca361e984507a001ca361e000000000000000000000000fffffffe00000002000000030000000400000005000000060000000700000008000000090000000a0000000b0000000c0000000d0000000e0000000f000000100000001100000012000000130000001400000015000000160000001700000018000000190000001a0000001b0000001c0000001d0000001e0000001f00000020fffffffe00000022000000230000002400000025000000260000002700000028000000290000002a0000002b0000002c0000002d0000002efffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
27000000ffffffffff0000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff005000540039002d0034003400320037003800340039003500430034005c003a004d004a005c004a00630069006e006f003b00730043003b005c003a004900570000fffe00020205ab949ac111d9ec9740002b9ed2aba90500000001fb8f0821101b01640008ed8413c72e2b00000030000007a90000003600000100000001b800000101000001c000000102000001c800000103000001d000000104000001d800000105000001e000000106000001e800000107000001f000000108000001f800000109000002000000010a000002080000010b000002100000010c000002180000010d000002200000010e000002280000010f000002300000011000000238000001110000024000000112000002480000011300000250000001140000028c0000011500000294000001160000029c00000117000002a400000118000002ac00000119000002b40000011a000002bc0000011b000002c40000011c000002cc0000011d000002d40000011e000002dc0000011f000002ec00000120000002f400000121000002fc0000012200000304000001230000030c0000012400000314000001250000031c0000012600000324000001270000032c0000012800000334000001290000033c0000012a000003440000012b0000034c0000012c000003540000012d0000035c0000012e000003640000012f0000036c0000013000000374000001310000037c00000132000003880000013300000390000001340000039800000000000003a000000003000100070000000300003b040000000300001a9000000003000000490000000200000001000000020000000100000002000000010000000b0000000000000002000000000000000b0000ffff0000000b0000ffff0000000200000000000000020000006400000002000000000000000b000000000000000b0000ffff00000002000000000000000b0000ffff0000000b000000000000000800000031505c3a4352474f525c317e4149454854317e414d5458545c7e5458455c302e335c6e694252454d414e4143494454562e0000000000000002000000030000000300002fd00000000300003de000000003000005a000000003000005a000000003000005a000000003000005a000000002000000640000000b000000000000000b0000ffff0000000800000006616972410000006c000000020000000c0000000b000000000000000b000000000000000b000000000000000b0000000000000002000000000000000300ffffff0000000200000000000000020000006400000002000000000000000200000020000000020000000000000002000000140000000200000000000000020000000000000002000000000000000200000000000000020000000000000008000000010000000000000002000000010000000b0000ffff0000000b0000ffff0000003600000000000000010001330000000a006c6c61006e75776f32006f640d000001770000007764726f6d7061720065646f00000112000000106d726f66657374617463656c006e6f69000001090000000e65646968656c65736f6974630108006e00090000646500006f6d7469280065640d0000016c00000073656e69696361700074676e000001190000000c656761706772616d00726e69000001070000000d746e6f63636c6f727372616800012d0000000800646e690072746e6500011e00000009006e6f66006d616e74011a0065000c000061700000616d65676e696772010e0062000d00006c6300006863706972646c6930006e6508000001690000006e65646e180062740c000001700000006d656761696772611500746e0a00000170000000776567616874646900010b0000000d00756f6d006f70657365746e6901060072000a00006162000074736b6300656c790000013400000015747865746d61726672616d656c72656b73656e6900012f0000000800646e690074746e650001270000000c006e696c0061707365676e696300010c0000000b006f6f7a006361666d00726f740000010a0000000e65736e696f697472646f6d6e012a0065000e00007266000064656d61617473690065636e000001130000001270737476646c6c656974636972616e6f01030079000c0000735f00006b636f74706f727001210073000b00006f6600007469746e63696c6100011000000009007a697300646f6d6501050065000c00006f620000726564726c79747301260065000a00006c6100006d6e676900746e65000001240000000965736162656e696c0001160000000b00676170006965686500746867000001250000000c747865746f636b6200726f6c000001230000000e746e6f6665646e756e696c7201220065000f00006f6600007473746e656b69727572687400011f00000009006e6f66007a69737401110065000700006174000079656b6200012b0000000f0061726600696c656d6977656e00687464000001290000000b6d617266797473650100656c090000015f000000657478650078746e0000012000000009746e6f66646c6f62000102000000090078655f00746e6574011d0079000c00007270000063746e69726f6c6f01170073000c000061700000616d65676e696772010d006c00090000697600006f6d77652c00656408000001690000006e65646e
282e006c740000000900016900000000006e65646e006c667400000131000000057478657400011c0000000c0069727000666f746e7465736600011b0000000a00697270006f7a746e14006d6f0b000001730000006c6f72637261626c0104007300090000616c00006175676e00006567090000015f00000073726576006e6f690000010f0000000d70696c636c62697373676e690000000000200029201fff1e000000240000001d0000000700000004000000010000000f000000370001000700003b0400001a90000000490000000000ffffff0100010100000100010100000064000001000000000100005c3a4330474f5250317e41524548545c7e414d4958545c3154584554302e337e6e69425c454d415c4143495254562e4e03000044002fd000003de0000005a0000005a0000005a0000005a00000006400724105010c6c616900000000ff0000000000ffff00006400000020000000140000000000000000000100000001010001000002ba000104b10000000e00000000000000000000000200000144000100010001000100000000000000000001001f00000001000000000000000000000000ff10500000000000019000000000000022020000616972410000006c0000000000000000000000000000000000000000000000000001000100000001000000000000000000640000001400206e01000008dc0104010d4a01260111b81a940116011f0201de0123702c4c01270130ba01960135283e0401390000000000000000000000000000000000720041006100690000006c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000210000036e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004e400010001010002092e000000ffffb70000000000000000000000000000000000000000010000000000000000000000000001000000000000000000000000000000000000000000000000015400000030000000000000000005a005a005a005a000ffffff0000000000000000000000010000000000000000000000000000012400000001ff10000000000000019000000000000022020000616972410000006c0000000000000000000000000000000000000000000000000000000000000000000000000000000000720041006100690000006c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000005000000000000000000000640000001400206e01000008dc0104010d4a01260111b81a940116011f0201de0123702c4c01270130ba01960135283e04013900010001010002092e000000ffffb7000000000000000000000000000000000000120000000000000000000000000000000000000000000000000000005b0000006f004e006d0072006c00610000005d002f0000003400320032002f00300030002000390800766400000000003a0030201fff1e000000240000001d0000000700000004000000010000000e0000003400000190000000000000006000000060fffc0020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2E0000000000000000000000000000000000000000000000000000000a000000000000000e00000000000000000000000a000000000000000000000000000000ec000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1Bw_svc_chart_export.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
