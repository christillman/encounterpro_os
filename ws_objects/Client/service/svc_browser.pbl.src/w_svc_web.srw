$PBExportHeader$w_svc_web.srw
forward
global type w_svc_web from w_window_base
end type
type ole_browser from u_ie_browser within w_svc_web
end type
type cb_cancel from commandbutton within w_svc_web
end type
type cb_close from commandbutton within w_svc_web
end type
type pb_done from u_picture_button within w_svc_web
end type
type pb_cancel from u_picture_button within w_svc_web
end type
type cb_beback from commandbutton within w_svc_web
end type
type cb_back from commandbutton within w_svc_web
end type
type cb_forward from commandbutton within w_svc_web
end type
type cb_home from commandbutton within w_svc_web
end type
type st_url from statictext within w_svc_web
end type
end forward

global type w_svc_web from w_window_base
integer x = 0
integer y = 0
integer width = 2926
integer height = 1832
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
windowstate windowstate = maximized!
long backcolor = 33538240
ole_browser ole_browser
cb_cancel cb_cancel
cb_close cb_close
pb_done pb_done
pb_cancel pb_cancel
cb_beback cb_beback
cb_back cb_back
cb_forward cb_forward
cb_home cb_home
st_url st_url
end type
global w_svc_web w_svc_web

type variables
string url
u_component_service service

end variables

forward prototypes
public subroutine resize ()
end prototypes

public subroutine resize ();
//pb_cancel.x = 100
//pb_cancel.y = height - pb_cancel.height - 100

cb_back.y = height - cb_back.height - 60
cb_forward.y = cb_back.y
cb_home.y = cb_back.y

cb_beback.y = cb_back.y
cb_close.y = cb_back.y
cb_cancel.y = cb_back.y

cb_close.x = width - cb_close.width - 100
cb_beback.x = cb_close.x - cb_beback.width - 100
cb_cancel.x = cb_beback.x - cb_cancel.width - 300

//pb_done.y = pb_cancel.y
//pb_done.x = width - pb_done.width - 100

ole_browser.x = 0
ole_browser.y = 0
ole_browser.width = width - 50
ole_browser.object.width = unitstopixels(ole_browser.width, XUnitsToPixels!)

ole_browser.height = height - 300
ole_browser.object.height = unitstopixels(ole_browser.height, YUnitsToPixels!)

st_url.x = 50
st_url.y = cb_beback.y - st_url.height - 20

end subroutine

on w_svc_web.create
int iCurrent
call super::create
this.ole_browser=create ole_browser
this.cb_cancel=create cb_cancel
this.cb_close=create cb_close
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.cb_beback=create cb_beback
this.cb_back=create cb_back
this.cb_forward=create cb_forward
this.cb_home=create cb_home
this.st_url=create st_url
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ole_browser
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cb_close
this.Control[iCurrent+4]=this.pb_done
this.Control[iCurrent+5]=this.pb_cancel
this.Control[iCurrent+6]=this.cb_beback
this.Control[iCurrent+7]=this.cb_back
this.Control[iCurrent+8]=this.cb_forward
this.Control[iCurrent+9]=this.cb_home
this.Control[iCurrent+10]=this.st_url
end on

on w_svc_web.destroy
call super::destroy
destroy(this.ole_browser)
destroy(this.cb_cancel)
destroy(this.cb_close)
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.cb_beback)
destroy(this.cb_back)
destroy(this.cb_forward)
destroy(this.cb_home)
destroy(this.st_url)
end on

event open;call super::open;str_popup popup
str_popup_return popup_return
long ll_encounter_id
integer li_sts
long ll_len
string ls_temp


popup_return.item_count = 0

service = message.powerobjectparm

url = service.get_attribute("url")
if isnull(url) then
	log.log(this, "w_svc_web.open.0015", "No URL", 4)
	closewithreturn(this, popup_return)
	return
end if

url = service.substitute_attributes(url)

