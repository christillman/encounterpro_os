HA$PBExportHeader$u_str_schedule.sru
forward
global type u_str_schedule from nonvisualobject
end type
end forward

global type u_str_schedule from nonvisualobject
end type
global u_str_schedule u_str_schedule

type variables
integer schedule_sequence
real age
string age_unit
integer warning_days

u_str_vaccine parent_vaccine
end variables

on u_str_schedule.create
TriggerEvent( this, "constructor" )
end on

on u_str_schedule.destroy
TriggerEvent( this, "destructor" )
end on

