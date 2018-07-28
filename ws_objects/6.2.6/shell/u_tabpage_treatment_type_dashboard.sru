HA$PBExportHeader$u_tabpage_treatment_type_dashboard.sru
forward
global type u_tabpage_treatment_type_dashboard from u_tabpage
end type
type st_prop_2_height_percent from statictext within u_tabpage_treatment_type_dashboard
end type
type st_prop_1_height_percent from statictext within u_tabpage_treatment_type_dashboard
end type
type st_prop_1_min_height from statictext within u_tabpage_treatment_type_dashboard
end type
type st_prop_2_height_percent_title from statictext within u_tabpage_treatment_type_dashboard
end type
type st_prop_1_height_percent_title from statictext within u_tabpage_treatment_type_dashboard
end type
type st_prop_1_min_height_title from statictext within u_tabpage_treatment_type_dashboard
end type
type st_5 from statictext within u_tabpage_treatment_type_dashboard
end type
type st_properties_width from statictext within u_tabpage_treatment_type_dashboard
end type
type st_properties_width_title from statictext within u_tabpage_treatment_type_dashboard
end type
type st_header_height_title from statictext within u_tabpage_treatment_type_dashboard
end type
type st_header_height from statictext within u_tabpage_treatment_type_dashboard
end type
type cb_clear_prop_3 from commandbutton within u_tabpage_treatment_type_dashboard
end type
type cb_config_prop_3 from commandbutton within u_tabpage_treatment_type_dashboard
end type
type st_prop_datawindow_3_title from statictext within u_tabpage_treatment_type_dashboard
end type
type st_prop_datawindow_3 from statictext within u_tabpage_treatment_type_dashboard
end type
type cb_clear_prop_2 from commandbutton within u_tabpage_treatment_type_dashboard
end type
type cb_config_prop_2 from commandbutton within u_tabpage_treatment_type_dashboard
end type
type st_prop_datawindow_2_title from statictext within u_tabpage_treatment_type_dashboard
end type
type st_prop_datawindow_2 from statictext within u_tabpage_treatment_type_dashboard
end type
type st_prop_datawindow_1 from statictext within u_tabpage_treatment_type_dashboard
end type
type st_prop_datawindow_1_title from statictext within u_tabpage_treatment_type_dashboard
end type
type cb_config_prop_1 from commandbutton within u_tabpage_treatment_type_dashboard
end type
type cb_clear_prop_1 from commandbutton within u_tabpage_treatment_type_dashboard
end type
type st_body_datawindow from statictext within u_tabpage_treatment_type_dashboard
end type
type st_body_datawindow_title from statictext within u_tabpage_treatment_type_dashboard
end type
type cb_config_body from commandbutton within u_tabpage_treatment_type_dashboard
end type
type cb_clear_body from commandbutton within u_tabpage_treatment_type_dashboard
end type
type st_1 from statictext within u_tabpage_treatment_type_dashboard
end type
type cb_clear_header from commandbutton within u_tabpage_treatment_type_dashboard
end type
type cb_config_header from commandbutton within u_tabpage_treatment_type_dashboard
end type
type st_header_datawindow_title from statictext within u_tabpage_treatment_type_dashboard
end type
type st_header_datawindow from statictext within u_tabpage_treatment_type_dashboard
end type
end forward

