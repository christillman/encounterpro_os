$PBExportHeader$w_component_params_edit.srw
forward
global type w_component_params_edit from w_window_base
end type
type cb_ok from commandbutton within w_component_params_edit
end type
type cb_cancel from commandbutton within w_component_params_edit
end type
type st_id from statictext within w_component_params_edit
end type
type st_param_mode from statictext within w_component_params_edit
end type
type cb_new from commandbutton within w_component_params_edit
end type
type cb_delete from commandbutton within w_component_params_edit
end type
type cb_update from commandbutton within w_component_params_edit
end type
type dw_params from datawindow within w_component_params_edit
end type
type cb_copy_from from commandbutton within w_component_params_edit
end type
type st_object_description from statictext within w_component_params_edit
end type
end forward

global type w_component_params_edit from w_window_base
integer width = 3511
integer height = 1956
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
windowstate windowstate = maximized!
cb_ok cb_ok
cb_cancel cb_cancel
st_id st_id
st_param_mode st_param_mode
cb_new cb_new
cb_delete cb_delete
cb_update cb_update
dw_params dw_params
cb_copy_from cb_copy_from
st_object_description st_object_description
end type
global w_component_params_edit w_component_params_edit

type variables
str_object_info object_info

end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();long ll_count

dw_params.settransobject(sqlca)
ll_count = dw_params.retrieve(st_id.text, st_param_mode.text)
if ll_count < 0 then return -1

return 1

end function

on w_component_params_edit.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.st_id=create st_id
this.st_param_mode=create st_param_mode
this.cb_new=create cb_new
this.cb_delete=create cb_delete
this.cb_update=create cb_update
this.dw_params=create dw_params
this.cb_copy_from=create cb_copy_from
this.st_object_description=create st_object_description
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.st_id
this.Control[iCurrent+4]=this.st_param_mode
this.Control[iCurrent+5]=this.cb_new
this.Control[iCurrent+6]=this.cb_delete
this.Control[iCurrent+7]=this.cb_update
this.Control[iCurrent+8]=this.dw_params
this.Control[iCurrent+9]=this.cb_copy_from
this.Control[iCurrent+10]=this.st_object_description
end on

on w_component_params_edit.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.st_id)
destroy(this.st_param_mode)
destroy(this.cb_new)
destroy(this.cb_delete)
destroy(this.cb_update)
destroy(this.dw_params)
destroy(this.cb_copy_from)
destroy(this.st_object_description)
end on

event open;call super::open;str_popup popup

popup = message.powerobjectparm

if popup.data_row_count > 0 then
	st_id.text = popup.items[1]
else
	log.log(this, "w_component_params_edit:open", "Invalid parameters", 4)
	close(this)
	return
end if

if popup.data_row_count > 1 then
	st_param_mode.text = popup.items[2]
else
	st_param_mode.text = "Config"
end if

SELECT CAST(id AS varchar(40)) ,
	object_class ,
	object_type ,
	description ,
	object_type_prefix ,
	owner_id ,
	status ,
	base_table ,
	base_table_key
INTO :object_info.id ,
	:object_info.object_class ,
	:object_info.object_type ,
	:object_info.description ,
	:object_info.object_type_prefix ,
	:object_info.owner_id ,
	:object_info.status ,
	:object_info.base_table ,
	:object_info.base_table_key
FROM dbo.fn_object_info(:st_id.text);
if not tf_check() then
	close(this)
	return
end if

st_object_description.text = object_info.object_type_prefix + ": " + object_info.description

postevent("post_open")


end event

event post_open;call super::post_open;dw_params.width = width - 100
dw_params.height = height - 350

cb_ok.x = width - cb_ok.width - 100
cb_ok.y = height - cb_ok.height - 30

cb_cancel.x = cb_ok.x - cb_cancel.width - 100
cb_cancel.y = cb_ok.y
cb_new.y = cb_ok.y
cb_delete.y = cb_ok.y
cb_update.y = cb_ok.y
cb_copy_from.y = cb_ok.y


