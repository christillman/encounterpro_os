HA$PBExportHeader$w_server_main.srw
forward
global type w_server_main from w_window_base
end type
end forward

global type w_server_main from w_window_base
boolean visible = false
boolean show_more_buttons = false
boolean auto_resize_window = false
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
end type
global w_server_main w_server_main

on w_server_main.create
call super::create
end on

on w_server_main.destroy
call super::destroy
end on

type pb_epro_help from w_window_base`pb_epro_help within w_server_main
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_server_main
end type

