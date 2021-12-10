$PBExportHeader$w_config_letter_types.srw
forward
global type w_config_letter_types from w_window_base
end type
type cb_finished from commandbutton within w_config_letter_types
end type
type st_description_title from statictext within w_config_letter_types
end type
type st_context_object_type from statictext within w_config_letter_types
end type
type dw_folders from u_dw_pick_list within w_config_letter_types
end type
type st_description from statictext within w_config_letter_types
end type
type st_context_object_type_title from statictext within w_config_letter_types
end type
type cb_move from commandbutton within w_config_letter_types
end type
type cb_delete from commandbutton within w_config_letter_types
end type
type cb_new_folder from commandbutton within w_config_letter_types
end type
type st_workplans_title from statictext within w_config_letter_types
end type
type dw_workplans from u_dw_pick_list within w_config_letter_types
end type
type cb_change_context from commandbutton within w_config_letter_types
end type
type cb_naming_rules from commandbutton within w_config_letter_types
end type
type st_title from statictext within w_config_letter_types
end type
end forward

global type w_config_letter_types from w_window_base
string title = "Letter Types"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_finished cb_finished
st_description_title st_description_title
st_context_object_type st_context_object_type
dw_folders dw_folders
st_description st_description
st_context_object_type_title st_context_object_type_title
cb_move cb_move
cb_delete cb_delete
cb_new_folder cb_new_folder
st_workplans_title st_workplans_title
dw_workplans dw_workplans
cb_change_context cb_change_context
cb_naming_rules cb_naming_rules
st_title st_title
end type
global w_config_letter_types w_config_letter_types

forward prototypes
public function integer refresh ()
public function integer refresh_workplans (string ps_folder)
end prototypes

public function integer refresh ();long ll_rows

ll_rows = dw_folders.retrieve()


if ll_rows > 0 then
	dw_folders.object.selected_flag[1] = 1
	dw_folders.event trigger selected(1)
else
	st_context_object_type.text = ""
	st_description.text = ""
	
	st_context_object_type.enabled = false
	st_description.enabled = false
	cb_delete.enabled = false
	cb_move.enabled = false
end if


return 1

end function

public function integer refresh_workplans (string ps_folder);long ll_count
long ll_row

dw_workplans.enabled = true
dw_workplans.settransobject(sqlca)

ll_count = dw_workplans.retrieve(ps_folder)
if ll_count <= 0 then
	ll_row = dw_workplans.insertrow(0)
	dw_workplans.object.description[ll_row] = "No Workplans"
end if

return 1

end function

on w_config_letter_types.create
int iCurrent
call super::create
this.cb_finished=create cb_finished
this.st_description_title=create st_description_title
this.st_context_object_type=create st_context_object_type
this.dw_folders=create dw_folders
this.st_description=create st_description
this.st_context_object_type_title=create st_context_object_type_title
this.cb_move=create cb_move
this.cb_delete=create cb_delete
this.cb_new_folder=create cb_new_folder
this.st_workplans_title=create st_workplans_title
this.dw_workplans=create dw_workplans
this.cb_change_context=create cb_change_context
this.cb_naming_rules=create cb_naming_rules
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_finished
this.Control[iCurrent+2]=this.st_description_title
this.Control[iCurrent+3]=this.st_context_object_type
this.Control[iCurrent+4]=this.dw_folders
this.Control[iCurrent+5]=this.st_description
this.Control[iCurrent+6]=this.st_context_object_type_title
this.Control[iCurrent+7]=this.cb_move
this.Control[iCurrent+8]=this.cb_delete
this.Control[iCurrent+9]=this.cb_new_folder
this.Control[iCurrent+10]=this.st_workplans_title
this.Control[iCurrent+11]=this.dw_workplans
this.Control[iCurrent+12]=this.cb_change_context
this.Control[iCurrent+13]=this.cb_naming_rules
this.Control[iCurrent+14]=this.st_title
end on

on w_config_letter_types.destroy
call super::destroy
destroy(this.cb_finished)
destroy(this.st_description_title)
destroy(this.st_context_object_type)
destroy(this.dw_folders)
destroy(this.st_description)
destroy(this.st_context_object_type_title)
destroy(this.cb_move)
destroy(this.cb_delete)
destroy(this.cb_new_folder)
destroy(this.st_workplans_title)
destroy(this.dw_workplans)
destroy(this.cb_change_context)
destroy(this.cb_naming_rules)
destroy(this.st_title)
end on

