HA$PBExportHeader$w_param_wizard.srw
forward
global type w_param_wizard from w_param_base
end type
type st_no_params from statictext within w_param_wizard
end type
type cb_cancel from commandbutton within w_param_wizard
end type
type cb_next from commandbutton within w_param_wizard
end type
type cb_back from commandbutton within w_param_wizard
end type
type st_param_list from statictext within w_param_wizard
end type
end forward

global type w_param_wizard from w_param_base
integer width = 2853
integer height = 1524
st_no_params st_no_params
cb_cancel cb_cancel
cb_next cb_next
cb_back cb_back
st_param_list st_param_list
end type
global w_param_wizard w_param_wizard

type variables
//u_param_base open_obj[]
//integer obj_count = 0
//integer current_index

long obj_x = 18
long obj_y = 28

long nesting_level = 0
string param_id[]
integer current_index[]
boolean parent_on_last_param[]
string param_mode

u_param_base param_object

boolean exiting_nested_params = false


end variables

forward prototypes
public subroutine set_buttons ()
public function integer remove_nested_param_level ()
public subroutine activate_param (boolean pb_forward)
public function integer add_nested_param_level (string ps_id, boolean pb_forward)
end prototypes

public subroutine set_buttons ();long ll_count

if current_index[nesting_level] = params.param_count &
	and parent_on_last_param[nesting_level] then
	if isnull(param_object.nested_param_id) then
		// We have no nested param object so this is the last param
		cb_next.text = "Finish"
	else
		// We have a nested param object so we need to determine if the nested param object has params
		SELECT count(*)
		INTO :ll_count
		FROM c_Component_Param  
		WHERE id = :param_object.nested_param_id
		AND param_mode = :param_mode;
		if not tf_check() then return
		if ll_count > 0 or config_mode then
			cb_next.text = "Next"
		else
			cb_next.text = "Finish"
		end if
	end if
else
	cb_next.text = "Next"
end if

if current_index[nesting_level] = 1 and nesting_level = 1 then
	cb_back.enabled = false
else
	cb_back.enabled = true
end if

st_param_list.text = params.params[current_index[nesting_level]].config_object_description
st_param_list.text += "~n" + param_id[nesting_level]
st_param_list.text += "~n" + param_mode

end subroutine

public function integer remove_nested_param_level ();str_params lstr_params
integer li_sts

if nesting_level = 1 then return 0

// Get the new params list
lstr_params = f_get_component_params(param_id[nesting_level - 1], param_mode)
if lstr_params.param_count < 0 then return -1
//lstr_params.id = param_id[nesting_level - 1]
//lstr_params.param_mode = param_mode
//li_sts = f_get_param_list(lstr_params)
//if li_sts < 0 then return -1

// If we have no params then return zero
if lstr_params.param_count <= 0 then return 0

nesting_level -= 1

params = lstr_params

exiting_nested_params = true

return 1

end function

public subroutine activate_param (boolean pb_forward);integer li_sts
u_param_base lo_old_param
u_param_base lo_new_param
boolean lb_exiting_nested_params

// Copy the exiting-nested flag and set it to false.  This makes sure
// that nested calls to activate_param() don't see this flag unless it's set again
lb_exiting_nested_params = exiting_nested_params
exiting_nested_params = false

li_sts = OpenUserObject(lo_new_param, &
						params.params[current_index[nesting_level]].param_class,&
						obj_x, &
						obj_y)
if li_sts < 0 then
	log.log(This,"Open","Unable to create param class for "+&
					params.params[current_index[nesting_level]].param_class,4)
	Return
End If

lo_old_param = param_object
param_object = lo_new_param
param_object.initialize(this, current_index[nesting_level])

if isvalid(lo_old_param) and not isnull(lo_old_param) then
	CloseUserObject(lo_old_param)
end if

if not pb_forward and not lb_exiting_nested_params then
	// If the previous param has nested params, drop into them
	if len(param_object.nested_param_id) > 0 then
		// There are nested params so drop into the nested params
		li_sts = add_nested_param_level(param_object.nested_param_id, pb_forward)
		if li_sts > 0 then
			activate_param(pb_forward)
			return
		end if
	end if
end if


param_object.setfocus()

set_buttons()

end subroutine

public function integer add_nested_param_level (string ps_id, boolean pb_forward);integer li_sts
str_params lstr_params


// Get the new params list
lstr_params = f_get_component_params(ps_id, param_mode)
if lstr_params.param_count < 0 then return -1
//lstr_params.id = ps_id
//lstr_params.param_mode = param_mode
//li_sts = f_get_param_list(lstr_params)
//if li_sts < 0 then return -1

// If we have no params and we're not in config mode then exit
if lstr_params.param_count <= 0 then return 0

nesting_level += 1
param_id[nesting_level] = ps_id
if pb_forward then
	// If we're going backwards then start at then beginning of the nested param list
	current_index[nesting_level] = 1
else
	// If we're going backwards then start at then end of the nested param list
	current_index[nesting_level] = lstr_params.param_count
end if

// keep track of the whether the parent params are all on their last param
if nesting_level > 1 then
	if current_index[nesting_level - 1] = params.param_count &
	  and parent_on_last_param[nesting_level - 1] then
		parent_on_last_param[nesting_level] = true
	else
		parent_on_last_param[nesting_level] = false
	end if
else
	parent_on_last_param[nesting_level] = true
end if

params = lstr_params

return 1

end function

on w_param_wizard.create
int iCurrent
call super::create
this.st_no_params=create st_no_params
this.cb_cancel=create cb_cancel
this.cb_next=create cb_next
this.cb_back=create cb_back
this.st_param_list=create st_param_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_no_params
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cb_next
this.Control[iCurrent+4]=this.cb_back
this.Control[iCurrent+5]=this.st_param_list
end on

