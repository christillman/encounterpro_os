HA$PBExportHeader$w_svc_config_datawindow.srw
forward
global type w_svc_config_datawindow from w_svc_config_object_base
end type
type st_component_title from statictext within w_svc_config_datawindow
end type
type st_dataobject_title from statictext within w_svc_config_datawindow
end type
type st_dataobject from statictext within w_svc_config_datawindow
end type
type dw_preview from u_dw_display within w_svc_config_datawindow
end type
type st_preview_title from statictext within w_svc_config_datawindow
end type
type st_argument_count_title from statictext within w_svc_config_datawindow
end type
type st_argument_count from statictext within w_svc_config_datawindow
end type
type st_nested_title from statictext within w_svc_config_datawindow
end type
type st_nested from statictext within w_svc_config_datawindow
end type
type cb_change_dataobject from commandbutton within w_svc_config_datawindow
end type
type st_component from statictext within w_svc_config_datawindow
end type
type st_controller from statictext within w_svc_config_datawindow
end type
type st_controller_title from statictext within w_svc_config_datawindow
end type
type dw_mappings from u_dw_pick_list within w_svc_config_datawindow
end type
type st_mappings_title from statictext within w_svc_config_datawindow
end type
type cb_configure_controller from commandbutton within w_svc_config_datawindow
end type
end forward

global type w_svc_config_datawindow from w_svc_config_object_base
st_component_title st_component_title
st_dataobject_title st_dataobject_title
st_dataobject st_dataobject
dw_preview dw_preview
st_preview_title st_preview_title
st_argument_count_title st_argument_count_title
st_argument_count st_argument_count
st_nested_title st_nested_title
st_nested st_nested
cb_change_dataobject cb_change_dataobject
st_component st_component
st_controller st_controller
st_controller_title st_controller_title
dw_mappings dw_mappings
st_mappings_title st_mappings_title
cb_configure_controller cb_configure_controller
end type
global w_svc_config_datawindow w_svc_config_datawindow

type variables
str_datawindow_config_object datawindow_config_object

str_config_object_info controller

end variables

forward prototypes
public function integer refresh ()
public function string pick_dataobject (string ps_dataobject)
public function string load_from_file ()
public function integer change_dataobject ()
public function integer change_controller ()
public function integer map_datawindow_control (long pl_row)
public function str_datawindow_mapping find_mapping (ref str_datawindow_mappings pstr_old_mappings, string ps_control_name)
end prototypes

public function integer refresh ();long ll_count
integer li_sts
string ls_error
str_component_definition lstr_component

super::refresh()

st_argument_count.text = "Unknown"
st_argument_count.borderstyle = stylebox!
st_nested.text = "Unknown"
st_nested.borderstyle = stylebox!
		
// Set the config object and parse it into the dw_config_object structure
li_sts = dw_preview.set_datawindow_config_object(config_object_id)
if li_sts < 0 then return -1

if len(datawindow_config_object.library_component_id) > 0 then
	lstr_component = f_get_component_definition(datawindow_config_object.library_component_id)
	st_component.text = lstr_component.description
else
	st_component.text = "NA"
end if

if len(datawindow_config_object.dataobject) > 0 then
	st_dataobject.text = datawindow_config_object.dataobject
elseif len(datawindow_config_object.datawindow_syntax) > 0 then
	st_dataobject.text = "<embedded script>"
else
	st_dataobject.text = "NA"
end if

st_argument_count.text = string(dw_preview.dw_config_object.arguments.argument_count)
if dw_preview.dw_config_object.arguments.argument_count > 0 then
	st_argument_count.borderstyle = styleraised!
else
	st_argument_count.borderstyle = stylebox!
end if

st_nested.text = string(dw_preview.dw_config_object.nested.nested_datawindow_count)
if dw_preview.dw_config_object.nested.nested_datawindow_count > 0 then
	st_nested.borderstyle = styleraised!
else
	st_nested.borderstyle = stylebox!
end if

li_sts = f_get_config_object_info(datawindow_config_object.controller_config_object_id, controller)
if li_sts > 0 then
	st_controller.text = controller.description
	dw_mappings.settransobject(sqlca)
	dw_mappings.retrieve(config_object_id)
	cb_configure_controller.visible = true
