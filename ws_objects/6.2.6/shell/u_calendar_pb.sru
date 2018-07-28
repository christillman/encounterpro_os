HA$PBExportHeader$u_calendar_pb.sru
forward
global type u_calendar_pb from monthcalendar
end type
end forward

global type u_calendar_pb from monthcalendar
integer width = 1006
integer height = 760
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long titletextcolor = 134217742
long trailingtextcolor = 134217745
long monthbackcolor = 1073741824
long titlebackcolor = 134217741
integer maxselectcount = 31
integer scrollrate = 1
boolean todaysection = true
boolean todaycircle = true
boolean border = true
borderstyle borderstyle = stylelowered!
end type
global u_calendar_pb u_calendar_pb

forward prototypes
public subroutine set_date (date pd_new_date)
public function date current_date ()
end prototypes

public subroutine set_date (date pd_new_date);
this.setselecteddate(pd_new_date)



end subroutine

public function date current_date ();
date ld_selected_date
integer li_sts

li_sts = getselecteddate( ld_selected_date)
if li_sts < 0 then
	setnull(ld_selected_date)
end if

return ld_selected_date

end function

on u_calendar_pb.create
end on

on u_calendar_pb.destroy
end on

