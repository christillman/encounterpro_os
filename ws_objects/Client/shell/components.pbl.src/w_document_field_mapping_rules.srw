$PBExportHeader$w_document_field_mapping_rules.srw
forward
global type w_document_field_mapping_rules from w_window_base
end type
type cb_finished from commandbutton within w_document_field_mapping_rules
end type
type dw_rules from u_dw_pick_list within w_document_field_mapping_rules
end type
type st_title from statictext within w_document_field_mapping_rules
end type
type cb_cancel from commandbutton within w_document_field_mapping_rules
end type
type cb_1 from commandbutton within w_document_field_mapping_rules
end type
type st_property_path from statictext within w_document_field_mapping_rules
end type
type st_property_path_title from statictext within w_document_field_mapping_rules
end type
type st_property_value_title from statictext within w_document_field_mapping_rules
end type
type st_property_value from statictext within w_document_field_mapping_rules
end type
type st_resolution_title from statictext within w_document_field_mapping_rules
end type
type st_resolution from statictext within w_document_field_mapping_rules
end type
type st_rules_title from statictext within w_document_field_mapping_rules
end type
type st_element from statictext within w_document_field_mapping_rules
end type
type st_element_title from statictext within w_document_field_mapping_rules
end type
type st_datatype from statictext within w_document_field_mapping_rules
end type
end forward

global type w_document_field_mapping_rules from w_window_base
integer width = 2898
integer height = 1808
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_finished cb_finished
dw_rules dw_rules
st_title st_title
cb_cancel cb_cancel
cb_1 cb_1
st_property_path st_property_path
st_property_path_title st_property_path_title
st_property_value_title st_property_value_title
st_property_value st_property_value
st_resolution_title st_resolution_title
st_resolution st_resolution
st_rules_title st_rules_title
st_element st_element
st_element_title st_element_title
st_datatype st_datatype
end type
global w_document_field_mapping_rules w_document_field_mapping_rules

type variables
str_document_element_context document_element_context
str_document_element document_element
str_document_element_mapping document_element_mapping

str_complete_context context

str_attributes attributes

boolean maptocollection
string collectiondefinition

str_document_element_set_collection collection


end variables

forward prototypes
public subroutine move_rule ()
public function integer refresh ()
public function str_document_element_mapping get_document_element_mapping ()
end prototypes

public subroutine move_rule ();str_popup popup
long ll_row
integer li_sts
long ll_rowcount
long i

ll_row = dw_rules.get_selected_row()
if ll_row <= 0 then return

ll_rowcount = dw_rules.rowcount()
for i = 1 to ll_rowcount
	dw_rules.object.sort_sequence[ll_row] = i
next

popup.objectparm = dw_rules

openwithparm(w_pick_list_sort, popup)

li_sts = dw_rules.sort()

return


end subroutine

public function integer refresh ();str_property_value lstr_property_value
str_document_element_mapping lstr_document_element_mapping
long i
string ls_from_object
string ls_object_key
integer li_sts

//if maptocollection and len(collectiondefinition) > 0 then
//	li_sts = f_edas_example_object(collectiondefinition, context, attributes, ls_from_object, ls_object_key)
//	if li_sts <= 0 then
//		ls_from_object = "Root"
//		ls_object_key = ""
//	end if
//else
//	ls_from_object = "Root"
//	ls_object_key = ""
//end if

// Get the document element as defined by the current screen
lstr_document_element_mapping = get_document_element_mapping()

if left(lstr_document_element_mapping.mapped_property, 1) = "." and maptocollection and len(collectiondefinition) > 0 then
	st_property_path.text = collectiondefinition + " : " + lstr_document_element_mapping.mapped_property
else
	st_property_path.text = lstr_document_element_mapping.mapped_property
end if


// Set the fields so the user can see how the properties resolve in the current context

// Left Side Resolution
st_property_value.text = ""
lstr_property_value = f_resolve_field_mapped_property_from_object(collection, &
																						1, &
																						lstr_document_element_mapping, &
																						context, &
																						attributes)

