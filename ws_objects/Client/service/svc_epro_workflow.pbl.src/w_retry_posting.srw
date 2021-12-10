$PBExportHeader$w_retry_posting.srw
forward
global type w_retry_posting from w_window_base
end type
type cb_be_back from commandbutton within w_retry_posting
end type
type cb_done from commandbutton within w_retry_posting
end type
type cb_retry_posting from commandbutton within w_retry_posting
end type
type st_1 from statictext within w_retry_posting
end type
type st_encounter_description from statictext within w_retry_posting
end type
type st_date_title from statictext within w_retry_posting
end type
type st_encounter_date from statictext within w_retry_posting
end type
type dw_posting_history from u_dw_pick_list within w_retry_posting
end type
type dw_fail from u_dw_pick_list within w_retry_posting
end type
type st_fail from statictext within w_retry_posting
end type
type cb_refresh from commandbutton within w_retry_posting
end type
type cb_cancel from commandbutton within w_retry_posting
end type
end forward

global type w_retry_posting from w_window_base
string title = "Retry Posting"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_be_back cb_be_back
cb_done cb_done
cb_retry_posting cb_retry_posting
st_1 st_1
st_encounter_description st_encounter_description
st_date_title st_date_title
st_encounter_date st_encounter_date
dw_posting_history dw_posting_history
dw_fail dw_fail
st_fail st_fail
cb_refresh cb_refresh
cb_cancel cb_cancel
end type
global w_retry_posting w_retry_posting

type variables
u_component_service service

string posting_service
string ordered_for
boolean billable = true

end variables

forward prototypes
public function integer display_posting_history ()
public function integer display_failure_history ()
end prototypes

public function integer display_posting_history ();integer li_sts

li_sts = dw_posting_history.retrieve(current_patient.cpr_id, service.encounter_id, posting_service)


return li_sts

end function

public function integer display_failure_history ();integer li_sts

li_sts = dw_fail.retrieve(current_patient.cpr_id, service.encounter_id)
if li_sts > 0 Then
	dw_fail.visible = true
	st_fail.visible = true
else
	dw_fail.visible = true
	st_fail.visible = true
end if
return li_sts
end function

on w_retry_posting.create
int iCurrent
call super::create
this.cb_be_back=create cb_be_back
this.cb_done=create cb_done
this.cb_retry_posting=create cb_retry_posting
this.st_1=create st_1
this.st_encounter_description=create st_encounter_description
this.st_date_title=create st_date_title
this.st_encounter_date=create st_encounter_date
this.dw_posting_history=create dw_posting_history
this.dw_fail=create dw_fail
this.st_fail=create st_fail
this.cb_refresh=create cb_refresh
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_be_back
this.Control[iCurrent+2]=this.cb_done
this.Control[iCurrent+3]=this.cb_retry_posting
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_encounter_description
this.Control[iCurrent+6]=this.st_date_title
this.Control[iCurrent+7]=this.st_encounter_date
this.Control[iCurrent+8]=this.dw_posting_history
this.Control[iCurrent+9]=this.dw_fail
this.Control[iCurrent+10]=this.st_fail
this.Control[iCurrent+11]=this.cb_refresh
this.Control[iCurrent+12]=this.cb_cancel
end on

on w_retry_posting.destroy
call super::destroy
destroy(this.cb_be_back)
destroy(this.cb_done)
destroy(this.cb_retry_posting)
destroy(this.st_1)
destroy(this.st_encounter_description)
destroy(this.st_date_title)
destroy(this.st_encounter_date)
destroy(this.dw_posting_history)
destroy(this.dw_fail)
destroy(this.st_fail)
destroy(this.cb_refresh)
destroy(this.cb_cancel)
end on

event post_open;call super::post_open;string ls_billing_posted,ls_bill_flag

SELECT billing_posted,
	bill_flag
INTO :ls_billing_posted,
		:ls_bill_flag
FROM p_Patient_Encounter
WHERE cpr_id = :current_patient.cpr_id
AND encounter_id = :current_patient.open_encounter_id;

If ls_bill_flag = 'Y' Then
	billable = true
	// if the bill is sent or accepted 
	If ls_billing_posted = 'Y' or ls_billing_posted = 'A' Then
		cb_cancel.visible = false
	else
		cb_cancel.visible = true
	End If
else
	billable = false
End If

display_posting_history()
display_failure_history()

end event

event open;call super::open;str_popup_return popup_return
long ll_menu_id
str_encounter_description lstr_encounter
integer li_sts

popup_return.item_count = 0

service = message.powerobjectparm


if isnull(service.encounter_id) then
	log.log(this, "w_retry_posting:open", "Null encounter_id", 4)
	closewithreturn(this, popup_return)
	return
end if

title = current_patient.id_line()

li_sts = current_patient.encounters.encounter(lstr_encounter, service.encounter_id)
if li_sts <= 0 then
	log.log(this, "w_retry_posting:open", "Inavlid encounter_id (" + string(service.encounter_id) + ")", 4)
	closewithreturn(this, popup_return)
	return
end if

