$PBExportHeader$w_freeform_history.srw
forward
global type w_freeform_history from w_window_base
end type
type cb_personal from commandbutton within w_freeform_history
end type
type pb_down from picturebutton within w_freeform_history
end type
type pb_up from picturebutton within w_freeform_history
end type
type st_title from statictext within w_freeform_history
end type
type st_13 from statictext within w_freeform_history
end type
type st_minutes from statictext within w_freeform_history
end type
type st_12 from statictext within w_freeform_history
end type
type st_11 from statictext within w_freeform_history
end type
type cb_done from commandbutton within w_freeform_history
end type
type cb_beback from commandbutton within w_freeform_history
end type
type cb_duration from commandbutton within w_freeform_history
end type
type mle_findings from multilineedit within w_freeform_history
end type
type st_years from statictext within w_freeform_history
end type
type st_months from statictext within w_freeform_history
end type
type st_weeks from statictext within w_freeform_history
end type
type st_days from statictext within w_freeform_history
end type
type st_hours from statictext within w_freeform_history
end type
type cb_edit_list from commandbutton within w_freeform_history
end type
type dw_complaint from u_dw_pick_list within w_freeform_history
end type
type cb_onset from commandbutton within w_freeform_history
end type
type st_10 from statictext within w_freeform_history
end type
type st_9 from statictext within w_freeform_history
end type
type st_8 from statictext within w_freeform_history
end type
type st_7 from statictext within w_freeform_history
end type
type st_6 from statictext within w_freeform_history
end type
type st_5 from statictext within w_freeform_history
end type
type st_4 from statictext within w_freeform_history
end type
type st_3 from statictext within w_freeform_history
end type
type st_2 from statictext within w_freeform_history
end type
type st_1 from statictext within w_freeform_history
end type
type ln_1 from line within w_freeform_history
end type
type st_generic_list from statictext within w_freeform_history
end type
type st_specific_list from statictext within w_freeform_history
end type
type st_comment_title from statictext within w_freeform_history
end type
type st_page from statictext within w_freeform_history
end type
type cb_time_per from commandbutton within w_freeform_history
end type
type cb_punctuation from commandbutton within w_freeform_history
end type
end forward

global type w_freeform_history from w_window_base
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
cb_personal cb_personal
pb_down pb_down
pb_up pb_up
st_title st_title
st_13 st_13
st_minutes st_minutes
st_12 st_12
st_11 st_11
cb_done cb_done
cb_beback cb_beback
cb_duration cb_duration
mle_findings mle_findings
st_years st_years
st_months st_months
st_weeks st_weeks
st_days st_days
st_hours st_hours
cb_edit_list cb_edit_list
dw_complaint dw_complaint
cb_onset cb_onset
st_10 st_10
st_9 st_9
st_8 st_8
st_7 st_7
st_6 st_6
st_5 st_5
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
ln_1 ln_1
st_generic_list st_generic_list
st_specific_list st_specific_list
st_comment_title st_comment_title
st_page st_page
cb_time_per cb_time_per
cb_punctuation cb_punctuation
end type
global w_freeform_history w_freeform_history

type variables
statictext st_current_amount
statictext st_current_unit

real amount
string unit

string top_20_code
string top_20_generic_code
string top_20_specific_code
string top_20_user_id

u_component_service service

string original_comment

long observation_sequence
string comment_title
datetime comment_date_time

string punctuation
string cr_rule


end variables

forward prototypes
public function integer save_comment ()
public function integer load_pick_list ()
public subroutine edit_menu (long pl_row)
public subroutine add_text (string ps_text)
end prototypes

public function integer save_comment ();long ll_row
long ll_observation_comment_id
integer li_sts
string ls_find
string ls_null
long ll_patient_workplan_item_id
integer li_diagnosis_sequence
long ll_attachment_id
long ll_sts
string ls_comment
string ls_abnormal_flag
integer li_severity

setnull(ls_null)
setnull(li_diagnosis_sequence)
setnull(ll_patient_workplan_item_id)
setnull(ll_attachment_id)
setnull(ls_abnormal_flag)
setnull(li_severity)

if mle_findings.text = original_comment then return 1

ls_comment = trim(mle_findings.text)
if ls_comment = "" then setnull(ls_comment)

