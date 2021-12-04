$PBExportHeader$w_observation_comment_with_list.srw
forward
global type w_observation_comment_with_list from w_window_base
end type
type st_comment_title from statictext within w_observation_comment_with_list
end type
type st_comment_user from statictext within w_observation_comment_with_list
end type
type cb_prev from commandbutton within w_observation_comment_with_list
end type
type cb_next from commandbutton within w_observation_comment_with_list
end type
type st_comment_count from statictext within w_observation_comment_with_list
end type
type cb_personal from commandbutton within w_observation_comment_with_list
end type
type cb_edit_list from commandbutton within w_observation_comment_with_list
end type
type st_generic_list from statictext within w_observation_comment_with_list
end type
type st_13 from statictext within w_observation_comment_with_list
end type
type st_specific_list from statictext within w_observation_comment_with_list
end type
type mle_comments from multilineedit within w_observation_comment_with_list
end type
type cb_done from commandbutton within w_observation_comment_with_list
end type
type cb_beback from commandbutton within w_observation_comment_with_list
end type
type cb_dictate from commandbutton within w_observation_comment_with_list
end type
type pb_down from picturebutton within w_observation_comment_with_list
end type
type pb_up from picturebutton within w_observation_comment_with_list
end type
type st_page from statictext within w_observation_comment_with_list
end type
type cb_punctuation from commandbutton within w_observation_comment_with_list
end type
type st_title from statictext within w_observation_comment_with_list
end type
type dw_complaint from u_dw_pick_list within w_observation_comment_with_list
end type
end forward

global type w_observation_comment_with_list from w_window_base
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_comment_title st_comment_title
st_comment_user st_comment_user
cb_prev cb_prev
cb_next cb_next
st_comment_count st_comment_count
cb_personal cb_personal
cb_edit_list cb_edit_list
st_generic_list st_generic_list
st_13 st_13
st_specific_list st_specific_list
mle_comments mle_comments
cb_done cb_done
cb_beback cb_beback
cb_dictate cb_dictate
pb_down pb_down
pb_up pb_up
st_page st_page
cb_punctuation cb_punctuation
st_title st_title
dw_complaint dw_complaint
end type
global w_observation_comment_with_list w_observation_comment_with_list

type variables
string comment_user_id
u_component_service service

long observation_sequence
string comment_title

str_observation_comment prev_comments[]
integer prev_comment_count

integer displayed_comment
string new_comment

string top_20_code
string top_20_generic_code
string top_20_specific_code
string top_20_user_id

string dictate_service
string dictate_external_source_type

string punctuation
string cr_rule

boolean modified_since_picked

end variables

forward prototypes
public function integer load_attachments ()
public subroutine display_comment (integer pl_displayed_comment)
public function integer save_comment ()
public function integer load_pick_list ()
public subroutine edit_menu (long pl_row)
end prototypes

public function integer load_attachments ();integer i
integer li_count

//li_count = attachment_list.rowcount()

for i = 1 to li_count
next

return li_count

end function

public subroutine display_comment (integer pl_displayed_comment);string ls_user
datetime ldt_created

displayed_comment = pl_displayed_comment

if displayed_comment > 1 then
	cb_prev.enabled = true
else
	displayed_comment = 1
	cb_prev.enabled = false
end if

// The number for the new_comment is one higher than the number of previous comments
if displayed_comment > prev_comment_count then
	// Display the new comment
	displayed_comment = prev_comment_count + 1
	cb_next.enabled = false
	mle_comments.displayonly = false
	mle_comments.backcolor = color_white
	mle_comments.text = new_comment
	setnull(ldt_created)
	setnull(ls_user)
else
	// Display the appropriate previous comment
	cb_next.enabled = true
	mle_comments.displayonly = true
	mle_comments.backcolor = color_object
	mle_comments.text = prev_comments[displayed_comment].comment
	ldt_created = prev_comments[displayed_comment].created
	ls_user = user_list.user_full_name(prev_comments[displayed_comment].user_id)
end if

// Build the display string
st_comment_count.text = string(displayed_comment) + " of " + string(prev_comment_count + 1)
if isnull(ldt_created) then
	st_comment_count.text += "  -  New Comment"
else
	st_comment_count.text += "  -  " + string(ldt_created, date_format_string) + " " + string(ldt_created, time_format_string)
	ls_user = user_list.user_full_name(prev_comments[displayed_comment].user_id)
	if not isnull(ls_user) then
		st_comment_count.text += ", " + ls_user
	end if