else
	st_controller.text = "<None>"
	dw_mappings.reset()
	cb_configure_controller.visible = false
end if

if editable then
	cb_change_dataobject.visible = true
	st_controller.enabled = true
	st_controller.borderstyle = styleraised!
else
	cb_change_dataobject.visible = false
	st_controller.enabled = false
	st_controller.borderstyle = stylebox!
end if

return 1

end function

public function string pick_dataobject (string ps_dataobject);str_param_setting lstr_param
str_param_wizard_return lstr_return
w_param_setting lw_param_window
string ls_null
string ls_dataobject

setnull(ls_null)

lstr_param.param.param_class = "u_param_datawindow"
lstr_param.param.param_title = "Select Datawindow Object"
lstr_param.param.token1 = "dataobject"
lstr_param.param.helptext = "Select datawindow object from one of the installed powerbuilder libraries"
lstr_param.param.query = ls_null
lstr_param.param.required_flag = "N"

if not isnull(ps_dataobject) then
	f_attribute_add_attribute(lstr_param.attributes, lstr_param.param.token1, ps_dataobject)
end if

openwithparm(lw_param_window, lstr_param, "w_param_setting")
lstr_return = message.powerobjectparm
if lstr_return.return_status <= 0 then return ls_null

ls_dataobject = f_attribute_find_attribute(lstr_return.attributes, lstr_param.param.token1)

return ls_dataobject

end function

public function string load_from_file ();str_popup popup
str_popup_return popup_return
string ls_extensions[]
integer li_extension_count
string ls_filter
long i
integer li_sts
string lsa_paths[]
string lsa_files[]
str_file_attributes lstr_file_attributes
long ll_filebytes
blob lbl_file
long ll_count
string ls_new_script
string ls_error
string ls_null
string ls_filepath
string ls_list
string ls_lines[]
long ll_line_count
string ls_fields[]
long ll_field_count
string ls_datawindows[]
long ll_datawindow_count
integer li_index

setnull(ls_null)

ls_filter = "PBL files (*.pbl), *.pbl"

li_sts = windows_api.comdlg32.getopenfilename( handle(w_main), &
															"Select " + st_title.text + " File", &
															lsa_paths, &
															lsa_files, &
															ls_filter)
if li_sts < 0 then return ls_null

ll_count = upperbound(lsa_paths)
if isnull(ll_count) or ll_count <= 0 then return ls_null

if ll_count > 1 then
	openwithparm(w_pop_message, "Multiple files selected.  Please select only one file.")
	return ls_null
end if

for i = 1 to ll_count
	// Skip the shorthand directories
	if lsa_files[i] = "." or lsa_files[i] = ".." then continue
	
	// Skip the file if we can't get its properties
	li_sts = log.file_attributes(lsa_paths[i], lstr_file_attributes)
	if li_sts <= 0 then continue
	
	// Skip the directories
	if lstr_file_attributes.subdirectory then continue

	// Found one !!
	ls_filepath = lsa_paths[i]
	exit
next



// Now get the desired datawindow from the library

ls_list = librarydirectory(ls_filepath, DirDataWindow!)
if isnull(ls_list) or ls_list = "" then
	openwithparm(w_pop_message, "The selected library contains no datawindows")
	return ls_null
end if

ll_line_count = f_parse_string(ls_list, "~n", ls_lines)
if ll_line_count <= 0 then
	openwithparm(w_pop_message, "The selected library contains no datawindows")
	return ls_null
end if

for i = 1 to ll_line_count
	ll_field_count = f_parse_string(ls_lines[i], "~t", ls_fields)
	if ll_field_count >= 1 then
		ll_datawindow_count++
		ls_datawindows[ll_datawindow_count] = ls_fields[1]
	end if
next

popup.data_row_count = ll_datawindow_count
popup.items = ls_datawindows
popup.title = "Select Datawindow"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return ls_null

li_index = popup_return.item_indexes[1]

ls_new_script = libraryexport(ls_filepath, ls_datawindows[li_index], ExportDataWindow!)

if len(ls_new_script) > 0 then
	return ls_new_script
end if

return ls_null


end function

public function integer change_dataobject ();string ls_script
blob lbl_objectdata
string ls_xml
str_popup popup
str_popup_return popup_return
string ls_current_dataobject
string ls_new_dataobject
string ls_library_component_id
string ls_dataobject
integer li_sts
long i
string ls_control_name
str_datawindow_mappings lstr_old_mappings

