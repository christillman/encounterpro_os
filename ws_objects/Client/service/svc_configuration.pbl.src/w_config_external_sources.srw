$PBExportHeader$w_config_external_sources.srw
forward
global type w_config_external_sources from w_window_base
end type
type st_title from statictext within w_config_external_sources
end type
type dw_external_sources from u_dw_pick_list within w_config_external_sources
end type
type pb_up from u_picture_button within w_config_external_sources
end type
type pb_down from u_picture_button within w_config_external_sources
end type
type cb_finished from commandbutton within w_config_external_sources
end type
type cb_be_back from commandbutton within w_config_external_sources
end type
type cb_cancel from commandbutton within w_config_external_sources
end type
type st_external_sources_title from statictext within w_config_external_sources
end type
type st_page from statictext within w_config_external_sources
end type
type dw_computers from u_dw_pick_list within w_config_external_sources
end type
type st_computers_title from statictext within w_config_external_sources
end type
type pb_up_c from u_picture_button within w_config_external_sources
end type
type pb_down_c from u_picture_button within w_config_external_sources
end type
type st_page_c from statictext within w_config_external_sources
end type
type st_office_title from statictext within w_config_external_sources
end type
type st_office from statictext within w_config_external_sources
end type
end forward

global type w_config_external_sources from w_window_base
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_title st_title
dw_external_sources dw_external_sources
pb_up pb_up
pb_down pb_down
cb_finished cb_finished
cb_be_back cb_be_back
cb_cancel cb_cancel
st_external_sources_title st_external_sources_title
st_page st_page
dw_computers dw_computers
st_computers_title st_computers_title
pb_up_c pb_up_c
pb_down_c pb_down_c
st_page_c st_page_c
st_office_title st_office_title
st_office st_office
end type
global w_config_external_sources w_config_external_sources

type variables
u_component_service service
u_ds_data computer_sources
string this_office_id
long this_computer_id


end variables

forward prototypes
public function integer save_changes ()
public function integer display_computers ()
public subroutine display_external_sources ()
end prototypes

public function integer save_changes ();integer li_sts

li_sts = computer_sources.update()
if li_sts < 0 then return -1

return 1

end function

public function integer display_computers ();integer li_sts
string ls_find
long ll_row
integer li_page
string ls_temp
integer li_lastrowonpage

dw_computers.settransobject(sqlca)
li_sts = dw_computers.retrieve(this_office_id)
dw_computers.set_page(1, pb_up_c, pb_down_c, st_page_c)

// See if the current computer is in the list
li_page = 1
ls_find = "computer_id=" + string(computer_id)
ll_row = dw_computers.find(ls_find, 1, dw_computers.rowcount())
if ll_row > 0 then
	// If the current computer is in the list, then scroll down to it
	// and select it
	DO WHILE true
		ls_temp = dw_computers.describe("datawindow.lastrowonpage")
		li_lastrowonpage = integer(ls_temp)
		if li_lastrowonpage >= ll_row then exit
		
		li_page += 1
		dw_computers.set_page(li_page, pb_up_c, pb_down_c, st_page_c)
		if li_page >= dw_computers.last_page then exit
	LOOP
	dw_computers.object.selected_flag[ll_row] = 1
	this_computer_id = computer_id
else
	setnull(this_computer_id)
end if

display_external_sources()

return li_sts

end function

public subroutine display_external_sources ();integer li_sts
long i
string ls_computer_find
string ls_source_find
long ll_computer_row
long ll_source_row
long ll_computer_count
long ll_source_count


dw_external_sources.clear_selected(false)
dw_external_sources.last_page = 0
dw_external_sources.set_page(1, pb_up, pb_down, st_page)

if isnull(this_computer_id) then return

ll_computer_count = computer_sources.rowcount()
ll_source_count = dw_external_sources.rowcount()

