HA$PBExportHeader$u_tabpage_hm_class_patients.sru
forward
global type u_tabpage_hm_class_patients from u_tabpage_hm_class_base
end type
type st_control_all from statictext within u_tabpage_hm_class_patients
end type
type st_control_no from statictext within u_tabpage_hm_class_patients
end type
type st_control_yes from statictext within u_tabpage_hm_class_patients
end type
type st_control_title from statictext within u_tabpage_hm_class_patients
end type
type st_control_unmeasured from statictext within u_tabpage_hm_class_patients
end type
type st_protocol_all from statictext within u_tabpage_hm_class_patients
end type
type st_protocol_title from statictext within u_tabpage_hm_class_patients
end type
type st_on_protocol from statictext within u_tabpage_hm_class_patients
end type
type st_off_protocol from statictext within u_tabpage_hm_class_patients
end type
type st_status_all from statictext within u_tabpage_hm_class_patients
end type
type st_status_active from statictext within u_tabpage_hm_class_patients
end type
type st_status_title from statictext within u_tabpage_hm_class_patients
end type
type cb_recalc from commandbutton within u_tabpage_hm_class_patients
end type
type cb_select_none from commandbutton within u_tabpage_hm_class_patients
end type
type cb_select_all from commandbutton within u_tabpage_hm_class_patients
end type
type cb_chart_note from commandbutton within u_tabpage_hm_class_patients
end type
type cb_document from commandbutton within u_tabpage_hm_class_patients
end type
type cb_chart_alert from commandbutton within u_tabpage_hm_class_patients
end type
type cb_order_followup from commandbutton within u_tabpage_hm_class_patients
end type
type cb_order_task from commandbutton within u_tabpage_hm_class_patients
end type
type cb_export from commandbutton within u_tabpage_hm_class_patients
end type
type st_title from statictext within u_tabpage_hm_class_patients
end type
type dw_patients from u_dw_pick_list within u_tabpage_hm_class_patients
end type
end forward

global type u_tabpage_hm_class_patients from u_tabpage_hm_class_base
integer width = 3168
st_control_all st_control_all
st_control_no st_control_no
st_control_yes st_control_yes
st_control_title st_control_title
st_control_unmeasured st_control_unmeasured
st_protocol_all st_protocol_all
st_protocol_title st_protocol_title
st_on_protocol st_on_protocol
st_off_protocol st_off_protocol
st_status_all st_status_all
st_status_active st_status_active
st_status_title st_status_title
cb_recalc cb_recalc
cb_select_none cb_select_none
cb_select_all cb_select_all
cb_chart_note cb_chart_note
cb_document cb_document
cb_chart_alert cb_chart_alert
cb_order_followup cb_order_followup
cb_order_task cb_order_task
cb_export cb_export
st_title st_title
dw_patients dw_patients
end type
global u_tabpage_hm_class_patients u_tabpage_hm_class_patients

type variables
boolean first_time = true

string status_filter = "Active"

string on_protocol_filter = "All"

string is_controlled_filter = "All"

end variables

forward prototypes
public subroutine refresh ()
public function integer initialize (str_hm_context pstr_hm_context, long pl_index)
end prototypes

public subroutine refresh ();long ll_count
integer li_please_wait
string ls_filter

li_please_wait = f_please_wait_open()
sqlca.jmj_HM_Reset_Patient_List(hmclasstab.hm_class.maintenance_rule_id)
if not tf_check() then
	f_please_wait_close(li_please_wait)
	return
end if

st_status_active.backcolor = color_object
st_status_all.backcolor = color_object
st_on_protocol.backcolor = color_object
st_off_protocol.backcolor = color_object
st_protocol_all.backcolor = color_object

st_control_yes.backcolor = color_object
st_control_no.backcolor = color_object
st_control_unmeasured.backcolor = color_object
st_control_all.backcolor = color_object

ls_filter = ""

if lower(status_filter) = "active" then
	if len(ls_filter) > 0 then ls_filter += " and "
	ls_filter += "lower(patient_status)='active'"
	st_status_active.backcolor = color_object_selected