if len(lstr_property_value.value) > 0 then
	st_property_value.text = lstr_property_value.value
	// Get the actual datatype from the current value
	st_datatype.text = lstr_property_value.datatype
else
	st_datatype.text = ""
end if

// Overall Resolution
lstr_property_value = f_resolve_field_mapped_property_from_object(collection, &
																						1, &
																						lstr_document_element_mapping, &
																						context, &
																						attributes)
st_resolution.text = lstr_property_value.value

return 1

end function

public function str_document_element_mapping get_document_element_mapping ();str_document_element_mapping lstr_document_element_mapping
long i

lstr_document_element_mapping = document_element_mapping
lstr_document_element_mapping.mapping_rule_count = dw_rules.rowcount()

for i = 1 to lstr_document_element_mapping.mapping_rule_count
	lstr_document_element_mapping.mapping_rule[i].right_side = dw_rules.object.right_side[i]
	lstr_document_element_mapping.mapping_rule[i].operator = dw_rules.object.operator[i]
	lstr_document_element_mapping.mapping_rule[i].true_value = dw_rules.object.true_value[i]
	lstr_document_element_mapping.mapping_rule[i].false_value = dw_rules.object.false_value[i]
next

return lstr_document_element_mapping


end function

on w_document_field_mapping_rules.create
int iCurrent
call super::create
this.cb_finished=create cb_finished
this.dw_rules=create dw_rules
this.st_title=create st_title
this.cb_cancel=create cb_cancel
this.cb_1=create cb_1
this.st_property_path=create st_property_path
this.st_property_path_title=create st_property_path_title
this.st_property_value_title=create st_property_value_title
this.st_property_value=create st_property_value
this.st_resolution_title=create st_resolution_title
this.st_resolution=create st_resolution
this.st_rules_title=create st_rules_title
this.st_element=create st_element
this.st_element_title=create st_element_title
this.st_datatype=create st_datatype
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_finished
this.Control[iCurrent+2]=this.dw_rules
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.cb_cancel
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.st_property_path
this.Control[iCurrent+7]=this.st_property_path_title
this.Control[iCurrent+8]=this.st_property_value_title
this.Control[iCurrent+9]=this.st_property_value
this.Control[iCurrent+10]=this.st_resolution_title
this.Control[iCurrent+11]=this.st_resolution
this.Control[iCurrent+12]=this.st_rules_title
this.Control[iCurrent+13]=this.st_element
this.Control[iCurrent+14]=this.st_element_title
this.Control[iCurrent+15]=this.st_datatype
end on

on w_document_field_mapping_rules.destroy
call super::destroy
destroy(this.cb_finished)
destroy(this.dw_rules)
destroy(this.st_title)
destroy(this.cb_cancel)
destroy(this.cb_1)
destroy(this.st_property_path)
destroy(this.st_property_path_title)
destroy(this.st_property_value_title)
destroy(this.st_property_value)
destroy(this.st_resolution_title)
destroy(this.st_resolution)
destroy(this.st_rules_title)
destroy(this.st_element)
destroy(this.st_element_title)
destroy(this.st_datatype)
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

if document_element_context.mapped_property_index > 0 and  document_element_context.mapped_property_index <= document_element.mapped_property_count then
	document_element_mapping = document_element.mapped_property[document_element_context.mapped_property_index]
else
	log.log(this, "open", "invalid document mapped property index", 4)
	closewithreturn(this, popup_return)
	return
end if

st_element.text = document_element.element


for i = 1 to document_element_mapping.mapping_rule_count
	ll_row = dw_rules.insertrow(0)
	dw_rules.object.right_side[ll_row] = document_element_mapping.mapping_rule[i].right_side
	dw_rules.object.operator[ll_row] = document_element_mapping.mapping_rule[i].operator
	dw_rules.object.true_value[ll_row] = document_element_mapping.mapping_rule[i].true_value
	dw_rules.object.false_value[ll_row] = document_element_mapping.mapping_rule[i].false_value
	if f_string_compare_is_unary(document_element_mapping.mapping_rule[i].operator) then
		dw_rules.object.unary[ll_row] = 1
	end if
