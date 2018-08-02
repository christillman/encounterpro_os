$PBExportHeader$w_chart_alert.srw
forward
global type w_chart_alert from w_window_base
end type
type st_title from statictext within w_chart_alert
end type
type dw_alerts from u_dw_pick_list within w_chart_alert
end type
type cb_ok from commandbutton within w_chart_alert
end type
type cb_new_alert from commandbutton within w_chart_alert
end type
type cb_1 from commandbutton within w_chart_alert
end type
end forward

global type w_chart_alert from w_window_base
integer x = 283
integer y = 112
integer width = 2921
integer height = 1500
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_title st_title
dw_alerts dw_alerts
cb_ok cb_ok
cb_new_alert cb_new_alert
cb_1 cb_1
end type
global w_chart_alert w_chart_alert

type variables
string cpr_id
long encounter_id
string alert_mode
string alert_category_id

u_component_service service
end variables

forward prototypes
public subroutine alert_menu (long pl_row)
public function integer set_alert_status (long pl_alert_id, string ps_status)
end prototypes

public subroutine alert_menu (long pl_row);str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
long ll_alert_id
string ls_alert_category_id

ls_alert_category_id = lower(dw_alerts.object.alert_category_id[pl_row])


if ls_alert_category_id = "alert" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Remove Chart Alert"
	popup.button_titles[popup.button_count] = "Remove Alert"
	buttons[popup.button_count] = "DELETEALERT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	button_pressed = message.doubleparm
	if button_pressed < 1 or button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if