else
	st_status_all.backcolor = color_object_selected
end if

if lower(on_protocol_filter) = "on" then
	if len(ls_filter) > 0 then ls_filter += " and "
	ls_filter += "upper(on_protocol_flag)='Y'"
	st_on_protocol.backcolor = color_object_selected
elseif lower(on_protocol_filter) = "off" then
	if len(ls_filter) > 0 then ls_filter += " and "
	ls_filter += "upper(on_protocol_flag)='N'"
	st_off_protocol.backcolor = color_object_selected
else
	st_protocol_all.backcolor = color_object_selected
end if

if lower(is_controlled_filter) = "y" then
	if len(ls_filter) > 0 then ls_filter += " and "
	ls_filter += "upper(is_controlled)='Y'"
	st_control_yes.backcolor = color_object_selected
elseif lower(is_controlled_filter) = "n" then
	if len(ls_filter) > 0 then ls_filter += " and "
	ls_filter += "upper(is_controlled)='N'"
	st_control_no.backcolor = color_object_selected
elseif lower(is_controlled_filter) = "x" then
	if len(ls_filter) > 0 then ls_filter += " and "
	ls_filter += "upper(is_controlled)='X'"
	st_control_unmeasured.backcolor = color_object_selected
else
	st_control_all.backcolor = color_object_selected
end if

dw_patients.setfilter(ls_filter)

ll_count = dw_patients.retrieve(hmclasstab.hm_class.maintenance_rule_id)

f_please_wait_close(li_please_wait)

end subroutine

public function integer initialize (str_hm_context pstr_hm_context, long pl_index);long ll_x

st_title.width = width

dw_patients.x = ((width - dw_patients.width) / 2) + 110
dw_patients.height = height - 300

ll_x = dw_patients.x - cb_select_all.width - 16
if ll_x < 8 then
	dw_patients.x += (8 - ll_x)
	ll_x = 8
end if

cb_recalc.x = dw_patients.x + dw_patients.width - cb_recalc.width

st_status_title.x = ll_x
st_status_title.y = dw_patients.y - 76
st_status_active.x = ll_x
st_status_active.y = dw_patients.y
st_status_all.x = ll_x
st_status_all.y = st_status_active.y + st_status_active.height + 20

st_protocol_title.x = ll_x
st_protocol_title.y = st_status_all.y + st_status_all.height + 140
st_on_protocol.x = ll_x
st_on_protocol.y = st_protocol_title.y + st_protocol_title.height + 4
st_off_protocol.x = ll_x
st_off_protocol.y = st_on_protocol.y + st_on_protocol.height + 20
st_protocol_all.x = ll_x
st_protocol_all.y = st_off_protocol.y + st_off_protocol.height + 20

st_control_title.x = ll_x
st_control_title.y = st_protocol_all.y + st_protocol_all.height + 140
st_control_yes.x = ll_x
st_control_yes.y = st_control_title.y + st_control_title.height + 4
st_control_no.x = ll_x
st_control_no.y = st_control_yes.y + st_control_yes.height + 20
st_control_unmeasured.x = ll_x
st_control_unmeasured.y = st_control_no.y + st_control_no.height + 20
st_control_all.x = ll_x
st_control_all.y = st_control_unmeasured.y + st_control_unmeasured.height + 20

cb_select_all.x = ll_x
cb_select_none.x = ll_x
if dw_patients.y + dw_patients.height - st_control_all.y - st_control_all.height > 300 then
	// align the select buttons with the bottom of the patients datawindow
	cb_select_none.y = dw_patients.y + dw_patients.height - cb_select_none.height
	cb_select_all.y = cb_select_none.y - cb_select_all.height - 20
else
	// space the select buttons after the st_control_all button
	cb_select_all.y = st_control_all.y + st_control_all.height + 100
	cb_select_none.y = cb_select_all.y + cb_select_all.height + 20
end if



