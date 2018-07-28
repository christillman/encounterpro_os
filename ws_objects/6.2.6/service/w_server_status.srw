HA$PBExportHeader$w_server_status.srw
forward
global type w_server_status from w_window_base
end type
type cb_finished from commandbutton within w_server_status
end type
type cb_be_back from commandbutton within w_server_status
end type
type st_title from statictext within w_server_status
end type
type dw_server_status from u_dw_pick_list within w_server_status
end type
type pb_up from u_picture_button within w_server_status
end type
type st_page from statictext within w_server_status
end type
type pb_down from u_picture_button within w_server_status
end type
type st_spid_title from statictext within w_server_status
end type
type st_spid from statictext within w_server_status
end type
type st_customer_id_title from statictext within w_server_status
end type
type st_customer_id from statictext within w_server_status
end type
type st_mode_title from statictext within w_server_status
end type
type st_mode from statictext within w_server_status
end type
type st_server_status_title from statictext within w_server_status
end type
type st_master_configuration_date_title from statictext within w_server_status
end type
type st_master_configuration_date from statictext within w_server_status
end type
type st_build_title from statictext within w_server_status
end type
type st_build from statictext within w_server_status
end type
type st_mod_level from statictext within w_server_status
end type
type st_mod_level_title from statictext within w_server_status
end type
type st_db_server_title from statictext within w_server_status
end type
type st_db_server from statictext within w_server_status
end type
type st_db_name_title from statictext within w_server_status
end type
type st_db_name from statictext within w_server_status
end type
end forward

global type w_server_status from w_window_base
integer width = 2935
integer height = 1912
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string button_type = "COMMAND"
integer max_buttons = 3
cb_finished cb_finished
cb_be_back cb_be_back
st_title st_title
dw_server_status dw_server_status
pb_up pb_up
st_page st_page
pb_down pb_down
st_spid_title st_spid_title
st_spid st_spid
st_customer_id_title st_customer_id_title
st_customer_id st_customer_id
st_mode_title st_mode_title
st_mode st_mode
st_server_status_title st_server_status_title
st_master_configuration_date_title st_master_configuration_date_title
st_master_configuration_date st_master_configuration_date
st_build_title st_build_title
st_build st_build
st_mod_level st_mod_level
st_mod_level_title st_mod_level_title
st_db_server_title st_db_server_title
st_db_server st_db_server
st_db_name_title st_db_name_title
st_db_name st_db_name
end type
global w_server_status w_server_status

type variables
u_component_service	service

end variables

on w_server_status.create
int iCurrent
call super::create
this.cb_finished=create cb_finished
this.cb_be_back=create cb_be_back
this.st_title=create st_title
this.dw_server_status=create dw_server_status
this.pb_up=create pb_up
this.st_page=create st_page
this.pb_down=create pb_down
this.st_spid_title=create st_spid_title
this.st_spid=create st_spid
this.st_customer_id_title=create st_customer_id_title
this.st_customer_id=create st_customer_id
this.st_mode_title=create st_mode_title
this.st_mode=create st_mode
this.st_server_status_title=create st_server_status_title
this.st_master_configuration_date_title=create st_master_configuration_date_title
this.st_master_configuration_date=create st_master_configuration_date
this.st_build_title=create st_build_title
this.st_build=create st_build
this.st_mod_level=create st_mod_level
this.st_mod_level_title=create st_mod_level_title
this.st_db_server_title=create st_db_server_title
this.st_db_server=create st_db_server
this.st_db_name_title=create st_db_name_title
this.st_db_name=create st_db_name
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_finished
this.Control[iCurrent+2]=this.cb_be_back
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.dw_server_status
this.Control[iCurrent+5]=this.pb_up
this.Control[iCurrent+6]=this.st_page
this.Control[iCurrent+7]=this.pb_down
this.Control[iCurrent+8]=this.st_spid_title
this.Control[iCurrent+9]=this.st_spid
this.Control[iCurrent+10]=this.st_customer_id_title
this.Control[iCurrent+11]=this.st_customer_id
this.Control[iCurrent+12]=this.st_mode_title
this.Control[iCurrent+13]=this.st_mode
this.Control[iCurrent+14]=this.st_server_status_title
this.Control[iCurrent+15]=this.st_master_configuration_date_title
this.Control[iCurrent+16]=this.st_master_configuration_date
this.Control[iCurrent+17]=this.st_build_title
this.Control[iCurrent+18]=this.st_build
this.Control[iCurrent+19]=this.st_mod_level
this.Control[iCurrent+20]=this.st_mod_level_title
this.Control[iCurrent+21]=this.st_db_server_title
this.Control[iCurrent+22]=this.st_db_server
this.Control[iCurrent+23]=this.st_db_name_title
this.Control[iCurrent+24]=this.st_db_name
end on

