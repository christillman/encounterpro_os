$PBExportHeader$w_config_drug.srw
forward
global type w_config_drug from w_window_base
end type
type st_common_name_title from statictext within w_config_drug
end type
type st_title from statictext within w_config_drug
end type
type cb_ok from commandbutton within w_config_drug
end type
type st_common_name from statictext within w_config_drug
end type
type tab_drug_config from u_tab_drug_config within w_config_drug
end type
type tab_drug_config from u_tab_drug_config within w_config_drug
end type
type st_generic_name_title from statictext within w_config_drug
end type
type st_generic_name from statictext within w_config_drug
end type
type cb_cancel from commandbutton within w_config_drug
end type
end forward

global type w_config_drug from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_common_name_title st_common_name_title
st_title st_title
cb_ok cb_ok
st_common_name st_common_name
tab_drug_config tab_drug_config
st_generic_name_title st_generic_name_title
st_generic_name st_generic_name
cb_cancel cb_cancel
end type
global w_config_drug w_config_drug

type variables

end variables

event open;call super::open;string ls_null
str_popup_return	popup_return
integer li_sts
string ls_drug_id

setnull(ls_null)

ls_drug_id = message.stringparm

li_sts = tab_drug_config.initialize_drug_tabs(ls_drug_id)
if li_sts <= 0 then
	Closewithreturn(this, "ERROR")
	return
end if

st_common_name.text = tab_drug_config.drug.common_name

if len(tab_drug_config.drug.generic_name) > 0 then
	st_generic_name.text = tab_drug_config.drug.generic_name
else
	st_generic_name.visible = false
	st_generic_name_title.visible = false
end if


st_title.text = wordcap(tab_drug_config.drug.drug_type) + " Definition"
end event

on w_config_drug.create
int iCurrent
call super::create
this.st_common_name_title=create st_common_name_title
this.st_title=create st_title
this.cb_ok=create cb_ok
this.st_common_name=create st_common_name
this.tab_drug_config=create tab_drug_config
this.st_generic_name_title=create st_generic_name_title
this.st_generic_name=create st_generic_name
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_common_name_title
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.cb_ok
this.Control[iCurrent+4]=this.st_common_name
this.Control[iCurrent+5]=this.tab_drug_config
this.Control[iCurrent+6]=this.st_generic_name_title
this.Control[iCurrent+7]=this.st_generic_name
this.Control[iCurrent+8]=this.cb_cancel
end on

on w_config_drug.destroy
call super::destroy
destroy(this.st_common_name_title)
destroy(this.st_title)
destroy(this.cb_ok)
destroy(this.st_common_name)
destroy(this.tab_drug_config)
destroy(this.st_generic_name_title)
destroy(this.st_generic_name)
destroy(this.cb_cancel)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_config_drug
integer width = 247
integer height = 120
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_config_drug
integer x = 18
integer y = 1588
end type

type st_common_name_title from statictext within w_config_drug
integer x = 233
integer y = 176
integer width = 398
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Trade Name:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_title from statictext within w_config_drug
integer width = 2926
integer height = 144
boolean bringtotop = true
integer textsize = -24
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Drug Definition"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_config_drug
integer x = 2469
integer y = 1664
integer width = 402
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;integer li_sts

li_sts = drugdb.update_drug(tab_drug_config.drug)
if li_sts <= 0 then
	openwithparm(w_pop_message, "Error updating drug definition")
	return
end if

closewithreturn(parent, "OK")


end event

type st_common_name from statictext within w_config_drug
integer x = 654
integer y = 168
integer width = 1952
integer height = 92
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type tab_drug_config from u_tab_drug_config within w_config_drug
integer x = 27
integer y = 400
integer width = 2848
integer height = 1172
integer taborder = 20
end type

type st_generic_name_title from statictext within w_config_drug
integer x = 178
integer y = 288
integer width = 453
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Generic Name:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_generic_name from statictext within w_config_drug
integer x = 654
integer y = 280
integer width = 1952
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_config_drug
integer x = 32
integer y = 1664
integer width = 402
integer height = 112
integer taborder = 70
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

event clicked;
closewithreturn(parent, "CANCEL")


end event

