$PBExportHeader$u_adodb_connection.sru
forward
global type u_adodb_connection from oleobject
end type
end forward

global type u_adodb_connection from oleobject
end type
global u_adodb_connection u_adodb_connection

type variables
integer error_code
string error_text

end variables

on u_adodb_connection.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_adodb_connection.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

