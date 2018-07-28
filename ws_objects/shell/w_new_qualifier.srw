HA$PBExportHeader$w_new_qualifier.srw
forward
global type w_new_qualifier from window
end type
type cb_get_phrase from commandbutton within w_new_qualifier
end type
type sle_string from singlelineedit within w_new_qualifier
end type
type pb_cancel from u_picture_button within w_new_qualifier
end type
type st_prompt from statictext within w_new_qualifier
end type
type pb_ok from u_picture_button within w_new_qualifier
end type
end forward

global type w_new_qualifier from window
integer x = 434
integer y = 604
integer width = 2190
integer height = 736
windowtype windowtype = response!
long backcolor = 33538240
cb_get_phrase cb_get_phrase
sle_string sle_string
pb_cancel pb_cancel
st_prompt st_prompt
pb_ok pb_ok
end type
global w_new_qualifier w_new_qualifier

event open;str_popup popup

popup = message.powerobjectparm

st_prompt.text = popup.title

if not isnull(popup.item) and trim(popup.item) <> "" then
	sle_string.text = popup.item
	sle_string.selecttext(1, len(sle_string.text))
end if

sle_string.setfocus()


end event

on w_new_qualifier.create
this.cb_get_phrase=create cb_get_phrase
this.sle_string=create sle_string
this.pb_cancel=create pb_cancel
this.st_prompt=create st_prompt
this.pb_ok=create pb_ok
this.Control[]={this.cb_get_phrase,&
this.sle_string,&
this.pb_cancel,&
this.st_prompt,&
this.pb_ok}
end on

on w_new_qualifier.destroy
destroy(this.cb_get_phrase)
destroy(this.sle_string)
destroy(this.pb_cancel)
destroy(this.st_prompt)
destroy(this.pb_ok)
end on

type cb_get_phrase from commandbutton within w_new_qualifier
boolean visible = false
integer x = 1961
integer y = 252
integer width = 146
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ". . ."
end type

event clicked;u_component_nomenclature luo_nomenclature
string ls_phrase

//luo_nomenclature = component_manager.get_component("NOMENCLATURE","PHRASE")
setnull(luo_nomenclature)
if isnull(luo_nomenclature) then
	openwithparm(w_pop_message, "A nomenclature component has not been installed")
	return
end if

ls_phrase = luo_nomenclature.get_phrase("RESULT")
if not (isnull(ls_phrase) or trim(ls_phrase) = "") then
	sle_string.text = ls_phrase
end if

component_manager.destroy_component(luo_nomenclature)


end event

type sle_string from singlelineedit within w_new_qualifier
integer x = 101
integer y = 252
integer width = 1824
integer height = 96
integer taborder = 10
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type pb_cancel from u_picture_button within w_new_qualifier
integer x = 82
integer y = 444
integer taborder = 40
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

setnull(popup_return.item)
popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type st_prompt from statictext within w_new_qualifier
integer x = 82
integer y = 80
integer width = 2039
integer height = 92
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_ok from u_picture_button within w_new_qualifier
integer x = 1861
integer y = 444
integer taborder = 20
boolean default = true
string picturename = "button26.bmp"
string disabledname = "button26.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

if trim(sle_string.text) = "" then
	setnull(popup_return.item)
	popup_return.item_count = 0
else
	popup_return.item = sle_string.text
	popup_return.items[1] = sle_string.text
	popup_return.item_count = 1
end if

closewithreturn(parent, popup_return)

end event

