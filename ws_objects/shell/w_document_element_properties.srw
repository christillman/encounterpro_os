HA$PBExportHeader$w_document_element_properties.srw
forward
global type w_document_element_properties from w_window_base
end type
type cb_finished from commandbutton within w_document_element_properties
end type
type dw_properties from u_dw_pick_list within w_document_element_properties
end type
type st_title from statictext within w_document_element_properties
end type
type cb_cancel from commandbutton within w_document_element_properties
end type
type cb_add_property from commandbutton within w_document_element_properties
end type
type st_element from statictext within w_document_element_properties
end type
type st_element_title from statictext within w_document_element_properties
end type
type cb_add_literal from commandbutton within w_document_element_properties
end type
type cb_add_nested_property from commandbutton within w_document_element_properties
end type
type st_collectionobject from statictext within w_document_element_properties
end type
type st_collectionobject_title from statictext within w_document_element_properties
end type
end forward

global type w_document_element_properties from w_window_base
integer width = 2898
integer height = 1808
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_finished cb_finished
dw_properties dw_properties
st_title st_title
cb_cancel cb_cancel
cb_add_property cb_add_property
st_element st_element
st_element_title st_element_title
cb_add_literal cb_add_literal
cb_add_nested_property cb_add_nested_property
st_collectionobject st_collectionobject
st_collectionobject_title st_collectionobject_title
end type
global w_document_element_properties w_document_element_properties

type variables
str_document_element_context document_element_context 

str_document_element document_element

str_complete_context context

str_attributes attributes

boolean maptocollection
string collectiondefinition

str_document_element_set_collection collection


end variables

forward prototypes
public function integer refresh ()
public subroutine refresh_row (long pl_row)
public subroutine move_property ()
public function str_document_element get_document_element ()
public subroutine property_menu (long pl_row)
end prototypes

public function integer refresh ();long i
long ll_row

dw_properties.reset()

for i = 1 to document_element.mapped_property_count
	ll_row = dw_properties.insertrow(0)
	dw_properties.object.sort_sequence[ll_row] = i
	dw_properties.object.property_index[ll_row] = i
	
	refresh_row(i)
next

return 1

end function

public subroutine refresh_row (long pl_row);str_property_value lstr_property_value
string ls_from_object
string ls_object_key
integer li_sts

dw_properties.object.property[pl_row] = document_element.mapped_property[pl_row].mapped_property
dw_properties.object.rule_count[pl_row] = document_element.mapped_property[pl_row].mapping_rule_count

// Resolve the mapping in this context and display the resolution
lstr_property_value = f_resolve_field_mapped_property_from_object(collection, &
																						1, &
																						document_element.mapped_property[pl_row], &
																						context, &
																						attributes)

dw_properties.object.value[pl_row] = f_property_value_display_string(lstr_property_value)


end subroutine

public subroutine move_property ();str_popup popup
long ll_row
integer li_sts
long ll_rowcount
long i
long ll_property_index
str_document_element lstr_document_element

ll_row = dw_properties.get_selected_row()
if ll_row <= 0 then return

ll_rowcount = dw_properties.rowcount()
for i = 1 to ll_rowcount
	dw_properties.object.sort_sequence[i] = i
next

popup.objectparm = dw_properties

openwithparm(w_pick_list_sort, popup)

li_sts = dw_properties.sort()

// resequence the properties to match the new sort order
lstr_document_element = document_element
for i = 1 to ll_rowcount
	ll_property_index = dw_properties.object.property_index[i]
	lstr_document_element.mapped_property[i] = document_element.mapped_property[ll_property_index]
next
document_element = lstr_document_element

return


end subroutine

public function str_document_element get_document_element ();str_document_element lstr_document_element
long i

lstr_document_element = document_element
lstr_document_element.mapped_property_count = dw_properties.rowcount()

for i = 1 to lstr_document_element.mapped_property_count
	lstr_document_element.mapped_property[i] = dw_properties.object.property[i]
next

return lstr_document_element


end function

public subroutine property_menu (long pl_row);long i
String		lsa_buttons[]
String 		ls_drug_id
String 		ls_description,ls_null
String		ls_top_20_code
Integer		li_sts, li_service_count
Long			ll_null
string ls_property
str_property_value lstr_property_value
long ll_set
w_data_address_builder_tree lw_edas

window 				lw_pop_buttons
str_popup 			popup
str_popup 			popup2
str_popup_return 	popup_return

Setnull(ls_null)
Setnull(ll_null)


if maptocollection and len(collectiondefinition) > 0 then
	if true then
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "button_tree.bmp"
		popup.button_helps[popup.button_count] = "Pick Nested Property"
		popup.button_titles[popup.button_count] = "Pick Nested Property"
		lsa_buttons[popup.button_count] = "SETNESTEDPROPERTY"
	end if
	
	if true then
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "button_tree.bmp"
		popup.button_helps[popup.button_count] = "Pick Root Property"
		popup.button_titles[popup.button_count] = "Pick Root Property"
		lsa_buttons[popup.button_count] = "SETPROPERTY"
	end if
