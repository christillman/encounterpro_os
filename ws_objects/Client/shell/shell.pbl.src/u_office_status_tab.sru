$PBExportHeader$u_office_status_tab.sru
forward
global type u_office_status_tab from u_main_tabpage_base
end type
type uo_office_status_1 from u_office_status within u_office_status_tab
end type
type uo_office_status_2 from u_office_status within u_office_status_tab
end type
type ln_1 from line within u_office_status_tab
end type
type str_office from structure within u_office_status_tab
end type
end forward

type str_office from structure
	string		office_id
	string		description
	string		server
	string		dbname
	string		dbms
end type

global type u_office_status_tab from u_main_tabpage_base
integer width = 2254
integer height = 1736
long tabbackcolor = 16777215
event refresh pbm_custom01
event refresh_tab pbm_custom02
event resized ( )
uo_office_status_1 uo_office_status_1
uo_office_status_2 uo_office_status_2
ln_1 ln_1
end type
global u_office_status_tab u_office_status_tab

type variables
long group_id
string group_description
string persistence_flag

boolean first_time = true

long normal_tab_color
long priority_tab_color
end variables

forward prototypes
public subroutine refresh ()
public subroutine refresh_tab ()
public subroutine initialize (long pl_group_id, string ps_description, string ps_persistence_flag)
end prototypes

event refresh;refresh()

end event

event refresh_tab;refresh_tab()

end event

event resized();long description_x

if uo_office_status_1.width <= 1115 then
	description_x = 562
else
	description_x = 562 + ((uo_office_status_1.width - 1115) / 2)
	if description_x > 900 then description_x = 900
end if

uo_office_status_1.width = (width - 104) / 2
uo_office_status_1.height = height - 8

uo_office_status_1.object.description.x = description_x
uo_office_status_1.object.room_name.width = uo_office_status_1.width - 498
uo_office_status_1.object.user_short_name.x = uo_office_status_1.width - 470
uo_office_status_1.object.l_1.x2 = uo_office_status_1.width - 12
uo_office_status_1.object.compute_alert_bitmap.x = uo_office_status_1.width - 85
//uo_office_status_1.object.description.width = uo_office_status_1.width - 575
//uo_office_status_1.object.in_use.x = uo_office_status_1.width - 45

ln_1.beginx = uo_office_status_1.width + 5
ln_1.endx = ln_1.beginx
ln_1.beginy = 0
ln_1.endy = height

uo_office_status_2.x = uo_office_status_1.width + 19
uo_office_status_2.width = uo_office_status_1.width + 80
uo_office_status_2.height = uo_office_status_1.height

uo_office_status_2.object.description.x = description_x
uo_office_status_2.object.room_name.width = uo_office_status_1.width - 498
uo_office_status_2.object.user_short_name.x = uo_office_status_1.width - 470
uo_office_status_2.object.l_1.x2 = uo_office_status_2.width - 92
uo_office_status_2.object.compute_alert_bitmap.x = uo_office_status_2.width - 155
//uo_office_status_2.object.description.width = uo_office_status_2.width - 655
//uo_office_status_2.object.in_use.x = uo_office_status_2.width - 125

end event

public subroutine refresh ();integer i
integer li_sts
long ll_group_id
string ls_description
str_popup popup
str_popup_return popup_return
long ll_lastrow
long ll_rowcount
long ll_count
string ls_priority_bitmap
string ls_new_tabtext
long ll_new_tabtextcolor

if backcolor <> color_background then backcolor = color_background
if long(uo_office_status_1.object.datawindow.color) <> color_background then uo_office_status_1.object.datawindow.color = color_background
if long(uo_office_status_2.object.datawindow.color) <> color_background then uo_office_status_2.object.datawindow.color = color_background

this.event TRIGGER resized()

uo_office_status_1.refresh(uo_office_status_2)

ll_lastrow = long(uo_office_status_2.Object.DataWindow.LastRowOnPage)
ll_rowcount = uo_office_status_2.rowcount()
if ll_rowcount > ll_lastrow then
	uo_office_status_2.VScrollBar = true
