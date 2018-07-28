$PBExportHeader$w_pop_little_window.srw
forward
global type w_pop_little_window from window
end type
end forward

global type w_pop_little_window from window
integer width = 14
integer height = 12
windowtype windowtype = popup!
event close_window ( )
end type
global w_pop_little_window w_pop_little_window

type variables

long minvalue
long maxvalue
long value

long maxwidth

u_component_base_class caller

end variables

event close_window();close(this)
return

end event

on w_pop_little_window.create
end on

on w_pop_little_window.destroy
end on