next

ll_width = (dw_rules.width - 520) / 3

dw_rules.object.right_side.width = ll_width

refresh()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_document_field_mapping_rules
integer x = 2830
integer y = 12
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_document_field_mapping_rules
integer x = 50
integer y = 1544
end type

type cb_finished from commandbutton within w_document_field_mapping_rules
integer x = 2405
integer y = 1568
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

event clicked;str_document_element_mapping lstr_document_element_mapping

lstr_document_element_mapping = get_document_element_mapping()

closewithreturn(parent, lstr_document_element_mapping)


end event

type dw_rules from u_dw_pick_list within w_document_field_mapping_rules
integer x = 69
integer y = 500
integer width = 2770
integer height = 880
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_document_field_mapping_rules"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;String		lsa_buttons[]
String 		ls_drug_id,ls_temp
String 		ls_description,ls_null
String		ls_top_20_code
Integer		li_sts, li_service_count
Long			ll_null
string ls_property
long ll_unary
string ls_literal
w_data_address_builder_tree lw_edas
str_edas_context lstr_edas_context

window 				lw_pop_buttons
str_popup 			popup
str_popup 			popup2
str_popup_return 	popup_return

Setnull(ls_null)
Setnull(ll_null)



ll_unary = dw_rules.object.unary[selected_row]

if lower(lastcolumnname) = "right_side" and ll_unary = 0 then
	ls_temp = dw_rules.object.right_side[selected_row]
	
	if maptocollection and len(collectiondefinition) > 0 then
		if true then
			popup.button_count = popup.button_count + 1
			popup.button_icons[popup.button_count] = "button_tree.bmp"
			popup.button_helps[popup.button_count] = "Pick Nested Property"
			popup.button_titles[popup.button_count] = "Pick Nested Property"
			lsa_buttons[popup.button_count] = "SETRIGHTSIDENESTEDPROPERTY"
		end if
		
		if true then
			popup.button_count = popup.button_count + 1
			popup.button_icons[popup.button_count] = "button_tree.bmp"
			popup.button_helps[popup.button_count] = "Pick Root Property"
			popup.button_titles[popup.button_count] = "Pick Root Property"
			lsa_buttons[popup.button_count] = "SETRIGHTSIDEPROPERTY"
		end if
	else
		if true then
			popup.button_count = popup.button_count + 1
			popup.button_icons[popup.button_count] = "button_tree.bmp"
			popup.button_helps[popup.button_count] = "Pick Property"
			popup.button_titles[popup.button_count] = "Pick Property"
			lsa_buttons[popup.button_count] = "SETRIGHTSIDEPROPERTY"
		end if
	end if

	if true then
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "buttonx3.bmp"
		popup.button_helps[popup.button_count] = "Set Literal"
		popup.button_titles[popup.button_count] = "Set Literal"
		lsa_buttons[popup.button_count] = "SETRIGHTSIDELITERAL"
	end if

	if len(ls_temp) > 0 then
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "button13.bmp"
		popup.button_helps[popup.button_count] = "Clear Right Side"
		popup.button_titles[popup.button_count] = "Clear Right Side"
		lsa_buttons[popup.button_count] = "CLEARRIGHTSIDE"
	end if
end if