cb_export.x = dw_patients.x
cb_export.y = dw_patients.y + dw_patients.height + 36

cb_order_task.x = cb_export.x + cb_export.width + 64
cb_order_task.y = cb_export.y
cb_order_followup.x = cb_order_task.x + cb_order_task.width + 64
cb_order_followup.y = cb_export.y
cb_chart_alert.x = cb_order_followup.x + cb_order_followup.width + 64
cb_chart_alert.y = cb_export.y
cb_document.x = cb_chart_alert.x + cb_chart_alert.width + 64
cb_document.y = cb_export.y
cb_chart_note.x = cb_document.x + cb_document.width + 64
cb_chart_note.y = cb_export.y



dw_patients.settransobject(sqlca)

return 1

end function

on u_tabpage_hm_class_patients.create
int iCurrent
call super::create
this.st_control_all=create st_control_all
this.st_control_no=create st_control_no
this.st_control_yes=create st_control_yes
this.st_control_title=create st_control_title
this.st_control_unmeasured=create st_control_unmeasured
this.st_protocol_all=create st_protocol_all
this.st_protocol_title=create st_protocol_title
this.st_on_protocol=create st_on_protocol
this.st_off_protocol=create st_off_protocol
this.st_status_all=create st_status_all
this.st_status_active=create st_status_active
this.st_status_title=create st_status_title
this.cb_recalc=create cb_recalc
this.cb_select_none=create cb_select_none
this.cb_select_all=create cb_select_all
this.cb_chart_note=create cb_chart_note
this.cb_document=create cb_document
this.cb_chart_alert=create cb_chart_alert
this.cb_order_followup=create cb_order_followup
this.cb_order_task=create cb_order_task
this.cb_export=create cb_export
this.st_title=create st_title
this.dw_patients=create dw_patients
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_control_all
this.Control[iCurrent+2]=this.st_control_no
this.Control[iCurrent+3]=this.st_control_yes
this.Control[iCurrent+4]=this.st_control_title
this.Control[iCurrent+5]=this.st_control_unmeasured
this.Control[iCurrent+6]=this.st_protocol_all
this.Control[iCurrent+7]=this.st_protocol_title
this.Control[iCurrent+8]=this.st_on_protocol
this.Control[iCurrent+9]=this.st_off_protocol
this.Control[iCurrent+10]=this.st_status_all
this.Control[iCurrent+11]=this.st_status_active
this.Control[iCurrent+12]=this.st_status_title
this.Control[iCurrent+13]=this.cb_recalc
this.Control[iCurrent+14]=this.cb_select_none
this.Control[iCurrent+15]=this.cb_select_all
this.Control[iCurrent+16]=this.cb_chart_note
this.Control[iCurrent+17]=this.cb_document
this.Control[iCurrent+18]=this.cb_chart_alert
this.Control[iCurrent+19]=this.cb_order_followup
this.Control[iCurrent+20]=this.cb_order_task
this.Control[iCurrent+21]=this.cb_export
this.Control[iCurrent+22]=this.st_title
this.Control[iCurrent+23]=this.dw_patients
end on

on u_tabpage_hm_class_patients.destroy
call super::destroy
destroy(this.st_control_all)
destroy(this.st_control_no)
destroy(this.st_control_yes)
destroy(this.st_control_title)
destroy(this.st_control_unmeasured)
destroy(this.st_protocol_all)
destroy(this.st_protocol_title)
destroy(this.st_on_protocol)
destroy(this.st_off_protocol)
destroy(this.st_status_all)
destroy(this.st_status_active)
destroy(this.st_status_title)
destroy(this.cb_recalc)
destroy(this.cb_select_none)
destroy(this.cb_select_all)
destroy(this.cb_chart_note)
destroy(this.cb_document)
destroy(this.cb_chart_alert)
destroy(this.cb_order_followup)
destroy(this.cb_order_task)
destroy(this.cb_export)
destroy(this.st_title)
destroy(this.dw_patients)
end on