// Show the existing ones as selected
ls_computer_find = "computer_id=" + string(this_computer_id)
ll_computer_row = computer_sources.find(ls_computer_find, 1, ll_computer_count)
DO WHILE ll_computer_row > 0 and ll_computer_row <= ll_computer_count
	ls_source_find = "external_source='" + string(computer_sources.object.external_source[ll_computer_row]) + "'"
	ll_source_row = dw_external_sources.find(ls_source_find, 1, ll_source_count)
	if ll_source_row > 0 then
		dw_external_sources.object.selected_flag[ll_source_row] = 1
	end if
	ll_computer_row = computer_sources.find(ls_computer_find, ll_computer_row + 1, ll_computer_count + 1)
LOOP


return

end subroutine

on w_config_external_sources.create
int iCurrent
call super::create
this.st_title=create st_title
this.dw_external_sources=create dw_external_sources
this.pb_up=create pb_up
this.pb_down=create pb_down
this.cb_finished=create cb_finished
this.cb_be_back=create cb_be_back
this.cb_cancel=create cb_cancel
this.st_external_sources_title=create st_external_sources_title
this.st_page=create st_page
this.dw_computers=create dw_computers
this.st_computers_title=create st_computers_title
this.pb_up_c=create pb_up_c
this.pb_down_c=create pb_down_c
this.st_page_c=create st_page_c
this.st_office_title=create st_office_title
this.st_office=create st_office
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.dw_external_sources
this.Control[iCurrent+3]=this.pb_up
this.Control[iCurrent+4]=this.pb_down
this.Control[iCurrent+5]=this.cb_finished
this.Control[iCurrent+6]=this.cb_be_back
this.Control[iCurrent+7]=this.cb_cancel
this.Control[iCurrent+8]=this.st_external_sources_title
this.Control[iCurrent+9]=this.st_page
this.Control[iCurrent+10]=this.dw_computers
this.Control[iCurrent+11]=this.st_computers_title
this.Control[iCurrent+12]=this.pb_up_c
this.Control[iCurrent+13]=this.pb_down_c
this.Control[iCurrent+14]=this.st_page_c
this.Control[iCurrent+15]=this.st_office_title
this.Control[iCurrent+16]=this.st_office
end on

on w_config_external_sources.destroy
call super::destroy
destroy(this.st_title)
destroy(this.dw_external_sources)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.cb_finished)
destroy(this.cb_be_back)
destroy(this.cb_cancel)
destroy(this.st_external_sources_title)
destroy(this.st_page)
destroy(this.dw_computers)
destroy(this.st_computers_title)
destroy(this.pb_up_c)
destroy(this.pb_down_c)
destroy(this.st_page_c)
destroy(this.st_office_title)
destroy(this.st_office)
end on

event open;call super::open;long ll_source_count
integer li_sts
integer ll_menu_id

service = message.powerobjectparm

// Set the title and sizes
If isvalid(current_patient) and not isnull(current_patient) Then
	title = current_patient.id_line()
End If

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

// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 4
end if

this_office_id = office_id
st_office.text = office_description

computer_sources = CREATE u_ds_data
computer_sources.set_dataobject("dw_o_computer_external_source")
computer_sources.retrieve()

dw_external_sources.settransobject(sqlca)
ll_source_count = dw_external_sources.retrieve()

this_office_id = office_id
display_computers()

	
end event

