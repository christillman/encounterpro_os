$PBExportHeader$w_observation_grid.srw
forward
global type w_observation_grid from w_observation_base
end type
type pb_down from u_picture_button within w_observation_grid
end type
type pb_up from u_picture_button within w_observation_grid
end type
type cb_done from commandbutton within w_observation_grid
end type
type cb_not_done from commandbutton within w_observation_grid
end type
type cb_menu from commandbutton within w_observation_grid
end type
type dw_observation_grid from u_dw_observation_grid within w_observation_grid
end type
type cb_timer from commandbutton within w_observation_grid
end type
type st_time from statictext within w_observation_grid
end type
type st_title from statictext within w_observation_grid
end type
end forward

global type w_observation_grid from w_observation_base
boolean titlebar = false
string title = ""
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
event check_alert ( )
pb_down pb_down
pb_up pb_up
cb_done cb_done
cb_not_done cb_not_done
cb_menu cb_menu
dw_observation_grid dw_observation_grid
cb_timer cb_timer
st_time st_time
st_title st_title
end type
global w_observation_grid w_observation_grid

type variables
u_component_service service

integer top_rb_x = 180
integer top_rb_y = 421
integer rb_gap = 140

long menu_id

datetime start_time

end variables

event check_alert();integer li_sts
u_component_alert luo_alert
string ls_show_alerts

// If the show_alerts is not set then the default behavior for this screen is to show the alerts.
// If the attribute is set then the service base class has already handled it
ls_show_alerts = service.get_attribute("show_alerts")
if isnull(ls_show_alerts) then
	luo_alert = component_manager.get_component(common_thread.chart_alert_component())
	If Isvalid(luo_alert) Then
		li_sts = luo_alert.alert(current_patient.cpr_id, current_patient.open_encounter_id, "ALERT")
		component_manager.destroy_component(luo_alert)
	End If
end if

end event

event open;call super::open;str_popup popup
str_popup_return popup_return
u_component_treatment luo_vital
long ll_encounter_id
long ll_treatment_id
long ll_row
integer li_sts
integer i
boolean lb_found
string ls_null
str_menu lstr_menu
string ls_observation_id
long ll_root_observation_sequence
str_observation_tree_branch lstr_branch
integer li_child_ordinal
datetime ldt_stop_time
string ls_temp

setnull(ls_null)
popup_return.item_count = 0
//showing_complaint = false

service = message.powerobjectparm

if isnull(service.treatment) then
	log.log(this, "w_observation_grid:open", "Null Treatment Object", 4)
	closewithreturn(this, popup_return)
	return
end if

title = current_patient.id_line()
st_title.text = service.treatment.treatment_description

li_sts = dw_observation_grid.initialize(service)
if li_sts <= 0 then
	log.log(this, "w_observation_grid:open", "Error initializing grid display", 4)
	closewithreturn(this, popup_return)
	return
end if

li_sts = dw_observation_grid.load()
if li_sts <= 0 then
	log.log(this, "w_observation_grid:open", "Error loading grid display", 4)
	closewithreturn(this, popup_return)
	return
end if

menu_id = long(service.get_attribute("menu_id"))
if isnull(menu_id) then
	cb_menu.visible = false
else
	lstr_menu = datalist.get_menu(menu_id)
	if lstr_menu.menu_item_count <= 0 then
		cb_menu.visible = false
	elseif lstr_menu.menu_item_count = 1 then
		cb_menu.text = lstr_menu.menu_item[1].button_title
	else
		cb_menu.text = lstr_menu.description
	end if
end if

// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_not_done.visible = false
end if

pb_up.enabled = false

service.get_attribute("start_time", start_time)
service.get_attribute("stop_time", ldt_stop_time)
if not isnull(start_time) then
	if ldt_stop_time > start_time then setnull(start_time)
end if

if isnull(start_time) then
	cb_timer.text = "Start"
	st_time.visible = false
else
	cb_timer.text = "Stop"
	st_time.text = f_datetime_diff(start_time, datetime(today(), now()))
	timer(1)
end if

postevent("check_alert")

end event

on w_observation_grid.create
int iCurrent
call super::create
this.pb_down=create pb_down
this.pb_up=create pb_up
this.cb_done=create cb_done
this.cb_not_done=create cb_not_done
this.cb_menu=create cb_menu
this.dw_observation_grid=create dw_observation_grid
this.cb_timer=create cb_timer
this.st_time=create st_time
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_down
this.Control[iCurrent+2]=this.pb_up
this.Control[iCurrent+3]=this.cb_done
this.Control[iCurrent+4]=this.cb_not_done
this.Control[iCurrent+5]=this.cb_menu
this.Control[iCurrent+6]=this.dw_observation_grid
this.Control[iCurrent+7]=this.cb_timer
this.Control[iCurrent+8]=this.st_time
this.Control[iCurrent+9]=this.st_title
end on

