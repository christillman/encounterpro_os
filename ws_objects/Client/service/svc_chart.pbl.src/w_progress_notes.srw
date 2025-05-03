$PBExportHeader$w_progress_notes.srw
forward
global type w_progress_notes from w_window_base
end type
type st_sort_title from statictext within w_progress_notes
end type
type st_sort_asc from statictext within w_progress_notes
end type
type st_sort_desc from statictext within w_progress_notes
end type
type cb_done from commandbutton within w_progress_notes
end type
type cb_be_back from commandbutton within w_progress_notes
end type
type st_progress_type from statictext within w_progress_notes
end type
type pb_up from u_picture_button within w_progress_notes
end type
type st_page from statictext within w_progress_notes
end type
type pb_down from u_picture_button within w_progress_notes
end type
type st_title from statictext within w_progress_notes
end type
type st_new_progress_note from statictext within w_progress_notes
end type
type st_new_attachment from statictext within w_progress_notes
end type
type dw_progress from u_dw_progress_display within w_progress_notes
end type
end forward

global type w_progress_notes from w_window_base
string title = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string button_type = "COMMAND"
integer max_buttons = 3
st_sort_title st_sort_title
st_sort_asc st_sort_asc
st_sort_desc st_sort_desc
cb_done cb_done
cb_be_back cb_be_back
st_progress_type st_progress_type
pb_up pb_up
st_page st_page
pb_down pb_down
st_title st_title
st_new_progress_note st_new_progress_note
st_new_attachment st_new_attachment
dw_progress dw_progress
end type
global w_progress_notes w_progress_notes

type variables
u_component_service service

end variables

on w_progress_notes.create
int iCurrent
call super::create
this.st_sort_title=create st_sort_title
this.st_sort_asc=create st_sort_asc
this.st_sort_desc=create st_sort_desc
this.cb_done=create cb_done
this.cb_be_back=create cb_be_back
this.st_progress_type=create st_progress_type
this.pb_up=create pb_up
this.st_page=create st_page
this.pb_down=create pb_down
this.st_title=create st_title
this.st_new_progress_note=create st_new_progress_note
this.st_new_attachment=create st_new_attachment
this.dw_progress=create dw_progress
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_sort_title
this.Control[iCurrent+2]=this.st_sort_asc
this.Control[iCurrent+3]=this.st_sort_desc
this.Control[iCurrent+4]=this.cb_done
this.Control[iCurrent+5]=this.cb_be_back
this.Control[iCurrent+6]=this.st_progress_type
this.Control[iCurrent+7]=this.pb_up
this.Control[iCurrent+8]=this.st_page
this.Control[iCurrent+9]=this.pb_down
this.Control[iCurrent+10]=this.st_title
this.Control[iCurrent+11]=this.st_new_progress_note
this.Control[iCurrent+12]=this.st_new_attachment
this.Control[iCurrent+13]=this.dw_progress
end on

on w_progress_notes.destroy
call super::destroy
destroy(this.st_sort_title)
destroy(this.st_sort_asc)
destroy(this.st_sort_desc)
destroy(this.cb_done)
destroy(this.cb_be_back)
destroy(this.st_progress_type)
destroy(this.pb_up)
destroy(this.st_page)
destroy(this.pb_down)
destroy(this.st_title)
destroy(this.st_new_progress_note)
destroy(this.st_new_attachment)
destroy(this.dw_progress)
end on

event open;call super::open;str_popup popup
str_popup_return popup_return
integer li_sts
long ll_menu_id
string ls_progress_key_required_flag
string ls_progress_key_enumerated_flag
integer li_count
u_ds_data luo_data
string ls_progress_object
string ls_progress_type

popup_return.item_count = 0

service = message.powerobjectparm

ls_progress_object = service.get_attribute("progress_object")
if isnull(ls_progress_object) then
	log.log(this, "w_progress_notes:open", "null progress_object", 4)
	closewithreturn(this, popup_return)
	return
end if

li_sts = dw_progress.initialize(service, ls_progress_object)
if li_sts <= 0 then
	log.log(this, "w_progress_notes:open", "Error initializing progress display", 4)
	closewithreturn(this, popup_return)
	return
end if

ls_progress_type = service.get_attribute("progress_type")

