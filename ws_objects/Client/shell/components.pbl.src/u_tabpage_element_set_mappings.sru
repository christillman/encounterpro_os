$PBExportHeader$u_tabpage_element_set_mappings.sru
forward
global type u_tabpage_element_set_mappings from u_tabpage
end type
type st_collection from statictext within u_tabpage_element_set_mappings
end type
type st_collection_title from statictext within u_tabpage_element_set_mappings
end type
type dw_elements from u_dw_pick_list within u_tabpage_element_set_mappings
end type
end forward

global type u_tabpage_element_set_mappings from u_tabpage
integer width = 3182
integer height = 2084
long tabbackcolor = COLOR_BACKGROUND
st_collection st_collection
st_collection_title st_collection_title
dw_elements dw_elements
end type
global u_tabpage_element_set_mappings u_tabpage_element_set_mappings

type variables
u_tab_element_sets element_set_tab
long element_set_index

str_complete_context context
str_attributes attributes

str_document_element_set_collection collection

end variables

forward prototypes
public function integer initialize ()
public subroutine property_menu (long pl_row)
public subroutine refresh ()
public subroutine refresh_element_mapping (long pl_row)
public subroutine refresh_collection_mapping ()
public subroutine collection_menu ()
public subroutine pick_collection ()
public subroutine change_collection_definition ()
end prototypes

public function integer initialize ();long ll_element_width
long ll_row
long i
str_property_value lstr_property_value
str_attributes lstr_attributes


dw_elements.width = width
st_collection.width = width - st_collection_title.width - 30

ll_element_width = 823 + ((dw_elements.width - 2770 ) / 3)

dw_elements.object.element.width = ll_element_width

if element_set_tab.document_elements.element_set[element_set_index].maptocollection then
	dw_elements.y = 144
	dw_elements.height = height - 144
	st_collection_title.visible = true
	st_collection.visible = true
else
	dw_elements.y = 0
	dw_elements.height = height
	st_collection_title.visible = false
	st_collection.visible = false
end if

refresh()

return 1

end function

public subroutine property_menu (long pl_row);String		lsa_buttons[]
String 		ls_drug_id
String 		ls_description,ls_null
String		ls_top_20_code
Integer		li_sts, li_service_count
Long			ll_null
string ls_property
string ls_literal
str_property_value lstr_property_value
w_document_element_properties lw_document_element_properties
long ll_button_pressed
str_document_element_context lstr_document_element_context
long ll_element_index
w_data_address_builder_tree lw_edas
str_edas_context lstr_edas_context
string ls_current_property
w_window_base lw_window
str_property_suffix lstr_property_suffix

window 				lw_pop_buttons
str_popup 			popup
str_popup 			popup2
str_popup_return 	popup_return

Setnull(ls_null)
Setnull(ll_null)

ll_element_index = dw_elements.object.element_index[pl_row]
if isnull(ll_element_index) or ll_element_index <= 0 then return

if element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property_count <= 1 then
	if element_set_tab.document_elements.element_set[element_set_index].maptocollection and len(element_set_tab.document_elements.element_set[element_set_index].collectiondefinition) > 0 then
		// Collection property
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "button_tree.bmp"
		lsa_buttons[popup.button_count] = "SETCOLLECTIONPROPERTY"
		CHOOSE CASE upper(element_set_tab.document_elements.element_set[element_set_index].maptocollectiontype)
			CASE "EDAS"
				popup.button_helps[popup.button_count] = "Pick Nested Property"
				popup.button_titles[popup.button_count] = "Nested Property"
			CASE "SQL"
				popup.button_helps[popup.button_count] = "Pick SQL Column"
				popup.button_titles[popup.button_count] = "SQL Column"
			CASE "DATAWINDOW"
				popup.button_helps[popup.button_count] = "Pick Datawindow Column"
				popup.button_titles[popup.button_count] = "Datawindow Column"
		END CHOOSE
	
		// Suffix
		if true then
			popup.button_count = popup.button_count + 1
			popup.button_icons[popup.button_count] = "button_format.bmp"
			popup.button_helps[popup.button_count] = "Format Output"
			popup.button_titles[popup.button_count] = "Format"
			lsa_buttons[popup.button_count] = "SUFFIX"
		end if
		
		// Root EDAS property
		if element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property_count <= 1 then
			popup.button_count = popup.button_count + 1
			popup.button_icons[popup.button_count] = "button_tree.bmp"
			popup.button_helps[popup.button_count] = "Pick Root Property"
			popup.button_titles[popup.button_count] = "Root Property"
			lsa_buttons[popup.button_count] = "SETPROPERTY"
		end if
	else
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "button_tree.bmp"
		popup.button_helps[popup.button_count] = "Pick Property"
		popup.button_titles[popup.button_count] = "Pick Property"
		lsa_buttons[popup.button_count] = "SETPROPERTY"
	end if