li_sts = f_set_progress2(current_patient.cpr_id, & 
								"Observation", &
								observation_sequence, &
								"Comment", &
								comment_title, &
								ls_comment, &
								comment_date_time, &
								li_severity, &
								ll_attachment_id, &
								ll_patient_workplan_item_id, &
								li_diagnosis_sequence, &
								ls_abnormal_flag)
if li_sts < 0 then return -1

return 1



end function

public function integer load_pick_list ();integer li_count


if isnull(top_20_user_id) then
	top_20_user_id = current_user.user_id
	cb_personal.text = "Personal List"
	li_count = dw_complaint.retrieve(top_20_user_id, top_20_code)
	if li_count <= 0 then
		top_20_user_id = current_user.specialty_id
		cb_personal.text = "Common List"
		li_count = dw_complaint.retrieve(top_20_user_id, top_20_code)
	end if
else
	li_count = dw_complaint.retrieve(top_20_user_id, top_20_code)
end if

dw_complaint.set_page(1, pb_up, pb_down, st_page)

return li_count



end function

public subroutine edit_menu (long pl_row);str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
integer li_update_flag
string ls_temp
string ls_description
string ls_null
long ll_null

setnull(ls_null)
setnull(ll_null)

if top_20_user_id = current_user.user_id or current_user.check_privilege("Edit Common Short Lists") then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonmove.bmp"
	popup.button_helps[popup.button_count] = "Move record up or down"
	popup.button_titles[popup.button_count] = "Move"
	buttons[popup.button_count] = "MOVE"
end if

if top_20_user_id = current_user.user_id or current_user.check_privilege("Edit Common Short Lists") then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Remove item from Top-20"
	popup.button_titles[popup.button_count] = "Remove Top-20"
	buttons[popup.button_count] = "REMOVE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	button_pressed = message.doubleparm
	if button_pressed < 1 or button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if

CHOOSE CASE buttons[button_pressed]
	CASE "REMOVE"
		dw_complaint.deleterow(pl_row)
		dw_complaint.update()
		dw_complaint.recalc_page(pb_up, pb_down, st_page)
	CASE "MOVE"
		popup.objectparm = dw_complaint
		popup.item = "SAVE"
		openwithparm(w_pick_list_sort, popup)
		dw_complaint.update()
		dw_complaint.recalc_page(pb_up, pb_down, st_page)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end subroutine

public subroutine add_text (string ps_text);long ll_position
long ll_newposition
string ls_left, ls_right
string ls_pre, ls_post

if isnull(mle_findings.text) then mle_findings.text = ""

ll_position = mle_findings.position( )
if ll_position <= 0 then ll_position = len(mle_findings.text) + 1

ls_pre = " "
ls_post = " "
ps_text = trim(ps_text)

ls_left = righttrim(left(mle_findings.text, ll_position - 1))
ls_right = lefttrim(mid(mle_findings.text, ll_position))

// If the insertion point follows a period or comma, move the punctuation
// to after the new text
if right(ls_left, 1) = "." or right(ls_left, 1) = "," then
	ls_post = right(ls_left, 1) + " "
	if ls_post = ". " then ls_post = ".  "
	ls_left = left(ls_left, len(ls_left) - 1)
	
	// If there is also punctuation at the end of the inserted text, 
	// then remove the punctuation from the inserted text
	if right(ps_text, 1) = "." or right(ps_text, 1) = "," then
		ps_text = trim(left(ps_text, len(ps_text) - 1))
	end if
end if

// If the insertion point precedes a period or comma, then don't add a space
if left(ls_right, 1) = "." or left(ls_right, 1) = "," then
	ls_post = ""
	
	// If there is also punctuation at the end of the inserted text, 
	// then remove the punctuation from the inserted text
	if right(ps_text, 1) = "." or right(ps_text, 1) = "," then
		ps_text = trim(left(ps_text, len(ps_text) - 1))
	end if
end if

// Don't add a space to the beginning of the added text if the insertion
// point is already at the beginning
if len(ls_left) = 0 then
	ls_pre = ""
end if

mle_findings.text = ls_left + ls_pre + ps_text + ls_post + ls_right

ll_newposition = len(ls_left) + len(ls_pre) + len(ps_text) + len(ls_post) + 1

mle_findings.setfocus()
mle_findings.selecttext(ll_newposition, 0)

end subroutine