on w_observation_grid.destroy
call super::destroy
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.cb_done)
destroy(this.cb_not_done)
destroy(this.cb_menu)
destroy(this.dw_observation_grid)
destroy(this.cb_timer)
destroy(this.st_time)
destroy(this.st_title)
end on

event results_posted;call super::results_posted;integer li_sts

li_sts = dw_observation_grid.results_posted(puo_observation)



end event

event source_connected;call super::source_connected;dw_observation_grid.event TRIGGER source_connected(puo_observation)

end event

event source_disconnected;call super::source_disconnected;dw_observation_grid.event TRIGGER source_disconnected(puo_observation)

end event

event timer;call super::timer;string ls_temp
string ls_time
long ll_stage
long ll_row
long ll_last_row

f_split_string(st_time.text, ":", ls_time, ls_temp)
f_split_string(ls_temp, ":", ls_time, ls_temp)

ll_stage = long(ls_time)
ll_last_row = ll_stage + 1

st_time.text = f_datetime_diff(start_time, datetime(today(), now()))

f_split_string(st_time.text, ":", ls_time, ls_temp)
f_split_string(ls_temp, ":", ls_time, ls_temp)

ll_stage = long(ls_time)
ll_row = ll_stage + 1

if ll_row > ll_last_row then
end if

if dw_observation_grid.rowcount() > ll_row then
	dw_observation_grid.clear_selected()
	dw_observation_grid.object.selected_flag[ll_row] = 1
end if

end event

type pb_epro_help from w_window_base`pb_epro_help within w_observation_grid
boolean visible = true
integer x = 1385
integer y = 1652
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_observation_grid
end type

type pb_down from u_picture_button within w_observation_grid
integer x = 2706
integer y = 268
integer width = 137
integer height = 116
integer taborder = 20
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page
string ls_temp

li_page = dw_observation_grid.current_page
li_last_page = dw_observation_grid.last_page

if li_page = li_last_page then
	dw_observation_grid.load_page(li_page + 1)
end if

dw_observation_grid.set_page(li_page + 1, ls_temp)

//if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type pb_up from u_picture_button within w_observation_grid
integer x = 2706
integer y = 144
integer width = 137
integer height = 116
integer taborder = 10
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;integer li_page
string ls_temp

li_page = dw_observation_grid.current_page

dw_observation_grid.set_page(li_page - 1, ls_temp)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type cb_done from commandbutton within w_observation_grid
integer x = 2359
integer y = 1652
integer width = 485
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Done"
end type

event clicked;str_popup_return popup_return

dw_observation_grid.shutdown()

popup_return.item_count = 1
popup_return.items[1] = "CLOSE"
closewithreturn(parent, popup_return)

end event

type cb_not_done from commandbutton within w_observation_grid
integer x = 1797
integer y = 1652
integer width = 485
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
end type

event clicked;str_popup_return popup_return

dw_observation_grid.shutdown()

popup_return.item_count = 0
closewithreturn(parent, popup_return)

end event

type cb_menu from commandbutton within w_observation_grid
integer x = 78
integer y = 1652
integer width = 581
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Menu"
end type

event clicked;f_display_menu(menu_id, true)

end event

type dw_observation_grid from u_dw_observation_grid within w_observation_grid
integer x = 73
integer y = 144
integer height = 1248
integer taborder = 11
boolean bringtotop = true
borderstyle borderstyle = stylelowered!
end type

type cb_timer from commandbutton within w_observation_grid
integer x = 919
integer y = 1432
integer width = 334
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Start"
end type

event clicked;datetime ldt_stop_time

if text = "Start" then
	text = "Stop"
	start_time = datetime(today(), now())
	service.add_workplan_item_attribute("start_time", string(start_time, db_datetime_format))
	st_time.visible = true
	st_time.text = "00:00:00"
	timer(1)
else
	text = "Start"
	ldt_stop_time = datetime(today(), now())
	service.add_workplan_item_attribute("stop_time", string(ldt_stop_time, db_datetime_format))
	st_time.visible = FALSE
	timer(0)
end if


end event

type st_time from statictext within w_observation_grid
integer x = 1298
integer y = 1432
integer width = 521
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "none"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_title from statictext within w_observation_grid
integer y = 4
integer width = 2894
integer height = 120
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
string text = "Test Results in Stages"
alignment alignment = center!
boolean focusrectangle = false
end type

