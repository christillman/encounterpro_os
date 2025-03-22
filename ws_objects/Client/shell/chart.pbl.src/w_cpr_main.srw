$PBExportHeader$w_cpr_main.srw
forward
global type w_cpr_main from w_window_base
end type
type st_property_8 from u_st_property within w_cpr_main
end type
type st_property_7 from u_st_property within w_cpr_main
end type
type st_property_6 from u_st_property within w_cpr_main
end type
type st_property_5 from u_st_property within w_cpr_main
end type
type st_property_title_8 from statictext within w_cpr_main
end type
type st_property_title_7 from statictext within w_cpr_main
end type
type st_property_title_6 from statictext within w_cpr_main
end type
type st_property_title_5 from statictext within w_cpr_main
end type
type st_property_4 from u_st_property within w_cpr_main
end type
type st_property_3 from u_st_property within w_cpr_main
end type
type st_property_2 from u_st_property within w_cpr_main
end type
type st_property_1 from u_st_property within w_cpr_main
end type
type st_property_title_3 from statictext within w_cpr_main
end type
type st_property_title_4 from statictext within w_cpr_main
end type
type uo_prior_meds from u_prior_meds_small within w_cpr_main
end type
type st_property_title_2 from statictext within w_cpr_main
end type
type tab_cpr from u_cpr_tab within w_cpr_main
end type
type tab_cpr from u_cpr_tab within w_cpr_main
end type
type ln_1 from line within w_cpr_main
end type
type uo_picture from u_picture_display within w_cpr_main
end type
type st_portrait from statictext within w_cpr_main
end type
type st_property_title_1 from statictext within w_cpr_main
end type
type st_halt from statictext within w_cpr_main
end type
type st_1 from statictext within w_cpr_main
end type
end forward

global type w_cpr_main from w_window_base
integer height = 1840
windowtype windowtype = response!
event post_open pbm_custom01
event open_windows pbm_custom02
event load_error ( string ps_message )
st_property_8 st_property_8
st_property_7 st_property_7
st_property_6 st_property_6
st_property_5 st_property_5
st_property_title_8 st_property_title_8
st_property_title_7 st_property_title_7
st_property_title_6 st_property_title_6
st_property_title_5 st_property_title_5
st_property_4 st_property_4
st_property_3 st_property_3
st_property_2 st_property_2
st_property_1 st_property_1
st_property_title_3 st_property_title_3
st_property_title_4 st_property_title_4
uo_prior_meds uo_prior_meds
st_property_title_2 st_property_title_2
tab_cpr tab_cpr
ln_1 ln_1
uo_picture uo_picture
st_portrait st_portrait
st_property_title_1 st_property_title_1
st_halt st_halt
st_1 st_1
end type
global w_cpr_main w_cpr_main

type variables
//long encounter_id
//long encounter_log_id
//string todo_user_id
//long todo_item_id
//long todo_encounter_id
//long display_encounter_id

window current_window

integer portrait_height = 305
integer portrait_width = 348
integer portrait_x = 1235
integer portrait_y = 13


end variables

forward prototypes
public function integer windowposchanging (long pl_x, long pl_y, long pl_width, long pl_height, long pl_flags)
public function integer close ()
public subroutine initialize ()
public subroutine display_portrait ()
public subroutine refresh_screen ()
public function integer refresh ()
public function integer initialize_property (string ps_prop_num, ref u_st_property pst_prop, ref statictext pst_prop_title, ref str_attributes pstr_attributes)
public function integer close_me (string ps_status)
end prototypes

event post_open;integer li_sts
u_component_alert luo_alert
string ls_show_alerts

// If the show_alerts is not set then the default behavior for this screen is to show the alerts.
// If the attribute is set then the service base class has already handled it
ls_show_alerts = current_service.get_attribute("show_alerts")
if isnull(ls_show_alerts) then
	luo_alert = component_manager.get_component(common_thread.chart_alert_component())
	If Isvalid(luo_alert) Then
		li_sts = luo_alert.alert(current_patient.cpr_id, current_patient.open_encounter_id, "NOTE")
		li_sts = luo_alert.alert(current_patient.cpr_id, current_patient.open_encounter_id, "ALERT")
		component_manager.destroy_component(luo_alert)
	End If
