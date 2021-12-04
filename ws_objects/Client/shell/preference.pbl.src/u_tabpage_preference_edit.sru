$PBExportHeader$u_tabpage_preference_edit.sru
forward
global type u_tabpage_preference_edit from u_tabpage
end type
type st_preference_key from statictext within u_tabpage_preference_edit
end type
type st_preference_key_title from statictext within u_tabpage_preference_edit
end type
type st_preference_value_title from statictext within u_tabpage_preference_edit
end type
type st_preference_title from statictext within u_tabpage_preference_edit
end type
type pb_down from u_picture_button within u_tabpage_preference_edit
end type
type pb_up from u_picture_button within u_tabpage_preference_edit
end type
type st_page from statictext within u_tabpage_preference_edit
end type
type st_preference_type_title from statictext within u_tabpage_preference_edit
end type
type dw_preference_type from u_dw_pick_list within u_tabpage_preference_edit
end type
type dw_preferences from u_dw_pick_list within u_tabpage_preference_edit
end type
end forward

global type u_tabpage_preference_edit from u_tabpage
integer width = 3026
st_preference_key st_preference_key
st_preference_key_title st_preference_key_title
st_preference_value_title st_preference_value_title
st_preference_title st_preference_title
pb_down pb_down
pb_up pb_up
st_page st_page
st_preference_type_title st_preference_type_title
dw_preference_type dw_preference_type
dw_preferences dw_preferences
end type
global u_tabpage_preference_edit u_tabpage_preference_edit

type variables
string preference_level
string preference_key

u_tab_preference_edit prefs_tab

end variables

forward prototypes
public function integer initialize ()
public subroutine refresh ()
end prototypes

public function integer initialize ();long ll_temp
long ll_count
long ll_row

prefs_tab = parent_tab

pb_up.x = width - pb_up.width - 12
pb_down.x = pb_up.x
st_page.x = pb_up.x

dw_preferences.settransobject(sqlca)
dw_preference_type.settransobject(sqlca)

dw_preferences.width = pb_up.x - dw_preferences.x - 20
//ll_temp = long(dw_preferences.object.preference_value.x)
ll_temp = 1143
dw_preferences.modify("preference_value='" + string(ll_temp - 100) + "'")
st_preference_value_title.width = ll_temp - 100

dw_preferences.height = height - dw_preferences.y - 20

st_preference_key.y = height - st_preference_key.height - 20
st_preference_key_title.y = st_preference_key.y - st_preference_key_title.height - 4
dw_preference_type.height = st_preference_key_title.y - dw_preference_type.y - 8

CHOOSE CASE lower(preference_level)
	CASE "global"
		st_preference_key.visible = false
		st_preference_key_title.visible = false
	CASE "office"
		preference_key = gnv_app.office_id
		st_preference_key.text = office_description
	CASE "computer"
		preference_key = string(gnv_app.computer_id)
		st_preference_key.text = gnv_app.computername + "/" + gnv_app.windows_logon_id
	CASE "specialty"
		preference_key = current_user.common_list_id()
		st_preference_key.text = datalist.specialty_description(preference_key)
	CASE "User"
		preference_key = current_user.user_id
		st_preference_key.text = current_user.user_full_name
END CHOOSE


return 1

end function

public subroutine refresh ();integer li_page
string ls_find
long ll_count
long ll_row
string ls_current_preference_type

ll_count = dw_preferences.rowcount()
if ll_count <= 0 then
	ll_count = dw_preference_type.retrieve()
	if ll_count <= 0 then return
end if

ll_row = dw_preferences.get_selected_row()
if ll_row > 0 then
	// If the preference_type has changed, then go back to page one
	ls_current_preference_type = dw_preferences.object.preference_type[ll_row]
	if upper(ls_current_preference_type) = upper(prefs_tab.preference_type) then
		li_page = dw_preferences.current_page
	else
		li_page = 1
	end if
end if

ls_find = "upper(preference_type)='" + prefs_tab.preference_type + "'"
ll_row = dw_preference_type.find(ls_find, 1, ll_count)
if ll_row <= 0 then
	ll_row = 1
	prefs_tab.preference_type = dw_preference_type.object.preference_type[ll_row]
end if
dw_preference_type.object.selected_flag[ll_row] = 1
	

if isnull(li_page) or li_page <= 0 then li_page = 1

dw_preferences.retrieve(prefs_tab.preference_type, preference_level, preference_key)
dw_preferences.set_page(li_page, pb_up, pb_down, st_page)

end subroutine

