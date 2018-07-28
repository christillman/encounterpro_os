HA$PBExportHeader$u_hl7_ackobject.sru
forward
global type u_hl7_ackobject from oleobject
end type
end forward

global type u_hl7_ackobject from oleobject
end type
global u_hl7_ackobject u_hl7_ackobject

event externalexception;log.log(this,"externalexception",description  + " exceptioncode=" + string(exceptioncode),3)
action = ExceptionIgnore!
end event

on u_hl7_ackobject.create
call oleobject::create
TriggerEvent( this, "constructor" )
end on

on u_hl7_ackobject.destroy
call oleobject::destroy
TriggerEvent( this, "destructor" )
end on

