$PBExportHeader$w_param_base.srw
forward
global type w_param_base from w_window_base
end type
end forward

global type w_param_base from w_window_base
integer x = 27
integer y = 144
integer width = 2816
integer height = 1492
boolean titlebar = false
string title = ""
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
event ue_required ( boolean pb_enable )
end type
global w_param_base w_param_base

type variables
str_params params
str_attributes attributes

boolean allow_preference = false

end variables

forward prototypes
public subroutine set_buttons ()
end prototypes

public subroutine set_buttons ();


return

end subroutine

on w_param_base.create
call super::create
end on

on w_param_base.destroy
call super::destroy
end on

type pb_epro_help from w_window_base`pb_epro_help within w_param_base
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_param_base
end type

