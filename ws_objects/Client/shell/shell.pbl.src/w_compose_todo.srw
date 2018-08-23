$PBExportHeader$w_compose_todo.srw
forward
global type w_compose_todo from w_window_base
end type
type pb_done from u_picture_button within w_compose_todo
end type
type pb_cancel from u_picture_button within w_compose_todo
end type
type st_title from statictext within w_compose_todo
end type
type st_subject_title from statictext within w_compose_todo
end type
type sle_subject from singlelineedit within w_compose_todo
end type
type st_3 from statictext within w_compose_todo
end type
type st_recipient from statictext within w_compose_todo
end type
type st_message_title from statictext within w_compose_todo
end type
type mle_message from multilineedit within w_compose_todo
end type
type st_patient_title from statictext within w_compose_todo
end type
type st_patient from statictext within w_compose_todo
end type
type cb_send from commandbutton within w_compose_todo
end type
end forward

global type w_compose_todo from w_window_base
boolean titlebar = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_done pb_done
pb_cancel pb_cancel
st_title st_title
st_subject_title st_subject_title
sle_subject sle_subject
st_3 st_3
st_recipient st_recipient
st_message_title st_message_title
mle_message mle_message
st_patient_title st_patient_title
st_patient st_patient
cb_send cb_send
end type
global w_compose_todo w_compose_todo

type variables
string cpr_id
long encounter_id

string to_user_id
string service

end variables

forward prototypes
public function integer send_message ()
end prototypes

public function integer send_message ();Long		ll_patient_workplan_item_id,ll_encounter_id
String	ls_attribute,ls_value,ls_cpr_id
string ls_auto_perform_flag
string ls_observation_tag
integer li_step_number

setnull(ls_auto_perform_flag)
setnull(ls_observation_tag)
setnull(li_step_number)
SetNull(ll_encounter_id)
SetNull(ls_cpr_id)

If Not Isnull(current_patient) Then 
	ls_cpr_id = current_patient.cpr_id
	If Not Isnull(current_patient.open_encounter) Then 
		ll_encounter_id = current_patient.open_encounter.encounter_id
	End If
End If

If isnull(to_user_id) Then
	openwithparm(w_pop_message, "You must select a recipient")
	Return 0
End If

if trim(sle_subject.text) = "" then
	openwithparm(w_pop_message, "You must enter a subject")
	return 0
end if

tf_begin_transaction(this, "send_message()")
sqlca.sp_order_service_workplan_item( &
		ls_cpr_id, &
		ll_encounter_id, &
		0, &
		service, &
		'N', &
		ls_auto_perform_flag, &
		ls_observation_tag, &
		sle_subject.text, &
		current_user.user_id, &
		to_user_id, &
		li_step_number, &
		current_user.user_id,  &
		ll_patient_workplan_item_id)
if not tf_check() then return -1

if trim(mle_message.text) <> "" then
	ls_attribute = "MESSAGE"
	ls_value = mle_message.text
	sqlca.sp_add_workplan_item_attribute( &
			ls_cpr_id,&
			0,&
			ll_patient_workplan_item_id,&
			ls_attribute,&
			ls_value,&
			current_scribe.user_id,&
			current_user.user_id)
	if not tf_check() then return -1
end if

tf_commit()
Return 1
end function

on w_compose_todo.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.st_title=create st_title
this.st_subject_title=create st_subject_title
this.sle_subject=create sle_subject
this.st_3=create st_3
this.st_recipient=create st_recipient
this.st_message_title=create st_message_title
this.mle_message=create mle_message
this.st_patient_title=create st_patient_title
this.st_patient=create st_patient
this.cb_send=create cb_send
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.st_subject_title
this.Control[iCurrent+5]=this.sle_subject
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.st_recipient
this.Control[iCurrent+8]=this.st_message_title
this.Control[iCurrent+9]=this.mle_message
this.Control[iCurrent+10]=this.st_patient_title
this.Control[iCurrent+11]=this.st_patient
this.Control[iCurrent+12]=this.cb_send
end on

on w_compose_todo.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.st_title)
destroy(this.st_subject_title)
destroy(this.sle_subject)
destroy(this.st_3)
destroy(this.st_recipient)
destroy(this.st_message_title)
destroy(this.mle_message)
destroy(this.st_patient_title)
destroy(this.st_patient)
destroy(this.cb_send)
end on

