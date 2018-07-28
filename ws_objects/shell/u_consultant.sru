HA$PBExportHeader$u_consultant.sru
forward
global type u_consultant from statictext
end type
end forward

global type u_consultant from statictext
integer width = 613
integer height = 68
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type
global u_consultant u_consultant

type variables
string specialty_id
string consultant_id
string specialty_description
string consultant_description
boolean WasModified
end variables

forward prototypes
public subroutine pretty_text ()
public subroutine set_consultant (string ps_consultant_id)
public subroutine set_specialty (string ps_specialty_id)
end prototypes

public subroutine pretty_text ();string ls_description
integer li_sts

if isnull(consultant_id) then
	text = ""
else
	text = consultant_description
end if
end subroutine

public subroutine set_consultant (string ps_consultant_id);integer li_sts
string ls_description

ls_description = datalist.consultant_description(ps_consultant_id)
if isnull(ls_description) then
	setnull(consultant_id)
	setnull(consultant_description)
else
	consultant_id = ps_consultant_id
	consultant_description = ls_description
end if

pretty_text()

end subroutine

public subroutine set_specialty (string ps_specialty_id);integer li_sts
string ls_description

ls_description = datalist.specialty_description(ps_specialty_id)
if isnull(ls_description) then
	setnull(specialty_id)
	setnull(specialty_description)
else
	specialty_id = ps_specialty_id
	specialty_description = ls_description
end if


end subroutine

event clicked;//string ls_null
//str_popup popup
//str_popup_return popup_return
//
//setnull(ls_null)
//popup.dataobject = "dw_sp_get_preferred_provider"
//popup.argument[1] = current_patient.cpr_id
//popup.argument[2] = specialty_id
//popup.argument[3] = ls_null
//popup.argument_count = 3
//
//openwithparm(w_pop_pick, popup)
//
//popup_return = message.powerobjectparm
//if isvalid(popup_return) and not isnull(popup_return) then
//	set_consultant(popup_return.item)
//end if
str_pick_users lstr_pick_users
integer li_sts

lstr_pick_users.actor_class = "Consultant"
lstr_pick_users.specialty_id = specialty_id
lstr_pick_users.hide_users = true

if not isnull(current_patient) then
	lstr_pick_users.cpr_id = current_patient.cpr_id
end if

lstr_pick_users.pick_screen_title = "Select Consultant"
li_sts = user_list.pick_users(lstr_pick_users)
if li_sts <= 0 then return

set_consultant(lstr_pick_users.selected_users.user[1].user_id)


end event

on constructor;setnull(specialty_id)
setnull(consultant_id)
end on

on u_consultant.create
end on

on u_consultant.destroy
end on

