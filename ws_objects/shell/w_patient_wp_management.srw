HA$PBExportHeader$w_patient_wp_management.srw
forward
global type w_patient_wp_management from w_window_base
end type
type st_workplan_type_title from statictext within w_patient_wp_management
end type
type st_workplan_status_title from statictext within w_patient_wp_management
end type
type st_workplan_type from statictext within w_patient_wp_management
end type
type st_workplan_status from statictext within w_patient_wp_management
end type
type cb_dispatch_workplan from commandbutton within w_patient_wp_management
end type
type cb_cancel_workplan from commandbutton within w_patient_wp_management
end type
type dw_workplans from u_dw_pick_list within w_patient_wp_management
end type
type pb_down from picturebutton within w_patient_wp_management
end type
type pb_up from picturebutton within w_patient_wp_management
end type
type st_1 from statictext within w_patient_wp_management
end type
type st_2 from statictext within w_patient_wp_management
end type
type dw_workplan_content from u_dw_pick_list within w_patient_wp_management
end type
type st_page from statictext within w_patient_wp_management
end type
type pb_content_down from picturebutton within w_patient_wp_management
end type
type pb_content_up from picturebutton within w_patient_wp_management
end type
type st_content_title from statictext within w_patient_wp_management
end type
type st_content_page from statictext within w_patient_wp_management
end type
type st_4 from statictext within w_patient_wp_management
end type
type st_3 from statictext within w_patient_wp_management
end type
type cb_finished from commandbutton within w_patient_wp_management
end type
type cb_be_back from commandbutton within w_patient_wp_management
end type
end forward

global type w_patient_wp_management from w_window_base
integer width = 0
integer height = 0
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = 0
string button_type = ""
boolean show_more_buttons = false
boolean auto_resize_window = false
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
real x_factor = 0
real y_factor = 0
st_workplan_type_title st_workplan_type_title
st_workplan_status_title st_workplan_status_title
st_workplan_type st_workplan_type
st_workplan_status st_workplan_status
cb_dispatch_workplan cb_dispatch_workplan
cb_cancel_workplan cb_cancel_workplan
dw_workplans dw_workplans
pb_down pb_down
pb_up pb_up
st_1 st_1
st_2 st_2
dw_workplan_content dw_workplan_content
st_page st_page
pb_content_down pb_content_down
pb_content_up pb_content_up
st_content_title st_content_title
st_content_page st_content_page
st_4 st_4
st_3 st_3
cb_finished cb_finished
cb_be_back cb_be_back
end type
global w_patient_wp_management w_patient_wp_management

type variables
string workplan_type
string workplan_status

u_component_service service

end variables

forward prototypes
public function integer display_workplans ()
end prototypes

public function integer display_workplans ();integer li_count

dw_workplan_content.reset()
pb_content_up.visible = false
pb_content_down.visible = false
st_content_page.visible = false

li_count = dw_workplans.retrieve(current_patient.cpr_id, workplan_type, workplan_status)
if li_count < 0 then return -1

dw_workplans.set_page(1, st_page.text)
if dw_workplans.last_page < 2 then
	pb_up.visible = false
	pb_down.visible = false
	st_page.visible = false
else
	pb_up.visible = true
	pb_down.visible = true
	pb_up.enabled = false
	pb_down.enabled = true
	st_page.visible = true
end if

if li_count > 0 then
	dw_workplans.object.selected_flag[1] = 1
	dw_workplans.event post selected(1)
end if

return li_count


end function

