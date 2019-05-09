$PBExportHeader$u_param_report.sru
forward
global type u_param_report from u_param_config_object_base
end type
end forward

global type u_param_report from u_param_config_object_base
string config_object_type = "Report"
end type
global u_param_report u_param_report

type variables

end variables

on u_param_report.create
call super::create
end on

on u_param_report.destroy
call super::destroy
end on

event constructor;call super::constructor;config_object_type = "Report"

end event

type cb_clear from u_param_config_object_base`cb_clear within u_param_report
end type

type st_required from u_param_config_object_base`st_required within u_param_report
end type

type st_helptext from u_param_config_object_base`st_helptext within u_param_report
end type

type st_title from u_param_config_object_base`st_title within u_param_report
end type

type st_popup_values from u_param_config_object_base`st_popup_values within u_param_report
end type

type cb_configure from u_param_config_object_base`cb_configure within u_param_report
end type