end if

end subroutine

public function integer save_comment ();str_popup_return popup_return
long ll_observation_comment_id
string ls_abnormal_flag
integer li_severity
string ls_prev_comment

setnull(ls_abnormal_flag)
setnull(li_severity)

// First remove the trailing separator
if not modified_since_picked and right(new_comment, len(punctuation)) = punctuation then
	new_comment = left(new_comment, len(new_comment) - len(punctuation))
end if

if isnull(new_comment) then
	new_comment = ""
else
	new_comment = trim(new_comment)
end if

if prev_comment_count > 0 then
	ls_prev_comment = trim(prev_comments[prev_comment_count].comment)
	if isnull(ls_prev_comment) then ls_prev_comment = ""
else
	ls_prev_comment = ""
end if

// If the comment changed then add the new comment
if new_comment <> ls_prev_comment then
	ll_observation_comment_id = service.treatment.add_comment(observation_sequence, comment_title, ls_abnormal_flag, li_severity, new_comment)
	if ll_observation_comment_id <= 0 then return -1
end if

return 1



end function

public function integer load_pick_list ();integer li_count
string ls_text


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

dw_complaint.set_page(1, st_page.text)
if dw_complaint.last_page < 2 then
	st_page.visible = false
	pb_up.visible = false
	pb_down.visible = false
else
	st_page.visible = true
	pb_up.visible = true
	pb_down.visible = true
	pb_up.enabled = false
	pb_down.enabled = true
end if

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
	CASE "MOVE"
		popup.objectparm = dw_complaint
		openwithparm(w_pick_list_sort, popup)
		dw_complaint.update()
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end subroutine

on w_observation_comment_with_list.create
int iCurrent
call super::create
this.st_comment_title=create st_comment_title
this.st_comment_user=create st_comment_user
this.cb_prev=create cb_prev
this.cb_next=create cb_next
this.st_comment_count=create st_comment_count
this.cb_personal=create cb_personal
this.cb_edit_list=create cb_edit_list
this.st_generic_list=create st_generic_list
this.st_13=create st_13
this.st_specific_list=create st_specific_list
this.mle_comments=create mle_comments
this.cb_done=create cb_done
this.cb_beback=create cb_beback
this.cb_dictate=create cb_dictate
this.pb_down=create pb_down
this.pb_up=create pb_up
this.st_page=create st_page
this.cb_punctuation=create cb_punctuation
this.st_title=create st_title
this.dw_complaint=create dw_complaint
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_comment_title
this.Control[iCurrent+2]=this.st_comment_user
this.Control[iCurrent+3]=this.cb_prev
this.Control[iCurrent+4]=this.cb_next
this.Control[iCurrent+5]=this.st_comment_count
this.Control[iCurrent+6]=this.cb_personal
this.Control[iCurrent+7]=this.cb_edit_list
this.Control[iCurrent+8]=this.st_generic_list
this.Control[iCurrent+9]=this.st_13
this.Control[iCurrent+10]=this.st_specific_list
this.Control[iCurrent+11]=this.mle_comments
this.Control[iCurrent+12]=this.cb_done
this.Control[iCurrent+13]=this.cb_beback
this.Control[iCurrent+14]=this.cb_dictate
this.Control[iCurrent+15]=this.pb_down
this.Control[iCurrent+16]=this.pb_up
this.Control[iCurrent+17]=this.st_page
this.Control[iCurrent+18]=this.cb_punctuation
this.Control[iCurrent+19]=this.st_title
this.Control[iCurrent+20]=this.dw_complaint
end on

on w_observation_comment_with_list.destroy
call super::destroy
destroy(this.st_comment_title)
destroy(this.st_comment_user)
destroy(this.cb_prev)
destroy(this.cb_next)
destroy(this.st_comment_count)
destroy(this.cb_personal)
destroy(this.cb_edit_list)
destroy(this.st_generic_list)
destroy(this.st_13)
destroy(this.st_specific_list)
destroy(this.mle_comments)
destroy(this.cb_done)
destroy(this.cb_beback)
destroy(this.cb_dictate)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.st_page)
destroy(this.cb_punctuation)
destroy(this.st_title)
destroy(this.dw_complaint)
end on

event open;call super::open;string ls_observation_id
str_popup_return popup_return
str_observation_comment lstr_comment
integer i, j
datetime ldt_created
string ls_temp
integer li_sts
u_ds_data luo_data
long ll_count
string ls_control

