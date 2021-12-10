$PBExportHeader$w_configure_printers.srw
forward
global type w_configure_printers from w_window_base
end type
type dw_printers from u_dw_pick_list within w_configure_printers
end type
type cb_finished from commandbutton within w_configure_printers
end type
type st_title from statictext within w_configure_printers
end type
type st_1 from statictext within w_configure_printers
end type
type st_2 from statictext within w_configure_printers
end type
type dw_offices from u_dw_pick_list within w_configure_printers
end type
type st_3 from statictext within w_configure_printers
end type
type cb_select_all from commandbutton within w_configure_printers
end type
type cb_clear_all from commandbutton within w_configure_printers
end type
type cb_1 from commandbutton within w_configure_printers
end type
end forward

global type w_configure_printers from w_window_base
integer width = 2935
integer height = 1912
string title = "Consultant Search"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
dw_printers dw_printers
cb_finished cb_finished
st_title st_title
st_1 st_1
st_2 st_2
dw_offices dw_offices
st_3 st_3
cb_select_all cb_select_all
cb_clear_all cb_clear_all
cb_1 cb_1
end type
global w_configure_printers w_configure_printers

type variables
string specialty_id

boolean filtering

string filter

boolean show_all
string show_edit

end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();long ll_count

ll_count = dw_printers.retrieve()
if ll_count > 0 then
	dw_printers.object.selected_flag[1] = 1
	dw_printers.event POST selected(1)
end if

return 1


end function

event open;call super::open;
dw_printers.object.display_name.width = dw_printers.width - 250
dw_offices.object.description.width = dw_offices.width - 100


dw_printers.settransobject(sqlca)
dw_offices.settransobject(sqlca)

refresh()

end event

on w_configure_printers.create
int iCurrent
call super::create
this.dw_printers=create dw_printers
this.cb_finished=create cb_finished
this.st_title=create st_title
this.st_1=create st_1
this.st_2=create st_2
this.dw_offices=create dw_offices
this.st_3=create st_3
this.cb_select_all=create cb_select_all
this.cb_clear_all=create cb_clear_all
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_printers
this.Control[iCurrent+2]=this.cb_finished
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.dw_offices
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.cb_select_all
this.Control[iCurrent+9]=this.cb_clear_all
this.Control[iCurrent+10]=this.cb_1
end on

on w_configure_printers.destroy
call super::destroy
destroy(this.dw_printers)
destroy(this.cb_finished)
destroy(this.st_title)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.dw_offices)
destroy(this.st_3)
destroy(this.cb_select_all)
destroy(this.cb_clear_all)
destroy(this.cb_1)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_configure_printers
integer x = 3099
integer y = 52
integer taborder = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_configure_printers
integer y = 1636
end type

type dw_printers from u_dw_pick_list within w_configure_printers
integer x = 41
integer y = 312
integer width = 1550
integer height = 1320
integer taborder = 0
boolean bringtotop = true
string dataobject = "dw_server_printers_small"
boolean vscrollbar = true
boolean border = false
boolean select_computed = false
end type

event selected;call super::selected;string ls_printer

ls_printer = object.printer[selected_row]

dw_offices.retrieve(ls_printer)


end event

event clicked;call super::clicked;string ls_printer
string ls_display_name
string ls_fax_flag

if lastcolumnname = "b_edit" then
	object.selected_flag[row] = 1
	
	ls_printer = object.printer[row]
	if len(ls_printer) > 0 then
		openwithparm(w_pop_printer_edit, ls_printer)
		
		SELECT display_name, fax_flag
		INTO :ls_display_name, :ls_fax_flag
		FROM o_Computer_Printer
		WHERE computer_id = 0
		AND printer = :ls_printer;
		if not tf_check() then return
		if sqlca.sqlnrows = 1 then
			object.display_name[row] = ls_display_name
			object.fax_flag[row] = ls_fax_flag
		end if
	end if
end if


end event

type cb_finished from commandbutton within w_configure_printers
integer x = 2469
integer y = 1692
integer width = 402
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
boolean default = true
end type

event clicked;close(parent)

end event

type st_title from statictext within w_configure_printers
integer width = 2926
integer height = 100
boolean bringtotop = true
integer textsize = -14
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Printer / Office Configuration"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_configure_printers
integer x = 50
integer y = 224
integer width = 1422
integer height = 88
boolean bringtotop = true
integer textsize = -14
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Server Printers"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_configure_printers
integer x = 1760
integer y = 224
integer width = 965
integer height = 88
boolean bringtotop = true
integer textsize = -14
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Offices"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_offices from u_dw_pick_list within w_configure_printers
integer x = 1714
integer y = 312
integer width = 1138
integer height = 1284
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_office_printer_availability"
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;string ls_allow_flag

if row > 0 then
	ls_allow_flag = object.allow_flag[row]
	if ls_allow_flag = "Y" then
		object.allow_flag[row] = "N"
	else
		object.allow_flag[row] = "Y"
	end if
	
	update()
end if

end event

type st_3 from statictext within w_configure_printers
integer x = 219
integer y = 116
integer width = 2491
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Select a printer, then highlight the offices in which that printer should be available"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_select_all from commandbutton within w_configure_printers
integer x = 1915
integer y = 1612
integer width = 315
integer height = 68
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select All"
end type

event clicked;long ll_count
long i

ll_count = dw_offices.rowcount()

for i = 1 to ll_count
	dw_offices.object.allow_flag[i] = "Y"
next

dw_offices.update()

end event

type cb_clear_all from commandbutton within w_configure_printers
integer x = 2322
integer y = 1612
integer width = 315
integer height = 68
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear All"
end type

event clicked;long ll_count
long i

ll_count = dw_offices.rowcount()

for i = 1 to ll_count
	dw_offices.object.allow_flag[i] = "N"
next

dw_offices.update()

end event

type cb_1 from commandbutton within w_configure_printers
integer x = 41
integer y = 1704
integer width = 919
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Show Printers For This Client"
end type

event clicked;str_printers lstr_printers
str_popup popup
long i

lstr_printers = common_thread.get_printers()

if lstr_printers.printer_count <= 0 then
	openwithparm(w_pop_message, "There are no printers defined on this client computer")
	return
end if

for i = 1 to lstr_printers.printer_count
	popup.items[i] = lstr_printers.printers[i].printername
next
popup.data_row_count = lstr_printers.printer_count
popup.display_only = true
popup.dataobject = "dw_pick_generic_wide"
openwithparm(w_pop_pick, popup)

end event

