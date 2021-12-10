$PBExportHeader$w_pop_printer_edit.srw
forward
global type w_pop_printer_edit from w_window_base
end type
type st_chars from statictext within w_pop_printer_edit
end type
type sle_display_name from singlelineedit within w_pop_printer_edit
end type
type st_max_length from statictext within w_pop_printer_edit
end type
type cb_ok from commandbutton within w_pop_printer_edit
end type
type st_title from statictext within w_pop_printer_edit
end type
type st_printer from statictext within w_pop_printer_edit
end type
type st_1 from statictext within w_pop_printer_edit
end type
type st_fax_title from statictext within w_pop_printer_edit
end type
type st_type_printer from statictext within w_pop_printer_edit
end type
type st_type_fax from statictext within w_pop_printer_edit
end type
type cb_cancel from commandbutton within w_pop_printer_edit
end type
end forward

global type w_pop_printer_edit from w_window_base
integer x = 402
integer y = 232
integer width = 2185
integer height = 928
boolean titlebar = false
string title = ""
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
st_chars st_chars
sle_display_name sle_display_name
st_max_length st_max_length
cb_ok cb_ok
st_title st_title
st_printer st_printer
st_1 st_1
st_fax_title st_fax_title
st_type_printer st_type_printer
st_type_fax st_type_fax
cb_cancel cb_cancel
end type
global w_pop_printer_edit w_pop_printer_edit

type variables
integer max_length
string fax_flag
end variables

event open;call super::open;// Parameters (popup.):
// title					Screen title/user instructions
// item					Default string value
//	data_row_count		Number of items in the canned selections list
// items[]				list of canned selections
// argument_count		Number of top_20 arguments supplied
// argument[]			List of top_20 arguments
//							argument[1] = specific top_20_code
//							argument[2] = generic top_20_code
// multiselect			True = Allow empty string
//							False = Don't allow empty string
// displaycolumn		Max Length


st_printer.text = message.stringparm

if gnv_app.cpr_mode = "SERVER" then
	close(this)
	return
end if

SELECT display_name, fax_flag
INTO :sle_display_name.text, :fax_flag
FROM o_Computer_Printer
WHERE computer_id = 0
AND printer = :st_printer.text;
if not tf_check() then
	close(this)
	return
end if
if sqlca.sqlnrows = 0 then
	log.log(this, "w_pop_printer_edit:open", "Printer not found (" +st_printer.text + ")" , 4)
	close(this)
	return
end if

max_length = 64

if max_length > 0 then
	st_max_length.text = "Max Length = " + string(max_length) + " Characters"
else
	st_max_length.visible = false
	st_chars.visible = false
end if

if fax_flag = "Y" then
	st_type_fax.backcolor = color_object_selected
else
	st_type_printer.backcolor = color_object_selected
end if



end event

on w_pop_printer_edit.create
int iCurrent
call super::create
this.st_chars=create st_chars
this.sle_display_name=create sle_display_name
this.st_max_length=create st_max_length
this.cb_ok=create cb_ok
this.st_title=create st_title
this.st_printer=create st_printer
this.st_1=create st_1
this.st_fax_title=create st_fax_title
this.st_type_printer=create st_type_printer
this.st_type_fax=create st_type_fax
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_chars
this.Control[iCurrent+2]=this.sle_display_name
this.Control[iCurrent+3]=this.st_max_length
this.Control[iCurrent+4]=this.cb_ok
this.Control[iCurrent+5]=this.st_title
this.Control[iCurrent+6]=this.st_printer
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.st_fax_title
this.Control[iCurrent+9]=this.st_type_printer
this.Control[iCurrent+10]=this.st_type_fax
this.Control[iCurrent+11]=this.cb_cancel
end on

on w_pop_printer_edit.destroy
call super::destroy
destroy(this.st_chars)
destroy(this.sle_display_name)
destroy(this.st_max_length)
destroy(this.cb_ok)
destroy(this.st_title)
destroy(this.st_printer)
destroy(this.st_1)
destroy(this.st_fax_title)
destroy(this.st_type_printer)
destroy(this.st_type_fax)
destroy(this.cb_cancel)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_pop_printer_edit
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pop_printer_edit
end type

type st_chars from statictext within w_pop_printer_edit
integer x = 1605
integer y = 512
integer width = 402
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "999 Characters"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_display_name from singlelineedit within w_pop_printer_edit
integer x = 55
integer y = 416
integer width = 1952
integer height = 96
integer taborder = 1
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type st_max_length from statictext within w_pop_printer_edit
integer x = 64
integer y = 512
integer width = 713
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Max Length = 64 Characters"
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_pop_printer_edit
integer x = 1728
integer y = 748
integer width = 361
integer height = 112
integer taborder = 21
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;
if isnull(sle_display_name.text) or trim(sle_display_name.text) = "" then
	sle_display_name.text = left(st_printer.text, 64)
end if

UPDATE o_Computer_Printer
SET display_name = :sle_display_name.text,
	fax_flag = :fax_flag
WHERE computer_id = 0
AND printer = :st_printer.text;
if not tf_check() then return

close(parent)

end event

type st_title from statictext within w_pop_printer_edit
integer width = 2158
integer height = 124
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "Printer Properties"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_printer from statictext within w_pop_printer_edit
integer y = 164
integer width = 2158
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Printer"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_pop_printer_edit
integer x = 64
integer y = 340
integer width = 439
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Display Name"
boolean focusrectangle = false
end type

type st_fax_title from statictext within w_pop_printer_edit
integer x = 471
integer y = 628
integer width = 279
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "This is a"
boolean focusrectangle = false
end type

type st_type_printer from statictext within w_pop_printer_edit
integer x = 741
integer y = 620
integer width = 311
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Printer"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;fax_flag = "N"
backcolor = color_object_selected
st_type_fax.backcolor = color_object

end event

type st_type_fax from statictext within w_pop_printer_edit
integer x = 1093
integer y = 620
integer width = 311
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Fax"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;fax_flag = "Y"
backcolor = color_object_selected
st_type_printer.backcolor = color_object

end event

type cb_cancel from commandbutton within w_pop_printer_edit
integer x = 41
integer y = 748
integer width = 361
integer height = 112
integer taborder = 31
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

event clicked;

close(parent)

end event

