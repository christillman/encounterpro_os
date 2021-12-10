$PBExportHeader$w_coding_element_observations.srw
forward
global type w_coding_element_observations from w_window_base
end type
type st_elements_title from statictext within w_coding_element_observations
end type
type st_title from statictext within w_coding_element_observations
end type
type cb_done from commandbutton within w_coding_element_observations
end type
type pb_up from u_picture_button within w_coding_element_observations
end type
type pb_down from u_picture_button within w_coding_element_observations
end type
type dw_elements from u_dw_pick_list within w_coding_element_observations
end type
type st_component_title from statictext within w_coding_element_observations
end type
type st_component from statictext within w_coding_element_observations
end type
type st_type_title from statictext within w_coding_element_observations
end type
type st_type from statictext within w_coding_element_observations
end type
type st_category_title from statictext within w_coding_element_observations
end type
type st_category from statictext within w_coding_element_observations
end type
type pb_obs_up from u_picture_button within w_coding_element_observations
end type
type pb_obs_down from u_picture_button within w_coding_element_observations
end type
type dw_observations from u_dw_pick_list within w_coding_element_observations
end type
type st_page from statictext within w_coding_element_observations
end type
type st_observations_title from statictext within w_coding_element_observations
end type
type st_obs_page from statictext within w_coding_element_observations
end type
type cb_add_observation from commandbutton within w_coding_element_observations
end type
type cb_new_element from commandbutton within w_coding_element_observations
end type
end forward

global type w_coding_element_observations from w_window_base
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_elements_title st_elements_title
st_title st_title
cb_done cb_done
pb_up pb_up
pb_down pb_down
dw_elements dw_elements
st_component_title st_component_title
st_component st_component
st_type_title st_type_title
st_type st_type
st_category_title st_category_title
st_category st_category
pb_obs_up pb_obs_up
pb_obs_down pb_obs_down
dw_observations dw_observations
st_page st_page
st_observations_title st_observations_title
st_obs_page st_obs_page
cb_add_observation cb_add_observation
cb_new_element cb_new_element
end type
global w_coding_element_observations w_coding_element_observations

type variables
string em_component
string em_type
string em_category
string em_element

end variables

forward prototypes
public subroutine observation_menu (long pl_row)
end prototypes

public subroutine observation_menu (long pl_row);str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
integer li_update_flag
string ls_Observation_id
string ls_temp
string ls_composite_flag
string ls_description
string ls_null
long ll_null

setnull(ls_null)
setnull(ll_null)

ls_composite_flag = dw_observations.object.composite_flag[pl_row]


if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Remove Observation"
	popup.button_titles[popup.button_count] = "Remove Observation"
	buttons[popup.button_count] = "REMOVE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonProperties.bmp"
	popup.button_helps[popup.button_count] = "Display all parent observations of this observation"
	popup.button_titles[popup.button_count] = "Display Parents"
	buttons[popup.button_count] = "PARENTS"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonProperties.bmp"
	popup.button_helps[popup.button_count] = "Display all categories of this observation"
	popup.button_titles[popup.button_count] = "Display Categories"
	buttons[popup.button_count] = "CATEGORIES"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	button_pressed = message.doubleparm
	if button_pressed < 1 or button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if

CHOOSE CASE buttons[button_pressed]
	CASE "REMOVE"
		dw_observations.deleterow(pl_row)
		li_sts = dw_observations.update()
		dw_observations.recalc_page(pb_obs_up, pb_obs_down, st_obs_page)
	CASE "PARENTS"
		popup.dataobject = "dw_parent_observation_display_list"
		popup.argument_count = 1
		popup.argument[1] = dw_observations.object.observation_id[pl_row]
		popup.datacolumn = 1
		popup.displaycolumn = 3
		openwithparm(w_pop_pick, popup)
	CASE "CATEGORIES"
		popup.dataobject = "dw_observation_categories_in_list"
		popup.argument_count = 1
		popup.argument[1] = dw_observations.object.observation_id[pl_row]
		popup.datacolumn = 1
		popup.displaycolumn = 6
		openwithparm(w_pop_pick, popup)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return



