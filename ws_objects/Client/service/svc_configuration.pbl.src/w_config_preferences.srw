$PBExportHeader$w_config_preferences.srw
forward
global type w_config_preferences from w_window_base
end type
type cb_ok from commandbutton within w_config_preferences
end type
type st_preference_key from statictext within w_config_preferences
end type
type st_preference_key_title from statictext within w_config_preferences
end type
type st_preference_value_title from statictext within w_config_preferences
end type
type st_preference_title from statictext within w_config_preferences
end type
type st_preference_type_title from statictext within w_config_preferences
end type
type dw_preference_type from u_dw_pick_list within w_config_preferences
end type
type dw_preferences from u_dw_pick_list within w_config_preferences
end type
type st_global from statictext within w_config_preferences
end type
type st_office from statictext within w_config_preferences
end type
type st_computer from statictext within w_config_preferences
end type
type st_specialty from statictext within w_config_preferences
end type
type st_user from statictext within w_config_preferences
end type
end forward

global type w_config_preferences from w_window_base
string title = "Preferences"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_ok cb_ok
st_preference_key st_preference_key
st_preference_key_title st_preference_key_title
st_preference_value_title st_preference_value_title
st_preference_title st_preference_title
st_preference_type_title st_preference_type_title
dw_preference_type dw_preference_type
dw_preferences dw_preferences
st_global st_global
st_office st_office
st_computer st_computer
st_specialty st_specialty
st_user st_user
end type
global w_config_preferences w_config_preferences

type variables
string preference_type
string preference_level
string preference_key

string global_preference_key = "Global"
string office_preference_key
string computer_preference_key
string specialty_preference_key
string user_preference_key


end variables

forward prototypes
public subroutine preference_menu (long pl_row)
public function integer refresh ()
end prototypes

public subroutine preference_menu (long pl_row);//str_popup popup
//str_popup_return popup_return
//string buttons[]
//integer button_pressed, li_sts, li_service_count
//window lw_pop_buttons
//string ls_user_id
//integer li_update_flag
//string ls_preference_id
//string ls_preference_value
//string ls_temp
//string ls_null
//
//setnull(ls_null)
//
//
//ls_preference_value = dw_preferences.object.preference_value[pl_row]
//
//if true then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button17.bmp"
//	popup.button_helps[popup.button_count] = "Edit Preference"
//	popup.button_titles[popup.button_count] = "Edit Preference"
//	buttons[popup.button_count] = "EDIT"
//end if
//
//if true then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button13.bmp"
//	popup.button_helps[popup.button_count] = "Delete Preference"
//	popup.button_titles[popup.button_count] = "Delete Preference"
//	buttons[popup.button_count] = "DELETE"
//end if
//
//if true then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button11.bmp"
//	popup.button_helps[popup.button_count] = "Cancel"
//	popup.button_titles[popup.button_count] = "Cancel"
//	buttons[popup.button_count] = "CANCEL"
//end if
//
//popup.button_titles_used = true
//
//if popup.button_count > 1 then
//	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
//	button_pressed = message.doubleparm
//	if button_pressed < 1 or button_pressed > popup.button_count then return
//elseif popup.button_count = 1 then
//	button_pressed = 1
//else
//	return
//end if
//
//CHOOSE CASE buttons[button_pressed]
//	CASE "EDIT"
//		ls_preference_id = dw_preferences.object.preference_id[pl_row]
//		popup.item = dw_preferences.object.preference_description[pl_row]
//		popup.title = dw_preferences.object.preference_value[pl_row]
//		openwithparm(w_pop_get_string, popup)
//		popup_return = message.powerobjectparm
//		if popup_return.item_count <> 1 then return
////		li_sts = datalist.update_preference(preference_type, user_id, ls_preference_id, popup_return.items[1])
//		if li_sts > 0 then dw_preferences.setitem(pl_row, "preference_value", popup_return.items[1])
//		datalist.clear_cache("preferences")
//	CASE "DELETE"
//		ls_temp = "Delete " + dw_preferences.object.preference_description[pl_row] + "?"
//		openwithparm(w_pop_ok, ls_temp)
//		if message.doubleparm = 1 then
//			ls_preference_id = dw_preferences.object.preference_id[pl_row]
////			li_sts = datalist.update_preference(preference_type, user_id, ls_preference_id, ls_null)
//			if li_sts > 0 then dw_preferences.deleterow(pl_row)
//			datalist.clear_cache("preferences")
//		end if
//	CASE "CANCEL"
//		return
//	CASE ELSE
//END CHOOSE
//
//return
//
//
end subroutine

