HA$PBExportHeader$u_oleaut_object.sru
forward
global type u_oleaut_object from oleobject
end type
end forward

global type u_oleaut_object from oleobject
end type
global u_oleaut_object u_oleaut_object

type variables
integer error_code
string error_text


end variables

event externalexception;
oleobject lo_object
error_code = integer(resultcode)
error_text = description
log.log(this, "externalexception", "ERROR (" + string(error_code) + ") - " + error_text, 4)

action = ExceptionSubstituteReturnValue!
returnvalue = -1

end event

on u_oleaut_object.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_oleaut_object.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