end subroutine

on w_coding_element_observations.create
int iCurrent
call super::create
this.st_elements_title=create st_elements_title
this.st_title=create st_title
this.cb_done=create cb_done
this.pb_up=create pb_up
this.pb_down=create pb_down
this.dw_elements=create dw_elements
this.st_component_title=create st_component_title
this.st_component=create st_component
this.st_type_title=create st_type_title
this.st_type=create st_type
this.st_category_title=create st_category_title
this.st_category=create st_category
this.pb_obs_up=create pb_obs_up
this.pb_obs_down=create pb_obs_down
this.dw_observations=create dw_observations
this.st_page=create st_page
this.st_observations_title=create st_observations_title
this.st_obs_page=create st_obs_page
this.cb_add_observation=create cb_add_observation
this.cb_new_element=create cb_new_element
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_elements_title
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.cb_done
this.Control[iCurrent+4]=this.pb_up
this.Control[iCurrent+5]=this.pb_down
this.Control[iCurrent+6]=this.dw_elements
this.Control[iCurrent+7]=this.st_component_title
this.Control[iCurrent+8]=this.st_component
this.Control[iCurrent+9]=this.st_type_title
this.Control[iCurrent+10]=this.st_type
this.Control[iCurrent+11]=this.st_category_title
this.Control[iCurrent+12]=this.st_category
this.Control[iCurrent+13]=this.pb_obs_up
this.Control[iCurrent+14]=this.pb_obs_down
this.Control[iCurrent+15]=this.dw_observations
this.Control[iCurrent+16]=this.st_page
this.Control[iCurrent+17]=this.st_observations_title
this.Control[iCurrent+18]=this.st_obs_page
this.Control[iCurrent+19]=this.cb_add_observation
this.Control[iCurrent+20]=this.cb_new_element
end on

on w_coding_element_observations.destroy
call super::destroy
destroy(this.st_elements_title)
destroy(this.st_title)
destroy(this.cb_done)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.dw_elements)
destroy(this.st_component_title)
destroy(this.st_component)
destroy(this.st_type_title)
destroy(this.st_type)
destroy(this.st_category_title)
destroy(this.st_category)
destroy(this.pb_obs_up)
destroy(this.pb_obs_down)
destroy(this.dw_observations)
destroy(this.st_page)
destroy(this.st_observations_title)
destroy(this.st_obs_page)
destroy(this.cb_add_observation)
destroy(this.cb_new_element)
end on

event open;call super::open;str_popup_return popup_return
integer li_sts

dw_observations.settransobject(sqlca)
dw_elements.settransobject(sqlca)

em_component = datalist.get_preference("CODING", "pickobs_em_component")
if isnull(em_component) then em_component = "Examination"

st_component.text = em_component

em_type = datalist.get_preference("CODING", "pickobs_em_type|" + em_component)
if isnull(em_type) then
	st_type.postevent("clicked")
else
	st_type.text = em_type
	
	em_category = datalist.get_preference("CODING", "pickobs_em_category|" + em_component + "|" + em_type)
	if isnull(em_category) then
		st_category.postevent("clicked")
	else
		st_category.text = em_category
		li_sts = dw_elements.retrieve(em_component, em_type, em_category)
		dw_elements.set_page(1, pb_up, pb_down, st_page)
		cb_new_element.enabled = true
		if li_sts >= 1 then
			dw_elements.set_row(1)
		else
			dw_observations.reset()
		end if
	end if
end if


end event