public function integer refresh ();u_ds_data luo_results
long ll_result_count
long ll_pref_count
string ls_preference_id
string ls_find
long i
long ll_row
string ls_preference_value
string ls_preference_display

CHOOSE CASE lower(preference_level)
	CASE "global"
		st_preference_key.visible = false
		st_preference_key_title.visible = false
		preference_key = global_preference_key
	CASE "office"
		st_preference_key.visible = true
		st_preference_key_title.visible = true
		preference_key = office_preference_key
		st_preference_key.text = datalist.office_description(preference_key)
	CASE "computer"
		st_preference_key.visible = true
		st_preference_key_title.visible = true
		preference_key = computer_preference_key
		st_preference_key.text = datalist.computer_description(long(preference_key))
	CASE "specialty"
		st_preference_key.visible = true
		st_preference_key_title.visible = true
		preference_key = specialty_preference_key
		st_preference_key.text = datalist.specialty_description(preference_key)
	CASE "user"
		st_preference_key.visible = true
		st_preference_key_title.visible = true
		preference_key = user_preference_key
		st_preference_key.text = user_list.user_full_name(preference_key)
END CHOOSE


luo_results = CREATE u_ds_data
luo_results.set_dataobject("dw_o_preferences")
ll_result_count = luo_results.retrieve(preference_type, preference_level, preference_key)

ll_pref_count = dw_preferences.rowcount()

for i = 1 to ll_pref_count
	ls_preference_id = dw_preferences.object.preference_id[i]
	ls_find = "preference_id='" + ls_preference_id + "'"
	ll_row = luo_results.find(ls_find, 1, ll_result_count)
	if ll_row > 0 then
		ls_preference_value = luo_results.object.preference_value[ll_row]
		if right(ls_preference_id, 5) = "color" then
			ls_preference_display = ""
		else
			ls_preference_display = sqlca.fn_attribute_description(ls_preference_id, ls_preference_value)
		end if
	else
		setnull(ls_preference_value)
		setnull(ls_preference_display)
	end if
	dw_preferences.object.preference_level[i] = lower(preference_level)
	dw_preferences.object.preference_value[i] = ls_preference_value
	dw_preferences.object.preference_display[i] = ls_preference_display
next

return 1

end function

on w_config_preferences.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.st_preference_key=create st_preference_key
this.st_preference_key_title=create st_preference_key_title
this.st_preference_value_title=create st_preference_value_title
this.st_preference_title=create st_preference_title
this.st_preference_type_title=create st_preference_type_title
this.dw_preference_type=create dw_preference_type
this.dw_preferences=create dw_preferences
this.st_global=create st_global
this.st_office=create st_office
this.st_computer=create st_computer
this.st_specialty=create st_specialty
this.st_user=create st_user
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.st_preference_key
this.Control[iCurrent+3]=this.st_preference_key_title
this.Control[iCurrent+4]=this.st_preference_value_title
this.Control[iCurrent+5]=this.st_preference_title
this.Control[iCurrent+6]=this.st_preference_type_title
this.Control[iCurrent+7]=this.dw_preference_type
this.Control[iCurrent+8]=this.dw_preferences
this.Control[iCurrent+9]=this.st_global
this.Control[iCurrent+10]=this.st_office
this.Control[iCurrent+11]=this.st_computer
this.Control[iCurrent+12]=this.st_specialty
this.Control[iCurrent+13]=this.st_user
end on

