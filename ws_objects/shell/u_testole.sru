HA$PBExportHeader$u_testole.sru
forward
global type u_testole from oleobject
end type
end forward

global type u_testole from oleobject
end type
global u_testole u_testole

on u_testole.create
TriggerEvent( this, "constructor" )
end on

on u_testole.destroy
TriggerEvent( this, "destructor" )
end on

