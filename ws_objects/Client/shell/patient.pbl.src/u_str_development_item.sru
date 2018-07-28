$PBExportHeader$u_str_development_item.sru
forward
global type u_str_development_item from nonvisualobject
end type
end forward

global type u_str_development_item from nonvisualobject
end type
global u_str_development_item u_str_development_item

type variables
string item_type
integer item_sequence
string description

u_str_development_stage parent_stage

end variables

on u_str_development_item.create
TriggerEvent( this, "constructor" )
end on

on u_str_development_item.destroy
TriggerEvent( this, "destructor" )
end on