if lower(lastcolumnname) = "true_value" then
	ls_temp = dw_rules.object.true_value[selected_row]
	
	if maptocollection and len(collectiondefinition) > 0 then
		if true then
			popup.button_count = popup.button_count + 1
			popup.button_icons[popup.button_count] = "button_tree.bmp"
			popup.button_helps[popup.button_count] = "Pick Nested Property"
			popup.button_titles[popup.button_count] = "Pick Nested Property"
			lsa_buttons[popup.button_count] = "SETTRUENESTEDPROPERTY"
		end if
		
		if true then
			popup.button_count = popup.button_count + 1
			popup.button_icons[popup.button_count] = "button_tree.bmp"
			popup.button_helps[popup.button_count] = "Pick Root Property"
			popup.button_titles[popup.button_count] = "Pick Root Property"
			lsa_buttons[popup.button_count] = "SETTRUEPROPERTY"
		end if
	else
		if true then
			popup.button_count = popup.button_count + 1
			popup.button_icons[popup.button_count] = "button_tree.bmp"
			popup.button_helps[popup.button_count] = "Pick Property"
			popup.button_titles[popup.button_count] = "Pick Property"
			lsa_buttons[popup.button_count] = "SETTRUEPROPERTY"
		end if
	end if

	if true then
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "buttonx3.bmp"
		popup.button_helps[popup.button_count] = "Set Literal"
		popup.button_titles[popup.button_count] = "Set Literal"
		lsa_buttons[popup.button_count] = "SETTRUELITERAL"
	end if

	if true then
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "buttonxc.bmp"
		popup.button_helps[popup.button_count] = "Set Null so True Value returns nothing"
		popup.button_titles[popup.button_count] = "Set Null"
		lsa_buttons[popup.button_count] = "SETTRUENULL"
	end if

	if len(ls_temp) > 0 then
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "button13.bmp"
		popup.button_helps[popup.button_count] = "Clear True Value"
		popup.button_titles[popup.button_count] = "Clear True Value"
		lsa_buttons[popup.button_count] = "CLEARTRUESIDE"
	end if
end if

if lower(lastcolumnname) = "false_value" then
	ls_temp = dw_rules.object.false_value[selected_row]
	
	if maptocollection and len(collectiondefinition) > 0 then
		if true then
			popup.button_count = popup.button_count + 1
			popup.button_icons[popup.button_count] = "button_tree.bmp"
			popup.button_helps[popup.button_count] = "Pick Nested Property"
			popup.button_titles[popup.button_count] = "Pick Nested Property"
			lsa_buttons[popup.button_count] = "SETFALSENESTEDPROPERTY"
		end if
		
		if true then
			popup.button_count = popup.button_count + 1
			popup.button_icons[popup.button_count] = "button_tree.bmp"
			popup.button_helps[popup.button_count] = "Pick Root Property"
			popup.button_titles[popup.button_count] = "Pick Root Property"
			lsa_buttons[popup.button_count] = "SETFALSEPROPERTY"
		end if
	else
		if true then
			popup.button_count = popup.button_count + 1
			popup.button_icons[popup.button_count] = "button_tree.bmp"
			popup.button_helps[popup.button_count] = "Pick Property"
			popup.button_titles[popup.button_count] = "Pick Property"
			lsa_buttons[popup.button_count] = "SETFALSEPROPERTY"
		end if
	end if

	if true then
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "buttonx3.bmp"
		popup.button_helps[popup.button_count] = "Set Literal"
		popup.button_titles[popup.button_count] = "Set Literal"
		lsa_buttons[popup.button_count] = "SETFALSELITERAL"
	end if

	if true then
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "buttonxc.bmp"
		popup.button_helps[popup.button_count] = "Set Null so False Value returns nothing"
		popup.button_titles[popup.button_count] = "Set Null"
		lsa_buttons[popup.button_count] = "SETFALSENULL"
	end if

	if len(ls_temp) > 0 then
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "button13.bmp"
		popup.button_helps[popup.button_count] = "Clear False Value"
		popup.button_titles[popup.button_count] = "Clear False Value"
		lsa_buttons[popup.button_count] = "CLEARFALSESIDE"
	end if
end if

if lower(lastcolumnname) = "operator" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_question.bmp"
	popup.button_helps[popup.button_count] = "Change Operator"
	popup.button_titles[popup.button_count] = "Change Operator"
	lsa_buttons[popup.button_count] = "OPERATOR"
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
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Delete Rule"
	popup.button_titles[popup.button_count] = "Delete Rule"
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
	if button_pressed < 1 or button_pressed > popup.button_count then
		clear_selected()
		return
	end if
elseif popup.button_count = 1 then
	button_pressed = 1
else
	clear_selected()
	return
end if