end if

if element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property_count <= 1 then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonx3.bmp"
	popup.button_helps[popup.button_count] = "Set Literal"
	popup.button_titles[popup.button_count] = "Set Literal"
	lsa_buttons[popup.button_count] = "SETLITERAL"
end if

if element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property_count <= 1 then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonx3.bmp"
	popup.button_helps[popup.button_count] = "Manually Enter Property String"
	popup.button_titles[popup.button_count] = "Manual Property"
	lsa_buttons[popup.button_count] = "SETMANUAL"
end if

if element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property_count = 1 then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Clear Property"
	popup.button_titles[popup.button_count] = "Clear Property"
	lsa_buttons[popup.button_count] = "CLEAR"
end if

if element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property_count >= 1 then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_tree.bmp"
	popup.button_helps[popup.button_count] = "Add/Edit Properties"
	popup.button_titles[popup.button_count] = "Add/Edit Properties"
	lsa_buttons[popup.button_count] = "ADDPROPERTIES"
end if

if element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property_count > 1 then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Clear All Properties"
	popup.button_titles[popup.button_count] = "Clear All Properties"
	lsa_buttons[popup.button_count] = "CLEARALL"
end if

if element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property_count = 1 then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_workflow.bmp"
	popup.button_helps[popup.button_count] = "Set Rules"
	popup.button_titles[popup.button_count] = "Set Rules"
	lsa_buttons[popup.button_count] = "SETRULES"
end if

if element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property_count = 1 then
	if element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property[1].mapping_rule_count > 0 then
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "button_workflow.bmp"
		popup.button_helps[popup.button_count] = "Clear Rules"
		popup.button_titles[popup.button_count] = "Clear Rules"
		lsa_buttons[popup.button_count] = "CLEARRULES"
	end if
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
	ll_button_pressed = message.doubleparm
	if ll_button_pressed < 1 or ll_button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	ll_button_pressed = 1
else
	return
end if