type pb_epro_help from w_window_base`pb_epro_help within w_coding_element_observations
boolean visible = true
integer x = 2103
integer y = 1600
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_coding_element_observations
end type

type st_elements_title from statictext within w_coding_element_observations
integer x = 142
integer y = 420
integer width = 1074
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Elements"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title from statictext within w_coding_element_observations
integer width = 2921
integer height = 116
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Associate Observations With Coding Elements"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_done from commandbutton within w_coding_element_observations
integer x = 2414
integer y = 1596
integer width = 402
integer height = 112
integer taborder = 41
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

event clicked;integer li_sts
str_popup_return popup_return

datalist.update_preference("CODING", "User", current_user.user_id, "pickobs_em_component", em_component)
datalist.update_preference("CODING", "User", current_user.user_id, "pickobs_em_type|" + em_component, em_type)
datalist.update_preference("CODING", "User", current_user.user_id, "pickobs_em_category|" + em_component + "|" + em_type, em_category)

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type pb_up from u_picture_button within w_coding_element_observations
boolean visible = false
integer x = 1275
integer y = 500
integer width = 137
integer height = 116
integer taborder = 11
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_elements.current_page

dw_elements.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_coding_element_observations
boolean visible = false
integer x = 1275
integer y = 624
integer width = 137
integer height = 116
integer taborder = 21
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_elements.current_page
li_last_page = dw_elements.last_page

dw_elements.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true
end event

type dw_elements from u_dw_pick_list within w_coding_element_observations
integer x = 137
integer y = 492
integer width = 1147
integer height = 1160
integer taborder = 10
string dataobject = "dw_em_element_list"
boolean border = false
end type

event selected(long selected_row);call super::selected;
em_element = object.em_element[selected_row]

dw_observations.settransobject(sqlca)
dw_observations.retrieve(em_component, em_type, em_category, em_element)
dw_observations.set_page(1, pb_obs_up, pb_obs_down, st_obs_page)

cb_add_observation.enabled = true

end event

event unselected(long unselected_row);call super::unselected;dw_observations.reset()

cb_add_observation.enabled = false

end event

type st_component_title from statictext within w_coding_element_observations
integer x = 50
integer y = 152
integer width = 896
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Component"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_component from statictext within w_coding_element_observations
integer x = 50
integer y = 232
integer width = 896
integer height = 108
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

popup.dataobject = "dw_em_component_list"
popup.datacolumn = 1
popup.displaycolumn = 1
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

em_component = popup_return.items[1]
text = em_component

end event

type st_type_title from statictext within w_coding_element_observations
integer x = 987
integer y = 152
integer width = 896
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Type"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_type from statictext within w_coding_element_observations
integer x = 987
integer y = 232
integer width = 896
integer height = 108
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

popup.dataobject = "dw_em_type_list"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = em_component
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

em_type = popup_return.items[1]
text = em_type

st_category.postevent("clicked")
end event

type st_category_title from statictext within w_coding_element_observations
integer x = 1925
integer y = 152
integer width = 896
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Category"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_category from statictext within w_coding_element_observations
integer x = 1925
integer y = 232
integer width = 896
integer height = 108
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
integer li_sts

popup.dataobject = "dw_em_category_list"
popup.datacolumn = 3
popup.displaycolumn = 3
popup.argument_count = 2
popup.argument[1] = em_component
popup.argument[2] = em_type
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

em_category = popup_return.items[1]
text = em_category

li_sts = dw_elements.retrieve(em_component, em_type, em_category)
dw_elements.set_page(1, pb_up, pb_down, st_page)
cb_new_element.enabled = true
if li_sts > 0 then
	dw_elements.set_row(1)
else
	dw_observations.reset()
end if

end event

type pb_obs_up from u_picture_button within w_coding_element_observations
boolean visible = false
integer x = 2661
integer y = 500
integer width = 137
integer height = 116
integer taborder = 10
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_observations.current_page

dw_observations.set_page(li_page - 1, st_obs_page.text)

if li_page <= 2 then enabled = false
pb_obs_down.enabled = true

end event

type pb_obs_down from u_picture_button within w_coding_element_observations
boolean visible = false
integer x = 2661
integer y = 624
integer width = 137
integer height = 116
integer taborder = 10
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_observations.current_page
li_last_page = dw_observations.last_page

dw_observations.set_page(li_page + 1, st_obs_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_obs_up.enabled = true
end event

type dw_observations from u_dw_pick_list within w_coding_element_observations
integer x = 1522
integer y = 492
integer width = 1147
integer height = 932
integer taborder = 20
string dataobject = "dw_em_element_observation_list"
boolean border = false
end type

event selected(long selected_row);call super::selected;observation_menu(selected_row)
clear_selected()

end event

type st_page from statictext within w_coding_element_observations
boolean visible = false
integer x = 1115
integer y = 416
integer width = 297
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Page 99/99"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_observations_title from statictext within w_coding_element_observations
integer x = 1522
integer y = 420
integer width = 1147
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Observations"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_obs_page from statictext within w_coding_element_observations
boolean visible = false
integer x = 2501
integer y = 420
integer width = 297
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Page 99/99"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_add_observation from commandbutton within w_coding_element_observations
integer x = 2071
integer y = 1444
integer width = 599
integer height = 112
integer taborder = 31
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Add Observation"
end type

event clicked;str_popup popup
str_picked_observations lstr_observations
string ls_observation_id
string ls_description
long ll_row
string ls_composite_flag
long i
string ls_treatment_type
w_pick_observations lw_pick
integer li_sts

popup.data_row_count = 2
popup.title = "Select Observation(s) for '" + em_element + "'"

setnull(ls_treatment_type)

popup.multiselect = true
popup.items[1] = ls_treatment_type
popup.items[2] = current_user.specialty_id
openwithparm(lw_pick, popup, "w_pick_observations")
lstr_observations = message.powerobjectparm
if lstr_observations.observation_count < 1 then return

for i = 1 to lstr_observations.observation_count
	ls_observation_id = lstr_observations.observation_id[i]
	ls_description = lstr_observations.description[i]
	ls_composite_flag = datalist.observation_composite_flag(ls_observation_id)
	
	ll_row = dw_observations.insertrow(0)
	dw_observations.object.em_component[ll_row] = em_component
	dw_observations.object.em_type[ll_row] = em_type
	dw_observations.object.em_category[ll_row] = em_category
	dw_observations.object.em_element[ll_row] = em_element
	dw_observations.object.observation_id[ll_row] = ls_observation_id
	dw_observations.object.description[ll_row] = ls_description
	dw_observations.object.composite_flag[ll_row] = ls_composite_flag
next

li_sts = dw_observations.update()

dw_observations.recalc_page(pb_obs_up, pb_obs_down, st_obs_page)


end event

type cb_new_element from commandbutton within w_coding_element_observations
integer x = 1275
integer y = 1528
integer width = 494
integer height = 112
integer taborder = 41
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "New Element"
end type

event clicked;string ls_em_element
integer li_sts
long ll_row
string ls_find
str_popup popup
str_popup_return popup_return

popup.title = "Please enter new element"
popup.argument_count = 1
popup.argument[1] = em_component
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_em_element = trim(popup_return.items[1])
if ls_em_element = "" or isnull(ls_em_element) then return

ls_find = "em_element='" + ls_em_element + "'"
ll_row = dw_elements.find(ls_find, 1, dw_elements.rowcount())
if ll_row > 0 then
	openwithparm(w_pop_message, "That element already exists")
	return
end if

ll_row = dw_elements.insertrow(0)
dw_elements.object.em_component[ll_row] = em_component
dw_elements.object.em_type[ll_row] = em_type
dw_elements.object.em_category[ll_row] = em_category
dw_elements.object.em_element[ll_row] = ls_em_element
dw_elements.object.sort_sequence[ll_row] = ll_row

li_sts = dw_elements.update()




end event