popup.title = "Get Datawindow"
popup.data_row_count = 2
popup.items[1] = "Select From Installed Library"
popup.items[2] = "Extract From External PBL File"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

lstr_old_mappings = datawindow_config_object.mappings

if popup_return.item_indexes[1] = 1 then
	ls_new_dataobject = pick_dataobject(datawindow_config_object.dataobject)
	if isnull(ls_new_dataobject) or len(ls_new_dataobject) <= 0 then return 0
	
	f_split_string(ls_new_dataobject, "|", ls_library_component_id, ls_dataobject)
	
	if lower(ls_library_component_id) = lower(datawindow_config_object.library_component_id) &
	 and lower(ls_dataobject) = lower(datawindow_config_object.dataobject)  then return 0
	 
	datawindow_config_object.library_component_id = f_get_component_guid(ls_library_component_id)
	datawindow_config_object.dataobject = ls_dataobject
	// The dataobject changed so clear the syntax and mappings
	setnull(datawindow_config_object.datawindow_syntax)
	datawindow_config_object.mappings.mapping_count = 0
else
	ls_script = load_from_file()
	if isnull(ls_script) or len(ls_script) <= 0 then return 0
	
	datawindow_config_object.datawindow_syntax = ls_script
	setnull(datawindow_config_object.library_component_id)
	setnull(datawindow_config_object.dataobject)
	datawindow_config_object.mappings.mapping_count = 0
end if

li_sts = f_save_datawindow_config_object(datawindow_config_object)

refresh()

// We changed the dataobject so reset the datawindow control list
datawindow_config_object.mappings.mapping_count = 0
if dw_preview.dw_config_object.controls.control_count > 0 or dw_preview.dw_config_object.nested.nested_datawindow_count > 0 then
	for i = 1 to dw_preview.dw_config_object.nested.nested_datawindow_count
		ls_control_name = dw_preview.dw_config_object.nested.nested_datawindow[i].controlname
		datawindow_config_object.mappings.mapping_count += 1
		datawindow_config_object.mappings.mapping[datawindow_config_object.mappings.mapping_count] = find_mapping(lstr_old_mappings, ls_control_name)
		datawindow_config_object.mappings.mapping[datawindow_config_object.mappings.mapping_count].control_name =  ls_control_name
		datawindow_config_object.mappings.mapping[datawindow_config_object.mappings.mapping_count].status =  "OK"
	next
	
	for i = 1 to dw_preview.dw_config_object.controls.control_count
		ls_control_name = dw_preview.dw_config_object.controls.control[i].control_name
		datawindow_config_object.mappings.mapping_count += 1
		datawindow_config_object.mappings.mapping[datawindow_config_object.mappings.mapping_count] = find_mapping(lstr_old_mappings, ls_control_name)
		datawindow_config_object.mappings.mapping[datawindow_config_object.mappings.mapping_count].control_name =  dw_preview.dw_config_object.controls.control[i].control_name
		datawindow_config_object.mappings.mapping[datawindow_config_object.mappings.mapping_count].status =  "OK"
	next
	
	li_sts = f_save_datawindow_config_object(datawindow_config_object)
	
	refresh()
end if

return 1

end function

public function integer change_controller ();str_pick_config_object lstr_pick_config_object
w_pick_config_object lw_pick
integer li_sts
str_popup_return popup_return

lstr_pick_config_object.config_object_type = "Controller"
lstr_pick_config_object.context_object = config_object_info.context_object

openwithparm(lw_pick, lstr_pick_config_object, "w_pick_config_object")
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

if isnull(datawindow_config_object.controller_config_object_id) or lower(datawindow_config_object.controller_config_object_id) <> lower(popup_return.items[1]) then
	datawindow_config_object.controller_config_object_id = popup_return.items[1]
	datawindow_config_object.mappings.mapping_count = 0
end if

li_sts = f_save_datawindow_config_object(datawindow_config_object)

refresh()

return 1


end function

public function integer map_datawindow_control (long pl_row);str_popup popup
str_popup_return popup_return
integer li_sts
string ls_temp
string ls_hotspot_name

