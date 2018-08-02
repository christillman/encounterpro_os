$PBExportHeader$w_post_attachment_workplan.srw
forward
global type w_post_attachment_workplan from w_window_base
end type
type cb_finished from commandbutton within w_post_attachment_workplan
end type
type cb_cancel from commandbutton within w_post_attachment_workplan
end type
type dw_workplans from u_dw_pick_list within w_post_attachment_workplan
end type
type st_workplan_title from statictext within w_post_attachment_workplan
end type
type st_owned_by_title from statictext within w_post_attachment_workplan
end type
type st_page from statictext within w_post_attachment_workplan
end type
type pb_up from u_picture_button within w_post_attachment_workplan
end type
type pb_down from u_picture_button within w_post_attachment_workplan
end type
type cb_no_workplan from commandbutton within w_post_attachment_workplan
end type
type st_title from statictext within w_post_attachment_workplan
end type
type st_workplan_owner from statictext within w_post_attachment_workplan
end type
type st_2 from statictext within w_post_attachment_workplan
end type
end forward

global type w_post_attachment_workplan from w_window_base
string title = "EncounterPRO Attachment Workplan"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_finished cb_finished
cb_cancel cb_cancel
dw_workplans dw_workplans
st_workplan_title st_workplan_title
st_owned_by_title st_owned_by_title
st_page st_page
pb_up pb_up
pb_down pb_down
cb_no_workplan cb_no_workplan
st_title st_title
st_workplan_owner st_workplan_owner
st_2 st_2
end type
global w_post_attachment_workplan w_post_attachment_workplan

type variables
str_attachment_context attachment_context

boolean workplan_required

string picked_user_id


end variables

on w_post_attachment_workplan.create
int iCurrent
call super::create
this.cb_finished=create cb_finished
this.cb_cancel=create cb_cancel
this.dw_workplans=create dw_workplans
this.st_workplan_title=create st_workplan_title
this.st_owned_by_title=create st_owned_by_title
this.st_page=create st_page
this.pb_up=create pb_up
this.pb_down=create pb_down
this.cb_no_workplan=create cb_no_workplan
this.st_title=create st_title
this.st_workplan_owner=create st_workplan_owner
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_finished
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.dw_workplans
this.Control[iCurrent+4]=this.st_workplan_title
this.Control[iCurrent+5]=this.st_owned_by_title
this.Control[iCurrent+6]=this.st_page
this.Control[iCurrent+7]=this.pb_up
this.Control[iCurrent+8]=this.pb_down
this.Control[iCurrent+9]=this.cb_no_workplan
this.Control[iCurrent+10]=this.st_title
this.Control[iCurrent+11]=this.st_workplan_owner
this.Control[iCurrent+12]=this.st_2
end on

on w_post_attachment_workplan.destroy
call super::destroy
destroy(this.cb_finished)
destroy(this.cb_cancel)
destroy(this.dw_workplans)
destroy(this.st_workplan_title)
destroy(this.st_owned_by_title)
destroy(this.st_page)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.cb_no_workplan)
destroy(this.st_title)
destroy(this.st_workplan_owner)
destroy(this.st_2)
end on

event open;call super::open;long ll_count
string ls_workplan_required_flag


attachment_context = message.powerobjectparm

dw_workplans.settransobject(sqlca)
ll_count = dw_workplans.retrieve(attachment_context.folder)

// Error
if ll_count < 0 then
	log.log(this, "w_post_attachment_workplan.open.0012", "Error getting folder workplans (" + attachment_context.folder + ")", 4)
	attachment_context.workplan_id = -1
	closewithreturn(this, attachment_context)
	return
end if

// No workplans
if ll_count = 0 then
	setnull(attachment_context.workplan_id)
	setnull(attachment_context.user_id)
	closewithreturn(this, attachment_context)
	return
end if

dw_workplans.set_page(1, pb_up, pb_down, st_page)

SELECT workplan_required_flag
INTO :ls_workplan_required_flag
FROM c_Folder
WHERE folder = :attachment_context.folder;
if not tf_check() then
	log.log(this, "w_post_attachment_workplan.open.0012", "Error folder record (" + attachment_context.folder + ")", 4)
	attachment_context.workplan_id = -1
	closewithreturn(this, attachment_context)
	return
end if
if sqlca.sqlcode = 100 then
	log.log(this, "w_post_attachment_workplan.open.0012", "folder record not found (" + attachment_context.folder + ")", 4)
	attachment_context.workplan_id = -1
	closewithreturn(this, attachment_context)
	return
end if