global type u_tabpage_treatment_type_dashboard from u_tabpage
integer width = 4398
integer height = 1700
st_prop_2_height_percent st_prop_2_height_percent
st_prop_1_height_percent st_prop_1_height_percent
st_prop_1_min_height st_prop_1_min_height
st_prop_2_height_percent_title st_prop_2_height_percent_title
st_prop_1_height_percent_title st_prop_1_height_percent_title
st_prop_1_min_height_title st_prop_1_min_height_title
st_5 st_5
st_properties_width st_properties_width
st_properties_width_title st_properties_width_title
st_header_height_title st_header_height_title
st_header_height st_header_height
cb_clear_prop_3 cb_clear_prop_3
cb_config_prop_3 cb_config_prop_3
st_prop_datawindow_3_title st_prop_datawindow_3_title
st_prop_datawindow_3 st_prop_datawindow_3
cb_clear_prop_2 cb_clear_prop_2
cb_config_prop_2 cb_config_prop_2
st_prop_datawindow_2_title st_prop_datawindow_2_title
st_prop_datawindow_2 st_prop_datawindow_2
st_prop_datawindow_1 st_prop_datawindow_1
st_prop_datawindow_1_title st_prop_datawindow_1_title
cb_config_prop_1 cb_config_prop_1
cb_clear_prop_1 cb_clear_prop_1
st_body_datawindow st_body_datawindow
st_body_datawindow_title st_body_datawindow_title
cb_config_body cb_config_body
cb_clear_body cb_clear_body
st_1 st_1
cb_clear_header cb_clear_header
cb_config_header cb_config_header
st_header_datawindow_title st_header_datawindow_title
st_header_datawindow st_header_datawindow
end type
global u_tabpage_treatment_type_dashboard u_tabpage_treatment_type_dashboard

type variables
string treatment_type

string header_datawindow
string body_datawindow
string prop_1_datawindow
string prop_2_datawindow
string prop_3_datawindow

string tt_preference_type = "Preferences"
string tt_preference_level = "TreatType"

string header_datawindow_preference_id = "header_datawindow"
string body_datawindow_preference_id = "body_datawindow"
string prop_1_datawindow_preference_id = "prop_1_datawindow"
string prop_2_datawindow_preference_id = "prop_2_datawindow"
string prop_3_datawindow_preference_id = "prop_3_datawindow"

long header_height
string header_datawindow_height_preference_id = "header_datawindow_height"

long prop_width
string properties_datawindow_width_preference_id = "properties_datawindow_width"

long prop1_min_height
long prop1_height_percent
long prop2_height_percent
string prop_1_datawindow_min_height_preference_id = "prop_1_datawindow_min_height"
string prop_1_datawindow_height_percent_preference_id = "prop_1_datawindow_height_percent"
string prop_2_datawindow_height_percent_preference_id = "prop_2_datawindow_height_percent"

end variables
forward prototypes
public subroutine refresh ()
public function integer initialize (string ps_key)
end prototypes

public subroutine refresh ();string ls_temp

header_datawindow = f_get_specific_preference(tt_preference_type, tt_preference_level, treatment_type, header_datawindow_preference_id)
if isnull(header_datawindow) then
	st_header_datawindow.text = ""
	cb_config_header.visible = false
	cb_clear_header.visible = false
else
	st_header_datawindow.text = datalist.config_object_description(header_datawindow)
	cb_config_header.visible = true
	cb_clear_header.visible = true
end if

body_datawindow = f_get_specific_preference(tt_preference_type, tt_preference_level, treatment_type, body_datawindow_preference_id)
if isnull(body_datawindow) then
	st_body_datawindow.text = ""
	cb_config_body.visible = false
	cb_clear_body.visible = false
else
	st_body_datawindow.text = datalist.config_object_description(body_datawindow)
	cb_config_body.visible = true
	cb_clear_body.visible = true
end if

prop_1_datawindow = f_get_specific_preference(tt_preference_type, tt_preference_level, treatment_type, prop_1_datawindow_preference_id)
if isnull(prop_1_datawindow) then
	st_prop_datawindow_1.text = ""
	cb_config_prop_1.visible = false
	cb_clear_prop_1.visible = false
else
	st_prop_datawindow_1.text = datalist.config_object_description(prop_1_datawindow)
	cb_config_prop_1.visible = true
	cb_clear_prop_1.visible = true
end if

prop_2_datawindow = f_get_specific_preference(tt_preference_type, tt_preference_level, treatment_type, prop_2_datawindow_preference_id)
if isnull(prop_2_datawindow) then
	st_prop_datawindow_2.text = ""
	cb_config_prop_2.visible = false
	cb_clear_prop_2.visible = false
else
	st_prop_datawindow_2.text = datalist.config_object_description(prop_2_datawindow)
	cb_config_prop_2.visible = true
	cb_clear_prop_2.visible = true
