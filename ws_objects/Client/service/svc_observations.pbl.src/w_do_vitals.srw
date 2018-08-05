$PBExportHeader$w_do_vitals.srw
forward
global type w_do_vitals from w_window_base
end type
type uo_current_meds from u_current_meds_small within w_do_vitals
end type
type dw_timed_set_list from u_timed_set_list within w_do_vitals
end type
type pb_down from u_picture_button within w_do_vitals
end type
type pb_up from u_picture_button within w_do_vitals
end type
type cb_new_timed_set from commandbutton within w_do_vitals
end type
type st_timed_set_title from statictext within w_do_vitals
end type
type cb_done from commandbutton within w_do_vitals
end type
type cb_not_done from commandbutton within w_do_vitals
end type
type dw_vitals from u_dw_vitals within w_do_vitals
end type
type uo_unit_preference from u_cb_toggle within w_do_vitals
end type
type uo_allergies from u_allergies within w_do_vitals
end type
type st_page from statictext within w_do_vitals
end type
type st_date from statictext within w_do_vitals
end type
type st_title from statictext within w_do_vitals
end type
end forward

global type w_do_vitals from w_window_base
integer height = 1840
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
string button_type = "COMMAND"
integer max_buttons = 3
boolean zoom_dw_on_resize = true
event check_alert ( )
uo_current_meds uo_current_meds
dw_timed_set_list dw_timed_set_list
pb_down pb_down
pb_up pb_up
cb_new_timed_set cb_new_timed_set
st_timed_set_title st_timed_set_title
cb_done cb_done
cb_not_done cb_not_done
dw_vitals dw_vitals
uo_unit_preference uo_unit_preference
uo_allergies uo_allergies
st_page st_page
st_date st_date
st_title st_title
end type
global w_do_vitals w_do_vitals

type variables
u_component_service service

integer top_rb_x = 180
integer top_rb_y = 421
integer rb_gap = 140

//boolean initializing = true

//boolean showing_complaint

u_ds_data   treatments
u_ds_data	attributes


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
long ll_menu_id

setnull(ls_null)
popup_return.item_count = 1
popup_return.items[1] = "ERROR"
//showing_complaint = false

service = message.powerobjectparm

if isnull(service.treatment) then
	log.log(this, "w_do_vitals:open", "Null Treatment Object", 4)
	closewithreturn(this, popup_return)
	return
end if


unit_preference = original_unit_preference

title = current_patient.id_line()
st_title.text = service.treatment.treatment_description

if date(service.treatment.begin_date) = today() then
	st_date.text = "Date Ordered:  Today"
else
	st_date.text = "Date Ordered:  " + string(date(service.treatment.begin_date))
end if

//st_chief_complaint.text = encounter.get_finding_text()

uo_allergies.set_value()
//uo_functional_development.set_color()

li_sts = dw_vitals.initialize(service, unit_preference)
if li_sts <= 0 then
	log.log(this, "w_do_vitals:open", "Error initializing vitals display", 4)
	closewithreturn(this, popup_return)
	return
end if


uo_unit_preference.initialize("Eng", "ENGLISH", "Met", "METRIC", unit_preference)

li_sts = dw_timed_set_list.initialize(service)
if li_sts < 0 then
	log.log(this, "w_do_vitals:open", "Error initializing vitals display", 4)
	closewithreturn(this, popup_return)
	return
end if

li_sts = dw_timed_set_list.load()
if li_sts < 0 then
	log.log(this, "w_do_vitals:open", "Error loading vitals display", 4)
	closewithreturn(this, popup_return)
	return
end if

cb_new_timed_set.visible = dw_timed_set_list.visible
st_timed_set_title.visible = dw_timed_set_list.visible

if dw_timed_set_list.visible then
	ll_row = dw_timed_set_list.select_set()
	if ll_row <= 0 then
		log.log(this, "w_do_vitals:open", "Error selecting timed set", 4)
		closewithreturn(this, popup_return)
		return
	end if
elseif dw_timed_set_list.rowcount() > 0 then
	dw_timed_set_list.select_set(1)
else
	log.log(this, "w_do_vitals:open", "Error loading timed set - set not found", 4)
	closewithreturn(this, popup_return)
	return
end if

// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_not_done.visible = false
	max_buttons = 4
end if

ll_menu_id = long(service.get_attribute("menu_id"))
paint_menu(ll_menu_id)


uo_current_meds.display_meds()

// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_not_done.visible = false
end if

dw_vitals.last_page = 0
dw_vitals.set_page(1, st_page.text)
if dw_vitals.last_page <= 1 then
	pb_up.visible = false
	pb_down.visible = false
	st_page.visible = false
else
	pb_up.visible = true
	pb_down.visible = true
	st_page.visible = true
	pb_up.enabled = false
end if

state_attributes.attribute_count = 0
f_attribute_add_attribute(state_attributes, "observation_id", service.root_observation_id())
f_attribute_add_attribute(state_attributes, "treatment_id", string(service.treatment.treatment_id))
f_attribute_add_attribute(state_attributes, "treatment_type", service.treatment.treatment_type)


postevent("check_alert")

end event