else
	if true then
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "button_tree.bmp"
		popup.button_helps[popup.button_count] = "Pick Property"
		popup.button_titles[popup.button_count] = "Pick Property"
		lsa_buttons[popup.button_count] = "SETPROPERTY"
	end if
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonx3.bmp"
	popup.button_helps[popup.button_count] = "Set Literal"
	popup.button_titles[popup.button_count] = "Set Literal"
	lsa_buttons[popup.button_count] = "SETLITERAL"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonmove.bmp"
	popup.button_helps[popup.button_count] = "Move Rule"
	popup.button_titles[popup.button_count] = "Move Rule"
	lsa_buttons[popup.button_count] = "MOVE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_workflow.bmp"
	popup.button_helps[popup.button_count] = "Set Rules"
	popup.button_titles[popup.button_count] = "Set Rules"
	lsa_buttons[popup.button_count] = "SETRULES"
end if

if document_element.mapped_property[pl_row].mapping_rule_count > 0 then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_workflow.bmp"
	popup.button_helps[popup.button_count] = "Clear Rules"
	popup.button_titles[popup.button_count] = "Clear Rules"
	lsa_buttons[popup.button_count] = "CLEARRULES"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Delete Property"
	popup.button_titles[popup.button_count] = "Delete Property"
	lsa_buttons[popup.button_count] = "DELETE"
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
	if button_pressed < 1 or button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if