else
	// Even if the base class has already handled the alerts, this service still shows the chart notes, if there are any
	luo_alert = component_manager.get_component(common_thread.chart_alert_component())
	If Isvalid(luo_alert) Then
		li_sts = luo_alert.alert(current_patient.cpr_id, current_patient.open_encounter_id, "NOTE")
		component_manager.destroy_component(luo_alert)
	End If
end if

if isvalid(tab_cpr.wait_window) then close(tab_cpr.wait_window)

enable_window()

tab_cpr.setfocus()


end event

event load_error(string ps_message);str_popup popup

long ll_choice

if isvalid(tab_cpr.wait_window) then close(tab_cpr.wait_window)

popup.title = ps_message

popup.data_row_count = 2
popup.items[1] = "Try Again Now"
popup.items[2] = "Try Again Later"
openwithparm(w_pop_choices_2, popup)
ll_choice = message.doubleparm
if ll_choice = 1 then
	// Try again now
	close_me("TRY AGAIN")
else
	// Try again later
	close_me("ERROR")
end if



end event

public function integer windowposchanging (long pl_x, long pl_y, long pl_width, long pl_height, long pl_flags);return tab_cpr.windowposchanging(pl_x, pl_y, pl_width, pl_height, pl_flags)


end function

public function integer close ();string ls_status

setnull(ls_status)

return close_me(ls_status)

end function

public subroutine initialize ();integer li_sts

// If the service is part of an encounter then display that encounter
if not isnull(current_service.encounter_id) then
	li_sts = f_set_current_encounter(current_service.encounter_id)
else
	li_sts = current_patient.encounters.last_encounter()



end if


end subroutine

public subroutine display_portrait ();string ls_file
string ls_find
str_progress_list lstr_attachments
long ll_null

setnull(ll_null)

lstr_attachments = current_patient.attachments.get_attachments( "Patient", ll_null, "Attachment", "Portrait")

if lstr_attachments.progress_count > 0 then
	// Display the last attachment
	ls_file = current_patient.attachments.get_attachment(lstr_attachments.progress[lstr_attachments.progress_count].attachment_id)
	uo_picture.display_picture(ls_file)
	st_portrait.visible = false
	uo_picture.visible = true
	filedelete(ls_file)
else
	st_portrait.visible = true
	uo_picture.visible = false
end if



end subroutine

public subroutine refresh_screen ();
// This function refreshes the objects on the Chart screen, not including the tab

title = current_patient.id_line()
if current_patient.display_only then main_window.title += " (Display Only)"

display_portrait()

st_property_1.refresh()
st_property_2.refresh()
st_property_3.refresh()
st_property_4.refresh()
st_property_5.refresh()
st_property_6.refresh()
st_property_7.refresh()
st_property_8.refresh()

uo_prior_meds.display_meds()

end subroutine

public function integer refresh ();
refresh_screen()

tab_cpr.refresh()

return 1

end function

public function integer initialize_property (string ps_prop_num, ref u_st_property pst_prop, ref statictext pst_prop_title, ref str_attributes pstr_attributes);string ls_property, ls_property_title
long ll_null

setnull(ll_null)

ls_property = current_service.get_attribute("property_" + ps_prop_num)
if isnull(ls_property) then
	pst_prop.visible = false
	pst_prop_title.visible = false
else
	pst_prop.initialize(ls_property, pst_prop_title, ll_null, pstr_attributes)
	ls_property_title = current_service.get_attribute("property_title_" + ps_prop_num)
	if not isnull(ls_property_title) then pst_prop_title.text = ls_property_title
end if
	
return 0
end function

public function integer close_me (string ps_status);str_popup_return popup_return

if isnull(ps_status) then
	popup_return.item_count = 0