type st_control_all from statictext within u_tabpage_hm_class_patients
integer y = 1172
integer width = 302
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "All"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;is_controlled_filter = "All"
refresh()

end event

type st_control_no from statictext within u_tabpage_hm_class_patients
integer y = 988
integer width = 302
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "No (*)"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;is_controlled_filter = "N"
refresh()

end event

type st_control_yes from statictext within u_tabpage_hm_class_patients
integer y = 896
integer width = 302
integer height = 72
integer textsize = -8
integer weight = 400
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

event clicked;is_controlled_filter = "Y"
refresh()

end event

type st_control_title from statictext within u_tabpage_hm_class_patients
integer y = 820
integer width = 302
integer height = 68
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 33538240
string text = "Control"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_control_unmeasured from statictext within u_tabpage_hm_class_patients
integer y = 1080
integer width = 302
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Unmeasured"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;is_controlled_filter = "X"
refresh()

end event

type st_protocol_all from statictext within u_tabpage_hm_class_patients
integer y = 656
integer width = 302
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "All"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;on_protocol_filter = "All"
refresh()

end event

type st_protocol_title from statictext within u_tabpage_hm_class_patients
integer y = 396
integer width = 302
integer height = 68
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 33538240
string text = "Protocol"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_on_protocol from statictext within u_tabpage_hm_class_patients
integer y = 472
integer width = 302
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "On Prot"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;on_protocol_filter = "On"
refresh()

end event

type st_off_protocol from statictext within u_tabpage_hm_class_patients
integer y = 564
integer width = 302
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Off Prot (*)"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;on_protocol_filter = "Off"
refresh()

end event

type st_status_all from statictext within u_tabpage_hm_class_patients
integer y = 220
integer width = 302
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "All"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;status_filter = "All"
refresh()

end event

type st_status_active from statictext within u_tabpage_hm_class_patients
integer y = 128
integer width = 302
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Active"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;status_filter = "Active"
refresh()

end event

type st_status_title from statictext within u_tabpage_hm_class_patients
integer y = 52
integer width = 302
integer height = 68
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 33538240
string text = "Status"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_recalc from commandbutton within u_tabpage_hm_class_patients
integer x = 2848
integer y = 36
integer width = 302
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recalc"
end type

event clicked;long ll_count
integer li_please_wait

li_please_wait = f_please_wait_open()
sqlca.jmj_HM_Reset_Patient_List(hmclasstab.hm_class.maintenance_rule_id)
if not tf_check() then
	f_please_wait_close(li_please_wait)
	return
end if

ll_count = dw_patients.retrieve(hmclasstab.hm_class.maintenance_rule_id)

f_please_wait_close(li_please_wait)

end event

type cb_select_none from commandbutton within u_tabpage_hm_class_patients
integer y = 1428
integer width = 302
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select None"
end type

event clicked;long i

for i = 1 to dw_patients.rowcount()
	dw_patients.object.selected_flag[i] = 0
next

end event

type cb_select_all from commandbutton within u_tabpage_hm_class_patients
integer y = 1320
integer width = 302
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select All"
end type

event clicked;long i

for i = 1 to dw_patients.rowcount()
	dw_patients.object.selected_flag[i] = 1
next

end event

type cb_chart_note from commandbutton within u_tabpage_hm_class_patients
integer x = 2747
integer y = 1372
integer width = 402
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Chart Note"
end type

type cb_document from commandbutton within u_tabpage_hm_class_patients
integer x = 2281
integer y = 1372
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Document"
end type

type cb_chart_alert from commandbutton within u_tabpage_hm_class_patients
integer x = 1815
integer y = 1372
integer width = 402
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Chart Alert"
end type

event clicked;str_popup popup
str_popup_return popup_return
long ll_row
string ls_alert_category_id
string ls_alert_text
string ls_find
long ll_rowcount
string ls_cpr_id
datetime ldt_now
long ll_alert_count
integer li_please_wait

popup.data_row_count = 2
popup.items[1] = "Alert"
popup.items[2] = "Reminder"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_alert_category_id = popup_return.items[1]