CHOOSE CASE lsa_buttons[ll_button_pressed]
	CASE "SETPROPERTY"
		lstr_edas_context.root_object = "root"
		lstr_edas_context.objects_only = false
		lstr_edas_context.context = context
		if element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property_count >= 1 then
			lstr_edas_context.property = element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property[1].mapped_property
		end if
		
		openwithparm(lw_edas, lstr_edas_context, "w_data_address_builder_tree")
		ls_property = message.stringparm
		if len(ls_property) > 0 then
			element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property_count = 1
			element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property[1].mapped_property = ls_property
		end if
	CASE "SETCOLLECTIONPROPERTY"
		if element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property_count >= 1 then
			ls_current_property = element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property[1].mapped_property
		end if
		ls_property = f_pick_collection_property(collection, ls_current_property, context, attributes)
		if len(ls_property) > 0 then
			element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property_count = 1
			element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property[1].mapped_property = ls_property
		end if
	CASE "SUFFIX"
		lstr_property_suffix = element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property[1].suffix
		lstr_property_suffix.datatype = element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].datatype
		openwithparm(lw_window, lstr_property_suffix, "w_data_address_suffix")
		
		lstr_property_suffix = message.powerobjectparm
		if isnull(lstr_property_suffix.datatype) then return
		
		element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property[1].suffix = lstr_property_suffix
	CASE "SETLITERAL"
		if element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property_count > 0 then
			ls_literal = element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property[1].mapped_property
			if left(ls_literal, 1) = "~"" then
				ls_literal = mid(ls_literal, 2, len(ls_literal) - 2)
			else
				ls_literal = ""
			end if
		end if
		
		popup2.title = "Enter Literal for this Property Rule"
		popup2.item = ls_literal
		openwithparm(w_pop_prompt_string, popup2)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		if len(popup_return.items[1] ) > 0 then
			element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property_count = 1
			element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property[1].mapped_property = "~"" + popup_return.items[1] + "~""
		end if
	CASE "SETMANUAL"
		if element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property_count > 0 then
			ls_literal = element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property[1].mapped_property
		end if
		
		popup2.title = "Enter EDAS Property"
		popup2.item = ls_literal
		openwithparm(w_pop_prompt_string, popup2)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		if len(popup_return.items[1] ) > 0 then
			element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property_count = 1
			element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property[1].mapped_property = popup_return.items[1]
		end if
	CASE "ADDPROPERTIES"
		lstr_document_element_context = element_set_tab.document_element_context
		lstr_document_element_context.document_elements =  element_set_tab.document_elements
		lstr_document_element_context.element_set_index = element_set_index
		lstr_document_element_context.element_index = ll_element_index
		openwithparm(lw_document_element_properties, lstr_document_element_context, "w_document_element_properties")
		popup_return = message.powerobjectparm
		if popup_return.item = "OK" then
			element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index] = popup_return.objectparm2
		end if
	CASE "CLEAR"
		openwithparm(w_pop_yes_no, "Are you sure you want to clear this property?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		
		element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property_count = 0
	CASE "CLEARALL"
		openwithparm(w_pop_yes_no, "Are you sure you want to clear all properties?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		
		element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property_count = 0
	CASE "SETRULES"
		lstr_document_element_context = element_set_tab.document_element_context
		lstr_document_element_context.document_elements =  element_set_tab.document_elements
		lstr_document_element_context.element_set_index = element_set_index
		lstr_document_element_context.element_index = ll_element_index
		lstr_document_element_context.mapped_property_index = 1
		openwithparm(w_document_field_mapping_rules, lstr_document_element_context)
		element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property[1] = message.powerobjectparm
	CASE "CLEARRULES"
		openwithparm(w_pop_yes_no, "Are you sure you want to clear all the mapping rules for this property?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		
		element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property[1].mapping_rule_count = 0
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

Return

end subroutine

public subroutine refresh ();long i
long ll_row
str_property_value lstr_property_value

refresh_collection_mapping()

dw_elements.reset()

for i = 1 to element_set_tab.document_elements.element_set[element_set_index].element_count
	ll_row = dw_elements.insertrow(0)
	dw_elements.object.element[ll_row] = element_set_tab.document_elements.element_set[element_set_index].element[i].element
	dw_elements.object.element_index[ll_row] = i
	refresh_element_mapping(ll_row)
next



end subroutine

public subroutine refresh_element_mapping (long pl_row);long i
string ls_property
boolean lb_found
str_property_value lstr_property_value
long ll_element_index
integer li_sts
string ls_suffix

ll_element_index = dw_elements.object.element_index[pl_row]
if isnull(ll_element_index) or ll_element_index <= 0 then return

//lstr_collection = f_get_collection_example(element_set_tab.document_elements.element_set[element_set_index], context, attributes)

// Figure out which property has a value
if element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property_count > 0 then
	lb_found = false
	for i = 1 to element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property_count
		lstr_property_value = f_resolve_field_mapped_property_from_object(collection, &
																								1, &
																								element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property[i], &
																								context, &
																								attributes)
		
		if len(lstr_property_value.display_value) > 0 then
			lb_found = true
			exit
		end if
	next
	if not lb_found then i = 1
	if element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property_count > 1 then
		ls_property = "[" + string(i) + "] "
	else
		ls_property = ""
	end if
	ls_property += element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property[i].mapped_property
	
	// Add the suffix
	ls_suffix = f_suffix_string(element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property[i].suffix)
	if len(ls_suffix) > 0 then
		ls_property += "." + ls_suffix
	end if

end if


// Refresh the property and rule count
dw_elements.object.property[pl_row] = ls_property

if element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property_count = 1 then
	dw_elements.object.rule_count[pl_row] = element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index].mapped_property[1].mapping_rule_count
else
	dw_elements.object.rule_count[pl_row] = -1
end if

// Resolve the mapping in this context and display the resolution
lstr_property_value = f_resolve_field_mapping_from_object(collection, &
																			1, &
																			element_set_tab.document_elements.element_set[element_set_index].element[ll_element_index], &
																			context, &
																			attributes)
dw_elements.object.value[pl_row] = f_property_value_display_string(lstr_property_value)


end subroutine

public subroutine refresh_collection_mapping ();
if element_set_tab.document_elements.element_set[element_set_index].maptocollection then
	CHOOSE CASE upper( element_set_tab.document_elements.element_set[element_set_index].maptocollectiontype)
		CASE "EDAS"
			st_collection.text = element_set_tab.document_elements.element_set[element_set_index].collectiondefinition
		CASE "SQL"
			st_collection.text = "SQL"
		CASE "DATAWINDOW"
			st_collection.text = "Datawindow"
		CASE ELSE
	END CHOOSE
	
	collection = f_get_collection_example(element_set_tab.document_elements.element_set[element_set_index], context, attributes)
	
	// Resolve the mapping in this context and display the resolution
	//dw_elements.object.value[pl_row] = f_property_value_display_string(f_resolve_field_mapping(element_set_tab.document_elements.element_set[element_set_index].element[pl_row], context, attributes))
	st_collection_title.visible = true
	st_collection.visible = true
else
	st_collection_title.visible = false
	st_collection.visible = false
end if

end subroutine

public subroutine collection_menu ();String		lsa_buttons[]
String 		ls_drug_id
String 		ls_description,ls_null
String		ls_top_20_code
Integer		li_sts, li_service_count
Long			ll_null
string ls_property
string ls_literal
str_property_value lstr_property_value
w_document_element_properties lw_document_element_properties
w_data_address_builder_tree lw_window
long ll_button_pressed
str_document_element_context lstr_document_element_context
long ll_element_index
str_edas_context lstr_edas_context
string ls_type

window 				lw_pop_buttons
str_popup 			popup
str_popup 			popup2
str_popup_return 	popup_return

Setnull(ls_null)
Setnull(ll_null)

ls_type = element_set_tab.document_elements.element_set[element_set_index].maptocollectiontype

if len(ls_type) > 0 and len(element_set_tab.document_elements.element_set[element_set_index].collectiondefinition) > 0 then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_tree.bmp"
	popup.button_helps[popup.button_count] = "Pick New Collection"
	popup.button_titles[popup.button_count] = "Pick Collection"
	lsa_buttons[popup.button_count] = "PICKCOLLECTION"
	
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_tree.bmp"
	popup.button_helps[popup.button_count] = "Change Collection Definition"
	popup.button_titles[popup.button_count] = "Change " + ls_type
	lsa_buttons[popup.button_count] = "CHANGEDEFINITION"
	
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Clear Collection"
	popup.button_titles[popup.button_count] = "Clear Collection"
	lsa_buttons[popup.button_count] = "CLEAR"
else
	// if we don't have a maptocollectiontype then go straight to the pick logic
	pick_collection()
	return
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
	ll_button_pressed = message.doubleparm
	if ll_button_pressed < 1 or ll_button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	ll_button_pressed = 1
else
	return
end if

CHOOSE CASE lsa_buttons[ll_button_pressed]
	CASE "PICKCOLLECTION"
		pick_collection()
	CASE "CHANGEDEFINITION"
		change_collection_definition()
	CASE "CLEAR"
		openwithparm(w_pop_yes_no, "Are you sure you want to clear this property?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		
		setnull(element_set_tab.document_elements.element_set[element_set_index].collectiondefinition)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

Return

end subroutine

public subroutine pick_collection ();str_popup popup
str_popup_return popup_return
string ls_context_object
integer li_sts
string ls_last_type

ls_last_type = upper(element_set_tab.document_elements.element_set[element_set_index].maptocollectiontype)
if isnull(ls_last_type) then ls_last_type = ""

popup.data_row_count = 3
popup.items[1] = "EDAS Collection"
popup.items[2] = "SQL Script"
popup.items[3] = "Infomaker Datawindow"
Openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

CHOOSE CASE popup_return.item_indexes[1]
	CASE 1
		if ls_last_type <> "EDAS" then
			element_set_tab.document_elements.element_set[element_set_index].maptocollectiontype = "EDAS"
			element_set_tab.document_elements.element_set[element_set_index].collectiondefinition = ""
		end if
	CASE 2
		if ls_last_type <> "SQL" then
			element_set_tab.document_elements.element_set[element_set_index].maptocollectiontype = "SQL"
			element_set_tab.document_elements.element_set[element_set_index].collectiondefinition = ""
		end if
	CASE 3
		if ls_last_type <> "DATAWINDOW" then
			element_set_tab.document_elements.element_set[element_set_index].maptocollectiontype = "Datawindow"
			element_set_tab.document_elements.element_set[element_set_index].collectiondefinition = ""
		end if
END CHOOSE

change_collection_definition()

return

end subroutine

public subroutine change_collection_definition ();str_popup popup
str_popup_return popup_return
string ls_context_object
integer li_sts
str_edas_context lstr_edas_context
w_window_base lw_window
string ls_property
string lsa_paths[]
string lsa_files[]
string ls_filter
long ll_count
long i
str_file_attributes lstr_file_attributes
long ll_filebytes
blob lbl_file
str_sql_context lstr_sql_context

CHOOSE CASE upper(element_set_tab.document_elements.element_set[element_set_index].maptocollectiontype)
	CASE "EDAS"
		lstr_edas_context.root_object = "Root"
		lstr_edas_context.objects_only = true
		lstr_edas_context.context = context
		
		openwithparm(lw_window,  lstr_edas_context, "w_data_address_builder_tree")
		ls_property = clipboard()
		if len(ls_property) > 0 then
			element_set_tab.document_elements.element_set[element_set_index].collectiondefinition = ls_property
		end if
	CASE "SQL"
		lstr_sql_context.script_name = element_set_tab.document_elements.element_set[element_set_index].description
		lstr_sql_context.sql = element_set_tab.document_elements.element_set[element_set_index].collectiondefinition
		lstr_sql_context.context = context
		lstr_sql_context.attributes = attributes
		
		openwithparm(w_pop_edit_sql, lstr_sql_context)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		element_set_tab.document_elements.element_set[element_set_index].collectiondefinition = popup_return.items[1]
	CASE "DATAWINDOW"
		ls_filter = "SRD Files (*.*), *.SRD, All Files (*.*), *.*"
		
		li_sts = windows_api.comdlg32.getopenfilename( handle(w_main), &
																	"Select Datawindow Definition File", &
																	lsa_paths, &
																	lsa_files, &
																	ls_filter)
		if li_sts < 0 then return
		
		ll_count = upperbound(lsa_paths)
		
		for i = 1 to ll_count
			// Skip the shorthand directories
			if lsa_files[i] = "." or lsa_files[i] = ".." then continue
			
			// Skip the file if we can't get its properties
			li_sts = log.file_attributes(lsa_paths[i], lstr_file_attributes)
			if li_sts <= 0 then continue
			
			// Skip the directories
			if lstr_file_attributes.subdirectory then continue
			
			ll_filebytes = log.file_read2(lsa_paths[i], lbl_file, false)
			if ll_filebytes > 0 then
				element_set_tab.document_elements.element_set[element_set_index].collectiondefinition = f_blob_to_string(lbl_file)
				exit
			end if
		next
	CASE ELSE
END CHOOSE


return

end subroutine

on u_tabpage_element_set_mappings.create
int iCurrent
call super::create
this.st_collection=create st_collection
this.st_collection_title=create st_collection_title
this.dw_elements=create dw_elements
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_collection
this.Control[iCurrent+2]=this.st_collection_title
this.Control[iCurrent+3]=this.dw_elements
end on

on u_tabpage_element_set_mappings.destroy
call super::destroy
destroy(this.st_collection)
destroy(this.st_collection_title)
destroy(this.dw_elements)
end on

type st_collection from statictext within u_tabpage_element_set_mappings
integer x = 1586
integer y = 12
integer width = 1157
integer height = 112
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;collection_menu()

refresh()

end event

type st_collection_title from statictext within u_tabpage_element_set_mappings
integer y = 28
integer width = 1568
integer height = 80
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Repeat element set for each object/record in:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_elements from u_dw_pick_list within u_tabpage_element_set_mappings
integer y = 144
integer width = 2770
integer height = 1244
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_document_field_mappings"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;
property_menu(selected_row)

clear_selected()

refresh_element_mapping(selected_row)

end event

