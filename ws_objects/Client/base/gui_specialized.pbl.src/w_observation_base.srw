$PBExportHeader$w_observation_base.srw
forward
global type w_observation_base from w_window_base
end type
end forward

global type w_observation_base from w_window_base
event results_posted ( u_component_observation puo_observation )
event source_connected ( u_component_observation puo_observation )
event source_disconnected ( u_component_observation puo_observation )
event ole_updated ( u_ole_control puo_ole_control )
end type
global w_observation_base w_observation_base

on w_observation_base.create
call super::create
end on

on w_observation_base.destroy
call super::destroy
end on

type pb_epro_help from w_window_base`pb_epro_help within w_observation_base
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_observation_base
end type

