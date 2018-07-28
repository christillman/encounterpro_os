HA$PBExportHeader$u_dw_patient_info.sru
forward
global type u_dw_patient_info from datawindow
end type
end forward

global type u_dw_patient_info from datawindow
integer width = 1248
integer height = 600
string title = "none"
string dataobject = "dw_patient_info"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type
global u_dw_patient_info u_dw_patient_info

forward prototypes
public subroutine display_patient (str_patient pstr_patient)
public subroutine display_patient (u_patient puo_patient)
end prototypes

public subroutine display_patient (str_patient pstr_patient);
reset()

insertrow(0)

object.full_name[1] = f_pretty_name( pstr_patient.last_name, &
													pstr_patient.first_name, &
													pstr_patient.middle_name, &
													pstr_patient.name_suffix, &
													pstr_patient.name_prefix, &
													pstr_patient.degree)
													

object.date_of_birth[1] = datetime(pstr_patient.date_of_birth, time(""))
object.sex[1] = pstr_patient.sex
object.ssn[1] = pstr_patient.ssn
object.phone_number[1] = pstr_patient.phone_number
object.race[1] = pstr_patient.race
object.billing_id[1] = pstr_patient.billing_id

end subroutine

public subroutine display_patient (u_patient puo_patient);
reset()

insertrow(0)

object.full_name[1] = f_pretty_name( puo_patient.last_name, &
													puo_patient.first_name, &
													puo_patient.middle_name, &
													puo_patient.name_suffix, &
													puo_patient.name_prefix, &
													puo_patient.degree)
													

object.date_of_birth[1] = datetime(puo_patient.date_of_birth, time(""))
object.sex[1] = puo_patient.sex
object.ssn[1] = puo_patient.ssn
object.phone_number[1] = puo_patient.phone_number
object.race[1] = puo_patient.race
object.billing_id[1] = puo_patient.billing_id

end subroutine

on u_dw_patient_info.create
end on

on u_dw_patient_info.destroy
end on

