$PBExportHeader$u_ds_report.sru
forward
global type u_ds_report from datastore
end type
end forward

global type u_ds_report from datastore
end type
global u_ds_report u_ds_report

type variables
u_event_log mylog

end variables

on u_ds_report.create
call datastore::create
TriggerEvent( this, "constructor" )
end on

on u_ds_report.destroy
call datastore::destroy
TriggerEvent( this, "destructor" )
end on

event error;string ls_temp

ls_temp = "Error (" + string(errornumber) + "): " + errortext

mylog.log(this, "error", ls_temp, 4)


end event

