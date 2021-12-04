$PBExportHeader$w_ext_document_rtf.srw
forward
global type w_ext_document_rtf from w_window_base
end type
type cb_ok from commandbutton within w_ext_document_rtf
end type
type pb_up from u_picture_button within w_ext_document_rtf
end type
type pb_down from u_picture_button within w_ext_document_rtf
end type
type cb_edit from commandbutton within w_ext_document_rtf
end type
type st_display_script from statictext within w_ext_document_rtf
end type
type rte_report from u_rich_text_edit within w_ext_document_rtf
end type
type pb_print from picturebutton within w_ext_document_rtf
end type
type cb_cancel from commandbutton within w_ext_document_rtf
end type
end forward

global type w_ext_document_rtf from w_window_base
integer width = 2953
integer height = 1928
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
cb_ok cb_ok
pb_up pb_up
pb_down pb_down
cb_edit cb_edit
st_display_script st_display_script
rte_report rte_report
pb_print pb_print
cb_cancel cb_cancel
end type
global w_ext_document_rtf w_ext_document_rtf

type variables
u_component_document document

datetime file_updated
string temp_file

string view_mode = "Page"

string document_description

string document_extension = "rtf"

str_captured_signature captured_signature

end variables

forward prototypes
public function string get_report_title ()
public function integer save_to_temp_file ()
public function integer attach ()
public subroutine resize_objects ()
end prototypes

public function string get_report_title ();str_popup popup
str_popup_return popup_return
string ls_null

setnull(ls_null)

// Set the title
popup.title = "Please enter a report title or select one from the list below"

// Allow an empty string
popup.multiselect = true
popup.item = document.get_attribute("report_title")

popup.argument_count = 1
popup.argument[1] = "RPT|" + document.external_source

openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return ls_null

return popup_return.items[1]


end function

public function integer save_to_temp_file ();integer li_sts
str_file_attributes lstr_file
datetime ldt_updated

li_sts = rte_report.SaveDocument(temp_file)
if li_sts <= 0 then return -1

li_sts = log.file_attributes(temp_file, lstr_file)
if li_sts <= 0 then return -1

file_updated = datetime(lstr_file.lastwritedate, relativetime(lstr_file.lastwritetime, 1))

return 1


end function

public function integer attach ();str_attachment lstr_new_attachment
string ls_date_suffix
long ll_attachment_id
string ls_progress_type
integer li_sts

li_sts = save_to_temp_file()
if li_sts <= 0 then return -1

ls_date_suffix = "_" + string(today(), "yymmdd")

setnull(lstr_new_attachment.attachment_id)
lstr_new_attachment.extension = "rtf"
lstr_new_attachment.attachment_type = "FILE"
lstr_new_attachment.attachment_tag = get_report_title()
if isnull(lstr_new_attachment.attachment_tag) then
	openwithparm(w_pop_message, "You must enter a report title.  Report has NOT been attached.")
	return 0
end if

lstr_new_attachment.attachment_file = lstr_new_attachment.attachment_tag + ls_date_suffix
lstr_new_attachment.attachment_folder = document.get_attribute("attachment_folder")

setnull(lstr_new_attachment.attachment_text)
ls_progress_type = document.get_attribute("progress_type")

lstr_new_attachment.cpr_id = current_patient.cpr_id
document.get_attribute("treatment_id", lstr_new_attachment.treatment_id)
document.get_attribute("problem_id", lstr_new_attachment.problem_id)
document.get_attribute("encounter_id", lstr_new_attachment.encounter_id)
document.get_attribute("observation_sequence", lstr_new_attachment.observation_sequence)

ll_attachment_id = current_patient.attachments.new_attachment(lstr_new_attachment, temp_file, document.context_object, ls_progress_type)
if ll_attachment_id <= 0 then
	log.log(this, "w_ext_document_rtf.attach:0035", "Error creating attachment", 4)
	return -1
end if