event open;call super::open;str_popup popup
str_popup_return popup_return
long ll_encounter_id
integer li_sts
integer i
long ll_len
string ls_mode
string ls_observation_id
//str_observation_comment lstr_comment
str_progress_list lstr_progress
string ls_control


popup_return.item_count = 0

setnull(top_20_user_id)

dw_complaint.settransobject(sqlca)

service = message.powerobjectparm

title = current_patient.id_line()

if isnull(service.treatment) then
	log.log(this, "w_freeform_history:open", "No associated treatment", 4)
	closewithreturn(this, popup_return)
	return
end if

// See if observation_sequence was passed in with service
service.get_attribute("observation_sequence", observation_sequence)

// If not, default to the root observation
if isnull(observation_sequence) then observation_sequence = service.get_root_observation()

// Get the comment_title
service.get_attribute("comment_title", comment_title)
st_comment_title.text = comment_title

// If we still don't have an observation_sequence, it's an error
if isnull(observation_sequence) then
	log.log(this, "w_freeform_history:open", "No root observation sequence", 4)
	closewithreturn(this, popup_return)
	return
end if

ls_observation_id = service.treatment.get_observation_id(observation_sequence)
st_title.text = datalist.observation_description(ls_observation_id)

top_20_generic_code = "FFH|" + service.treatment.treatment_type
top_20_specific_code = top_20_generic_code + "|" + ls_observation_id

top_20_code = top_20_specific_code
st_specific_list.backcolor = color_object_selected
li_sts = load_pick_list()
if li_sts < 0 then
	log.log(this, "w_freeform_history:open", "Error loading pick list", 4)
	popup_return.item_count = 1
	popup_return.items[1] = "ERROR"
	closewithreturn(this, popup_return)
	return
end if
if li_sts = 0 then
	setnull(top_20_user_id)
	top_20_code = top_20_generic_code
	st_specific_list.backcolor = color_object
	st_generic_list.backcolor = color_object_selected
	
	li_sts = load_pick_list()
	if li_sts < 0 then
		log.log(this, "w_freeform_history:open", "Error loading pick list", 4)
		popup_return.item_count = 1
		popup_return.items[1] = "ERROR"
		closewithreturn(this, popup_return)
		return
	end if
end if

// Get comments structure
//li_sts = service.treatment.get_comment(observation_sequence, comment_title, lstr_comment)
lstr_progress = f_get_progress(current_patient.cpr_id, &
										'Observation', &
										observation_sequence, &
										'Comment', &
										comment_title)

// Set original_comment to be this user's comment
if lstr_progress.progress_count <= 0 then
	setnull(original_comment)
	setnull(comment_date_time)
else
	// Show the latest comment
	original_comment = lstr_progress.progress[lstr_progress.progress_count].progress
	comment_date_time = lstr_progress.progress[lstr_progress.progress_count].progress_date_time
end if

if isnull(original_comment) then
	mle_findings.text = ""
else
	mle_findings.text = original_comment
end if

st_current_amount = st_1
st_current_unit = st_days
st_days.trigger event clicked()

amount = 0

mle_findings.setfocus()
ll_len = len(mle_findings.text)
mle_findings.selecttext(ll_len + 1, 0)

if service.manual_service then
	cb_beback.visible = false
	cb_done.text = "OK"
end if

dw_complaint.object.item_text.width = dw_complaint.width - 320

ls_control = datalist.get_preference("PREFERENCES", "history_punctuaion_control", "PERIOD|, ")

f_split_string(ls_control, "|", cr_rule, punctuation)


end event