on w_do_vitals.create
int iCurrent
call super::create
this.uo_current_meds=create uo_current_meds
this.dw_timed_set_list=create dw_timed_set_list
this.pb_down=create pb_down
this.pb_up=create pb_up
this.cb_new_timed_set=create cb_new_timed_set
this.st_timed_set_title=create st_timed_set_title
this.cb_done=create cb_done
this.cb_not_done=create cb_not_done
this.dw_vitals=create dw_vitals
this.uo_unit_preference=create uo_unit_preference
this.uo_allergies=create uo_allergies
this.st_page=create st_page
this.st_date=create st_date
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_current_meds
this.Control[iCurrent+2]=this.dw_timed_set_list
this.Control[iCurrent+3]=this.pb_down
this.Control[iCurrent+4]=this.pb_up
this.Control[iCurrent+5]=this.cb_new_timed_set
this.Control[iCurrent+6]=this.st_timed_set_title
this.Control[iCurrent+7]=this.cb_done
this.Control[iCurrent+8]=this.cb_not_done
this.Control[iCurrent+9]=this.dw_vitals
this.Control[iCurrent+10]=this.uo_unit_preference
this.Control[iCurrent+11]=this.uo_allergies
this.Control[iCurrent+12]=this.st_page
this.Control[iCurrent+13]=this.st_date
this.Control[iCurrent+14]=this.st_title
end on

on w_do_vitals.destroy
call super::destroy
destroy(this.uo_current_meds)
destroy(this.dw_timed_set_list)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.cb_new_timed_set)
destroy(this.st_timed_set_title)
destroy(this.cb_done)
destroy(this.cb_not_done)
destroy(this.dw_vitals)
destroy(this.uo_unit_preference)
destroy(this.uo_allergies)
destroy(this.st_page)
destroy(this.st_date)
destroy(this.st_title)
end on

event results_posted;call super::results_posted;integer li_sts

li_sts = dw_vitals.results_posted(puo_observation)


end event

event source_connected;call super::source_connected;dw_vitals.event TRIGGER source_connected(puo_observation)

end event

event source_disconnected;call super::source_disconnected;dw_vitals.event TRIGGER source_disconnected(puo_observation)

end event

type pb_epro_help from w_window_base`pb_epro_help within w_do_vitals
integer x = 2830
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_do_vitals
end type

type uo_current_meds from u_current_meds_small within w_do_vitals
integer x = 78
integer y = 1152
integer width = 485
integer height = 316
integer taborder = 10
boolean border = true
borderstyle borderstyle = styleraised!
integer max_meds = 5
end type

on uo_current_meds.destroy
call u_current_meds_small::destroy
end on

type dw_timed_set_list from u_timed_set_list within w_do_vitals
integer x = 5
integer y = 172
integer width = 635
integer height = 824
integer taborder = 20
end type

event selected;call super::selected;long ll_observation_sequence

ll_observation_sequence = object.observation_sequence[selected_row]

dw_vitals.load(ll_observation_sequence, unit_preference)

f_attribute_add_attribute(state_attributes, "observation_sequence", string(ll_observation_sequence))

return

end event

type pb_down from u_picture_button within w_do_vitals
integer x = 2715
integer y = 304
integer width = 137
integer height = 116
integer taborder = 20
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_vitals.current_page
li_last_page = dw_vitals.last_page

dw_vitals.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type pb_up from u_picture_button within w_do_vitals
integer x = 2715
integer y = 180
integer width = 137
integer height = 116
integer taborder = 10
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;integer li_page

li_page = dw_vitals.current_page

dw_vitals.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type cb_new_timed_set from commandbutton within w_do_vitals
integer x = 352
integer y = 1000
integer width = 279
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Set"
end type

event clicked;dw_timed_set_list.new_timed_set()

end event

type st_timed_set_title from statictext within w_do_vitals
integer x = 46
integer y = 104
integer width = 539
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Timed Set"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_done from commandbutton within w_do_vitals
integer x = 2427
integer y = 1620
integer width = 443
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

dw_vitals.shutdown()

popup_return.item_count = 1
popup_return.items[1] = "CLOSE"
closewithreturn(parent, popup_return)

end event

type cb_not_done from commandbutton within w_do_vitals
integer x = 1961
integer y = 1620
integer width = 443
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

dw_vitals.shutdown()

popup_return.item_count = 0
closewithreturn(parent, popup_return)

end event

type dw_vitals from u_dw_vitals within w_do_vitals
integer x = 649
integer y = 184
integer width = 2057
integer height = 1416
integer taborder = 10
end type

type uo_unit_preference from u_cb_toggle within w_do_vitals
integer x = 2715
integer y = 484
integer width = 137
integer height = 108
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
string text = "Eng"
end type

event clicked;call super::clicked;integer li_sts

unit_preference = value

dw_vitals.load(unit_preference)

end event

type uo_allergies from u_allergies within w_do_vitals
integer x = 78
integer y = 1492
integer width = 485
integer height = 108
long backcolor = 12632256
string text = ""
end type

type st_page from statictext within w_do_vitals
integer x = 2432
integer y = 124
integer width = 274
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99/99"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_date from statictext within w_do_vitals
integer x = 649
integer y = 120
integer width = 1696
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean focusrectangle = false
end type

type st_title from statictext within w_do_vitals
integer width = 2894
integer height = 120
boolean bringtotop = true
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Vital Signs"
alignment alignment = center!
boolean focusrectangle = false
end type