end if

prop_3_datawindow = f_get_specific_preference(tt_preference_type, tt_preference_level, treatment_type, prop_3_datawindow_preference_id)
if isnull(prop_3_datawindow) then
	st_prop_datawindow_3.text = ""
	cb_config_prop_3.visible = false
	cb_clear_prop_3.visible = false
else
	st_prop_datawindow_3.text = datalist.config_object_description(prop_3_datawindow)
	cb_config_prop_3.visible = true
	cb_clear_prop_3.visible = true
end if

ls_temp = f_get_specific_preference(tt_preference_type, tt_preference_level, treatment_type, header_datawindow_height_preference_id)
if not isnull(ls_temp) and isnumber(ls_temp) then
	header_height = long(ls_temp)
	st_header_height.text = ls_temp
else
	setnull(header_height)
end if

ls_temp = f_get_specific_preference(tt_preference_type, tt_preference_level, treatment_type, properties_datawindow_width_preference_id)
if not isnull(ls_temp) and isnumber(ls_temp) then
	prop_width = long(ls_temp)
	st_properties_width.text = ls_temp
else
	setnull(prop_width)
end if

ls_temp = f_get_specific_preference(tt_preference_type, tt_preference_level, treatment_type, prop_1_datawindow_min_height_preference_id)
if not isnull(ls_temp) and isnumber(ls_temp) then
	prop1_min_height = long(ls_temp)
	st_prop_1_min_height.text = ls_temp
else
	setnull(prop1_min_height)
end if

ls_temp = f_get_specific_preference(tt_preference_type, tt_preference_level, treatment_type, prop_1_datawindow_height_percent_preference_id)
if not isnull(ls_temp) and isnumber(ls_temp) then
	prop1_height_percent = long(ls_temp)
	st_prop_1_height_percent.text = ls_temp
else
	setnull(prop1_height_percent)
end if

ls_temp = f_get_specific_preference(tt_preference_type, tt_preference_level, treatment_type, prop_2_datawindow_height_percent_preference_id)
if not isnull(ls_temp) and isnumber(ls_temp) then
	prop2_height_percent = long(ls_temp)
	st_prop_2_height_percent.text = ls_temp
else
	setnull(prop2_height_percent)
end if

end subroutine

public function integer initialize (string ps_key);treatment_type = ps_key

return 1

end function