service = message.powerobjectparm
if isnull(service.treatment) then
	log.log(this, "w_observation_comment_with_list:open", "Invalid treatment object", 4)
	popup_return.item_count = 1
	popup_return.items[1] = "ERROR"
	closewithreturn(this, popup_return)
	return
end if

if service.manual_service then cb_done.text = "OK"

comment_user_id = current_user.user_id
observation_sequence = long(service.get_attribute("observation_sequence"))
comment_title = service.get_attribute("comment_title")

st_comment_user.text = current_user.user_full_name
if trim(comment_title) = "" then setnull(comment_title)

if isnull(comment_title) then
	st_comment_title.visible = false
else
	st_comment_title.text = comment_title
end if

title = current_patient.id_line()

if isnull(observation_sequence) then
	observation_sequence = service.get_root_observation()
end if

ls_observation_id = service.treatment.get_observation_id(observation_sequence)
st_title.text = datalist.observation_description(ls_observation_id)

top_20_generic_code = "FFH|" + service.treatment.treatment_type
if not isnull(comment_title) then top_20_generic_code += "|" + comment_title
if len(top_20_generic_code) > 64 then top_20_generic_code = left(top_20_generic_code, 64)


top_20_specific_code = top_20_generic_code + "|" + ls_observation_id
if len(top_20_specific_code) > 64 then top_20_specific_code = left(top_20_specific_code, 64)

top_20_code = top_20_specific_code
st_specific_list.backcolor = color_object_selected
dw_complaint.settransobject(sqlca)
setnull(top_20_user_id)

li_sts = load_pick_list()
if li_sts < 0 then
	log.log(this, "w_observation_comment_with_list:open", "Error loading pick list", 4)
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
		log.log(this, "w_observation_comment_with_list:open", "Error loading pick list", 4)
		popup_return.item_count = 1
		popup_return.items[1] = "ERROR"
		closewithreturn(this, popup_return)
		return
	end if
end if


prev_comment_count = 0

// Display the comment which matches both the user_id and the comment_title
li_sts = service.treatment.get_comment(observation_sequence, comment_title, lstr_comment)
if li_sts > 0 then
	prev_comment_count = lstr_comment.previous_comments.comment_count
	for j = 1 to prev_comment_count
		prev_comments[j] = lstr_comment.previous_comments.comment[j]
	next
	// Add the latest comment to the list of previous comments
	prev_comment_count += 1
	prev_comments[prev_comment_count] = lstr_comment
end if

if prev_comment_count > 0 then
	new_comment = prev_comments[prev_comment_count].comment
	if isnull(new_comment) then new_comment = ""
	ldt_created = prev_comments[prev_comment_count].created
else
	new_comment = ""
	setnull(ldt_created)
end if

mle_comments.text = new_comment

displayed_comment = prev_comment_count + 1
mle_comments.displayonly = false
mle_comments.backcolor = color_white
ls_temp = "New Comment"

st_comment_count.text = string(displayed_comment) + " of " + string(displayed_comment)
st_comment_count.text += "  -  " + ls_temp

if displayed_comment <= 0 then
	log.log(this, "w_observation_comment_with_list:open", "Nothing to display", 3)
	close(this)
	return
elseif displayed_comment = 1 then
	st_comment_count.visible = false
	cb_prev.visible = false
	cb_next.visible = false
else
	st_comment_count.visible = true
	cb_prev.visible = true
	cb_next.visible = true
	cb_prev.enabled = true
	cb_next.enabled = false
end if

if service.manual_service then
	cb_beback.visible = false
end if

dictate_service = service.get_attribute("dictate_service")
if isnull(dictate_service) then dictate_service = "EXTERNAL_SOURCE"

dictate_external_source_type = service.get_attribute("dictate_external_source_type")
if isnull(dictate_external_source_type) then dictate_external_source_type = "Audio"

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_available_sources")
ll_count = luo_data.retrieve(gnv_app.computer_id, dictate_external_source_type)
if ll_count <= 0 then
	cb_dictate.visible = false
else
	cb_dictate.visible = true
end if

ls_control = datalist.get_preference("PREFERENCES", "punctuation_control", "PERIOD|, ")

f_split_string(ls_control, "|", cr_rule, punctuation)

mle_comments.setfocus()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_observation_comment_with_list
boolean visible = true
integer x = 2661
integer y = 128
integer taborder = 40
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_observation_comment_with_list
end type

