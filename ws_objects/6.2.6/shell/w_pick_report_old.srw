HA$PBExportHeader$w_pick_report_old.srw
forward
global type w_pick_report_old from w_window_base
end type
type pb_up from u_picture_button within w_pick_report_old
end type
type pb_down from u_picture_button within w_pick_report_old
end type
type st_page from statictext within w_pick_report_old
end type
type st_title from statictext within w_pick_report_old
end type
type cb_ok from commandbutton within w_pick_report_old
end type
type cb_cancel from commandbutton within w_pick_report_old
end type
type dw_context_object from u_dw_pick_list within w_pick_report_old
end type
type st_context_title from statictext within w_pick_report_old
end type
type dw_reports from u_dw_pick_list within w_pick_report_old
end type
end forward

global type w_pick_report_old from w_window_base
integer height = 1836
boolean controlmenu = false
windowtype windowtype = response!
pb_up pb_up
pb_down pb_down
st_page st_page
st_title st_title
cb_ok cb_ok
cb_cancel cb_cancel
dw_context_object dw_context_object
st_context_title st_context_title
dw_reports dw_reports
end type
global w_pick_report_old w_pick_report_old

type variables

end variables

event open;call super::open;/////////////////////////////////////////////////////////////////////////////
//
//
//
//
//
//
//
//
////////////////////////////////////////////////////////////////////////////
string ls_context_object
long ll_count
string ls_find
long ll_row
str_popup_return popup_return

popup_return.item_count = 0

ls_context_object = wordcap(message.stringparm)


if f_is_context_object(ls_context_object) then
	dw_context_object.dataobject = "dw_v_compatible_context_object"
	dw_context_object.settransobject(sqlca)
	ll_count = dw_context_object.retrieve(ls_context_object)
	if ll_count <= 0 then
		log.log(this, "open", "Error getting compatible context objects", 4)
		closewithreturn(this, popup_return)
		return
	end if
	ls_find = "lower(compatible_context_object)='" + lower(ls_context_object) + "'"
	ll_row = dw_context_object.find(ls_find, 1, ll_count)
	if ll_row <= 0 then ll_row = 1
else
	dw_context_object.dataobject = "dw_domain_notranslate_list"
	dw_context_object.settransobject(sqlca)
	ll_count = dw_context_object.retrieve("CONTEXT_OBJECT")
	if ll_count <= 0 then
		log.log(this, "open", "Error getting context objects", 4)
		closewithreturn(this, popup_return)
		return
	end if
	ll_row = 1
end if

dw_reports.settransobject(sqlca)

dw_context_object.object.selected_flag[ll_row] = 1
dw_context_object.event POST selected(ll_row)


end event

on w_pick_report_old.create
int iCurrent
call super::create
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
this.st_title=create st_title
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.dw_context_object=create dw_context_object
this.st_context_title=create st_context_title
this.dw_reports=create dw_reports
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_up
this.Control[iCurrent+2]=this.pb_down
this.Control[iCurrent+3]=this.st_page
this.Control[iCurrent+4]=this.st_title
this.Control[iCurrent+5]=this.cb_ok
this.Control[iCurrent+6]=this.cb_cancel
this.Control[iCurrent+7]=this.dw_context_object
this.Control[iCurrent+8]=this.st_context_title
this.Control[iCurrent+9]=this.dw_reports
end on

on w_pick_report_old.destroy
call super::destroy
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
destroy(this.st_title)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.dw_context_object)
destroy(this.st_context_title)
destroy(this.dw_reports)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_pick_report_old
boolean visible = true
integer x = 2624
integer y = 16
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pick_report_old
end type

type pb_up from u_picture_button within w_pick_report_old
integer x = 1394
integer y = 136
integer width = 137
integer height = 116
integer taborder = 20
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_reports.current_page

dw_reports.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_pick_report_old
integer x = 1394
integer y = 260
integer width = 137
integer height = 116
integer taborder = 10
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_reports.current_page
li_last_page = dw_reports.last_page

dw_reports.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type st_page from statictext within w_pick_report_old
integer x = 1531
integer y = 136
integer width = 274
integer height = 64
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

type st_title from statictext within w_pick_report_old
integer x = 14
integer width = 2889
integer height = 108
integer textsize = -14
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Select Report"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_pick_report_old
integer x = 2299
integer y = 1548
integer width = 475
integer height = 112
integer taborder = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "OK"
boolean default = true
end type

event clicked;str_popup_return	popup_return
long ll_row

ll_row = dw_reports.get_selected_row()
if ll_row <= 0 then return


popup_return.item_count = 1
popup_return.items[1] = dw_reports.object.report_id[ll_row]
popup_return.descriptions[1] = dw_reports.object.description[ll_row]

Closewithreturn(Parent,popup_return)

end event

type cb_cancel from commandbutton within w_pick_report_old
integer x = 1440
integer y = 1548
integer width = 475
integer height = 112
integer taborder = 110
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 0
Closewithreturn(Parent,popup_return)


end event

type dw_context_object from u_dw_pick_list within w_pick_report_old
integer x = 1609
integer y = 388
integer width = 1157
integer height = 1008
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_v_compatible_context_object"
boolean border = false
end type

event selected;call super::selected;string ls_context_object

if lower(dataobject) = "dw_v_compatible_context_object" then
	ls_context_object = object.compatible_context_object[selected_row]
else
	ls_context_object = object.domain_item[selected_row]
end if

dw_reports.retrieve(ls_context_object, "OK")


end event

type st_context_title from statictext within w_pick_report_old
integer x = 1879
integer y = 320
integer width = 517
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Report Context"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_reports from u_dw_pick_list within w_pick_report_old
integer x = 5
integer y = 128
integer width = 1394
integer height = 1544
integer taborder = 21
boolean bringtotop = true
string dataobject = "dw_report_by_type_list"
boolean border = false
end type

event selected;call super::selected;cb_ok.enabled = true

end event

event unselected;call super::unselected;cb_ok.enabled = false

end event