else
	popup_return.item_count = 1
	popup_return.items[1] = ps_status
end if

if IsValid(main_window) then main_window.postevent("refresh")

closewithreturn(this, popup_return)

return 1

end function

event open;call super::open;str_popup_return popup_return
string ls_encounter_flag
integer li_sts
string ls_property_title
string ls_mode
string ls_property
long ll_null
str_attributes lstr_attributes
time lt_start_loading
time lt_done_loading
decimal ld_loadtime

setnull(ll_null)
lt_start_loading = now()

popup_return.item_count = 0

if isnull(current_service) or not isvalid(current_service) then
	log.log(this, "w_cpr_main:open", "Current service not valid", 4)
	closewithreturn(this, popup_return)
	return
end if

tab_cpr.chart_window = this
open(tab_cpr.wait_window, "w_pop_please_wait_chart")

log.log(this, "w_cpr_main:open", "Initializing w_cpr_main...", 1)
initialize()

log.log(this, "w_cpr_main:open", "Initializing tab_cpr...", 1)
tab_cpr.initialize()

current_service.add_attribute("chart_id", string(tab_cpr.chart_id))

if not isnull(current_service) then
	initialize_property("1", st_property_1, st_property_title_1, lstr_attributes)
	initialize_property("2", st_property_2, st_property_title_2, lstr_attributes)
	initialize_property("3", st_property_3, st_property_title_3, lstr_attributes)
	initialize_property("4", st_property_4, st_property_title_4, lstr_attributes)
	initialize_property("5", st_property_5, st_property_title_5, lstr_attributes)
	initialize_property("6", st_property_6, st_property_title_6, lstr_attributes)
	initialize_property("7", st_property_7, st_property_title_7, lstr_attributes)
	initialize_property("8", st_property_8, st_property_title_8, lstr_attributes)
end if

uo_picture.initialize()

log.log(this, "w_cpr_main:open", "calling refresh_screen()...", 1)
refresh_screen()

if isvalid(tab_cpr.wait_window) then tab_cpr.wait_window.bump_progress()

log.log(this, "w_cpr_main:open", "calling tab_cpr.select_default_tab()", 1)
tab_cpr.select_default_tab()

// Log the amount of time it took to load the chart
lt_done_loading = now()
ld_loadtime = f_time_seconds_after(lt_start_loading, lt_done_loading)
common_thread.log_perflog("Chart Load Time", ld_loadtime, true)

//post_open event will trigger showing alerts, if any
postevent("post_open")

end event

on w_cpr_main.create
int iCurrent
call super::create
this.st_property_8=create st_property_8
this.st_property_7=create st_property_7
this.st_property_6=create st_property_6
this.st_property_5=create st_property_5
this.st_property_title_8=create st_property_title_8
this.st_property_title_7=create st_property_title_7
this.st_property_title_6=create st_property_title_6
this.st_property_title_5=create st_property_title_5
this.st_property_4=create st_property_4
this.st_property_3=create st_property_3
this.st_property_2=create st_property_2
this.st_property_1=create st_property_1
this.st_property_title_3=create st_property_title_3
this.st_property_title_4=create st_property_title_4
this.uo_prior_meds=create uo_prior_meds
this.st_property_title_2=create st_property_title_2
this.tab_cpr=create tab_cpr
this.ln_1=create ln_1
this.uo_picture=create uo_picture
this.st_portrait=create st_portrait
this.st_property_title_1=create st_property_title_1
this.st_halt=create st_halt
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_property_8
this.Control[iCurrent+2]=this.st_property_7
this.Control[iCurrent+3]=this.st_property_6
this.Control[iCurrent+4]=this.st_property_5
this.Control[iCurrent+5]=this.st_property_title_8
this.Control[iCurrent+6]=this.st_property_title_7
this.Control[iCurrent+7]=this.st_property_title_6
this.Control[iCurrent+8]=this.st_property_title_5
this.Control[iCurrent+9]=this.st_property_4
this.Control[iCurrent+10]=this.st_property_3
this.Control[iCurrent+11]=this.st_property_2
this.Control[iCurrent+12]=this.st_property_1
this.Control[iCurrent+13]=this.st_property_title_3
this.Control[iCurrent+14]=this.st_property_title_4
this.Control[iCurrent+15]=this.uo_prior_meds
this.Control[iCurrent+16]=this.st_property_title_2
this.Control[iCurrent+17]=this.tab_cpr
this.Control[iCurrent+18]=this.ln_1
this.Control[iCurrent+19]=this.uo_picture
this.Control[iCurrent+20]=this.st_portrait
this.Control[iCurrent+21]=this.st_property_title_1
this.Control[iCurrent+22]=this.st_halt
this.Control[iCurrent+23]=this.st_1
end on

