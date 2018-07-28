$PBExportHeader$w_config_reports_old.srw
forward
global type w_config_reports_old from w_window_base
end type
type cb_1 from commandbutton within w_config_reports_old
end type
type tab_reports from u_tab_report_config within w_config_reports_old
end type
type tab_reports from u_tab_report_config within w_config_reports_old
end type
type st_1 from statictext within w_config_reports_old
end type
end forward

global type w_config_reports_old from w_window_base
string title = "Report Configuration"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_1 cb_1
tab_reports tab_reports
st_1 st_1
end type
global w_config_reports_old w_config_reports_old

on w_config_reports_old.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.tab_reports=create tab_reports
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.tab_reports
this.Control[iCurrent+3]=this.st_1
end on

on w_config_reports_old.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.tab_reports)
destroy(this.st_1)
end on

event open;call super::open;

tab_reports.initialize()

tab_reports.selecttab(1)

end event

type pb_epro_help from w_window_base`pb_epro_help within w_config_reports_old
boolean visible = true
integer x = 2094
integer y = 1604
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_config_reports_old
end type

type cb_1 from commandbutton within w_config_reports_old
integer x = 2414
integer y = 1600
integer width = 443
integer height = 108
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type tab_reports from u_tab_report_config within w_config_reports_old
integer x = 18
integer y = 148
integer width = 2853
integer height = 1424
integer taborder = 20
end type

type st_1 from statictext within w_config_reports_old
integer width = 2917
integer height = 108
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Report Configuration"
alignment alignment = center!
boolean focusrectangle = false
end type

