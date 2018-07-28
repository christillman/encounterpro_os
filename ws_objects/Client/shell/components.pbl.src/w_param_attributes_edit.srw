$PBExportHeader$w_param_attributes_edit.srw
forward
global type w_param_attributes_edit from w_param_base
end type
type st_no_params from statictext within w_param_attributes_edit
end type
type cb_cancel from commandbutton within w_param_attributes_edit
end type
type cb_finished from commandbutton within w_param_attributes_edit
end type
type st_param_list from statictext within w_param_attributes_edit
end type
type dw_attributes from u_dw_params_edit within w_param_attributes_edit
end type
type st_title from statictext within w_param_attributes_edit
end type
end forward

global type w_param_attributes_edit from w_param_base
integer x = 0
integer y = 0
integer width = 2962
integer height = 1864
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
event ue_required ( boolean pb_enable )
st_no_params st_no_params
cb_cancel cb_cancel
cb_finished cb_finished
st_param_list st_param_list
dw_attributes dw_attributes
st_title st_title
end type
global w_param_attributes_edit w_param_attributes_edit

type variables

string param_id

string param_mode


end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();integer li_sts

li_sts = dw_attributes.load_params( param_id , param_mode, attributes)


return li_sts


end function

on w_param_attributes_edit.create
int iCurrent
call super::create
this.st_no_params=create st_no_params
this.cb_cancel=create cb_cancel
this.cb_finished=create cb_finished
this.st_param_list=create st_param_list
this.dw_attributes=create dw_attributes
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_no_params
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cb_finished
this.Control[iCurrent+4]=this.st_param_list
this.Control[iCurrent+5]=this.dw_attributes
this.Control[iCurrent+6]=this.st_title
end on

on w_param_attributes_edit.destroy
call super::destroy
destroy(this.st_no_params)
destroy(this.cb_cancel)
destroy(this.cb_finished)
destroy(this.st_param_list)
destroy(this.dw_attributes)
destroy(this.st_title)
end on

event open;call super::open;//////////////////////////////////////////////////////////////////////////////////////
//
// Description:Open the respective attribute class type and get attribute value
//
// Created By:Sumathi Chinnasamy										Creation dt: 10/05/99
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////
integer i
integer li_sts
str_param_wizard_attributes lstr_wizard
str_param_wizard_return lstr_return

// get the message object parm
lstr_wizard = Message.Powerobjectparm
param_mode = lstr_wizard.param_mode
param_id = lstr_wizard.id
state_attributes = lstr_wizard.state_attributes
attributes = lstr_wizard.param_attributes

// If we're in config mode then display the config buttons
if config_mode then
	st_param_list.visible = true
else
	st_param_list.visible = false
end if

refresh()

end event

event resize;call super::resize;
st_title.width = width
dw_attributes.width = width

st_param_list.x = (width - st_param_list.width) / 2
cb_finished.x = width - 425

end event

type pb_epro_help from w_param_base`pb_epro_help within w_param_attributes_edit
integer x = 498
integer y = 1684
boolean originalsize = false
end type

type st_config_mode_menu from w_param_base`st_config_mode_menu within w_param_attributes_edit
integer x = 59
integer y = 1496
end type

type st_no_params from statictext within w_param_attributes_edit
boolean visible = false
integer x = 517
integer y = 424
integer width = 1664
integer height = 220
integer textsize = -24
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "No Parameters Defined"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_param_attributes_edit
integer x = 41
integer y = 1656
integer width = 370
integer height = 132
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = roman!
string facename = "MS Serif"
string text = "&Cancel"
end type

event clicked;//////////////////////////////////////////////////////////////////////////////////////
//
// Description: Set the param count as negative if user cancel the operation
//
// Created By:Sumathi Chinnasamy										Creation dt: 10/05/99
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////
str_param_wizard_return lstr_return

// If the user cancels then return -1
lstr_return.return_status = -1
Closewithreturn(parent,lstr_return)


end event

type cb_finished from commandbutton within w_param_attributes_edit
integer x = 2501
integer y = 1656
integer width = 370
integer height = 132
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = roman!
string facename = "MS Serif"
string text = "&Finished"
end type

event clicked;//////////////////////////////////////////////////////////////////////////////////////
//
// Description:get the attribute value
//
// Created By:Sumathi Chinnasamy										Creation dt: 10/05/99
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////
integer li_sts
str_param_wizard_return lstr_return

// If we have no params then just return
if params.param_count <= 0 then
	lstr_return.return_status = 0
	Closewithreturn(Parent, lstr_return)
	Return 1
end if

lstr_return.return_status = 1
lstr_return.attributes = attributes
Closewithreturn(Parent, lstr_return)
Return 1

end event

type st_param_list from statictext within w_param_attributes_edit
integer x = 827
integer y = 1568
integer width = 1239
integer height = 220
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
integer li_sts

popup.data_row_count = 2
popup.items[1] = param_id
popup.items[2] = param_mode

openwithparm(w_component_params_edit, popup)


refresh()

end event

type dw_attributes from u_dw_params_edit within w_param_attributes_edit
integer y = 188
integer width = 2921
integer height = 1384
integer taborder = 20
boolean bringtotop = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

type st_title from statictext within w_param_attributes_edit
integer width = 2926
integer height = 180
boolean bringtotop = true
integer textsize = -16
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33536444
string text = "Params Title"
alignment alignment = center!
boolean focusrectangle = false
end type

