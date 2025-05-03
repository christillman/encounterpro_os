$PBExportHeader$w_encounterpro_report.srw
forward
global type w_encounterpro_report from w_window_base
end type
type pb_done from u_picture_button within w_encounterpro_report
end type
type pb_cancel from u_picture_button within w_encounterpro_report
end type
type cb_print from commandbutton within w_encounterpro_report
end type
type cb_printsetup from commandbutton within w_encounterpro_report
end type
type dw_report from u_dw_report within w_encounterpro_report
end type
end forward

global type w_encounterpro_report from w_window_base
string title = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
windowstate windowstate = maximized!
pb_done pb_done
pb_cancel pb_cancel
cb_print cb_print
cb_printsetup cb_printsetup
dw_report dw_report
end type
global w_encounterpro_report w_encounterpro_report

type variables



end variables

forward prototypes
public subroutine display_report (u_component_report puo_report_component)
end prototypes

public subroutine display_report (u_component_report puo_report_component);integer li_sts
blob lbl_report

dw_report.setredraw(false)

pb_done.x = width - pb_done.width - 100
cb_print.x = width - cb_print.width - 100
cb_printsetup.x = width - cb_printsetup.width - 100

pb_done.y = height - pb_done.height - 200

dw_report.height = height - 250
dw_report.width = cb_print.x - 100


li_sts = puo_report_component.report_datastore.getfullstate(lbl_report)
if li_sts < 0 then
	puo_report_component.mylog.log(this, "w_encounterpro_report.display_report:0018", "Error getting report state", 4)
	close(this)
	return
end if

dw_report.setfullstate(lbl_report)
dw_report.setredraw(true)

end subroutine

on w_encounterpro_report.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.cb_print=create cb_print
this.cb_printsetup=create cb_printsetup
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.cb_print
this.Control[iCurrent+4]=this.cb_printsetup
this.Control[iCurrent+5]=this.dw_report
end on

on w_encounterpro_report.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.cb_print)
destroy(this.cb_printsetup)
destroy(this.dw_report)
end on

event open;call super::open;str_popup popup
string ls_temp
integer li_sts
blob lbl_report
u_component_report luo_report

luo_report = message.powerobjectparm

if isnull(luo_report) or not isvalid(luo_report) then
	luo_report.mylog.log(this, "w_encounterpro_report:open", "Invalid report object", 4)
	close(this)
	return
end if

SELECT description
INTO :title
FROM c_Report_Definition
WHERE report_id = :luo_report.report_id
USING luo_report.cprdb;
if not luo_report.cprdb.check() then
	luo_report.mylog.log(this, "w_encounterpro_report:open", "Error getting report description", 4)
	close(this)
	return
end if

this.function POST display_report(luo_report)


end event

type pb_epro_help from w_window_base`pb_epro_help within w_encounterpro_report
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_encounterpro_report
end type

type pb_done from u_picture_button within w_encounterpro_report
integer x = 2409
integer y = 1484
integer width = 256
integer height = 224
integer taborder = 10
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;close(parent)

end event

type pb_cancel from u_picture_button within w_encounterpro_report
boolean visible = false
integer x = 128
integer y = 1556
integer width = 256
integer height = 224
integer taborder = 40
boolean bringtotop = true
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

type cb_print from commandbutton within w_encounterpro_report
integer x = 2405
integer y = 364
integer width = 247
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print"
end type

event clicked;dw_report.print()

end event

type cb_printsetup from commandbutton within w_encounterpro_report
integer x = 2405
integer y = 84
integer width = 247
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Setup"
end type

event clicked;printsetup()

end event

type dw_report from u_dw_report within w_encounterpro_report
integer x = 18
integer y = 20
integer width = 2286
integer height = 1668
integer taborder = 20
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

