HA$PBExportHeader$w_svc_wait.srw
forward
global type w_svc_wait from w_window_base
end type
type cb_be_back from commandbutton within w_svc_wait
end type
type st_title from statictext within w_svc_wait
end type
type cb_done from commandbutton within w_svc_wait
end type
type st_1 from statictext within w_svc_wait
end type
type st_event_title from statictext within w_svc_wait
end type
type st_event from statictext within w_svc_wait
end type
type cb_view from commandbutton within w_svc_wait
end type
type st_context_title from statictext within w_svc_wait
end type
type st_context from statictext within w_svc_wait
end type
end forward

global type w_svc_wait from w_window_base
string title = "Patients Waiting"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
integer max_buttons = 4
cb_be_back cb_be_back
st_title st_title
cb_done cb_done
st_1 st_1
st_event_title st_event_title
st_event st_event
cb_view cb_view
st_context_title st_context_title
st_context st_context
end type
global w_svc_wait w_svc_wait

type variables
u_component_service service

string service_office_id

string services

string this_room_id


end variables

on w_svc_wait.create
int iCurrent
call super::create
this.cb_be_back=create cb_be_back
this.st_title=create st_title
this.cb_done=create cb_done
this.st_1=create st_1
this.st_event_title=create st_event_title
this.st_event=create st_event
this.cb_view=create cb_view
this.st_context_title=create st_context_title
this.st_context=create st_context
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_be_back
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.cb_done
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_event_title
this.Control[iCurrent+6]=this.st_event
this.Control[iCurrent+7]=this.cb_view
this.Control[iCurrent+8]=this.st_context_title
this.Control[iCurrent+9]=this.st_context
end on

on w_svc_wait.destroy
call super::destroy
destroy(this.cb_be_back)
destroy(this.st_title)
destroy(this.cb_done)
destroy(this.st_1)
destroy(this.st_event_title)
destroy(this.st_event)
destroy(this.cb_view)
destroy(this.st_context_title)
destroy(this.st_context)
end on

event open;call super::open;str_popup_return popup_return
long ll_menu_id
integer li_sts
string ls_event_type
string ls_event_key
string ls_wait_progress_key

popup_return.item_count = 1
popup_return.items[1] = "ERROR"

service = message.powerobjectparm

st_title.text = service.description

if lower(service.context_object) = "general" then
	cb_view.visible = false
else
	cb_view.text = "View " + wordcap(service.context_object)
end if

st_context.text = service.context_description

ll_menu_id = long(service.get_attribute("menu_id"))
paint_menu(ll_menu_id)



ls_event_type = service.get_attribute("event_type")
if isnull(ls_event_type) then ls_event_type = "Wait For"

CHOOSE CASE upper(ls_event_type)
	CASE "WAIT FOR"
		ls_event_key = service.get_attribute("wait_interval")
		if isnull(ls_event_key) then ls_event_key = "1 Minute"
	CASE "WAIT UNTIL"
		ls_event_key = service.get_attribute("wait_until_time")
		if isnull(ls_event_key) then ls_event_key = "12 Midnight"
	CASE "PROGRESS"
		ls_event_key = service.get_attribute("wait_progress_type")
		ls_wait_progress_key = service.get_attribute("wait_progress_key")
		if len(ls_wait_progress_key) > 0 then
			ls_event_key += " " + ls_wait_progress_key
		end if
END CHOOSE


st_event.text = wordcap(ls_event_type) + " " + wordcap(ls_event_key)


end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_wait
boolean visible = true
integer x = 2665
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_wait
end type

type cb_be_back from commandbutton within w_svc_wait
integer x = 2345
integer y = 1604
integer width = 521
integer height = 108
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Keep Waiting"
boolean default = true
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type st_title from statictext within w_svc_wait
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
string text = "Wait for ..."
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_done from commandbutton within w_svc_wait
integer x = 759
integer y = 1180
integer width = 1403
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Stop Waiting and Order Next Workplan Step"
boolean default = true
end type

event clicked;str_popup_return popup_return
integer li_sts

openwithparm(w_pop_yes_no, "Are you sure you want to complete this service now?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)



end event

type st_1 from statictext within w_svc_wait
integer x = 453
integer y = 240
integer width = 2011
integer height = 200
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "This service is waiting for the following event at which time it will complete itself automatically"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_event_title from statictext within w_svc_wait
integer x = 347
integer y = 508
integer width = 283
integer height = 88
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Event:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_event from statictext within w_svc_wait
integer x = 635
integer y = 500
integer width = 1669
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Results Posted"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type cb_view from commandbutton within w_svc_wait
integer x = 2290
integer y = 836
integer width = 567
integer height = 108
integer taborder = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "View Assessment"
boolean default = true
end type

event clicked;str_popup_return popup_return
integer li_sts

popup_return.item_count = 1
popup_return.items[1] = "CANCEL"

closewithreturn(parent, popup_return)



end event

type st_context_title from statictext within w_svc_wait
integer x = 82
integer y = 748
integer width = 320
integer height = 88
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Context:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_context from statictext within w_svc_wait
integer x = 402
integer y = 740
integer width = 1874
integer height = 204
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

