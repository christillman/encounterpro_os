$PBExportHeader$w_svc_patient_service_list.srw
forward
global type w_svc_patient_service_list from w_window_base
end type
type cb_be_back from commandbutton within w_svc_patient_service_list
end type
type st_waiting_title from statictext within w_svc_patient_service_list
end type
type st_encounter_description from statictext within w_svc_patient_service_list
end type
type dw_patients_waiting from u_dw_pick_list within w_svc_patient_service_list
end type
type dw_services from u_dw_pick_list within w_svc_patient_service_list
end type
type st_fpage from statictext within w_svc_patient_service_list
end type
type pb_fup from picturebutton within w_svc_patient_service_list
end type
type pb_fdown from picturebutton within w_svc_patient_service_list
end type
type cb_refresh from commandbutton within w_svc_patient_service_list
end type
type cb_done from commandbutton within w_svc_patient_service_list
end type
type st_services_title from statictext within w_svc_patient_service_list
end type
type st_waiting_info from statictext within w_svc_patient_service_list
end type
type st_no_patients from statictext within w_svc_patient_service_list
end type
end forward

global type w_svc_patient_service_list from w_window_base
string title = "Patients Waiting"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean auto_resize_window = false
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
cb_be_back cb_be_back
st_waiting_title st_waiting_title
st_encounter_description st_encounter_description
dw_patients_waiting dw_patients_waiting
dw_services dw_services
st_fpage st_fpage
pb_fup pb_fup
pb_fdown pb_fdown
cb_refresh cb_refresh
cb_done cb_done
st_services_title st_services_title
st_waiting_info st_waiting_info
st_no_patients st_no_patients
end type
global w_svc_patient_service_list w_svc_patient_service_list

type variables
u_component_service service

string service_office_id

string services

string this_room_id


end variables

forward prototypes
public function integer load_services ()
public function integer do_services ()
end prototypes

public function integer load_services ();string lsa_services[]
integer li_service_count
string ls_description
integer i
long ll_row

dw_services.reset()

li_service_count = f_parse_string(services, "|", lsa_services)
for i = 1 to li_service_count
	ls_description = datalist.service_description(lsa_services[i])
	if not isnull(ls_description) then
		// found a valid service
		ll_row = dw_services.insertrow(0)
		dw_services.object.service[ll_row] = lsa_services[i]
		dw_services.object.description[ll_row] = ls_description
	end if
next

dw_services.set_page(1, pb_fup, pb_fdown, st_fpage)

return dw_services.rowcount()




end function

public function integer do_services ();Integer				li_sts
Long					ll_encounter_id
long					ll_patient_workplan_item_id
String				ls_cpr_id
u_component_service			luo_service
long ll_row
string ls_message
long ll_count
long lla_selected_row[]
long i

ll_count = 0

ll_row = dw_patients_waiting.get_selected_row()
DO WHILE ll_row > 0
	ll_count += 1
	lla_selected_row[ll_count] = ll_row
	ll_row = dw_patients_waiting.get_selected_row(ll_row)
LOOP


for i = 1 to ll_count
	ll_row = lla_selected_row[i]
	ls_cpr_id = dw_patients_waiting.object.cpr_id[ll_row]
	ll_encounter_id = dw_patients_waiting.object.encounter_id[ll_row]
	ll_patient_workplan_item_id = dw_patients_waiting.object.patient_workplan_item_id[ll_row]

	luo_service = service_list.get_service_component(ll_patient_workplan_item_id)
 	If isnull(luo_service) Then
		log.log(This, "w_svc_patient_service_list.do_services.0030", "Error Getting Service (" + string(ll_patient_workplan_item_id) + ")", 4)
		Return -1
	End If

	// Suppress autoperform if there's more than one service selected
	if ll_count > 1 then
		luo_service.do_autoperform = false
	end if

	li_sts = luo_service.do_service(ll_patient_workplan_item_id)
	
	component_manager.destroy_component(luo_service)

	if not isnull(this_room_id) then
		sqlca.sp_change_room(ls_cpr_id, ll_encounter_id, this_room_id)
		if not tf_check() then return -1
	end if
next	

return 1

end function

on w_svc_patient_service_list.create
int iCurrent
call super::create
this.cb_be_back=create cb_be_back
this.st_waiting_title=create st_waiting_title
this.st_encounter_description=create st_encounter_description
this.dw_patients_waiting=create dw_patients_waiting
this.dw_services=create dw_services
this.st_fpage=create st_fpage
this.pb_fup=create pb_fup
this.pb_fdown=create pb_fdown
this.cb_refresh=create cb_refresh
this.cb_done=create cb_done
this.st_services_title=create st_services_title
this.st_waiting_info=create st_waiting_info
this.st_no_patients=create st_no_patients
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_be_back
this.Control[iCurrent+2]=this.st_waiting_title
this.Control[iCurrent+3]=this.st_encounter_description
this.Control[iCurrent+4]=this.dw_patients_waiting
this.Control[iCurrent+5]=this.dw_services
this.Control[iCurrent+6]=this.st_fpage
this.Control[iCurrent+7]=this.pb_fup
this.Control[iCurrent+8]=this.pb_fdown
this.Control[iCurrent+9]=this.cb_refresh
this.Control[iCurrent+10]=this.cb_done
this.Control[iCurrent+11]=this.st_services_title
this.Control[iCurrent+12]=this.st_waiting_info
this.Control[iCurrent+13]=this.st_no_patients
end on

