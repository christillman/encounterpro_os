HA$PBExportHeader$u_component_service_past_encounter.sru
forward
global type u_component_service_past_encounter from u_component_service
end type
end forward

global type u_component_service_past_encounter from u_component_service
end type
global u_component_service_past_encounter u_component_service_past_encounter

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();Datetime				ldt_encounter_date
String				ls_encounter_type,ls_attending_doctor
String				ls_office_id,ls_null
str_popup_return	popup_return
string	ls_service
long ll_encounter_id

ls_service = get_attribute("chart_service")
if isnull(ls_service) then ls_service = "CHART"

Open(service_window, "w_new_past_encounter")
popup_return = Message.Powerobjectparm
If popup_return.item_count = 0 Then Return 2

ls_encounter_type = popup_return.items[1]
ldt_encounter_date = datetime(date(popup_return.items[2]))
ls_attending_doctor = popup_return.items[3]
ls_office_id = popup_return.items[4]

Setnull(ls_null)
// WORKFLOW SYSTEM DIDNT HANDLE PAST ENCOUNTER - 08/07/01
ll_encounter_id = current_patient.new_encounter(office_id, &
																ls_encounter_type, &
																ldt_encounter_date, &
																'N', &
																ls_null, &
																ls_attending_doctor, &
																current_scribe.user_id, &
																false)
if ll_encounter_id <= 0 then
	mylog.log(this, "xx_do_encounter()", "Error creating new encounter", 4)
	return 2
end if

service_list.do_service(current_patient.cpr_id, ll_encounter_id, ls_service)

Return 1


end function

on u_component_service_past_encounter.create
call super::create
end on

on u_component_service_past_encounter.destroy
call super::destroy
end on

