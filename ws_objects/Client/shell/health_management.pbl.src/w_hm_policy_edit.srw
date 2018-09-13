$PBExportHeader$w_hm_policy_edit.srw
forward
global type w_hm_policy_edit from w_window_base
end type
type st_workplan_name from statictext within w_hm_policy_edit
end type
type st_execute_title from statictext within w_hm_policy_edit
end type
type cb_ok from commandbutton within w_hm_policy_edit
end type
type st_class_description from statictext within w_hm_policy_edit
end type
type st_class_description_title from statictext within w_hm_policy_edit
end type
type st_workplan_recipient from statictext within w_hm_policy_edit
end type
type st_before from statictext within w_hm_policy_edit
end type
type cb_cancel from commandbutton within w_hm_policy_edit
end type
type st_title from statictext within w_hm_policy_edit
end type
type st_workplan_user_title from statictext within w_hm_policy_edit
end type
type st_after from statictext within w_hm_policy_edit
end type
type st_whenever from statictext within w_hm_policy_edit
end type
type st_time_offset_amount from statictext within w_hm_policy_edit
end type
type st_days from statictext within w_hm_policy_edit
end type
type st_weeks from statictext within w_hm_policy_edit
end type
type st_months from statictext within w_hm_policy_edit
end type
type st_or from statictext within w_hm_policy_edit
end type
type st_whenever_text from statictext within w_hm_policy_edit
end type
type st_patient_title from statictext within w_hm_policy_edit
end type
type st_policy_event from statictext within w_hm_policy_edit
end type
type cb_edit_workplan from commandbutton within w_hm_policy_edit
end type
end forward

global type w_hm_policy_edit from w_window_base
integer y = 252
integer width = 2917
integer height = 1416
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_workplan_name st_workplan_name
st_execute_title st_execute_title
cb_ok cb_ok
st_class_description st_class_description
st_class_description_title st_class_description_title
st_workplan_recipient st_workplan_recipient
st_before st_before
cb_cancel cb_cancel
st_title st_title
st_workplan_user_title st_workplan_user_title
st_after st_after
st_whenever st_whenever
st_time_offset_amount st_time_offset_amount
st_days st_days
st_weeks st_weeks
st_months st_months
st_or st_or
st_whenever_text st_whenever_text
st_patient_title st_patient_title
st_policy_event st_policy_event
cb_edit_workplan cb_edit_workplan
end type
global w_hm_policy_edit w_hm_policy_edit

type variables
str_hm_policy_edit hm_policy_edit
str_hm_policy policy

end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();string ls_temp
str_c_workplan lstr_workplan
u_user luo_user 

ls_temp = "<Unspecified Workplan>"
cb_edit_workplan.visible = false
if policy.action_workplan_id > 0 then
	lstr_workplan = datalist.get_workplan(policy.action_workplan_id)
	if lstr_workplan.workplan_id > 0 then
		ls_temp = lstr_workplan.description
		cb_edit_workplan.visible = true
	end if
end if
st_workplan_name.text = ls_temp

ls_temp = "<Unspecified User>"
luo_user = user_list.find_user(policy.action_workplan_recipient)
if not isnull(luo_user) then
	ls_temp = luo_user.user_full_name
end if
st_workplan_recipient.text = ls_temp

if isnull(policy.time_offset_amount) or policy.time_offset_amount = 0 then
	st_whenever.backcolor = color_object_selected
	st_days.backcolor = color_object
	st_weeks.backcolor = color_object
	st_months.backcolor = color_object
	st_before.backcolor = color_object
	st_after.backcolor = color_object
	st_days.enabled = false
	st_weeks.enabled = false
	st_months.enabled = false
	st_before.enabled = false
	st_after.enabled = false
	st_time_offset_amount.backcolor = color_object
	st_time_offset_amount.text = "<Amount>"
else
	st_whenever.backcolor = color_object
	st_time_offset_amount.text = string(abs(policy.time_offset_amount))
	st_time_offset_amount.backcolor = color_object_selected

	st_days.enabled = true
	st_weeks.enabled = true
	st_months.enabled = true
	st_before.enabled = true
	st_after.enabled = true
	
	CHOOSE CASE lower(policy.time_offset_unit)
		CASE "day"
			st_days.backcolor = color_object_selected
			st_weeks.backcolor = color_object
			st_months.backcolor = color_object
		CASE "week"
			st_days.backcolor = color_object
			st_weeks.backcolor = color_object_selected
			st_months.backcolor = color_object
		CASE "month"
			st_days.backcolor = color_object
			st_weeks.backcolor = color_object
			st_months.backcolor = color_object_selected
		CASE ELSE
			st_days.backcolor = color_object_selected
			st_weeks.backcolor = color_object
			st_months.backcolor = color_object
			policy.time_offset_unit = "Day"
	END CHOOSE
	
	st_time_offset_amount.text = string(abs(policy.time_offset_amount))
	
	if lower(policy.policy_event) = "becomes not-compliant" or lower(policy.policy_event) = "becomes not-measured" then
		if policy.time_offset_amount < 0 then
			st_before.backcolor = color_object_selected
			st_after.backcolor = color_object
		else
			st_before.backcolor = color_object
			st_after.backcolor = color_object_selected
		end if
	else
		policy.time_offset_amount = abs(policy.time_offset_amount)
		st_before.backcolor = color_object
		st_before.enabled = false
		st_after.backcolor = color_object_selected
	end if