type pb_epro_help from w_window_base`pb_epro_help within w_config_external_sources
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_config_external_sources
end type

type st_title from statictext within w_config_external_sources
integer width = 2921
integer height = 116
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "External Sources Available By Computer"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_external_sources from u_dw_pick_list within w_config_external_sources
integer x = 1157
integer y = 252
integer width = 1577
integer height = 1312
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_external_source_list"
boolean border = false
boolean multiselect = true
end type

event selected(long selected_row);call super::selected;string ls_external_source
string ls_find
long ll_row

// Don't do anything if there isn't a current computer_id
if isnull(this_computer_id) then
	clear_selected()
	return
end if

ls_external_source = object.external_source[selected_row]
ls_find = "computer_id=" + string(this_computer_id)
ls_find += " and external_source='" + ls_external_source + "'"
ll_row = computer_sources.find(ls_find, 1, computer_sources.rowcount())
if ll_row > 0 then return

ll_row = computer_sources.insertrow(0)
computer_sources.object.computer_id[ll_row] = this_computer_id
computer_sources.object.external_source[ll_row] = ls_external_source


end event

event unselected(long unselected_row);call super::unselected;string ls_external_source
string ls_find
long ll_row

ls_external_source = object.external_source[unselected_row]
ls_find = "computer_id=" + string(this_computer_id)
ls_find += " and external_source='" + ls_external_source + "'"
ll_row = computer_sources.find(ls_find, 1, computer_sources.rowcount())
if ll_row > 0 then computer_sources.deleterow(ll_row)


end event

type pb_up from u_picture_button within w_config_external_sources
boolean visible = false
integer x = 2725
integer y = 260
integer width = 137
integer height = 116
integer taborder = 21
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_external_sources.current_page

dw_external_sources.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_config_external_sources
boolean visible = false
integer x = 2725
integer y = 388
integer width = 137
integer height = 116
integer taborder = 31
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_external_sources.current_page
li_last_page = dw_external_sources.last_page

dw_external_sources.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true
end event

type cb_finished from commandbutton within w_config_external_sources
integer x = 2427
integer y = 1612
integer width = 443
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;str_popup_return popup_return
integer li_sts

li_sts = save_changes()
if li_sts <= 0 then return

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)
end event

type cb_be_back from commandbutton within w_config_external_sources
integer x = 1961
integer y = 1612
integer width = 443
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
end type

event clicked;str_popup_return popup_return
integer li_sts

li_sts = save_changes()
if li_sts <= 0 then return

popup_return.item_count = 0
closewithreturn(parent, popup_return)

end event

type cb_cancel from commandbutton within w_config_external_sources
integer x = 46
integer y = 1612
integer width = 443
integer height = 108
integer taborder = 40
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

popup_return.item_count = 1
popup_return.items[1] = "CANCEL"

closewithreturn(parent, popup_return)

end event

type st_external_sources_title from statictext within w_config_external_sources
integer x = 1157
integer y = 156
integer width = 1577
integer height = 96
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 33538240
string text = "External Sources"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_page from statictext within w_config_external_sources
integer x = 2587
integer y = 192
integer width = 274
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99/99"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_computers from u_dw_pick_list within w_config_external_sources
integer x = 37
integer y = 456
integer width = 864
integer height = 1132
integer taborder = 21
boolean bringtotop = true
string dataobject = "dw_computer_pick_list"
boolean border = false
end type

event unselected(long unselected_row);call super::unselected;setnull(this_computer_id)
display_external_sources()

end event

event selected(long selected_row);call super::selected;
this_computer_id = object.computer_id[selected_row]
display_external_sources()

end event

type st_computers_title from statictext within w_config_external_sources
integer x = 37
integer y = 380
integer width = 864
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
string text = "Computers"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_up_c from u_picture_button within w_config_external_sources
boolean visible = false
integer x = 910
integer y = 464
integer width = 137
integer height = 116
integer taborder = 31
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_computers.current_page

dw_computers.set_page(li_page - 1, st_page_c.text)

if li_page <= 2 then enabled = false
pb_down_c.enabled = true

end event

type pb_down_c from u_picture_button within w_config_external_sources
boolean visible = false
integer x = 910
integer y = 592
integer width = 137
integer height = 116
integer taborder = 41
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_computers.current_page
li_last_page = dw_computers.last_page

dw_computers.set_page(li_page + 1, st_page_c.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up_c.enabled = true

end event

type st_page_c from statictext within w_config_external_sources
integer x = 773
integer y = 400
integer width = 274
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99/99"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_office_title from statictext within w_config_external_sources
integer x = 46
integer y = 140
integer width = 864
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Office"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_office from statictext within w_config_external_sources
integer x = 46
integer y = 220
integer width = 864
integer height = 132
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return


popup.dataobject = "dw_office_pick"
popup.datacolumn = 1
popup.displaycolumn = 2
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

this_office_id = popup_return.items[1]
text = popup_return.descriptions[1]

display_computers()


end event

