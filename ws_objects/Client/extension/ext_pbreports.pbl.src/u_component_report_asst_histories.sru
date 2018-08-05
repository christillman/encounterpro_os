$PBExportHeader$u_component_report_asst_histories.sru
forward
global type u_component_report_asst_histories from u_component_report
end type
end forward

global type u_component_report_asst_histories from u_component_report
end type
global u_component_report_asst_histories u_component_report_asst_histories

type variables
u_ds_data           temp_ds
end variables

forward prototypes
public function integer xx_printreport ()
public subroutine load_plan ()
end prototypes

public function integer xx_printreport ();/////////////////////////////////////////////////////////////////////////////////////////////////////
//	Return: Integer
//
// Created By:Sumathi Chinnasamy									Modified On:07/25/01
//
// Description:
// Prints the assessment history of selected assessment. it supports to print only one assessment.
//
////////////////////////////////////////////////////////////////////////////////////////////////////

String 	ls_provider, ls_description
String   ls_dataobject, ls_icd10_code
String	ls_left,ls_right
String	ls_assessment_id
Integer	li_length

ls_dataobject = get_attribute("dataobject")
If Isnull(ls_dataobject) Then ls_dataobject = "assessment"
report_datastore.dataobject = ls_dataobject

If Isnull(current_patient) Or Not Isvalid(current_patient) Then
	mylog.log(this, "u_component_report_asst_histories.xx_printreport:0022", "No cpr_id", 4)
	return -1
End if

temp_ds = Create u_ds_data
ls_assessment_id = get_attribute("assessment_id")

	
SELECT icd10_code,
		 description
INTO :ls_icd10_code,
		:ls_description
FROM c_Assessment_Definition (NOLOCK)
WHERE assessment_id = :ls_assessment_id
and status = 'OK';
If Not tf_check() Then Return -1

If Not isnull(ls_icd10_code) then
	f_split_string(ls_icd10_code, ".", ls_left, ls_right)
	ls_icd10_code = ls_left
End If
temp_ds.reset()
If isnull(ls_icd10_code) Then
	temp_ds.set_dataobject("dw_assessments_assessment_id")
	temp_ds.Retrieve(current_patient.cpr_id, ls_assessment_id)
Else
	temp_ds.set_dataobject("dw_assessments_icd10")
	temp_ds.Retrieve(current_patient.cpr_id, ls_icd10_code + "%")
End If
	
report_datastore.Modify("history_title.text='" + ls_description+" History" + "'")
report_datastore.Modify("report_dt.Text='" + String(Today(), "m/d/yy hh:mm") + "'")
report_datastore.Modify("patient_id.Text='Patient: " + current_patient.id_line1() + "'")
report_datastore.Modify("icd10_code.Text='icd10_code: " + ls_icd10_code+".xx" + "'")

If temp_ds.rowcount() > 0 Then
	load_plan()
	print_datastore()
Else
	Openwithparm(w_pop_message,"No histories for "+ls_description)
End If
Destroy temp_ds

Return 1

end function

public subroutine load_plan ();Integer 							i, j, li_treatment_count, li_sts
Long 								ll_row,ll_count,ll_problem_id
Integer 							li_diagnosis_sequence
Long 								ll_null,ll_treatment_ids[]
String 							ls_treatment,ls_find
String							ls_description
string ls_assessment_description

datawindowchild				temp_history
str_assessment_description		lstr_assessment
u_component_treatment		luo_treatment

Setnull(ll_null)
li_sts = report_datastore.Getchild("history",temp_history)

ll_count = temp_ds.Rowcount()

temp_history.Reset()
ll_problem_id = 0
For i = 1 To ll_count
	ll_problem_id = Long(temp_ds.object.problem_id[i])
	li_diagnosis_sequence = Long(temp_ds.object.diagnosis_sequence[i])

	li_sts = current_patient.assessments.assessment(lstr_assessment, ll_problem_id, li_diagnosis_sequence)
	If li_sts <= 0 Then Continue
	
	ls_assessment_description = f_assessment_description(lstr_assessment)

	li_treatment_count = current_patient.treatments.get_assessment_treatments(ll_problem_id, ll_treatment_ids)
	For j = 1 To li_treatment_count
		li_sts = current_patient.treatments.treatment(luo_treatment, ll_treatment_ids[j])
		If li_sts <= 0 Then Continue
		If Not Isnull(luo_treatment.begin_date) Then
			ls_description = "( "+String(luo_treatment.begin_date,"m/d/yy")
			If not isnull(luo_treatment.end_date) Then
				ls_description += " - "+String(luo_treatment.end_date,"m/d/yy")+" ) "
			Else
				ls_description += " ) "
			End If
		End If
		ls_description += luo_treatment.description()
		ll_row = temp_history.Insertrow(0)
		temp_history.setitem(ll_row,"problem_id",ll_problem_id)
		temp_history.setitem(ll_row,"assessment",ls_assessment_description)
		temp_history.setitem(ll_row,"treatment",ls_description)
		temp_history.setitem(ll_row,"begin_date",luo_treatment.begin_date)
	Next

	If li_treatment_count = 0 Then
		ll_row = temp_history.Insertrow(0)
		temp_history.setitem(ll_row,"problem_id",ll_problem_id)
		temp_history.setitem(ll_row,"assessment",ls_assessment_description)
		temp_history.setitem(ll_row,"treatment","No Treatments")
	End if
Next

temp_history.Sort()
temp_history.Groupcalc()
end subroutine

on u_component_report_asst_histories.create
call super::create
end on

on u_component_report_asst_histories.destroy
call super::destroy
end on

