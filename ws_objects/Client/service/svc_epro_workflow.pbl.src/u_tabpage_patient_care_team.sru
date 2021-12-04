$PBExportHeader$u_tabpage_patient_care_team.sru
forward
global type u_tabpage_patient_care_team from u_tabpage
end type
type cbx_include_users from checkbox within u_tabpage_patient_care_team
end type
type cb_add from commandbutton within u_tabpage_patient_care_team
end type
type dw_care_team from u_dw_pick_list within u_tabpage_patient_care_team
end type
type st_title from statictext within u_tabpage_patient_care_team
end type
end forward

global type u_tabpage_patient_care_team from u_tabpage
integer width = 2875
integer height = 1272
string text = "none"
cbx_include_users cbx_include_users
cb_add cb_add
dw_care_team dw_care_team
st_title st_title
end type
global u_tabpage_patient_care_team u_tabpage_patient_care_team

type variables
boolean dw_has_focus
end variables

forward prototypes
public subroutine refresh ()
public subroutine item_menu (long pl_row)
public function integer initialize ()
end prototypes

public subroutine refresh ();string ls_include_users

dw_care_team.object.user_full_name.width = dw_care_team.width - 260

if cbx_include_users.checked then
	ls_include_users = "Y"
else
	ls_include_users = "N"
end if

dw_care_team.settransobject(sqlca)
dw_care_team.retrieve(current_patient.cpr_id, ls_include_users, "%")


end subroutine

public subroutine item_menu (long pl_row);str_popup popup
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
string ls_user_status
boolean lb_active
integer li_count
string ls_license_flag
long ll_picked_computer_id
datetime ldt_null
boolean lb_care_team
boolean lb_primary
string ls_find
long ll_care_team_row
string ls_actor_class

setnull(ldt_null)
setnull(ls_null)
setnull(ll_null)

lb_active = false
lb_primary = false

ls_description = dw_care_team.object.user_full_name[pl_row]
ls_user_status = dw_care_team.object.user_status[pl_row]
ls_user_id = dw_care_team.object.user_id[pl_row]
ls_actor_class = dw_care_team.object.actor_class[pl_row]

if upper(ls_user_id) = "#PATIENT" then
	openwithparm(w_pop_message, "The patient cannot be removed from their own care team")
	return
end if


if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_remove_careteam.bmp"
	popup.button_helps[popup.button_count] = "Remove this " + lower(ls_actor_class) + " from the patient's care team"
	popup.button_titles[popup.button_count] = "Take Off Care Team"
	buttons[popup.button_count] = "REMOVECARETEAM"
end if

if not lb_primary then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_make_primary.bmp"
	popup.button_helps[popup.button_count] = "Make this " + lower(ls_actor_class) + " a Primary care team actor"
	popup.button_titles[popup.button_count] = "Make Primary"
	buttons[popup.button_count] = "MAKEPRIMARY"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_edit2.bmp"
	popup.button_helps[popup.button_count] = "Edit this " + lower(ls_actor_class)
	popup.button_titles[popup.button_count] = "Edit " + wordcap(ls_actor_class)
	buttons[popup.button_count] = "EDITUSER"
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
	CASE "ADDCARETEAM"
		li_sts = f_set_progress(current_patient.cpr_id, &
							"Patient", &
							ll_null, &
							"Care Team", &
							ls_user_id, &
							"True", &
							ldt_null, &
							ll_null, &
							ll_null, &
							ll_null)
		refresh( )
	CASE "REMOVECARETEAM"
		li_sts = f_set_progress(current_patient.cpr_id, &
							"Patient", &
							ll_null, &
							"Care Team", &
							ls_user_id, &
							"False", &
							ldt_null, &
							ll_null, &
							ll_null, &
							ll_null)
		refresh( )
	CASE "MAKEPRIMARY"
		li_sts = f_set_progress(current_patient.cpr_id, &
							"Patient", &
							ll_null, &
							"Care Team", &
							ls_user_id, &
							"Primary", &
							ldt_null, &
							ll_null, &
							ll_null, &
							ll_null)
		refresh()
	CASE "EDITUSER"
		popup.data_row_count = 1
		popup.items[1] = ls_user_id
		openwithparm(w_user_definition, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		dw_care_team.object.user_full_name[pl_row] = popup_return.descriptions[1]
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end subroutine

public function integer initialize ();
this.event TRIGGER resize_tabpage()

return 1

end function

on u_tabpage_patient_care_team.create
int iCurrent
call super::create
this.cbx_include_users=create cbx_include_users
this.cb_add=create cb_add
this.dw_care_team=create dw_care_team
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_include_users
this.Control[iCurrent+2]=this.cb_add
this.Control[iCurrent+3]=this.dw_care_team
this.Control[iCurrent+4]=this.st_title
end on

on u_tabpage_patient_care_team.destroy
call super::destroy
destroy(this.cbx_include_users)
destroy(this.cb_add)
destroy(this.dw_care_team)
destroy(this.st_title)
end on

event resize_tabpage;call super::resize_tabpage;st_title.height = 116
cbx_include_users.height = 80
cbx_include_users.width = 910
cb_add.height = 112
cb_add.width = 731

st_title.x = 0
st_title.y = 0
st_title.width = width

cb_add.x = (width - cb_add.width) / 2
cb_add.y = height - cb_add.height - 50

cbx_include_users.x = 100
cbx_include_users.y = cb_add.y + ((cb_add.height - cbx_include_users.height) / 2)

dw_care_team.x = 100
dw_care_team.y = st_title.height + 50
dw_care_team.width = width - 200
dw_care_team.height = cb_add.y - dw_care_team.y - 50


end event

type cbx_include_users from checkbox within u_tabpage_patient_care_team
integer x = 101
integer y = 1096
integer width = 910
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
string text = "Include EncounterPRO Users"
end type

event clicked;refresh()

end event

type cb_add from commandbutton within u_tabpage_patient_care_team
integer x = 1070
integer y = 1080
integer width = 731
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add To Care Team ..."
end type

event clicked;long ll_null
datetime ldt_null
integer li_sts
str_pick_users lstr_pick_users
long i
str_popup popup
str_popup_return popup_return

setnull(ll_null)
setnull(ldt_null)

// First get the actor class
popup.dataobject = "dw_domain_notranslate_list"
popup.argument_count = 1
popup.argument[1] = "Care Team Actor Class"
popup.datacolumn = 2
popup.displaycolumn = 2
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if lower(popup_return.items[1]) = "user" then
	setnull(lstr_pick_users.actor_class)
else
	lstr_pick_users.actor_class = popup_return.items[1]
	lstr_pick_users.hide_users = true
end if

user_list.pick_users(lstr_pick_users)

for i = 1 to lstr_pick_users.selected_users.user_count
	li_sts = f_set_progress(current_patient.cpr_id, &
						"Patient", &
						ll_null, &
						"Care Team", &
						lstr_pick_users.selected_users.user[i].user_id, &
						"True", &
						ldt_null, &
						ll_null, &
						ll_null, &
						ll_null)
next


refresh( )

end event

type dw_care_team from u_dw_pick_list within u_tabpage_patient_care_team
integer x = 101
integer y = 116
integer width = 2633
integer height = 928
integer taborder = 10
string dataobject = "dw_jmj_patient_care_team_list"
boolean vscrollbar = true
end type

event selected;call super::selected;item_menu(selected_row)
clear_selected()

end event

type st_title from statictext within u_tabpage_patient_care_team
integer width = 2871
integer height = 116
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Patient Care Team"
alignment alignment = center!
boolean focusrectangle = false
end type