st_object_description.width = width - st_object_description.x - 150

refresh()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_component_params_edit
boolean visible = true
integer x = 9
integer y = 16
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_component_params_edit
end type

type cb_ok from commandbutton within w_component_params_edit
integer x = 2866
integer y = 1704
integer width = 402
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;long i

for i = 1 to dw_params.rowcount()
	if isnull(string(dw_params.object.id[i])) then
		dw_params.object.id[i] = st_id.text
	end if
next

dw_params.update()

close(parent)

end event

type cb_cancel from commandbutton within w_component_params_edit
integer x = 2373
integer y = 1704
integer width = 402
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;close(parent)

end event

type st_id from statictext within w_component_params_edit
integer x = 293
integer y = 20
integer width = 1266
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

event doubleclicked;clipboard(text)

end event

type st_param_mode from statictext within w_component_params_edit
integer x = 1591
integer y = 20
integer width = 448
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

dw_params.update()

popup.data_row_count = 3
popup.items[1] = "Config"
popup.items[2] = "Order"
popup.items[3] = "Runtime"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

st_param_mode.text = popup.items[popup_return.item_indexes[1]]

dw_params.settransobject(sqlca)
dw_params.retrieve(st_id.text, st_param_mode.text)

end event

type cb_new from commandbutton within w_component_params_edit
integer x = 69
integer y = 1704
integer width = 485
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add New Param"
end type

event clicked;long ll_row

ll_row = dw_params.insertrow(0)
dw_params.object.id[ll_row] = st_id.text
dw_params.object.param_mode[ll_row] = st_param_mode.text
dw_params.object.sort_sequence[ll_row] = ll_row


end event

type cb_delete from commandbutton within w_component_params_edit
integer x = 645
integer y = 1704
integer width = 485
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete Param"
end type

event clicked;long ll_row
string ls_param_title
str_popup_return popup_return

ll_row = dw_params.getrow()
if ll_row <= 0 then return

ls_param_title = dw_params.object.param_title[ll_row]
if isnull(ls_param_title) then ls_param_title = "<Null>"
openwithparm(w_pop_yes_no, "Are you sure you want to delete the parameter '" + ls_param_title + "'")
popup_return = message.powerobjectparm
if popup_return.item = "YES" then dw_params.deleterow(ll_row)



end event

type cb_update from commandbutton within w_component_params_edit
integer x = 1221
integer y = 1704
integer width = 485
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Update"
end type

event clicked;integer li_sts
li_sts = dw_params.update()
if li_sts < 0 then
	openwithparm(w_pop_message, "An error occured updating the params")
	return
end if

dw_params.settransobject(sqlca)
dw_params.retrieve(st_id.text, st_param_mode.text)


end event

event rbuttondown;integer li_sts
string ls_master_update_password
str_popup popup
str_popup_return popup_return

li_sts = dw_params.update()
if li_sts < 0 then
	openwithparm(w_pop_message, "An error occured updating the params")
	return
end if

dw_params.settransobject(sqlca)
dw_params.retrieve(st_id.text, st_param_mode.text)

