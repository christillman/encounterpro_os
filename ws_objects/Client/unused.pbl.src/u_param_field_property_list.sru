$PBExportHeader$u_param_field_property_list.sru
forward
global type u_param_field_property_list from u_param_config_object_base
end type
end forward

global type u_param_field_property_list from u_param_config_object_base
string config_object_type = "Report"
end type
global u_param_field_property_list u_param_field_property_list

type variables


end variables

on u_param_field_property_list.create
call super::create
end on

on u_param_field_property_list.destroy
call super::destroy
end on

event constructor;call super::constructor;config_object_type = "Datafile"

end event

type cb_clear from u_param_config_object_base`cb_clear within u_param_field_property_list
end type

type st_required from u_param_config_object_base`st_required within u_param_field_property_list
end type

type st_helptext from u_param_config_object_base`st_helptext within u_param_field_property_list
end type

type st_title from u_param_config_object_base`st_title within u_param_field_property_list
end type

type st_popup_values from u_param_config_object_base`st_popup_values within u_param_field_property_list
end type

type cb_configure from u_param_config_object_base`cb_configure within u_param_field_property_list
end type