on u_tabpage_treatment_type_dashboard.create
int iCurrent
call super::create
this.st_prop_2_height_percent=create st_prop_2_height_percent
this.st_prop_1_height_percent=create st_prop_1_height_percent
this.st_prop_1_min_height=create st_prop_1_min_height
this.st_prop_2_height_percent_title=create st_prop_2_height_percent_title
this.st_prop_1_height_percent_title=create st_prop_1_height_percent_title
this.st_prop_1_min_height_title=create st_prop_1_min_height_title
this.st_5=create st_5
this.st_properties_width=create st_properties_width
this.st_properties_width_title=create st_properties_width_title
this.st_header_height_title=create st_header_height_title
this.st_header_height=create st_header_height
this.cb_clear_prop_3=create cb_clear_prop_3
this.cb_config_prop_3=create cb_config_prop_3
this.st_prop_datawindow_3_title=create st_prop_datawindow_3_title
this.st_prop_datawindow_3=create st_prop_datawindow_3
this.cb_clear_prop_2=create cb_clear_prop_2
this.cb_config_prop_2=create cb_config_prop_2
this.st_prop_datawindow_2_title=create st_prop_datawindow_2_title
this.st_prop_datawindow_2=create st_prop_datawindow_2
this.st_prop_datawindow_1=create st_prop_datawindow_1
this.st_prop_datawindow_1_title=create st_prop_datawindow_1_title
this.cb_config_prop_1=create cb_config_prop_1
this.cb_clear_prop_1=create cb_clear_prop_1
this.st_body_datawindow=create st_body_datawindow
this.st_body_datawindow_title=create st_body_datawindow_title
this.cb_config_body=create cb_config_body
this.cb_clear_body=create cb_clear_body
this.st_1=create st_1
this.cb_clear_header=create cb_clear_header
this.cb_config_header=create cb_config_header
this.st_header_datawindow_title=create st_header_datawindow_title
this.st_header_datawindow=create st_header_datawindow
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_prop_2_height_percent
this.Control[iCurrent+2]=this.st_prop_1_height_percent
this.Control[iCurrent+3]=this.st_prop_1_min_height
this.Control[iCurrent+4]=this.st_prop_2_height_percent_title
this.Control[iCurrent+5]=this.st_prop_1_height_percent_title
this.Control[iCurrent+6]=this.st_prop_1_min_height_title
this.Control[iCurrent+7]=this.st_5
this.Control[iCurrent+8]=this.st_properties_width
this.Control[iCurrent+9]=this.st_properties_width_title
this.Control[iCurrent+10]=this.st_header_height_title
this.Control[iCurrent+11]=this.st_header_height
this.Control[iCurrent+12]=this.cb_clear_prop_3
this.Control[iCurrent+13]=this.cb_config_prop_3
this.Control[iCurrent+14]=this.st_prop_datawindow_3_title
this.Control[iCurrent+15]=this.st_prop_datawindow_3
this.Control[iCurrent+16]=this.cb_clear_prop_2
this.Control[iCurrent+17]=this.cb_config_prop_2
this.Control[iCurrent+18]=this.st_prop_datawindow_2_title
this.Control[iCurrent+19]=this.st_prop_datawindow_2
this.Control[iCurrent+20]=this.st_prop_datawindow_1
this.Control[iCurrent+21]=this.st_prop_datawindow_1_title
this.Control[iCurrent+22]=this.cb_config_prop_1
this.Control[iCurrent+23]=this.cb_clear_prop_1
this.Control[iCurrent+24]=this.st_body_datawindow
this.Control[iCurrent+25]=this.st_body_datawindow_title
this.Control[iCurrent+26]=this.cb_config_body
this.Control[iCurrent+27]=this.cb_clear_body
this.Control[iCurrent+28]=this.st_1
this.Control[iCurrent+29]=this.cb_clear_header
this.Control[iCurrent+30]=this.cb_config_header
this.Control[iCurrent+31]=this.st_header_datawindow_title
this.Control[iCurrent+32]=this.st_header_datawindow
end on

on u_tabpage_treatment_type_dashboard.destroy
call super::destroy
destroy(this.st_prop_2_height_percent)
destroy(this.st_prop_1_height_percent)
destroy(this.st_prop_1_min_height)
destroy(this.st_prop_2_height_percent_title)
destroy(this.st_prop_1_height_percent_title)
destroy(this.st_prop_1_min_height_title)
destroy(this.st_5)
destroy(this.st_properties_width)
destroy(this.st_properties_width_title)
destroy(this.st_header_height_title)
destroy(this.st_header_height)
destroy(this.cb_clear_prop_3)
destroy(this.cb_config_prop_3)
destroy(this.st_prop_datawindow_3_title)
destroy(this.st_prop_datawindow_3)
destroy(this.cb_clear_prop_2)
destroy(this.cb_config_prop_2)
destroy(this.st_prop_datawindow_2_title)
destroy(this.st_prop_datawindow_2)
destroy(this.st_prop_datawindow_1)
destroy(this.st_prop_datawindow_1_title)
destroy(this.cb_config_prop_1)
destroy(this.cb_clear_prop_1)
destroy(this.st_body_datawindow)
destroy(this.st_body_datawindow_title)
destroy(this.cb_config_body)
destroy(this.cb_clear_body)
destroy(this.st_1)
destroy(this.cb_clear_header)
destroy(this.cb_config_header)
destroy(this.st_header_datawindow_title)
destroy(this.st_header_datawindow)
end on

type st_prop_2_height_percent from statictext within u_tabpage_treatment_type_dashboard
integer x = 3264
integer y = 792
integer width = 402
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.realitem = real(prop2_height_percent)
openwithparm(w_number, popup)
popup_return = message.powerobjectparm
if popup_return.item <> "OK" then return

