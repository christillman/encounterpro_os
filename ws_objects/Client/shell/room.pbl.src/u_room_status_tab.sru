$PBExportHeader$u_room_status_tab.sru
forward
global type u_room_status_tab from u_main_tabpage_base
end type
type cb_checkin from commandbutton within u_room_status_tab
end type
type cb_cleaned from commandbutton within u_room_status_tab
end type
type st_empty from statictext within u_room_status_tab
end type
type cb_get_patient from commandbutton within u_room_status_tab
end type
type uo_room from u_room_status within u_room_status_tab
end type
end forward

global type u_room_status_tab from u_main_tabpage_base
integer width = 2414
integer height = 1704
long tabbackcolor = 16777215
event refresh_tab pbm_custom02
event resized ( )
cb_checkin cb_checkin
cb_cleaned cb_cleaned
st_empty st_empty
cb_get_patient cb_get_patient
uo_room uo_room
end type
global u_room_status_tab u_room_status_tab

type variables
u_room this_room
string room_id
string room_type
string room_name

string encounter_type
string new_encounter_service = "CHECKIN"

long room_menu_id

end variables

forward prototypes
public subroutine just_logged_on ()
public subroutine initialize (string ps_room_id, string ps_room_name)
public subroutine do_next_service ()
end prototypes

event refresh_tab;this.event refresh()

end event

public subroutine just_logged_on ();integer li_count, i
string ls_attending_doctor
string ls_service

just_logged_on = false

if uo_room.visible then
	do_next_service()
//	li_count = uo_room.rowcount()
//	if li_count = 1 then
//		ls_service = uo_room.object.service[1]
//		if ls_service = "EXAM" or ls_service = "RECHECK" then
//			ls_attending_doctor = uo_room.object.attending_doctor[1]
//			if ls_attending_doctor = current_user.user_id then
//				uo_room.do_service(1)
//			end if
//		end if
//	end if
elseif cb_get_patient.enabled then
//	i = current_user.get_service_index("GET_PATIENT")
	if i > 0 then
//		if current_user.primary_flag[i] = "Y" then
//			current_user.sticky_logon = false
//			cb_get_patient.postevent("clicked")
//		end if
	end if
end if


end subroutine

public subroutine initialize (string ps_room_id, string ps_room_name);room_id = ps_room_id
room_name = ps_room_name

this_room = room_list.find_room(room_id)

uo_room.initialize(room_id)

room_type = uo_room.room_type

room_menu_id = f_get_context_menu2("Room Checkin", room_id, room_type)

if isnull(this_room.room_default_encounter_type) and isnull(room_menu_id) then
	cb_checkin.visible = false
else
	cb_checkin.visible = true
end if

this.event trigger resized()

this.event refresh()


end subroutine

public subroutine do_next_service ();integer li_count
string ls_owned_by
string ls_service
boolean lb_do_service
long ll_patient_workplan_item_id
long ll_last_patient_workplan_item_id
integer i

if not uo_room.visible then return

ll_last_patient_workplan_item_id = 0

DO
	// Set do_service flag to false
	lb_do_service = false
	
	// Count the services waiting
	li_count = uo_room.rowcount()
	
	// If only one service waiting, then check if it's for the current_user
	if li_count = 1 then
		// First, check the owned_by field
		ls_owned_by = uo_room.object.owned_by[1]
		ll_patient_workplan_item_id = uo_room.object.patient_workplan_item_id[1]
		
		// If this service is the same as the last service, then don't do it
		if ll_patient_workplan_item_id = ll_last_patient_workplan_item_id then
			exit
		else
			ll_last_patient_workplan_item_id = ll_patient_workplan_item_id
		end if

		if isnull(ls_owned_by) then
			// If there is no owned_by field, then check the service's primary_flag for this user
			ls_service = uo_room.object.service[1]
//			i = current_user.get_service_index(ls_service)
			if i > 0 then
//				if current_user.primary_flag[i] = "Y" then
//					lb_do_service = true
//				end if
			end if
		else
			// If we have an owned_by, then check against the user_id and the users role(s)
			if ls_owned_by = current_user.user_id or user_list.is_user_role(current_user.user_id, ls_owned_by) then
				lb_do_service = true
			end if
		end if
	end if

	// If we found a match, the perform the service
//	if lb_do_service then
//		uo_room.do_service(1)
//		refresh()
//	end if
LOOP WHILE lb_do_service and not isnull(current_user)


end subroutine

on u_room_status_tab.create
int iCurrent
call super::create
this.cb_checkin=create cb_checkin
this.cb_cleaned=create cb_cleaned
this.st_empty=create st_empty
this.cb_get_patient=create cb_get_patient
this.uo_room=create uo_room
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_checkin
this.Control[iCurrent+2]=this.cb_cleaned
this.Control[iCurrent+3]=this.st_empty
this.Control[iCurrent+4]=this.cb_get_patient
this.Control[iCurrent+5]=this.uo_room
end on

on u_room_status_tab.destroy
call super::destroy
destroy(this.cb_checkin)
destroy(this.cb_cleaned)
destroy(this.st_empty)
destroy(this.cb_get_patient)
destroy(this.uo_room)
end on