on w_freeform_history.create
int iCurrent
call super::create
this.cb_personal=create cb_personal
this.pb_down=create pb_down
this.pb_up=create pb_up
this.st_title=create st_title
this.st_13=create st_13
this.st_minutes=create st_minutes
this.st_12=create st_12
this.st_11=create st_11
this.cb_done=create cb_done
this.cb_beback=create cb_beback
this.cb_duration=create cb_duration
this.mle_findings=create mle_findings
this.st_years=create st_years
this.st_months=create st_months
this.st_weeks=create st_weeks
this.st_days=create st_days
this.st_hours=create st_hours
this.cb_edit_list=create cb_edit_list
this.dw_complaint=create dw_complaint
this.cb_onset=create cb_onset
this.st_10=create st_10
this.st_9=create st_9
this.st_8=create st_8
this.st_7=create st_7
this.st_6=create st_6
this.st_5=create st_5
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.ln_1=create ln_1
this.st_generic_list=create st_generic_list
this.st_specific_list=create st_specific_list
this.st_comment_title=create st_comment_title
this.st_page=create st_page
this.cb_time_per=create cb_time_per
this.cb_punctuation=create cb_punctuation
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_personal
this.Control[iCurrent+2]=this.pb_down
this.Control[iCurrent+3]=this.pb_up
this.Control[iCurrent+4]=this.st_title
this.Control[iCurrent+5]=this.st_13
this.Control[iCurrent+6]=this.st_minutes
this.Control[iCurrent+7]=this.st_12
this.Control[iCurrent+8]=this.st_11
this.Control[iCurrent+9]=this.cb_done
this.Control[iCurrent+10]=this.cb_beback
this.Control[iCurrent+11]=this.cb_duration
this.Control[iCurrent+12]=this.mle_findings
this.Control[iCurrent+13]=this.st_years
this.Control[iCurrent+14]=this.st_months
this.Control[iCurrent+15]=this.st_weeks
this.Control[iCurrent+16]=this.st_days
this.Control[iCurrent+17]=this.st_hours
this.Control[iCurrent+18]=this.cb_edit_list
this.Control[iCurrent+19]=this.dw_complaint
this.Control[iCurrent+20]=this.cb_onset
this.Control[iCurrent+21]=this.st_10
this.Control[iCurrent+22]=this.st_9
this.Control[iCurrent+23]=this.st_8
this.Control[iCurrent+24]=this.st_7
this.Control[iCurrent+25]=this.st_6
this.Control[iCurrent+26]=this.st_5
this.Control[iCurrent+27]=this.st_4
this.Control[iCurrent+28]=this.st_3
this.Control[iCurrent+29]=this.st_2
this.Control[iCurrent+30]=this.st_1
this.Control[iCurrent+31]=this.ln_1
this.Control[iCurrent+32]=this.st_generic_list
this.Control[iCurrent+33]=this.st_specific_list
this.Control[iCurrent+34]=this.st_comment_title
this.Control[iCurrent+35]=this.st_page
this.Control[iCurrent+36]=this.cb_time_per
this.Control[iCurrent+37]=this.cb_punctuation
end on

on w_freeform_history.destroy
call super::destroy
destroy(this.cb_personal)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.st_title)
destroy(this.st_13)
destroy(this.st_minutes)
destroy(this.st_12)
destroy(this.st_11)
destroy(this.cb_done)
destroy(this.cb_beback)
destroy(this.cb_duration)
destroy(this.mle_findings)
destroy(this.st_years)
destroy(this.st_months)
destroy(this.st_weeks)
destroy(this.st_days)
destroy(this.st_hours)
destroy(this.cb_edit_list)
destroy(this.dw_complaint)
destroy(this.cb_onset)
destroy(this.st_10)
destroy(this.st_9)
destroy(this.st_8)
destroy(this.st_7)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.ln_1)
destroy(this.st_generic_list)
destroy(this.st_specific_list)
destroy(this.st_comment_title)
destroy(this.st_page)
destroy(this.cb_time_per)
destroy(this.cb_punctuation)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_freeform_history
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_freeform_history
end type

type cb_personal from commandbutton within w_freeform_history
integer x = 1362
integer y = 1560
integer width = 466
integer height = 116
integer taborder = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Personal List"
end type

event clicked;

if top_20_user_id <> current_user.user_id then
	top_20_user_id = current_user.user_id
	text = "Personal List"
else
	top_20_user_id = current_user.common_list_id()
	text = "Common List"
end if

load_pick_list()


end event

type pb_down from picturebutton within w_freeform_history
integer x = 1349
integer y = 240
integer width = 137
integer height = 116
integer taborder = 20
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

event clicked;integer li_page
integer li_last_page

li_page = dw_complaint.current_page
li_last_page = dw_complaint.last_page

dw_complaint.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type pb_up from picturebutton within w_freeform_history
integer x = 1349
integer y = 116
integer width = 137
integer height = 116
integer taborder = 10
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

event clicked;integer li_page

li_page = dw_complaint.current_page

