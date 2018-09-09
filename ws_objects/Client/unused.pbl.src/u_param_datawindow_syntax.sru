$PBExportHeader$u_param_datawindow_syntax.sru
forward
global type u_param_datawindow_syntax from u_param_base
end type
type dw_preview from datawindow within u_param_datawindow_syntax
end type
type st_argument_count_title from statictext within u_param_datawindow_syntax
end type
type st_argument_count from statictext within u_param_datawindow_syntax
end type
type cb_pick from commandbutton within u_param_datawindow_syntax
end type
end forward

global type u_param_datawindow_syntax from u_param_base
dw_preview dw_preview
st_argument_count_title st_argument_count_title
st_argument_count st_argument_count
cb_pick cb_pick
end type
global u_param_datawindow_syntax u_param_datawindow_syntax

type variables
string script

str_datawindow_arguments arguments


end variables

forward prototypes
public function integer check_required ()
public function integer x_initialize ()
public function integer pick_param ()
public function integer show_script ()
public function string load_from_file ()
end prototypes

public function integer check_required ();//////////////////////////////////////////////////////////////////////////////////////
//
//	Return: Integer [ -1 - required column missing  1 - validation success
//
//	Description: validates whether it's required column
//
// Created By:Sumathi Chinnasamy										Creation dt: 10/14/99
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////
if upper(param_wizard.params.params[param_index].required_flag) = "Y" then
	If Isnull(script) Or Len(script) = 0 Then
		Openwithparm(w_pop_message,"Please enter a " + st_title.text)
		Return -1
	End if
End If

Return 1
end function

public function integer x_initialize ();//////////////////////////////////////////////////////////////////////////////////////
//
//	Return: Integer
//
// Description:If no values defined then initialize the fields with initial values
//
// Created By:Sumathi Chinnasamy										Creation dt: 10/14/99
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////
string ls_intitial_value
integer li_sts

ls_intitial_value = get_initial_value(1)

If trim(ls_intitial_value) <> "" and not isnull(ls_intitial_value) and not preference_in_use Then
	script = ls_intitial_value
Else
	setnull(script)
end if

show_script()


return 1

end function

public function integer pick_param ();str_popup popup
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
string ls_new_script_name
string ls_error
string ls_clipboard

ls_clipboard = clipboard()
ls_new_script = ""
ls_new_script_name = ""

popup.title = "Datawindow Script"
popup.data_row_count = 1
popup.items[1] = "Load From PBL File"
if lower(left(ls_clipboard, 2)) = "dw" then
	popup.data_row_count += 1
	popup.items[popup.data_row_count] = "Use " + ls_clipboard
end if
popup.data_row_count += 1
popup.items[popup.data_row_count] = "Built-in Datawindow"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

CHOOSE CASE popup_return.items[1]
	CASE "Load From PBL File"
		ls_new_script = load_from_file()
	CASE "Built-in Datawindow"
		popup.title = "Enter Built-in Datawindow Name"
		popup.data_row_count = 0
		openwithparm(w_pop_prompt_string, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return 0
		
		ls_new_script_name = popup_return.items[1]
	CASE ELSE
		ls_new_script_name = ls_clipboard
END CHOOSE

if len(ls_new_script_name) > 0 then
	dw_preview.dataobject = ls_new_script_name
	if isnull(dw_preview.object) or not isvalid(dw_preview.object) then
		openwithparm(w_pop_message, "The specified datawindow (" + ls_new_script_name + ") is not valid")
		return 0
	end if
	ls_new_script = dw_preview.object.datawindow.syntax
end if

if isnull(ls_new_script) or len(ls_new_script) = 0 then
	return 0
end if

li_sts = dw_preview.create(ls_new_script, ls_error)
if li_sts <= 0 then
	openwithparm(w_pop_message, "Invalid datawindow script:  " + ls_error)
	show_script()
	return 0
else
	dw_preview.Object.DataWindow.zoom = 50
	arguments = f_get_datawindow_arguments(ls_new_script)
	st_argument_count.text = string(arguments.argument_count)
	if arguments.argument_count > 0 then
		st_argument_count.borderstyle = styleraised!
	else
		st_argument_count.borderstyle = stylebox!
	end if
end if

script = ls_new_script

update_param(param_wizard.params.params[param_index].token1, script)

if st_required.visible and not isnull(script) then
	param_wizard.event POST ue_required(true)
end if

return 1

end function

public function integer show_script ();integer li_sts
string ls_error

dw_preview.setredraw(false)

if len(script) > 0 then
	li_sts = dw_preview.create(script, ls_error)
	if li_sts <= 0 then
		setnull(script)
		dw_preview.reset()
	else
		dw_preview.Object.DataWindow.zoom = 50
	end if
else
	dw_preview.reset()
end if

dw_preview.setredraw(true)

arguments = f_get_datawindow_arguments(script)
st_argument_count.text = string(arguments.argument_count)
if arguments.argument_count > 0 then
	st_argument_count.borderstyle = styleraised!
else
	st_argument_count.borderstyle = stylebox!
end if

return 1

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

on u_param_datawindow_syntax.create
int iCurrent
call super::create
this.dw_preview=create dw_preview
this.st_argument_count_title=create st_argument_count_title
this.st_argument_count=create st_argument_count
this.cb_pick=create cb_pick
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_preview
this.Control[iCurrent+2]=this.st_argument_count_title
this.Control[iCurrent+3]=this.st_argument_count
this.Control[iCurrent+4]=this.cb_pick
end on

on u_param_datawindow_syntax.destroy
call super::destroy
destroy(this.dw_preview)
destroy(this.st_argument_count_title)
destroy(this.st_argument_count)
destroy(this.cb_pick)
end on

type st_preference from u_param_base`st_preference within u_param_datawindow_syntax
end type

type st_preference_title from u_param_base`st_preference_title within u_param_datawindow_syntax
end type

type cb_clear from u_param_base`cb_clear within u_param_datawindow_syntax
integer x = 896
integer y = 976
integer taborder = 30
end type

event cb_clear::clicked;call super::clicked;setnull(script)
dw_preview.reset()

f_attribute_remove_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				param_wizard.params.id )


end event

type st_required from u_param_base`st_required within u_param_datawindow_syntax
integer x = 1358
integer y = 424
end type

type st_helptext from u_param_base`st_helptext within u_param_datawindow_syntax
end type

type st_title from u_param_base`st_title within u_param_datawindow_syntax
integer y = 480
end type

type dw_preview from datawindow within u_param_datawindow_syntax
integer x = 1349
integer y = 476
integer width = 1184
integer height = 568
integer taborder = 10
boolean livescroll = true
end type

type st_argument_count_title from statictext within u_param_datawindow_syntax
integer x = 1381
integer y = 1052
integer width = 462
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
boolean focusrectangle = false
end type

type st_argument_count from statictext within u_param_datawindow_syntax
integer x = 1861
integer y = 1044
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


popup.data_row_count = arguments.argument_count
for i = 1 to arguments.argument_count
	popup.items[i] = arguments.argument[i].argument_name + "  " + arguments.argument[i].argument_type
next

openwithparm(w_pop_pick, popup)

end event

type cb_pick from commandbutton within u_param_datawindow_syntax
integer x = 2546
integer y = 948
integer width = 119
integer height = 96
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;pick_param()

end event