openwithparm(w_pop_message, "Report was attached successfully.")

return 1

end function

public subroutine resize_objects ();
rte_report.width = width - 48
rte_report.height = height - 292

cb_cancel.y = height - 232
st_display_script.y = height - st_display_script.height - 100
pb_epro_help.y = cb_cancel.y
pb_print.y = cb_cancel.y
pb_up.y = cb_cancel.y
pb_down.y = cb_cancel.y
cb_edit.y = cb_cancel.y
cb_ok.y = cb_cancel.y

cb_ok.x = width - 648
pb_up.x = width - 1088
pb_down.x = width - 928


end subroutine

on w_ext_document_rtf.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.pb_up=create pb_up
this.pb_down=create pb_down
this.cb_edit=create cb_edit
this.st_display_script=create st_display_script
this.rte_report=create rte_report
this.pb_print=create pb_print
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.pb_up
this.Control[iCurrent+3]=this.pb_down
this.Control[iCurrent+4]=this.cb_edit
this.Control[iCurrent+5]=this.st_display_script
this.Control[iCurrent+6]=this.rte_report
this.Control[iCurrent+7]=this.pb_print
this.Control[iCurrent+8]=this.cb_cancel
end on

on w_ext_document_rtf.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.cb_edit)
destroy(this.st_display_script)
destroy(this.rte_report)
destroy(this.pb_print)
destroy(this.cb_cancel)
end on

event open;call super::open;str_external_observation_attachment lstr_document
boolean lb_full_screen
string ls_path
string ls_destination
long ll_line
string ls_temp
string ls_message
string ls_office_id
integer li_sts
long ll_display_script_id
string ls_printer
long ll_page_width
long ll_page_height

document = message.powerobjectparm


if not isnull(current_patient) then
	title = current_patient.id_line()
else
	title = "Document"
end if

if isnull(temp_file) or trim(temp_file) = "" then
	temp_file = f_temp_file("rtf")
end if

rte_report.reader_user_id = document.get_attribute("reader_user_id")

rte_report.set_background_color(rgb(255, 255, 255))

//if isnull(document.report_object) then
//	cb_attach.visible = false
//end if

//postevent("post_open")

//rte_report.width = width - 64
//rte_report.height = height - 282
//st_display_script.y = rte_report.y + rte_report.height + 4
//
//pb_epro_help.y = rte_report.y + rte_report.height + 28
//cb_print.y = pb_epro_help.y
//cb_edit.y = pb_epro_help.y
//cb_attach.y = pb_epro_help.y
//pb_up.y = pb_epro_help.y
//pb_down.y = pb_epro_help.y
//cb_ok.y = pb_epro_help.y
//cb_view.y = pb_epro_help.y
//
//cb_ok.x = width - cb_ok.width - 40
//pb_epro_help.x = cb_ok.x - pb_epro_help.width - 40
//pb_down.x = pb_epro_help.x - pb_down.width - 60
//pb_up.x = pb_down.x - pb_up.width - 28

//report.rtf = rte_report
rte_report.set_report_attributes(document.get_attributes())

//li_sts = do_template( )

view_mode = document.get_attribute("default_view_mode")
if isnull(view_mode) then view_mode = "Page"
rte_report.set_view_mode(view_mode)

document.get_attribute("display_script_id", ll_display_script_id)
if isnull(ll_display_script_id) then
	log.log(this, "w_ext_document_rtf:open", "No display script", 4)
	closewithreturn(this, "ERROR")
	return
end if

st_display_script.text = datalist.display_script_description(ll_display_script_id)

document_description = document.get_attribute("document_description")
if isnull(document_description) then
	document_description = st_display_script.text
end if
if isnull(document_description) then
	document_description = datalist.external_source_description(document.external_source)
end if

rte_report.goto_end_of_text()
rte_report.display_script(ll_display_script_id)

// Scroll back to the top
rte_report.goto_top()

