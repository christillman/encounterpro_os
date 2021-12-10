$PBExportHeader$w_folder_workplan.srw
forward
global type w_folder_workplan from w_window_base
end type
type cb_finished from commandbutton within w_folder_workplan
end type
type dw_workplans from u_dw_pick_list within w_folder_workplan
end type
type st_workplan_title from statictext within w_folder_workplan
end type
type st_owned_by_title from statictext within w_folder_workplan
end type
type st_page from statictext within w_folder_workplan
end type
type pb_up from u_picture_button within w_folder_workplan
end type
type pb_down from u_picture_button within w_folder_workplan
end type
type st_title from statictext within w_folder_workplan
end type
type st_1 from statictext within w_folder_workplan
end type
type st_workplan_required_yes from statictext within w_folder_workplan
end type
type st_workplan_required_no from statictext within w_folder_workplan
end type
type cb_move from commandbutton within w_folder_workplan
end type
type cb_delete from commandbutton within w_folder_workplan
end type
type cb_new_folder from commandbutton within w_folder_workplan
end type
end forward

global type w_folder_workplan from w_window_base
string title = "EncounterPRO Attachment Workplan"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_finished cb_finished
dw_workplans dw_workplans
st_workplan_title st_workplan_title
st_owned_by_title st_owned_by_title
st_page st_page
pb_up pb_up
pb_down pb_down
st_title st_title
st_1 st_1
st_workplan_required_yes st_workplan_required_yes
st_workplan_required_no st_workplan_required_no
cb_move cb_move
cb_delete cb_delete
cb_new_folder cb_new_folder
end type
global w_folder_workplan w_folder_workplan

type variables
string folder
string folder_context_object

boolean workplan_required



end variables

forward prototypes
public function integer pick_owner (long pl_row)
end prototypes

public function integer pick_owner (long pl_row);string ls_null
long ll_null
u_user luo_user
integer li_sts
string ls_owned_by
str_popup_return popup_return

setnull(ls_null)
setnull(ll_null)

ls_owned_by = dw_workplans.object.owned_by[pl_row]

luo_user = user_list.pick_user(true, true, true)
if isnull(luo_user) then
	if not isnull(ls_owned_by) then
		openwithparm(w_pop_yes_no, "Do you wish to remove the previously specified workplan owner?")
		popup_return = message.powerobjectparm
		if popup_return.item = "YES" then
			dw_workplans.object.owned_by[pl_row] = ls_null
			dw_workplans.object.user_full_name[pl_row] = ls_null
			dw_workplans.object.color[pl_row] = ll_null
			
			li_sts = dw_workplans.update()
			if li_sts < 0 then
				openwithparm(w_pop_message, "Update failed")
				return -1
			end if
		end if
	end if
else
	dw_workplans.object.owned_by[pl_row] = luo_user.user_id
	dw_workplans.object.user_full_name[pl_row] = luo_user.user_full_name
	dw_workplans.object.color[pl_row] = luo_user.color
	
	li_sts = dw_workplans.update()
	if li_sts < 0 then
		openwithparm(w_pop_message, "Update failed")
		return -1
	end if
end if

return 1

end function

on w_folder_workplan.create
int iCurrent
call super::create
this.cb_finished=create cb_finished
this.dw_workplans=create dw_workplans
this.st_workplan_title=create st_workplan_title
this.st_owned_by_title=create st_owned_by_title
this.st_page=create st_page
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_title=create st_title
this.st_1=create st_1
this.st_workplan_required_yes=create st_workplan_required_yes
this.st_workplan_required_no=create st_workplan_required_no
this.cb_move=create cb_move
this.cb_delete=create cb_delete
this.cb_new_folder=create cb_new_folder
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_finished
this.Control[iCurrent+2]=this.dw_workplans
this.Control[iCurrent+3]=this.st_workplan_title
this.Control[iCurrent+4]=this.st_owned_by_title
this.Control[iCurrent+5]=this.st_page
this.Control[iCurrent+6]=this.pb_up
this.Control[iCurrent+7]=this.pb_down
this.Control[iCurrent+8]=this.st_title
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.st_workplan_required_yes
this.Control[iCurrent+11]=this.st_workplan_required_no
this.Control[iCurrent+12]=this.cb_move
this.Control[iCurrent+13]=this.cb_delete
this.Control[iCurrent+14]=this.cb_new_folder
end on

on w_folder_workplan.destroy
call super::destroy
destroy(this.cb_finished)
destroy(this.dw_workplans)
destroy(this.st_workplan_title)
destroy(this.st_owned_by_title)
destroy(this.st_page)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_title)
destroy(this.st_1)
destroy(this.st_workplan_required_yes)
destroy(this.st_workplan_required_no)
destroy(this.cb_move)
destroy(this.cb_delete)
destroy(this.cb_new_folder)
end on

event open;call super::open;long ll_count
string ls_workplan_required_flag


folder = message.stringparm

dw_workplans.settransobject(sqlca)
ll_count = dw_workplans.retrieve(folder)

// Error
if ll_count < 0 then
	log.log(this, "w_folder_workplan:open", "Error getting folder workplans (" + folder + ")", 4)
	close(this)
	return
end if

dw_workplans.set_page(1, pb_up, pb_down, st_page)

SELECT workplan_required_flag, context_object
INTO :ls_workplan_required_flag, :folder_context_object
FROM c_Folder
WHERE folder = :folder;
if not tf_check() then
	log.log(this, "w_folder_workplan:open", "Error folder record (" + folder + ")", 4)
	close(this)
	return
