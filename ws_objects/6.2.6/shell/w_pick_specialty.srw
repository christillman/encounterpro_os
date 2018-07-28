HA$PBExportHeader$w_pick_specialty.srw
forward
global type w_pick_specialty from w_window_base
end type
type st_specialty_t from statictext within w_pick_specialty
end type
type sle_filter from singlelineedit within w_pick_specialty
end type
type dw_all_specialties from u_dw_pick_list within w_pick_specialty
end type
type cb_cancel from commandbutton within w_pick_specialty
end type
type st_title from statictext within w_pick_specialty
end type
type cb_all_specialties from commandbutton within w_pick_specialty
end type
type cb_show_all from commandbutton within w_pick_specialty
end type
type st_short_list_title from statictext within w_pick_specialty
end type
end forward

global type w_pick_specialty from w_window_base
integer width = 2057
integer height = 1912
string title = "Consultant Search"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_specialty_t st_specialty_t
sle_filter sle_filter
dw_all_specialties dw_all_specialties
cb_cancel cb_cancel
st_title st_title
cb_all_specialties cb_all_specialties
cb_show_all cb_show_all
st_short_list_title st_short_list_title
end type
global w_pick_specialty w_pick_specialty

type variables
string specialty_id

boolean filtering

string filter

boolean show_all
string show_edit

end variables

forward prototypes
public function integer refresh ()
public subroutine set_filter ()
public subroutine add_filter_letter (string ps_letter)
public subroutine set_filter_selected (long ll_row)
end prototypes

public function integer refresh ();long ll_rows
string ls_show_edit

if show_all then
	cb_show_all.text = "Show Short"
	if user_list.is_user_privileged(current_scribe.user_id, "Edit Common Short Lists") then
		ls_show_edit = "Y"
	else
		ls_show_edit = "N"
	end if
else
	cb_show_all.text = "Show All"
	ls_show_edit = "N"
end if

if ls_show_edit = "Y" then
	st_short_list_title.visible = true
	dw_all_specialties.width = 2039
else
	st_short_list_title.visible = false
	dw_all_specialties.width = 1499
end if

st_title.width = dw_all_specialties.width
cb_cancel.x = dw_all_specialties.x + dw_all_specialties.width - cb_cancel.width - 20
width = dw_all_specialties.x + dw_all_specialties.width + 32

dw_all_specialties.settransobject(sqlca)
if show_all then
	dw_all_specialties.setfilter("")
else
	dw_all_specialties.setfilter("short_list='Y'")
end if
ll_rows = dw_all_specialties.retrieve(ls_show_edit)

if ll_rows < 0 then return -1

Return 1

end function

public subroutine set_filter ();string ls_filter
string ls_description
integer li_len

li_len = len(filter)

if li_len > 0 then
	ls_filter = "lower(description) like '" + lower(filter) + "%'"
else
	ls_filter = ""
end if

dw_all_specialties.setfilter(ls_filter)
dw_all_specialties.filter()

if li_len > 0 then
	if dw_all_specialties.rowcount() > 0 then
		dw_all_specialties.clear_selected()
		dw_all_specialties.object.selected_flag[1] = 1
		set_filter_selected(1)
	end if
end if

filtering = false

end subroutine

public subroutine add_filter_letter (string ps_letter);filter += ps_letter
set_filter( )

end subroutine

public subroutine set_filter_selected (long ll_row);string ls_description
integer li_len

return

li_len = len(filter)

ls_description = dw_all_specialties.object.description[ll_row]
sle_filter.text = ls_description
sle_filter.selecttext(li_len + 1, len(ls_description) - li_len)


end subroutine

event open;call super::open;long ll_temp
string ls_all_specialties

if isvalid(main_window) then
	ll_temp = ( main_window.width - width ) / 2
	x = main_window.x + ll_temp
	
	ll_temp = ( main_window.height - height ) / 2
	y = main_window.y + ll_temp
end if

ls_all_specialties = message.stringparm
if len(ls_all_specialties) > 0 then
	cb_all_specialties.visible = true
	cb_all_specialties.text = ls_all_specialties
else
	cb_all_specialties.visible = false
end if

refresh()

end event

on w_pick_specialty.create
int iCurrent
call super::create
this.st_specialty_t=create st_specialty_t
this.sle_filter=create sle_filter
this.dw_all_specialties=create dw_all_specialties
this.cb_cancel=create cb_cancel
this.st_title=create st_title
this.cb_all_specialties=create cb_all_specialties
this.cb_show_all=create cb_show_all
this.st_short_list_title=create st_short_list_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_specialty_t
this.Control[iCurrent+2]=this.sle_filter
this.Control[iCurrent+3]=this.dw_all_specialties
this.Control[iCurrent+4]=this.cb_cancel
this.Control[iCurrent+5]=this.st_title
this.Control[iCurrent+6]=this.cb_all_specialties
this.Control[iCurrent+7]=this.cb_show_all
this.Control[iCurrent+8]=this.st_short_list_title
end on

on w_pick_specialty.destroy
call super::destroy
destroy(this.st_specialty_t)
destroy(this.sle_filter)
destroy(this.dw_all_specialties)
destroy(this.cb_cancel)
destroy(this.st_title)
destroy(this.cb_all_specialties)
destroy(this.cb_show_all)
destroy(this.st_short_list_title)
end on

