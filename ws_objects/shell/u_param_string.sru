HA$PBExportHeader$u_param_string.sru
forward
global type u_param_string from u_param_base
end type
type sle_string from singlelineedit within u_param_string
end type
type cb_picklist from commandbutton within u_param_string
end type
end forward

global type u_param_string from u_param_base
sle_string sle_string
cb_picklist cb_picklist
end type
global u_param_string u_param_string

forward prototypes
public function integer x_initialize ()
public function integer check_required ()
public function integer pick_param ()
end prototypes

public function integer x_initialize ();//////////////////////////////////////////////////////////////////////////////////////
//
//	Return: Integer
//
// Description:If no values defined then initialize the fields with initial values
//
// Created By:Sumathi Chinnasamy										Creation dt: 10/05/99
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////
string ls_intitial_value

ls_intitial_value = get_initial_value(1)

If trim(ls_intitial_value) <> "" and not isnull(ls_intitial_value) and not preference_in_use Then
	sle_string.text = ls_intitial_value
Else
	sle_string.text = ""
end if

sle_string.function POST setfocus( )

return 1

end function

public function integer check_required ();//////////////////////////////////////////////////////////////////////////////////////
//
//	Return: Integer [ -1 - required column missing  1 - validation success
//
//	Description: validates whether it's required column
//
// Created By:Sumathi Chinnasamy										Creation dt: 10/11/99
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////
if upper(param_wizard.params.params[param_index].required_flag) = "Y" then
	If Isnull(sle_string.text) Or Len(sle_string.text) = 0 Then
		Openwithparm(w_pop_message,"Please enter a " + st_title.text)
		Return -1
	End if
End If

Return 1
end function

public function integer pick_param ();str_popup popup
str_popup_return popup_return
string ls_text

popup.title = "Select " + st_title.text
popup.data_row_count = 2
popup.items[1] = "PARAM|" + param_wizard.params.params[param_index].token1
popup.items[2] = ""
openwithparm(w_pick_top_20_multiline, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

sle_string.replacetext(popup_return.items[1])

if isnull(sle_string.text) or trim(sle_string.text) = "" then
	setnull(ls_text)
else
	ls_text = sle_string.text
end if

update_param(param_wizard.params.params[param_index].token1, ls_text)

if st_required.visible and not isnull(ls_text) then
	param_wizard.event POST ue_required(true)
end if

sle_string.setfocus()

return 1

end function

on u_param_string.create
int iCurrent
call super::create
this.sle_string=create sle_string
this.cb_picklist=create cb_picklist
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_string
this.Control[iCurrent+2]=this.cb_picklist
end on

on u_param_string.destroy
call super::destroy
destroy(this.sle_string)
destroy(this.cb_picklist)
end on

type st_preference from u_param_base`st_preference within u_param_string
end type

type st_preference_title from u_param_base`st_preference_title within u_param_string
end type

type cb_clear from u_param_base`cb_clear within u_param_string
integer taborder = 20
end type

event cb_clear::clicked;call super::clicked;sle_string.text = ""
f_attribute_remove_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				param_wizard.params.id )


end event

type st_required from u_param_base`st_required within u_param_string
integer x = 1358
integer y = 532
end type

type st_helptext from u_param_base`st_helptext within u_param_string
end type

type st_title from u_param_base`st_title within u_param_string
integer x = 27
integer y = 584
end type

type sle_string from singlelineedit within u_param_string
integer x = 1344
integer y = 580
integer width = 1198
integer height = 108
integer taborder = 10
boolean bringtotop = true
integer textsize = -11
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 255
borderstyle borderstyle = stylelowered!
end type

event modified;string ls_text

if isnull(text) or trim(text) = "" then
	setnull(ls_text)
else
	ls_text = text
end if

f_attribute_add_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				ls_text, &
				param_wizard.params.id )

if st_required.visible and not isnull(ls_text) then
	param_wizard.event POST ue_required(true)
end if

end event

type cb_picklist from commandbutton within u_param_string
integer x = 2560
integer y = 592
integer width = 119
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_text

popup.title = "Select " + st_title.text
popup.data_row_count = 2
popup.items[1] = "PARAM|" + param_wizard.params.params[param_index].token1
popup.items[2] = ""
openwithparm(w_pick_top_20_multiline, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

sle_string.replacetext(popup_return.items[1])

if isnull(sle_string.text) or trim(sle_string.text) = "" then
	setnull(ls_text)
else
	ls_text = sle_string.text
end if

f_attribute_add_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				ls_text, &
				param_wizard.params.id)

if st_required.visible and not isnull(ls_text) then
	param_wizard.event POST ue_required(true)
end if

sle_string.setfocus()

end event

