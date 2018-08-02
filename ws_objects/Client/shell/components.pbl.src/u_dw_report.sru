$PBExportHeader$u_dw_report.sru
forward
global type u_dw_report from datawindow
end type
end forward

global type u_dw_report from datawindow
int Width=731
int Height=556
int TabOrder=10
BorderStyle BorderStyle=StyleLowered!
boolean LiveScroll=true
end type
global u_dw_report u_dw_report

type variables
u_event_log mylog

end variables

event error;string ls_temp

ls_temp = "Error (" + string(errornumber) + "): " + errortext

mylog.log(this, "u_dw_report.error.0005", ls_temp, 4)


end event