if not isnull(current_patient) then
	url = f_string_substitute(url, "%CPR_ID%", current_patient.cpr_id)
end if

url = f_string_substitute(url, "%PATIENT_WORKPLAN_ITEM_ID%", string(service.patient_workplan_item_id))

if not isnull(service.treatment) then
	url = f_string_substitute(url, "%TREATMENT_ID%", string(service.treatment.treatment_id))
end if

ls_temp = service.get_attribute("debug")
if upper(left(ls_temp, 1)) = "Y" then
	st_url.text = url
	st_url.visible = true
else
	st_url.visible = false
end if

this.postevent("post_open")

end event

event post_open;call super::post_open;resize()

ole_browser.object.navigate(url)

end event

type ole_browser from u_ie_browser within w_svc_web
integer width = 2921
integer height = 1584
integer taborder = 10
string binarykey = "w_svc_web.win"
end type

type cb_cancel from commandbutton within w_svc_web
boolean visible = false
integer x = 1065
integer y = 1624
integer width = 283
integer height = 92
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "CANCEL"
closewithreturn(parent, popup_return)

end event

type cb_close from commandbutton within w_svc_web
integer x = 2368
integer y = 1624
integer width = 462
integer height = 132
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'m Finished"
boolean default = true
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "CLOSE"
closewithreturn(parent, popup_return)

end event

type pb_done from u_picture_button within w_svc_web
boolean visible = false
integer x = 347
integer y = 1772
integer taborder = 10
boolean default = true
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "CLOSE"
closewithreturn(parent, popup_return)

end event

type pb_cancel from u_picture_button within w_svc_web
boolean visible = false
integer x = 37
integer y = 1772
integer taborder = 60
boolean bringtotop = true
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type cb_beback from commandbutton within w_svc_web
integer x = 1778
integer y = 1624
integer width = 462
integer height = 132
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
boolean cancel = true
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 0
closewithreturn(parent, popup_return)

end event

type cb_back from commandbutton within w_svc_web
integer x = 37
integer y = 1624
integer width = 219
integer height = 132
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Back"
end type

event clicked;ole_browser.object.goback()

end event

type cb_forward from commandbutton within w_svc_web
integer x = 265
integer y = 1624
integer width = 219
integer height = 132
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Fwd"
end type

event clicked;ole_browser.object.goforward()

end event

type cb_home from commandbutton within w_svc_web
integer x = 494
integer y = 1624
integer width = 219
integer height = 132
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Home"
end type

event clicked;ole_browser.object.navigate(url)

end event

type st_url from statictext within w_svc_web
boolean visible = false
integer x = 41
integer y = 1552
integer width = 2807
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean focusrectangle = false
end type


Start of PowerBuilder Binary Data Section : Do NOT Edit
06w_svc_web.bin 
2B00000a00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff000000010000000000000000000000000000000000000000000000000000000044c4ba5001c0c91a00000003000000c00000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000102001affffffff00000002ffffffff000000000000000000000000000000000000000000000000000000000000000000000000fffffffe0000000000000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000001001affffffffffffffff000000038856f96111d0340ac0006ba9a205d74f0000000044c4ba5001c0c91a44c4ba5001c0c91a000000000000000000000000004f00430054004e004e00450053005400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000009c000000000000000100000002fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
2Effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000004c0000420b000028ee0000000000000000000000000000000000000000000000000000004c0000000000000000000000010057d0e011cf3573000869ae62122e2b00000008000000000000004c0002140100000000000000c04600000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000200028002000290072002000740065007200750073006e006c0020006e006f002000670070005b006d0062006f005f00650070005d006e006f0000006800740072006500280020007500200073006e006700690065006e006c0064006e006f002000670070007700720061006d00610020002c006f006c0067006e006c002000610070006100720020006d002000290072002000740065007200750073006e006c0020006e006f002000670070005b006d0062006f005f00680074007200650000005d01010000000000000000000000000000010002000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
16w_svc_web.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