else
	uo_office_status_2.VScrollBar = false
end if

common_thread.set_max_priority(uo_office_status_1.max_priority)

ls_priority_bitmap = datalist.priority_bitmap(uo_office_status_1.max_priority)
if len(ls_priority_bitmap) > 0 then
	if picturename <> ls_priority_bitmap then picturename = ls_priority_bitmap
else
	// Clear out the picture if we couldn't find one
	if picturename <> "" then picturename = ""
end if

if uo_office_status_1.patient_count <= 0 AND persistence_flag = "N" then
	visible = false
else
	visible = true
end if

ls_new_tabtext = group_description + " " + string(uo_office_status_1.patient_count)
ll_new_tabtextcolor = color_black
if not isnull(current_user) then
	ls_new_tabtext += "/" + string(uo_office_status_1.my_patient_count) + "/" + string(uo_office_status_1.my_role_patient_count)
	
	if uo_office_status_1.my_patient_count > 0 then
		ll_new_tabtextcolor = color_text_error
	elseif uo_office_status_1.my_role_patient_count > 0 then
		ll_new_tabtextcolor = color_text_warning
	end if
end if

//ll_count = uo_office_status_1.patient_count
//if isnull(ll_count) or ll_count <= 0 then
//	ls_new_tabtext = group_description
//	if tabtextcolor <> color_black then tabtextcolor = color_black
//	if persistence_flag = "N" then
//		visible = false
//	else
//		visible = true
//	end if
//elseif isnull(current_user) or uo_office_status_1.my_patient_count <= 0 then
//	ls_new_tabtext = group_description + " " + string(ll_count)
//	if tabtextcolor <> color_black then tabtextcolor = color_black
////	if tabbackcolor <> normal_tab_color then tabbackcolor = normal_tab_color
//	visible = true
//else
//	ls_new_tabtext = group_description + " " + string(ll_count) + "/" + string(uo_office_status_1.my_patient_count)
//	if tabtextcolor <> color_text_error then tabtextcolor = color_text_error
////	if tabbackcolor <> priority_tab_color then tabbackcolor = priority_tab_color
//	visible = true
//end if


if tabtextcolor <> ll_new_tabtextcolor then tabtextcolor = ll_new_tabtextcolor
if text <> ls_new_tabtext then text = ls_new_tabtext

end subroutine

public subroutine refresh_tab ();refresh()

end subroutine

public subroutine initialize (long pl_group_id, string ps_description, string ps_persistence_flag);normal_tab_color = rgb(192, 192, 192)
priority_tab_color = rgb(255, 224, 224)

group_id = pl_group_id
group_description = ps_description
persistence_flag = ps_persistence_flag

uo_office_status_1.initialize(group_id)

refresh_tab()


end subroutine

on u_office_status_tab.create
int iCurrent
call super::create
this.uo_office_status_1=create uo_office_status_1
this.uo_office_status_2=create uo_office_status_2
this.ln_1=create ln_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_office_status_1
this.Control[iCurrent+2]=this.uo_office_status_2
this.Control[iCurrent+3]=this.ln_1
end on

on u_office_status_tab.destroy
call super::destroy
destroy(this.uo_office_status_1)
destroy(this.uo_office_status_2)
destroy(this.ln_1)
end on

type uo_office_status_1 from u_office_status within u_office_status_tab
event post_click pbm_custom01
integer width = 1115
integer height = 1728
long my_patient_count = 20840472
end type

event post_click;string ls_room_id

ls_room_id = object.room_id[lastrow]
viewed_room = room_list.find_room(ls_room_id)
f_set_screen()


end event

type uo_office_status_2 from u_office_status within u_office_status_tab
event post_click pbm_custom01
integer x = 1134
integer width = 1115
integer height = 1632
long my_patient_count = 20840472
end type

event post_click;string ls_room_id

ls_room_id = object.room_id[lastrow]
viewed_room = room_list.find_room(ls_room_id)
f_set_screen()


end event

type ln_1 from line within u_office_status_tab
integer linethickness = 8
integer beginx = 1120
integer endx = 1120
integer endy = 1744
end type