prop2_height_percent = integer(popup_return.realitem)
text = string(prop2_height_percent)

sqlca.sp_set_preference(tt_preference_type, tt_preference_level, treatment_type, prop_2_datawindow_height_percent_preference_id, string(prop2_height_percent))
if not tf_check() then return

refresh()

end event

type st_prop_1_height_percent from statictext within u_tabpage_treatment_type_dashboard
integer x = 3264
integer y = 628
integer width = 402
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.realitem = real(prop1_height_percent)
openwithparm(w_number, popup)
popup_return = message.powerobjectparm
if popup_return.item <> "OK" then return

prop1_height_percent = integer(popup_return.realitem)
text = string(prop1_height_percent)

sqlca.sp_set_preference(tt_preference_type, tt_preference_level, treatment_type, prop_1_datawindow_height_percent_preference_id, string(prop1_height_percent))
if not tf_check() then return

refresh()

end event

type st_prop_1_min_height from statictext within u_tabpage_treatment_type_dashboard
integer x = 3264
integer y = 464
integer width = 402
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.realitem = real(prop1_min_height)
openwithparm(w_number, popup)
popup_return = message.powerobjectparm
if popup_return.item <> "OK" then return

prop1_min_height = integer(popup_return.realitem)
text = string(prop1_min_height)

sqlca.sp_set_preference(tt_preference_type, tt_preference_level, treatment_type, prop_1_datawindow_min_height_preference_id, string(prop1_min_height))
if not tf_check() then return

refresh()

end event

type st_prop_2_height_percent_title from statictext within u_tabpage_treatment_type_dashboard
integer x = 2432
integer y = 808
integer width = 809
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Properties 2 Height Percent"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_prop_1_height_percent_title from statictext within u_tabpage_treatment_type_dashboard
integer x = 2432
integer y = 644
integer width = 809
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Properties 1 Height Percent"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_prop_1_min_height_title from statictext within u_tabpage_treatment_type_dashboard
integer x = 2432
integer y = 480
integer width = 809
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Properties 1 Min height"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_5 from statictext within u_tabpage_treatment_type_dashboard
integer x = 5705
integer y = 384
integer width = 402
integer height = 104
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "none"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_properties_width from statictext within u_tabpage_treatment_type_dashboard
integer x = 3264
integer y = 300
integer width = 402
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.realitem = real(prop_width)
openwithparm(w_number, popup)
popup_return = message.powerobjectparm
if popup_return.item <> "OK" then return

prop_width = integer(popup_return.realitem)
text = string(prop_width)

sqlca.sp_set_preference(tt_preference_type, tt_preference_level, treatment_type, properties_datawindow_width_preference_id, string(prop_width))
if not tf_check() then return

refresh()

end event

type st_properties_width_title from statictext within u_tabpage_treatment_type_dashboard
integer x = 2432
integer y = 316
integer width = 809
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Properties Width"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_header_height_title from statictext within u_tabpage_treatment_type_dashboard
integer x = 2432
integer y = 152
integer width = 809
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Header Height"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_header_height from statictext within u_tabpage_treatment_type_dashboard
integer x = 3264
integer y = 136
integer width = 402
integer height = 104
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.realitem = real(header_height)
openwithparm(w_number, popup)
popup_return = message.powerobjectparm
if popup_return.item <> "OK" then return

header_height = integer(popup_return.realitem)
text = string(header_height)

sqlca.sp_set_preference(tt_preference_type, tt_preference_level, treatment_type, header_datawindow_height_preference_id, string(header_height))
if not tf_check() then return

refresh()

end event

type cb_clear_prop_3 from commandbutton within u_tabpage_treatment_type_dashboard
integer x = 2034
integer y = 828
integer width = 229
integer height = 68
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;st_prop_datawindow_3.text = ""
setnull(prop_3_datawindow)

sqlca.sp_set_preference(tt_preference_type, tt_preference_level, treatment_type, prop_3_datawindow_preference_id, prop_3_datawindow)
if not tf_check() then return

refresh()




end event

