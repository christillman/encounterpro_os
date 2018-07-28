HA$PBExportHeader$u_tabpage_dbmaint_daily_schedules.sru
forward
global type u_tabpage_dbmaint_daily_schedules from u_tabpage
end type
type cb_delete_schedule from commandbutton within u_tabpage_dbmaint_daily_schedules
end type
type cb_new_schedule from commandbutton within u_tabpage_dbmaint_daily_schedules
end type
type st_no_schedules from statictext within u_tabpage_dbmaint_daily_schedules
end type
type tab_schedules from u_tab_dbmaint_schedules within u_tabpage_dbmaint_daily_schedules
end type
type tab_schedules from u_tab_dbmaint_schedules within u_tabpage_dbmaint_daily_schedules
end type
end forward

global type u_tabpage_dbmaint_daily_schedules from u_tabpage
integer width = 2898
string text = "Updates"
cb_delete_schedule cb_delete_schedule
cb_new_schedule cb_new_schedule
st_no_schedules st_no_schedules
tab_schedules tab_schedules
end type
global u_tabpage_dbmaint_daily_schedules u_tabpage_dbmaint_daily_schedules

type variables
long service_sequence
boolean changes_made

end variables

forward prototypes
public subroutine refresh ()
public function integer initialize ()
end prototypes

public subroutine refresh ();long ll_count

tab_schedules.width = width
tab_schedules.height = height - 250

st_no_schedules.width = width

cb_delete_schedule.y = height - cb_delete_schedule.height - 120
cb_new_schedule.y = cb_delete_schedule.y

// Is maintenance enabled?
SELECT count(*)
INTO :ll_count
FROM o_Service_Schedule
WHERE schedule_type = 'Daily'
AND service = 'Database Maintenance';
if not tf_check() then return

if ll_count > 0 then
	tab_schedules.visible = true
	st_no_schedules.visible = false
	cb_delete_schedule.x = (width / 2) - cb_delete_schedule.width - 100
	cb_new_schedule.x = (width / 2) + 100
	
	tab_schedules.refresh()
else
	tab_schedules.visible = false
	st_no_schedules.visible = true
	cb_delete_schedule.visible = false
	cb_new_schedule.x = (width  - cb_new_schedule.width) / 2
end if

end subroutine

public function integer initialize ();long ll_count

if sqlca.modification_level < 141 then
	visible = false
	return 1
end if

tab_schedules.width = width
tab_schedules.height = height - 250

st_no_schedules.width = width

cb_delete_schedule.y = height - cb_delete_schedule.height - 120
cb_new_schedule.y = cb_delete_schedule.y

tab_schedules.initialize()

// Is maintenance enabled?
SELECT count(*)
INTO :ll_count
FROM o_Service_Schedule
WHERE schedule_type = 'Daily'
AND service = 'Database Maintenance';
if not tf_check() then return -1

if ll_count > 0 then
	tab_schedules.visible = true
	st_no_schedules.visible = false
	cb_delete_schedule.x = (width / 2) - cb_delete_schedule.width - 100
	cb_new_schedule.x = (width / 2) + 100
else
	tab_schedules.visible = false
	st_no_schedules.visible = true
	cb_delete_schedule.visible = false
	cb_new_schedule.x = (width  - cb_new_schedule.width) / 2
end if

end function

on u_tabpage_dbmaint_daily_schedules.create
int iCurrent
call super::create
this.cb_delete_schedule=create cb_delete_schedule
this.cb_new_schedule=create cb_new_schedule
this.st_no_schedules=create st_no_schedules
this.tab_schedules=create tab_schedules
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_delete_schedule
this.Control[iCurrent+2]=this.cb_new_schedule
this.Control[iCurrent+3]=this.st_no_schedules
this.Control[iCurrent+4]=this.tab_schedules
end on

on u_tabpage_dbmaint_daily_schedules.destroy
call super::destroy
destroy(this.cb_delete_schedule)
destroy(this.cb_new_schedule)
destroy(this.st_no_schedules)
destroy(this.tab_schedules)
end on

type cb_delete_schedule from commandbutton within u_tabpage_dbmaint_daily_schedules
integer x = 814
integer y = 1388
integer width = 576
integer height = 92
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete Schedule"
end type

event clicked;tab_schedules.delete_schedule( )

end event

type cb_new_schedule from commandbutton within u_tabpage_dbmaint_daily_schedules
integer x = 1586
integer y = 1388
integer width = 576
integer height = 92
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Schedule"
end type

event clicked;tab_schedules.new_schedule( )

refresh()

end event

type st_no_schedules from statictext within u_tabpage_dbmaint_daily_schedules
boolean visible = false
integer y = 584
integer width = 1989
integer height = 160
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "No Maintenance Schedules"
alignment alignment = center!
boolean focusrectangle = false
end type

type tab_schedules from u_tab_dbmaint_schedules within u_tabpage_dbmaint_daily_schedules
end type

