$PBExportHeader$w_carrier_select.srw
forward
global type w_carrier_select from w_window_base
end type
type pb_done from u_picture_button within w_carrier_select
end type
type pb_cancel from u_picture_button within w_carrier_select
end type
type st_no_alternate_codes from statictext within w_carrier_select
end type
type uo_carriers from u_insurance_edit within w_carrier_select
end type
end forward

global type w_carrier_select from w_window_base
integer x = 0
integer y = 0
integer height = 1832
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_done pb_done
pb_cancel pb_cancel
st_no_alternate_codes st_no_alternate_codes
uo_carriers uo_carriers
end type
global w_carrier_select w_carrier_select

type variables
string authority_id
string authority_description
string authority_type

end variables

event open;call super::open;str_popup popup
str_popup_return popup_return
integer li_sts

popup_return.item_count = 0

li_sts = uo_carriers.initialize("PICK")
if li_sts < 0 then
	log.log(this, "open", "Error initializing carriers", 4)
	closewithreturn(this, popup_return)
	return
end if



end event

on w_carrier_select.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.st_no_alternate_codes=create st_no_alternate_codes
this.uo_carriers=create uo_carriers
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.st_no_alternate_codes
this.Control[iCurrent+4]=this.uo_carriers
end on

on w_carrier_select.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.st_no_alternate_codes)
destroy(this.uo_carriers)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_carrier_select
end type

type pb_done from u_picture_button within w_carrier_select
integer x = 2565
integer y = 1532
integer taborder = 0
boolean default = true
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = authority_id
popup_return.items[2] = authority_type
popup_return.descriptions[1] = authority_description

closewithreturn(parent, popup_return)


end event

type pb_cancel from u_picture_button within w_carrier_select
integer x = 2565
integer y = 1204
integer taborder = 0
boolean bringtotop = true
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

setnull(popup_return.item)
popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type st_no_alternate_codes from statictext within w_carrier_select
boolean visible = false
integer x = 736
integer y = 1052
integer width = 1504
integer height = 156
boolean bringtotop = true
integer textsize = -24
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "No Alternate Codes"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_carriers from u_insurance_edit within w_carrier_select
event destroy ( )
integer x = 59
integer y = 48
integer taborder = 10
boolean bringtotop = true
end type

on uo_carriers.destroy
call u_insurance_edit::destroy
end on

event carrier_selected;authority_id = ps_insurance_id
authority_description = ps_description
authority_type = ps_insurance_type
pb_done.enabled = true

end event

event carrier_unselected;setnull(authority_id)
setnull(authority_description)
setnull(authority_type)
pb_done.enabled = false


end event