type cb_config_prop_3 from commandbutton within u_tabpage_treatment_type_dashboard
integer x = 1792
integer y = 828
integer width = 229
integer height = 68
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Config"
end type

event clicked;f_configure_config_object(prop_3_datawindow)

end event

type st_prop_datawindow_3_title from statictext within u_tabpage_treatment_type_dashboard
integer x = 14
integer y = 808
integer width = 558
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Properties 3"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_prop_datawindow_3 from statictext within u_tabpage_treatment_type_dashboard
integer x = 590
integer y = 792
integer width = 1189
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup_return	popup_return
string ls_observation_id
string ls_description
long ll_row
string ls_composite_flag
long i
string ls_treatment_type
w_window_base lw_pick
str_pick_config_object lstr_pick_config_object


lstr_pick_config_object.config_object_type = "Datawindow"
lstr_pick_config_object.context_object = "Treatment"

openwithparm(lw_pick, lstr_pick_config_object, "w_pick_config_object")
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

this.text = popup_return.descriptions[1]
prop_3_datawindow = popup_return.items[1]


sqlca.sp_set_preference(tt_preference_type, tt_preference_level, treatment_type, prop_3_datawindow_preference_id, prop_3_datawindow)
if not tf_check() then return

refresh()

end event

type cb_clear_prop_2 from commandbutton within u_tabpage_treatment_type_dashboard
integer x = 2034
integer y = 664
integer width = 229
integer height = 68
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;st_prop_datawindow_2.text = ""
setnull(prop_2_datawindow)

sqlca.sp_set_preference(tt_preference_type, tt_preference_level, treatment_type, prop_2_datawindow_preference_id, prop_2_datawindow)
if not tf_check() then return

refresh()




end event

type cb_config_prop_2 from commandbutton within u_tabpage_treatment_type_dashboard
integer x = 1792
integer y = 664
integer width = 229
integer height = 68
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Config"
end type

event clicked;f_configure_config_object(prop_2_datawindow)

end event

type st_prop_datawindow_2_title from statictext within u_tabpage_treatment_type_dashboard
integer x = 14
integer y = 644
integer width = 558
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Properties 2"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_prop_datawindow_2 from statictext within u_tabpage_treatment_type_dashboard
integer x = 590
integer y = 628
integer width = 1189
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup_return	popup_return
string ls_observation_id
string ls_description
long ll_row
string ls_composite_flag
long i
string ls_treatment_type
w_window_base lw_pick
str_pick_config_object lstr_pick_config_object


lstr_pick_config_object.config_object_type = "Datawindow"
lstr_pick_config_object.context_object = "Treatment"

openwithparm(lw_pick, lstr_pick_config_object, "w_pick_config_object")
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

this.text = popup_return.descriptions[1]
prop_2_datawindow = popup_return.items[1]


sqlca.sp_set_preference(tt_preference_type, tt_preference_level, treatment_type, prop_2_datawindow_preference_id, prop_2_datawindow)
if not tf_check() then return

refresh()

end event

type st_prop_datawindow_1 from statictext within u_tabpage_treatment_type_dashboard
integer x = 590
integer y = 464
integer width = 1189
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup_return	popup_return
string ls_observation_id
string ls_description
long ll_row
string ls_composite_flag
long i
string ls_treatment_type
w_window_base lw_pick
str_pick_config_object lstr_pick_config_object


lstr_pick_config_object.config_object_type = "Datawindow"
lstr_pick_config_object.context_object = "Treatment"

openwithparm(lw_pick, lstr_pick_config_object, "w_pick_config_object")
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

this.text = popup_return.descriptions[1]
prop_1_datawindow = popup_return.items[1]


sqlca.sp_set_preference(tt_preference_type, tt_preference_level, treatment_type, prop_1_datawindow_preference_id, prop_1_datawindow)
if not tf_check() then return

refresh()

end event

type st_prop_datawindow_1_title from statictext within u_tabpage_treatment_type_dashboard
integer x = 14
integer y = 480
integer width = 558
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Properties 1"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_config_prop_1 from commandbutton within u_tabpage_treatment_type_dashboard
integer x = 1792
integer y = 500
integer width = 229
integer height = 68
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Config"
end type

