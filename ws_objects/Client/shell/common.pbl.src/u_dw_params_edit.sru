$PBExportHeader$u_dw_params_edit.sru
forward
global type u_dw_params_edit from datawindow
end type
end forward

global type u_dw_params_edit from datawindow
integer width = 3173
integer height = 1704
string title = "none"
string dataobject = "dw_param_list"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type
global u_dw_params_edit u_dw_params_edit

type variables
str_attributes attributes

end variables

forward prototypes
public function integer load_params (string ps_id, string ps_param_mode, str_attributes pstr_attributes)
end prototypes

public function integer load_params (string ps_id, string ps_param_mode, str_attributes pstr_attributes);long ll_rows
long i
string ls_attribute
string ls_value
string ls_display_value

attributes = pstr_attributes

object.param_title.width = int(width * 0.45)
object.compute_value.width = width - int(width * 0.45) - 100
object.l_1.x2 = width - 108

settransobject(sqlca)
ll_rows = retrieve(ps_id, ps_param_mode)
if ll_rows < 0 then return -1

for i = 1 to ll_rows
	ls_attribute = object.token1[i]
	ls_value = f_attribute_find_attribute(attributes, ls_attribute)
	ls_display_value = sqlca.fn_attribute_description( ls_attribute, ls_value)
	object.attribute_value[i] = ls_display_value
next

end function

on u_dw_params_edit.create
end on

on u_dw_params_edit.destroy
end on

event clicked;str_param_setting lstr_param
str_param_wizard_return lstr_return
string ls_preference_value
string ls_flag
string ls_encrypted
string ls_preference_enc
string ls_attribute
string ls_value
string ls_display_value
w_param_setting lw_param_window

lstr_param.param.param_class = object.param_class[row]
lstr_param.param.param_title = object.param_title[row]
lstr_param.param.token1 = object.token1[row]
lstr_param.param.helptext = object.helptext[row]
lstr_param.param.query = object.query[row]
lstr_param.param.required_flag = object.required_flag[row]
lstr_param.attributes = attributes

openwithparm(lw_param_window, lstr_param, "w_param_setting")
lstr_return = message.powerobjectparm
if lstr_return.return_status <= 0 then return

ls_attribute = object.token1[row]
ls_value = f_attribute_find_attribute(lstr_return.attributes, ls_attribute)
ls_display_value = sqlca.fn_attribute_description( ls_attribute, ls_value)
object.attribute_value[row] = ls_display_value




//
//// If we need to encrypt the value, do it here
//if not isnull(ls_preference_value) then
//	ls_encrypted = object.encrypted[row]
//	if ls_encrypted = "Y" then
//		ls_preference_enc = common_thread.eprolibnet4.encryptstring(ls_preference_value, common_thread.key())
//		if len(ls_preference_enc) > 0 then
//			ls_preference_value = ls_preference_enc
//		else
//			log.log(this, "selected", "Error encrypting value", 4)
//			return
//		end if
//	end if
//end if
//
//datalist.update_preference( preference_type, &
//									preference_level, &
//									preference_key, &
//									lstr_param.param.token1, &
//									ls_preference_value)
//
//clear_selected()
//refresh()
//
//
end event

