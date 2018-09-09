$PBExportHeader$w_config_workplans.srw
forward
global type w_config_workplans from w_window_base
end type
type uo_workplan_edit from u_workplan_edit within w_config_workplans
end type
type pb_ok from u_picture_button within w_config_workplans
end type
end forward

global type w_config_workplans from w_window_base
string title = "Workplan Configurations"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
uo_workplan_edit uo_workplan_edit
pb_ok pb_ok
end type
global w_config_workplans w_config_workplans

event open;call super::open;uo_workplan_edit.initialize()
end event

on w_config_workplans.create
int iCurrent
call super::create
this.uo_workplan_edit=create uo_workplan_edit
this.pb_ok=create pb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_workplan_edit
this.Control[iCurrent+2]=this.pb_ok
end on

on w_config_workplans.destroy
call super::destroy
destroy(this.uo_workplan_edit)
destroy(this.pb_ok)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_config_workplans
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_config_workplans
end type

type uo_workplan_edit from u_workplan_edit within w_config_workplans
integer x = 18
integer y = 32
integer taborder = 30
boolean bringtotop = true
end type

on uo_workplan_edit.destroy
call u_workplan_edit::destroy
end on

type pb_ok from u_picture_button within w_config_workplans
integer x = 2578
integer y = 1428
integer taborder = 11
boolean bringtotop = true
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;Close(Parent)
end event

