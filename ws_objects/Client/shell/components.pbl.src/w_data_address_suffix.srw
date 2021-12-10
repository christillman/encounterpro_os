$PBExportHeader$w_data_address_suffix.srw
forward
global type w_data_address_suffix from w_window_base
end type
type cb_finished from commandbutton within w_data_address_suffix
end type
type cb_cancel from commandbutton within w_data_address_suffix
end type
type cbx_display_code from checkbox within w_data_address_suffix
end type
type st_1 from statictext within w_data_address_suffix
end type
type st_lookup_owner from statictext within w_data_address_suffix
end type
type st_lookup_code_domain from statictext within w_data_address_suffix
end type
type st_display_format_title from statictext within w_data_address_suffix
end type
type st_display_format from statictext within w_data_address_suffix
end type
type st_6 from statictext within w_data_address_suffix
end type
type st_lookup_owner_title from statictext within w_data_address_suffix
end type
type st_lookup_code_domain_title from statictext within w_data_address_suffix
end type
type cb_clear_lookup from commandbutton within w_data_address_suffix
end type
type cb_clear_display_format from commandbutton within w_data_address_suffix
end type
end forward

global type w_data_address_suffix from w_window_base
integer x = 439
integer y = 592
integer width = 2377
integer height = 1184
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
cb_finished cb_finished
cb_cancel cb_cancel
cbx_display_code cbx_display_code
st_1 st_1
st_lookup_owner st_lookup_owner
st_lookup_code_domain st_lookup_code_domain
st_display_format_title st_display_format_title
st_display_format st_display_format
st_6 st_6
st_lookup_owner_title st_lookup_owner_title
st_lookup_code_domain_title st_lookup_code_domain_title
cb_clear_lookup cb_clear_lookup
cb_clear_display_format cb_clear_display_format
end type
global w_data_address_suffix w_data_address_suffix

type variables
str_property_suffix property_suffix


end variables

event open;call super::open;
property_suffix = message.powerobjectparm

st_display_format_title.text = wordcap(property_suffix.datatype) + " Display Format"

if not isnull(property_suffix.display_code) then
	cbx_display_code.checked = property_suffix.display_code
end if

if property_suffix.lookup_owner_id >= 0 and len(property_suffix.lookup_code_domain) > 0 then
	st_lookup_owner.text = string(property_suffix.lookup_owner_id)
	st_lookup_code_domain.text = property_suffix.lookup_code_domain
end if

if len(property_suffix.format_string) > 0 then
	st_display_format.text = property_suffix.format_string
end if

refresh()

end event

on w_data_address_suffix.create
int iCurrent
call super::create
this.cb_finished=create cb_finished
this.cb_cancel=create cb_cancel
this.cbx_display_code=create cbx_display_code
this.st_1=create st_1
this.st_lookup_owner=create st_lookup_owner
this.st_lookup_code_domain=create st_lookup_code_domain
this.st_display_format_title=create st_display_format_title
this.st_display_format=create st_display_format
this.st_6=create st_6
this.st_lookup_owner_title=create st_lookup_owner_title
this.st_lookup_code_domain_title=create st_lookup_code_domain_title
this.cb_clear_lookup=create cb_clear_lookup
this.cb_clear_display_format=create cb_clear_display_format
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_finished
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cbx_display_code
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_lookup_owner
this.Control[iCurrent+6]=this.st_lookup_code_domain
this.Control[iCurrent+7]=this.st_display_format_title
this.Control[iCurrent+8]=this.st_display_format
this.Control[iCurrent+9]=this.st_6
this.Control[iCurrent+10]=this.st_lookup_owner_title
this.Control[iCurrent+11]=this.st_lookup_code_domain_title
this.Control[iCurrent+12]=this.cb_clear_lookup
this.Control[iCurrent+13]=this.cb_clear_display_format
end on

on w_data_address_suffix.destroy
call super::destroy
destroy(this.cb_finished)
destroy(this.cb_cancel)
destroy(this.cbx_display_code)
destroy(this.st_1)
destroy(this.st_lookup_owner)
destroy(this.st_lookup_code_domain)
destroy(this.st_display_format_title)
destroy(this.st_display_format)
destroy(this.st_6)
destroy(this.st_lookup_owner_title)
destroy(this.st_lookup_code_domain_title)
destroy(this.cb_clear_lookup)
destroy(this.cb_clear_display_format)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_data_address_suffix
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_data_address_suffix
end type

type cb_finished from commandbutton within w_data_address_suffix
integer x = 1874
integer y = 984
integer width = 434
integer height = 116
integer taborder = 20
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

event clicked;closewithreturn(parent, property_suffix)


end event

type cb_cancel from commandbutton within w_data_address_suffix
integer x = 82
integer y = 984
integer width = 434
integer height = 116
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;str_property_suffix lstr_suffix

