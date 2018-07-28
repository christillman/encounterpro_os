HA$PBExportHeader$u_param_config_object.sru
forward
global type u_param_config_object from u_param_config_object_base
end type
end forward

global type u_param_config_object from u_param_config_object_base
end type
global u_param_config_object u_param_config_object

on u_param_config_object.create
call super::create
end on

on u_param_config_object.destroy
call super::destroy
end on

type st_preference from u_param_config_object_base`st_preference within u_param_config_object
end type

type st_preference_title from u_param_config_object_base`st_preference_title within u_param_config_object
end type

type cb_clear from u_param_config_object_base`cb_clear within u_param_config_object
end type

type st_required from u_param_config_object_base`st_required within u_param_config_object
end type

type st_helptext from u_param_config_object_base`st_helptext within u_param_config_object
end type

type st_title from u_param_config_object_base`st_title within u_param_config_object
end type

type st_popup_values from u_param_config_object_base`st_popup_values within u_param_config_object
end type

type cb_configure from u_param_config_object_base`cb_configure within u_param_config_object
end type