if isnull(ls_progress_type) then
	luo_data = CREATE u_ds_data
	luo_data.set_dataobject(dw_progress.progress_pick_dw)
	li_sts = luo_data.retrieve(dw_progress.progress_type_pick_code)
	if li_sts < 0 then
		DESTROY luo_data
		closewithreturn(this, popup_return)
		return
	elseif li_sts = 0 then
		DESTROY luo_data
		log.log(this, "w_progress_notes:open", "No progress_type defined (" + dw_progress.progress_type_pick_code + ")", 4)
		closewithreturn(this, popup_return)
		return
	elseif li_sts = 1 then
		ls_progress_type = luo_data.object.progress_type[1]
		dw_progress.set_progress_type(ls_progress_type)
		st_progress_type.text = ls_progress_type
		st_progress_type.borderstyle = StyleBox!
		st_progress_type.enabled = false
	else
		st_progress_type.postevent("clicked")
	end if
	DESTROY luo_data
else
	st_progress_type.text = ls_progress_type
	dw_progress.set_progress_type(ls_progress_type)
	st_progress_type.borderstyle = StyleBox!
	st_progress_type.enabled = false
end if

dw_progress.set_page(1, pb_up, pb_down, st_page)

title = current_patient.id_line()

st_title.text = ls_progress_type + " for " + service.context_description

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

dw_progress.sort = "D"
st_sort_desc.backcolor = color_object_selected

// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 4
end if

ll_menu_id = long(service.get_attribute("menu_id"))
paint_menu(ll_menu_id)

return


end event

type pb_epro_help from w_window_base`pb_epro_help within w_progress_notes
boolean visible = true
integer x = 2642
integer y = 1464
boolean originalsize = false
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_progress_notes
end type

type st_sort_title from statictext within w_progress_notes
integer x = 2574
integer y = 556
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
string text = "Sort"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_sort_asc from statictext within w_progress_notes
integer x = 2574
integer y = 628
integer width = 247
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Asc"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_progress.sort = "A"
backcolor = color_object_selected
st_sort_desc.backcolor = color_object

dw_progress.sort_notes()

end event

type st_sort_desc from statictext within w_progress_notes
integer x = 2574
integer y = 748
integer width = 247
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Desc"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_progress.sort = "D"
backcolor = color_object_selected
st_sort_asc.backcolor = color_object

dw_progress.sort_notes()

end event

type cb_done from commandbutton within w_progress_notes
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

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type cb_be_back from commandbutton within w_progress_notes
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

popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type st_progress_type from statictext within w_progress_notes
integer x = 837
integer y = 132
integer width = 1248
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Progress Notes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = dw_progress.progress_pick_dw
popup.argument_count = 1
popup.argument[1] = dw_progress.progress_type_pick_code
popup.datacolumn = 2
popup.displaycolumn = 2
popup.auto_singleton = true
openwithparm(w_pop_pick, popup)
popup_return = f_popup_return("w_pop_pick,w_progress_notes.st_progress_type.clicked:0011")
if popup_return.item_count <> 1 then return

dw_progress.set_progress_type(popup_return.items[1])

text = popup_return.items[1]

st_title.text = text + " for " + service.context_description

end event

type pb_up from u_picture_button within w_progress_notes
integer x = 2528
integer y = 268
integer width = 137
integer height = 116
integer taborder = 20
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_progress.current_page

dw_progress.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type st_page from statictext within w_progress_notes
integer x = 2290
integer y = 192
integer width = 366
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Page 99/99"
alignment alignment = right!
boolean focusrectangle = false
end type

type pb_down from u_picture_button within w_progress_notes
integer x = 2528
integer y = 404
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

li_page = dw_progress.current_page
li_last_page = dw_progress.last_page

dw_progress.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true


end event

type st_title from statictext within w_progress_notes
integer width = 2921
integer height = 120
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
string text = "Treatment Progress Notes"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_new_progress_note from statictext within w_progress_notes
integer x = 2528
integer y = 976
integer width = 343
integer height = 160
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "New Text Note"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;integer li_sts

li_sts = dw_progress.new_progress_note()

end event

type st_new_attachment from statictext within w_progress_notes
integer x = 2528
integer y = 1176
integer width = 343
integer height = 160
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "New Attachment"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;integer li_sts

li_sts = dw_progress.new_attachment()

end event

type dw_progress from u_dw_progress_display within w_progress_notes
integer x = 27
integer y = 260
integer width = 2491
integer height = 1348
integer taborder = 10
boolean border = false
end type

