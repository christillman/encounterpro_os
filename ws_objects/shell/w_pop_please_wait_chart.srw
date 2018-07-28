HA$PBExportHeader$w_pop_please_wait_chart.srw
forward
global type w_pop_please_wait_chart from w_pop_please_wait
end type
end forward

global type w_pop_please_wait_chart from w_pop_please_wait
integer x = 0
integer y = 1700
integer width = 2926
integer height = 156
end type
global w_pop_please_wait_chart w_pop_please_wait_chart

forward prototypes
public subroutine resize_and_move ()
end prototypes

public subroutine resize_and_move ();
st_progress_back.visible = false
st_progress_fill.visible = false
st_percentile.visible = false
cb_cancelled.visible = false


x = main_window.x
width = main_window.width
y = main_window.y - height - 88


end subroutine

on w_pop_please_wait_chart.create
call super::create
end on

on w_pop_please_wait_chart.destroy
call super::destroy
end on

event open;
st_progress_back.visible = false
st_progress_fill.visible = false
st_percentile.visible = false
cb_cancelled.visible = false


x = main_window.x
width = main_window.width
y = main_window.y + main_window.height - height - 88

st_progress_back.width = width - 9

end event

type pb_epro_help from w_pop_please_wait`pb_epro_help within w_pop_please_wait_chart
end type

type st_config_mode_menu from w_pop_please_wait`st_config_mode_menu within w_pop_please_wait_chart
end type

type cb_cancelled from w_pop_please_wait`cb_cancelled within w_pop_please_wait_chart
end type

type st_units_done from w_pop_please_wait`st_units_done within w_pop_please_wait_chart
end type

type st_percentile from w_pop_please_wait`st_percentile within w_pop_please_wait_chart
end type

type st_progress_fill from w_pop_please_wait`st_progress_fill within w_pop_please_wait_chart
integer x = 5
integer y = 4
integer width = 242
integer height = 140
end type

type st_title from w_pop_please_wait`st_title within w_pop_please_wait_chart
boolean visible = false
integer x = 951
integer y = 748
end type

type st_progress_back from w_pop_please_wait`st_progress_back within w_pop_please_wait_chart
integer x = 0
integer y = 0
integer width = 2917
integer height = 148
end type