dw_complaint.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type st_title from statictext within w_freeform_history
integer width = 2898
integer height = 112
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
string text = "Football Pizza Beer"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_13 from statictext within w_freeform_history
integer x = 1929
integer y = 136
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
string text = "Which List"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_minutes from statictext within w_freeform_history
integer x = 2176
integer y = 404
integer width = 293
integer height = 104
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Minutes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_current_unit.backcolor = COLOR_LIGHT_GREY

backcolor = COLOR_DARK_GREY

st_current_unit = this

unit = "MINUTE"

end event

type st_12 from statictext within w_freeform_history
integer x = 1865
integer y = 700
integer width = 178
integer height = 96
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "12"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_current_amount.backcolor = COLOR_LIGHT_GREY

backcolor = COLOR_DARK_GREY

st_current_amount = this

amount = 12

end event

type st_11 from statictext within w_freeform_history
integer x = 1865
integer y = 596
integer width = 178
integer height = 96
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "11"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_current_amount.backcolor = COLOR_LIGHT_GREY

backcolor = COLOR_DARK_GREY

st_current_amount = this

amount = 11

end event

type cb_done from commandbutton within w_freeform_history
integer x = 2418
integer y = 1560
integer width = 402
integer height = 116
integer taborder = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'m Finished"
end type

event clicked;str_popup_return popup_return
integer li_sts

li_sts = save_comment()
if li_sts < 0 then
	log.log(this, "w_freeform_history.cb_done.clicked:0006", "Error saving comment", 4)
	return
end if

popup_return.items[1] = "CLOSE"
popup_return.item_count = 1
closewithreturn(parent, popup_return)



end event

type cb_beback from commandbutton within w_freeform_history
integer x = 1966
integer y = 1560
integer width = 402
integer height = 116
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
end type

event clicked;str_popup_return popup_return
integer li_sts

li_sts = save_comment()
if li_sts < 0 then
	log.log(this, "w_freeform_history.cb_beback.clicked:0006", "Error saving comment", 4)
	return
end if

popup_return.item_count = 0
closewithreturn(parent, popup_return)



end event

type cb_duration from commandbutton within w_freeform_history
integer x = 2382
integer y = 848
integer width = 288
integer height = 100
integer taborder = 40
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Duration"
end type

event clicked;string ls_temp
long ll_len

if amount <= 0 or isnull(amount) then return

ls_temp = f_pretty_amount_unit(amount, unit)
if isnull(ls_temp) then return

add_text("lasting for " + ls_temp + ".")


end event

type mle_findings from multilineedit within w_freeform_history
integer x = 1426
integer y = 960
integer width = 1422
integer height = 440
integer taborder = 40
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

type st_years from statictext within w_freeform_history
integer x = 2501
integer y = 652
integer width = 293
integer height = 104
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Years"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_current_unit.backcolor = COLOR_LIGHT_GREY

backcolor = COLOR_DARK_GREY

st_current_unit = this

unit = "YEAR"

end event

type st_months from statictext within w_freeform_history
integer x = 2501
integer y = 528
integer width = 293
integer height = 104
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Months"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_current_unit.backcolor = COLOR_LIGHT_GREY

backcolor = COLOR_DARK_GREY

st_current_unit = this

unit = "MONTH"

end event

type st_weeks from statictext within w_freeform_history
integer x = 2501
integer y = 404
integer width = 293
integer height = 104
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Weeks"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_current_unit.backcolor = COLOR_LIGHT_GREY

backcolor = COLOR_DARK_GREY

st_current_unit = this

unit = "WEEK"

end event

type st_days from statictext within w_freeform_history
integer x = 2176
integer y = 652
integer width = 293
integer height = 104
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Days"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_current_unit.backcolor = COLOR_LIGHT_GREY

backcolor = COLOR_DARK_GREY

st_current_unit = this

unit = "DAY"

end event

type st_hours from statictext within w_freeform_history
integer x = 2176
integer y = 528
integer width = 293
integer height = 104
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Hours"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_current_unit.backcolor = COLOR_LIGHT_GREY

backcolor = COLOR_DARK_GREY

st_current_unit = this

unit = "HOUR"

end event

type cb_edit_list from commandbutton within w_freeform_history
integer x = 1426
integer y = 1420
integer width = 526
integer height = 84
integer taborder = 60
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<< Add to List <<"
end type