popup.dataobject = "dw_controller_hotspot_pick"
popup.argument_count = 1
popup.argument[1] = datawindow_config_object.controller_config_object_id
popup.add_blank_row = true
popup.blank_text = "<None>"
popup.displaycolumn = 4
popup.datacolumn = 4
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

if popup_return.items[1] = "" then
	setnull(ls_hotspot_name)
else
	ls_hotspot_name = popup_return.items[1]
end if

dw_mappings.object.hotspot_name[pl_row] = ls_hotspot_name
li_sts = dw_mappings.update()


return 1

end function

public function str_datawindow_mapping find_mapping (ref str_datawindow_mappings pstr_old_mappings, string ps_control_name);long i
str_datawindow_mapping lstr_mapping

for i = 1 to pstr_old_mappings.mapping_count
	if lower(pstr_old_mappings.mapping[i].control_name) = lower(ps_control_name) then
		return pstr_old_mappings.mapping[i]
	end if
next

return f_empty_datawindow_mapping()



end function

event open;call super::open;str_popup_return popup_return
integer li_sts

li_sts = f_get_datawindow_config_object(config_object_id, datawindow_config_object)
if li_sts < 0 then
	log.log(this, "open", "Error getting datawindow config object(" + config_object_id + ")", 4)

	popup_return.item_count = 1
	popup_return.items[1] = "ERROR"
	
	closewithreturn(this, popup_return)
end if


end event

on w_svc_config_datawindow.create
int iCurrent
call super::create
this.st_component_title=create st_component_title
this.st_dataobject_title=create st_dataobject_title
this.st_dataobject=create st_dataobject
this.dw_preview=create dw_preview
this.st_preview_title=create st_preview_title
this.st_argument_count_title=create st_argument_count_title
this.st_argument_count=create st_argument_count
this.st_nested_title=create st_nested_title
this.st_nested=create st_nested
this.cb_change_dataobject=create cb_change_dataobject
this.st_component=create st_component
this.st_controller=create st_controller
this.st_controller_title=create st_controller_title
this.dw_mappings=create dw_mappings
this.st_mappings_title=create st_mappings_title
this.cb_configure_controller=create cb_configure_controller
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_component_title
this.Control[iCurrent+2]=this.st_dataobject_title
this.Control[iCurrent+3]=this.st_dataobject
this.Control[iCurrent+4]=this.dw_preview
this.Control[iCurrent+5]=this.st_preview_title
this.Control[iCurrent+6]=this.st_argument_count_title
this.Control[iCurrent+7]=this.st_argument_count
this.Control[iCurrent+8]=this.st_nested_title
this.Control[iCurrent+9]=this.st_nested
this.Control[iCurrent+10]=this.cb_change_dataobject
this.Control[iCurrent+11]=this.st_component
this.Control[iCurrent+12]=this.st_controller
this.Control[iCurrent+13]=this.st_controller_title
this.Control[iCurrent+14]=this.dw_mappings
this.Control[iCurrent+15]=this.st_mappings_title
this.Control[iCurrent+16]=this.cb_configure_controller
end on

on w_svc_config_datawindow.destroy
call super::destroy
destroy(this.st_component_title)
destroy(this.st_dataobject_title)
destroy(this.st_dataobject)
destroy(this.dw_preview)
destroy(this.st_preview_title)
destroy(this.st_argument_count_title)
destroy(this.st_argument_count)
destroy(this.st_nested_title)
destroy(this.st_nested)
destroy(this.cb_change_dataobject)
destroy(this.st_component)
destroy(this.st_controller)
destroy(this.st_controller_title)
destroy(this.dw_mappings)
destroy(this.st_mappings_title)
destroy(this.cb_configure_controller)
end on

event resize;call super::resize;
st_nested.y = height - st_nested.height - 150
st_nested_title.y = st_nested.y + 8

st_argument_count.y = st_nested.y - st_argument_count.height - 30
st_argument_count_title.y = st_argument_count.y + 8


cb_save_to_file.x = st_nested.x + st_nested.width + 100

st_controller_title.x = st_checkout_title.x
st_controller.x = st_checkout.x

cb_configure_controller.x = st_controller.x + ((st_controller.width - cb_configure_controller.width) / 2)

dw_mappings.x = st_controller.x + st_controller.width - dw_mappings.width
dw_mappings.height = st_argument_count.y - dw_mappings.y - 100
st_mappings_title.x = dw_mappings.x

