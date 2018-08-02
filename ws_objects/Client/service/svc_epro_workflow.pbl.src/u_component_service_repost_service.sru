$PBExportHeader$u_component_service_repost_service.sru
forward
global type u_component_service_repost_service from u_component_service
end type
end forward

global type u_component_service_repost_service from u_component_service
end type
global u_component_service_repost_service u_component_service_repost_service

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();/**********************************************************************************
*
*  Description: repost the encounter service
*
*  Attributes: posting_service = <name of the service to be reposted>
*              ordered_for     = <service owner>
*
*  Return: -1 - Error
*           1 - Success
*           2 - Cancelled
*
**********************************************************************************/



integer		li_sts
string		ls_posting_service,ls_ordered_for
string		ls_find
long			ll_find

u_ds_data	lds_posting_history

ls_posting_service = get_attribute("posting_service")
If isnull(ls_posting_service) then
	mylog.log(this, "u_component_service_repost_service.xx_do_service.0025", "posting service is null", 4)
	return -1
End If

ls_ordered_for = get_attribute("ordered_for")
If isnull(ls_ordered_for) then
	mylog.log(this, "u_component_service_repost_service.xx_do_service.0025", "ordered for is null", 4)
	return -1
End If

lds_posting_history = Create u_ds_data
lds_posting_history.dataobject = "dw_encounter_service_history"
lds_posting_history.settransobject(sqlca)

li_sts = lds_posting_history.retrieve(current_patient.cpr_id, encounter_id, ls_posting_service)
if not tf_check() then return -1

ls_find = "status = 'DISPATCHED' OR status = 'STARTED'"
ll_find = lds_posting_history.find(ls_find, 1,lds_posting_history.rowcount())
if ll_find > 0 Then 
	Openwithparm(w_pop_message,"This request is already queued up")
	return 2
end if

// queue the service
li_sts = service_list.order_service(current_patient.cpr_id,encounter_id,ls_posting_service,ls_ordered_for,"Re-Posting Service")
if li_sts <= 0 then return -1

Return 1
end function

on u_component_service_repost_service.create
call super::create
end on

on u_component_service_repost_service.destroy
call super::destroy
end on