popup.title = "Enter New " + wordcap(ls_alert_category_id)
popup.item = ""
popup.data_row_count = 0
openwithparm(w_pop_prompt_string_multiline, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return
ls_alert_text = popup_return.items[1]

ll_alert_count = 0
ldt_now = datetime(today(), now())
ls_find = "selected_flag=1"
ll_rowcount = dw_patients.rowcount( )

li_please_wait = f_please_wait_open()
f_please_wait_progress_bar(li_please_wait, 0, ll_rowcount)

ll_row = dw_patients.find(ls_find, 1, ll_rowcount)
DO WHILE ll_row > 0 AND ll_row <= ll_rowcount
	ls_cpr_id = dw_patients.object.cpr_id[ll_row]
	
	INSERT INTO p_Chart_Alert (
		cpr_id,
		ordered_by,
		created_by,
		begin_date,
		created,
		alert_text,
		alert_category_id)
	VALUES (
		:ls_cpr_id,
		:current_user.user_id,
		:current_scribe.user_id,
		:ldt_now,
		:ldt_now,
		:ls_alert_text,
		:ls_alert_category_id);
	if not tf_check() then return -1
	
	ll_alert_count += 1
	f_please_wait_progress_bar(li_please_wait, ll_row, ll_rowcount)
	
	ll_row = dw_patients.find(ls_find, ll_row + 1, ll_rowcount + 1)
LOOP

f_please_wait_close(li_please_wait)

if ll_alert_count > 0 then
	openwithparm(w_pop_message, "Successfully ordered " + string(ll_alert_count) + " " + lower(ls_alert_category_id) + "s")
else
	openwithparm(w_pop_message, "No patients selected")
end if



end event

type cb_order_followup from commandbutton within u_tabpage_hm_class_patients
integer x = 1243
integer y = 1372
integer width = 507
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Order Followup"
end type

type cb_order_task from commandbutton within u_tabpage_hm_class_patients
integer x = 777
integer y = 1372
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Order Task"
end type

event clicked;long ll_row
string ls_find
long ll_rowcount
string ls_patient_list
str_service_info lstr_service
integer li_sts

ls_find = "selected_flag=1"
ll_rowcount = dw_patients.rowcount( )
ls_patient_list = ""

ll_row = dw_patients.find(ls_find, 1, ll_rowcount)
DO WHILE ll_row > 0 AND ll_row <= ll_rowcount
	if len(ls_patient_list) > 0 then
		ls_patient_list += "|"
	end if
	ls_patient_list += dw_patients.object.cpr_id[ll_row]
	ll_row = dw_patients.find(ls_find, ll_row + 1, ll_rowcount + 1)
LOOP

if ls_patient_list = "" then
	openwithparm(w_pop_message, "No patients selected")
	return
end if

lstr_service.service = "SENDTODO"
f_attribute_add_attribute(lstr_service.attributes, "patient_list", ls_patient_list)
f_attribute_add_attribute(lstr_service.attributes, "message_in_office_flag", "N")

li_sts = service_list.do_service(lstr_service)
if li_sts < 0 then
	openwithparm(w_pop_message, "An error occured ordering tasks")
	return
end if


end event

type cb_export from commandbutton within u_tabpage_hm_class_patients
integer x = 311
integer y = 1372
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Export"
end type

event clicked;
dw_patients.setredraw(false)
dw_patients.setfilter("selected_flag=1")
dw_patients.filter()
dw_patients.saveas()
dw_patients.setfilter("")
dw_patients.filter()
dw_patients.setredraw(true)

end event

type st_title from statictext within u_tabpage_hm_class_patients
integer width = 3182
integer height = 108
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Patient List"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_patients from u_dw_pick_list within u_tabpage_hm_class_patients
integer x = 311
integer y = 128
integer width = 2839
integer taborder = 10
string dataobject = "dw_hm_patient_list"
boolean vscrollbar = true
boolean multiselect = true
end type

