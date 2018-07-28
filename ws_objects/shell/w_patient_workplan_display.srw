HA$PBExportHeader$w_patient_workplan_display.srw
forward
global type w_patient_workplan_display from w_window_base
end type
type tab_workplan from u_tab_workplan_display within w_patient_workplan_display
end type
type tab_workplan from u_tab_workplan_display within w_patient_workplan_display
end type
type cb_finished from commandbutton within w_patient_workplan_display
end type
end forward

global type w_patient_workplan_display from w_window_base
tab_workplan tab_workplan
cb_finished cb_finished
end type
global w_patient_workplan_display w_patient_workplan_display

type variables
boolean my_patient

end variables

on w_patient_workplan_display.create
int iCurrent
call super::create
this.tab_workplan=create tab_workplan
this.cb_finished=create cb_finished
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_workplan
this.Control[iCurrent+2]=this.cb_finished
end on

on w_patient_workplan_display.destroy
call super::destroy
destroy(this.tab_workplan)
destroy(this.cb_finished)
end on

event open;call super::open;str_context lstr_context
long ll_patient_workplan_id
str_p_patient_wp lstr_patient_workplan


if lower(message.powerobjectparm.classname( )) = "str_context" then
	lstr_context = message.powerobjectparm
	tab_workplan.initialize(lstr_context)
elseif lower(message.powerobjectparm.classname( )) = "str_p_patient_wp" then
	lstr_patient_workplan = message.powerobjectparm
	tab_workplan.initialize(lstr_patient_workplan.patient_workplan_id)
else
	close(this)
end if

tab_workplan.refresh()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_patient_workplan_display
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_patient_workplan_display
end type

type tab_workplan from u_tab_workplan_display within w_patient_workplan_display
integer width = 2894
integer height = 1516
integer taborder = 20
boolean bringtotop = true
boolean createondemand = false
end type

type cb_finished from commandbutton within w_patient_workplan_display
integer x = 2423
integer y = 1572
integer width = 402
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;close(parent)

end event

