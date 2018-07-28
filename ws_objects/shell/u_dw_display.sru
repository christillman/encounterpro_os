HA$PBExportHeader$u_dw_display.sru
forward
global type u_dw_display from u_dw_pick_list
end type
end forward

global type u_dw_display from u_dw_pick_list
integer width = 1463
integer height = 1048
string title = "none"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
event hotspot_hit ( string ps_controller_config_object_id,  str_controller_hotspot pstr_hotspot,  str_attributes pstr_attributes )
end type
global u_dw_display u_dw_display

type variables
str_attributes attributes
str_datawindow_config_object dw_config_object

str_controller controller

long lastnestedrow

end variables

forward prototypes
public function integer refresh (str_attributes pstr_attributes)
public function integer refresh ()
public function integer set_datawindow_config_object (string ps_datawindow_config_object_id)
public function str_datawindow_nested_datawindow find_nested_datawindow (string ps_controlname)
public function str_datawindow_nested_datawindow get_nested_datawindow_info (string ps_controlname)
public subroutine map_datawindow_control (string control_name)
public subroutine unmap_datawindow_control (string control_name)
public function string get_control_value (string ps_control_name, long pl_row)
public function string get_nested_control_value (string ps_nested_control, string ps_control_name, long pl_row)
public function str_attributes process_mapping_attributes (str_attributes pstr_attributes)
end prototypes

event hotspot_hit(string ps_controller_config_object_id, str_controller_hotspot pstr_hotspot, str_attributes pstr_attributes);long ll_menu_id
str_attributes lstr_attributes

lstr_attributes = attributes // attributes set by containing window
f_attribute_add_attributes(lstr_attributes, pstr_attributes) // Attributes from the datawindow/controller mapping

ll_menu_id = f_config_object_local_key(pstr_hotspot.menu_config_object_id)

if ll_menu_id > 0 then
	f_display_menu_with_attributes(ll_menu_id, true, attributes)
end if

end event

public function integer refresh (str_attributes pstr_attributes);
attributes = pstr_attributes

set_datawindow_config_object(f_attribute_find_attribute(attributes, "datawindow_config_object_id"))

return refresh()


end function

public function integer refresh ();any laa_argument[]
string ls_error_create
string ls_new_sql
long i
long ll_temp
decimal ldc_temp
string ls_temp
date ld_temp
time lt_temp
datetime ldt_temp
integer li_sts
string ls_sts
str_complete_context lstr_complete_context
long ll_rowcount
blob lbl_datawindow_script


if len(dw_config_object.dataobject) > 0 then
	this.dataobject = dw_config_object.dataobject
elseif len(dw_config_object.datawindow_syntax) > 0 then
	this.Create(dw_config_object.datawindow_syntax, ls_error_create)
	if Len(ls_error_create) > 0 THEN
		if isnull(ls_error_create) then ls_error_create = "<Null>"
		log.log(this, "refresh()", "Error creating datastore (" + ls_error_create + ")", 4)
		return -1
	end if
else
	log.log(this, "refresh()", "No dataobject and no syntax", 4)
	return -1
end if

lstr_complete_context = f_get_complete_context()

