HA$PBExportHeader$w_workplan_definition_display.srw
forward
global type w_workplan_definition_display from w_window_base
end type
type st_title from statictext within w_workplan_definition_display
end type
type tv_workplan from u_tv_workplan within w_workplan_definition_display
end type
type cb_set_active from commandbutton within w_workplan_definition_display
end type
type dw_workplans from u_dw_pick_list within w_workplan_definition_display
end type
type cb_finished from commandbutton within w_workplan_definition_display
end type
type cb_edit_workplan from commandbutton within w_workplan_definition_display
end type
type st_versions_title from statictext within w_workplan_definition_display
end type
type cb_local_copy from commandbutton within w_workplan_definition_display
end type
end forward

global type w_workplan_definition_display from w_window_base
integer width = 3063
integer height = 2036
string title = "Workplan Display / Edit"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_title st_title
tv_workplan tv_workplan
cb_set_active cb_set_active
dw_workplans dw_workplans
cb_finished cb_finished
cb_edit_workplan cb_edit_workplan
st_versions_title st_versions_title
cb_local_copy cb_local_copy
end type
global w_workplan_definition_display w_workplan_definition_display

type variables
string id
boolean allow_editing


end variables

forward prototypes
public function integer initialize ()
end prototypes

public function integer initialize ();integer li_sts
long ll_rows
long ll_active
long i
string ls_status
long ll_workplan_id
long ll_root_handle
boolean lb_local_found
long ll_owner_id

dw_workplans.settransobject(sqlca)
ll_rows = dw_workplans.retrieve(id, sqlca.customer_id)
if ll_rows < 0 then
	log.log(this, "open", "Error retrieving workplans (" + id + ")", 4)
	return -1
elseif ll_rows = 0 then	
	log.log(this, "open", "No workplans found (" + id + ")", 4)
	return -1
end if

// Find the last active workplan and highlight it
ll_active = 0
lb_local_found = false
for i = ll_rows to 1 step -1
	ll_owner_id = dw_workplans.object.owner_id[i]
	ls_status = dw_workplans.object.status[i]
	if ll_owner_id = sqlca.customer_id then lb_local_found = true
	if upper(ls_status) = "OK" then
		if ll_active = 0 then
			ll_active = i
		else
			// If there are any other workplans with a status of OK, make them NA.
			dw_workplans.object.status[i] = "NA"
			dw_workplans.update()
		end if
	end if
next
if ll_active <= 0 then ll_active = 1

dw_workplans.object.selected_flag[ll_active] = 1
dw_workplans.event TRIGGER selected(ll_active)

if not lb_local_found then
	cb_local_copy.visible = true
else
	cb_local_copy.visible = false
end if


return 1

end function

on w_workplan_definition_display.create
int iCurrent
call super::create
this.st_title=create st_title
this.tv_workplan=create tv_workplan
this.cb_set_active=create cb_set_active
this.dw_workplans=create dw_workplans
this.cb_finished=create cb_finished
this.cb_edit_workplan=create cb_edit_workplan
this.st_versions_title=create st_versions_title
this.cb_local_copy=create cb_local_copy
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.tv_workplan
this.Control[iCurrent+3]=this.cb_set_active
this.Control[iCurrent+4]=this.dw_workplans
this.Control[iCurrent+5]=this.cb_finished
this.Control[iCurrent+6]=this.cb_edit_workplan
this.Control[iCurrent+7]=this.st_versions_title
this.Control[iCurrent+8]=this.cb_local_copy
end on

on w_workplan_definition_display.destroy
call super::destroy
destroy(this.st_title)
destroy(this.tv_workplan)
destroy(this.cb_set_active)
destroy(this.dw_workplans)
destroy(this.cb_finished)
destroy(this.cb_edit_workplan)
destroy(this.st_versions_title)
destroy(this.cb_local_copy)
end on

event open;call super::open;str_popup popup
integer li_sts
long ll_workplan_id

popup = message.powerobjectparm

if popup.data_row_count < 1 then
	log.log(this, "open", "Invalid Parameters", 4)
	close(this)
	return
end if

if isnumber(popup.items[1]) then
	ll_workplan_id = long(popup.items[1])

	SELECT CAST(id AS varchar(40))
	INTO :id
	FROM c_workplan
	WHERE workplan_id = :ll_workplan_id;
	if not tf_check() then close(this)
	if sqlca.sqlcode = 100 then
		log.log(this, "open", "Invalid workplan_id (" + popup.items[1] + ")", 4)
		close(this)
	end if
else
	id = popup.items[1]
end if

if popup.data_row_count >= 2 then
	allow_editing = f_string_to_boolean(popup.items[2])
else
	allow_editing = true
end if

li_sts = initialize()
if li_sts <= 0 then close(this)


end event

event resize;call super::resize;long ll_delta


dw_workplans.x = newwidth - dw_workplans.width - 100

ll_delta = (dw_workplans.width - cb_set_active.width) / 2
cb_set_active.x = dw_workplans.x + ll_delta

ll_delta = (dw_workplans.width - st_versions_title.width) / 2
st_versions_title.x = dw_workplans.x + ll_delta

