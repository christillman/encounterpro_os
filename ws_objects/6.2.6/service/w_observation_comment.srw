HA$PBExportHeader$w_observation_comment.srw
forward
global type w_observation_comment from w_window_base
end type
type pb_done from u_picture_button within w_observation_comment
end type
type pb_cancel from u_picture_button within w_observation_comment
end type
type st_title from statictext within w_observation_comment
end type
type mle_comments from multilineedit within w_observation_comment
end type
type st_comment_title from statictext within w_observation_comment
end type
type st_comment_user from statictext within w_observation_comment
end type
type cb_prev from commandbutton within w_observation_comment
end type
type cb_next from commandbutton within w_observation_comment
end type
type st_comment_count from statictext within w_observation_comment
end type
end forward

global type w_observation_comment from w_window_base
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_done pb_done
pb_cancel pb_cancel
st_title st_title
mle_comments mle_comments
st_comment_title st_comment_title
st_comment_user st_comment_user
cb_prev cb_prev
cb_next cb_next
st_comment_count st_comment_count
end type
global w_observation_comment w_observation_comment

type variables

u_component_service service
u_component_treatment treatment

long observation_sequence
string comment_title
string comment_user_id

str_observation_comment prev_comments[]
integer prev_comment_count

integer displayed_comment
string new_comment

end variables

forward prototypes
public function integer load_attachments ()
end prototypes

public function integer load_attachments ();integer i
integer li_count

//li_count = attachment_list.rowcount()

for i = 1 to li_count
next

return li_count

end function

on w_observation_comment.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.st_title=create st_title
this.mle_comments=create mle_comments
this.st_comment_title=create st_comment_title
this.st_comment_user=create st_comment_user
this.cb_prev=create cb_prev
this.cb_next=create cb_next
this.st_comment_count=create st_comment_count
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.mle_comments
this.Control[iCurrent+5]=this.st_comment_title
this.Control[iCurrent+6]=this.st_comment_user
this.Control[iCurrent+7]=this.cb_prev
this.Control[iCurrent+8]=this.cb_next
this.Control[iCurrent+9]=this.st_comment_count
end on

on w_observation_comment.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.st_title)
destroy(this.mle_comments)
destroy(this.st_comment_title)
destroy(this.st_comment_user)
destroy(this.cb_prev)
destroy(this.cb_next)
destroy(this.st_comment_count)
end on

event open;call super::open;str_popup popup
str_observation_comment lstr_comment
integer i, j
datetime ldt_created
string ls_temp
integer li_sts

popup = message.powerobjectparm

if popup.data_row_count <> 3 then
	log.log(this, "open", "Invalid parameters", 4)
	close(this)
	return
end if

service = popup.objectparm
treatment = service.treatment
observation_sequence = long(popup.items[1])
comment_user_id = popup.items[2]
comment_title = popup.items[3]

st_comment_user.text = user_list.user_full_name(comment_user_id)
if trim(comment_title) = "" then setnull(comment_title)

if isnull(comment_title) then
	st_comment_title.visible = false
else
	st_comment_title.text = comment_title
end if

st_title.text = popup.title

title = current_patient.id_line()

if isnull(observation_sequence) then
	observation_sequence = service.get_root_observation()
end if

prev_comment_count = 0

// Display the comment which matches both the user_id and the comment_title
li_sts = treatment.get_comment(observation_sequence, comment_title, lstr_comment)
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

if comment_user_id = current_user.user_id then
	displayed_comment = prev_comment_count + 1
	mle_comments.displayonly = false
	mle_comments.backcolor = color_white
	pb_cancel.visible = true
	ls_temp = "New Comment"
else
	displayed_comment = prev_comment_count
	mle_comments.displayonly = true
	mle_comments.backcolor = color_object
	pb_cancel.visible = false
	ls_temp = string(ldt_created, date_format_string) + " " + string(ldt_created, time_format_string)
end if

st_comment_count.text = string(displayed_comment) + " of " + string(displayed_comment)
st_comment_count.text += "  -  " + ls_temp

if displayed_comment <= 0 then
	log.log(this, "open", "Nothing to display", 3)
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

