HA$PBExportHeader$w_encounterpro_report.srw
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
int X=0
int Y=0
int Width=2926
int Height=1832
WindowType WindowType=response!
boolean TitleBar=true
string Title=""
long BackColor=33538240
boolean MinBox=false
boolean MaxBox=false
boolean Resizable=false
WindowState WindowState=maximized!
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
cb_print.x = pb_done.x
cb_printsetup.x = cb_print.x

pb_done.y = height - pb_done.height - 200

dw_report.height = height - 150
dw_report.width = pb_done.x - 100


li_sts = puo_report_component.report_datastore.getfullstate(lbl_report)
if li_sts < 0 then
	puo_report_component.mylog.log(this, "display_report()", "Error getting report state", 4)
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
	luo_report.mylog.log(this, "open", "Invalid report object", 4)
	close(this)
	return
end if

SELECT description
INTO :title
FROM c_Report_Definition
WHERE report_id = :luo_report.report_id
USING luo_report.cprdb;
if not luo_report.cprdb.check() then
	luo_report.mylog.log(this, "open", "Error getting report description", 4)
	close(this)
	return
end if

this.function POST display_report(luo_report)


end event

type pb_done from u_picture_button within w_encounterpro_report
int X=2583
int Y=1568
int TabOrder=10
string PictureName="button26.bmp"
string DisabledName="b_push26.bmp"
end type

event clicked;call super::clicked;close(parent)

end event

type pb_cancel from u_picture_button within w_encounterpro_report
int X=128
int Y=1556
int TabOrder=40
boolean Visible=false
boolean BringToTop=true
string PictureName="button11.bmp"
string DisabledName="b_push11.bmp"
boolean Cancel=true
end type

type cb_print from commandbutton within w_encounterpro_report
int X=2578
int Y=364
int Width=247
int Height=108
int TabOrder=20
boolean BringToTop=true
string Text="Print"
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;dw_report.print()

end event

type cb_printsetup from commandbutton within w_encounterpro_report
int X=2578
int Y=84
int Width=247
int Height=108
int TabOrder=30
boolean BringToTop=true
string Text="Setup"
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;printsetup()

end event

type dw_report from u_dw_report within w_encounterpro_report
int X=18
int Y=20
int Width=2286
int Height=1668
int TabOrder=20
boolean BringToTop=true
boolean HScrollBar=true
boolean VScrollBar=true
end type

