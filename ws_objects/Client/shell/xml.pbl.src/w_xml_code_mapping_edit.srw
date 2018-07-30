$PBExportHeader$w_xml_code_mapping_edit.srw
forward
global type w_xml_code_mapping_edit from w_window_base
end type
type st_interface_service from statictext within w_xml_code_mapping_edit
end type
type st_code_mapping_title from statictext within w_xml_code_mapping_edit
end type
type dw_mappings from u_dw_pick_list within w_xml_code_mapping_edit
end type
type cb_ok from commandbutton within w_xml_code_mapping_edit
end type
type st_code_domain_title from statictext within w_xml_code_mapping_edit
end type
type st_code_domain from statictext within w_xml_code_mapping_edit
end type
type st_code_title from statictext within w_xml_code_mapping_edit
end type
type st_code from statictext within w_xml_code_mapping_edit
end type
type st_epro_domain_title from statictext within w_xml_code_mapping_edit
end type
type st_epro_domain from statictext within w_xml_code_mapping_edit
end type
type cb_add_mapping from commandbutton within w_xml_code_mapping_edit
end type
type st_1 from statictext within w_xml_code_mapping_edit
end type
type st_2 from statictext within w_xml_code_mapping_edit
end type
end forward

global type w_xml_code_mapping_edit from w_window_base
integer x = 151
integer y = 152
integer width = 2638
integer height = 1600
string title = "Interface Service Code Mappings"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean show_more_buttons = false
boolean auto_resize_window = false
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
st_interface_service st_interface_service
st_code_mapping_title st_code_mapping_title
dw_mappings dw_mappings
cb_ok cb_ok
st_code_domain_title st_code_domain_title
st_code_domain st_code_domain
st_code_title st_code_title
st_code st_code
st_epro_domain_title st_epro_domain_title
st_epro_domain st_epro_domain
cb_add_mapping cb_add_mapping
st_1 st_1
st_2 st_2
end type
global w_xml_code_mapping_edit w_xml_code_mapping_edit

type variables
str_c_xml_code mapping

string code_dataobject = "dw_xml_code_mapping_edit"
string epro_id_dataobject = "dw_xml_epro_id_mapping_edit"

string edit_which // "code" or "epro_id" identifies which will get modified on edit
integer button_pressed

end variables

forward prototypes
public function integer refresh ()
public subroutine mapping_menu (long pl_row)
end prototypes

public function integer refresh ();string ls_temp
string ls_find
long ll_row


st_interface_service.text = sqlca.fn_owner_description(mapping.owner_id)

st_code_domain.text = mapping.code_domain
st_epro_domain.text = mapping.epro_domain

if edit_which = "epro_id" then
	st_code.text = f_code_display(mapping.code, mapping.code_description)
else
	st_code.text = f_code_display(mapping.epro_id, mapping.epro_description)
end if

dw_mappings.settransobject(sqlca)

if dw_mappings.dataobject = code_dataobject then
	dw_mappings.retrieve(mapping.owner_id, mapping.code_domain, mapping.code, mapping.epro_domain)
else
	dw_mappings.retrieve(mapping.owner_id, mapping.code_domain, mapping.epro_id, mapping.epro_domain)
end if


//// See if there is a locally owned mapping
//ls_find = "mapping_owner_id=" + string(sqlca.customer_id)
//ll_row = dw_mappings.find(ls_find, 1, dw_mappings.rowcount())
//if ll_row > 0 then
//	cb_add_mapping.visible = false
//else
//	cb_add_mapping.visible = true
//end if

return 1

end function

public subroutine mapping_menu (long pl_row);String		lsa_buttons[]
String 		ls_drug_id,ls_temp
String 		ls_description,ls_null
String		ls_top_20_code
Integer		li_sts, li_service_count
Long			ll_null
window 				lw_pop_buttons
str_popup 			popup
str_popup 			popup2
str_popup_return 	popup_return
string ls_epro_id
long ll_sts
string ls_new_epro_id
string ls_epro_description
long ll_epro_owner_id
long ll_new_code_id
str_domain_item lstr_domain_item
long ll_code_id
string ls_code

