HA$PBExportHeader$u_component_service_send_report.sru
forward
global type u_component_service_send_report from u_component_service
end type
end forward

global type u_component_service_send_report from u_component_service
end type
global u_component_service_send_report u_component_service_send_report

type variables

end variables

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();
/***************************************************************************************
*
* Description: call the respective report component to send out a report
*
* Returns: -1 - Error
*           2 - Cancelled
*           1 - Success
*
*
* Created By: Sumathi Asokumar											Created:
*
*****************************************************************************************/

integer							li_return
string 							ls_component_id
string							ls_report_id

str_attributes					lstr_attributes
u_component_send_report 	luo_report

ls_report_id = get_attribute("report_id")
if isnull(ls_report_id) then return -1

SELECT component_id
INTO :ls_component_id
FROM c_Report_Definition
WHERE report_id = :ls_report_id
Using Sqlca;

if not tf_check() then return -1

// If any component defined for selected report then
If Isnull(ls_component_id) Then
	mylog.log(this, "xx_do_service()", "Null component_id (" + ls_report_id + ")", 4)
	Return -1
Else
	luo_report = component_manager.get_component(ls_component_id)
	If Isnull(luo_report) Then
		mylog.log(This, "print()", "Error getting report component (" + &
					ls_component_id + ")", 4)
		Return -1
	End If
End If
lstr_attributes = get_attributes()

li_return = luo_report.sendreport(ls_report_id,lstr_attributes)

if li_return < 1 Then Return 2

Return 1
end function

on u_component_service_send_report.create
call super::create
end on

on u_component_service_send_report.destroy
call super::destroy
end on