for i = 1 to dw_config_object.arguments.argument_count
	// First look for the context names in the argument names
	CHOOSE CASE lower(dw_config_object.arguments.argument[i].argument_name)
		CASE "cpr_id", "ps_cpr_id"
			laa_argument[i] = lstr_complete_context.cpr_id
		CASE "encounter_id", "pl_encounter_id"
			laa_argument[i] = lstr_complete_context.encounter_id
		CASE "problem_id", "pl_problem_id"
			laa_argument[i] = lstr_complete_context.problem_id
		CASE "treatment_id", "pl_treatment_id"
			laa_argument[i] = lstr_complete_context.treatment_id
		CASE "observation_sequence", "pl_observation_sequence"
			laa_argument[i] = lstr_complete_context.observation_sequence
		CASE "attachment_id", "pl_attachment_id"
			laa_argument[i] = lstr_complete_context.attachment_id
		CASE "patient_workplan_item_id", "service_id", "pl_patient_workplan_item_id"
			laa_argument[i] = lstr_complete_context.service_id
		CASE "customer_id"
			laa_argument[i] = lstr_complete_context.customer_id
		CASE "office_id"
			laa_argument[i] = lstr_complete_context.office_id
		CASE "user_id", "ps_user_id"
			laa_argument[i] = lstr_complete_context.user_id
		CASE "scribe_user_id"
			laa_argument[i] = lstr_complete_context.scribe_user_id
		CASE "context_object"
			laa_argument[i] = lstr_complete_context.context_object
		CASE "document_id"
			laa_argument[i] = lstr_complete_context.document_id
		CASE ELSE
			CHOOSE CASE lower(dw_config_object.arguments.argument[i].argument_type)
				CASE "number"
					ls_temp = f_attribute_find_attribute(attributes, "argument_" + string(i))
					if isnumber(ls_temp) then
						ll_temp = long(ls_temp)
					else
						setnull(ll_temp)
					end if
					laa_argument[i] = ll_temp
				CASE "string"
					ls_temp = f_attribute_find_attribute(attributes, "argument_" + string(i))
					laa_argument[i] = ls_temp
				CASE "date"
					ls_temp = f_attribute_find_attribute(attributes, "argument_" + string(i))
					ld_temp = date(ls_temp)
					laa_argument[i] = ld_temp
				CASE "time"
					ls_temp = f_attribute_find_attribute(attributes, "argument_" + string(i))
					lt_temp = time(ls_temp)
					laa_argument[i] = lt_temp
				CASE "datetime"
					ls_temp = f_attribute_find_attribute(attributes, "argument_" + string(i))
					ldt_temp = f_string_to_datetime(ls_temp)
					laa_argument[i] = ldt_temp
				CASE "decimal"
					ls_temp = f_attribute_find_attribute(attributes, "argument_" + string(i))
					ldc_temp = dec(ls_temp)
					laa_argument[i] = ldc_temp
				CASE ELSE
					ls_temp = f_attribute_find_attribute(attributes, "argument_" + string(i))
					laa_argument[i] = ls_temp
			END CHOOSE
		END CHOOSE
next

// Execute the datawindow
this.settransobject(sqlca)

CHOOSE CASE dw_config_object.arguments.argument_count
	CASE 0
		ll_rowcount = this.retrieve()
	CASE 1
		ll_rowcount = this.retrieve(laa_argument[1])
	CASE 2
		ll_rowcount = this.retrieve(laa_argument[1], laa_argument[2])
	CASE 3
		ll_rowcount = this.retrieve(laa_argument[1], laa_argument[2], laa_argument[3])
	CASE 4
		ll_rowcount = this.retrieve(laa_argument[1], laa_argument[2], laa_argument[3], laa_argument[4])
	CASE 5
		ll_rowcount = this.retrieve(laa_argument[1], laa_argument[2], laa_argument[3], laa_argument[4], laa_argument[5])
	CASE 6
		ll_rowcount = this.retrieve(laa_argument[1], laa_argument[2], laa_argument[3], laa_argument[4], laa_argument[5], laa_argument[6])
	CASE 7
		ll_rowcount = this.retrieve(laa_argument[1], laa_argument[2], laa_argument[3], laa_argument[4], laa_argument[5], laa_argument[6], laa_argument[7])
	CASE 8
		ll_rowcount = this.retrieve(laa_argument[1], laa_argument[2], laa_argument[3], laa_argument[4], laa_argument[5], laa_argument[6], laa_argument[7], laa_argument[8])
END CHOOSE

if ll_rowcount < 0 then return -1

return 1

end function

public function integer set_datawindow_config_object (string ps_datawindow_config_object_id);string ls_script
string ls_left
string ls_right
string ls_dwdata
long i
integer li_sts
datawindowchild ldw_rpt
string ls_type
string ls_coltype
string ls_name
string ls_tag
string ls_control_length
string ls_error_create
string ls_objects
string lsa_control_names[]

li_sts = f_get_datawindow_config_object(ps_datawindow_config_object_id, dw_config_object)
if li_sts <= 0 then return li_sts


