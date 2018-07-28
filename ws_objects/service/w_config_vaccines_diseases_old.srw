HA$PBExportHeader$w_config_vaccines_diseases_old.srw
forward
global type w_config_vaccines_diseases_old from w_window_base
end type
type tab_1 from u_tab_vaccine_diseases within w_config_vaccines_diseases_old
end type
type tab_1 from u_tab_vaccine_diseases within w_config_vaccines_diseases_old
end type
type pb_ok from u_picture_button within w_config_vaccines_diseases_old
end type
end forward

global type w_config_vaccines_diseases_old from w_window_base
string title = "Vaccines & Diseases"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
tab_1 tab_1
pb_ok pb_ok
end type
global w_config_vaccines_diseases_old w_config_vaccines_diseases_old

on w_config_vaccines_diseases_old.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.pb_ok=create pb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.pb_ok
end on

on w_config_vaccines_diseases_old.destroy
call super::destroy
destroy(this.tab_1)
destroy(this.pb_ok)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_config_vaccines_diseases_old
boolean visible = true
integer width = 247
integer height = 120
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_config_vaccines_diseases_old
end type

type tab_1 from u_tab_vaccine_diseases within w_config_vaccines_diseases_old
integer x = 23
integer y = 32
integer width = 2501
integer taborder = 11
boolean bringtotop = true
end type

type pb_ok from u_picture_button within w_config_vaccines_diseases_old
integer x = 2601
integer y = 1456
integer taborder = 11
boolean bringtotop = true
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;Close(Parent)
end event