on u_tabpage_preference_edit.create
int iCurrent
call super::create
this.st_preference_key=create st_preference_key
this.st_preference_key_title=create st_preference_key_title
this.st_preference_value_title=create st_preference_value_title
this.st_preference_title=create st_preference_title
this.pb_down=create pb_down
this.pb_up=create pb_up
this.st_page=create st_page
this.st_preference_type_title=create st_preference_type_title
this.dw_preference_type=create dw_preference_type
this.dw_preferences=create dw_preferences
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_preference_key
this.Control[iCurrent+2]=this.st_preference_key_title
this.Control[iCurrent+3]=this.st_preference_value_title
this.Control[iCurrent+4]=this.st_preference_title
this.Control[iCurrent+5]=this.pb_down
this.Control[iCurrent+6]=this.pb_up
this.Control[iCurrent+7]=this.st_page
this.Control[iCurrent+8]=this.st_preference_type_title
this.Control[iCurrent+9]=this.dw_preference_type
this.Control[iCurrent+10]=this.dw_preferences
end on

on u_tabpage_preference_edit.destroy
call super::destroy
destroy(this.st_preference_key)
destroy(this.st_preference_key_title)
destroy(this.st_preference_value_title)
destroy(this.st_preference_title)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.st_page)
destroy(this.st_preference_type_title)
destroy(this.dw_preference_type)
destroy(this.dw_preferences)
end on

event refresh;call super::refresh;//dw_preferences.retrieve(
end event

type st_preference_key from statictext within u_tabpage_preference_edit
integer x = 14
integer y = 1252
integer width = 873
integer height = 116
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
u_user luo_user
string ls_specialty_id

CHOOSE CASE lower(preference_level)
	CASE "global"
		preference_key = "Global"
		text = "Global"
	CASE "office"
		popup.dataobject = "dw_office_pick"
		popup.datacolumn = 1
		popup.displaycolumn = 2
		
		openwithparm(w_pop_pick, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		
		preference_key = popup_return.items[1]
		text = popup_return.descriptions[1]
		refresh()
	CASE "computer"
		popup.dataobject = "dw_computer_list"
		popup.datacolumn = 1
		popup.displaycolumn = 5
		popup.argument_count = 1
		popup.argument[1] = gnv_app.office_id
		openwithparm(w_pop_pick, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		
		preference_key = popup_return.items[1]
		text = popup_return.descriptions[1]
		refresh()
	CASE "specialty"
		ls_specialty_id = f_pick_specialty("")
		if isnull(ls_specialty_id) then return
		
		preference_key = ls_specialty_id
		text = datalist.specialty_description(ls_specialty_id)
		refresh()
	CASE "User"
		luo_user = user_list.pick_user()
		if not isnull(luo_user) then
			preference_key = luo_user.user_id
			text = luo_user.user_full_name
			refresh()
		end if
END CHOOSE


end event

type st_preference_key_title from statictext within u_tabpage_preference_edit
integer x = 9
integer y = 1172
integer width = 873
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Preference Key"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_preference_value_title from statictext within u_tabpage_preference_edit
integer x = 2048
integer width = 562
integer height = 72
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Value"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_preference_title from statictext within u_tabpage_preference_edit
integer x = 914
integer width = 1134
integer height = 72
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Preference"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_down from u_picture_button within u_tabpage_preference_edit
boolean visible = false
integer x = 2885
integer y = 212
integer width = 137
integer height = 116
integer taborder = 40
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_preferences.current_page
li_last_page = dw_preferences.last_page

dw_preferences.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true
end event

type pb_up from u_picture_button within u_tabpage_preference_edit
boolean visible = false
integer x = 2885
integer y = 88
integer width = 137
integer height = 116
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_preferences.current_page

dw_preferences.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type st_page from statictext within u_tabpage_preference_edit
boolean visible = false
integer x = 2885
integer y = 332
integer width = 133
integer height = 128
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Page 99/99"
boolean focusrectangle = false
end type

type st_preference_type_title from statictext within u_tabpage_preference_edit
integer width = 882
integer height = 72
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Preference Type"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_preference_type from u_dw_pick_list within u_tabpage_preference_edit
integer y = 80
integer width = 882
integer height = 1068
integer taborder = 20
string dataobject = "dw_preference_type_list"
boolean border = false
end type

event selected;call super::selected;prefs_tab.preference_type = dw_preference_type.object.preference_type[selected_row]
refresh()

end event

type dw_preferences from u_dw_pick_list within u_tabpage_preference_edit
integer x = 914
integer y = 80
integer width = 1952
integer height = 1384
integer taborder = 10
string dataobject = "dw_sp_get_preference_list"
boolean border = false
end type

