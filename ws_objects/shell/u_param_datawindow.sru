HA$PBExportHeader$u_param_datawindow.sru
forward
global type u_param_datawindow from u_param_base
end type
type st_argument_count_title from statictext within u_param_datawindow
end type
type st_argument_count from statictext within u_param_datawindow
end type
type st_dataobject from statictext within u_param_datawindow
end type
type st_component_title from statictext within u_param_datawindow
end type
type st_component from statictext within u_param_datawindow
end type
type dw_preview from u_dw_display within u_param_datawindow
end type
end forward

global type u_param_datawindow from u_param_base
st_argument_count_title st_argument_count_title
st_argument_count st_argument_count
st_dataobject st_dataobject
st_component_title st_component_title
st_component st_component
dw_preview dw_preview
end type
global u_param_datawindow u_param_datawindow

type variables
string dataobject

str_datawindow_arguments arguments


end variables

forward prototypes
public function integer check_required ()
public function integer x_initialize ()
public function integer pick_param ()
public function integer show_dataobject ()
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
	If Isnull(dataobject) Or Len(dataobject) = 0 Then
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
	dataobject = ls_intitial_value
Else
	setnull(dataobject)
end if

show_dataobject()


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
str_pblibraries lstr_pblibraries
str_pblibrary lstr_pblibrary
string ls_dataobject
string ls_list
string lsa_lines[]
long ll_line_count
string lsa_fields[]
long ll_field_count
string lsa_datawindows[]
long ll_datawindow_count
integer li_index

ls_new_script = ""
ls_new_script_name = ""

lstr_pblibraries = common_thread.installed_libraries()

popup.title = "PowerBuilder Library"
popup.data_row_count = lstr_pblibraries.pblibrary_count
for i = 1 to lstr_pblibraries.pblibrary_count
	popup.items[i] = lstr_pblibraries.pblibrary[i].component_description + " (" + lstr_pblibraries.pblibrary[i].compile_name + ")"
next
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

lstr_pblibrary =  lstr_pblibraries.pblibrary[popup_return.item_indexes[1]]

// Now get the desired datawindow from the library

ls_list = librarydirectory(lstr_pblibrary.path, DirDataWindow!)
if isnull(ls_list) or ls_list = "" then
	openwithparm(w_pop_message, "The selected library contains no datawindows")
	return 0
end if

ll_line_count = f_parse_string(ls_list, "~n", lsa_lines)
if ll_line_count <= 0 then
	openwithparm(w_pop_message, "The selected library contains no datawindows")
	return 0
end if

for i = 1 to ll_line_count
	ll_field_count = f_parse_string(lsa_lines[i], "~t", lsa_fields)
	if ll_field_count >= 1 then
		ll_datawindow_count++
		lsa_datawindows[ll_datawindow_count] = lsa_fields[1]
	end if
next

popup.data_row_count = ll_datawindow_count
popup.items = lsa_datawindows
popup.title = "Select Datawindow"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

dataobject = lstr_pblibrary.component_id + "|" + popup_return.items[1]

show_dataobject()

update_param(param_wizard.params.params[param_index].token1, dataobject)

if st_required.visible and not isnull(dataobject) then
	param_wizard.event POST ue_required(true)
end if

return 1

end function

public function integer show_dataobject ();integer li_sts
string ls_error
string ls_syntax
string ls_dataobject
string ls_component_id
str_component_definition lstr_component

if len(dataobject) > 0 then
	f_split_string(dataobject, "|", ls_component_id, ls_dataobject)
	if ls_dataobject = "" then
		ls_dataobject = ls_component_id
		ls_component_id = ""
		st_component.text = ls_component_id
	else
		lstr_component = f_get_component_definition(ls_component_id)
		st_component.text = lstr_component.description
	end if
	st_dataobject.text = ls_dataobject
	

	TRY
		dw_preview.dataobject = ls_dataobject
		ls_syntax = dw_preview.object.datawindow.syntax
		
		arguments = f_get_datawindow_arguments(ls_syntax)
		st_argument_count.text = string(arguments.argument_count)
		if arguments.argument_count > 0 then
			st_argument_count.borderstyle = styleraised!
		else
			st_argument_count.borderstyle = stylebox!
		end if
	CATCH (throwable lt_error)
		log.log(this, "add_image()", "Error getting datawindow syntax (" + ls_dataobject + ")~r~n" + lt_error.text, 4)
		st_argument_count.text = "Unknown"
		st_argument_count.borderstyle = stylebox!
	END TRY
	
else
	st_component.text = ""
	st_dataobject.text = ""
	st_argument_count.text = ""
	st_argument_count.borderstyle = stylebox!
end if

return 1

end function

on u_param_datawindow.create
int iCurrent
call super::create
this.st_argument_count_title=create st_argument_count_title
this.st_argument_count=create st_argument_count
this.st_dataobject=create st_dataobject
this.st_component_title=create st_component_title
this.st_component=create st_component
this.dw_preview=create dw_preview
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_argument_count_title
this.Control[iCurrent+2]=this.st_argument_count
this.Control[iCurrent+3]=this.st_dataobject
this.Control[iCurrent+4]=this.st_component_title
this.Control[iCurrent+5]=this.st_component
this.Control[iCurrent+6]=this.dw_preview
end on

on u_param_datawindow.destroy
call super::destroy
destroy(this.st_argument_count_title)
destroy(this.st_argument_count)
destroy(this.st_dataobject)
destroy(this.st_component_title)
destroy(this.st_component)
destroy(this.dw_preview)
end on

type st_preference from u_param_base`st_preference within u_param_datawindow
integer x = 14
integer y = 1028
end type

type st_preference_title from u_param_base`st_preference_title within u_param_datawindow
integer x = 14
integer y = 960
end type

type cb_clear from u_param_base`cb_clear within u_param_datawindow
integer x = 2263
integer y = 992
integer taborder = 30
end type

event cb_clear::clicked;call super::clicked;setnull(dataobject)
dw_preview.reset()

f_attribute_remove_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				param_wizard.params.id )


end event

type st_required from u_param_base`st_required within u_param_datawindow
integer x = 1358
integer y = 584
end type

type st_helptext from u_param_base`st_helptext within u_param_datawindow
end type

type st_title from u_param_base`st_title within u_param_datawindow
integer y = 640
end type

type st_argument_count_title from statictext within u_param_datawindow
integer x = 1353
integer y = 772
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

type st_argument_count from statictext within u_param_datawindow
integer x = 1833
integer y = 764
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

type st_dataobject from statictext within u_param_datawindow
integer x = 1344
integer y = 636
integer width = 1275
integer height = 116
boolean bringtotop = true
integer textsize = -10
integer weight = 400
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

event clicked;pick_param()
end event

type st_component_title from statictext within u_param_datawindow
integer x = 727
integer y = 488
integer width = 590
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
string text = "Library Component:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_component from statictext within u_param_datawindow
integer x = 1339
integer y = 472
integer width = 1275
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
string text = "none"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type dw_preview from u_dw_display within u_param_datawindow
boolean visible = false
integer x = 1317
integer y = 444
integer width = 1362
integer height = 668
integer taborder = 10
end type

