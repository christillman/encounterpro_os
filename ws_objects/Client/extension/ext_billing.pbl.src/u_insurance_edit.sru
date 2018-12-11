$PBExportHeader$u_insurance_edit.sru
forward
global type u_insurance_edit from userobject
end type
type cb_edit_types from commandbutton within u_insurance_edit
end type
type st_authority_type_t from statictext within u_insurance_edit
end type
type st_authority_types from statictext within u_insurance_edit
end type
type st_page from statictext within u_insurance_edit
end type
type pb_down from u_picture_button within u_insurance_edit
end type
type pb_up from u_picture_button within u_insurance_edit
end type
type cb_edit_categories from commandbutton within u_insurance_edit
end type
type st_status_title from statictext within u_insurance_edit
end type
type st_1 from statictext within u_insurance_edit
end type
type st_authority_category from statictext within u_insurance_edit
end type
type st_title from statictext within u_insurance_edit
end type
type cb_new from commandbutton within u_insurance_edit
end type
type dw_carriers from u_dw_pick_list within u_insurance_edit
end type
type st_radio_inactive from u_st_radio_user_role within u_insurance_edit
end type
type st_radio_active from u_st_radio_user_role within u_insurance_edit
end type
end forward

global type u_insurance_edit from userobject
integer width = 2400
integer height = 1748
long backcolor = 33538240
long tabtextcolor = 33554432
long tabbackcolor = 16777215
long picturemaskcolor = 536870912
event carrier_selected ( string ps_insurance_id,  string ps_description,  string ps_insurance_type )
event carrier_unselected ( )
cb_edit_types cb_edit_types
st_authority_type_t st_authority_type_t
st_authority_types st_authority_types
st_page st_page
pb_down pb_down
pb_up pb_up
cb_edit_categories cb_edit_categories
st_status_title st_status_title
st_1 st_1
st_authority_category st_authority_category
st_title st_title
cb_new cb_new
dw_carriers dw_carriers
st_radio_inactive st_radio_inactive
st_radio_active st_radio_active
end type
global u_insurance_edit u_insurance_edit

type variables
string display_status
string authority_type,authority_category

string mode
boolean allow_editing



end variables

forward prototypes
public subroutine refresh ()
public subroutine carrier_menu (long pl_row)
public function integer initialize (string ps_mode)
end prototypes

public subroutine refresh ();
dw_carriers.retrieve(authority_type, authority_category, display_status)

if display_status = "OK" then
	cb_new.enabled = true
else
	cb_new.enabled = false
end if
dw_carriers.last_page = 0
dw_carriers.set_page(1, st_page.text)
if dw_carriers.last_page < 2 then
	pb_down.visible = false
	pb_up.visible = false
else
	pb_down.visible = true
	pb_up.visible = true
	pb_up.enabled = false
	pb_down.enabled = true
end if




end subroutine

public subroutine carrier_menu (long pl_row);str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
long ll_row

ll_row = dw_carriers.get_selected_row()
if ll_row <= 0 then return

if display_status = "OK" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Carrier Attributes"
	popup.button_titles[popup.button_count] = "Edit Carrier"
	buttons[popup.button_count] = "EDIT"
end if

if display_status = "OK" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Set Carrier as Inactive"
	popup.button_titles[popup.button_count] = "Inactive"
	buttons[popup.button_count] = "INACTIVE"
end if

if display_status = "NA" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Set Carrier as Active"
	popup.button_titles[popup.button_count] = "Active"
	buttons[popup.button_count] = "ACTIVE"
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
	CASE "EDIT"
		popup.data_row_count = 1
		popup.items[1] = dw_carriers.object.authority_id[ll_row]
		popup.title = dw_carriers.object.name[ll_row]
		openwithparm(w_carrier_definition, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		refresh()
		dw_carriers.scrolltorow(ll_row)
	CASE "INACTIVE"
		dw_carriers.object.status[ll_row] = "NA"
		dw_carriers.update()
		refresh()
	CASE "ACTIVE"
		dw_carriers.object.status[ll_row] = "OK"
		dw_carriers.update()
		refresh()
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return


end subroutine

public function integer initialize (string ps_mode);
mode = ps_mode

st_title.width = width
dw_carriers.height = height - dw_carriers.y

if user_list.is_user_service(current_user.user_id, "CONFIG_INSURANCE_CARRIER") then
	cb_edit_types.visible = true
	cb_edit_categories.visible = true
	cb_new.visible = true
	allow_editing = true
else
	cb_edit_types.visible = false
	cb_edit_categories.visible = true
	cb_new.visible = false
	allow_editing = false
end if

st_authority_category.text = "<All>"
authority_type = "%"
authority_category = "%"

st_radio_active.postevent("clicked")

return 1

end function

on u_insurance_edit.create
this.cb_edit_types=create cb_edit_types
this.st_authority_type_t=create st_authority_type_t
this.st_authority_types=create st_authority_types
this.st_page=create st_page
this.pb_down=create pb_down
this.pb_up=create pb_up
this.cb_edit_categories=create cb_edit_categories
this.st_status_title=create st_status_title
this.st_1=create st_1
this.st_authority_category=create st_authority_category
this.st_title=create st_title
this.cb_new=create cb_new
this.dw_carriers=create dw_carriers
this.st_radio_inactive=create st_radio_inactive
this.st_radio_active=create st_radio_active
this.Control[]={this.cb_edit_types,&
this.st_authority_type_t,&
this.st_authority_types,&
this.st_page,&
this.pb_down,&
this.pb_up,&
this.cb_edit_categories,&
this.st_status_title,&
this.st_1,&
this.st_authority_category,&
this.st_title,&
this.cb_new,&
this.dw_carriers,&
this.st_radio_inactive,&
this.st_radio_active}
end on

on u_insurance_edit.destroy
destroy(this.cb_edit_types)
destroy(this.st_authority_type_t)
destroy(this.st_authority_types)
destroy(this.st_page)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.cb_edit_categories)
destroy(this.st_status_title)
destroy(this.st_1)
destroy(this.st_authority_category)
destroy(this.st_title)
destroy(this.cb_new)
destroy(this.dw_carriers)
destroy(this.st_radio_inactive)
destroy(this.st_radio_active)
end on

