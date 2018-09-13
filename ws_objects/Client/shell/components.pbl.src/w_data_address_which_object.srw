$PBExportHeader$w_data_address_which_object.srw
forward
global type w_data_address_which_object from w_window_base
end type
type cb_ok from commandbutton within w_data_address_which_object
end type
type sle_filter from singlelineedit within w_data_address_which_object
end type
type em_ordinal from editmask within w_data_address_which_object
end type
type st_which_object_class from statictext within w_data_address_which_object
end type
type st_2 from statictext within w_data_address_which_object
end type
type st_which_object_class_title from statictext within w_data_address_which_object
end type
type st_filter_title from statictext within w_data_address_which_object
end type
type st_ordinal_title from statictext within w_data_address_which_object
end type
type st_epro_object from statictext within w_data_address_which_object
end type
type cb_clear_class from commandbutton within w_data_address_which_object
end type
type rb_from_first from radiobutton within w_data_address_which_object
end type
type rb_from_last from radiobutton within w_data_address_which_object
end type
type rb_of_last from radiobutton within w_data_address_which_object
end type
type em_of_last from editmask within w_data_address_which_object
end type
end forward

global type w_data_address_which_object from w_window_base
integer width = 1499
integer height = 1008
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_ok cb_ok
sle_filter sle_filter
em_ordinal em_ordinal
st_which_object_class st_which_object_class
st_2 st_2
st_which_object_class_title st_which_object_class_title
st_filter_title st_filter_title
st_ordinal_title st_ordinal_title
st_epro_object st_epro_object
cb_clear_class cb_clear_class
rb_from_first rb_from_first
rb_from_last rb_from_last
rb_of_last rb_of_last
em_of_last em_of_last
end type
global w_data_address_which_object w_data_address_which_object

type variables
str_property_specification property_specification 
end variables

on w_data_address_which_object.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.sle_filter=create sle_filter
this.em_ordinal=create em_ordinal
this.st_which_object_class=create st_which_object_class
this.st_2=create st_2
this.st_which_object_class_title=create st_which_object_class_title
this.st_filter_title=create st_filter_title
this.st_ordinal_title=create st_ordinal_title
this.st_epro_object=create st_epro_object
this.cb_clear_class=create cb_clear_class
this.rb_from_first=create rb_from_first
this.rb_from_last=create rb_from_last
this.rb_of_last=create rb_of_last
this.em_of_last=create em_of_last
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.sle_filter
this.Control[iCurrent+3]=this.em_ordinal
this.Control[iCurrent+4]=this.st_which_object_class
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_which_object_class_title
this.Control[iCurrent+7]=this.st_filter_title
this.Control[iCurrent+8]=this.st_ordinal_title
this.Control[iCurrent+9]=this.st_epro_object
this.Control[iCurrent+10]=this.cb_clear_class
this.Control[iCurrent+11]=this.rb_from_first
this.Control[iCurrent+12]=this.rb_from_last
this.Control[iCurrent+13]=this.rb_of_last
this.Control[iCurrent+14]=this.em_of_last
end on

on w_data_address_which_object.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.sle_filter)
destroy(this.em_ordinal)
destroy(this.st_which_object_class)
destroy(this.st_2)
destroy(this.st_which_object_class_title)
destroy(this.st_filter_title)
destroy(this.st_ordinal_title)
destroy(this.st_epro_object)
destroy(this.cb_clear_class)
destroy(this.rb_from_first)
destroy(this.rb_from_last)
destroy(this.rb_of_last)
destroy(this.em_of_last)
end on

event open;call super::open;property_specification = message.powerobjectparm


if lower(property_specification.property.property_value_object) = "treatmenttypeselect" then
	st_which_object_class.event trigger clicked()
	cb_ok.event trigger clicked()
	return
end if