event open;call super::open;long ll_rows
long i
string ls_treatment_type
str_popup popup
string ls_patient_name
u_user luo_user

	 DECLARE lsp_get_patient_name PROCEDURE FOR dbo.sp_get_patient_name  
         @ps_cpr_id = :cpr_id,   
         @ps_patient_name = :ls_patient_name OUT ;

popup = message.powerobjectparm

if popup.data_row_count = 2 then
	cpr_id = popup.items[1]
	encounter_id = long(popup.items[2])
	to_user_id = current_user.user_id
elseif popup.data_row_count = 3 then
	cpr_id = popup.items[1]
	encounter_id = long(popup.items[2])
	service = popup.items[3]
//	if not isnull(popup.items[4]) then sle_subject.text = popup.items[4]
//	if not isnull(popup.items[5]) then mle_message.text = popup.items[5]
//	mle_message.setfocus()
else
	log.log(this, "w_compose_todo:open", "Invalid Parameters", 4)
	close(this)
	return
end if

//if not isnull(to_user_id) then
//	luo_user = user_list.find_user(to_user_id)
//	if isnull(luo_user) then
//		setnull(to_user_id)
//	else
//		st_recipient.text = luo_user.user_full_name
//		st_recipient.backcolor = luo_user.color
//	end if
//end if


if not isnull(cpr_id) then
	EXECUTE 	lsp_get_patient_name;
	if not tf_check() then return -1
	
	FETCH lsp_get_patient_name INTO :ls_patient_name;
	if not tf_check() then return -1
	
	CLOSE lsp_get_patient_name;
	
	st_patient.text = ls_patient_name
end if

end event

type pb_epro_help from w_window_base`pb_epro_help within w_compose_todo
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_compose_todo
end type

type pb_done from u_picture_button within w_compose_todo
boolean visible = false
integer x = 2560
integer y = 1552
integer width = 256
integer height = 224
integer taborder = 40
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;
close(parent)

end event

type pb_cancel from u_picture_button within w_compose_todo
integer x = 87
integer y = 1552
integer width = 256
integer height = 224
integer taborder = 50
boolean bringtotop = true
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return
string ls_temp

if (not isnull(sle_subject.text) and trim(sle_subject.text) <> "") &
 OR (not isnull(mle_message.text) and trim(mle_message.text) <> "") then
	ls_temp = "Are you sure you want to exit without sending this message?"
	openwithparm(w_pop_yes_no, ls_temp)
	popup_return = message.powerobjectparm
	if popup_return.item = "NO" then return
end if

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type st_title from statictext within w_compose_todo
integer width = 2912
integer height = 124
boolean bringtotop = true
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "New Todo Item"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_subject_title from statictext within w_compose_todo
integer x = 9
integer y = 632
integer width = 434
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Description:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_subject from singlelineedit within w_compose_todo
integer x = 471
integer y = 612
integer width = 2194
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_compose_todo
integer x = 41
integer y = 216
integer width = 402
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Ordered For:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_recipient from statictext within w_compose_todo
integer x = 471
integer y = 196
integer width = 1280
integer height = 112
integer taborder = 10
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
end type

event clicked;u_user luo_user

luo_user = user_list.pick_user("ALL", true)
if isnull(luo_user) then return

text = luo_user.user_full_name
backcolor = luo_user.color

to_user_id = luo_user.user_id




end event

type st_message_title from statictext within w_compose_todo
integer x = 101
integer y = 840
integer width = 343
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Message:"
alignment alignment = right!
boolean focusrectangle = false
end type

type mle_message from multilineedit within w_compose_todo
integer x = 471
integer y = 812
integer width = 2194
integer height = 656
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
boolean autovscroll = true
borderstyle borderstyle = stylelowered!
end type

type st_patient_title from statictext within w_compose_todo
integer x = 101
integer y = 424
integer width = 343
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Patient:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_patient from statictext within w_compose_todo
integer x = 471
integer y = 416
integer width = 1280
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
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type cb_send from commandbutton within w_compose_todo
integer x = 2263
integer y = 1608
integer width = 558
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Create Todo Item"
end type

event clicked;integer li_sts
str_popup_return popup_return

li_sts = send_message()

if li_sts <= 0 then return

popup_return.item_count = 1
popup_return.items[1] = to_user_id
closewithreturn(parent, popup_return)



end event