end if
if sqlca.sqlcode = 100 then
	log.log(this, "w_folder_workplan:open", "folder record not found (" + folder + ")", 4)
	close(this)
	return
end if

workplan_required = f_string_to_boolean(ls_workplan_required_flag)

if workplan_required then
	st_workplan_required_yes.backcolor = color_object_selected
else
	st_workplan_required_no.backcolor = color_object_selected
end if



end event

type pb_epro_help from w_window_base`pb_epro_help within w_folder_workplan
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_folder_workplan
end type

type cb_finished from commandbutton within w_folder_workplan
integer x = 2318
integer y = 1592
integer width = 535
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
boolean default = true
end type

event clicked;
close(parent)

end event

type dw_workplans from u_dw_pick_list within w_folder_workplan
integer x = 402
integer y = 284
integer width = 2066
integer height = 952
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_folder_workplan_pick"
boolean border = false
end type

event unselected;call super::unselected;cb_delete.enabled = false
cb_move.enabled = false

end event

event selected;call super::selected;cb_delete.enabled = true
cb_move.enabled = true

if lastcolumn = 0 then pick_owner(selected_row)

end event

type st_workplan_title from statictext within w_folder_workplan
integer x = 805
integer y = 220
integer width = 402
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
string text = "Workplan"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_owned_by_title from statictext within w_folder_workplan
integer x = 1701
integer y = 220
integer width = 654
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
string text = "Workplan Owner"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_page from statictext within w_folder_workplan
integer x = 2459
integer y = 220
integer width = 325
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Page 99/99"
boolean focusrectangle = false
end type

type pb_up from u_picture_button within w_folder_workplan
integer x = 2459
integer y = 292
integer width = 137
integer height = 116
integer taborder = 50
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_workplans.current_page

dw_workplans.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_folder_workplan
integer x = 2459
integer y = 416
integer width = 137
integer height = 116
integer taborder = 60
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_workplans.current_page
li_last_page = dw_workplans.last_page

dw_workplans.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true


end event

type st_title from statictext within w_folder_workplan
integer width = 2921
integer height = 132
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Attachment Workplan"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_folder_workplan
integer x = 731
integer y = 1524
integer width = 699
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
string text = "Workplan Required:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_workplan_required_yes from statictext within w_folder_workplan
integer x = 1458
integer y = 1500
integer width = 224
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_workplan_required_no.backcolor = color_object

workplan_required = true

UPDATE c_Folder
SET workplan_required_flag = 'Y'
WHERE folder = :folder;
if not tf_check() then return


end event

type st_workplan_required_no from statictext within w_folder_workplan
integer x = 1737
integer y = 1500
integer width = 224
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_workplan_required_yes.backcolor = color_object

workplan_required = false

UPDATE c_Folder
SET workplan_required_flag = 'N'
WHERE folder = :folder;
if not tf_check() then return


end event

type cb_move from commandbutton within w_folder_workplan
integer x = 1797
integer y = 1292
integer width = 535
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Move Up/Down"
end type

event clicked;str_popup popup
long ll_row
integer li_sts
long ll_rowcount
long i

ll_row = dw_workplans.get_selected_row()
if ll_row <= 0 then return 0

ll_rowcount = dw_workplans.rowcount()
for i = 1 to ll_rowcount
	dw_workplans.object.sort_sequence[ll_row] = i
next

popup.objectparm = dw_workplans

openwithparm(w_pick_list_sort, popup)

li_sts = dw_workplans.update()
if li_sts <= 0 then
	openwithparm(w_pop_message, "Sort update failed")
	return
end if

return


end event

type cb_delete from commandbutton within w_folder_workplan
integer x = 1161
integer y = 1292
integer width = 535
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Delete Workplan"
end type

event clicked;str_popup_return popup_return
long ll_row
integer li_sts

ll_row = dw_workplans.get_selected_row()
if ll_row <= 0 then return

openwithparm(w_pop_yes_no, "Are you sure you want to delete the selected workplan?")
popup_return = message.powerobjectparm
if popup_return.item = "YES" then
	dw_workplans.deleterow(ll_row)
	li_sts = dw_workplans.update()
end if


end event

type cb_new_folder from commandbutton within w_folder_workplan
integer x = 526
integer y = 1292
integer width = 535
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Workplan"
end type

event clicked;w_pick_workplan lw_window
str_c_workplan lstr_workplan
long ll_row
integer li_sts
str_workplan_context lstr_workplan_context

lstr_workplan_context.context_object = "Attachment"
lstr_workplan_context.in_office_flag = "N"

if len(folder_context_object) > 0 &
	and lower(folder_context_object) <> "general" &
	and lower(folder_context_object) <> "patient" &
	and lower(folder_context_object) <> "attachment" then
	lstr_workplan_context.second_context_object = folder_context_object
end if

openwithparm(lw_window, lstr_workplan_context, "w_pick_workplan")
lstr_workplan = message.powerobjectparm
if isnull(lstr_workplan.workplan_id) then return

dw_workplans.clear_selected()

ll_row = dw_workplans.insertrow(0)
dw_workplans.object.folder[ll_row] = folder
dw_workplans.object.workplan_id[ll_row] = lstr_workplan.workplan_id
dw_workplans.object.selected_flag[ll_row] = 1
dw_workplans.object.description[ll_row] = lstr_workplan.description
dw_workplans.object.sort_sequence[ll_row] = ll_row

li_sts = dw_workplans.update()
if li_sts <= 0 then
	openwithparm(w_pop_message, "Error saving new workplan")
	return
end if

dw_workplans.scrolltorow(ll_row)
dw_workplans.event POST selected(ll_row)


end event

