$PBExportHeader$w_treatment_type_definition.srw
forward
global type w_treatment_type_definition from w_window_base
end type
type st_1 from statictext within w_treatment_type_definition
end type
type st_title from statictext within w_treatment_type_definition
end type
type cb_change_description from commandbutton within w_treatment_type_definition
end type
type pb_1 from u_pb_help_button within w_treatment_type_definition
end type
type tab_treatment_type from u_tab_treatment_type within w_treatment_type_definition
end type
type tab_treatment_type from u_tab_treatment_type within w_treatment_type_definition
end type
type cb_ok from commandbutton within w_treatment_type_definition
end type
type cb_cancel from commandbutton within w_treatment_type_definition
end type
type st_description from statictext within w_treatment_type_definition
end type
end forward

global type w_treatment_type_definition from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_1 st_1
st_title st_title
cb_change_description cb_change_description
pb_1 pb_1
tab_treatment_type tab_treatment_type
cb_ok cb_ok
cb_cancel cb_cancel
st_description st_description
end type
global w_treatment_type_definition w_treatment_type_definition

type variables
string treatment_type

end variables

event open;call super::open;str_popup popup
integer li_sts

popup = message.powerobjectparm

if popup.data_row_count <> 1 then
	log.log(this, "open", "Invalid parameters", 4)
	close(this)
	return
end if

treatment_type = popup.items[1]

if isnull(treatment_type) then
	log.log(this, "open", "Null treatment_type", 4)
	close(this)
	return
end if

st_description.text = datalist.treatment_type_description(treatment_type)

li_sts = tab_treatment_type.initialize(treatment_type)
if li_sts <= 0 then
	log.log(this, "open", "Error initializing tabs (" + treatment_type + ")", 4)
	close(this)
	return
end if


end event

on w_treatment_type_definition.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_title=create st_title
this.cb_change_description=create cb_change_description
this.pb_1=create pb_1
this.tab_treatment_type=create tab_treatment_type
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.st_description=create st_description
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.cb_change_description
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.tab_treatment_type
this.Control[iCurrent+6]=this.cb_ok
this.Control[iCurrent+7]=this.cb_cancel
this.Control[iCurrent+8]=this.st_description
end on

on w_treatment_type_definition.destroy
call super::destroy
destroy(this.st_1)
destroy(this.st_title)
destroy(this.cb_change_description)
destroy(this.pb_1)
destroy(this.tab_treatment_type)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.st_description)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_treatment_type_definition
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_treatment_type_definition
end type

type st_1 from statictext within w_treatment_type_definition
integer x = 142
integer y = 180
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
string text = "Description:"
boolean focusrectangle = false
end type

type st_title from statictext within w_treatment_type_definition
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
string text = "Treatment Type Definition"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_change_description from commandbutton within w_treatment_type_definition
integer x = 2537
integer y = 268
integer width = 256
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Change"
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.title = "Enter new Encounter Type description"
popup.item = st_description.text

openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

st_description.text = popup_return.items[1]

UPDATE c_Treatment_Type
SET description = :popup_return.items[1]
WHERE treatment_type = :treatment_type;
if not tf_check() then return

datalist.clear_cache("treatment_types")

end event

type pb_1 from u_pb_help_button within w_treatment_type_definition
integer x = 2656
integer y = 24
integer taborder = 30
boolean bringtotop = true
end type

type tab_treatment_type from u_tab_treatment_type within w_treatment_type_definition
integer x = 27
integer y = 400
integer width = 2848
integer height = 1172
integer taborder = 20
boolean bringtotop = true
end type

type cb_ok from commandbutton within w_treatment_type_definition
integer x = 2450
integer y = 1656
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

event clicked;str_popup_return popup_return
integer li_sts

popup_return.item_count = 1
popup_return.items[1] = treatment_type
popup_return.descriptions[1] = st_description.text

closewithreturn(parent, popup_return)


end event

type cb_cancel from commandbutton within w_treatment_type_definition
integer x = 37
integer y = 1656
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
string text = "Cancel"
boolean cancel = true
end type

event clicked;str_popup_return popup_return

setnull(popup_return.item)
popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type st_description from statictext within w_treatment_type_definition
integer x = 142
integer y = 264
integer width = 2368
integer height = 92
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
boolean focusrectangle = false
end type