setnull(lstr_suffix.datatype)

closewithreturn(parent, lstr_suffix)


end event

type cbx_display_code from checkbox within w_data_address_suffix
integer x = 347
integer y = 268
integer width = 1641
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
string text = "Display Code (do not translate to descriptive text)"
boolean lefttext = true
end type

event clicked;property_suffix.display_code = checked
end event

type st_1 from statictext within w_data_address_suffix
integer x = 302
integer y = 508
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Code Lookup"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_lookup_owner from statictext within w_data_address_suffix
integer x = 736
integer y = 492
integer width = 425
integer height = 100
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


popup.dataobject = "dw_interface_pick_list"
popup.datacolumn = 2
popup.displaycolumn = 6
popup.add_blank_row = true
popup.blank_text = "<Other Interface Service>"
popup.blank_at_bottom = true
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	popup.title = "Enter the Owner ID of the desired code translation"
	openwithparm(w_pop_prompt_string, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return
end if

if isnumber(popup_return.items[1]) then
	property_suffix.lookup_owner_id = long(popup_return.items[1])
	text = string(property_suffix.lookup_owner_id)
	
	// Since we have a value, make sure the DisplayCode flag isn't null because that's the signal for no suffix
	property_suffix.display_code = cbx_display_code.checked
end if

end event

type st_lookup_code_domain from statictext within w_data_address_suffix
integer x = 1221
integer y = 492
integer width = 795
integer height = 100
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

if property_suffix.lookup_owner_id >= 0 then
	popup.dataobject = "dw_c_xml_domain_pick"
	popup.datacolumn = 1
	popup.displaycolumn = 1
	popup.argument_count = 1
	popup.argument[1] = string(property_suffix.lookup_owner_id )
	popup.numeric_argument = true
	popup.add_blank_row = true
	popup.blank_text = "<Other Domain>"
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return
	
	if popup_return.items[1] = "" then
		popup.title = "Enter the desired code domain"
		popup.displaycolumn = 0
		popup.argument_count = 1
		popup.argument[1] = "LookupCodeDomain"
		popup.add_blank_row = false
		openwithparm(w_pop_prompt_string, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
	end if
	
	property_suffix.lookup_code_domain = popup_return.items[1]
	text = property_suffix.lookup_code_domain
	
	// Since we have a value, make sure the DisplayCode flag isn't null because that's the signal for no suffix
	property_suffix.display_code = cbx_display_code.checked
else
	openwithparm(w_pop_message, "You must enter an owner id before selecting a code domain")
	return
end if


end event

type st_display_format_title from statictext within w_data_address_suffix
integer x = 96
integer y = 756
integer width = 731
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Display Format"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_display_format from statictext within w_data_address_suffix
integer x = 878
integer y = 740
integer width = 864
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "<Default>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_c_domain_property_display_pick"
popup.datacolumn = 3
popup.displaycolumn = 4
popup.argument_count = 1
popup.add_blank_row = true
popup.blank_text = "<Other Format>"
popup.blank_at_bottom = true
popup.blank_text_column = "data"
popup.argument[1] = "PropDspFmt" + wordcap(property_suffix.datatype)
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	popup.title = "Enter the desired format"
	popup.displaycolumn = 0
	popup.argument_count = 1
	popup.argument[1] = "PropDspFmt" + wordcap(property_suffix.datatype)
	popup.add_blank_row = false
	openwithparm(w_pop_prompt_string, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return
end if

property_suffix.format_string = popup_return.items[1]
text = property_suffix.format_string

// Since we have a value, make sure the DisplayCode flag isn't null because that's the signal for no suffix
property_suffix.display_code = cbx_display_code.checked


end event

type st_6 from statictext within w_data_address_suffix
integer width = 2345
integer height = 188
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Use these options to affect how the selected property appears in the output document."
alignment alignment = center!
boolean focusrectangle = false
end type

type st_lookup_owner_title from statictext within w_data_address_suffix
integer x = 736
integer y = 424
integer width = 425
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Owner"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_lookup_code_domain_title from statictext within w_data_address_suffix
integer x = 1221
integer y = 424
integer width = 795
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Code Domain"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_clear_lookup from commandbutton within w_data_address_suffix
integer x = 2034
integer y = 524
integer width = 219
integer height = 68
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;
setnull(property_suffix.lookup_owner_id)
setnull(property_suffix.lookup_code_domain)

st_lookup_owner.text = ""
st_lookup_code_domain.text = ""



end event

type cb_clear_display_format from commandbutton within w_data_address_suffix
integer x = 1755
integer y = 772
integer width = 219
integer height = 68
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;
setnull(property_suffix.format_string)

st_display_format.text = "<Default>"



end event

