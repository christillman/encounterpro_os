$PBExportHeader$u_timer_tabpage.sru
forward
global type u_timer_tabpage from timing
end type
end forward

global type u_timer_tabpage from timing
end type
global u_timer_tabpage u_timer_tabpage

type variables
u_tabpage mytabpage

end variables

forward prototypes
public subroutine initialize_tabpage (u_tabpage puo_tabpage, double pdbl_interval)
end prototypes

public subroutine initialize_tabpage (u_tabpage puo_tabpage, double pdbl_interval);
mytabpage = puo_tabpage

start(pdbl_interval)

end subroutine

event timer;mytabpage.event post timer_ding()

end event

on u_timer_tabpage.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_timer_tabpage.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