event refresh;call super::refresh;integer li_sts
string ls_room_status
integer li_waiting_count
str_encounter_list lstr_encounters
long ll_patient_count
str_room lstr_room
string ls_temp
long ll_description_x

if not isvalid(this_room) then return


// Place objects
cb_cleaned.y = height - 128
cb_checkin.y = cb_cleaned.y
cb_get_patient.y = cb_cleaned.y

cb_get_patient.x = width - cb_get_patient.width - cb_cleaned.x
cb_checkin.x = cb_cleaned.x + cb_cleaned.width + ((cb_get_patient.x - cb_cleaned.x - cb_cleaned.width - cb_checkin.width) / 2)

uo_room.width = width - 60
uo_room.height = height - 160

if uo_room.width <= 2400 then
	ll_description_x = 1216
else
	ll_description_x = 1216 + ((uo_room.width - 2400) / 2)
	if ll_description_x > 2000 then ll_description_x = 2000
end if

uo_room.object.description.x = ll_description_x
uo_room.object.compute_alert_bitmap.x = uo_room.width - 155
//uo_room.object.description.width = uo_room.width - 1316
//uo_room.object.in_use.x = uo_room.width - 1316 - 36

// Set the colors if they're different
if backcolor <> 7191717 then backcolor = 7191717
if long(uo_room.object.datawindow.color) <> 7191717 then uo_room.object.datawindow.color = 7191717

uo_room.refresh()

ll_patient_count = uo_room.rowcount()

if ll_patient_count = 0 then
	if text <> room_name then text = room_name
	uo_room.visible = false
	st_empty.visible = true
else
	ls_temp = room_name + " (" + string(ll_patient_count) + ")"
	if text <> ls_temp then text = ls_temp
	uo_room.visible = true
	st_empty.visible = false
end if

lstr_encounters = datalist.office_room_encounters("$WAITING")
if lstr_encounters.encounter_count > 0 then
	cb_get_patient.enabled = true
else
	cb_get_patient.enabled = false
end if

// Get the latest room_status
if not isnull(room_id) and room_id <> "!!NOWHERE" then
	lstr_room = datalist.office_room(room_id)
	if lstr_room.room_status = "DIRTY" then
		cb_cleaned.visible = true
	else
		cb_cleaned.visible = false
	end if
else
	cb_cleaned.visible = false
end if

if just_logged_on then just_logged_on()

end event

type cb_checkin from commandbutton within u_room_status_tab
integer x = 965
integer y = 1556
integer width = 425
integer height = 108
integer taborder = 13
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Check-In"
end type

event clicked;str_popup popup
str_popup_return popup_return
u_user luo_user
str_attributes lstr_attributes

f_user_logon()
if isnull(current_user) then return 1

lstr_attributes.attribute_count = 0

if not isnull(this_room.room_default_encounter_type) then
	f_attribute_add_attribute(lstr_attributes, "encounter_type", this_room.room_default_encounter_type)
end if

luo_user = user_list.find_user(datalist.encounter_type_default_role(this_room.room_default_encounter_type))
if not isnull(luo_user) then
	f_attribute_add_attribute(lstr_attributes, "attending_doctor", luo_user.user_id)
end if	

if room_menu_id > 0 then
	f_display_menu_with_attributes(room_menu_id, true, lstr_attributes)
else
	service_list.do_service(new_encounter_service, lstr_attributes)
end if

parent.event refresh()

end event

type cb_cleaned from commandbutton within u_room_status_tab
integer x = 18
integer y = 1556
integer width = 425
integer height = 108
integer taborder = 10
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cleaned"
end type

event clicked;if not isnull(this_room) then
	this_room.set_room_status("OK")
	visible = false
end if

end event

type st_empty from statictext within u_room_status_tab
boolean visible = false
integer x = 274
integer y = 40
integer width = 1874
integer height = 240
integer textsize = -36
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Empty"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_get_patient from commandbutton within u_room_status_tab
integer x = 1856
integer y = 1556
integer width = 425
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Get Patient"
end type

event clicked;Integer				li_sts
long i
Boolean				lb_sticky_logon
Long					ll_encounter_id
long					ll_patient_workplan_item_id
String				ls_cpr_id
String				ls_right
u_ds_data luo_data
long ll_count
integer li_index
string ls_user_id
u_user luo_user
integer li_minutes
string ls_patient
u_component_service			luo_service
str_popup			popup
str_popup_return	popup_return
string ls_encounter_description
str_service_info lstr_service


f_user_logon()
if isnull(current_user) then return

// Since multiple patients can be got, record and turn on sticky logon and then check it at the end
lb_sticky_logon = current_user.sticky_logon
setnull(current_user.sticky_logon)

lstr_service.service = "Service List"
f_attribute_add_attribute(lstr_service.attributes, "this_room_id", room_id)
service_list.do_service(lstr_service)

parent.event refresh()

If isnull(current_user) Then return

current_user.sticky_logon = lb_sticky_logon

do_next_service()

//current_user.complete_service()


end event

type uo_room from u_room_status within u_room_status_tab
integer height = 1524
integer taborder = 20
boolean border = false
end type