on w_param_wizard.destroy
call super::destroy
destroy(this.st_no_params)
destroy(this.cb_cancel)
destroy(this.cb_next)
destroy(this.cb_back)
destroy(this.st_param_list)
end on

event open;//////////////////////////////////////////////////////////////////////////////////////
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
state_attributes = lstr_wizard.state_attributes
attributes = lstr_wizard.param_attributes
allow_preference = lstr_wizard.allow_preference

// If we're in server mode then don't bother trying to get any input from the user
if cpr_mode = "SERVER" then
	lstr_return.return_status = 0
	closewithreturn(this, lstr_return)
	return
end if


// move the wizard
x = main_window.x + ((main_window.width - width) / 2)
y = main_window.y + ((main_window.height - height) / 2)

// Initialize the 1st param
li_sts = add_nested_param_level(lstr_wizard.id, true)
if li_sts < 0 then
	log.log(this, "open", "Error initializing params", 4)
	lstr_return.return_status = -1
	closewithreturn(this, lstr_return)
	return
end if

// If we have no params and we're not in config mode then exit
if li_sts = 0 then
	lstr_return.return_status = 0
	closewithreturn(this, lstr_return)
	return
end if

// If we're in config mode then display the config buttons
if config_mode then
	st_param_list.visible = true
else
	st_param_list.visible = false
end if


activate_param(true)

end event

event close;call super::close;if isvalid(param_object) and not isnull(param_object) then
	CloseUserObject(param_object)
end if


end event

event ue_required;call super::ue_required;cb_next.Enabled = pb_enable

end event

type pb_epro_help from w_param_base`pb_epro_help within w_param_wizard
integer width = 256
integer height = 128
end type

type st_config_mode_menu from w_param_base`st_config_mode_menu within w_param_wizard
end type

type st_no_params from statictext within w_param_wizard
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

type cb_cancel from commandbutton within w_param_wizard
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

type cb_next from commandbutton within w_param_wizard
integer x = 1801
integer y = 1252
integer width = 370
integer height = 132
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = roman!
string facename = "MS Serif"
string text = "&Next"
boolean default = true
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
long ll_count

// If we have no params then just return
if params.param_count <= 0 then
	lstr_return.return_status = 0
	Closewithreturn(Parent, lstr_return)
	Return 1
end if

// validate param required
If param_object.check_required() < 0 Then return

// get the report attribute value
//open_obj[current_index[nesting_level]].set_values(rpt_params,current_index[nesting_level])

// If this is really the last param, then exit
if current_index[nesting_level] = params.param_count &
	and parent_on_last_param[nesting_level] then
	if isnull(param_object.nested_param_id) then
		// We have no nested param object so this is the last param
		lstr_return.return_status = 1
		lstr_return.attributes = attributes
		Closewithreturn(Parent, lstr_return)
		Return 1
	else
		// We have a nested param object so we need to determine if the nested param object has params
		SELECT count(*)
		INTO :ll_count
		FROM c_Component_Param  
		WHERE id = :param_object.nested_param_id
		AND param_mode = :param_mode;
		if not tf_check() then return
		if ll_count = 0 and not config_mode then
			lstr_return.return_status = 1
			lstr_return.attributes = attributes
			Closewithreturn(Parent, lstr_return)
			Return 1
		end if
	end if
End If

if len(param_object.nested_param_id) > 0 then
	// There are nested params so drop into the nested params
	li_sts = add_nested_param_level(param_object.nested_param_id, true)
else
	// "0" means that there are no nested params to dive into, so go to the next param at this level
	li_sts = 0
end if
if li_sts = 0 then
	// Climb out of any nested params where we're already at the end
	DO WHILE nesting_level > 1 and current_index[nesting_level] = params.param_count
		// back up one level
		li_sts = remove_nested_param_level()
	LOOP
	
	if nesting_level = 1 and current_index[nesting_level] = params.param_count then
		// We climbed up out of the nested params and found that we're already at the last param
		lstr_return.return_status = 1
		lstr_return.attributes = attributes
		Closewithreturn(Parent, lstr_return)
		Return 1
	end if
	current_index[nesting_level]++
end if

activate_param(true)

end event

type cb_back from commandbutton within w_param_wizard
integer x = 1367
integer y = 1252
integer width = 370
integer height = 132
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = roman!
string facename = "MS Serif"
boolean enabled = false
string text = "&Back"
end type

event clicked;//////////////////////////////////////////////////////////////////////////////////////
//
// Description:get the attribute value
//
// Created By:Sumathi Chinnasamy										Creation dt: 10/05/99
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

// get the attribute values
//open_obj.set_values(rpt_params,current_index[nesting_level])
integer li_sts

// If we're at the beginning, then go up a nested level
if current_index[nesting_level] = 1 then
	// If we're at the beginning of this param list, then go up a nested level
	li_sts = remove_nested_param_level()
	if li_sts <= 0 then return
else
	// Go to the previous param
	current_index[nesting_level] -= 1
end if

activate_param(false)


end event

type st_param_list from statictext within w_param_wizard
integer x = 64
integer y = 1236
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
popup.items[1] = params.id
popup.items[2] = params.param_mode

openwithparm(w_component_params_edit, popup)

// Reopen all the objects to pick up the changes
params = f_get_component_params(params.id, params.param_mode)
if params.param_count < 0 then return -1

//li_sts = f_get_param_list(params)
//open_param_objects(params)

// Since the objects might have changed, restart the wizard from the first param
current_index[nesting_level] = 1

activate_param(true)

end event

