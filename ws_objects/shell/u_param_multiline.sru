HA$PBExportHeader$u_param_multiline.sru
forward
global type u_param_multiline from u_param_base
end type
type mle_string from multilineedit within u_param_multiline
end type
type cb_picklist from commandbutton within u_param_multiline
end type
end forward

global type u_param_multiline from u_param_base
mle_string mle_string
cb_picklist cb_picklist
end type
global u_param_multiline u_param_multiline

forward prototypes
public function integer check_required ()
public function integer x_initialize ()
public function integer pick_param ()
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
	If Isnull(mle_string.text) Or Len(mle_string.text) = 0 Then
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

ls_intitial_value = get_initial_value(1)

If trim(ls_intitial_value) <> "" and not isnull(ls_intitial_value) and not preference_in_use Then
	mle_string.text = ls_intitial_value
Else
	mle_string.text = ""
end if

mle_string.function POST setfocus()

return 1

end function

public function integer pick_param ();str_popup popup
str_popup_return popup_return
string ls_text

popup.title = "Select " + st_title.text
popup.data_row_count = 2
popup.items[1] = "PARAM|" + param_wizard.params.params[param_index].token1
popup.items[2] = mle_string.selectedtext()
if isnull(popup.items[2]) or popup.items[2] = "" then
	popup.items[2] = mle_string.text
end if
openwithparm(w_pick_top_20_multiline, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

if len(mle_string.selectedtext()) > 0 then
	mle_string.replacetext(popup_return.items[1])
else
	mle_string.text = popup_return.items[1]
end if

if isnull(mle_string.text) or trim(mle_string.text) = "" then
	setnull(ls_text)
else
	ls_text = mle_string.text
end if

update_param(param_wizard.params.params[param_index].token1, ls_text)

if st_required.visible and not isnull(ls_text) then
	param_wizard.event POST ue_required(true)
end if

mle_string.setfocus()

return 1

end function

on u_param_multiline.create
int iCurrent
call super::create
this.mle_string=create mle_string
this.cb_picklist=create cb_picklist
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.mle_string
this.Control[iCurrent+2]=this.cb_picklist
end on

on u_param_multiline.destroy
call super::destroy
destroy(this.mle_string)
destroy(this.cb_picklist)
end on

type st_preference from u_param_base`st_preference within u_param_multiline
end type

type st_preference_title from u_param_base`st_preference_title within u_param_multiline
end type

type cb_clear from u_param_base`cb_clear within u_param_multiline
integer y = 988
integer taborder = 30
end type

event cb_clear::clicked;call super::clicked;mle_string.text = ""

f_attribute_remove_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				param_wizard.params.id )


end event

type st_required from u_param_base`st_required within u_param_multiline
integer x = 1358
integer y = 424
end type

type st_helptext from u_param_base`st_helptext within u_param_multiline
end type

type st_title from u_param_base`st_title within u_param_multiline
integer y = 480
end type

type mle_string from multilineedit within u_param_multiline
integer x = 1349
integer y = 476
integer width = 1184
integer height = 488
integer taborder = 10
boolean bringtotop = true
integer textsize = -11
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
boolean autovscroll = true
borderstyle borderstyle = stylelowered!
boolean ignoredefaultbutton = true
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

type cb_picklist from commandbutton within u_param_multiline
integer x = 2546
integer y = 868
integer width = 119
integer height = 100
integer taborder = 20
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
popup.items[2] = mle_string.selectedtext()
if isnull(popup.items[2]) or popup.items[2] = "" then
	popup.items[2] = mle_string.text
end if
openwithparm(w_pick_top_20_multiline, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if len(mle_string.selectedtext()) > 0 then
	mle_string.replacetext(popup_return.items[1])
else
	mle_string.text = popup_return.items[1]
end if

if isnull(mle_string.text) or trim(mle_string.text) = "" then
	setnull(ls_text)
else
	ls_text = mle_string.text
end if

f_attribute_add_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				ls_text, &
				param_wizard.params.id)

if st_required.visible and not isnull(ls_text) then
	param_wizard.event POST ue_required(true)
end if

mle_string.setfocus()

end event

