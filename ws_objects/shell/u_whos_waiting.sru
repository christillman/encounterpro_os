HA$PBExportHeader$u_whos_waiting.sru
forward
global type u_whos_waiting from datawindow
end type
end forward

global type u_whos_waiting from datawindow
int Width=1623
int Height=1476
int TabOrder=1
string DataObject="dw_whos_waiting"
boolean Border=false
boolean LiveScroll=true
event post_click pbm_custom01
end type
global u_whos_waiting u_whos_waiting

type variables

end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();integer i, li_status, li_sts, li_move_row, li_rowcount
string ls_first_name, ls_middle_name, ls_last_name
string ls_name_prefix, ls_name_suffix, ls_degree
string ls_service, ls_temp, ls_room_id
long ll_patient_color, ll_service_color
integer li_room_index, li_row, li_added_row
date ld_date_of_birth
string ls_ordered_for
u_user luo_ordered_for
u_user luo_user
string ls_sex

setnull(luo_user)

setredraw(false)

settransobject(sqlca)
li_sts = retrieve(office_id)
if li_sts < 0 then return li_sts

li_room_index = 0
li_rowcount = rowcount()

for i = 1 to li_rowcount
	if not isnull(luo_user) then setitem(i, "user_short_name", luo_user.user_short_name)

	ls_room_id = object.room_id[i]
	ls_first_name = object.first_name[i]
	ls_last_name = object.last_name[i]
	ls_middle_name = object.middle_name[i]
	setnull(ls_name_prefix)
	ls_name_suffix = object.name_suffix[i]
	ls_degree = object.degree[i]
	ls_service = object.service[i]
	ll_patient_color = object.patient_color[i]
	ld_date_of_birth = date(object.date_of_birth[i])
	ls_ordered_for = object.ordered_for[i]
	ls_sex = object.sex[i]

	ls_temp = f_pretty_name_fml(ls_last_name, ls_first_name, ls_middle_name, ls_name_suffix, ls_name_prefix, ls_degree)
	if not isnull(ls_sex) then ls_temp += ", " + ls_sex
	if not isnull(ld_date_of_birth) then ls_temp += ", " + f_pretty_age(ld_date_of_birth, today())
	setitem(i, "pretty_name", ls_temp)

	ls_temp = object.description[i]
	ls_temp += "  (" + string(object.minutes[i]) + ")"
	setitem(i, "description", ls_temp)

	if ll_patient_color = 0 then
		setitem(i, "patient_color", color_light_grey)
		ll_patient_color = color_light_grey
	end if

	luo_ordered_for = user_list.find_user(ls_ordered_for)
	if isnull(luo_ordered_for) then
		CHOOSE CASE ls_service
			CASE "EXAM"
				ll_service_color = ll_patient_color
			CASE "CHECKIN"
				ll_service_color = color_light_grey
			CASE "CHECKOUT"
				ll_service_color = color_light_grey
			CASE "EDIT_VITALS"
				ll_service_color = color_service_ordered
			CASE "EXIT"
				ll_service_color = color_light_grey
			CASE "GET_PATIENT"
				ll_service_color = color_service_ordered
			CASE "MEDICATION"
				ll_service_color = color_service_ordered
			CASE "PROCEDURE"
				ll_service_color = color_service_ordered
			CASE "IMMUNIZATION"
				ll_service_color = color_service_ordered
			CASE "RECHECK"
				ll_service_color = ll_patient_color
			CASE "TAKE_VITALS"
				ll_service_color = color_service_ordered
			CASE "TEST"
				ll_service_color = color_service_ordered
			CASE "PHONE"
				ll_service_color = ll_patient_color
			CASE ELSE
				ll_service_color = color_light_grey
		END CHOOSE
	else
		ll_service_color = luo_ordered_for.color
	end if

	setitem(i, "service_color", ll_service_color)
next

sort()
groupcalc()
setredraw(true)

return 1
end function