on w_patient_wp_management.create
int iCurrent
call super::create
this.st_workplan_type_title=create st_workplan_type_title
this.st_workplan_status_title=create st_workplan_status_title
this.st_workplan_type=create st_workplan_type
this.st_workplan_status=create st_workplan_status
this.cb_dispatch_workplan=create cb_dispatch_workplan
this.cb_cancel_workplan=create cb_cancel_workplan
this.dw_workplans=create dw_workplans
this.pb_down=create pb_down
this.pb_up=create pb_up
this.st_1=create st_1
this.st_2=create st_2
this.dw_workplan_content=create dw_workplan_content
this.st_page=create st_page
this.pb_content_down=create pb_content_down
this.pb_content_up=create pb_content_up
this.st_content_title=create st_content_title
this.st_content_page=create st_content_page
this.st_4=create st_4
this.st_3=create st_3
this.cb_finished=create cb_finished
this.cb_be_back=create cb_be_back
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_workplan_type_title
this.Control[iCurrent+2]=this.st_workplan_status_title
this.Control[iCurrent+3]=this.st_workplan_type
this.Control[iCurrent+4]=this.st_workplan_status
this.Control[iCurrent+5]=this.cb_dispatch_workplan
this.Control[iCurrent+6]=this.cb_cancel_workplan
this.Control[iCurrent+7]=this.dw_workplans
this.Control[iCurrent+8]=this.pb_down
this.Control[iCurrent+9]=this.pb_up
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.dw_workplan_content
this.Control[iCurrent+13]=this.st_page
this.Control[iCurrent+14]=this.pb_content_down
this.Control[iCurrent+15]=this.pb_content_up
this.Control[iCurrent+16]=this.st_content_title
this.Control[iCurrent+17]=this.st_content_page
this.Control[iCurrent+18]=this.st_4
this.Control[iCurrent+19]=this.st_3
this.Control[iCurrent+20]=this.cb_finished
this.Control[iCurrent+21]=this.cb_be_back
end on

on w_patient_wp_management.destroy
call super::destroy
destroy(this.st_workplan_type_title)
destroy(this.st_workplan_status_title)
destroy(this.st_workplan_type)
destroy(this.st_workplan_status)
destroy(this.cb_dispatch_workplan)
destroy(this.cb_cancel_workplan)
destroy(this.dw_workplans)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.dw_workplan_content)
destroy(this.st_page)
destroy(this.pb_content_down)
destroy(this.pb_content_up)
destroy(this.st_content_title)
destroy(this.st_content_page)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.cb_finished)
destroy(this.cb_be_back)
end on

event open;call super::open;

service = message.powerobjectparm

// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 4
end if

workplan_type = service.get_attribute("WORKPLAN_TYPE")
if isnull(workplan_type) then workplan_type = "Patient"

workplan_status = service.get_attribute("WORKPLAN_STATUS")
if isnull(workplan_status) then workplan_status = "Current"

st_workplan_type.text = workplan_type
st_workplan_status.text = workplan_status

cb_dispatch_workplan.enabled = false
cb_cancel_workplan.enabled = false

dw_workplan_content.settransobject(service.cprdb)
dw_workplans.settransobject(service.cprdb)

display_workplans()



end event