if len(dw_config_object.dataobject) > 0 then
	// Run the object through the datawindow control to get the syntax
	this.dataobject = dw_config_object.dataobject
	TRY
		dw_config_object.datawindow_syntax = this.object.datawindow.syntax
	CATCH (throwable lt_error)
		log.log(this, "set_datawindow_config_object()", "Error getting datawindow syntax (" + dw_config_object.dataobject + ")~r~n" + lt_error.text, 3)
		setnull(dw_config_object.datawindow_syntax)
	END TRY
elseif len(dw_config_object.datawindow_syntax) > 0 then
	this.Create(dw_config_object.datawindow_syntax, ls_error_create)
	if Len(ls_error_create) > 0 THEN
		if isnull(ls_error_create) then ls_error_create = "<Null>"
		log.log(this, "set_datawindow_config_object()", "Error creating datastore (" + ls_error_create + ")", 4)
		return -1
	end if
else
	return 0
end if

li_sts = f_get_controller_config_object(dw_config_object.controller_config_object_id, controller)

if len(dw_config_object.datawindow_syntax) > 0 then
	dw_config_object.arguments = f_get_datawindow_arguments(dw_config_object.datawindow_syntax)
	dw_config_object.nested = f_get_datawindow_nested_datawindows(dw_config_object.datawindow_syntax)
end if

for i = 1 to dw_config_object.nested.nested_datawindow_count
	dw_config_object.nested.nested_datawindow[i] = get_nested_datawindow_info(dw_config_object.nested.nested_datawindow[i].controlname)
next

ls_objects = describe("datawindow.objects")
dw_config_object.controls.control_count = f_parse_string(ls_objects, "~t", lsa_control_names)
for i = 1 to dw_config_object.controls.control_count
	ls_type = describe(lsa_control_names[i] + ".type")
	if isnull(ls_type) or trim(ls_type) = "" or ls_type = "!" then exit
	dw_config_object.controls.control[i].control_type = ls_type

	ls_name = describe(lsa_control_names[i] + ".name")
	if isnull(ls_name) or trim(ls_name) = "" or ls_name = "!" then exit
	dw_config_object.controls.control[i].control_name = ls_name

	ls_tag = describe(lsa_control_names[i] + ".tag")
	if ls_tag = "" or ls_tag = "?" then setnull(ls_tag)
	dw_config_object.controls.control[i].control_tag = ls_tag

//	dw_config_object.controls.control_count += 1
	

	ls_coltype = describe(lsa_control_names[i] + ".coltype")
	f_split_string(ls_coltype, "(", ls_left, ls_right)
	dw_config_object.controls.control[i].control_column_datatype = ls_left
	
	if ls_right <> "" then
		ls_control_length = left(ls_right, len(ls_right) - 1)
		if isnumber(ls_control_length) then
			dw_config_object.controls.control[i].control_length = long(ls_control_length)
		end if
	end if
next


//dw_config_object.controls.control_count = 0
//for j = 1 to 100
//	ls_temp = describe("#" + string(j) + ".name")
//	if isnull(ls_temp) or trim(ls_temp) = "" or ls_temp = "!" then exit
//	
//	dw_config_object.controls.control_count += 1
//	
//	dw_config_object.controls.control[dw_config_object.controls.control_count].control_name = ls_temp
//
//	ls_temp = describe("#" + string(j) + ".coltype")
//	f_split_string(ls_temp, "(", ls_left, ls_right)
//	dw_config_object.controls.control[dw_config_object.controls.control_count].control_column_datatype = ls_left
//	
//	if ls_right <> "" then
//		ls_temp = left(ls_right, len(ls_right) - 1)
//		if isnumber(ls_temp) then
//			dw_config_object.controls.control[dw_config_object.controls.control_count].control_length = long(ls_temp)
//		end if
//	end if
//next
//
return 1

end function

public function str_datawindow_nested_datawindow find_nested_datawindow (string ps_controlname);str_datawindow_nested_datawindow lstr_nested
long i
datawindowchild ldw_nested
integer li_sts
long j
string ls_temp
string ls_left
string ls_right

for i = 1 to dw_config_object.nested.nested_datawindow_count
	if lower(dw_config_object.nested.nested_datawindow[i].controlname) = lower(ps_controlname) then
		return dw_config_object.nested.nested_datawindow[i]
	end if
next

// if we didn't find it then just get it from the datawindow
lstr_nested = get_nested_datawindow_info(dw_config_object.nested.nested_datawindow[i].controlname)