end if



st_policy_event.text = policy.policy_event

return 1


end function

on w_hm_policy_edit.create
int iCurrent
call super::create
this.st_workplan_name=create st_workplan_name
this.st_execute_title=create st_execute_title
this.cb_ok=create cb_ok
this.st_class_description=create st_class_description
this.st_class_description_title=create st_class_description_title
this.st_workplan_recipient=create st_workplan_recipient
this.st_before=create st_before
this.cb_cancel=create cb_cancel
this.st_title=create st_title
this.st_workplan_user_title=create st_workplan_user_title
this.st_after=create st_after
this.st_whenever=create st_whenever
this.st_time_offset_amount=create st_time_offset_amount
this.st_days=create st_days
this.st_weeks=create st_weeks
this.st_months=create st_months
this.st_or=create st_or
this.st_whenever_text=create st_whenever_text
this.st_patient_title=create st_patient_title
this.st_policy_event=create st_policy_event
this.cb_edit_workplan=create cb_edit_workplan
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_workplan_name
this.Control[iCurrent+2]=this.st_execute_title
this.Control[iCurrent+3]=this.cb_ok
this.Control[iCurrent+4]=this.st_class_description
this.Control[iCurrent+5]=this.st_class_description_title
this.Control[iCurrent+6]=this.st_workplan_recipient
this.Control[iCurrent+7]=this.st_before
this.Control[iCurrent+8]=this.cb_cancel
this.Control[iCurrent+9]=this.st_title
this.Control[iCurrent+10]=this.st_workplan_user_title
this.Control[iCurrent+11]=this.st_after
this.Control[iCurrent+12]=this.st_whenever
this.Control[iCurrent+13]=this.st_time_offset_amount
this.Control[iCurrent+14]=this.st_days
this.Control[iCurrent+15]=this.st_weeks
this.Control[iCurrent+16]=this.st_months
this.Control[iCurrent+17]=this.st_or
this.Control[iCurrent+18]=this.st_whenever_text
this.Control[iCurrent+19]=this.st_patient_title
this.Control[iCurrent+20]=this.st_policy_event
this.Control[iCurrent+21]=this.cb_edit_workplan
end on

on w_hm_policy_edit.destroy
call super::destroy
destroy(this.st_workplan_name)
destroy(this.st_execute_title)
destroy(this.cb_ok)
destroy(this.st_class_description)
destroy(this.st_class_description_title)
destroy(this.st_workplan_recipient)
destroy(this.st_before)
destroy(this.cb_cancel)
destroy(this.st_title)
destroy(this.st_workplan_user_title)
destroy(this.st_after)
destroy(this.st_whenever)
destroy(this.st_time_offset_amount)
destroy(this.st_days)
destroy(this.st_weeks)
destroy(this.st_months)
destroy(this.st_or)
destroy(this.st_whenever_text)
destroy(this.st_patient_title)
destroy(this.st_policy_event)
destroy(this.cb_edit_workplan)
end on

event open;call super::open;long ll_count
string ls_value

hm_policy_edit = message.powerobjectparm
policy = hm_policy_edit.policy

st_class_description.text = hm_policy_edit.description

refresh()

end event

event post_open;call super::post_open;//string ls_description
//sle_menu.text = menu_name
//ls_description = datalist.specialty_description(specialty_id)
//st_specialty.text = ls_description
//st_context_object.text = context_object	
//
//sle_menu.setfocus()
end event