Setnull(ls_null)
Setnull(ll_null)

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_delete.bmp"
	popup.button_helps[popup.button_count] = "Delete this mapping"
	popup.button_titles[popup.button_count] = "Delete"
	lsa_buttons[popup.button_count] = "DELETE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_edit2.bmp"
	popup.button_helps[popup.button_count] = "Change the Epro ID for this mapping"
	popup.button_titles[popup.button_count] = "Change"
	lsa_buttons[popup.button_count] = "CHANGE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_default.bmp"
	popup.button_helps[popup.button_count] = "Set this mapping as the default mapping"
	popup.button_titles[popup.button_count] = "Set Default"
	lsa_buttons[popup.button_count] = "SETDEFAULT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	lsa_buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	button_pressed = message.doubleparm
	if button_pressed < 1 or button_pressed > popup.button_count then
		return
	end if
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if

CHOOSE CASE lsa_buttons[button_pressed]
	CASE "DELETE"
		openwithparm(w_pop_yes_no, "Are you sure you want to delete this mapping?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		
		if edit_which = "code" then
			ls_code = dw_mappings.object.code[pl_row]
			ll_sts = sqlca.xml_remove_mapping(mapping.owner_id, mapping.code_domain, mapping.code_version, ls_code, mapping.epro_domain, mapping.epro_id, current_scribe.user_id, 0)
			if not tf_check() then return
		else
			ls_epro_id = dw_mappings.object.epro_id[pl_row]
			ll_sts = sqlca.xml_remove_mapping(mapping.owner_id, mapping.code_domain, mapping.code_version, mapping.code, mapping.epro_domain, ls_epro_id, current_scribe.user_id, 0)
			if not tf_check() then return
		end if
	CASE "CHANGE"
		ll_code_id = dw_mappings.object.code_id[pl_row]
		f_edit_mapping(ll_code_id, edit_which)
	CASE "SETDEFAULT"
		if edit_which = "code" then
			ls_code = dw_mappings.object.code[pl_row]
			ll_sts = sqlca.xml_set_default_mapping(mapping.owner_id, mapping.code_domain, mapping.code_version, ls_code, mapping.epro_domain, mapping.epro_id)
			if not tf_check() then return
		else
			ls_epro_id = dw_mappings.object.epro_id[pl_row]
			ll_sts = sqlca.xml_set_default_mapping(mapping.owner_id, mapping.code_domain, mapping.code_version, mapping.code, mapping.epro_domain, ls_epro_id)
			if not tf_check() then return
		end if
	CASE "CANCEL"
	CASE ELSE
END CHOOSE

refresh()

Return

end subroutine

on w_xml_code_mapping_edit.create
int iCurrent
call super::create
this.st_interface_service=create st_interface_service
this.st_code_mapping_title=create st_code_mapping_title
this.dw_mappings=create dw_mappings
this.cb_ok=create cb_ok
this.st_code_domain_title=create st_code_domain_title
this.st_code_domain=create st_code_domain
this.st_code_title=create st_code_title
this.st_code=create st_code
this.st_epro_domain_title=create st_epro_domain_title
this.st_epro_domain=create st_epro_domain
this.cb_add_mapping=create cb_add_mapping
this.st_1=create st_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_interface_service
this.Control[iCurrent+2]=this.st_code_mapping_title
this.Control[iCurrent+3]=this.dw_mappings
this.Control[iCurrent+4]=this.cb_ok
this.Control[iCurrent+5]=this.st_code_domain_title
this.Control[iCurrent+6]=this.st_code_domain
this.Control[iCurrent+7]=this.st_code_title
this.Control[iCurrent+8]=this.st_code
this.Control[iCurrent+9]=this.st_epro_domain_title
this.Control[iCurrent+10]=this.st_epro_domain
this.Control[iCurrent+11]=this.cb_add_mapping
this.Control[iCurrent+12]=this.st_1
this.Control[iCurrent+13]=this.st_2
end on

on w_xml_code_mapping_edit.destroy
call super::destroy
destroy(this.st_interface_service)
destroy(this.st_code_mapping_title)
destroy(this.dw_mappings)
destroy(this.cb_ok)
destroy(this.st_code_domain_title)
destroy(this.st_code_domain)
destroy(this.st_code_title)
destroy(this.st_code)
destroy(this.st_epro_domain_title)
destroy(this.st_epro_domain)
destroy(this.cb_add_mapping)
destroy(this.st_1)
destroy(this.st_2)
end on

event open;call super::open;integer li_sts

mapping = message.powerobjectparm

this.x = main_window.x + ((main_window.width - this.width) / 2)
this.y = main_window.y + ((main_window.height - this.height) / 2)

if not isnull(mapping.code) then
	dw_mappings.dataobject = code_dataobject
	edit_which = "epro_id"
	st_code_title.text = "Code:"
elseif not isnull(mapping.epro_id) then
	dw_mappings.dataobject = epro_id_dataobject
	edit_which = "code"
	st_code_title.text = "Epro ID:"
else
	log.log(this, "open", "No code or epro_id", 4)
	close(this)
	return
end if

li_sts = refresh()
if li_sts <= 0 then
	close(this)
	return
end if


end event

event resize;call super::resize;st_interface_service.width = width


cb_ok.x = width - cb_ok.width - 50
cb_ok.y = height - cb_ok.height - 150

dw_mappings.width = width - dw_mappings.x - 50
dw_mappings.height = cb_ok.y - dw_mappings.y - 50

st_code_mapping_title.width = dw_mappings.width - 100
end event

type pb_epro_help from w_window_base`pb_epro_help within w_xml_code_mapping_edit
integer x = 2830
integer taborder = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_xml_code_mapping_edit
integer x = 64
integer y = 1496
end type

type st_interface_service from statictext within w_xml_code_mapping_edit
integer width = 2633
integer height = 84
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Interface Service ###"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_code_mapping_title from statictext within w_xml_code_mapping_edit
integer x = 78
integer y = 292
integer width = 722
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
string text = "Code Mappings"
boolean focusrectangle = false
end type

type dw_mappings from u_dw_pick_list within w_xml_code_mapping_edit
integer x = 23
integer y = 372
integer width = 2587
integer height = 972
integer taborder = 0
boolean bringtotop = true
string dataobject = "dw_xml_code_mapping_edit"
boolean vscrollbar = true
end type

event selected;call super::selected;mapping_menu(selected_row)

refresh()

end event

type cb_ok from commandbutton within w_xml_code_mapping_edit
integer x = 2144
integer y = 1376
integer width = 402
integer height = 112
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

event clicked;str_popup_return popup_return


popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type st_code_domain_title from statictext within w_xml_code_mapping_edit
integer x = 78
integer y = 120
integer width = 425
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
string text = "Code Domain:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_code_domain from statictext within w_xml_code_mapping_edit
integer x = 521
integer y = 112
integer width = 608
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type st_code_title from statictext within w_xml_code_mapping_edit
integer x = 1143
integer y = 120
integer width = 247
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
string text = "Epro ID:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_code from statictext within w_xml_code_mapping_edit
integer x = 1408
integer y = 112
integer width = 1138
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type st_epro_domain_title from statictext within w_xml_code_mapping_edit
integer x = 965
integer y = 224
integer width = 425
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
string text = "Epro Domain:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_epro_domain from statictext within w_xml_code_mapping_edit
integer x = 1408
integer y = 216
integer width = 608
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type cb_add_mapping from commandbutton within w_xml_code_mapping_edit
integer x = 1070
integer y = 1376
integer width = 498
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Mapping"
boolean default = true
end type

event clicked;long ll_new_code_id
str_domain_item lstr_domain_item

if edit_which = "code" then
	lstr_domain_item = f_pick_interface_domain_item(mapping.owner_id, mapping.code_domain, "Select the new " + mapping.code_domain + " value to map to ~"" + mapping.epro_id + "~".")
	
	// If we don't have a new epro_id then return 0
	if isnull(lstr_domain_item.domain_item) then return
	
	ll_new_code_id = sqlca.xml_add_mapping(mapping.owner_id, mapping.code_domain, mapping.code_version, lstr_domain_item.domain_item, lstr_domain_item.domain_item_description, mapping.epro_domain, mapping.epro_id, mapping.epro_description, lstr_domain_item.domain_item_owner_id, current_scribe.user_id)
	if not tf_check() then return
else
	lstr_domain_item = f_pick_domain_item(mapping.epro_domain, "Select the new " + mapping.epro_domain + " value to map to ~"" + mapping.code + "~".")
	
	// If we don't have a new epro_id then return 0
	if isnull(lstr_domain_item.domain_item) then return
	
	ll_new_code_id = sqlca.xml_add_mapping(mapping.owner_id, mapping.code_domain, mapping.code_version, mapping.code, mapping.code_description, mapping.epro_domain, lstr_domain_item.domain_item, lstr_domain_item.domain_item_description, lstr_domain_item.domain_item_owner_id, current_scribe.user_id)
	if not tf_check() then return
end if

refresh()

end event

type st_1 from statictext within w_xml_code_mapping_edit
integer x = 73
integer y = 1400
integer width = 59
integer height = 64
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "*"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_xml_code_mapping_edit
integer x = 151
integer y = 1396
integer width = 571
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
string text = "= Default Mapping"
boolean focusrectangle = false
end type

