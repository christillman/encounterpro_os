$PBExportHeader$w_charge_edit.srw
forward
global type w_charge_edit from w_window_base
end type
type pb_done from u_picture_button within w_charge_edit
end type
type pb_cancel from u_picture_button within w_charge_edit
end type
type em_charge from editmask within w_charge_edit
end type
type st_2 from statictext within w_charge_edit
end type
type cb_zero from commandbutton within w_charge_edit
end type
type st_title from statictext within w_charge_edit
end type
type st_update from statictext within w_charge_edit
end type
end forward

global type w_charge_edit from w_window_base
integer x = 1390
integer y = 608
integer width = 1385
integer height = 888
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_done pb_done
pb_cancel pb_cancel
em_charge em_charge
st_2 st_2
cb_zero cb_zero
st_title st_title
st_update st_update
end type
global w_charge_edit w_charge_edit

type variables
string cpr_id
long encounter_id
long encounter_charge_id
boolean update_master
end variables

on w_charge_edit.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.em_charge=create em_charge
this.st_2=create st_2
this.cb_zero=create cb_zero
this.st_title=create st_title
this.st_update=create st_update
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.em_charge
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.cb_zero
this.Control[iCurrent+6]=this.st_title
this.Control[iCurrent+7]=this.st_update
end on

on w_charge_edit.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.em_charge)
destroy(this.st_2)
destroy(this.cb_zero)
destroy(this.st_title)
destroy(this.st_update)
end on

event open;call super::open;str_popup popup

popup = message.powerobjectparm

cpr_id = popup.items[1]
encounter_id = long(popup.items[2])
encounter_charge_id = long(popup.items[3])
em_charge.text = popup.items[4]

st_title.text = popup.title

if popup.multiselect and current_user.check_privilege("Edit Charges")then
	st_update.visible = true
else
	st_update.visible = false
end if

update_master = false

end event

type pb_epro_help from w_window_base`pb_epro_help within w_charge_edit
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_charge_edit
end type

type pb_done from u_picture_button within w_charge_edit
integer x = 1015
integer y = 624
integer taborder = 0
boolean default = true
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return
decimal ldc_charge


ldc_charge = dec(em_charge.text)
if ldc_charge = 0 then
	setnull(popup_return.items[1])
else
	popup_return.items[1] = em_charge.text
end if

if update_master then
	popup_return.items[2] = "TRUE"
else
	popup_return.items[2] = "FALSE"
end if

popup_return.item_count = 2

closewithreturn(parent, popup_return)

end event

type pb_cancel from u_picture_button within w_charge_edit
integer x = 105
integer y = 620
integer taborder = 0
boolean bringtotop = true
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type em_charge from editmask within w_charge_edit
event modified pbm_enmodified
integer x = 521
integer y = 392
integer width = 338
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "##,###.00"
string displaydata = ""
end type

type st_2 from statictext within w_charge_edit
integer x = 165
integer y = 400
integer width = 347
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Charge:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_zero from commandbutton within w_charge_edit
integer x = 951
integer y = 388
integer width = 201
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Zero"
end type

event clicked;em_charge.text = ".00"
end event

type st_title from statictext within w_charge_edit
integer x = 5
integer width = 1371
integer height = 256
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type st_update from statictext within w_charge_edit
integer x = 549
integer y = 648
integer width = 283
integer height = 160
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Update Master"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if update_master then
	backcolor = color_object
	update_master = false
else
	backcolor = color_object_selected
	update_master = true
end if


end event