on w_server_status.destroy
call super::destroy
destroy(this.cb_finished)
destroy(this.cb_be_back)
destroy(this.st_title)
destroy(this.dw_server_status)
destroy(this.pb_up)
destroy(this.st_page)
destroy(this.pb_down)
destroy(this.st_spid_title)
destroy(this.st_spid)
destroy(this.st_customer_id_title)
destroy(this.st_customer_id)
destroy(this.st_mode_title)
destroy(this.st_mode)
destroy(this.st_server_status_title)
destroy(this.st_master_configuration_date_title)
destroy(this.st_master_configuration_date)
destroy(this.st_build_title)
destroy(this.st_build)
destroy(this.st_mod_level)
destroy(this.st_mod_level_title)
destroy(this.st_db_server_title)
destroy(this.st_db_server)
destroy(this.st_db_name_title)
destroy(this.st_db_name)
end on

event open;call super::open;integer ll_menu_id
integer li_timer_interval
long ll_spid

service = message.powerobjectparm

// Set the title and sizes
If isvalid(current_patient) and not isnull(current_patient) Then
	title = current_patient.id_line()
End If

if len(st_title.text) > 42 then
	if len(st_title.text) > 60 then
		if len(st_title.text) > 70 then
			st_title.textsize = -10
		else
			st_title.textsize = -12
		end if
	else
		st_title.textsize = -14
	end if
else
	st_title.textsize = -18
end if

// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 4
end if

ll_menu_id = long(service.get_attribute("menu_id"))
paint_menu(ll_menu_id)

st_spid.text = string(sqlca.spid)
st_customer_id.text = string(sqlca.customer_id)
st_build.text = f_app_version()
st_mode.text = sqlca.database_mode
st_master_configuration_date.text = string(date(sqlca.master_configuration_date))
st_mod_level.text = string(sqlca.modification_level)

st_db_server.text = sqlca.servername
st_db_name.text = sqlca.database

dw_server_status.settransobject(sqlca)
dw_server_status.retrieve()
dw_server_status.set_page(1, pb_up, pb_down, st_page)

service.get_attribute("timer_interval", li_timer_interval)
if isnull(li_timer_interval) then li_timer_interval = 10

timer(li_timer_interval)


end event

event timer;call super::timer;integer li_page

li_page = dw_server_status.current_page
if isnull(li_page) or li_page <= 0 then li_page = 1

dw_server_status.retrieve()
dw_server_status.set_page(li_page, pb_up, pb_down, st_page)


end event

type pb_epro_help from w_window_base`pb_epro_help within w_server_status
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_server_status
end type

type cb_finished from commandbutton within w_server_status
integer x = 2427
integer y = 1612
integer width = 443
integer height = 108
integer taborder = 20
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

type cb_be_back from commandbutton within w_server_status
integer x = 1961
integer y = 1612
integer width = 443
integer height = 108
integer taborder = 20
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

type st_title from statictext within w_server_status
integer width = 2921
integer height = 120
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Client / Database Status"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_server_status from u_dw_pick_list within w_server_status
integer x = 219
integer y = 584
integer width = 2469
integer height = 952
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_server_status"
end type

type pb_up from u_picture_button within w_server_status
integer x = 2697
integer y = 584
integer width = 137
integer height = 116
integer taborder = 40
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_server_status.current_page

dw_server_status.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type st_page from statictext within w_server_status
integer x = 2459
integer y = 524
integer width = 366
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99/99"
alignment alignment = right!
boolean focusrectangle = false
end type

type pb_down from u_picture_button within w_server_status
integer x = 2697
integer y = 720
integer width = 137
integer height = 116
integer taborder = 50
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_server_status.current_page
li_last_page = dw_server_status.last_page

dw_server_status.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true


end event

type st_spid_title from statictext within w_server_status
integer x = 1975
integer y = 364
integer width = 302
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "My SPID:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_spid from statictext within w_server_status
integer x = 2277
integer y = 356
integer width = 434
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_customer_id_title from statictext within w_server_status
integer x = 32
integer y = 180
integer width = 379
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Customer ID:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_customer_id from statictext within w_server_status
integer x = 421
integer y = 172
integer width = 375
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_mode_title from statictext within w_server_status
integer x = 32
integer y = 272
integer width = 379
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Mode:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_mode from statictext within w_server_status
integer x = 421
integer y = 264
integer width = 375
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_server_status_title from statictext within w_server_status
integer x = 229
integer y = 520
integer width = 553
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Server Status"
boolean focusrectangle = false
end type

type st_master_configuration_date_title from statictext within w_server_status
integer x = 800
integer y = 272
integer width = 553
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Initial Config Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_master_configuration_date from statictext within w_server_status
integer x = 1358
integer y = 264
integer width = 434
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_build_title from statictext within w_server_status
integer x = 850
integer y = 176
integer width = 503
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Client Version:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_build from statictext within w_server_status
integer x = 1358
integer y = 172
integer width = 1353
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_mod_level from statictext within w_server_status
integer x = 2277
integer y = 264
integer width = 434
integer height = 84
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_mod_level_title from statictext within w_server_status
integer x = 1833
integer y = 272
integer width = 443
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "DB Mod Level:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_db_server_title from statictext within w_server_status
integer x = 32
integer y = 360
integer width = 379
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "DB Server:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_db_server from statictext within w_server_status
integer x = 421
integer y = 356
integer width = 599
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_db_name_title from statictext within w_server_status
integer x = 1024
integer y = 368
integer width = 329
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "DB Name:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_db_name from statictext within w_server_status
integer x = 1358
integer y = 356
integer width = 594
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