CHOOSE CASE buttons[button_pressed]
	CASE "DELETEALERT"
		openwithparm(w_pop_yes_no, "Are you sure you want to remove this alert?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		
		ll_alert_id = dw_alerts.object.alert_id[pl_row]
		li_sts = set_alert_status(ll_alert_id, "CLOSED")

		dw_alerts.retrieve(cpr_id)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return


end subroutine

public function integer set_alert_status (long pl_alert_id, string ps_status);		
INSERT INTO p_Chart_Alert_Progress  
         ( cpr_id,   
           alert_id,   
           encounter_id,   
           user_id,   				//current_user.user_id //application global variable
           progress_type,  		//"CLOSE" 
           created_by )  			//current_scribe.user_id //application global variable
VALUES ( :cpr_id,   
           :pl_alert_id,   
           :encounter_id,   
           :current_user.user_id,   
           :ps_status,   
           :current_scribe.user_id) ;
			  
if not tf_check() then return -1
			  

return 1


end function

on w_chart_alert.create
int iCurrent
call super::create
this.st_title=create st_title
this.dw_alerts=create dw_alerts
this.cb_ok=create cb_ok
this.cb_new_alert=create cb_new_alert
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.dw_alerts
this.Control[iCurrent+3]=this.cb_ok
this.Control[iCurrent+4]=this.cb_new_alert
this.Control[iCurrent+5]=this.cb_1
end on

on w_chart_alert.destroy
call super::destroy
destroy(this.st_title)
destroy(this.dw_alerts)
destroy(this.cb_ok)
destroy(this.cb_new_alert)
destroy(this.cb_1)
end on

event open;call super::open;//Chuck Webster, 07-28-99

str_popup popup

popup = message.powerobjectparm

cpr_id = popup.items[1]
encounter_id = long(popup.items[2])
alert_mode = popup.items[3]

//can only add new alerts in context of an encounter
//if isnull(encounter_id) then pb_new.enabled = false

dw_alerts.settransobject(sqlca)



CHOOSE CASE alert_mode
	CASE "ALERT"
		alert_category_id = "ALERT"
		st_title.text = "Chart Alerts / Reminders"
		dw_alerts.retrieve(cpr_id)
		//only popup alert window if there are alerts or reminders to show
		if dw_alerts.rowcount() = 0 then
			close(this)
			return
		end if
	CASE "EDITALERTS"
		alert_category_id = "ALERT"
		st_title.text = "Chart Alerts / Reminders"
		dw_alerts.retrieve(cpr_id)
	CASE "NOTE"
		alert_category_id = "NOTE"
		st_title.text = "Chart Notes"
		dw_alerts.retrieve(cpr_id)
		dw_alerts.setfilter("ordered_for='" + current_user.user_id + "'")
		dw_alerts.filter()
		//only popup note window if there are notes to show
		if dw_alerts.rowcount() = 0 then
			close(this)
			return
		end if
		cb_new_alert.visible = false
	CASE ELSE
		log.log(this, "w_chart_alert.open.0045", "Invalid alert mode (" + alert_mode + ")", 4)
		close(this)
		return
END CHOOSE



end event

type pb_epro_help from w_window_base`pb_epro_help within w_chart_alert
integer x = 2853
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_chart_alert
end type

type st_title from statictext within w_chart_alert
integer width = 2921
integer height = 136
boolean bringtotop = true
integer textsize = -24
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Chart Alerts"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_alerts from u_dw_pick_list within w_chart_alert
integer x = 14
integer y = 152
integer width = 2866
integer height = 1160
integer taborder = 30
string dataobject = "dw_alert_display_grid"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event post_click;call super::post_click;string ls_alert_category_id

ls_alert_category_id = lower(dw_alerts.object.alert_category_id[clicked_row])

if ls_alert_category_id = "alert" then
	alert_menu(lastrow)
end if

clear_selected()

end event

event buttonclicked;call super::buttonclicked;string ls_button
long ll_alert_id
integer li_sts
long ll_count

ls_button = dwo.name

if lower(dwo.name) = "b_dismiss" then
	ll_alert_id = object.alert_id[row]
	li_sts = set_alert_status(ll_alert_id, "CLOSED")
	ll_count = dw_alerts.retrieve(cpr_id)
end if

return

end event

type cb_ok from commandbutton within w_chart_alert
integer x = 2418
integer y = 1344
integer width = 462
integer height = 120
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;integer i
long ll_alert_id

CHOOSE CASE alert_mode
	CASE "ALERT"
	CASE "EDITALERTS"
	CASE "NOTE"
		for i = 1 to dw_alerts.rowcount()
			ll_alert_id = dw_alerts.object.alert_id[i]
			set_alert_status(ll_alert_id, "READ")
		next
END CHOOSE


close(parent)


end event

type cb_new_alert from commandbutton within w_chart_alert
integer x = 18
integer y = 1344
integer width = 462
integer height = 120
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Alert"
end type

event clicked;//Chuck Webster, 07-28-99

//create a new alert

str_popup popup
str_popup_return popup_return
long ll_row

popup.title = "Enter New Alert"
popup.item = ""
openwithparm(w_pop_prompt_string_multiline, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return
ll_row = dw_alerts.insertrow(1)
dw_alerts.object.cpr_id[ll_row] = cpr_id
dw_alerts.object.open_encounter_id[ll_row] = encounter_id
dw_alerts.object.ordered_by[ll_row] = current_user.user_id

dw_alerts.object.user_short_name[ll_row] = current_user.user_short_name

dw_alerts.object.created_by[ll_row] = current_scribe.user_id
dw_alerts.object.begin_date[ll_row] = datetime(today(), now())
dw_alerts.object.created[ll_row] = datetime(today(), now())
dw_alerts.object.alert_text[ll_row] = popup_return.items[1]
dw_alerts.object.alert_category_id[ll_row] = "Alert"
dw_alerts.update()

dw_alerts.retrieve(cpr_id)
dw_alerts.sort()



end event

type cb_1 from commandbutton within w_chart_alert
integer x = 1216
integer y = 1344
integer width = 485
integer height = 120
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Reminder"
end type

event clicked;//Chuck Webster, 07-28-99

//create a new alert

str_popup popup
str_popup_return popup_return
long ll_row

popup.title = "Enter New Reminder"
popup.item = ""
openwithparm(w_pop_prompt_string_multiline, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return
ll_row = dw_alerts.insertrow(1)
dw_alerts.object.cpr_id[ll_row] = cpr_id
dw_alerts.object.open_encounter_id[ll_row] = encounter_id
dw_alerts.object.ordered_by[ll_row] = current_user.user_id

dw_alerts.object.user_short_name[ll_row] = current_user.user_short_name

dw_alerts.object.created_by[ll_row] = current_scribe.user_id
dw_alerts.object.begin_date[ll_row] = datetime(today(), now())
dw_alerts.object.created[ll_row] = datetime(today(), now())
dw_alerts.object.alert_text[ll_row] = popup_return.items[1]
dw_alerts.object.alert_category_id[ll_row] = "Reminder"
dw_alerts.update()

dw_alerts.retrieve(cpr_id)
dw_alerts.sort()



end event