st_encounter_description.text = lstr_encounter.description
st_encounter_date.text = string(lstr_encounter.encounter_date, date_format_string)

// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 4
end if

ll_menu_id = long(service.get_attribute("menu_id"))
paint_menu(ll_menu_id)

dw_posting_history.settransobject(sqlca)
dw_fail.settransobject(sqlca)

posting_service = service.get_attribute("posting_service")
if isnull(posting_service) then posting_service = "SENDBILLING"

ordered_for = service.get_attribute("ordered_for")
if isnull(ordered_for) then ordered_for = "#BILL"

postevent("post_open")
//timer(2)

end event

type pb_epro_help from w_window_base`pb_epro_help within w_retry_posting
integer x = 2857
integer y = 1296
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_retry_posting
end type

type cb_be_back from commandbutton within w_retry_posting
integer x = 1961
integer y = 1564
integer width = 443
integer height = 108
integer taborder = 70
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

type cb_done from commandbutton within w_retry_posting
integer x = 2427
integer y = 1564
integer width = 443
integer height = 108
integer taborder = 80
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
integer li_sts

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type cb_retry_posting from commandbutton within w_retry_posting
integer x = 1600
integer y = 1564
integer width = 809
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Retry Posting"
end type

event clicked;integer li_sts
String ls_cpr_id,ls_find
Long ll_encounter_id,ll_find

ls_find = "status = 'DISPATCHED' OR status = 'STARTED'"
ll_find = dw_posting_history.find(ls_find, 1,dw_posting_history.rowcount())
if ll_find > 0 Then 
	Openwithparm(w_pop_message,"Billing request is already queued up")
	return
end if
ls_cpr_id = current_patient.cpr_id
ll_encounter_id = current_patient.open_encounter_id

UPDATE p_Patient_Encounter
SET billing_posted = 'R'
WHERE cpr_id = :ls_cpr_id
AND encounter_id = :ll_encounter_id;
if not tf_check() then return -1

li_sts = service_list.order_service(current_patient.cpr_id, service.encounter_id, posting_service, ordered_for, "Post Billing")

display_posting_history()

end event

type st_1 from statictext within w_retry_posting
integer x = 229
integer y = 344
integer width = 603
integer height = 84
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Posting History"
boolean focusrectangle = false
end type

type st_encounter_description from statictext within w_retry_posting
integer width = 2921
integer height = 196
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Encounter Description"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_date_title from statictext within w_retry_posting
integer x = 773
integer y = 256
integer width = 507
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Encounter Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_encounter_date from statictext within w_retry_posting
integer x = 1307
integer y = 244
integer width = 576
integer height = 88
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "12/12/2000"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type dw_posting_history from u_dw_pick_list within w_retry_posting
integer x = 229
integer y = 432
integer width = 2520
integer height = 548
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_encounter_service_history"
boolean vscrollbar = true
end type

event clicked;call super::clicked;long ll_attachment_id


if isnull(row) or row <= 0 then return

ll_attachment_id = object.attachment_id[row]
if isnull(ll_attachment_id) or ll_attachment_id <= 0 then return

f_display_attachment(ll_attachment_id)

return

end event

type dw_fail from u_dw_pick_list within w_retry_posting
boolean visible = false
integer x = 229
integer y = 1056
integer width = 2519
integer height = 448
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_sp_get_posting_failure_reasons"
boolean vscrollbar = true
boolean hsplitscroll = true
end type

type st_fail from statictext within w_retry_posting
boolean visible = false
integer x = 229
integer y = 992
integer width = 585
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16776960
long backcolor = 7191717
string text = "Failure Reasons"
boolean focusrectangle = false
end type

type cb_refresh from commandbutton within w_retry_posting
integer x = 2464
integer y = 248
integer width = 402
integer height = 112
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Refresh"
end type

event clicked;display_posting_history()
display_failure_history()

end event

type cb_cancel from commandbutton within w_retry_posting
boolean visible = false
integer x = 137
integer y = 1564
integer width = 809
integer height = 112
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Not Billable"
end type

event clicked;String ls_cpr_id,ls_reason
Long ll_encounter_id
str_popup	popup
str_popup_return popup_return

popup.title = 'Enter Reason to Cancel the Billing:'
popup.multiselect = false // required reason for cancellation

Openwithparm(w_pop_prompt_string,popup)
popup_return = message.powerobjectparm

if popup_return.item_count <> 1 then 
	setnull(ls_reason)
else
	ls_reason = popup_return.items[1]
end if
// Now cancel the billing 
ls_cpr_id = current_patient.cpr_id
ll_encounter_id = current_patient.open_encounter_id

UPDATE p_Patient_Encounter
SET billing_posted = 'N',
bill_flag = 'N'
WHERE cpr_id = :ls_cpr_id
AND encounter_id = :ll_encounter_id;
if not tf_check() then return -1

// Cancel the queued up tasks (if any) and update with reason
UPDATE o_Message_Log
SET status = 'CANCELLED',
comments = :ls_reason
WHERE cpr_id = :ls_cpr_id
AND encounter_id = :ll_encounter_id
AND status not in('ACK_WAIT','SENT');
if not tf_check() then return -1

end event