dw_preview.width = dw_mappings.x - dw_preview.x - 100
dw_preview.height = st_argument_count.y - dw_preview.y - 100



end event

type pb_epro_help from w_svc_config_object_base`pb_epro_help within w_svc_config_datawindow
end type

type st_config_mode_menu from w_svc_config_object_base`st_config_mode_menu within w_svc_config_datawindow
end type

type cb_finished from w_svc_config_object_base`cb_finished within w_svc_config_datawindow
end type

type st_title from w_svc_config_object_base`st_title within w_svc_config_datawindow
string text = "Datawindow Configuration"
end type

type st_2 from w_svc_config_object_base`st_2 within w_svc_config_datawindow
end type

type st_report_description from w_svc_config_object_base`st_report_description within w_svc_config_datawindow
end type

type cb_change_name from w_svc_config_object_base`cb_change_name within w_svc_config_datawindow
end type

type cb_change_status from w_svc_config_object_base`cb_change_status within w_svc_config_datawindow
end type

type st_config_object_id from w_svc_config_object_base`st_config_object_id within w_svc_config_datawindow
end type

type st_config_object_id_title from w_svc_config_object_base`st_config_object_id_title within w_svc_config_datawindow
end type

type st_status from w_svc_config_object_base`st_status within w_svc_config_datawindow
end type

type st_status_title from w_svc_config_object_base`st_status_title within w_svc_config_datawindow
end type

type st_context_object from w_svc_config_object_base`st_context_object within w_svc_config_datawindow
end type

type st_context_object_title from w_svc_config_object_base`st_context_object_title within w_svc_config_datawindow
end type

type cb_change_context from w_svc_config_object_base`cb_change_context within w_svc_config_datawindow
end type

type st_report_category from w_svc_config_object_base`st_report_category within w_svc_config_datawindow
end type

type st_report_category_title from w_svc_config_object_base`st_report_category_title within w_svc_config_datawindow
end type

type cb_change_report_category from w_svc_config_object_base`cb_change_report_category within w_svc_config_datawindow
end type

type cb_copy_report from w_svc_config_object_base`cb_copy_report within w_svc_config_datawindow
end type

type st_not_copyable from w_svc_config_object_base`st_not_copyable within w_svc_config_datawindow
end type

type st_owner from w_svc_config_object_base`st_owner within w_svc_config_datawindow
end type

type st_owner_title from w_svc_config_object_base`st_owner_title within w_svc_config_datawindow
end type

type cb_checkout from w_svc_config_object_base`cb_checkout within w_svc_config_datawindow
end type

type st_checkout from w_svc_config_object_base`st_checkout within w_svc_config_datawindow
end type

type st_checkout_title from w_svc_config_object_base`st_checkout_title within w_svc_config_datawindow
end type

type st_version from w_svc_config_object_base`st_version within w_svc_config_datawindow
end type

type st_version_title from w_svc_config_object_base`st_version_title within w_svc_config_datawindow
end type

type cb_save_to_file from w_svc_config_object_base`cb_save_to_file within w_svc_config_datawindow
integer x = 1001
integer y = 1640
end type

type st_component_title from statictext within w_svc_config_datawindow
integer x = 14
integer y = 708
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Library:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_dataobject_title from statictext within w_svc_config_datawindow
integer x = 1111
integer y = 708
integer width = 343
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Dataobject:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_dataobject from statictext within w_svc_config_datawindow
integer x = 1467
integer y = 700
integer width = 997
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
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type dw_preview from u_dw_display within w_svc_config_datawindow
integer x = 59
integer y = 920
integer width = 2144
integer height = 532
integer taborder = 21
boolean bringtotop = true
end type

type st_preview_title from statictext within w_svc_config_datawindow
integer x = 64
integer y = 856
integer width = 293
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
string text = "Preview"
boolean focusrectangle = false
end type

type st_argument_count_title from statictext within w_svc_config_datawindow
integer x = 64
integer y = 1536
integer width = 585
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
string text = "Argument Count:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_argument_count from statictext within w_svc_config_datawindow
integer x = 658
integer y = 1528
integer width = 293
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "0"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
long i