mle_comments.setfocus()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_observation_comment
boolean visible = true
integer x = 2249
integer y = 1544
integer taborder = 40
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_observation_comment
end type

type pb_done from u_picture_button within w_observation_comment
integer x = 2597
integer y = 1480
integer taborder = 20
boolean originalsize = false
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;string ls_abnormal_flag
integer li_severity
string ls_prev_comment

setnull(ls_abnormal_flag)
setnull(li_severity)

if comment_user_id = current_user.user_id then
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
		treatment.add_comment(observation_sequence, comment_title, ls_abnormal_flag, li_severity, new_comment)
	end if
end if

close(parent)

end event

type pb_cancel from u_picture_button within w_observation_comment
boolean visible = false
integer x = 55
integer y = 1480
integer taborder = 30
boolean bringtotop = true
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;string ls_abnormal_flag
integer li_severity
string ls_prev_comment
str_popup_return popup_return

setnull(ls_abnormal_flag)
setnull(li_severity)

if comment_user_id = current_user.user_id then
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
	
	// If the comment changed then ask the user if they're sure they want to cancel
	if new_comment <> ls_prev_comment then
		openwithparm(w_pop_yes_no, "Are you sure you wish to exit without saving these comments?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
	end if
end if

close(parent)



end event

type st_title from statictext within w_observation_comment
integer width = 2917
integer height = 164
boolean bringtotop = true
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Comments"
alignment alignment = center!
boolean focusrectangle = false
end type

type mle_comments from multilineedit within w_observation_comment
integer x = 73
integer y = 268
integer width = 2761
integer height = 1148
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

event modified;if displayed_comment > prev_comment_count then
	new_comment = trim(text)
end if

end event

type st_comment_title from statictext within w_observation_comment
integer x = 87
integer y = 188
integer width = 1595
integer height = 64
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Comment Title"
boolean focusrectangle = false
end type

type st_comment_user from statictext within w_observation_comment
integer x = 1801
integer y = 188
integer width = 1033
integer height = 64
boolean bringtotop = true
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Comment User"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_prev from commandbutton within w_observation_comment
integer x = 1230
integer y = 1480
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

event clicked;datetime ldt_created

displayed_comment -= 1

if displayed_comment <= 1 then
	displayed_comment = 1
	enabled = false
else
	enabled = true
end if


mle_comments.text = prev_comments[displayed_comment].comment
mle_comments.displayonly = true
mle_comments.backcolor = color_object
ldt_created = prev_comments[displayed_comment].created

cb_next.enabled = true

st_comment_count.text = string(displayed_comment) + " of " + string(prev_comment_count + 1)
st_comment_count.text += "  -  " + string(ldt_created, date_format_string) + " " + string(ldt_created, time_format_string)

end event

type cb_next from commandbutton within w_observation_comment
integer x = 1504
integer y = 1480
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

event clicked;datetime ldt_created

displayed_comment += 1

if displayed_comment > prev_comment_count then
	displayed_comment = prev_comment_count + 1
	enabled = false
	if comment_user_id = current_user.user_id then
		mle_comments.displayonly = false
		mle_comments.backcolor = color_white
		mle_comments.text = new_comment
		setnull(ldt_created)
	else
		displayed_comment = prev_comment_count
		ldt_created = prev_comments[displayed_comment].created
	end if
else
	if comment_user_id = current_user.user_id then
		if displayed_comment > prev_comment_count then enabled = false
	else
		if displayed_comment = prev_comment_count then enabled = false
	end if
	mle_comments.displayonly = true
	mle_comments.backcolor = color_object
	mle_comments.text = prev_comments[displayed_comment].comment
	ldt_created = prev_comments[displayed_comment].created
end if

cb_prev.enabled = true

st_comment_count.text = string(displayed_comment) + " of " + string(prev_comment_count + 1)
if isnull(ldt_created) then
	st_comment_count.text += "  -  New Comment"
else
	st_comment_count.text += "  -  " + string(ldt_created, date_format_string) + " " + string(ldt_created, time_format_string)
end if

end event

type st_comment_count from statictext within w_observation_comment
integer x = 827
integer y = 1612
integer width = 1253
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
string text = "99 of 99"
alignment alignment = center!
boolean focusrectangle = false
end type