CHOOSE CASE lsa_buttons[button_pressed]
	CASE "SETRIGHTSIDEPROPERTY"
		lstr_edas_context.root_object = "Root"
		lstr_edas_context.objects_only = false
		lstr_edas_context.context = context
		
		openwithparm(lw_edas,  lstr_edas_context, "w_data_address_builder_tree")
		ls_property = message.stringparm
		if len(ls_property) > 0 then
			dw_rules.object.right_side[selected_row] = ls_property
		end if
	CASE "SETRIGHTSIDENESTEDPROPERTY"
		lstr_edas_context.root_object = collectiondefinition
		lstr_edas_context.objects_only = false
		lstr_edas_context.context = context
		
		openwithparm(lw_edas,  lstr_edas_context, "w_data_address_builder_tree")
		ls_property = message.stringparm
		if len(ls_property) > 0 then
			dw_rules.object.right_side[selected_row] = ls_property
		end if
	CASE "SETRIGHTSIDELITERAL"
		ls_literal = dw_rules.object.right_side[selected_row]
		if left(ls_literal, 1) = "~"" then
			ls_literal = mid(ls_literal, 2, len(ls_literal) - 2)
		else
			ls_literal = ""
		end if
		
		popup2.title = "Enter Literal for Property Rule"
		popup2.item = ls_literal
		openwithparm(w_pop_prompt_string, popup2)
		popup_return = message.powerobjectparm
		if popup_return.item_count = 1 then
			if len(popup_return.items[1] ) > 0 then
				dw_rules.object.right_side[selected_row] = "~"" + popup_return.items[1] + "~""
			end if
		end if
	CASE "CLEARRIGHTSIDE"
		dw_rules.object.right_side[selected_row] = ls_null
	CASE "SETTRUEPROPERTY"
		lstr_edas_context.root_object = "Root"
		lstr_edas_context.objects_only = false
		lstr_edas_context.context = context
		
		openwithparm(lw_edas,  lstr_edas_context, "w_data_address_builder_tree")
		ls_property = message.stringparm
		if len(ls_property) > 0 then
			dw_rules.object.true_value[selected_row] = ls_property
		end if
	CASE "SETTRUENESTEDPROPERTY"
		lstr_edas_context.root_object = collectiondefinition
		lstr_edas_context.objects_only = false
		lstr_edas_context.context = context
		
		openwithparm(lw_edas,  lstr_edas_context, "w_data_address_builder_tree")
		ls_property = message.stringparm
		if len(ls_property) > 0 then
			dw_rules.object.true_value[selected_row] = ls_property
		end if
	CASE "SETTRUELITERAL"
		ls_literal = dw_rules.object.true_value[selected_row]
		if left(ls_literal, 1) = "~"" then
			ls_literal = mid(ls_literal, 2, len(ls_literal) - 2)
		else
			ls_literal = ""
		end if
		
		popup2.title = "Enter Literal for Property Rule"
		popup2.item = ls_literal
		openwithparm(w_pop_prompt_string, popup2)
		popup_return = message.powerobjectparm
		if popup_return.item_count = 1 then
			if len(popup_return.items[1] ) > 0 then
				dw_rules.object.true_value[selected_row] = "~"" + popup_return.items[1] + "~""
			end if
		end if
	CASE "SETTRUENULL"
		dw_rules.object.true_value[selected_row] = "~"~""
	CASE "CLEARTRUESIDE"
		dw_rules.object.true_value[selected_row] = ls_null
	CASE "SETFALSEPROPERTY"
		lstr_edas_context.root_object = "Root"
		lstr_edas_context.objects_only = false
		lstr_edas_context.context = context
		
		openwithparm(lw_edas,  lstr_edas_context, "w_data_address_builder_tree")
		ls_property = message.stringparm
		if len(ls_property) > 0 then
			dw_rules.object.false_value[selected_row] = ls_property
		end if
	CASE "SETFALSENESTEDPROPERTY"
		lstr_edas_context.root_object = collectiondefinition
		lstr_edas_context.objects_only = false
		lstr_edas_context.context = context
		
		openwithparm(lw_edas,  lstr_edas_context, "w_data_address_builder_tree")
		ls_property = message.stringparm
		if len(ls_property) > 0 then
			dw_rules.object.false_value[selected_row] = ls_property
		end if
	CASE "SETFALSELITERAL"
		ls_literal = dw_rules.object.false_value[selected_row]
		if left(ls_literal, 1) = "~"" then
			ls_literal = mid(ls_literal, 2, len(ls_literal) - 2)
		else
			ls_literal = ""
		end if
		
		popup2.title = "Enter Literal for Property Rule"
		popup2.item = ls_literal
		openwithparm(w_pop_prompt_string, popup2)
		popup_return = message.powerobjectparm
		if popup_return.item_count = 1 then
			if len(popup_return.items[1] ) > 0 then
				dw_rules.object.false_value[selected_row] = "~"" + popup_return.items[1] + "~""
			end if
		end if
	CASE "SETFALSENULL"
		dw_rules.object.false_value[selected_row] = "~"~""
	CASE "CLEARFALSESIDE"
		dw_rules.object.false_value[selected_row] = ls_null
	CASE "OPERATOR"
		popup2.dataobject = "dw_domain_notranslate_list"
		popup2.datacolumn = 2
		popup2.displaycolumn = 2
		popup2.argument_count = 1
		popup2.argument[1] = "Comparison Operator"
		openwithparm(w_pop_pick, popup2)
		popup_return = message.powerobjectparm
		if popup_return.item_count = 1 then
			dw_rules.object.operator[selected_row] = popup_return.items[1]
		end if
		if f_string_compare_is_unary(popup_return.items[1]) then
			dw_rules.object.unary[selected_row] = 1
		else
			dw_rules.object.unary[selected_row] = 0
		end if
	CASE "MOVE"
		move_rule()
	CASE "DELETE"
		dw_rules.deleterow(selected_row)
	CASE "CANCEL"
	CASE ELSE