ll_delta = (dw_workplans.width - cb_edit_workplan.width) / 2
cb_edit_workplan.x = dw_workplans.x + ll_delta

ll_delta = (dw_workplans.width - cb_local_copy.width) / 2
cb_local_copy.x = dw_workplans.x + ll_delta

tv_workplan.width = dw_workplans.x - 125
tv_workplan.height = newheight - tv_workplan.y - 100
st_title.width = tv_workplan.width

pb_epro_help.x = newwidth - pb_epro_help.width - 100

cb_finished.x = newwidth - cb_finished.width - 100
cb_finished.y = newheight - cb_finished.height - 80


end event

type pb_epro_help from w_window_base`pb_epro_help within w_workplan_definition_display
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_workplan_definition_display
end type

type st_title from statictext within w_workplan_definition_display
integer y = 8
integer width = 2907
integer height = 112
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Workplan Title"
alignment alignment = center!
boolean focusrectangle = false
end type

type tv_workplan from u_tv_workplan within w_workplan_definition_display
integer x = 14
integer y = 136
integer width = 2153
integer height = 1640
integer taborder = 20
long backcolor = 12632256
end type

type cb_set_active from commandbutton within w_workplan_definition_display
integer x = 2405
integer y = 988
integer width = 402
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Set Inactive"
end type

event clicked;long ll_row
string ls_status
long i
integer li_sts

ll_row = dw_workplans.get_selected_row()
if ll_row <= 0 then return

ls_status = dw_workplans.object.status[ll_row]

if upper(ls_status) = "OK" then
	dw_workplans.object.status[ll_row] = "NA"
	text = "Set Active"
else
	text = "Set Inactive"
	for i = 1 to dw_workplans.rowcount()
		if i = ll_row then
			dw_workplans.object.status[i] = "OK"
		else
			dw_workplans.object.status[i] = "NA"
		end if
	next
end if

li_sts = dw_workplans.update()
if li_sts <= 0 then
	openwithparm(w_pop_message, "Status change failed")
	return
end if


end event

type dw_workplans from u_dw_pick_list within w_workplan_definition_display
integer x = 2217
integer y = 268
integer width = 782
integer height = 608
integer taborder = 11
string dataobject = "dw_id_workplans"
boolean border = false
end type

event selected;call super::selected;long ll_workplan_id
long ll_root_handle
string ls_status
long ll_owner_id
long ll_local_owner_id

ll_workplan_id = object.workplan_id[selected_row]

tv_workplan.setredraw(false)

tv_workplan.display_workplan(ll_workplan_id, allow_editing)
ll_root_handle = tv_workplan.finditem(RootTreeItem!, 0)
if ll_root_handle > 0 then tv_workplan.expandall(ll_root_handle)

tv_workplan.setredraw(true)

ls_status = object.status[selected_row]
if upper(ls_status) = "OK" then
	cb_set_active.text = "Set Inactive"
else
	cb_set_active.text = "Set Active"
end if

ll_owner_id = object.owner_id[selected_row]
ll_local_owner_id = object.local_owner_id[selected_row]

if ll_local_owner_id = ll_owner_id and allow_editing then
	cb_edit_workplan.visible = true
else
	cb_edit_workplan.visible = false
end if

st_title.text = tv_workplan.workplan.description

end event

type cb_finished from commandbutton within w_workplan_definition_display
integer x = 2505
integer y = 1748
integer width = 402
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

event clicked;close(parent)

end event

type cb_edit_workplan from commandbutton within w_workplan_definition_display
integer x = 2299
integer y = 1176
integer width = 617
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Edit Workplan"
end type

event clicked;str_popup popup
str_popup_return popup_return
long ll_workplan_id
long ll_root_handle
long ll_row

ll_row = dw_workplans.get_selected_row()
if ll_row <= 0 then return

ll_workplan_id = dw_workplans.object.workplan_id[ll_row]

popup.items[1] = string(ll_workplan_id)
popup.data_row_count = 1
openwithparm(w_Workplan_definition, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

dw_workplans.event TRIGGER selected(ll_row) 


end event

type st_versions_title from statictext within w_workplan_definition_display
integer x = 2405
integer y = 204
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
long backcolor = 33538240
string text = "Versions"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_local_copy from commandbutton within w_workplan_definition_display
integer x = 2299
integer y = 1364
integer width = 617
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Create Local Copy"
end type

event clicked;long ll_workplan_id
string ls_id
string ls_description
long ll_new_workplan_id
long ll_row

ll_row = dw_workplans.get_selected_row()
if ll_row <= 0 then return

ll_workplan_id = dw_workplans.object.workplan_id[ll_row]
ls_id = dw_workplans.object.id[ll_row]
ls_description = dw_workplans.object.description[ll_row]

if not f_popup_yes_no("Are you sure you wish to create a local copy of this workplan?") then return

ll_new_workplan_id = sqlca.sp_local_copy_workplan(ll_workplan_id, ls_id, ls_description)
if not tf_check() then return

initialize()

end event