event clicked;f_configure_config_object(prop_1_datawindow)

end event

type cb_clear_prop_1 from commandbutton within u_tabpage_treatment_type_dashboard
integer x = 2034
integer y = 500
integer width = 229
integer height = 68
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;st_prop_datawindow_1.text = ""
setnull(prop_1_datawindow)

sqlca.sp_set_preference(tt_preference_type, tt_preference_level, treatment_type, prop_1_datawindow_preference_id, prop_1_datawindow)
if not tf_check() then return

refresh()




end event

type st_body_datawindow from statictext within u_tabpage_treatment_type_dashboard
integer x = 590
integer y = 300
integer width = 1189
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup_return	popup_return
string ls_observation_id
string ls_description
long ll_row
string ls_composite_flag
long i
string ls_treatment_type
w_window_base lw_pick
str_pick_config_object lstr_pick_config_object


lstr_pick_config_object.config_object_type = "Datawindow"
lstr_pick_config_object.context_object = "Treatment"

openwithparm(lw_pick, lstr_pick_config_object, "w_pick_config_object")
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

this.text = popup_return.descriptions[1]
body_datawindow = popup_return.items[1]


sqlca.sp_set_preference(tt_preference_type, tt_preference_level, treatment_type, body_datawindow_preference_id, body_datawindow)
if not tf_check() then return

refresh()

end event

type st_body_datawindow_title from statictext within u_tabpage_treatment_type_dashboard
integer x = 14
integer y = 316
integer width = 558
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Body"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_config_body from commandbutton within u_tabpage_treatment_type_dashboard
integer x = 1792
integer y = 336
integer width = 229
integer height = 68
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Config"
end type

event clicked;f_configure_config_object(body_datawindow)

end event

type cb_clear_body from commandbutton within u_tabpage_treatment_type_dashboard
integer x = 2034
integer y = 336
integer width = 229
integer height = 68
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;st_body_datawindow.text = ""
setnull(body_datawindow)

sqlca.sp_set_preference(tt_preference_type, tt_preference_level, treatment_type, body_datawindow_preference_id, body_datawindow)
if not tf_check() then return

refresh()




end event

type st_1 from statictext within u_tabpage_treatment_type_dashboard
integer x = 210
integer y = 20
integer width = 2085
integer height = 116
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 33538240
string text = "Dashboard Datawindows"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_clear_header from commandbutton within u_tabpage_treatment_type_dashboard
integer x = 2034
integer y = 172
integer width = 229
integer height = 68
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;st_header_datawindow.text = ""
setnull(header_datawindow)

sqlca.sp_set_preference(tt_preference_type, tt_preference_level, treatment_type, header_datawindow_preference_id, header_datawindow)
if not tf_check() then return

refresh()




end event

type cb_config_header from commandbutton within u_tabpage_treatment_type_dashboard
integer x = 1792
integer y = 172
integer width = 229
integer height = 68
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Config"
end type

event clicked;f_configure_config_object(header_datawindow)

end event

type st_header_datawindow_title from statictext within u_tabpage_treatment_type_dashboard
integer x = 14
integer y = 152
integer width = 558
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Header"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_header_datawindow from statictext within u_tabpage_treatment_type_dashboard
integer x = 590
integer y = 136
integer width = 1189
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup_return	popup_return
string ls_observation_id
string ls_description
long ll_row
string ls_composite_flag
long i
string ls_treatment_type
w_window_base lw_pick
str_pick_config_object lstr_pick_config_object


lstr_pick_config_object.config_object_type = "Datawindow"
lstr_pick_config_object.context_object = "Treatment"

openwithparm(lw_pick, lstr_pick_config_object, "w_pick_config_object")
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

this.text = popup_return.descriptions[1]
header_datawindow = popup_return.items[1]


sqlca.sp_set_preference(tt_preference_type, tt_preference_level, treatment_type, header_datawindow_preference_id, header_datawindow)
if not tf_check() then return

refresh()

end event