END CHOOSE

clear_selected()

refresh()

Return

end event

type st_title from statictext within w_document_field_mapping_rules
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
string text = "Document Field Mapping Rules"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_document_field_mapping_rules
integer x = 59
integer y = 1568
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

event clicked;

closewithreturn(parent, document_element_mapping)

end event

type cb_1 from commandbutton within w_document_field_mapping_rules
integer x = 1243
integer y = 1568
integer width = 402
integer height = 112
integer taborder = 21
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Insert Rule"
end type

event clicked;long ll_row

ll_row = dw_rules.insertrow(0)
dw_rules.object.operator[ll_row] = "="


end event

type st_property_path from statictext within w_document_field_mapping_rules
integer x = 942
integer y = 188
integer width = 1879
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

type st_property_path_title from statictext within w_document_field_mapping_rules
integer x = 942
integer y = 108
integer width = 1262
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
string text = "Corresponding Epro Property"
boolean focusrectangle = false
end type

type st_property_value_title from statictext within w_document_field_mapping_rules
integer y = 312
integer width = 937
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Value in Current Context (Left Side):"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_property_value from statictext within w_document_field_mapping_rules
integer x = 942
integer y = 296
integer width = 1879
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

type st_resolution_title from statictext within w_document_field_mapping_rules
integer x = 46
integer y = 1436
integer width = 887
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
string text = "Resolution in Current Context:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_resolution from statictext within w_document_field_mapping_rules
integer x = 946
integer y = 1424
integer width = 1819
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

type st_rules_title from statictext within w_document_field_mapping_rules
integer y = 408
integer width = 2894
integer height = 72
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 33538240
string text = "Mapping Rules"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_element from statictext within w_document_field_mapping_rules
integer x = 41
integer y = 188
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

type st_element_title from statictext within w_document_field_mapping_rules
integer x = 41
integer y = 108
integer width = 471
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
string text = "Document Field"
boolean focusrectangle = false
end type

type st_datatype from statictext within w_document_field_mapping_rules
integer x = 2432
integer y = 200
integer width = 379
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = right!
boolean focusrectangle = false
end type