on w_cpr_main.destroy
call super::destroy
destroy(this.st_property_8)
destroy(this.st_property_7)
destroy(this.st_property_6)
destroy(this.st_property_5)
destroy(this.st_property_title_8)
destroy(this.st_property_title_7)
destroy(this.st_property_title_6)
destroy(this.st_property_title_5)
destroy(this.st_property_4)
destroy(this.st_property_3)
destroy(this.st_property_2)
destroy(this.st_property_1)
destroy(this.st_property_title_3)
destroy(this.st_property_title_4)
destroy(this.uo_prior_meds)
destroy(this.st_property_title_2)
destroy(this.tab_cpr)
destroy(this.ln_1)
destroy(this.uo_picture)
destroy(this.st_portrait)
destroy(this.st_property_title_1)
destroy(this.st_halt)
destroy(this.st_1)
end on

event close;call super::close;tab_cpr.finished()

end event

event key;call super::key;tab_cpr.event key(key, keyflags)



end event

type pb_epro_help from w_window_base`pb_epro_help within w_cpr_main
integer x = 2830
integer y = 4
integer taborder = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_cpr_main
end type

type st_property_8 from u_st_property within w_cpr_main
integer x = 2263
integer y = 256
integer width = 626
integer height = 76
integer textsize = -9
string text = ""
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
end type

type st_property_7 from u_st_property within w_cpr_main
integer x = 2263
integer y = 172
integer width = 626
integer height = 76
integer textsize = -9
string text = ""
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
end type

type st_property_6 from u_st_property within w_cpr_main
integer x = 2263
integer y = 88
integer width = 626
integer height = 76
integer textsize = -9
string text = ""
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
end type

type st_property_5 from u_st_property within w_cpr_main
integer x = 2263
integer y = 4
integer width = 626
integer height = 76
integer textsize = -9
string text = ""
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
end type

type st_property_title_8 from statictext within w_cpr_main
integer x = 1938
integer y = 252
integer width = 311
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Property 8"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_property_title_7 from statictext within w_cpr_main
integer x = 1938
integer y = 172
integer width = 311
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Property 7"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_property_title_6 from statictext within w_cpr_main
integer x = 1938
integer y = 92
integer width = 311
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Property 6"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_property_title_5 from statictext within w_cpr_main
integer x = 1938
integer y = 12
integer width = 311
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "Property 5"
alignment alignment = right!
boolean focusrectangle = false
end type

event clicked;str_attributes lstr_attributes


lstr_attributes.attribute_count = 0

lstr_attributes.attribute_count += 1
lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = "chart_id"
lstr_attributes.attribute[lstr_attributes.attribute_count].value = string(tab_cpr.chart_id)

openwithparm(w_attributes_display, lstr_attributes)


end event

type st_property_4 from u_st_property within w_cpr_main
integer x = 352
integer y = 256
integer width = 773
integer height = 76
integer textsize = -9
string text = ""
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
end type

type st_property_3 from u_st_property within w_cpr_main
integer x = 352
integer y = 172
integer width = 773
integer height = 76
integer textsize = -9
string text = ""
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
end type

type st_property_2 from u_st_property within w_cpr_main
integer x = 352
integer y = 88
integer width = 773
integer height = 76
integer textsize = -9
string text = ""
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
end type

type st_property_1 from u_st_property within w_cpr_main
integer x = 352
integer y = 4
integer width = 773
integer height = 76
integer textsize = -9
string text = ""
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
end type

type st_property_title_3 from statictext within w_cpr_main
integer x = 27
integer y = 172
integer width = 311
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Property 3"
alignment alignment = right!
boolean focusrectangle = false
end type

event clicked;pb_epro_help.event trigger clicked()

end event

type st_property_title_4 from statictext within w_cpr_main
integer x = 27
integer y = 252
integer width = 311
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Property 4"
alignment alignment = right!
boolean focusrectangle = false
end type

event clicked;pb_epro_help.event trigger clicked()

end event

type uo_prior_meds from u_prior_meds_small within w_cpr_main
integer x = 1499
integer y = 12
integer width = 434
integer height = 308
boolean border = true
borderstyle borderstyle = styleraised!
integer max_meds = 4
end type

on uo_prior_meds.destroy
call u_prior_meds_small::destroy
end on

event meds_clicked;call super::meds_clicked;refresh()

end event

type st_property_title_2 from statictext within w_cpr_main
integer x = 27
integer y = 92
integer width = 311
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Property 2"
alignment alignment = right!
boolean focusrectangle = false
end type

event clicked;pb_epro_help.event trigger clicked()

end event

type tab_cpr from u_cpr_tab within w_cpr_main
integer x = 5
integer y = 340
integer width = 2885
integer height = 1392
end type

event refresh;call super::refresh;refresh_screen()

end event

type ln_1 from line within w_cpr_main
integer linethickness = 12
integer beginy = 336
integer endx = 2962
integer endy = 336
end type

type uo_picture from u_picture_display within w_cpr_main
integer x = 1138
integer y = 16
integer width = 347
integer height = 304
borderstyle borderstyle = styleraised!
end type

on uo_picture.destroy
call u_picture_display::destroy
end on

event picture_clicked;call super::picture_clicked;string ls_service

ls_service = datalist.get_preference("PREFERENCES", "portrait_service")
if isnull(ls_service) then ls_service = "PORTRAIT"

service_list.do_service(current_patient.cpr_id,current_patient.open_encounter_id,ls_service)

display_portrait()

end event

type st_portrait from statictext within w_cpr_main
integer x = 1138
integer y = 16
integer width = 347
integer height = 304
integer textsize = -12
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "Portrait"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_service

ls_service = datalist.get_preference("PREFERENCES", "portrait_service")
if isnull(ls_service) then ls_service = "PORTRAIT"

service_list.do_service(current_patient.cpr_id,current_patient.open_encounter_id,ls_service)

display_portrait()

end event

type st_property_title_1 from statictext within w_cpr_main
integer x = 27
integer y = 12
integer width = 311
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "Property 1"
alignment alignment = right!
boolean focusrectangle = false
end type

event clicked;//str_attributes lstr_attributes
//
//
//lstr_attributes.attribute_count = 0
//
//lstr_attributes.attribute_count += 1
//lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = "chart_id"
//lstr_attributes.attribute[lstr_attributes.attribute_count].value = string(tab_cpr.chart_id)
//
//openwithparm(w_attributes_display, lstr_attributes)
//
//
pb_epro_help.event trigger clicked()

end event

type st_halt from statictext within w_cpr_main
integer x = 23
integer y = 16
integer width = 146
integer height = 80
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 7191717
alignment alignment = right!
boolean focusrectangle = false
end type

event clicked;str_attributes lstr_attributes


lstr_attributes.attribute_count = 0

lstr_attributes.attribute_count += 1
lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = "chart_id"
lstr_attributes.attribute[lstr_attributes.attribute_count].value = string(tab_cpr.chart_id)

openwithparm(w_attributes_display, lstr_attributes)


end event

type st_1 from statictext within w_cpr_main
integer x = 9
integer y = 20
integer width = 338
integer height = 300
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean focusrectangle = false
end type

event clicked;pb_epro_help.event trigger clicked()

end event