event key;call super::key;long ll_row
string ls_specialty_id

CHOOSE CASE key
	CASE KeyEnter!
		ll_row = dw_all_specialties.get_selected_row()
		if ll_row > 0 then
			ls_specialty_id = dw_all_specialties.object.specialty_id[ll_row]
			closewithreturn(this, ls_specialty_id)
		end if
	CASE KeyDownArrow!
		ll_row = dw_all_specialties.get_selected_row()
		if ll_row > 0 and ll_row < dw_all_specialties.rowcount() then
			dw_all_specialties.object.selected_flag[ll_row] = 0
			ll_row += 1
			dw_all_specialties.object.selected_flag[ll_row] = 1
			this.function POST set_filter_selected(ll_row)
		end if
	CASE KeyUpArrow!
		ll_row = dw_all_specialties.get_selected_row()
		if ll_row > 1  then
			dw_all_specialties.object.selected_flag[ll_row] = 0
			ll_row -= 1
			dw_all_specialties.object.selected_flag[ll_row] = 1
			this.function POST set_filter_selected(ll_row)
		end if
	CASE KeyPageUp!
		dw_all_specialties.scrollpriorpage( )
		ll_row = dw_all_specialties.Object.DataWindow.LastRowOnPage
		if ll_row > 0 then
			dw_all_specialties.clear_selected()
			dw_all_specialties.object.selected_flag[ll_row] = 1
		end if
	CASE KeyPageDown!
		dw_all_specialties.scrollnextpage( )
		if ll_row > 0 then
			dw_all_specialties.clear_selected()
			dw_all_specialties.object.selected_flag[ll_row] = 1
		end if
END CHOOSE


end event

type pb_epro_help from w_window_base`pb_epro_help within w_pick_specialty
integer x = 2679
integer y = 164
integer taborder = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pick_specialty
end type

type st_specialty_t from statictext within w_pick_specialty
integer x = 5
integer y = 144
integer width = 201
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Filter:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_filter from singlelineedit within w_pick_specialty
event key_up pbm_keyup
integer x = 224
integer y = 132
integer width = 832
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event key_up;if filter <> this.text then
	filter = this.text
	set_filter()
end if
end event

type dw_all_specialties from u_dw_pick_list within w_pick_specialty
integer y = 228
integer width = 1499
integer height = 1432
integer taborder = 0
boolean bringtotop = true
string dataobject = "dw_specialty_pick_list"
boolean vscrollbar = true
boolean border = false
boolean select_computed = false
end type

event computed_clicked;call super::computed_clicked;string ls_specialty_id
string ls_description
string ls_short_list
str_popup_return popup_return
integer li_sts

ls_specialty_id = dw_all_specialties.object.specialty_id[clicked_row]
ls_description = dw_all_specialties.object.description[clicked_row]
ls_short_list = dw_all_specialties.object.short_list[clicked_row]

if ls_short_list = "Y" then
	openwithparm(w_pop_pick, "Remove ~"" + ls_description + "~" from specialty short list?")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return
	dw_all_specialties.object.short_list[clicked_row] = "N"
else
	openwithparm(w_pop_pick, "Add ~"" + ls_description + "~" to specialty short list?")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return
	dw_all_specialties.object.short_list[clicked_row] = "Y"
end if

li_sts = dw_all_specialties.update()
if li_sts < 0 then return

dw_all_specialties.filter()

end event

event buttonclicked;call super::buttonclicked;integer li_sts

if dwo.name = "b_add" then
	dw_all_specialties.object.short_list[row] = "Y"
else
	dw_all_specialties.object.short_list[row] = "N"
end if

dw_all_specialties.object.selected_flag[row] = 0

li_sts = dw_all_specialties.update()
if li_sts < 0 then return


end event

event selected;call super::selected;string ls_specialty_id

// Don't process the selection if a button was clicked
if left(lastcolumnname, 2) = "b_" then return

ls_specialty_id = object.specialty_id[selected_row]
closewithreturn(parent, ls_specialty_id)

end event

type cb_cancel from commandbutton within w_pick_specialty
integer x = 1614
integer y = 1700
integer width = 402
integer height = 112
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

event clicked;string ls_specialty_id

setnull(ls_specialty_id)

closewithreturn(parent, ls_specialty_id)


end event

type st_title from statictext within w_pick_specialty
integer width = 2039
integer height = 100
boolean bringtotop = true
integer textsize = -14
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Select Specialty"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_all_specialties from commandbutton within w_pick_specialty
integer x = 18
integer y = 1700
integer width = 713
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<All>"
end type

event clicked;closewithreturn(parent, text)


end event

type cb_show_all from commandbutton within w_pick_specialty
integer x = 1074
integer y = 132
integer width = 361
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Show Short"
end type

event clicked;show_all = not show_all
refresh()

end event

type st_short_list_title from statictext within w_pick_specialty
integer x = 1486
integer y = 148
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 33538240
string text = "Short List"
alignment alignment = center!
boolean focusrectangle = false
end type