type cb_edit_types from commandbutton within u_insurance_edit
integer x = 1783
integer y = 600
integer width = 462
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Edit Types"
end type

event clicked;open(w_authority_types_edit)

end event

type st_authority_type_t from statictext within u_insurance_edit
integer x = 1723
integer y = 364
integer width = 553
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Authority Type"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_authority_types from statictext within u_insurance_edit
integer x = 1705
integer y = 456
integer width = 645
integer height = 108
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "<All>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_authority_type_pick_list"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.add_blank_row = true
popup.blank_text = "<All>"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	authority_type = "%"
	text = "<All>"
else
	authority_type = popup_return.items[1]
	text = popup_return.descriptions[1]
end if

refresh()

end event

type st_page from statictext within u_insurance_edit
integer x = 1682
integer y = 112
integer width = 338
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99/99"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_down from u_picture_button within u_insurance_edit
boolean visible = false
integer x = 1673
integer y = 200
integer width = 137
integer height = 116
integer taborder = 30
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_carriers.current_page
li_last_page = dw_carriers.last_page

dw_carriers.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type pb_up from u_picture_button within u_insurance_edit
boolean visible = false
integer x = 1861
integer y = 200
integer width = 137
integer height = 116
integer taborder = 30
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_carriers.current_page

dw_carriers.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true
end event

type cb_edit_categories from commandbutton within u_insurance_edit
integer x = 1806
integer y = 976
integer width = 462
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Edit Categories"
end type

event clicked;open(w_authority_categories_edit)
end event

type st_status_title from statictext within u_insurance_edit
integer x = 1792
integer y = 1164
integer width = 503
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Authority Status"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within u_insurance_edit
integer x = 1737
integer y = 744
integer width = 622
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Authority Categories"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_authority_category from statictext within u_insurance_edit
integer x = 1710
integer y = 832
integer width = 645
integer height = 108
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "<All>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_authority_category_pick_list"
popup.datacolumn = 2
popup.displaycolumn = 3
popup.add_blank_row = true
popup.blank_text = "<All>"
popup.argument_count = 1
popup.argument[1] = authority_type
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	authority_category = "%"
	text = "<All>"
else
	authority_category = popup_return.items[1]
	text = popup_return.descriptions[1]
end if

refresh()

end event

type st_title from statictext within u_insurance_edit
integer width = 2409
integer height = 92
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Authorities"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_new from commandbutton within u_insurance_edit
integer x = 1787
integer y = 1580
integer width = 462
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Authority"
end type

event clicked;String ls_authority_type,ls_authority_category
str_popup popup

if authority_type = "%" then
	Setnull(ls_authority_type)
end if
if authority_category = "%" then
	Setnull(ls_authority_category)
end if
popup.data_row_count = 2
popup.items[1] = ls_authority_type
popup.items[2] = ls_authority_category

Openwithparm(w_carrier_definition, popup)

Refresh()

end event

type dw_carriers from u_dw_pick_list within u_insurance_edit
integer y = 104
integer width = 1646
integer height = 1608
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_insurance_display_list"
boolean border = false
boolean livescroll = false
end type

event constructor;call super::constructor;settransobject(sqlca)

end event

event selected;string ls_insurance_id
string ls_insurance_description,ls_insurance_type


CHOOSE CASE mode
	CASE "EDIT"
		if allow_editing then
			carrier_menu(selected_row)
		end if
	CASE "PICK"
		ls_insurance_id = object.authority_id[selected_row]
		ls_insurance_description = object.name[selected_row]
		ls_insurance_type = object.authority_type[selected_row]
		if not isnull(ls_insurance_id) then parent.event POST carrier_selected(ls_insurance_id, ls_insurance_description,ls_insurance_type)
END CHOOSE




end event

event post_click;call super::post_click;if lasttype = 'compute' and allow_editing then
	carrier_menu(clicked_row)
end if


end event

event unselected;call super::unselected;parent.event POST carrier_unselected()
end event

type st_radio_inactive from u_st_radio_user_role within u_insurance_edit
event clicked pbm_bnclicked
integer x = 1797
integer y = 1404
integer width = 457
integer height = 108
boolean bringtotop = true
string text = "Inactive"
end type

event clicked;call super::clicked;display_status = "NA"
refresh()

end event

type st_radio_active from u_st_radio_user_role within u_insurance_edit
event clicked pbm_bnclicked
integer x = 1797
integer y = 1260
integer width = 457
integer height = 108
boolean bringtotop = true
string text = "Active"
end type

event clicked;call super::clicked;display_status = "OK"
refresh()

end event

