HA$PBExportHeader$w_config_specialties_consultants.srw
forward
global type w_config_specialties_consultants from w_window_base
end type
end forward

global type w_config_specialties_consultants from w_window_base
boolean visible = false
string title = "Users Configuration"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
end type
global w_config_specialties_consultants w_config_specialties_consultants

type variables
u_component_service service

end variables

event open;call super::open;
service = message.powerobjectparm

postevent("post_open")

end event

on w_config_specialties_consultants.create
call super::create
end on

on w_config_specialties_consultants.destroy
call super::destroy
end on

event post_open;call super::post_open;u_user luo_user
str_pick_users lstr_pick_users
integer li_sts
str_popup popup
str_popup_return popup_return


lstr_pick_users.actor_class = service.get_attribute("actor_class")
if lower(lstr_pick_users.actor_class) = "user" then
	// If we're editing users then allow roles too
	lstr_pick_users.allow_roles = true
	lstr_pick_users.hide_users = false
else
	lstr_pick_users.allow_roles = false
	lstr_pick_users.hide_users = true
end if

lstr_pick_users.allow_system_users = false
lstr_pick_users.allow_special_users = false
lstr_pick_users.allow_multiple = false
lstr_pick_users.pick_screen_title = "Select User to Edit"
lstr_pick_users.allow_editing = true

li_sts = user_list.pick_users(lstr_pick_users)

close(this)
return
	

end event

type pb_epro_help from w_window_base`pb_epro_help within w_config_specialties_consultants
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_config_specialties_consultants
end type

