$PBExportHeader$w_param_setting.srw
forward
global type w_param_setting from w_param_base
end type
type cb_finished from commandbutton within w_param_setting
end type
type cb_cancel from commandbutton within w_param_setting
end type
end forward

global type w_param_setting from w_param_base
cb_finished cb_finished
cb_cancel cb_cancel
end type
global w_param_setting w_param_setting

type variables
u_param_base param_object

long obj_x = 18
long obj_y = 28


end variables

forward prototypes
public function integer initialize ()
end prototypes

public function integer initialize ();long i
integer li_sts


// If there aren't any params then we're done
if params.param_count = 0 Then return 0

li_sts = OpenUserObject(param_object, &
						params.params[1].param_class,&
						obj_x, &
						obj_y)
if li_sts < 0 then
	log.log(This,"w_param_setting.initialize:0013","Unable to create param class for "+&
					params.params[1].param_class,4)
	Return -1
End If

param_object.initialize(this, i)

param_object.setfocus()

return 1

end function

on w_param_setting.create
int iCurrent
call super::create
this.cb_finished=create cb_finished
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_finished
this.Control[iCurrent+2]=this.cb_cancel
end on

on w_param_setting.destroy
call super::destroy
destroy(this.cb_finished)
destroy(this.cb_cancel)
end on

event open;//////////////////////////////////////////////////////////////////////////////////////
//
// Description:Open the respective attribute class type and get attribute value
//
// Created By:Sumathi Chinnasamy										Creation dt: 10/05/99
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////
integer li_sts
str_param_setting lstr_param
str_param_wizard_return lstr_return
string ls_value

// get the message object parm
lstr_param = Message.Powerobjectparm

params.param_count = 1
params.params[1] = lstr_param.param

state_attributes = lstr_param.attributes

allow_preference = false

ls_value = f_attribute_find_attribute(state_attributes, params.params[1].token1)
if len(ls_value) > 0 then
	f_attribute_add_attribute(attributes, params.params[1].token1, ls_value)
end if

li_sts = OpenUserObject(param_object, &
						params.params[1].param_class,&
						obj_x, &
						obj_y)
if li_sts < 0 then
	log.log(This,"w_param_setting:open","Unable to create param class for "+&
					params.params[1].param_class,4)
	lstr_return.return_status = -1
	closewithreturn(this, lstr_return)
	return
End If

param_object.initialize(this, 1)

if lstr_param.invisible_wizard then
	visible = false
	li_sts = param_object.pick_param()
	if li_sts <= 0 then
		// If the user cancel the print
		lstr_return.return_status = -1
	else
		lstr_return.return_status = 1
		lstr_return.attributes = attributes
	end if
	
	Closewithreturn(this, lstr_return)
	return
else
	param_object.setfocus()
end if




end event

event close;call super::close;if isvalid(param_object) and not isnull(param_object) then
	CloseUserObject(param_object)
end if


end event

event ue_required;call super::ue_required;cb_finished.Enabled = pb_enable

end event

type pb_epro_help from w_param_base`pb_epro_help within w_param_setting
end type

type st_config_mode_menu from w_param_base`st_config_mode_menu within w_param_setting
end type

type cb_finished from commandbutton within w_param_setting
integer x = 2240
integer y = 1252
integer width = 370
integer height = 132
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = roman!
string facename = "MS Serif"
string text = "&Finished"
end type

event clicked;str_param_wizard_return lstr_return


lstr_return.return_status = 1
lstr_return.attributes = attributes
Closewithreturn(Parent, lstr_return)
Return 1

end event

type cb_cancel from commandbutton within w_param_setting
integer x = 1696
integer y = 1252
integer width = 370
integer height = 132
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = roman!
string facename = "MS Serif"
string text = "&Cancel"
end type

event clicked;str_param_wizard_return lstr_return

// If the user cancel the print
lstr_return.return_status = -1
Closewithreturn(parent,lstr_return)


end event