if config_mode then
	st_display_script.visible = true
else
	st_display_script.visible = false
end if

this.function POST resize_objects()

end event

event timer;str_file_attributes lstr_file
integer li_sts
datetime ldt_updated
integer li_file

// Make sure file isn't locked
li_file = FileOpen(temp_file, LineMode!, Read!, LockReadWrite!, Append!)
if li_file < 0 then return
FileClose(li_file)

li_sts = log.file_attributes(temp_file, lstr_file)
if li_sts <= 0 then return

ldt_updated = datetime(lstr_file.lastwritedate, lstr_file.lastwritetime)
if ldt_updated > file_updated then
	li_sts = rte_report.load_document(temp_file)
	if li_sts > 0 then
		file_updated = datetime(lstr_file.lastwritedate, relativetime(lstr_file.lastwritetime, 1))
	end if
end if


end event

event resize;call super::resize;resize_objects()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_ext_document_rtf
boolean visible = true
integer x = 1051
integer y = 1604
integer height = 116
boolean originalsize = false
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_ext_document_rtf
end type

type cb_ok from commandbutton within w_ext_document_rtf
integer x = 2281
integer y = 1604
integer width = 594
integer height = 116
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Save Document"
end type

event clicked;blob lbl_rtf_file
integer li_sts
string ls_temp_file

ls_temp_file = f_temp_file(document_extension)

li_sts = rte_report.SaveDocument(ls_temp_file)
if li_sts <= 0 then 
	openwithparm(w_pop_message, "Error saving document")
	return
end if

li_sts = log.file_read(ls_temp_file, lbl_rtf_file)
if li_sts <= 0 then 
	openwithparm(w_pop_message, "Error saving document file")
	return
end if

document.observation_count = 1
document.observations[1].result_count = 0
document.observations[1].attachment_list.attachment_count = 1
document.observations[1].attachment_list.attachments[1].attachment_type = "FILE"
document.observations[1].attachment_list.attachments[1].extension = document_extension
document.observations[1].attachment_list.attachments[1].attachment_comment_title = document_description
document.observations[1].attachment_list.attachments[1].attachment = lbl_rtf_file

document.observations[1].attachment_list.attachments[1].attached_by_user_id = current_user.user_id

document.observations[1].attachment_list.attachments[1].captured_signature = captured_signature

closewithreturn(parent, "OK")

end event

type pb_up from u_picture_button within w_ext_document_rtf
integer x = 1829
integer y = 1604
integer width = 137
integer height = 116
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;rte_report.Scroll_up()
end event

type pb_down from u_picture_button within w_ext_document_rtf
integer x = 1989
integer y = 1604
integer width = 137
integer height = 116
integer taborder = 20
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;rte_report.Scroll_down()
end event

type cb_edit from commandbutton within w_ext_document_rtf
integer x = 1349
integer y = 1604
integer width = 137
integer height = 116
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Edit"
end type

event clicked;integer li_sts
string ls_command

li_sts = save_to_temp_file()
if li_sts <= 0 then return

ls_command = 'cmd /c start "' + document_description + '" "' + temp_file + '"'
run(ls_command)

//ole_control.initialize(temp_file, parent, false)
//
//ole_control.activate(OffSite!)



timer(2)

end event

type st_display_script from statictext within w_ext_document_rtf
integer x = 389
integer y = 1584
integer width = 613
integer height = 160
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean focusrectangle = false
end type

type rte_report from u_rich_text_edit within w_ext_document_rtf
integer x = 14
integer y = 20
integer width = 2912
integer height = 1560
integer taborder = 60
boolean bringtotop = true
boolean process_local = true
end type

event signature_captured;call super::signature_captured;captured_signature = pstr_captured_signature
end event

event field_clicked;call super::field_clicked;enable_window()

end event

type pb_print from picturebutton within w_ext_document_rtf
integer x = 1531
integer y = 1604
integer width = 137
integer height = 116
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "button33.bmp"
end type