type pb_epro_help from w_window_base`pb_epro_help within w_hm_policy_edit
integer x = 2848
integer y = 0
boolean originalsize = false
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_hm_policy_edit
end type

type st_workplan_name from statictext within w_hm_policy_edit
integer x = 750
integer y = 352
integer width = 1783
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "<Unspecified Workplan>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;u_user luo_user
str_c_workplan lstr_workplan
w_pick_workplan lw_window
str_workplan_context lstr_workplan_context

lstr_workplan_context.context_object = "Patient"
lstr_workplan_context.in_office_flag = "N"

openwithparm(lw_window, lstr_workplan_context, "w_pick_workplan")
lstr_workplan = message.powerobjectparm
if isnull(lstr_workplan.workplan_id) then return

policy.action_workplan_id = lstr_workplan.workplan_id

refresh()

end event

type st_execute_title from statictext within w_hm_policy_edit
integer x = 32
integer y = 364
integer width = 686
integer height = 80
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Execute Workplan"
alignment alignment = right!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_hm_policy_edit
integer x = 2459
integer y = 1268
integer width = 402
integer height = 112
integer taborder = 31
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;hm_policy_edit.policy = policy

hm_policy_edit.return_status = "OK"

closewithreturn(parent, hm_policy_edit)

end event

type st_class_description from statictext within w_hm_policy_edit
integer x = 347
integer y = 176
integer width = 2391
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
boolean focusrectangle = false
end type

event clicked;//str_popup popup
//str_popup_return popup_return
//
//popup.dataobject = "dw_specialty_list"
//popup.datacolumn = 2
//popup.displaycolumn = 1
//popup.add_blank_row = true
//popup.blank_text = "<None>"
//openwithparm(w_pop_pick, popup)
//popup_return = message.powerobjectparm
//if popup_return.item_count <> 1 then return
//
//
//if popup_return.items[1] = "" then
//	text = "<None>"
//	setnull(specialty_id)
//else
//	text = popup_return.descriptions[1]
//	specialty_id = popup_return.items[1]
//end if
end event

type st_class_description_title from statictext within w_hm_policy_edit
integer x = 96
integer y = 192
integer width = 238
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Class"
alignment alignment = right!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_workplan_recipient from statictext within w_hm_policy_edit
integer x = 750
integer y = 496
integer width = 1783
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "<Unspecified Recipient>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;u_user luo_user

luo_user = user_list.pick_user( true, true, true)
if isnull(luo_user) then return

policy.action_workplan_recipient = luo_user.user_id

refresh()

end event

type st_before from statictext within w_hm_policy_edit
integer x = 2080
integer y = 896
integer width = 279
integer height = 88
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Before"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;
policy.time_offset_amount = -abs(policy.time_offset_amount)

refresh()

end event

type cb_cancel from commandbutton within w_hm_policy_edit
integer x = 32
integer y = 1268
integer width = 402
integer height = 112
integer taborder = 41
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

event clicked;
hm_policy_edit.return_status = "CANCEL"

closewithreturn(parent, hm_policy_edit)

end event

type st_title from statictext within w_hm_policy_edit
integer width = 2917
integer height = 132
boolean bringtotop = true
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Class Policy Definition"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_workplan_user_title from statictext within w_hm_policy_edit
integer x = 366
integer y = 508
integer width = 352
integer height = 80
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "For User"
alignment alignment = right!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_after from statictext within w_hm_policy_edit
integer x = 2373
integer y = 896
integer width = 279
integer height = 88
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "After"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;
policy.time_offset_amount = abs(policy.time_offset_amount)

refresh()

end event

type st_whenever from statictext within w_hm_policy_edit
integer x = 1275
integer y = 696
integer width = 361
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Whenever"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;
setnull(policy.time_offset_amount)

refresh()


end event

type st_time_offset_amount from statictext within w_hm_policy_edit
integer x = 443
integer y = 896
integer width = 361
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "<Amount>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup 			popup
str_popup_return	popup_return

popup.realitem = real(policy.time_offset_amount)
Openwithparm(w_number,popup)

popup_return = Message.powerobjectparm

If popup_return.item = "CANCEL" Then Return

policy.time_offset_amount = long(popup_return.realitem)

refresh()


end event

type st_days from statictext within w_hm_policy_edit
integer x = 1024
integer y = 896
integer width = 279
integer height = 88
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Days"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;
policy.time_offset_unit = "Day"

refresh()


end event

type st_weeks from statictext within w_hm_policy_edit
integer x = 1317
integer y = 896
integer width = 279
integer height = 88
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Weeks"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;
policy.time_offset_unit = "Week"

refresh()


end event

type st_months from statictext within w_hm_policy_edit
integer x = 1609
integer y = 896
integer width = 279
integer height = 88
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Months"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;
policy.time_offset_unit = "Month"

refresh()


end event

type st_or from statictext within w_hm_policy_edit
integer x = 1275
integer y = 800
integer width = 361
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 33538240
string text = "OR"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_whenever_text from statictext within w_hm_policy_edit
integer x = 1719
integer y = 700
integer width = 475
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "(No Time Offset)"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_patient_title from statictext within w_hm_policy_edit
integer x = 567
integer y = 1104
integer width = 361
integer height = 80
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Patient"
alignment alignment = right!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_policy_event from statictext within w_hm_policy_edit
integer x = 955
integer y = 1092
integer width = 1001
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Enters Class"
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
popup.argument[1] = "Health Maintenance Event"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

policy.policy_event = popup_return.items[1]

refresh()

end event

type cb_edit_workplan from commandbutton within w_hm_policy_edit
integer x = 2542
integer y = 396
integer width = 160
integer height = 64
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Edit"
end type

event clicked;w_window_base lw_edit_window
str_popup popup
long ll_workplan_id
string ls_id

ll_workplan_id = policy.action_workplan_id
if isnull(ll_workplan_id) or ll_workplan_id <= 0 then return

SELECT CAST(id AS varchar(40))
INTO :ls_id
FROM c_workplan
WHERE workplan_id = :ll_workplan_id;
if not tf_check() then return
if sqlca.sqlcode = 100 then return

popup.data_row_count = 2
popup.items[1] = ls_id
popup.items[2] = "true"

openwithparm(lw_edit_window, popup, "w_Workplan_definition_display")

end event