on w_config_preferences.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.st_preference_key)
destroy(this.st_preference_key_title)
destroy(this.st_preference_value_title)
destroy(this.st_preference_title)
destroy(this.st_preference_type_title)
destroy(this.dw_preference_type)
destroy(this.dw_preferences)
destroy(this.st_global)
destroy(this.st_office)
destroy(this.st_computer)
destroy(this.st_specialty)
destroy(this.st_user)
end on

event open;call super::open;long ll_count
string ls_find
long ll_row


global_preference_key = "Global"
office_preference_key = office_id
computer_preference_key = string(computer_id)
specialty_preference_key = current_user.common_list_id()
user_preference_key = current_user.user_id

st_global.backcolor = color_object_selected
preference_level = "Global"
preference_key = "Global"

dw_preference_type.settransobject(sqlca)
dw_preferences.settransobject(sqlca)

ll_count = dw_preference_type.retrieve()
if ll_count <= 0 then
	log.log(this, "open", "Error getting preference types", 4)
	close(this)
	return
end if

dw_preference_type.object.description.width = dw_preference_type.width - 108
dw_preferences.object.preference_display.width = dw_preferences.width - 1238

ls_find = "preference_type='PREFERENCES'"
ll_row = dw_preference_type.find(ls_find, 1, ll_count)
if ll_row <= 0 then ll_row = 1
dw_preference_type.object.selected_flag[ll_row] = 1
dw_preference_type.event trigger selected(ll_row)



end event