CHOOSE CASE lsa_buttons[button_pressed]
	CASE "SETPROPERTY"
		open(w_data_address_builder_tree)
		ls_property = message.stringparm
		if len(ls_property) > 0 then
			document_element.mapped_property[pl_row].mapped_property = ls_property
			refresh_row(pl_row)
		end if
	CASE "SETNESTEDPROPERTY"
		openwithparm(lw_edas, collectiondefinition + "|False", "w_data_address_builder_tree")
		ls_property = message.stringparm
		if len(ls_property) > 0 then
			document_element.mapped_property[pl_row].mapped_property = ls_property
			refresh_row(pl_row)
		end if
	CASE "SETLITERAL"
		popup2.title = "Enter Literal for Property Rule"
		openwithparm(w_pop_prompt_string, popup2)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		if len(popup_return.items[1] ) > 0 then
			ls_property = "~"" + popup_return.items[1] + "~""
			document_element.mapped_property[pl_row].mapped_property = ls_property
			refresh_row(pl_row)
		end if
	CASE "MOVE"
		move_property()
	CASE "SETRULES"
		ll_set = document_element_context.element_set_index
		document_element_context.document_elements.element_set[ll_set].element[document_element_context.element_index] = document_element
		document_element_context.mapped_property_index = pl_row
		openwithparm(w_document_field_mapping_rules, document_element_context)
		document_element.mapped_property[pl_row] = message.powerobjectparm
		refresh_row(pl_row)
	CASE "CLEARRULES"
		openwithparm(w_pop_yes_no, "Are you sure you want to clear all the mapping rules for this property?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		
		document_element.mapped_property[pl_row].mapping_rule_count = 0
		refresh_row(pl_row)
	CASE "DELETE"
		openwithparm(w_pop_yes_no, "Are you sure you want to clear this property and all it's mapping rules?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return

		for i = pl_row to document_element.mapped_property_count - 1
			document_element.mapped_property[i] = document_element.mapped_property[i + 1]
		next
		document_element.mapped_property_count -= 1
		
		refresh()
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

Return

end subroutine

on w_document_element_properties.create
int iCurrent
call super::create
this.cb_finished=create cb_finished
this.dw_properties=create dw_properties
this.st_title=create st_title
this.cb_cancel=create cb_cancel
this.cb_add_property=create cb_add_property
this.st_element=create st_element
this.st_element_title=create st_element_title
this.cb_add_literal=create cb_add_literal
this.cb_add_nested_property=create cb_add_nested_property
this.st_collectionobject=create st_collectionobject
this.st_collectionobject_title=create st_collectionobject_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_finished
this.Control[iCurrent+2]=this.dw_properties
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.cb_cancel
this.Control[iCurrent+5]=this.cb_add_property
this.Control[iCurrent+6]=this.st_element
this.Control[iCurrent+7]=this.st_element_title
this.Control[iCurrent+8]=this.cb_add_literal
this.Control[iCurrent+9]=this.cb_add_nested_property
this.Control[iCurrent+10]=this.st_collectionobject
this.Control[iCurrent+11]=this.st_collectionobject_title
end on

on w_document_element_properties.destroy
call super::destroy
destroy(this.cb_finished)
destroy(this.dw_properties)
destroy(this.st_title)
destroy(this.cb_cancel)
destroy(this.cb_add_property)
destroy(this.st_element)
destroy(this.st_element_title)
destroy(this.cb_add_literal)
destroy(this.cb_add_nested_property)
destroy(this.st_collectionobject)
destroy(this.st_collectionobject_title)
end on

event open;call super::open;long ll_width
long ll_row
long i
str_property_value lstr_property_value
str_popup_return popup_return
long ll_set

document_element_context = message.powerobjectparm

popup_return.item = "ERROR"

ll_set = document_element_context.element_set_index
context = document_element_context.context
attributes = document_element_context.attributes

if ll_set > 0 and  ll_set <= document_element_context.document_elements.element_set_count then
	maptocollection = document_element_context.document_elements.element_set[ll_set].maptocollection
	collectiondefinition = document_element_context.document_elements.element_set[ll_set].collectiondefinition
	
	if document_element_context.element_index > 0 and  document_element_context.element_index <= document_element_context.document_elements.element_set[ll_set].element_count then
		document_element = document_element_context.document_elements.element_set[ll_set].element[document_element_context.element_index]
	else
		log.log(this, "open", "invalid document element index", 4)
		closewithreturn(this, popup_return)
		return
	end if
	
	//  Get an example collection for resolving the "Value in this context" display
	collection = f_get_collection_example(document_element_context.document_elements.element_set[ll_set], context, attributes)
else
	log.log(this, "open", "invalid document element_set index", 4)
	closewithreturn(this, popup_return)
	return
end if


st_element.text = document_element.element

ll_width = (dw_properties.width - 140) / 2
dw_properties.object.property.width = ll_width

if maptocollection and len(collectiondefinition) > 0 then
	cb_add_property.text = "Add Root Property"
	cb_add_nested_property.visible = true
	st_collectionobject.text = collectiondefinition
	st_collectionobject.visible = true
	st_collectionobject_title.visible = true
else
	cb_add_property.text = "Add Property"
	cb_add_nested_property.visible = false
	cb_add_property.x = cb_add_property.x - (cb_add_property.width / 2) - 20
	cb_add_literal.x = cb_add_property.x + cb_add_property.width + 40
	st_collectionobject.visible = false
	st_collectionobject_title.visible = false
end if

refresh()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_document_element_properties
integer x = 2830
integer y = 12
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_document_element_properties
integer x = 50
integer y = 1544
end type

type cb_finished from commandbutton within w_document_element_properties
integer x = 2423
integer y = 1580
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
string text = "Finished"
boolean default = true
end type

event clicked;str_popup_return popup_return

popup_return.item = "OK"
popup_return.objectparm2 = document_element

closewithreturn(parent, popup_return)


end event

type dw_properties from u_dw_pick_list within w_document_element_properties
integer x = 59
integer y = 344
integer width = 2770
integer height = 1204
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_document_element_properties"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;property_menu(selected_row)

clear_selected()

end event

type st_title from statictext within w_document_element_properties
integer width = 2894
integer height = 124
boolean bringtotop = true
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Document Properties"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_document_element_properties
integer x = 50
integer y = 1580
integer width = 402
integer height = 112
integer taborder = 30
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

event clicked;str_popup_return popup_return

popup_return.item = "CANCEL"

closewithreturn(parent, popup_return)

end event

type cb_add_property from commandbutton within w_document_element_properties
integer x = 1134
integer y = 1580
integer width = 608
integer height = 112
integer taborder = 21
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Property"
end type

event clicked;long ll_row
string ls_property


open(w_data_address_builder_tree)
ls_property = message.stringparm
if len(ls_property) > 0 then
	document_element.mapped_property_count += 1
	document_element.mapped_property[document_element.mapped_property_count].mapped_property = ls_property
	refresh()
end if



end event

type st_element from statictext within w_document_element_properties
integer x = 1207
integer y = 136
integer width = 827
integer height = 88
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
boolean focusrectangle = false
end type

type st_element_title from statictext within w_document_element_properties
integer x = 709
integer y = 148
integer width = 489
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
string text = "Document Field:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_add_literal from commandbutton within w_document_element_properties
integer x = 1778
integer y = 1580
integer width = 608
integer height = 112
integer taborder = 31
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Literal"
end type

event clicked;long ll_row
str_popup popup
str_popup_return popup_return


popup.title = "Enter Literal for Property Rule"
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 1 then
	if len(popup_return.items[1] ) > 0 then
		document_element.mapped_property_count += 1
		document_element.mapped_property[document_element.mapped_property_count].mapped_property = "~"" + popup_return.items[1] + "~""
		refresh()
	end if
end if

end event

type cb_add_nested_property from commandbutton within w_document_element_properties
integer x = 489
integer y = 1580
integer width = 608
integer height = 112
integer taborder = 31
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Nested Property"
end type

event clicked;long ll_row
string ls_property
w_data_address_builder_tree lw_window

openwithparm(lw_window, collectiondefinition + "|False", "w_data_address_builder_tree")
ls_property = message.stringparm
if len(ls_property) > 0 then
	document_element.mapped_property_count += 1
	document_element.mapped_property[document_element.mapped_property_count].mapped_property = ls_property
	refresh()
end if



end event

type st_collectionobject from statictext within w_document_element_properties
integer x = 1207
integer y = 236
integer width = 1463
integer height = 88
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
boolean focusrectangle = false
end type

type st_collectionobject_title from statictext within w_document_element_properties
integer x = 475
integer y = 248
integer width = 722
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
string text = "Parent Property:"
alignment alignment = right!
boolean focusrectangle = false
end type

