$PBExportHeader$w_new_material_url.srw
forward
global type w_new_material_url from window
end type
type cb_test from commandbutton within w_new_material_url
end type
type st_2 from statictext within w_new_material_url
end type
type sle_url from singlelineedit within w_new_material_url
end type
type st_1 from statictext within w_new_material_url
end type
type cb_cancel from commandbutton within w_new_material_url
end type
type cb_finished from commandbutton within w_new_material_url
end type
type st_category from statictext within w_new_material_url
end type
type st_category_title from statictext within w_new_material_url
end type
type sle_title from singlelineedit within w_new_material_url
end type
type st_title_title from statictext within w_new_material_url
end type
end forward

global type w_new_material_url from window
integer width = 2926
integer height = 1832
boolean titlebar = true
string title = "Import Selected Files"
windowtype windowtype = response!
long backcolor = 33538240
event postopen ( )
cb_test cb_test
st_2 st_2
sle_url sle_url
st_1 st_1
cb_cancel cb_cancel
cb_finished cb_finished
st_category st_category
st_category_title st_category_title
sle_title sle_title
st_title_title st_title_title
end type
global w_new_material_url w_new_material_url

type variables
long category_id

end variables

on w_new_material_url.create
this.cb_test=create cb_test
this.st_2=create st_2
this.sle_url=create sle_url
this.st_1=create st_1
this.cb_cancel=create cb_cancel
this.cb_finished=create cb_finished
this.st_category=create st_category
this.st_category_title=create st_category_title
this.sle_title=create sle_title
this.st_title_title=create st_title_title
this.Control[]={this.cb_test,&
this.st_2,&
this.sle_url,&
this.st_1,&
this.cb_cancel,&
this.cb_finished,&
this.st_category,&
this.st_category_title,&
this.sle_title,&
this.st_title_title}
end on

on w_new_material_url.destroy
destroy(this.cb_test)
destroy(this.st_2)
destroy(this.sle_url)
destroy(this.st_1)
destroy(this.cb_cancel)
destroy(this.cb_finished)
destroy(this.st_category)
destroy(this.st_category_title)
destroy(this.sle_title)
destroy(this.st_title_title)
end on

event open;setnull(category_id)

end event

type cb_test from commandbutton within w_new_material_url
integer x = 2555
integer y = 520
integer width = 215
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Test"
end type

event clicked;f_open_browser(sle_url.text)
end event

type st_2 from statictext within w_new_material_url
integer x = 375
integer y = 532
integer width = 197
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "URL:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_url from singlelineedit within w_new_material_url
integer x = 603
integer y = 516
integer width = 1938
integer height = 108
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_new_material_url
integer x = 306
integer y = 24
integer width = 2277
integer height = 240
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Please specify the following information about the new material"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_new_material_url
integer x = 78
integer y = 1604
integer width = 402
integer height = 112
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;str_popup_return popup_return

openwithparm(w_pop_yes_no, "Are you sure yuou wish to cancel without importing these files?")
popup_return = message.powerobjectparm
if popup_return.item = "YES" then close(parent)



end event

type cb_finished from commandbutton within w_new_material_url
integer x = 2354
integer y = 1604
integer width = 517
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;long ll_material_id
string ls_id
string ls_filename
long ll_from_material_id
string ls_parent_config_object_id

if isnull(sle_url.text) or trim(sle_url.text) = "" then
	openwithparm(w_pop_message, "You must supply a URL")
	return
end if

if isnull(sle_title.text) or trim(sle_title.text) = "" then
	openwithparm(w_pop_message, "You must supply a title")
	return
end if

setnull(ls_id)
setnull(ls_filename)
setnull(ll_from_material_id)
setnull(ls_parent_config_object_id)


ll_material_id = sqlca.jmj_new_material(sle_title.text, category_id, "OK", "URL", ls_id, sle_url.text, current_scribe.user_id, ls_filename, ll_from_material_id, ls_parent_config_object_id)
if not tf_check() then return
if isnull(ll_material_id) or ll_material_id <= 0 then
	log.log(this,"w_new_material_url.cb_finished.clicked:0026","Error creating new material",4)
	return
end if


closewithreturn(parent, ll_material_id)

end event

type st_category from statictext within w_new_material_url
integer x = 603
integer y = 1092
integer width = 773
integer height = 136
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;//////////////////////////////////////////////////////////////////////////////////////
//
// Description: popup the material categories
//
// Created By:Sumathi Chinnasamy										Creation dt: 02/02/2000
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

str_popup			popup
str_popup_return	popup_return

popup.dataobject = "dw_material_category_list"
popup.datacolumn = 1
popup.displaycolumn = 2

Openwithparm(w_pop_pick, popup)
popup_return = Message.powerobjectparm
If popup_return.item_count <> 1 Then Return
category_id = Long(popup_return.items[1])
Text = popup_return.descriptions[1]


end event

type st_category_title from statictext within w_new_material_url
integer x = 270
integer y = 1124
integer width = 302
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Category:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_title from singlelineedit within w_new_material_url
integer x = 603
integer y = 804
integer width = 1938
integer height = 108
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

type st_title_title from statictext within w_new_material_url
integer x = 155
integer y = 820
integer width = 416
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Material Title:"
alignment alignment = right!
boolean focusrectangle = false
end type