event clicked;string ls_item_text
long ll_row


ls_item_text = trim(mle_findings.selectedtext())
if isnull(ls_item_text) or ls_item_text = "" then
	ls_item_text = trim(mle_findings.text)
	if isnull(ls_item_text) or ls_item_text = "" then return
end if

ll_row = dw_complaint.insertrow(0)
dw_complaint.object.user_id[ll_row] = top_20_user_id
dw_complaint.object.top_20_code[ll_row] = top_20_code
dw_complaint.object.item_text[ll_row] = ls_item_text
dw_complaint.object.sort_sequence[ll_row] = ll_row

dw_complaint.update()

dw_complaint.scrolltorow(ll_row)
dw_complaint.recalc_page(pb_up, pb_down, st_page)

end event

type dw_complaint from u_dw_pick_list within w_freeform_history
integer x = 14
integer y = 108
integer width = 1339
integer height = 1700
integer taborder = 10
string dataobject = "dw_top_20_list_with_no"
boolean border = false
boolean livescroll = false
end type

event selected;call super::selected;string ls_item_text
string ls_temp
string ls_sep
long ll_len
string ls_no
string ls_punctuation


if lasttype = 'compute' then
	object.selected_flag[selected_row] = 1
	edit_menu(selected_row)
	clear_selected()
	return
end if


ls_item_text = object.item_text[selected_row]
ls_temp = right(mle_findings.text, 1)

ls_punctuation = punctuation
ls_no = "No "

CHOOSE CASE upper(cr_rule)
	CASE "ALWAYS"
		if ls_temp = "" then
			ls_sep = ""
		else
			ls_sep = "~r~n"
		end if
		ls_punctuation = ""
	CASE "NEVER"
		if ls_temp = "" or ls_temp = " " then
			ls_sep = ""
		else
			ls_sep = " "
		end if
	CASE ELSE
		if ls_temp = "" or ls_temp = " " then
			ls_sep = ""
		elseif ls_temp = "." then
			ls_sep = "~r~n"
		else
			ls_sep = " "
		end if
END CHOOSE


if lastcolumn = 10 then
	// "No" button
	mle_findings.text += ls_sep + ls_no + ls_item_text + ls_punctuation
elseif lastcolumn = 4 then
	mle_findings.text += ls_sep + ls_item_text + ls_punctuation
	// Complaint button
end if

object.selected_flag[selected_row] = 0

mle_findings.setfocus()
ll_len = len(mle_findings.text)
mle_findings.selecttext(ll_len + 1, 0)

end event

type cb_onset from commandbutton within w_freeform_history
integer x = 2071
integer y = 848
integer width = 288
integer height = 100
integer taborder = 30
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Onset"
end type

event clicked;string ls_temp
long ll_len

if amount <= 0 or isnull(amount) then return

ls_temp = f_pretty_amount_unit(amount, unit)
if isnull(ls_temp) then return

add_text("beginning " + ls_temp + " ago.")


end event

type st_10 from statictext within w_freeform_history
integer x = 1865
integer y = 492
integer width = 178
integer height = 96
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "10"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_current_amount.backcolor = COLOR_LIGHT_GREY

backcolor = COLOR_DARK_GREY

st_current_amount = this

amount = 10

end event

type st_9 from statictext within w_freeform_history
integer x = 1865
integer y = 388
integer width = 178
integer height = 96
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "9"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_current_amount.backcolor = COLOR_LIGHT_GREY

backcolor = COLOR_DARK_GREY

st_current_amount = this

amount = 9

end event

type st_8 from statictext within w_freeform_history
integer x = 1655
integer y = 700
integer width = 178
integer height = 96
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "8"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_current_amount.backcolor = COLOR_LIGHT_GREY

backcolor = COLOR_DARK_GREY

st_current_amount = this

amount = 8
end event

type st_7 from statictext within w_freeform_history
integer x = 1655
integer y = 596
integer width = 178
integer height = 96
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "7"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_current_amount.backcolor = COLOR_LIGHT_GREY

backcolor = COLOR_DARK_GREY

st_current_amount = this

amount = 7

end event

type st_6 from statictext within w_freeform_history
integer x = 1655
integer y = 492
integer width = 178
integer height = 96
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "6"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_current_amount.backcolor = COLOR_LIGHT_GREY

backcolor = COLOR_DARK_GREY

