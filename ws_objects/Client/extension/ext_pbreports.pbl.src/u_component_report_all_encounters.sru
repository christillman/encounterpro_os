$PBExportHeader$u_component_report_all_encounters.sru
forward
global type u_component_report_all_encounters from u_component_report
end type
end forward

global type u_component_report_all_encounters from u_component_report
end type
global u_component_report_all_encounters u_component_report_all_encounters

type variables
boolean user_cancelled = false

end variables

forward prototypes
public function boolean xx_displayable ()
public function integer xx_printreport ()
end prototypes

public function boolean xx_displayable ();return false

end function

public function integer xx_printreport ();///////////////////////////////////////////////////////////////////////////////////////////
//
//	Return: Integer [ -1 - Failure , 1 - success ]
//
//	Description:Add the required attribute and values and call runreport() of report
// component to add more runtime/other attributes.
//
// Created By:Sumathi Chinnasamy										Creation dt: 10/21/99
//
// Modified By:															Modified On:
////////////////////////////////////////////////////////////////////////////////////////////
Integer						li_return,i
Long 							ll_count
Long 							lla_encounter_id[]
String						ls_report_id,ls_temp,lsa_temp[],ls_find
String						ls_service,ls_destination
Integer 						li_attribute_count
string ls_report_printer
long ll_display_script_id

u_component_report		luo_report
str_attributes				lstra_attributes

// Check for valid patient & enocunter
If isnull(current_patient) Or not isvalid(current_patient) Then
	mylog.log(this, "u_component_report_all_encounters.xx_printreport.0026", "No patient context ", 4)
	Return -1
End If 
Setnull(ls_report_id)
ls_report_id = get_attribute("encounter_report_id")
If isnull(ls_report_id) then
	mylog.log(this, "u_component_report_all_encounters.xx_printreport.0026", "No report id ", 4)
	Return -1
End If
ls_service = get_attribute("report_service")
If isnull(ls_service) then ls_service = "REPORT"
ls_destination = get_attribute("destination")
If isnull(ls_destination) then ls_destination = "PRINTER"

// Get the printer designation for this report and pass it into the
// called report
ls_report_printer = get_attribute("printer")

get_attribute("display_script_id", ll_display_script_id)

f_attribute_add_attribute(lstra_attributes, "report_id", ls_report_id)
f_attribute_add_attribute(lstra_attributes, "cpr_id", current_patient.cpr_id)
f_attribute_add_attribute(lstra_attributes, "destination", ls_destination)
f_attribute_add_attribute(lstra_attributes, "printer", ls_report_printer)
f_attribute_add_attribute(lstra_attributes, "display_script_id", string(ll_display_script_id))

// Construct filter
ls_find = "cpr_id='" + current_patient.cpr_id + "'"

ls_temp = get_attribute("begin_date")
if isdate(ls_temp) then
	ls_find += " and date(encounter_date)>=date('" + ls_temp + "')"
end if

ls_temp = get_attribute("end_date")
if isdate(ls_temp) then
	ls_find += " and date(encounter_date)<=date('" + ls_temp + "')"
end if

ls_temp = get_attribute("encounter_type")
if not isnull(ls_temp) and trim(ls_temp) <> "" then
	ll_count = f_parse_string(ls_temp, ";", lsa_temp)
	if ll_count > 0 then
		ls_temp = "'" + lsa_temp[1] + "'"
		for i = 2 to ll_count
			ls_temp += ", '" + lsa_temp[i] + "'"
		next
		ls_find += " and encounter_type IN (" + ls_temp + ")"
	end if
end if

// get list of encounter_ids
ll_count = current_patient.encounters.encounter_list(ls_find, lla_encounter_id)
if ll_count <= 0 then return 0

// Initialize progress meter
if isvalid(w_pop_please_wait) then w_pop_please_wait.initialize(0, ll_count, this)
for i = 1 to ll_count
	// Get the next encounter_id
	f_attribute_add_attribute(lstra_attributes, "encounter_id", String(lla_encounter_id[i]))
	
	service_list.do_service(ls_service,lstra_attributes)
	// See if user cancelled
	yield()
	if user_cancelled then exit

	// increment the progress counter
	if isvalid(w_pop_please_wait) then w_pop_please_wait.set_progress(i)
next

Return 1
end function

on u_component_report_all_encounters.create
call super::create
end on

on u_component_report_all_encounters.destroy
call super::destroy
end on