if isnull(property_specification.property.property_value_object_cat_qury) and isnull(property_specification.property.property_value_object_cat_fld) then
		st_which_object_class.text = "N/A"
		st_which_object_class.enabled = false
		cb_clear_class.visible = false
else
	if len(property_specification.which_object.object_identifier) > 0 then
		st_which_object_class.text = property_specification.which_object.object_identifier
		cb_clear_class.visible = true
	else
		cb_clear_class.visible = false
	end if
end if

if len(property_specification.which_object.filter_statement ) > 0 then
	sle_filter.text = property_specification.which_object.filter_statement
end if

if not isnull(property_specification.which_object.ordinal) then
	if not isnull(property_specification.which_object.recent_set_count) then
		em_ordinal.text = string(property_specification.which_object.ordinal)
		em_of_last.text = string(property_specification.which_object.recent_set_count)
		rb_of_last.checked = true
		em_of_last.visible = true
	elseif property_specification.which_object.ordinal < 0 then
		em_ordinal.text = string(abs(property_specification.which_object.ordinal))
		rb_from_last.checked = true
	else
		em_ordinal.text = string(property_specification.which_object.ordinal)
		rb_from_first.checked = true
	end if
end if



end event

type pb_epro_help from w_window_base`pb_epro_help within w_data_address_which_object
integer x = 2830
integer y = 12
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_data_address_which_object
integer x = 64
integer y = 1496
end type

type cb_ok from commandbutton within w_data_address_which_object
integer x = 539
integer y = 716
integer width = 402
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Done"
boolean default = true
end type

event clicked;string ls_ordinal

property_specification.which_object.which_object_string = ""

if st_which_object_class.enabled and len(st_which_object_class.text) > 0 then
	property_specification.which_object.object_identifier = st_which_object_class.text
	property_specification.which_object.which_object_string = property_specification.which_object.object_identifier
else
	setnull(property_specification.which_object.object_identifier)
end if

if len(sle_filter.text ) > 0 then
	property_specification.which_object.filter_statement = sle_filter.text
	if len(property_specification.which_object.which_object_string) > 0 then
		property_specification.which_object.which_object_string += "."
	end if
	property_specification.which_object.which_object_string += "~"" + property_specification.which_object.filter_statement + "~""
else
	setnull(property_specification.which_object.filter_statement)
end if

if len(em_ordinal.text) > 0 then
	property_specification.which_object.ordinal = long(em_ordinal.text)
	if rb_from_first.checked then
		property_specification.which_object.ordinal = abs(property_specification.which_object.ordinal)
		setnull(property_specification.which_object.recent_set_count)
	elseif rb_from_last.checked then 
		property_specification.which_object.ordinal = -abs(property_specification.which_object.ordinal)
		setnull(property_specification.which_object.recent_set_count)
	elseif rb_of_last.checked and len(em_of_last.text) > 0 then
		property_specification.which_object.ordinal = abs(property_specification.which_object.ordinal)
		property_specification.which_object.recent_set_count = abs(long(em_of_last.text))
	end if
	
	if len(property_specification.which_object.which_object_string) > 0 then
		property_specification.which_object.which_object_string += "."
	end if
	if property_specification.which_object.recent_set_count > 0 then
		property_specification.which_object.which_object_string += string(property_specification.which_object.recent_set_count)
		property_specification.which_object.which_object_string += "-"
		property_specification.which_object.which_object_string += string(property_specification.which_object.ordinal)
	else
		property_specification.which_object.which_object_string += string(property_specification.which_object.ordinal)
	end if
else
	setnull(property_specification.which_object.ordinal)
	setnull(property_specification.which_object.recent_set_count)
end if



closewithreturn(parent, property_specification)
end event

type sle_filter from singlelineedit within w_data_address_which_object
integer x = 430
integer y = 256
integer width = 827
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
borderstyle borderstyle = stylelowered!
end type

type em_ordinal from editmask within w_data_address_which_object
integer x = 370
integer y = 460
integer width = 178
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
borderstyle borderstyle = stylelowered!
string mask = "#"
end type

event modified;long ll_ordinal

if len(text) > 0 then
	ll_ordinal = long(text)
	if ll_ordinal < 0 then
		text = string(abs(ll_ordinal))
		rb_from_last.checked = true
		return
	end if
end if


end event

type st_which_object_class from statictext within w_data_address_which_object
integer x = 430
integer y = 92
integer width = 677
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;u_ds_data luo_data
str_popup popup
str_popup_return popup_return
long i
string ls_left
string ls_right
str_param_setting lstr_param
str_param_wizard_return lstr_return
long ll_count
w_param_setting lw_param_window

luo_data = CREATE u_ds_data

// See if the cat query is a param class
f_split_string(property_specification.property.property_value_object_cat_qury, ",", ls_left, ls_right)
SELECT count(*)
INTO :ll_count
FROM c_Component_Param_Class
WHERE param_class = :ls_left;
if not tf_check() then return

if ll_count > 0 then
	// param class
	
	lstr_param.param.param_class = ls_left
	if len(ls_right) > 0 then
		lstr_param.param.param_title = ls_right
	else
		lstr_param.param.param_title = wordcap(f_string_substitute(property_specification.property.property_value_object_cat_fld, "_", " "))
	end if
	lstr_param.param.helptext = lstr_param.param.param_title
	lstr_param.param.token1 = property_specification.property.property_value_object_cat_fld
	setnull(lstr_param.param.query)
	lstr_param.param.required_flag = "N"
	lstr_param.invisible_wizard = true
	
	openwithparm(lw_param_window, lstr_param, "w_param_setting")
	lstr_return = message.powerobjectparm
	if lstr_return.return_status <= 0 then return
	
	text = f_attribute_find_attribute(lstr_return.attributes, lstr_param.param.token1)
	cb_clear_class.visible = true
else
	// Not a param class so treat it as a SQL script that returns a result set
	popup.data_row_count = luo_data.load_query(property_specification.property.property_value_object_cat_qury)
	
	for i = 1 to popup.data_row_count
		popup.items[i] = luo_data.object.data[i, 1]
	next
	
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return
	
	text = luo_data.object.data[popup_return.item_indexes[1], 2]
	cb_clear_class.visible = true
end if




end event

type st_2 from statictext within w_data_address_which_object
integer width = 1495
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
string text = "Which Object"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_which_object_class_title from statictext within w_data_address_which_object
integer y = 120
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Object Class:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_filter_title from statictext within w_data_address_which_object
integer y = 280
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
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

type st_ordinal_title from statictext within w_data_address_which_object
integer x = 123
integer y = 484
integer width = 233
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Ordinal:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_epro_object from statictext within w_data_address_which_object
integer x = 5
integer y = 844
integer width = 878
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
boolean focusrectangle = false
end type

type cb_clear_class from commandbutton within w_data_address_which_object
integer x = 1115
integer y = 140
integer width = 187
integer height = 64
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;st_which_object_class.text = ""
cb_clear_class.visible = false

end event

type rb_from_first from radiobutton within w_data_address_which_object
integer x = 645
integer y = 400
integer width = 434
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "From the first"
boolean checked = true
end type

event clicked;if checked then
	em_of_last.visible = false
end if

end event

type rb_from_last from radiobutton within w_data_address_which_object
integer x = 645
integer y = 476
integer width = 434
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "From the last"
end type

event clicked;if checked then
	em_of_last.visible = false
end if

end event

type rb_of_last from radiobutton within w_data_address_which_object
integer x = 645
integer y = 552
integer width = 389
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Of the last"
end type

event clicked;if checked then
	em_of_last.visible = true
	em_of_last.setfocus()
else
	em_of_last.visible = false
end if

end event

type em_of_last from editmask within w_data_address_which_object
boolean visible = false
integer x = 1038
integer y = 548
integer width = 142
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#"
end type