type pb_epro_help from w_window_base`pb_epro_help within w_patient_wp_management
boolean visible = true
integer x = 0
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_patient_wp_management
integer x = 0
integer y = 0
integer width = 0
integer height = 0
integer textsize = 0
integer weight = 0
fontpitch fontpitch = default!
fontfamily fontfamily = anyfont!
string facename = ""
long textcolor = 0
long backcolor = 0
end type

type st_workplan_type_title from statictext within w_patient_wp_management
integer x = 50
integer y = 164
integer width = 640
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
string text = "Workplan Type"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_workplan_status_title from statictext within w_patient_wp_management
integer x = 837
integer y = 164
integer width = 640
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
string text = "Workplan Status"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_workplan_type from statictext within w_patient_wp_management
integer x = 50
integer y = 240
integer width = 640
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 400
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

event clicked;str_popup popup
str_popup_return popup_return
integer li_sts
string ls_button

popup.dataobject = "dw_domain_notranslate_list"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = "WORKPLAN_TYPE"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

workplan_type = popup_return.items[1]
text = popup_return.items[1]

display_workplans()

end event

type st_workplan_status from statictext within w_patient_wp_management
integer x = 837
integer y = 240
integer width = 640
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 400
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

event clicked;str_popup popup
str_popup_return popup_return
integer li_sts
string ls_button

popup.dataobject = "dw_domain_notranslate_list"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = "WORKPLAN_STATUS"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

workplan_status = popup_return.items[1]
text = popup_return.items[1]

display_workplans()

end event

type cb_dispatch_workplan from commandbutton within w_patient_wp_management
integer x = 78
integer y = 1584
integer width = 576
integer height = 112
integer taborder = 11
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Dispatch Workplan"
end type

event clicked;str_popup_return popup_return
long ll_patient_workplan_id
integer li_step_number
long ll_row
string ls_in_office_flag
integer li_count
string ls_description
long ll_encounter_id

 DECLARE lsp_dispatch_workplan_step PROCEDURE FOR dbo.sp_Dispatch_Workplan_Step  
         @ps_cpr_id = :current_patient.cpr_id,   
         @pl_patient_workplan_id = :ll_patient_workplan_id,
         @pi_step_number = :li_step_number,   
         @ps_dispatched_by = :current_user.user_id,   
			@pl_encounter_id = :ll_encounter_id,
         @ps_created_by = :current_scribe.user_id
 USING service.cprdb;


ll_row = dw_workplans.get_selected_row()
if ll_row <= 0 then return

ll_patient_workplan_id = dw_workplans.object.patient_workplan_id[ll_row]
ls_in_office_flag = dw_workplans.object.in_office_flag[ll_row]
ls_description = dw_workplans.object.description[ll_row]

setnull(ll_encounter_id)

// If we're dispatching an in-office workplan, make sure that we already have an in-office encounter
if ls_in_office_flag = "Y" then
	// If there are any in-office encounters, get the latest in-office encounter_id
	
	SELECT max(e.encounter_id), count(*)
	INTO :ll_encounter_id, :li_count
	FROM	p_Patient_WP w (NOLOCK),
			p_Patient_Encounter e (NOLOCK)
	WHERE w.cpr_id = :current_patient.cpr_id
	AND	e.cpr_id = :current_patient.cpr_id
	AND	w.status = 'Current'
	AND	w.in_office_flag = 'Y'
	AND	w.encounter_id = e.encounter_id
	AND	e.encounter_status = 'OPEN'
	USING service.cprdb;
	if not service.cprdb.check() then return
	
	if li_count <= 0 then
		openwithparm(w_pop_message, "You may not dispatch an in-office workplan unless the patient is already in the office")
		return
	end if
else
	// If we're not dispatching an in-office workplan, just use the open_encounter_id
	ll_encounter_id = current_patient.open_encounter_id
end if

openwithparm(w_pop_yes_no, "Are you sure you want to dispatch the workplan '" + ls_description + "'?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

SELECT min(step_number)
INTO :li_step_number
FROM p_Patient_WP_Item
WHERE patient_workplan_id = :ll_patient_workplan_id
AND status IS NULL
USING service.cprdb;
if not service.cprdb.check() then return

EXECUTE lsp_dispatch_workplan_step;
if not service.cprdb.check() then return

openwithparm(w_pop_message, "Workplan '" + ls_description + "' has been dispatched")

display_workplans()

end event

type cb_cancel_workplan from commandbutton within w_patient_wp_management
integer x = 795
integer y = 1584
integer width = 576
integer height = 112
integer taborder = 21
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel Workplan"
end type

event clicked;str_popup_return popup_return
long ll_patient_workplan_id
integer li_step_number
long ll_row
string ls_in_office_flag
integer li_count
string ls_description
long ll_encounter_id
string ls_status
long ll_treatment_id
datetime ldt_progress_date_time
string ls_owned_by

setnull(ll_treatment_id)
setnull(ldt_progress_date_time)
setnull(ls_owned_by)

ll_row = dw_workplans.get_selected_row()
if ll_row <= 0 then return

li_step_number = 1
ll_patient_workplan_id = dw_workplans.object.patient_workplan_id[ll_row]
ls_in_office_flag = dw_workplans.object.in_office_flag[ll_row]
ls_description = dw_workplans.object.description[ll_row]

ll_encounter_id = current_patient.open_encounter_id
ls_status = "Cancelled"

openwithparm(w_pop_yes_no, "Are you sure you want to cancel the workplan '" + ls_description + "'?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

service.cprdb.sp_set_workplan_status( &
		current_patient.cpr_id, &
		ll_encounter_id, &
		ll_treatment_id, &
		ll_patient_workplan_id, &
		ls_status, &
		ldt_progress_date_time, &
		current_user.user_id, &
		ls_owned_by, &
		current_scribe.user_id)

if not service.cprdb.check() then return

openwithparm(w_pop_message, "Workplan '" + ls_description + "' has been cancelled")

display_workplans()

end event

type dw_workplans from u_dw_pick_list within w_patient_wp_management
integer x = 64
integer y = 484
integer width = 1358
integer height = 992
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_patient_workplan_selection"
boolean border = false
end type

event selected;call super::selected;long ll_patient_workplan_id

CHOOSE CASE lower(workplan_status)
	CASE "pending"
		cb_dispatch_workplan.enabled = true
		cb_cancel_workplan.enabled = true
	CASE "current"
		cb_dispatch_workplan.enabled = false
		cb_cancel_workplan.enabled = true
	CASE "completed"
		cb_dispatch_workplan.enabled = false
		cb_cancel_workplan.enabled = false
	CASE "cancelled"
		cb_dispatch_workplan.enabled = false
		cb_cancel_workplan.enabled = false
END CHOOSE

ll_patient_workplan_id = object.patient_workplan_id[selected_row]

dw_workplan_content.settransobject(service.cprdb)
dw_workplan_content.retrieve(ll_patient_workplan_id)

dw_workplan_content.set_page(1, st_content_page.text)
if dw_workplan_content.last_page < 2 then
	pb_content_up.visible = false
	pb_content_down.visible = false
	st_content_page.visible = false
else
	pb_content_up.visible = true
	pb_content_down.visible = true
	pb_content_up.enabled = false
	pb_content_down.enabled = true
	st_content_page.visible = true
end if

end event

event unselected;integer i
long ll_count

cb_dispatch_workplan.enabled = false
cb_cancel_workplan.enabled = false

dw_workplan_content.reset()
pb_content_up.visible = false
pb_content_down.visible = false
st_content_page.visible = false

end event

type pb_down from picturebutton within w_patient_wp_management
integer x = 1115
integer y = 364
integer width = 137
integer height = 116
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
alignment htextalign = left!
end type

event clicked;string ls_text
dw_workplans.set_page(dw_workplans.current_page + 1, st_page.text)
pb_up.enabled = true

if dw_workplans.current_page >= dw_workplans.last_page then
	enabled = false
else
	enabled = true
end if

end event

type pb_up from picturebutton within w_patient_wp_management
integer x = 1266
integer y = 364
integer width = 137
integer height = 116
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
alignment htextalign = left!
end type

event clicked;string ls_text
dw_workplans.set_page(dw_workplans.current_page - 1, st_page.text)
pb_down.enabled = true

if dw_workplans.current_page <= 1 then
	enabled = false
else
	enabled = true
end if

end event

type st_1 from statictext within w_patient_wp_management
integer width = 2926
integer height = 136
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Patient Workplans"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_patient_wp_management
integer x = 87
integer y = 412
integer width = 457
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
string text = "Workplans"
boolean focusrectangle = false
end type

type dw_workplan_content from u_dw_pick_list within w_patient_wp_management
integer x = 1454
integer y = 548
integer width = 1385
integer height = 892
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_patient_workplan_content"
borderstyle borderstyle = styleraised!
end type

type st_page from statictext within w_patient_wp_management
integer x = 690
integer y = 416
integer width = 402
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
alignment alignment = right!
boolean focusrectangle = false
end type

type pb_content_down from picturebutton within w_patient_wp_management
integer x = 2551
integer y = 428
integer width = 137
integer height = 116
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
alignment htextalign = left!
end type

event clicked;string ls_text
dw_workplan_content.set_page(dw_workplan_content.current_page + 1, st_content_page.text)
pb_content_up.enabled = true

if dw_workplan_content.current_page >= dw_workplan_content.last_page then
	enabled = false
else
	enabled = true
end if

end event

type pb_content_up from picturebutton within w_patient_wp_management
integer x = 2702
integer y = 428
integer width = 137
integer height = 116
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
alignment htextalign = left!
end type

event clicked;string ls_text
dw_workplan_content.set_page(dw_workplan_content.current_page - 1, st_content_page.text)
pb_content_down.enabled = true

if dw_workplan_content.current_page <= 1 then
	enabled = false
else
	enabled = true
end if

end event

type st_content_title from statictext within w_patient_wp_management
integer x = 1449
integer y = 480
integer width = 841
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
string text = "Selected Workplan Content"
boolean focusrectangle = false
end type

type st_content_page from statictext within w_patient_wp_management
integer x = 2267
integer y = 480
integer width = 270
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
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_patient_wp_management
integer x = 891
integer y = 1504
integer width = 50
integer height = 56
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "*"
boolean focusrectangle = false
end type

type st_3 from statictext within w_patient_wp_management
integer x = 933
integer y = 1504
integer width = 480
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
string text = "= In-Office Workplan"
boolean focusrectangle = false
end type

type cb_finished from commandbutton within w_patient_wp_management
integer x = 2427
integer y = 1612
integer width = 443
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "CLOSE"

closewithreturn(parent, popup_return)
end event

type cb_be_back from commandbutton within w_patient_wp_management
integer x = 1961
integer y = 1612
integer width = 443
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 0
closewithreturn(parent, popup_return)
end event