type st_comment_title from statictext within w_observation_comment_with_list
integer x = 1390
integer y = 444
integer width = 1458
integer height = 64
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Comment Title"
boolean focusrectangle = false
end type

type st_comment_user from statictext within w_observation_comment_with_list
integer x = 1390
integer y = 368
integer width = 823
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Comment User"
boolean focusrectangle = false
end type

type cb_prev from commandbutton within w_observation_comment_with_list
integer x = 2459
integer y = 1352
integer width = 178
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<<"
end type

event clicked;display_comment(displayed_comment - 1)

end event

type cb_next from commandbutton within w_observation_comment_with_list
integer x = 2670
integer y = 1352
integer width = 178
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">>"
end type

event clicked;display_comment(displayed_comment + 1)

end event

type st_comment_count from statictext within w_observation_comment_with_list
integer x = 1381
integer y = 1468
integer width = 1472
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "99 of 99"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_personal from commandbutton within w_observation_comment_with_list
integer x = 1358
integer y = 1588
integer width = 466
integer height = 116
integer taborder = 90
boolean bringtotop = true
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

type cb_edit_list from commandbutton within w_observation_comment_with_list
integer x = 1376
integer y = 1352
integer width = 526
integer height = 92
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<< Add to List <<"
end type

event clicked;string ls_item_text
long ll_row
str_popup_return popup_return

ls_item_text = trim(mle_comments.selectedtext())
if isnull(ls_item_text) or ls_item_text = "" then
	ls_item_text = trim(mle_comments.text)
	if isnull(ls_item_text) or ls_item_text = "" then return
end if

if len(ls_item_text) > 255 then
	openwithparm(w_pop_yes_no, "You are attempting to create a pick-list item that is larger than 255 characters.  The text will be truncated to 255 characters.  Do you wish to add the truncated text to the pick-list?")
	popup_return = message.powerobjectparm
	if popup_return.item = "YES" then
		ls_item_text = left(ls_item_text, 255)
	else
		return
	end if
end if

ll_row = dw_complaint.insertrow(0)
dw_complaint.object.user_id[ll_row] = top_20_user_id
dw_complaint.object.top_20_code[ll_row] = top_20_code
dw_complaint.object.item_text[ll_row] = ls_item_text
dw_complaint.object.sort_sequence[ll_row] = ll_row

// We're wrapping this in a transaction because for some reason it causes the subsequent
// rpc call to fail with "object was open"
tf_begin_transaction(this, "clicked")
dw_complaint.update()
tf_commit()

dw_complaint.recalc_page(pb_up, pb_down, st_page)
dw_complaint.set_page(dw_complaint.last_page, pb_up, pb_down, st_page)

end event

type st_generic_list from statictext within w_observation_comment_with_list
integer x = 1755
integer y = 212
integer width = 379
integer height = 100
boolean bringtotop = true
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

type st_13 from statictext within w_observation_comment_with_list
integer x = 1929
integer y = 136
integer width = 402
integer height = 64
boolean bringtotop = true
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

type st_specific_list from statictext within w_observation_comment_with_list
integer x = 2181
integer y = 212
integer width = 379
integer height = 100
boolean bringtotop = true
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

type mle_comments from multilineedit within w_observation_comment_with_list
integer x = 1376
integer y = 516
integer width = 1513
integer height = 820
integer taborder = 10
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

event modified;modified_since_picked = true

if displayed_comment > prev_comment_count then
	new_comment = trim(text)
end if

end event

type cb_done from commandbutton within w_observation_comment_with_list
integer x = 2418
integer y = 1588
integer width = 402
integer height = 116
integer taborder = 90
boolean bringtotop = true
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
	log.log(this, "w_observation_comment_with_list.cb_done.clicked:0006", "Error saving comment", 4)
	return
end if

popup_return.items[1] = "CLOSE"
popup_return.item_count = 1
closewithreturn(parent, popup_return)



end event

type cb_beback from commandbutton within w_observation_comment_with_list
integer x = 1966
integer y = 1588
integer width = 402
integer height = 116
integer taborder = 100
boolean bringtotop = true
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
	log.log(this, "w_observation_comment_with_list.cb_beback.clicked:0006", "Error saving comment", 4)
	return
end if

popup_return.item_count = 0
closewithreturn(parent, popup_return)



end event

type cb_dictate from commandbutton within w_observation_comment_with_list
integer x = 1957
integer y = 1352
integer width = 416
integer height = 92
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Dictate"
end type