ls_master_update_password = datalist.get_preference("SYSTEM", "master_update_password")
if len(ls_master_update_password) > 0 then
	popup.title = "Enter the Master Database Update Password"
	openwithparm(w_pop_prompt_string, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return

	if ls_master_update_password = popup_return.items[1] then
		sqlca.jmj_upload_params(st_id.text)
		if not tf_check() then
			openwithparm(w_pop_message, "ERROR Updating master database")
			return
		end if
		
		openwithparm(w_pop_message, "Updating master database successful")
	else
		openwithparm(w_pop_message, "Password Incorrect")
		return
	end if
end if

end event

type dw_params from datawindow within w_component_params_edit
integer x = 18
integer y = 148
integer width = 3337
integer height = 1420
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "dw_component_param_edit"
boolean vscrollbar = true
boolean livescroll = true
end type

event buttonclicked;str_popup popup
str_popup_return popup_return
long ll_null
string lsa_parts[]
integer li_count
long ll_build

setnull(ll_null)

CHOOSE CASE lower(dwo.name)
	CASE "b_help"
		popup.item = object.helptext[row]
		popup.title = "Help Text for " + string(object.param_title[row])
		openwithparm(w_pop_prompt_string_multiline, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		object.helptext[row] = popup_return.items[1]
	CASE "b_sql"
		popup.item = object.query[row]
		popup.title = "SQL Query for " + string(object.param_title[row])
		openwithparm(w_pop_prompt_string_multiline, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		object.query[row] = popup_return.items[1]
	CASE "b_min_build"
// For now, just prompt the user for a string
		popup.title = "Enter the minimum build number for this attribute.  Use the form M.mm.bb where M is the major release, mm is the minor release and bb is the build number."
		openwithparm(w_pop_prompt_string, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		if pos(popup_return.items[1], ".") = 0 and isnumber(popup_return.items[1]) then
			ll_build = long(popup_return.items[1])
		elseif pos(popup_return.items[1], ".") > 0 then
			li_count = f_parse_string(popup_return.items[1], ".", lsa_parts)
			if li_count < 3 then return
			if isnumber(lsa_parts[1]) and isnumber(lsa_parts[2]) and isnumber(lsa_parts[3]) then
				ll_build = long(lsa_parts[1]) * 10000
				ll_build += long(lsa_parts[2]) * 100
				ll_build += long(lsa_parts[3])
			end if
		else
			return
		end if
		
		if ll_build >= 0 then
			object.min_build[row] = ll_build
		end if
// Use this section when the function fn_component_versions gets written
//		popup.dataobject = "dw_fn_component_versions"
//		popup.title = "Select Min Version for Attribute"
//		popup.add_blank_row =true
//		popup.blank_text = "<None>"
//		popup.argument_count = 1
//		popup.argument[1] = st_id.text
//		openwithparm(w_pop_pick, popup)
//		popup_return = message.powerobjectparm
//		if popup_return.item_count <> 1 then return
//		if popup_return.items[1] = "" then
//			object.min_build[row] = ll_null
//		else
//			object.min_build[row] = long(popup_return.items[1])
//		end if
END CHOOSE

end event

type cb_copy_from from commandbutton within w_component_params_edit
integer x = 1797
integer y = 1704
integer width = 485
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Copy From..."
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_null
long ll_param_sequence
long i
string ls_id

setnull(ls_null)

popup.dataobject = "dw_fn_object_info_by_type"
popup.datacolumn = 1
popup.displaycolumn = 4
popup.argument_count = 2
popup.argument[1] = object_info.object_class
popup.argument[2] = object_info.object_type
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_id = popup_return.items[1]

popup.dataobject = "dw_component_param_item_pick"
popup.multiselect = true
popup.title = "Select params to copy"
popup.datacolumn = 1
popup.displaycolumn = 5
popup.argument_count = 2
popup.argument[1] = ls_id
popup.argument[2] = st_param_mode.text
popup.add_blank_row = true
popup.blank_text = "<All Params>"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count < 1 then return

if popup_return.items[1] = "" then
	setnull(ll_param_sequence)
	sqlca.jmj_copy_object_params(ls_id, ll_param_sequence, st_id.text, st_param_mode.text, current_scribe.user_id)
	if not tf_check() then return
else
	for i = 1 to popup_return.item_count
		ll_param_sequence = long(popup_return.items[i])
		sqlca.jmj_copy_object_params(ls_id, ll_param_sequence, st_id.text, st_param_mode.text, current_scribe.user_id)
		if not tf_check() then return
	next
end if


refresh()

end event

type st_object_description from statictext within w_component_params_edit
integer x = 2112
integer y = 20
integer width = 1266
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

event doubleclicked;clipboard(text)

end event

