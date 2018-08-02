$PBExportHeader$w_svc_history_yesno.srw
forward
global type w_svc_history_yesno from w_window_base
end type
type st_page from statictext within w_svc_history_yesno
end type
type pb_up from picturebutton within w_svc_history_yesno
end type
type pb_down from picturebutton within w_svc_history_yesno
end type
type dw_observations from u_dw_observations_pick_results within w_svc_history_yesno
end type
type cb_set_all_col_1 from commandbutton within w_svc_history_yesno
end type
type cb_done from commandbutton within w_svc_history_yesno
end type
type cb_be_back from commandbutton within w_svc_history_yesno
end type
type st_title from statictext within w_svc_history_yesno
end type
type cb_set_all_col_2 from commandbutton within w_svc_history_yesno
end type
end forward

global type w_svc_history_yesno from w_window_base
integer height = 1840
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string button_type = "COMMAND"
st_page st_page
pb_up pb_up
pb_down pb_down
dw_observations dw_observations
cb_set_all_col_1 cb_set_all_col_1
cb_done cb_done
cb_be_back cb_be_back
st_title st_title
cb_set_all_col_2 cb_set_all_col_2
end type
global w_svc_history_yesno w_svc_history_yesno

type variables
u_component_service service
string observation_id


end variables

on w_svc_history_yesno.create
int iCurrent
call super::create
this.st_page=create st_page
this.pb_up=create pb_up
this.pb_down=create pb_down
this.dw_observations=create dw_observations
this.cb_set_all_col_1=create cb_set_all_col_1
this.cb_done=create cb_done
this.cb_be_back=create cb_be_back
this.st_title=create st_title
this.cb_set_all_col_2=create cb_set_all_col_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_page
this.Control[iCurrent+2]=this.pb_up
this.Control[iCurrent+3]=this.pb_down
this.Control[iCurrent+4]=this.dw_observations
this.Control[iCurrent+5]=this.cb_set_all_col_1
this.Control[iCurrent+6]=this.cb_done
this.Control[iCurrent+7]=this.cb_be_back
this.Control[iCurrent+8]=this.st_title
this.Control[iCurrent+9]=this.cb_set_all_col_2
end on

on w_svc_history_yesno.destroy
call super::destroy
destroy(this.st_page)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.dw_observations)
destroy(this.cb_set_all_col_1)
destroy(this.cb_done)
destroy(this.cb_be_back)
destroy(this.st_title)
destroy(this.cb_set_all_col_2)
end on

event open;call super::open;long ll_menu_id
integer li_count
string ls_dataobject
integer li_sts
long ll_left
long ll_right
string ls_result_type
str_popup_return popup_return
long ll_observation_sequence

popup_return.item_count = 1
popup_return.items[1] = "ERROR"

service = message.powerobjectparm

title = current_patient.id_line()

observation_id = service.root_observation_id()
if isnull(observation_id) then
	log.log(this, "w_svc_history_yesno.open.0020", "No observation_id", 4)
	closewithreturn(this, popup_return)
	return
end if

ll_observation_sequence = service.get_root_observation()

st_title.text = datalist.observation_description(observation_id)

ls_result_type = service.get_attribute("result_type")
if isnull(ls_result_type) then ls_result_type = "PERFORM"

li_sts = dw_observations.initialize(service)
if li_sts = 0 then
	log.log(this, "w_svc_history_yesno.open.0020", "No observations to display (" + observation_id + ")", 4)
	closewithreturn(this, popup_return)
	return
elseif li_sts < 0 then
	log.log(this, "w_svc_history_yesno.open.0020", "Error initializing observations (" + observation_id + ")", 4)
	closewithreturn(this, popup_return)
	return
end if

dw_observations.last_page = 0
dw_observations.set_page(1, pb_up, pb_down, st_page)


cb_set_all_col_1.x = dw_observations.x + long(dw_observations.object.result1.x)
cb_set_all_col_1.width = long(dw_observations.object.result1.width)

cb_set_all_col_2.x = dw_observations.x + long(dw_observations.object.result2.x)
cb_set_all_col_2.width = long(dw_observations.object.result2.width)

if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 4
else
	cb_be_back.visible = true
	max_buttons = 3
end if

state_attributes.attribute_count = 0
f_attribute_add_attribute(state_attributes, "observation_sequence", string(ll_observation_sequence))
f_attribute_add_attribute(state_attributes, "treatment_id", string(service.treatment_id))
f_attribute_add_attribute(state_attributes, "observation_id", observation_id)

ll_menu_id = long(service.get_attribute("menu_id"))
paint_menu(ll_menu_id)



end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_history_yesno
boolean visible = true
integer x = 18
integer y = 1456
boolean originalsize = false
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_history_yesno
integer x = 32
integer y = 1552
end type

type st_page from statictext within w_svc_history_yesno
integer x = 2363
integer y = 1444
integer width = 215
integer height = 56
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "99 of 99"
alignment alignment = right!
boolean focusrectangle = false
end type

type pb_up from picturebutton within w_svc_history_yesno
integer x = 2587
integer y = 1444
integer width = 137
integer height = 116
integer taborder = 20
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

li_page = dw_observations.current_page

dw_observations.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from picturebutton within w_svc_history_yesno
integer x = 2738
integer y = 1444
integer width = 137
integer height = 116
integer taborder = 50
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

li_page = dw_observations.current_page
li_last_page = dw_observations.last_page

dw_observations.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type dw_observations from u_dw_observations_pick_results within w_svc_history_yesno
integer x = 14
integer y = 148
integer width = 2885
integer height = 1284
integer taborder = 10
boolean bringtotop = true
boolean vscrollbar = true
boolean border = false
end type

type cb_set_all_col_1 from commandbutton within w_svc_history_yesno
integer x = 1193
integer y = 1464
integer width = 366
integer height = 96
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Set All"
end type

event clicked;integer li_sts

li_sts = dw_observations.set_all_rows(1)

return 

end event

type cb_done from commandbutton within w_svc_history_yesno
integer x = 2427
integer y = 1620
integer width = 443
integer height = 108
integer taborder = 150
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
integer li_sts

li_sts = dw_observations.save_results()
if li_sts < 0 then return

popup_return.item_count = 1
popup_return.items[1] = "COMPLETE"

closewithreturn(parent, popup_return)


end event

type cb_be_back from commandbutton within w_svc_history_yesno
integer x = 1961
integer y = 1620
integer width = 443
integer height = 108
integer taborder = 160
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
integer li_sts

li_sts = dw_observations.save_results()
if li_sts < 0 then return

popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type st_title from statictext within w_svc_history_yesno
integer width = 2917
integer height = 120
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "History Display"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_set_all_col_2 from commandbutton within w_svc_history_yesno
integer x = 1586
integer y = 1464
integer width = 366
integer height = 96
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Set All"
end type

event clicked;integer li_sts

li_sts = dw_observations.set_all_rows(2)

return 

end event