event clicked;str_popup_return popup_return
str_attributes lstr_attributes
string ls_msg
integer li_sts

if not isnull(new_comment) and trim(new_comment) <> "" then
	ls_msg = "You have already entered some comments.  Do you wish to replace them with dictated comments?"
	openwithparm(w_pop_yes_no, ls_msg)
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return
end if

lstr_attributes.attribute_count = 5
lstr_attributes.attribute[1].attribute = "observation_id"
lstr_attributes.attribute[1].value = service.treatment.get_observation_id(observation_sequence)
lstr_attributes.attribute[2].attribute = "observation_sequence"
lstr_attributes.attribute[2].value = string(observation_sequence)
lstr_attributes.attribute[3].attribute = "treatment_id"
lstr_attributes.attribute[3].value = string(service.treatment.treatment_id)
lstr_attributes.attribute[4].attribute = "external_source_type"
lstr_attributes.attribute[4].value = dictate_external_source_type
lstr_attributes.attribute[5].attribute = "comment_title"
lstr_attributes.attribute[5].value = comment_title
if isnull(lstr_attributes.attribute[5].value) then lstr_attributes.attribute[5].value = ""


li_sts = service_list.do_service(current_patient.cpr_id, service.encounter_id, dictate_service, service.treatment, lstr_attributes)
if li_sts <= 0 then return

popup_return.items[1] = "CLOSE"
popup_return.item_count = 1
closewithreturn(parent, popup_return)



end event

type pb_down from picturebutton within w_observation_comment_with_list
integer x = 1349
integer y = 240
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

event clicked;integer li_page
integer li_last_page

li_page = dw_complaint.current_page
li_last_page = dw_complaint.last_page

dw_complaint.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type pb_up from picturebutton within w_observation_comment_with_list
integer x = 1349
integer y = 116
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

type st_page from statictext within w_observation_comment_with_list
integer x = 1486
integer y = 120
integer width = 197
integer height = 56
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "99 of 99"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_punctuation from commandbutton within w_observation_comment_with_list
integer x = 2583
integer y = 348
integer width = 306
integer height = 84
integer taborder = 50
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

datalist.update_preference( "PREFERENCES", "User", current_scribe.user_id, "punctuation_control", ls_control)

f_split_string(ls_control, "|", cr_rule, punctuation)


end event

type st_title from statictext within w_observation_comment_with_list
integer width = 2917
integer height = 104
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Comments"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_complaint from u_dw_pick_list within w_observation_comment_with_list
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
string ls_punctuation

if mle_comments.displayonly then 
	clear_selected()
	return
end if

if lasttype = 'compute' then
	object.selected_flag[selected_row] = 1
	edit_menu(selected_row)
	clear_selected()
	return
end if



ls_punctuation = punctuation
ls_item_text = object.item_text[selected_row]
ls_temp = right(mle_comments.text, 1)

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
	mle_comments.text += ls_sep + "No " + ls_item_text + ls_punctuation
elseif lastcolumn = 4 then
	mle_comments.text += ls_sep + ls_item_text + ls_punctuation
	// Complaint button
end if

modified_since_picked = false

new_comment = mle_comments.text

object.selected_flag[selected_row] = 0

mle_comments.setfocus()
ll_len = len(mle_comments.text)
mle_comments.selecttext(ll_len + 1, 0)

end event


