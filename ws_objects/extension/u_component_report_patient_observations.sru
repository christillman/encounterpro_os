HA$PBExportHeader$u_component_report_patient_observations.sru
forward
global type u_component_report_patient_observations from u_component_report
end type
end forward

global type u_component_report_patient_observations from u_component_report
end type
global u_component_report_patient_observations u_component_report_patient_observations

type variables

end variables

forward prototypes
public function integer xx_printreport ()
end prototypes

public function integer xx_printreport ();string ls_dataobject
u_ds_observation_results luo_results
string ls_observation_id
string ls_abnormal_flag
long ll_left
long ll_right

ll_right = 100
ll_left = long(real(rtf.width) * 1.2)
rtf.set_margins(ll_left, ll_right)

ls_observation_id = get_attribute("observation_id")
if isnull(ls_observation_id) then
	mylog.log(this, "xx_printreport()", "no observation_id", 4)
	return -1
end if

ls_abnormal_flag = get_attribute("abnormal_flag")
if isnull(ls_abnormal_flag) then ls_abnormal_flag = "N"

luo_results = CREATE u_ds_observation_results
luo_results.set_dataobject("dw_sp_obstree_patient", cprdb)
luo_results.retrieve(current_patient.cpr_id, ls_observation_id)

luo_results.display_roots("PERFORM", ls_abnormal_flag, rtf)

DESTROY luo_results

return 1


end function

on u_component_report_patient_observations.create
call super::create
end on

on u_component_report_patient_observations.destroy
call super::destroy
end on

event constructor;call super::constructor;report_type = "RTF"

end event