type pb_epro_help from w_window_base`pb_epro_help within w_config_preferences
integer x = 2857
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_config_preferences
end type

type cb_ok from commandbutton within w_config_preferences
integer x = 2459
integer y = 1592
integer width = 402
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;
datalist.clear_cache("preferences")

close(parent)
end event

type st_preference_key from statictext within w_config_preferences
integer x = 1102
integer y = 1592
integer width = 873
integer height = 112
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
		global_preference_key = "Global"
		text = "Global"
	CASE "office"
		popup.dataobject = "dw_office_pick"
		popup.datacolumn = 1
		popup.displaycolumn = 2
		
		openwithparm(w_pop_pick, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		
		office_preference_key = popup_return.items[1]
		text = popup_return.descriptions[1]
	CASE "computer"
		popup.dataobject = "dw_computer_list"
		popup.datacolumn = 1
		popup.displaycolumn = 5
		popup.argument_count = 1
		popup.argument[1] = office_id
		openwithparm(w_pop_pick, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		
		computer_preference_key = popup_return.items[1]
		text = popup_return.descriptions[1]
	CASE "specialty"
		ls_specialty_id = f_pick_specialty("")
		if isnull(ls_specialty_id) then return
		
		specialty_preference_key = ls_specialty_id
		text = datalist.specialty_description(ls_specialty_id)
	CASE "user"
		luo_user = user_list.pick_user()
		if isnull(luo_user) then return
		
		user_preference_key = luo_user.user_id
		text = luo_user.user_full_name
END CHOOSE

refresh()

end event

type st_preference_key_title from statictext within w_config_preferences
integer x = 553
integer y = 1612
integer width = 507
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
string text = "Preference Key:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_preference_value_title from statictext within w_config_preferences
integer x = 2048
integer width = 681
integer height = 72
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Value"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_preference_title from statictext within w_config_preferences
integer x = 914
integer width = 1134
integer height = 72
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Preference"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_preference_type_title from statictext within w_config_preferences
integer width = 882
integer height = 72
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Preference Type"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_preference_type from u_dw_pick_list within w_config_preferences
integer y = 80
integer width = 978
integer height = 1340
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_preference_type_list"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;
preference_type = dw_preference_type.object.preference_type[selected_row]
dw_preferences.retrieve(preference_type)

refresh()

end event

type dw_preferences from u_dw_pick_list within w_config_preferences
integer x = 992
integer y = 80
integer width = 1879
integer height = 1384
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_preference_by_type_display"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;str_param_setting lstr_param
str_param_wizard_return lstr_return
string ls_preference_value
string ls_flag
string ls_encrypted
string ls_preference_enc
string ls_universal_flag
w_param_setting lw_param_window

ls_universal_flag = object.universal_flag[selected_row]
if upper(ls_universal_flag) = 'Y' or  upper(ls_universal_flag) = 'C' then return

CHOOSE CASE lower(preference_level)
	CASE "global"
		ls_flag = object.global_flag[selected_row]
	CASE "office"
		ls_flag = object.office_flag[selected_row]
	CASE "computer"
		ls_flag = object.computer_flag[selected_row]
	CASE "specialty"
		ls_flag = object.specialty_flag[selected_row]
	CASE "user"
		ls_flag = object.user_flag[selected_row]
END CHOOSE

if upper(ls_flag) <> "Y" then
	clear_selected()
	return
end if

lstr_param.param.param_class = object.param_class[selected_row]
lstr_param.param.param_title = object.description[selected_row]
lstr_param.param.token1 = object.preference_id[selected_row]
lstr_param.param.helptext = object.help[selected_row]
lstr_param.param.query = object.query[selected_row]
lstr_param.param.required_flag = "N"

ls_preference_value = object.preference_value[selected_row]
if not isnull(ls_preference_value) then
	f_attribute_add_attribute(lstr_param.attributes, lstr_param.param.token1, ls_preference_value)
end if

openwithparm(lw_param_window, lstr_param, "w_param_setting")
lstr_return = message.powerobjectparm
if lstr_return.return_status <= 0 then
	clear_selected()
	return
end if

ls_preference_value = f_attribute_find_attribute(lstr_return.attributes, lstr_param.param.token1)

datalist.set_preference( preference_type, &
									preference_level, &
									preference_key, &
									lstr_param.param.token1, &
									ls_preference_value)

clear_selected()
refresh()


end event

type st_global from statictext within w_config_preferences
integer x = 366
integer y = 1476
integer width = 402
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Global"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_global.backcolor = color_object_selected
st_office.backcolor = color_object
st_computer.backcolor = color_object
st_specialty.backcolor = color_object
st_user.backcolor = color_object

preference_level = "Global"

refresh()

end event

type st_office from statictext within w_config_preferences
integer x = 805
integer y = 1476
integer width = 402
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Office"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_global.backcolor = color_object
st_office.backcolor = color_object_selected
st_computer.backcolor = color_object
st_specialty.backcolor = color_object
st_user.backcolor = color_object

preference_level = "Office"

refresh()

end event

type st_computer from statictext within w_config_preferences
integer x = 1243
integer y = 1476
integer width = 402
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Computer"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_global.backcolor = color_object
st_office.backcolor = color_object
st_computer.backcolor = color_object_selected
st_specialty.backcolor = color_object
st_user.backcolor = color_object

preference_level = "Computer"

refresh()

end event

type st_specialty from statictext within w_config_preferences
integer x = 1682
integer y = 1476
integer width = 402
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Specialty"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_global.backcolor = color_object
st_office.backcolor = color_object
st_computer.backcolor = color_object
st_specialty.backcolor = color_object_selected
st_user.backcolor = color_object

preference_level = "Specialty"

refresh()

end event

type st_user from statictext within w_config_preferences
integer x = 2121
integer y = 1476
integer width = 402
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "User"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_global.backcolor = color_object
st_office.backcolor = color_object
st_computer.backcolor = color_object
st_specialty.backcolor = color_object
st_user.backcolor = color_object_selected

preference_level = "User"

refresh()

end event