st_current_amount = this

amount = 6

end event

type st_5 from statictext within w_freeform_history
integer x = 1655
integer y = 388
integer width = 178
integer height = 96
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "5"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_current_amount.backcolor = COLOR_LIGHT_GREY

backcolor = COLOR_DARK_GREY

st_current_amount = this

amount = 5

end event

type st_4 from statictext within w_freeform_history
integer x = 1445
integer y = 700
integer width = 178
integer height = 96
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "4"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_current_amount.backcolor = COLOR_LIGHT_GREY

backcolor = COLOR_DARK_GREY

st_current_amount = this

amount = 4

end event

type st_3 from statictext within w_freeform_history
integer x = 1445
integer y = 596
integer width = 178
integer height = 96
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "3"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_current_amount.backcolor = COLOR_LIGHT_GREY

backcolor = COLOR_DARK_GREY

st_current_amount = this

amount = 3

end event

type st_2 from statictext within w_freeform_history
integer x = 1445
integer y = 492
integer width = 178
integer height = 96
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "2"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_current_amount.backcolor = COLOR_LIGHT_GREY

backcolor = COLOR_DARK_GREY

st_current_amount = this

amount = 2

end event

type st_1 from statictext within w_freeform_history
integer x = 1445
integer y = 388
integer width = 178
integer height = 96
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "1"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_current_amount.backcolor = COLOR_LIGHT_GREY

backcolor = COLOR_DARK_GREY

st_current_amount = this

amount = 1

end event

type ln_1 from line within w_freeform_history
integer linethickness = 2
integer beginx = 1595
integer beginy = 344
integer endx = 2688
integer endy = 344
end type

type st_generic_list from statictext within w_freeform_history
integer x = 1755
integer y = 212
integer width = 379
integer height = 100
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Generic"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;top_20_code = top_20_generic_code
backcolor = color_object_selected
st_specific_list.backcolor = color_object

load_pick_list()

end event

type st_specific_list from statictext within w_freeform_history
integer x = 2181
integer y = 212
integer width = 379
integer height = 100
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Specific"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;top_20_code = top_20_specific_code
backcolor = color_object_selected
st_generic_list.backcolor = color_object

load_pick_list()

end event

type st_comment_title from statictext within w_freeform_history
integer x = 1426
integer y = 888
integer width = 635
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Comment Title"
boolean focusrectangle = false
end type

type st_page from statictext within w_freeform_history
integer x = 1495
integer y = 112
integer width = 274
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Page 99/99"
boolean focusrectangle = false
end type

type cb_time_per from commandbutton within w_freeform_history
integer x = 2693
integer y = 848
integer width = 146
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "T/P"
end type

event clicked;string ls_temp
string ls_text
long ll_len
string ls_amount
string ls_unit_desc
u_unit luo_unit

if amount <= 0 or isnull(amount) then return

ls_temp = f_pretty_amount_unit(amount, unit)
if isnull(ls_temp) then return

ls_amount = f_pretty_amount(amount, unit, luo_unit)

ls_text = "frequency of " + ls_amount + " time"
if ls_amount = "1" then
	ls_text += " per "
else
	ls_text += "s per "
end if
ls_text += unit_list.unit_description(unit) + ".  "

add_text(ls_text)


//if ls_temp1 = "" then
//	// don't change anything
//elseif right(ls_temp1, 1) = "." then
//	ls_temp1 = left(ls_temp1, len(ls_temp1) - 1) + " and"
//elseif right(ls_temp1, 1) = "," then
//	// don't change anything
//elseif lower(right(ls_temp1, 4)) = " and" then
//	// don't change anything
//else
//	ls_temp1 += ","
//end if
//
//ls_amount = f_pretty_amount(amount, unit, luo_unit)


end event

type cb_punctuation from commandbutton within w_freeform_history
integer x = 2542
integer y = 1420
integer width = 306
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Punctuation"
end type

event clicked;string ls_control

ls_control = cr_rule + "|" + punctuation

openwithparm(w_punctuation_control, ls_control, f_active_window())

ls_control = message.stringparm
if isnull(ls_control) then return

datalist.update_preference( "PREFERENCES", "User", current_scribe.user_id, "history_punctuaion_control", ls_control)

f_split_string(ls_control, "|", cr_rule, punctuation)


end event

