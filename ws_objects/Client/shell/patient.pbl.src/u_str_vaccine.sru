$PBExportHeader$u_str_vaccine.sru
forward
global type u_str_vaccine from nonvisualobject
end type
end forward

global type u_str_vaccine from nonvisualobject
end type
global u_str_vaccine u_str_vaccine

type variables
string vaccine_id
string description
string drug_id

end variables
on u_str_vaccine.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_str_vaccine.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

