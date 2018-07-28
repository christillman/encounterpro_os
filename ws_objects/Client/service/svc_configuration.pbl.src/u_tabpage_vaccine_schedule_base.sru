$PBExportHeader$u_tabpage_vaccine_schedule_base.sru
forward
global type u_tabpage_vaccine_schedule_base from u_tabpage
end type
end forward

global type u_tabpage_vaccine_schedule_base from u_tabpage
end type
global u_tabpage_vaccine_schedule_base u_tabpage_vaccine_schedule_base

type variables
str_config_object_info config_object_info

u_tab_vaccine_schedule_config my_parent_tab

end variables

forward prototypes
public function integer save_changes ()
end prototypes

public function integer save_changes ();return 1

end function

on u_tabpage_vaccine_schedule_base.create
call super::create
end on

on u_tabpage_vaccine_schedule_base.destroy
call super::destroy
end on