popup.data_row_count = dw_preview.dw_config_object.arguments.argument_count
for i = 1 to dw_preview.dw_config_object.arguments.argument_count
	popup.items[i] = dw_preview.dw_config_object.arguments.argument[i].argument_name + "  " + dw_preview.dw_config_object.arguments.argument[i].argument_type
next

openwithparm(w_pop_pick, popup)

end event

type st_nested_title from statictext within w_svc_config_datawindow
integer x = 64
integer y = 1636
integer width = 585
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
string text = "Nested Datawindows:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_nested from statictext within w_svc_config_datawindow
integer x = 658
integer y = 1632
integer width = 293
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "0"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
long i
long j
string ls_temp

popup.data_row_count = dw_preview.dw_config_object.nested.nested_datawindow_count
for i = 1 to dw_preview.dw_config_object.nested.nested_datawindow_count
	popup.items[i] = dw_preview.dw_config_object.nested.nested_datawindow[i].dataobject
	ls_temp = ""
	for j = 1 to dw_preview.dw_config_object.nested.nested_datawindow[i].nested_argument_count
		if len(ls_temp) > 0 then ls_temp += ", "
		ls_temp += dw_preview.dw_config_object.nested.nested_datawindow[i].nested_argument[j]
	next
	if len(ls_temp) > 0 then
		popup.items[i] += " (" + ls_temp + ")"
	end if
next

openwithparm(w_pop_pick, popup)

end event

type cb_change_dataobject from commandbutton within w_svc_config_datawindow
integer x = 1874
integer y = 808
integer width = 590
integer height = 84
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Change Dataobject"
end type

event clicked;change_dataobject()

end event

type st_component from statictext within w_svc_config_datawindow
integer x = 434
integer y = 700
integer width = 613
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_controller from statictext within w_svc_config_datawindow
integer x = 2949
integer y = 700
integer width = 1006
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
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;change_controller()


end event

type st_controller_title from statictext within w_svc_config_datawindow
integer x = 2523
integer y = 708
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Controller:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_mappings from u_dw_pick_list within w_svc_config_datawindow
integer x = 2240
integer y = 1008
integer width = 1714
integer height = 512
integer taborder = 31
boolean bringtotop = true
string dataobject = "dw_datawindow_control_mappings"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;if not editable then
	clear_selected()
	return
end if

if lower(lastcolumnname) = "compute_hotspot" then
	map_datawindow_control(selected_row)
end if

end event

event buttonclicked;call super::buttonclicked;string ls_control_name
long i
long ll_mapping_index
str_popup popup
str_popup_return popup_return

if row <= 0 or isnull(row) then return

ls_control_name = object.control_name[row]

ll_mapping_index = 0
for i = 1 to dw_preview.dw_config_object.mappings.mapping_count
	if lower(ls_control_name) = lower(dw_preview.dw_config_object.mappings.mapping[i].control_name) then
		ll_mapping_index = i
		exit
	end if
next

if ll_mapping_index > 0 then
	popup.items[1] = dw_preview.dw_config_object.config_object_id
	popup.items[2] = dw_preview.dw_config_object.mappings.mapping[ll_mapping_index].control_name
	popup.objectparm = dw_preview.dw_config_object.mappings.mapping[ll_mapping_index].attributes
	popup.objectparm2 = dw_preview.dw_config_object.controls
	// See if this control matches a nested datawindow
	for i = 1 to dw_preview.dw_config_object.nested.nested_datawindow_count
		if lower(ls_control_name) = lower(dw_preview.dw_config_object.nested.nested_datawindow[i].controlname) then
			popup.objectparm3 = dw_preview.dw_config_object.nested.nested_datawindow[i]
		end if
	next
	openwithparm(w_datawindow_mapping_attributes, popup)
	popup_return = message.powerobjectparm
	if popup_return.item = "OK" then
		dw_preview.dw_config_object.mappings.mapping[ll_mapping_index].attributes = popup_return.returnobject
	end if
end if

end event

type st_mappings_title from statictext within w_svc_config_datawindow
integer x = 2240
integer y = 920
integer width = 1614
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Datawindow Controller Mappings"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_configure_controller from commandbutton within w_svc_config_datawindow
integer x = 3159
integer y = 808
integer width = 590
integer height = 84
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Configure Controller"
end type

event clicked;f_configure_config_object(datawindow_config_object.controller_config_object_id)

refresh()

end event