Start of PowerBuilder Binary Data Section : Do NOT Edit
01w_observation_comment_with_list.bin 
2900001200e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd00000004fffffffe00000005fffffffe0000000600000007fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff00000003000000000000000000000000000000000000000000000000000000007e3c3fa001c8c51200000003000006c00000000000500003004c004200430049004e0045004500530045004b000000590000000000000000000000000000000000000000000000000000000000000000000000000002001cffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000320000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000002001affffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000010000010000000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000101001a000000020000000100000004245338c34a2cbca33453b7a7e8a89959000000007e3c3fa001c8c5127e3c3fa001c8c512000000000000000000000000fffffffe000000020000000300000004fffffffe00000006fffffffe00000008000000090000000a0000000b0000000c0000000d0000000e0000000f000000100000001100000012000000130000001400000015000000160000001700000018000000190000001afffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
22ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff003200390034003500340036003600360020002000200020002000200020002000200020002000200020002000200020004500200061007200200073006500440000fffe00020205245338c34a2cbca33453b7a7e8a8995900000001fb8f0821101b01640008ed8413c72e2b00000030000000d000000006000001000000003800000101000000400000010200000048000001030000005000000104000000580000000000000060000000030001000000000003000001c2000000030000024600000003000000100000000b0000ffff0000000600000000000000010001030000000c0074735f00706b636f73706f7200010400000014006e6769006e65726f6c616e6f776168707364726f000101000000090078655f00746e65740102007800090000655f00006e65747800007974090000015f00000073726576006e6f6900010000000001c20000024600000010ff010000ffffffff01ffffff00010101000001010000000101000000737316006d616563786c742e6373732c326d6165786c632e00320010000000320a0100010100320073751701696472656c742e636f632c78636572726c742e74006c00780020006c006100530073006e004d0020ffffffff000000030000000400000001ffffffff0000000200000000000001dc00000261000004b20009000102590300000000000000021a0004000001030000006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffff00000005ffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000050000006d00000000004f00020065006c007200500073006500300030000000300000000000000000000000000000000000000000000000000000000000000000000000000000000000020018ffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000007000004f4000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050008020b000000000000000000050017020c00030012001e00000000000500030107000500000201000000ffffff0000000500000209021a00000f43000000cc002000150000000000100017000000000012002800000010000000150000000100000000001803f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c6c3c600c6c6c3c6c3c6c6c3c6c3c6c6c6c6c3c6c3c6c6c3c6c3c6c6c6c6c3c6c3c6c6c3c6c3c6c600c6c3c600000000c6c3c600c6c6c3c6c3c6c6c3c6c3c6c6c6c6c3c6c3c6c6c3c6c3c6c6c6c6c3c6c3c6c6c3c6c3c6c600c6c3c600000000c6c3c60000c6c3c600000000000000000000000000000000000000000000000000000000c6c3c60000c6c3c600000000c6c3c60000c6c3c6ffff0000ffffffffffffffffffffffffffffffffffffffff0000ffffc6c3c60000c6c3c600000000c6c3c60000c6c3c6ffff0000ffffffff00ffffffffffff00ffffffffffffffff0000ffffc6c3c60000c6c3c600000000c6c3c60000c6c3c6ffff0000ffffffff00ffffff0000ff00ffffffffffffffff0000ffffc6c3c60000c6c3c600000000c6c3c60000c6c3c6ffff0000ffffffff00ff00000000ff00ffffffffffffffff0000ffffc6c3c60000c6c3c600000000c6c3c60000c6c3c6ffff0000ffffffffffff00000000ffffff0000ffffffffff0000ffffc6c3c60000c6c3c600000000c6c3c60000c6c3c6ffff0000ffffffffffffffffffffffffff0000ffffffffff0000ffffc6c3c60000c6c3c600000000c6c3c60000c6c3c6ffff0000ffffffffffffffffffffffffff0000ffffff00000000ffffc6c3c60000c6c3c600000000c6c3c60000c6c3c6ffff0000ffffffffffffffffffffffffffffffffffff00000000ffffc6c3c60000c6c3c600000000c6c3c60000c6c3c6ffff0000ffffffffffffffffffffffffffffffff00ff00000000ff00c6c3c60000c6c3c600000000c6c3c60000c6c3c6000000000000000000000000ffff0000ffffffff00ffffff0000ff00c6c3c60000c6c3c600000000c6c3c600c6c6c3c60000c6c3ffffff0000ffffffffff0000ffffffffffffffff0000ffffc6c3c60000c6c3c600000000c6c3c600c6c6c3c6c3c6c6c3000000c600ffffffffff0000ffffffffffffffff0000ffffc6c3c60000c6c3c600000000c6c3c600c6c6c3c6c3c6c6c3c6c3c6c600000000
28ffff0000ffffffffffffffff0000ffffc6c3c60000c6c3c600000000c6c3c600c6c6c3c6c3c6c6c3c6c3c6c600c6c3c600000000000000000000000000000000c6c3c60000c6c3c600000000c6c3c600c6c6c3c6c3c6c6c3c6c3c6c6c6c6c3c6c3c6c6c3c6c3c6c6c6c6c3c6c3c6c6c3c6c3c6c600c6c3c600000000c6c3c600c6c6c3c6c3c6c6c3c6c3c6c6c6c6c3c6c3c6c6c3c6c3c6c6c6c6c3c6c3c6c6c3c6c3c6c600c6c3c6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000500000107000000000001000000050001020100050000020900000000000100000004ffff0127000000030000000000000000000000000000000000000000494e414e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11w_observation_comment_with_list.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