workplan_required = f_string_to_boolean(ls_workplan_required_flag)

if cpr_mode = "SERVER" then
	// If we're in server mode then automatically pick the first workplan
	attachment_context.workplan_id = dw_workplans.object.workplan_id[1]
	attachment_context.user_id = dw_workplans.object.owned_by[1]
	if isnull(attachment_context.user_id) then
		attachment_context.user_id = "#PATIENT_PROVIDER"
	end if
	return
end if

if workplan_required then
	// A workplan is required and there's only one workplan, so
	// see if it already has an owned_by
	if ll_count = 1 then
		if not isnull(string(dw_workplans.object.owned_by[1])) then
			attachment_context.workplan_id = dw_workplans.object.workplan_id[1]
			attachment_context.user_id = dw_workplans.object.owned_by[1]
			closewithreturn(this, attachment_context)
			return
		end if
	end if
end if

// Automatically select the first workplan
dw_workplans.object.selected_flag[1] = 1
dw_workplans.event POST selected(1)


end event

type pb_epro_help from w_window_base`pb_epro_help within w_post_attachment_workplan
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_post_attachment_workplan
end type

type cb_finished from commandbutton within w_post_attachment_workplan
integer x = 2171
integer y = 1396
integer width = 640
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Finished"
boolean default = true
end type

event clicked;long ll_row

if isnull(picked_user_id) then
	openwithparm(w_pop_message, "You must select a user to dispatch the workplan to.")
	return
end if

ll_row = dw_workplans.get_selected_row( )
if ll_row <= 0 then return

attachment_context.workplan_id = dw_workplans.object.workplan_id[ll_row]
attachment_context.user_id = picked_user_id

closewithreturn(parent, attachment_context)

end event

type cb_cancel from commandbutton within w_post_attachment_workplan
integer x = 41
integer y = 1592
integer width = 494
integer height = 112
integer taborder = 30
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

event clicked;attachment_context.workplan_id = 0
closewithreturn(parent, attachment_context)

end event

type dw_workplans from u_dw_pick_list within w_post_attachment_workplan
integer x = 352
integer y = 372
integer width = 2066
integer height = 904
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_folder_workplan_pick"
boolean border = false
end type

event selected;call super::selected;string ls_owned_by
u_user luo_user
string ls_null
long ll_null

setnull(ls_null)
setnull(ll_null)

cb_finished.enabled = true

ls_owned_by = object.owned_by[selected_row]
luo_user = user_list.find_user(ls_owned_by)

if isnull(luo_user) then
	picked_user_id = ls_null
	st_workplan_owner.text = "N/A"
	st_workplan_owner.backcolor = color_object
	st_workplan_owner.event POST clicked()
else
	picked_user_id = luo_user.user_id
	st_workplan_owner.text = luo_user.user_full_name
	st_workplan_owner.backcolor = luo_user.color
end if


end event

event unselected;call super::unselected;cb_finished.enabled = false


end event

type st_workplan_title from statictext within w_post_attachment_workplan
integer x = 754
integer y = 308
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
string text = "Workplan"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_owned_by_title from statictext within w_post_attachment_workplan
integer x = 1568
integer y = 308
integer width = 809
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
string text = "Default Workplan Owner"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_page from statictext within w_post_attachment_workplan
integer x = 2409
integer y = 308
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
long backcolor = 33538240
string text = "Page 99/99"
boolean focusrectangle = false
end type

type pb_up from u_picture_button within w_post_attachment_workplan
integer x = 2409
integer y = 380
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

type pb_down from u_picture_button within w_post_attachment_workplan
integer x = 2409
integer y = 504
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

type cb_no_workplan from commandbutton within w_post_attachment_workplan
integer x = 603
integer y = 1592
integer width = 850
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "No Workplan This Time"
boolean default = true
end type

event clicked;setnull(attachment_context.workplan_id)
closewithreturn(parent, attachment_context)

end event

type st_title from statictext within w_post_attachment_workplan
integer width = 2921
integer height = 132
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Attachment Workplan"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_workplan_owner from statictext within w_post_attachment_workplan
integer x = 1029
integer y = 1396
integer width = 1074
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
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

event clicked;u_user luo_user

luo_user = user_list.pick_user( )
if not isnull(luo_user) then
	picked_user_id = luo_user.user_id
	text = luo_user.user_full_name
	backcolor = luo_user.color
end if

end event

type st_2 from statictext within w_post_attachment_workplan
integer x = 55
integer y = 1416
integer width = 965
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
string text = "Dispatch Selected Workplan To:"
alignment alignment = right!
boolean focusrectangle = false
end type

