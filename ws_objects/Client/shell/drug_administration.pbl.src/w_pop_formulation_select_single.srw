﻿$PBExportHeader$w_pop_formulation_select_single.srw
forward
global type w_pop_formulation_select_single from w_window_base
end type
type pb_cancel from u_picture_button within w_pop_formulation_select_single
end type
type pb_ok from u_picture_button within w_pop_formulation_select_single
end type
type dw_generic from u_dw_pick_list within w_pop_formulation_select_single
end type
type dw_brand from u_dw_pick_list within w_pop_formulation_select_single
end type
type st_generic_brand from statictext within w_pop_formulation_select_single
end type
end forward

global type w_pop_formulation_select_single from w_window_base
integer width = 3973
integer height = 2040
windowtype windowtype = response!
boolean center = true
pb_cancel pb_cancel
pb_ok pb_ok
dw_generic dw_generic
dw_brand dw_brand
st_generic_brand st_generic_brand
end type
global w_pop_formulation_select_single w_pop_formulation_select_single

type variables
string which_code
boolean ib_generic_shown

end variables

event open;call super::open;
string ls_generic_rxcui, ls_brand_rxcui
string ls_country_code

str_popup popup
str_popup_return popup_return

popup = message.powerobjectparm

ls_generic_rxcui = popup.items[1]
ls_brand_rxcui = popup.items[2]
ls_country_code =  datalist.office_field(gnv_app.office_id, "country")

dw_generic.settransobject(sqlca)
dw_brand.settransobject(sqlca)

ib_generic_shown = True
dw_generic.Visible = True
dw_brand.Visible = False
IF ls_brand_rxcui <> "0" THEN
	// If a brand was chosen, let the procedure know
	ls_generic_rxcui = "0" 
	// and show the brand list
	ib_generic_shown = False
	dw_generic.Visible = False
	dw_brand.Visible = True
	st_generic_brand.text = "Show Generics"
END IF

dw_generic.retrieve(ls_generic_rxcui, ls_brand_rxcui, ls_country_code)
dw_brand.retrieve(ls_brand_rxcui, ls_generic_rxcui, ls_country_code)

IF ls_brand_rxcui <> "0" THEN
	dw_brand.setfocus()
ELSE
	dw_generic.setfocus()
END IF


end event

on w_pop_formulation_select_single.create
int iCurrent
call super::create
this.pb_cancel=create pb_cancel
this.pb_ok=create pb_ok
this.dw_generic=create dw_generic
this.dw_brand=create dw_brand
this.st_generic_brand=create st_generic_brand
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_cancel
this.Control[iCurrent+2]=this.pb_ok
this.Control[iCurrent+3]=this.dw_generic
this.Control[iCurrent+4]=this.dw_brand
this.Control[iCurrent+5]=this.st_generic_brand
end on

on w_pop_formulation_select_single.destroy
call super::destroy
destroy(this.pb_cancel)
destroy(this.pb_ok)
destroy(this.dw_generic)
destroy(this.dw_brand)
destroy(this.st_generic_brand)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_pop_formulation_select_single
boolean visible = true
integer x = 1691
integer y = 1712
integer height = 188
boolean originalsize = false
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pop_formulation_select_single
end type

type pb_cancel from u_picture_button within w_pop_formulation_select_single
integer x = 119
integer y = 1696
integer width = 256
integer height = 224
integer taborder = 20
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

setnull(popup_return.item)
popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type pb_ok from u_picture_button within w_pop_formulation_select_single
integer x = 3374
integer y = 1696
integer taborder = 10
boolean default = true
boolean originalsize = false
string picturename = "button26.bmp"
string disabledname = "button26.bmp"
end type

event clicked;call super::clicked;
str_popup_return popup_return

popup_return.item_count = 2

SetNull(popup_return.items[1])
SetNull(popup_return.items[2])
SetNull(popup_return.descriptions[1])

IF dw_generic.lastrow > 0 AND dw_generic.isselected(dw_generic.lastrow) THEN
	popup_return.items[1] = dw_generic.Object.form_rxcui[dw_generic.lastrow]
	popup_return.items[2] = dw_generic.Object.ingr_rxcui[dw_generic.lastrow]
	popup_return.descriptions[1] = dw_generic.Object.form_descr[dw_generic.lastrow]
END IF
IF dw_brand.lastrow > 0 AND dw_brand.isselected(dw_brand.lastrow) THEN
	popup_return.items[1] = dw_brand.Object.form_rxcui[dw_brand.lastrow]
	popup_return.items[2] = dw_brand.Object.ingr_rxcui[dw_brand.lastrow]
	popup_return.descriptions[1] = dw_brand.Object.form_descr[dw_brand.lastrow]
END IF

message.powerobjectparm = popup_return
CloseWithReturn(parent, popup_return)

RETURN AncestorReturnValue
end event

type dw_generic from u_dw_pick_list within w_pop_formulation_select_single
integer x = 128
integer y = 52
integer width = 3625
integer height = 1636
integer taborder = 10
boolean bringtotop = true
boolean titlebar = true
string title = "Generic Drug Formulations"
string dataobject = "dw_generic_formulations"
boolean vscrollbar = true
boolean livescroll = false
end type

event clicked;call super::clicked;
dw_brand.SelectRow(0,false)
SelectRow(0,false)
SelectRow(row, true)
end event

type dw_brand from u_dw_pick_list within w_pop_formulation_select_single
integer x = 128
integer y = 52
integer width = 3625
integer height = 1636
integer taborder = 10
boolean bringtotop = true
boolean titlebar = true
string title = "Branded Drug Formulations"
string dataobject = "dw_brand_formulations"
boolean vscrollbar = true
boolean livescroll = false
end type

event clicked;call super::clicked;

dw_generic.SelectRow(0,false)
SelectRow(0,false)
SelectRow(row, true)
end event

type st_generic_brand from statictext within w_pop_formulation_select_single
integer x = 517
integer y = 1764
integer width = 489
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Show Brands"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;
if ib_generic_shown then
	ib_generic_shown = False
	dw_generic.Visible = False
	dw_brand.Visible = True
	text = "Show Generics"
else
	ib_generic_shown = True
	dw_generic.Visible = True
	dw_brand.Visible = False
	text = "Show Brands"
end if

end event

