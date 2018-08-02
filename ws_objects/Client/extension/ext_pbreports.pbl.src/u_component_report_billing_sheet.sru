$PBExportHeader$u_component_report_billing_sheet.sru
forward
global type u_component_report_billing_sheet from u_component_report
end type
end forward

global type u_component_report_billing_sheet from u_component_report
end type
global u_component_report_billing_sheet u_component_report_billing_sheet

forward prototypes
public function integer xx_printreport ()
end prototypes

public function integer xx_printreport ();u_user							luo_user
datawindowchild				header, objective, treatment, footer
str_encounter_assessment	lstr_assessments[]
u_str_encounter				luo_encounter
string ls_cpt_code

Integer							li_sts, i, j
String							ls_provider, ls_description, ls_encounter_title, ls_null
Long								ll_row, ll_encounter_charge_id
String							ls_courtesy, ls_cpr_id, ls_dataobject
Long								ll_billing_code, ll_encounter_id
Integer							li_assessment_count, li_count
Integer							li_sort_sequence
Decimal							ld_null
string ls_office_id

Setnull(ld_null)

ll_encounter_id	= long(get_attribute("ENCOUNTER_ID"))
ls_dataobject		= get_attribute("dataobject")
If Not Isnull(ls_dataobject) Then
	report_datastore.dataobject = ls_dataobject
Else
	report_datastore.dataobject = "dw_billing_sheet"
End If

// Check for valid patient & enocunter
If isnull(current_patient) Then
	mylog.log(this, "u_component_report_billing_sheet.xx_printreport.0029", "No patient context ", 4)
	Return -1
Elseif isnull(current_patient.open_encounter) Then
	mylog.log(this, "u_component_report_billing_sheet.xx_printreport.0029", "No encounter context ", 4)
	Return -1
End If 

luo_encounter = current_patient.open_encounter

luo_user = user_list.find_user(luo_encounter.attending_doctor)
If isnull(luo_user) Then
	ls_provider = ""
Else
	ls_provider = luo_user.user_full_name
End If

li_sts = tf_get_domain_item("COURTESY_CODE", luo_encounter.courtesy_code, ls_courtesy)
If li_sts <= 0 Then
	report_datastore.Modify("billing_courtesy.Text=''")
	report_datastore.Modify("courtesy_title.Text=''")
Else
	report_datastore.Modify("billing_courtesy.Text='" + ls_courtesy + "'")
End If

If isnull(luo_encounter.billing_note) or luo_encounter.billing_note = "" Then
	report_datastore.Modify("billing_note.Text=''")
	report_datastore.Modify("notes_title.Text=''")
Else
	report_datastore.Modify("billing_note.Text='" + luo_encounter.billing_note + "'")
End If

ls_office_id = get_attribute("office_id")
if isnull(ls_office_id) then ls_office_id = office_id

report_datastore.Modify("t_office_name.Text='" + datalist.office_description(ls_office_id) + "'")
report_datastore.Modify("t_office_address.Text='" + datalist.office_address(ls_office_id) + "'")
report_datastore.Modify("encounter_date.Text='" + string(luo_encounter.encounter_date, date_format_string) + "'")
report_datastore.Modify("cpr_id.Text='" + current_patient.cpr_id + "," + string(luo_encounter.encounter_id) + "'")
report_datastore.Modify("patient_id.Text='Patient: " + current_patient.id_line1() + "'")
report_datastore.Modify("provider.Text='Provider: " + ls_provider + "'")

luo_encounter.get_billing(lstr_assessments, li_assessment_count)

If li_assessment_count = 0 Then
	ll_row = report_datastore.insertrow(0)
	report_datastore.setitem(ll_row, "assessment_description", "No Billed Diagnoses")
Else
	For i = 1 To li_assessment_count
		If lstr_assessments[i].bill_flag = "N" Then Continue
		If lstr_assessments[i].charge_count = 0 Then
			ll_row = report_datastore.insertrow(0)
			report_datastore.setitem(ll_row, "assessment_description", lstr_assessments[i].description)
			report_datastore.setitem(ll_row, "icd10_code", lstr_assessments[i].icd10_code)
			report_datastore.setitem(ll_row, "description", "No Billed Items")
			report_datastore.setitem(ll_row, "problem_id", lstr_assessments[i].problem_id)
		Else
			For j = 1 To lstr_assessments[i].charge_count
				// If the charge is not billed, then don't show it.
				If lstr_assessments[i].charge[j].assessment_charge_bill_flag = "N" Then Continue
				If lstr_assessments[i].charge[j].charge_bill_flag = "N" Then Continue
				
				ls_cpt_code = lstr_assessments[i].charge[j].cpt_code
				// Add the modifier
				if not isnull(lstr_assessments[i].charge[j].modifier) &
					and trim(lstr_assessments[i].charge[j].modifier) <> "" then
					ls_cpt_code += "-" + lstr_assessments[i].charge[j].modifier
					// Add any other modifiers
					if not isnull(lstr_assessments[i].charge[j].other_modifiers) &
						and trim(lstr_assessments[i].charge[j].other_modifiers) <> "" then
						ls_cpt_code += "," + lstr_assessments[i].charge[j].other_modifiers
					end if
				end if
				
				ll_row = report_datastore.insertrow(0)
				report_datastore.setitem(ll_row, "assessment_description", lstr_assessments[i].description)
				report_datastore.setitem(ll_row, "icd10_code", lstr_assessments[i].icd10_code)
				report_datastore.setitem(ll_row, "description", lstr_assessments[i].charge[j].description)
				report_datastore.setitem(ll_row, "cpt_code", ls_cpt_code)
				report_datastore.setitem(ll_row, "charge", lstr_assessments[i].charge[j].charge)
				report_datastore.setitem(ll_row, "encounter_charge_id", &
															lstr_assessments[i].charge[j].encounter_charge_id)
				report_datastore.setitem(ll_row, "problem_id", lstr_assessments[i].problem_id)
				li_sort_sequence = lstr_assessments[i].charge[j].treatment_id
				If lstr_assessments[i].charge[j].procedure_type = "PRIMARY" Then
					li_sort_sequence -= 1000
				End If
				report_datastore.setitem(ll_row, "sort_sequence", li_sort_sequence)
	//			li_sts = tf_get_billing_code(lstr_assessments[i].charge[j].procedure_id, ll_billing_code)
				If li_sts > 0 Then
					report_datastore.setitem(ll_row, "billing_code", ll_billing_code)
				End If
				// By Sumathi Chinnasamy On 11/29/99
				// Check whether the encounter is already billed for procedure
				li_count = 1
				Do While li_count < ll_row
					ll_encounter_charge_id = report_datastore.getitemnumber(li_count,"encounter_charge_id")
					If ll_encounter_charge_id = &
							lstr_assessments[i].charge[j].encounter_charge_id Then
						report_datastore.setitem(ll_row, "charge", ld_null)
						Exit
					End If
					li_count++
				Loop
			Next
		End if
	Next
End if


report_datastore.sort()
report_datastore.groupcalc()

print_datastore()

return 1



end function

on u_component_report_billing_sheet.create
call super::create
end on

on u_component_report_billing_sheet.destroy
call super::destroy
end on

