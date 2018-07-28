$PBExportHeader$w_pick_preference.srw
forward
global type w_pick_preference from w_window_base
end type
type st_specialty_t from statictext within w_pick_preference
end type
type sle_filter from singlelineedit within w_pick_preference
end type
type dw_preferences from u_dw_pick_list within w_pick_preference
end type
type cb_cancel from commandbutton within w_pick_preference
end type
type st_title from statictext within w_pick_preference
end type
type cbx_description from checkbox within w_pick_preference
end type
type cbx_helptext from checkbox within w_pick_preference
end type
end forward

global type w_pick_preference from w_window_base
integer width = 2871
integer height = 1912
string title = "Consultant Search"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_specialty_t st_specialty_t
sle_filter sle_filter
dw_preferences dw_preferences
cb_cancel cb_cancel
st_title st_title
cbx_description cbx_description
cbx_helptext cbx_helptext
end type
global w_pick_preference w_pick_preference

type variables
string specialty_id

boolean filtering

string filter

boolean show_all
string show_edit

string preference_type

end variables

forward prototypes
public function integer refresh ()
public subroutine set_filter ()
public subroutine add_filter_letter (string ps_letter)
public subroutine set_filter_selected (long ll_row)
public function string filter_string ()
end prototypes

public function integer refresh ();long ll_rows

dw_preferences.setfilter(filter_string())

ll_rows = dw_preferences.retrieve(preference_type)

if ll_rows < 0 then return -1

Return 1

end function

public subroutine set_filter ();string ls_filter

ls_filter = filter_string()

dw_preferences.setfilter(ls_filter)
dw_preferences.filter()

if len(ls_filter) > 0 then
	if dw_preferences.rowcount() > 0 then
		dw_preferences.clear_selected()
		dw_preferences.object.selected_flag[1] = 1
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

ls_description = dw_preferences.object.description[ll_row]
sle_filter.text = ls_description
sle_filter.selecttext(li_len + 1, len(ls_description) - li_len)


end subroutine

public function string filter_string ();string ls_filter
integer li_len

li_len = len(filter)

ls_filter = ""

if li_len > 0 then
	if cbx_description.checked then
		ls_filter = "(lower(description) like '%" + lower(filter) + "%')"
	end if
	if cbx_helptext.checked then
		if len(ls_filter) > 0 then
			ls_filter += " or "
		end if
		ls_filter += "(lower(help) like '%" + lower(filter) + "%')"
	end if
else
	ls_filter = ""
end if

return ls_filter

end function

event open;call super::open;
preference_type = message.stringparm
if isnull(preference_type) or trim(preference_type) = "" then
	preference_type = "FAVORITES"
end if

dw_preferences.object.description.width = int((dw_preferences.width - 130) / 2)

dw_preferences.settransobject(sqlca)
refresh()

end event

on w_pick_preference.create
int iCurrent
call super::create
this.st_specialty_t=create st_specialty_t
this.sle_filter=create sle_filter
this.dw_preferences=create dw_preferences
this.cb_cancel=create cb_cancel
this.st_title=create st_title
this.cbx_description=create cbx_description
this.cbx_helptext=create cbx_helptext
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_specialty_t
this.Control[iCurrent+2]=this.sle_filter
this.Control[iCurrent+3]=this.dw_preferences
this.Control[iCurrent+4]=this.cb_cancel
this.Control[iCurrent+5]=this.st_title
this.Control[iCurrent+6]=this.cbx_description
this.Control[iCurrent+7]=this.cbx_helptext
end on

on w_pick_preference.destroy
call super::destroy
destroy(this.st_specialty_t)
destroy(this.sle_filter)
destroy(this.dw_preferences)
destroy(this.cb_cancel)
destroy(this.st_title)
destroy(this.cbx_description)
destroy(this.cbx_helptext)
end on

event key;call super::key;long ll_row
string ls_specialty_id

CHOOSE CASE key
	CASE KeyEnter!
		ll_row = dw_preferences.get_selected_row()
		if ll_row > 0 then
			ls_specialty_id = dw_preferences.object.specialty_id[ll_row]
			closewithreturn(this, ls_specialty_id)
		end if
	CASE KeyDownArrow!
		ll_row = dw_preferences.get_selected_row()
		if ll_row > 0 and ll_row < dw_preferences.rowcount() then
			dw_preferences.object.selected_flag[ll_row] = 0
			ll_row += 1
			dw_preferences.object.selected_flag[ll_row] = 1
			this.function POST set_filter_selected(ll_row)
		end if
	CASE KeyUpArrow!
		ll_row = dw_preferences.get_selected_row()
		if ll_row > 1  then
			dw_preferences.object.selected_flag[ll_row] = 0
			ll_row -= 1
			dw_preferences.object.selected_flag[ll_row] = 1
			this.function POST set_filter_selected(ll_row)
		end if
	CASE KeyPageUp!
		dw_preferences.scrollpriorpage( )
		ll_row = dw_preferences.Object.DataWindow.LastRowOnPage
		if ll_row > 0 then
			dw_preferences.clear_selected()
			dw_preferences.object.selected_flag[ll_row] = 1
		end if
	CASE KeyPageDown!
		dw_preferences.scrollnextpage( )
		if ll_row > 0 then
			dw_preferences.clear_selected()
			dw_preferences.object.selected_flag[ll_row] = 1
		end if
END CHOOSE


end event

type pb_epro_help from w_window_base`pb_epro_help within w_pick_preference
integer x = 3374
integer y = 0
integer width = 224
integer taborder = 0
boolean originalsize = false
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pick_preference
end type

type st_specialty_t from statictext within w_pick_preference
integer x = 41
integer y = 132
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

type sle_filter from singlelineedit within w_pick_preference
event key_up pbm_keyup
integer x = 261
integer y = 120
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

type dw_preferences from u_dw_pick_list within w_pick_preference
integer y = 228
integer width = 2843
integer height = 1432
integer taborder = 0
boolean bringtotop = true
string dataobject = "dw_pick_preference_of_type"
boolean vscrollbar = true
boolean border = false
boolean select_computed = false
end type

event selected;call super::selected;string ls_preference_id

// Don't process the selection if a button was clicked
if lower(lastcolumnname) <> "description" then return

ls_preference_id = object.preference_id[selected_row]

closewithreturn(parent, ls_preference_id)

end event

type cb_cancel from commandbutton within w_pick_preference
integer x = 2432
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

event clicked;string ls_preference_id

setnull(ls_preference_id)

closewithreturn(parent, ls_preference_id)


end event

type st_title from statictext within w_pick_preference
integer width = 2866
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
string text = "Select Property Preference"
alignment alignment = center!
boolean focusrectangle = false
end type

type cbx_description from checkbox within w_pick_preference
integer x = 1225
integer y = 116
integer width = 407
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Description"
boolean checked = true
end type

event clicked;set_filter()
end event

type cbx_helptext from checkbox within w_pick_preference
integer x = 1774
integer y = 116
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Help Text"
end type

event clicked;set_filter()
end event

