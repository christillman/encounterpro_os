$PBExportHeader$u_str_location.sru
forward
global type u_str_location from nonvisualobject
end type
end forward

global type u_str_location from nonvisualobject
end type
global u_str_location u_str_location

type variables
integer location_index

string location
string description
integer sort_sequence
string diffuse_flag
string status

u_str_location_domain parent_location_domain
end variables

on u_str_location.create
TriggerEvent( this, "constructor" )
end on

on u_str_location.destroy
TriggerEvent( this, "destructor" )
end on

