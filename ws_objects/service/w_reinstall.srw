HA$PBExportHeader$w_reinstall.srw
forward
global type w_reinstall from w_window_base
end type
end forward

global type w_reinstall from w_window_base
boolean visible = false
string title = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
end type
global w_reinstall w_reinstall

event post_open;call super::post_open;String		ls_setup
str_popup_return popup_return

openwithparm(w_pop_yes_no, "Are you sure you want to reinstall the EncounterPRO Client on this computer?")
popup_return = message.powerobjectparm
If popup_return.item = "YES" then
	ls_Setup = f_default_attachment_path() + "\Install\EncounterPRO\SETUP.EXE"
	run(ls_setup,Normal!)
	yield()
	halt close
End if

close(this)


end event

event open;call super::open;postevent("post_open")
end event

on w_reinstall.create
call super::create
end on

on w_reinstall.destroy
call super::destroy
end on

type pb_epro_help from w_window_base`pb_epro_help within w_reinstall
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_reinstall
end type

