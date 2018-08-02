$PBExportHeader$w_svc_show_actor.srw
forward
global type w_svc_show_actor from w_window_base
end type
type cb_finished from commandbutton within w_svc_show_actor
end type
type dw_actor from u_dw_pick_list within w_svc_show_actor
end type
type dw_address from u_dw_pick_list within w_svc_show_actor
end type
type dw_communication from u_dw_pick_list within w_svc_show_actor
end type
type pb_down from u_picture_button within w_svc_show_actor
end type
type pb_up from u_picture_button within w_svc_show_actor
end type
type st_page from statictext within w_svc_show_actor
end type
type pb_up2 from u_picture_button within w_svc_show_actor
end type
type pb_down2 from u_picture_button within w_svc_show_actor
end type
type st_page2 from statictext within w_svc_show_actor
end type
end forward

global type w_svc_show_actor from w_window_base
integer x = 599
integer y = 252
integer width = 1714
integer height = 1388
string title = "EncounterPRO Actor Profile"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = 12632256
cb_finished cb_finished
dw_actor dw_actor
dw_address dw_address
dw_communication dw_communication
pb_down pb_down
pb_up pb_up
st_page st_page
pb_up2 pb_up2
pb_down2 pb_down2
st_page2 st_page2
end type
global w_svc_show_actor w_svc_show_actor

type variables
u_component_service service
string user_id
string actor_class
long actor_id

end variables

on w_svc_show_actor.create
int iCurrent
call super::create
this.cb_finished=create cb_finished
this.dw_actor=create dw_actor
this.dw_address=create dw_address
this.dw_communication=create dw_communication
this.pb_down=create pb_down
this.pb_up=create pb_up
this.st_page=create st_page
this.pb_up2=create pb_up2
this.pb_down2=create pb_down2
this.st_page2=create st_page2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_finished
this.Control[iCurrent+2]=this.dw_actor
this.Control[iCurrent+3]=this.dw_address
this.Control[iCurrent+4]=this.dw_communication
this.Control[iCurrent+5]=this.pb_down
this.Control[iCurrent+6]=this.pb_up
this.Control[iCurrent+7]=this.st_page
this.Control[iCurrent+8]=this.pb_up2
this.Control[iCurrent+9]=this.pb_down2
this.Control[iCurrent+10]=this.st_page2
end on

on w_svc_show_actor.destroy
call super::destroy
destroy(this.cb_finished)
destroy(this.dw_actor)
destroy(this.dw_address)
destroy(this.dw_communication)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.st_page)
destroy(this.pb_up2)
destroy(this.pb_down2)
destroy(this.st_page2)
end on

event open;str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "ERROR"

service = message.powerobjectparm


user_id = service.get_attribute("user_id")
if isnull(user_id) then
	log.log(this, "w_svc_show_actor.open.0011", "No user_id", 4)
	closewithreturn(this, popup_return)
	return
end if


SELECT actor_id, actor_class
INTO :actor_id, :actor_class
FROM c_User
WHERE user_id = :user_id;
if not tf_check() then
	log.log(this, "w_svc_show_actor.open.0011", "Error getting actor", 4)
	closewithreturn(this, popup_return)
	return
end if
if sqlca.sqlcode = 100 then
	log.log(this, "w_svc_show_actor.open.0011", "Actor not found (" + user_id + ")", 4)
	closewithreturn(this, popup_return)
	return
end if

CHOOSE CASE lower(actor_class)
	CASE "organization"
		dw_actor.dataobject = "dw_actor_organization"
	CASE "informationsystem"
		dw_actor.dataobject = "dw_actor_information_system"
	CASE ELSE
		dw_actor.dataobject = "dw_actor_person"
END CHOOSE

dw_actor.settransobject(sqlca)
dw_actor.retrieve(user_id)


dw_address.settransobject(sqlca)
dw_address.retrieve(actor_id)
dw_address.set_page(1, pb_up, pb_down, st_page)

dw_communication.settransobject(sqlca)
dw_communication.retrieve(actor_id)
dw_communication.set_page(1, pb_up2, pb_down2, st_page2)





end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_show_actor
integer x = 46
integer y = 1156
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_show_actor
end type

type cb_finished from commandbutton within w_svc_show_actor
integer x = 1271
integer y = 1152
integer width = 402
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type dw_actor from u_dw_pick_list within w_svc_show_actor
integer width = 1714
integer height = 352
integer taborder = 11
string title = "EncounterPRO Actor Profile"
string dataobject = "dw_actor_organization"
boolean border = false
end type

type dw_address from u_dw_pick_list within w_svc_show_actor
integer x = 219
integer y = 376
integer width = 1243
integer height = 352
integer taborder = 21
boolean bringtotop = true
string dataobject = "dw_actor_address"
end type

type dw_communication from u_dw_pick_list within w_svc_show_actor
integer x = 219
integer y = 756
integer width = 1243
integer height = 252
integer taborder = 31
boolean bringtotop = true
string dataobject = "dw_actor_communication"
end type

type pb_down from u_picture_button within w_svc_show_actor
integer x = 1477
integer y = 500
integer width = 137
integer height = 116
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_address.current_page
li_last_page = dw_address.last_page

dw_address.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true


end event

type pb_up from u_picture_button within w_svc_show_actor
integer x = 1477
integer y = 376
integer width = 137
integer height = 116
integer taborder = 20
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_address.current_page

dw_address.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type st_page from statictext within w_svc_show_actor
integer x = 1481
integer y = 632
integer width = 146
integer height = 124
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Page 99/99"
boolean focusrectangle = false
end type

type pb_up2 from u_picture_button within w_svc_show_actor
integer x = 1477
integer y = 760
integer width = 137
integer height = 116
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_communication.current_page

dw_communication.set_page(li_page - 1, st_page2.text)

if li_page <= 2 then enabled = false
pb_down2.enabled = true

end event

type pb_down2 from u_picture_button within w_svc_show_actor
integer x = 1477
integer y = 884
integer width = 137
integer height = 116
integer taborder = 40
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_communication.current_page
li_last_page = dw_communication.last_page

dw_communication.set_page(li_page + 1, st_page2.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up2.enabled = true


end event

type st_page2 from statictext within w_svc_show_actor
integer x = 1477
integer y = 1008
integer width = 146
integer height = 124
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Page 99/99"
boolean focusrectangle = false
end type