event open;call super::open;integer li_sts
boolean lb_allow_delete
string ls_temp

dw_folders.settransobject(sqlca)

lb_allow_delete = f_string_to_boolean(datalist.get_preference("PREFERENCES", "allow_folder_delete", "False"))
if lb_allow_delete then
	cb_delete.visible = true
else
	cb_delete.visible = false
end if

dw_folders.object.description.width = dw_folders.width - 600

refresh()


end event

type pb_epro_help from w_window_base`pb_epro_help within w_config_letter_types
integer x = 2857
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_config_letter_types
end type

type cb_finished from commandbutton within w_config_letter_types
integer x = 2395
integer y = 1588
integer width = 480
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;sqlca.sp_set_patient_folder_selection()
if not tf_check() then
	openwithparm(w_pop_message, "Folder Selection update failed")
	return
end if


close(parent)

end event

type st_description_title from statictext within w_config_letter_types
integer x = 1851
integer y = 376
integer width = 1024
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Description"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_context_object_type from statictext within w_config_letter_types
integer x = 1961
integer y = 228
integer width = 914
integer height = 104
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

event clicked;string ls_context_object_type
string ls_context_object
long ll_row
integer li_sts

ll_row = dw_folders.get_selected_row()
if ll_row <= 0 then return

ls_context_object = dw_folders.object.context_object[ll_row]

ls_context_object_type = f_pick_context_object_type(ls_context_object, "Folder " + ls_context_object + " Type")
if isnull(ls_context_object_type) then return

dw_folders.object.context_object_type[ll_row] = ls_context_object_type
text = datalist.object_type_description(ls_context_object, ls_context_object_type)

li_sts = dw_folders.update()

return

end event

type dw_folders from u_dw_pick_list within w_config_letter_types
integer x = 18
integer y = 180
integer width = 1778
integer height = 1476
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_folder_display"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;string ls_context_object
string ls_context_object_type
integer li_sts
str_popup popup
str_popup_return popup_return
string ls_folder
string ls_null
long ll_count
long ll_row

setnull(ls_null)

ls_folder = object.folder[selected_row]
ls_context_object = object.context_object[selected_row]
ls_context_object_type = object.context_object_type[selected_row]

st_context_object_type.text = datalist.object_type_description(ls_context_object, ls_context_object_type)

st_description.text = object.description[selected_row]

st_context_object_type.enabled = true
st_description.enabled = true
cb_delete.enabled = true
cb_move.enabled = true
cb_change_context.enabled = true


if lower(ls_context_object) = "patient" or lower(ls_context_object) = "observation" then
	st_context_object_type.visible = false
	st_context_object_type_title.visible = false
else
	st_context_object_type.visible = true
	st_context_object_type_title.visible = true
end if

refresh_workplans(ls_folder)

end event

event unselected;call super::unselected;st_context_object_type.text = ""
st_description.text = ""

st_context_object_type.enabled = false
st_description.enabled = false
cb_delete.enabled = false
cb_move.enabled = false
cb_change_context.enabled = false

dw_workplans.reset()
dw_workplans.enabled = false

end event

type st_description from statictext within w_config_letter_types
integer x = 1851
integer y = 460
integer width = 1024
integer height = 228
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;integer li_sts
str_popup popup
str_popup_return popup_return
string ls_description
long ll_row

ll_row = dw_folders.get_selected_row()
if ll_row <= 0 then return 0

ls_description = dw_folders.object.description[ll_row]

popup.title = "Enter the description of this folder"
popup.item = ls_description
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_description = trim(popup_return.items[1])
if ls_description = "" then return

dw_folders.object.description[ll_row] = ls_description
text = ls_description

li_sts = dw_folders.update()
if li_sts <= 0 then
	openwithparm(w_pop_message, "description update failed")
	return
end if




end event

type st_context_object_type_title from statictext within w_config_letter_types
integer x = 1961
integer y = 152
integer width = 914
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Type"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_move from commandbutton within w_config_letter_types
integer x = 1851
integer y = 1180
integer width = 480
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Move"
end type

event clicked;str_popup popup
long ll_row
integer li_sts
long ll_rowcount
long i

ll_row = dw_folders.get_selected_row()
if ll_row <= 0 then return 0

ll_rowcount = dw_folders.rowcount()
for i = 1 to ll_rowcount
	dw_folders.object.sort_sequence[ll_row] = i
next

popup.objectparm = dw_folders

openwithparm(w_pick_list_sort, popup)

li_sts = dw_folders.update()
if li_sts <= 0 then
	openwithparm(w_pop_message, "Sort update failed")
	return
end if

return


end event

type cb_delete from commandbutton within w_config_letter_types
integer x = 2395
integer y = 1180
integer width = 480
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete"
end type

event clicked;str_popup_return popup_return
long ll_row
integer li_sts

ll_row = dw_folders.get_selected_row()
if ll_row <= 0 then return

openwithparm(w_pop_yes_no, "Are you sure you want to delete the selected menu item?")
popup_return = message.powerobjectparm
if popup_return.item = "YES" then
	dw_folders.object.status[ll_row] = 'NA'
	li_sts = dw_folders.update()
	refresh()
end if


end event

type cb_new_folder from commandbutton within w_config_letter_types
integer x = 1851
integer y = 1316
integer width = 480
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Folder"
end type

event clicked;integer li_sts
str_popup popup
str_popup_return popup_return
string ls_folder
long ll_row

popup.title = "Enter the name of the new folder"
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_folder = trim(popup_return.items[1])
if ls_folder = "" then return

dw_folders.clear_selected()

ll_row = dw_folders.insertrow(0)
dw_folders.object.folder[ll_row] = ls_folder
dw_folders.object.context_object[ll_row] = "Patient"
dw_folders.object.description[ll_row] = ls_folder
dw_folders.object.status[ll_row] = "OK"
dw_folders.object.sort_sequence[ll_row] = ll_row
dw_folders.object.selected_flag[ll_row] = 1

li_sts = dw_folders.update()
if li_sts <= 0 then
	openwithparm(w_pop_message, "New folder create failed")
	return
end if

dw_folders.scrolltorow(ll_row)

// post a selected event
dw_folders.event post selected(ll_row)



end event

type st_workplans_title from statictext within w_config_letter_types
integer x = 1851
integer y = 728
integer width = 1024
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Workplans"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_workplans from u_dw_pick_list within w_config_letter_types
integer x = 1851
integer y = 804
integer width = 1024
integer height = 340
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_folder_workplan_list_small"
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;long ll_row
string ls_folder


ll_row = dw_folders.get_selected_row()
if ll_row <= 0 then return 0

ls_folder = dw_folders.object.folder[ll_row]

openwithparm(w_folder_workplan, ls_folder)

refresh_workplans(ls_folder)

end event

type cb_change_context from commandbutton within w_config_letter_types
integer x = 2395
integer y = 1316
integer width = 480
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Change Context"
end type

event clicked;string ls_context_object
string ls_context_object_type
integer li_sts
str_popup popup
str_popup_return popup_return
string ls_folder
string ls_null
long ll_row

setnull(ls_null)

ll_row = dw_folders.get_selected_row()
if ll_row <= 0 then return

ls_context_object = dw_folders.object.context_object[ll_row]
ls_context_object_type = dw_folders.object.context_object_type[ll_row]

// get the service type
popup.dataobject = "dw_patient_context_object_pick_list"
popup.datacolumn = 1
popup.displaycolumn = 1
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if lower(popup_return.items[1]) <> ls_context_object then
	ls_context_object = wordcap(trim(popup_return.items[1]))

	openwithparm(w_pop_yes_no, "Are you sure you want to change the context of this folder to " + ls_context_object + "?")
	popup_return = message.powerobjectparm
	if popup_return.item = "YES" then
		dw_folders.object.context_object[ll_row] = ls_context_object
		if lower(ls_context_object) = "patient" or lower(ls_context_object) = "observation" then
			dw_folders.object.context_object_type[ll_row] = ls_null
			st_context_object_type.visible = false
			st_context_object_type_title.visible = false
		else
			st_context_object_type.visible = true
			st_context_object_type_title.visible = true
			st_context_object_type.event POST clicked()
		end if
		li_sts = dw_folders.update()
	end if
end if

end event

type cb_naming_rules from commandbutton within w_config_letter_types
integer x = 2126
integer y = 1452
integer width = 480
integer height = 112
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Naming Rules"
end type

event clicked;string ls_folder
long ll_row

ll_row = dw_folders.get_selected_row()
if ll_row <= 0 then return

ls_folder = dw_folders.object.folder[ll_row]

openwithparm(w_folder_naming_rules, ls_folder)

end event

type st_title from statictext within w_config_letter_types
integer width = 2921
integer height = 100
boolean bringtotop = true
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Folder Configuration"
alignment alignment = center!
boolean focusrectangle = false
end type