return lstr_nested

end function

public function str_datawindow_nested_datawindow get_nested_datawindow_info (string ps_controlname);str_datawindow_nested_datawindow lstr_nested
long i
datawindowchild ldw_nested
integer li_sts
long j
string ls_temp
string ls_left
string ls_right

setnull(lstr_nested.controlname)
setnull(lstr_nested.dataobject)

li_sts = getchild(ps_controlname, ldw_nested)
if li_sts > 0 then
	lstr_nested.controlname = ps_controlname
	lstr_nested.dataobject = this.describe(ps_controlname + ".dataobject")
	lstr_nested.has_selected_flag = false
	
	for j = 1 to 100
		ls_temp = ldw_nested.describe("#" + string(j) + ".name")
		if isnull(ls_temp) or trim(ls_temp) = "" or ls_temp = "!" then exit
		
		lstr_nested.controls.control[j].control_name = ls_temp
		if lower(ls_temp) = "selected_flag" then
			lstr_nested.has_selected_flag = true
		end if

		lstr_nested.controls.control_count = j
		
		ls_temp = ldw_nested.describe("#" + string(j) + ".coltype")
		f_split_string(ls_temp, "(", ls_left, ls_right)
		lstr_nested.controls.control[j].control_column_datatype = ls_left
		
		if ls_right <> "" then
			ls_temp = left(ls_right, len(ls_right) - 1)
			if isnumber(ls_temp) then
				lstr_nested.controls.control[j].control_length = long(ls_temp)
			end if
		end if
	next
	
	ls_temp = this.describe(ps_controlname + ".nest_arguments")
	lstr_nested.nested_argument_count = f_parse_string(ls_temp, ",", lstr_nested.nested_argument)
	for i = 1 to lstr_nested.nested_argument_count
		lstr_nested.nested_argument[i] = f_string_substitute(lstr_nested.nested_argument[i], "(", "")
		lstr_nested.nested_argument[i] = f_string_substitute(lstr_nested.nested_argument[i], ")", "")
		lstr_nested.nested_argument[i] = trim(f_string_substitute(lstr_nested.nested_argument[i], "~"", ""))
	next
else
	log.log(this, "get_nested_datawindow_info()", "Error getting nested datawindow (" + ps_controlname + ")", 3)
end if

return lstr_nested

end function

public subroutine map_datawindow_control (string control_name);str_popup popup
str_popup_return popup_return
integer li_sts
string ls_temp
string ls_hotspot_name
boolean lb_found
long ll_mapping_index
long i

lb_found = false
for i = 1 to dw_config_object.mappings.mapping_count
	if lower(control_name) = lower(dw_config_object.mappings.mapping[i].control_name) then
		lb_found = true
		ll_mapping_index = i
		exit
	end if
next

if not lb_found then return

popup.dataobject = "dw_controller_hotspot_pick"
popup.argument_count = 1
popup.argument[1] = controller.config_object_id
popup.add_blank_row = true
popup.blank_text = "<None>"
popup.displaycolumn = 4
popup.datacolumn = 4
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	setnull(ls_hotspot_name)
else
	ls_hotspot_name = popup_return.items[1]
end if

dw_config_object.mappings.mapping[i].hotspot_name = ls_hotspot_name
li_sts = f_save_datawindow_config_object(dw_config_object)


return

end subroutine

public subroutine unmap_datawindow_control (string control_name);str_popup popup
str_popup_return popup_return
integer li_sts
string ls_temp
string ls_hotspot_name
boolean lb_found
long ll_mapping_index
long i

lb_found = false
for i = 1 to dw_config_object.mappings.mapping_count
	if lower(control_name) = lower(dw_config_object.mappings.mapping[i].control_name) then
		lb_found = true
		ll_mapping_index = i
		exit
	end if
next

if not lb_found then return


setnull(dw_config_object.mappings.mapping[i].hotspot_name)
li_sts = f_save_datawindow_config_object(dw_config_object)


return

end subroutine

public function string get_control_value (string ps_control_name, long pl_row);string ls_null
integer li_column_id
long ll_property_id
string ls_coltype
integer li_length
integer li_pos
string ls_progress_type
string ls_progress_key
string ls_value

setnull(ls_null)

if isnull(pl_row) or pl_row <= 0 then return ls_null

// Make sure it's a real control
li_column_id = integer(describe(ps_control_name + ".id"))
if isnull(li_column_id) or li_column_id <= 0 then return ls_null


if li_column_id > 0 then
	// Get the column type
	ls_coltype = trim(upper(Describe(ps_control_name + ".ColType")))
	
	// strip off the size
	li_pos = pos(ls_coltype, "(")
	if li_pos > 0 then
		li_length = integer(mid(ls_coltype, li_pos + 1, len(ls_coltype) - li_pos - 1))
		ls_coltype = left(ls_coltype, li_pos - 1)
	end if
	
	CHOOSE CASE ls_coltype
		CASE "CHAR"
			ls_value = object.data[pl_row, li_column_id]
		CASE "DATE"
			ls_value = string(date(object.data[pl_row, li_column_id]))
		CASE "DATETIME"
			ls_value = string(datetime(object.data[pl_row, li_column_id]))
		CASE "DECIMAL"
			ls_value = string(dec(object.data[pl_row, li_column_id]))
		CASE "INT"
			ls_value = string(integer(object.data[pl_row, li_column_id]))
		CASE "LONG"
			ls_value = string(long(object.data[pl_row, li_column_id]))
		CASE "NUMBER"
			ls_value = string(object.data[pl_row, li_column_id])
		CASE "REAL"
			ls_value = string(real(object.data[pl_row, li_column_id]))
		CASE "TIME"
			ls_value = string(time(object.data[pl_row, li_column_id]))
		CASE "TIMESTAMP"
			ls_value = string(object.data[pl_row, li_column_id])
		CASE "ULONG"
			ls_value = string(object.data[pl_row, li_column_id])
		CASE ELSE
			ls_value = string(object.data[pl_row, li_column_id])
	END CHOOSE
end if	

return ls_value


end function

public function string get_nested_control_value (string ps_nested_control, string ps_control_name, long pl_row);string ls_null
integer li_column_id
long ll_property_id
string ls_coltype
integer li_length
integer li_pos
string ls_progress_type
string ls_progress_key
string ls_value
datawindowchild ldw_nested
integer li_sts

setnull(ls_null)

if isnull(pl_row) or pl_row <= 0 then return ls_null

li_sts = getchild(ps_nested_control, ldw_nested)
if li_sts <= 0 then return ls_null // nested control not found

// Make sure it's a real control
li_column_id = integer(ldw_nested.describe(ps_control_name + ".id"))
if isnull(li_column_id) or li_column_id <= 0 then return ls_null


if li_column_id > 0 then
	// Get the column type
	ls_coltype = trim(upper(ldw_nested.describe(ps_control_name + ".ColType")))
	
	// strip off the size
	li_pos = pos(ls_coltype, "(")
	if li_pos > 0 then
		li_length = integer(mid(ls_coltype, li_pos + 1, len(ls_coltype) - li_pos - 1))
		ls_coltype = left(ls_coltype, li_pos - 1)
	end if
	
	CHOOSE CASE ls_coltype
		CASE "CHAR"
			ls_value = ldw_nested.getitemstring(pl_row, ps_control_name)
		CASE "DATE"
			ls_value = string(ldw_nested.getitemdate(pl_row, ps_control_name))
		CASE "DATETIME"
			ls_value = string(ldw_nested.getitemdatetime(pl_row, ps_control_name))
		CASE "DECIMAL"
			ls_value = string(ldw_nested.getitemdecimal(pl_row, ps_control_name))
		CASE "INT"
			ls_value = string(ldw_nested.getitemnumber(pl_row, ps_control_name))
		CASE "LONG"
			ls_value = string(ldw_nested.getitemnumber(pl_row, ps_control_name))
		CASE "NUMBER"
			ls_value = string(ldw_nested.getitemnumber(pl_row, ps_control_name))
		CASE "REAL"
			ls_value = string(ldw_nested.getitemnumber(pl_row, ps_control_name))
		CASE "TIME"
			ls_value = string(ldw_nested.getitemtime(pl_row, ps_control_name))
		CASE "TIMESTAMP"
			ls_value = string(ldw_nested.getitemdatetime(pl_row, ps_control_name))
		CASE "ULONG"
			ls_value = string(ldw_nested.getitemnumber(pl_row, ps_control_name))
		CASE ELSE
			ls_value = ldw_nested.getitemstring(pl_row, ps_control_name)
	END CHOOSE
end if	

return ls_value


end function

public function str_attributes process_mapping_attributes (str_attributes pstr_attributes);string ls_attribute
string ls_unprocessed_value
string ls_processed_value
str_attributes lstr_processed_attributes
long i
str_complete_context lstr_context
string ls_left
string ls_right

lstr_context = f_get_complete_context()

for i = 1 to pstr_attributes.attribute_count
	ls_attribute = pstr_attributes.attribute[i].attribute
	ls_unprocessed_value = pstr_attributes.attribute[i].value

	if left(ls_unprocessed_value, 1) = ":" then
		// datawindow control reference
		// First shed the colon
		ls_unprocessed_value = mid(ls_unprocessed_value, 2)
		// Split on the period to see if this is a nested datawindow control
		f_split_string(ls_unprocessed_value, ".", ls_left, ls_right)
		if len(ls_right) > 0 then
			ls_processed_value = get_nested_control_value(ls_left, ls_right, lastnestedrow)
		else
			ls_processed_value = get_control_value(ls_unprocessed_value, lastrow)
		end if
		
			
	else
		ls_processed_value = f_attribute_value_substitute_string(ls_unprocessed_value, lstr_context, attributes)
	end if

	if len(ls_attribute) > 0 and len(ls_processed_value) > 0 then
		f_attribute_add_attribute(lstr_processed_attributes, ls_attribute, ls_processed_value)
	end if
next

return lstr_processed_attributes
end function

on u_dw_display.create
call super::create
end on

on u_dw_display.destroy
call super::destroy
end on

event rbuttondown;integer i
integer li_selected_flag
string ls_object, ls_left, ls_right, ls_column
string ls_message
string ls_hotspot_name
string ls_temp
long ll_choice
str_popup popup

// Set the 'last' values
lasttype = dwo.type
lastrow = row 
lastheader = false
lastcomputed = false
lastcolumnname = dwo.name
lasttag = describe(dwo.name + ".tag")
if lasttag = "?" then lasttag = ""
mousebutton = "RIGHT"

ls_object = getobjectatpointer()
f_split_string(ls_object, "~t", ls_left, ls_right)

lastrow = integer(ls_right)
lastcolumn = 1

if config_mode then
	if keydown(keycontrol!) then
		setnull(ls_hotspot_name)
		ls_message = "The control you clicked (" + lastcolumnname + ")"
		for i = 1 to dw_config_object.mappings.mapping_count
			if lower(lastcolumnname) = lower(dw_config_object.mappings.mapping[i].control_name) then
				ls_hotspot_name = dw_config_object.mappings.mapping[i].hotspot_name
				ls_message += " is mapped to the hotspot named ~"" + ls_hotspot_name + "~"."
				exit
			end if
		next
		
		if isnull(ls_hotspot_name) and len(lasttag) > 0 then
			ls_hotspot_name = lasttag
			ls_message = " is tagged ~"" + lasttag + "~""
		end if
		
		if isnull(ls_hotspot_name) then
			ls_message += " is not mapped to a hotspot."
		else
			ls_temp = ", which is not a valid hotspot name."
			for i = 1 to controller.hotspot_count
				if lower(controller.hotspot[i].hotspot_name) = lower(ls_hotspot_name) then
					ls_temp = ", which is a valid hotspot name."
					ls_hotspot_name = controller.hotspot[i].hotspot_name
					exit
				end if
			next
			ls_message += ls_temp
		end if
			
		ls_message += "  Do you wish to..."

		popup.title = ls_message
		popup.data_row_count = 3
		popup.items[1] = "Map this control"
		popup.items[2] = "Remove the mapping for this control"
		popup.items[3] = "Cancel"
		openwithparm(w_pop_choices_3, popup)
		ll_choice = message.doubleparm
		CHOOSE CASE ll_choice
			CASE 1
				map_datawindow_control(lastcolumnname)
			CASE 2
				unmap_datawindow_control(lastcolumnname)
			CASE ELSE
		END CHOOSE
		return
	else
		f_configure_config_object(dw_config_object.config_object_id)
		refresh()
	end if
end if

if lastrow = 0 then return

ls_column = describe("selected_flag.name")
if ls_column = "selected_flag" then
	if multiselect and ((not multiselect_ctrl) or keydown(KeyControl!)) then
		li_selected_flag = object.selected_flag[lastrow]
		setitem(lastrow, "selected_flag", 1 - li_selected_flag)
	else
		for i = 1 to rowcount()
			setitem(i, "selected_flag", 0)
		next
		setitem(lastrow, "selected_flag", 1)
	end if
end if



end event

event clicked;call super::clicked;string ls_column
string ls_temp
string ls_left
string ls_right
long ll_pos
integer li_selected_flag
integer li_column
datawindowchild ldw_rpt
integer li_sts
long ll_row
str_datawindow_nested_datawindow lstr_nested
long i
boolean lb_hotspot_found
string ls_hotspot_name
long ll_end
string ls_find
str_attributes lstr_mapping_attributes

// Set the 'last' values
lasttype = dwo.type
lastrow = row 
lastheader = false
lastcomputed = false
lastcolumnname = dwo.name
lasttag = describe(dwo.name + ".tag")
if lasttag = "?" then lasttag = ""

mousebutton = "LEFT"

if lasttype = "column" then
	lastcolumn = integer(dwo.id)
elseif lasttype = "compute" then
	lastcolumn = 0
	ls_temp = lower(left(describe(dwo.name + ".expression"), 6))
	if ls_temp = "bitmap" or ls_temp = "~"bitma" then lastcomputed = true
else
	lastcolumn = 0
end if

// If we didn't click on a row, check to see if we clicked on a header
if lastrow <= 0 then
	if active_header then
		ls_temp = GetBandAtPointer()
		ll_pos = pos(ls_temp,"~t")
		lastrow = long(mid(ls_temp,ll_pos, 4))
		if lastrow > 0 then
			// If we clicked on a header, then set lastheader and post post_click event
			lastheader = true
			set_row()
		end if
	end if
elseif lastcomputed then
	This.event POST computed_clicked(lastrow)
	if select_computed then set_row()
else
	set_row()
end if

if lower(lasttype) = "report" then
	li_sts = getchild(lastcolumnname, ldw_rpt)
	if li_sts > 0 then
		lstr_nested = find_nested_datawindow(lastcolumnname)
		ls_temp = ldw_rpt.getbandatpointer( )
		f_split_string(ls_temp, "~t", ls_left, ls_right)
		lastnestedrow = long(ls_right)
		ldw_rpt.selectrow(lastnestedrow, true)
		if lstr_nested.has_selected_flag then
			ll_end = ldw_rpt.rowcount()
			ls_find = "selected_flag=1"
			ll_row = ldw_rpt.Find(ls_find, 1, ll_end)
			DO WHILE ll_row > 0 AND ll_row <= ll_end
				ldw_rpt.setitem(ll_row, "selected_flag", 0)
				ll_row = ldw_rpt.Find(ls_find, ll_row + 1, ll_end + 1)
			LOOP
			
			ldw_rpt.setitem(lastnestedrow, "selected_flag", 1)
		end if
	end if
end if

lb_hotspot_found = false
for i = 1 to dw_config_object.mappings.mapping_count
	if lower(lastcolumnname) = lower(dw_config_object.mappings.mapping[i].control_name) then
		ls_hotspot_name = dw_config_object.mappings.mapping[i].hotspot_name
		lstr_mapping_attributes = dw_config_object.mappings.mapping[i].attributes
		lb_hotspot_found = true
		exit
	end if
next

if not lb_hotspot_found and len(lasttag) > 0 then
	lb_hotspot_found = true
	ls_hotspot_name = lasttag
end if

if lb_hotspot_found then
	for i = 1 to controller.hotspot_count
		if lower(controller.hotspot[i].hotspot_name) = lower(ls_hotspot_name) then
			this.event POST hotspot_hit(dw_config_object.controller_config_object_id, controller.hotspot[i], process_mapping_attributes(lstr_mapping_attributes))
			exit
		end if
	next
end if


end event

