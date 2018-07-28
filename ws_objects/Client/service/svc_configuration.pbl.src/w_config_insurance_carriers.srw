$PBExportHeader$w_config_insurance_carriers.srw
forward
global type w_config_insurance_carriers from w_window_base
end type
type uo_insurance_carriers from u_insurance_edit within w_config_insurance_carriers
end type
type pb_ok from u_picture_button within w_config_insurance_carriers
end type
end forward

global type w_config_insurance_carriers from w_window_base
string title = "Insurance Carriers"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
uo_insurance_carriers uo_insurance_carriers
pb_ok pb_ok
end type
global w_config_insurance_carriers w_config_insurance_carriers

event open;call super::open;uo_insurance_carriers.initialize("EDIT")
end event

on w_config_insurance_carriers.create
int iCurrent
call super::create
this.uo_insurance_carriers=create uo_insurance_carriers
this.pb_ok=create pb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_insurance_carriers
this.Control[iCurrent+2]=this.pb_ok
end on

on w_config_insurance_carriers.destroy
call super::destroy
destroy(this.uo_insurance_carriers)
destroy(this.pb_ok)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_config_insurance_carriers
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_config_insurance_carriers
end type

type uo_insurance_carriers from u_insurance_edit within w_config_insurance_carriers
integer x = 37
integer y = 32
integer taborder = 30
boolean bringtotop = true
end type

on uo_insurance_carriers.destroy
call u_insurance_edit::destroy
end on

type pb_ok from u_picture_button within w_config_insurance_carriers
integer x = 2606
integer y = 1492
integer taborder = 11
boolean bringtotop = true
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;close(parent)
end event