event clicked;window lw_wait
string ls_printer

ls_printer = common_thread.select_printer()
// If the user didn't select a printer then don't do anything
if isnull(ls_printer) then return


open(lw_wait, "w_pop_please_wait", parent)

common_thread.set_printer(ls_printer)
rte_report.Print(1, "", false, true)
common_thread.set_default_printer()

close(lw_wait)

end event

type cb_cancel from commandbutton within w_ext_document_rtf
integer x = 23
integer y = 1604
integer width = 347
integer height = 116
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;closewithreturn(parent, "CANCEL")
end event


Start of PowerBuilder Binary Data Section : Do NOT Edit
07w_ext_document_rtf.bin 
2B00001600e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd00000008fffffffe0000000400000005000000060000000700000009fffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff0000000300000000000000000000000000000000000000000000000000000000ef67774001ca361c0000000300000bc00000000000500003004c004200430049004e0045004500530045004b000000590000000000000000000000000000000000000000000000000000000000000000000000000002001cffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000001a0000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000002001affffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000001000007d900000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000101001a000000020000000100000004ab949ac111d9ec9740002b9ed2aba90500000000ef67774001ca361cef67774001ca361c000000000000000000000000fffffffe00000002000000030000000400000005000000060000000700000008000000090000000a0000000b0000000c0000000d0000000e0000000f000000100000001100000012000000130000001400000015000000160000001700000018000000190000001a0000001b0000001c0000001d0000001e0000001f00000020fffffffe00000022000000230000002400000025000000260000002700000028000000290000002a0000002b0000002c0000002d0000002efffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
29ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff005000540039002d003400340032003700380034003900350072003400650073004c000000740065006500740020007200720054006e006100760073007200650000fffe00020205ab949ac111d9ec9740002b9ed2aba90500000001fb8f0821101b01640008ed8413c72e2b00000030000007a90000003600000100000001b800000101000001c000000102000001c800000103000001d000000104000001d800000105000001e000000106000001e800000107000001f000000108000001f800000109000002000000010a000002080000010b000002100000010c000002180000010d000002200000010e000002280000010f000002300000011000000238000001110000024000000112000002480000011300000250000001140000028c0000011500000294000001160000029c00000117000002a400000118000002ac00000119000002b40000011a000002bc0000011b000002c40000011c000002cc0000011d000002d40000011e000002dc0000011f000002ec00000120000002f400000121000002fc0000012200000304000001230000030c0000012400000314000001250000031c0000012600000324000001270000032c0000012800000334000001290000033c0000012a000003440000012b0000034c0000012c000003540000012d0000035c0000012e000003640000012f0000036c0000013000000374000001310000037c00000132000003880000013300000390000001340000039800000000000003a0000000030001000700000003000041d6000000030000284f00000003000000490000000200000001000000020000000100000002000000010000000b0000000000000002000000000000000b0000ffff0000000b0000ffff0000000200000000000000020000006400000002000000030000000b000000000000000b0000ffff00000002000000000000000b0000ffff0000000b000000000000000800000031505c3a4352474f525c317e4149454854317e414d5458545c7e5458455c302e335c6e694252454d414e4143494454562e0000000000000002000000030000000300002fd00000000300003de000000003000005a000000003000005a000000003000005a000000003000005a000000002000000640000000b000000000000000b0000ffff0000000800000006616972410000006c000000020000000c0000000b000000000000000b000000000000000b000000000000000b0000000000000002000000000000000300ffffff0000000200000000000000020000006400000002000000000000000200000020000000020000000000000002000000140000000200000000000000020000000000000002000000000000000200000000000000020000000000000008000000010000000000000002000000010000000b0000ffff0000000b0000ffff0000003600000000000000010001330000000a006c6c61006e75776f32006f640d000001770000007764726f6d7061720065646f00000112000000106d726f66657374617463656c006e6f69000001090000000e65646968656c65736f6974630108006e00090000646500006f6d7469280065640d0000016c00000073656e69696361700074676e000001190000000c656761706772616d00726e69000001070000000d746e6f63636c6f727372616800012d0000000800646e690072746e6500011e00000009006e6f66006d616e74011a0065000c000061700000616d65676e696772010e0062000d00006c6300006863706972646c6930006e6508000001690000006e65646e180062740c000001700000006d656761696772611500746e0a00000170000000776567616874646900010b0000000d00756f6d006f70657365746e6901060072000a00006162000074736b6300656c790000013400000015747865746d61726672616d656c72656b73656e6900012f0000000800646e690074746e650001270000000c006e696c0061707365676e696300010c0000000b006f6f7a006361666d00726f740000010a0000000e65736e696f697472646f6d6e012a0065000e00007266000064656d61617473690065636e000001130000001270737476646c6c656974636972616e6f01030079000c0000735f00006b636f74706f727001210073000b00006f6600007469746e63696c6100011000000009007a697300646f6d6501050065000c00006f620000726564726c79747301260065000a00006c6100006d6e676900746e65000001240000000965736162656e696c0001160000000b00676170006965686500746867000001250000000c747865746f636b6200726f6c000001230000000e746e6f6665646e756e696c7201220065000f00006f6600007473746e656b69727572687400011f00000009006e6f66007a69737401110065000700006174000079656b6200012b0000000f0061726600696c656d6977656e00687464000001290000000b6d617266797473650100656c090000015f000000657478650078746e0000012000000009746e6f66646c6f62000102000000090078655f00746e6574011d0079000c00007270000063746e69726f6c6f01170073000c000061700000616d65676e696772010d006c00090000697600006f6d77652c00656408000001690000006e65646e2e006c740900000169000000
2C6e65646e006c667400000131000000057478657400011c0000000c0069727000666f746e7465736600011b0000000a00697270006f7a746e14006d6f0b000001730000006c6f72637261626c0104007300090000616c00006175676e00006567090000015f00000073726576006e6f690000010f0000000d70696c636c62697373676e690000000000000000201fff1e000000240000001d0000000700000004000000010000000f0000003700010007000041d60000284f000000490000000000ffffff0100010100000100010100000064000001000003000100005c3a4330474f5250317e41524548545c7e414d4958545c3154584554302e337e6e69425c454d415c4143495254562e4e03000044002fd000003de0000005a0000005a0000005a0000005a00000006400724105010c6c616900000000ff0000000000ffff00006400000020000000140000000000000000000100000001010001000002ba000104b10000000e00000000000000000000000200000144000100010001000100000000000000000001001f00000001000000000000000000000000ff10500000000000019000000000000022020000616972410000006c0000000000000000000000000000000000000000000000000001000100000001000000000000000000640000001400206e01000008dc0104010d4a01260111b81a940116011f0201de0123702c4c01270130ba01960135283e0401390000000000000000000000000000000000720041006100690000006c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000210000036e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004e400010001010002092e000000ffffb70000000000000000000000000000000000000000010000000000000000000000000001000000000000000000000000000000000000000000000000015400000030000000000000000005a0000005a0000000ffffff0000000000000000000000010000000000000000000000000000012400000001ff10000000000000019000000000000022020000616972410000006c0000000000000000000000000000000000000000000000000000000000000000000000000000000000720041006100690000006c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000005000000000000000000000640000001400206e01000008dc0104010d4a01260111b81a940116011f0201de0123702c4c01270130ba01960135283e04013900010001010002092e000000ffffb7000000000000000000000000000000000000120000000000000000000000000000000000000000000000000000005b0000006f004e006d0072006c00610000005d0000000000000000000000000000000000000000080076640000000000000000201fff1e000000240000001d0000000700000004000000010000000e0000003400000190000000000000006000000060fffc002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17w_ext_document_rtf.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
