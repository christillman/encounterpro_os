$PBExportHeader$w_general_reports.srw
forward
global type w_general_reports from w_window_base
end type
type st_1 from statictext within w_general_reports
end type
type pb_ok from u_picture_button within w_general_reports
end type
type dw_general_reports from u_dw_pick_list within w_general_reports
end type
type pb_up from u_picture_button within w_general_reports
end type
type pb_down from u_picture_button within w_general_reports
end type
type st_page from statictext within w_general_reports
end type
end forward

global type w_general_reports from w_window_base
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_1 st_1
pb_ok pb_ok
dw_general_reports dw_general_reports
pb_up pb_up
pb_down pb_down
st_page st_page
end type
global w_general_reports w_general_reports

type variables
u_component_service    service
end variables

on w_general_reports.create
int iCurrent
call super::create
this.st_1=create st_1
this.pb_ok=create pb_ok
this.dw_general_reports=create dw_general_reports
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.pb_ok
this.Control[iCurrent+3]=this.dw_general_reports
this.Control[iCurrent+4]=this.pb_up
this.Control[iCurrent+5]=this.pb_down
this.Control[iCurrent+6]=this.st_page
end on

on w_general_reports.destroy
call super::destroy
destroy(this.st_1)
destroy(this.pb_ok)
destroy(this.dw_general_reports)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
end on

event open;call super::open;service = message.powerobjectparm

postevent("post_open")
end event

event post_open;call super::post_open;Long	ll_rows

dw_general_reports.settransobject(sqlca)
ll_rows = dw_general_reports.retrieve()
If not tf_check() Then
	pb_ok.event clicked()
	Return
End If
If ll_rows = 0 Then
	openwithparm(w_pop_message,"No records found for general reports..")
	pb_ok.event clicked()
	Return
End If
dw_general_reports.last_page = 0
dw_general_reports.set_page(1, st_page.text)
If dw_general_reports.last_page < 2 then
	pb_down.visible = false
	pb_up.visible = false
Else
	pb_down.visible = true
	pb_up.visible = true
	pb_up.enabled = false
	pb_down.enabled = true
End If
end event

type pb_epro_help from w_window_base`pb_epro_help within w_general_reports
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_general_reports
end type

type st_1 from statictext within w_general_reports
integer x = 873
integer y = 52
integer width = 763
integer height = 92
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "General Reports"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_ok from u_picture_button within w_general_reports
integer x = 2619
integer y = 1564
integer taborder = 11
boolean bringtotop = true
string picturename = "button26.bmp"
string disabledname = "button26.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "CLOSE"

closewithreturn(parent, popup_return)
end event

type dw_general_reports from u_dw_pick_list within w_general_reports
integer x = 50
integer y = 172
integer width = 2373
integer height = 1624
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_general_report_types"
boolean livescroll = false
end type

event post_click;String 			ls_report_id,ls_service
str_attributes lstr_attributes

ls_report_id = object.report_id[clicked_row]
If Not Isnull(service) And Isvalid(service) Then
	ls_service = service.get_attribute("report_service")
	lstr_attributes.attribute_count = 1
	lstr_attributes.attribute[1].attribute = "report_id"
	lstr_attributes.attribute[1].value = ls_report_id
	service_list.do_service(ls_service,lstr_attributes)
End If

end event

type pb_up from u_picture_button within w_general_reports
boolean visible = false
integer x = 2665
integer y = 256
integer width = 137
integer height = 116
integer taborder = 11
boolean bringtotop = true
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_general_reports.current_page

dw_general_reports.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_general_reports
boolean visible = false
integer x = 2482
integer y = 256
integer width = 137
integer height = 116
integer taborder = 21
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_general_reports.current_page
li_last_page = dw_general_reports.last_page

dw_general_reports.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true
end event

type st_page from statictext within w_general_reports
integer x = 2478
integer y = 168
integer width = 325
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Page 99/99"
alignment alignment = center!
boolean focusrectangle = false
end type