on w_svc_patient_service_list.destroy
call super::destroy
destroy(this.cb_be_back)
destroy(this.st_waiting_title)
destroy(this.st_encounter_description)
destroy(this.dw_patients_waiting)
destroy(this.dw_services)
destroy(this.st_fpage)
destroy(this.pb_fup)
destroy(this.pb_fdown)
destroy(this.cb_refresh)
destroy(this.cb_done)
destroy(this.st_services_title)
destroy(this.st_waiting_info)
destroy(this.st_no_patients)
end on

event open;call super::open;str_popup_return popup_return
long ll_menu_id
str_encounter_description lstr_encounter
integer li_sts
long ll_xmove

popup_return.item_count = 1
popup_return.items[1] = "ERROR"

service = message.powerobjectparm

service_office_id = service.get_attribute("service_office_id")
if isnull(service_office_id) then service_office_id = office_id

services = service.get_attribute("service_list")
if isnull(services) then services = "GET_PATIENT"

this_room_id = service.get_attribute("this_room_id")

// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 4
end if

ll_menu_id = long(service.get_attribute("menu_id"))
paint_menu(ll_menu_id)


li_sts = load_services()
if li_sts <= 0 then
	log.log(this, "w_svc_patient_service_list.open.0032", "Error loading service", 4)
	closewithreturn(this, popup_return)
	return
elseif li_sts = 1 then
	dw_services.visible = false
	pb_fdown.visible = false
	pb_fup.visible = false
	st_fpage.visible = false
	st_services_title.visible = false
	
	ll_xmove = dw_patients_waiting.x - ((width - dw_patients_waiting.width) / 2)
	dw_patients_waiting.x -= ll_xmove
	st_waiting_info.x -= ll_xmove
	st_waiting_title.x -= ll_xmove
	cb_refresh.x -= ll_xmove
	st_no_patients.x -= ll_xmove
end if

dw_patients_waiting.object.compute_patient.width = dw_patients_waiting.width - 100
center_popup()

dw_services.object.selected_flag[1] = 1
dw_services.event POST selected(1)

dw_patients_waiting.settransobject(sqlca)

end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_patient_service_list
integer x = 2848
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_patient_service_list
end type

type cb_be_back from commandbutton within w_svc_patient_service_list
integer x = 1961
integer y = 1612
integer width = 443
integer height = 108
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type st_waiting_title from statictext within w_svc_patient_service_list
integer x = 1266
integer y = 188
integer width = 1408
integer height = 152
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Patients Waiting on Service"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_encounter_description from statictext within w_svc_patient_service_list
integer width = 2921
integer height = 120
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Patients Waiting"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_patients_waiting from u_dw_pick_list within w_svc_patient_service_list
integer x = 1257
integer y = 336
integer width = 1408
integer height = 1096
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_sp_get_patients_waiting_on_services"
boolean vscrollbar = true
boolean border = false
boolean multiselect = true
end type

event selected;call super::selected;long ll_patient_workplan_item_id

ll_patient_workplan_item_id = object.patient_workplan_item_id[selected_row]


end event

type dw_services from u_dw_pick_list within w_svc_patient_service_list
integer x = 110
integer y = 336
integer width = 919
integer height = 972
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_service_list_generic"
boolean border = false
boolean hsplitscroll = true
end type

event selected;call super::selected;long ll_count
string ls_service
string ls_description

ls_service = object.service[selected_row]
ls_description = object.description[selected_row]
ll_count = dw_patients_waiting.retrieve(service_office_id, ls_service)

if ll_count > 0 then
	st_no_patients.visible = false
else
	st_no_patients.visible = true
end if

st_waiting_title.text = "Patients Waiting on ~"" + ls_description + "~" Service"


end event

type st_fpage from statictext within w_svc_patient_service_list
integer x = 1047
integer y = 596
integer width = 146
integer height = 104
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99/99"
boolean focusrectangle = false
end type

type pb_fup from picturebutton within w_svc_patient_service_list
integer x = 1042
integer y = 340
integer width = 137
integer height = 116
integer taborder = 80
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;integer li_page

li_page = dw_services.current_page

dw_services.set_page(li_page - 1, st_fpage.text)

if li_page <= 2 then enabled = false
pb_fdown.enabled = true

end event

type pb_fdown from picturebutton within w_svc_patient_service_list
integer x = 1042
integer y = 472
integer width = 137
integer height = 116
integer taborder = 90
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_services.current_page
li_last_page = dw_services.last_page

dw_services.set_page(li_page + 1, st_fpage.text)

if li_page >= li_last_page - 1 then enabled = false
pb_fup.enabled = true

end event

type cb_refresh from commandbutton within w_svc_patient_service_list
integer x = 2674
integer y = 764
integer width = 210
integer height = 96
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Refresh"
end type

event clicked;long ll_row
string ls_service

ll_row = dw_services.get_selected_row()
if ll_row <= 0 then return

dw_services.event POST selected(ll_row)


end event

type cb_done from commandbutton within w_svc_patient_service_list
integer x = 2423
integer y = 1612
integer width = 443
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
boolean default = true
end type

event clicked;str_popup_return popup_return
integer li_sts

if isvalid(main_window) and not isnull(main_window) then main_window.setfocus()
parent.visible = false

li_sts = do_services()
if li_sts < 0 then
	parent.visible = true
	return
end if

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)



end event

type st_services_title from statictext within w_svc_patient_service_list
integer x = 123
integer y = 188
integer width = 905
integer height = 84
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Service"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_waiting_info from statictext within w_svc_patient_service_list
integer x = 1257
integer y = 1444
integer width = 1408
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Highlight Patients and Click Finished to Perform"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_no_patients from statictext within w_svc_patient_service_list
boolean visible = false
integer x = 1367
integer y = 552
integer width = 1189
integer height = 184
boolean bringtotop = true
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "No Patients"
alignment alignment = center!
boolean focusrectangle = false
end type

