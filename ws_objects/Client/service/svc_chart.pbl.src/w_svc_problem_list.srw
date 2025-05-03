$PBExportHeader$w_svc_problem_list.srw
forward
global type w_svc_problem_list from w_window_base
end type
type st_assessment_type_title from statictext within w_svc_problem_list
end type
type st_open from statictext within w_svc_problem_list
end type
type st_closed from statictext within w_svc_problem_list
end type
type st_open_treatments from statictext within w_svc_problem_list
end type
type st_all_treatments from statictext within w_svc_problem_list
end type
type st_page from statictext within w_svc_problem_list
end type
type pb_down from u_picture_button within w_svc_problem_list
end type
type cb_finished from commandbutton within w_svc_problem_list
end type
type cb_be_back from commandbutton within w_svc_problem_list
end type
type p_atat from picture within w_svc_problem_list
end type
type p_aatt from picture within w_svc_problem_list
end type
type p_aa from picture within w_svc_problem_list
end type
type p_tt from picture within w_svc_problem_list
end type
type pb_up from u_picture_button within w_svc_problem_list
end type
type st_assessment_type from statictext within w_svc_problem_list
end type
type st_3 from statictext within w_svc_problem_list
end type
type st_4 from statictext within w_svc_problem_list
end type
type st_treatment_type from statictext within w_svc_problem_list
end type
type st_all from statictext within w_svc_problem_list
end type
type st_closed_treatments from statictext within w_svc_problem_list
end type
type dw_soap from u_soap_display within w_svc_problem_list
end type
end forward

global type w_svc_problem_list from w_window_base
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string button_type = "COMMAND"
integer max_buttons = 3
st_assessment_type_title st_assessment_type_title
st_open st_open
st_closed st_closed
st_open_treatments st_open_treatments
st_all_treatments st_all_treatments
st_page st_page
pb_down pb_down
cb_finished cb_finished
cb_be_back cb_be_back
p_atat p_atat
p_aatt p_aatt
p_aa p_aa
p_tt p_tt
pb_up pb_up
st_assessment_type st_assessment_type
st_3 st_3
st_4 st_4
st_treatment_type st_treatment_type
st_all st_all
st_closed_treatments st_closed_treatments
dw_soap dw_soap
end type
global w_svc_problem_list w_svc_problem_list

type variables
u_component_service service

string assessment_type
string assessment_status

string treatment_type
string treatment_status

string display_mode

end variables

forward prototypes
public function integer refresh_display ()
end prototypes

public function integer refresh_display ();long ll_page

ll_page = dw_soap.current_page
if ll_page <= 0 then ll_page = 1

dw_soap.setredraw(false)

dw_soap.load_patient(display_mode, assessment_type, assessment_status, treatment_type, treatment_status)

dw_soap.last_page = 0
dw_soap.set_page(ll_page, pb_up, pb_down, st_page)

dw_soap.setredraw(true)

return 1


end function

on w_svc_problem_list.create
int iCurrent
call super::create
this.st_assessment_type_title=create st_assessment_type_title
this.st_open=create st_open
this.st_closed=create st_closed
this.st_open_treatments=create st_open_treatments
this.st_all_treatments=create st_all_treatments
this.st_page=create st_page
this.pb_down=create pb_down
this.cb_finished=create cb_finished
this.cb_be_back=create cb_be_back
this.p_atat=create p_atat
this.p_aatt=create p_aatt
this.p_aa=create p_aa
this.p_tt=create p_tt
this.pb_up=create pb_up
this.st_assessment_type=create st_assessment_type
this.st_3=create st_3
this.st_4=create st_4
this.st_treatment_type=create st_treatment_type
this.st_all=create st_all
this.st_closed_treatments=create st_closed_treatments
this.dw_soap=create dw_soap
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_assessment_type_title
this.Control[iCurrent+2]=this.st_open
this.Control[iCurrent+3]=this.st_closed
this.Control[iCurrent+4]=this.st_open_treatments
this.Control[iCurrent+5]=this.st_all_treatments
this.Control[iCurrent+6]=this.st_page
this.Control[iCurrent+7]=this.pb_down
this.Control[iCurrent+8]=this.cb_finished
this.Control[iCurrent+9]=this.cb_be_back
this.Control[iCurrent+10]=this.p_atat
this.Control[iCurrent+11]=this.p_aatt
this.Control[iCurrent+12]=this.p_aa
this.Control[iCurrent+13]=this.p_tt
this.Control[iCurrent+14]=this.pb_up
this.Control[iCurrent+15]=this.st_assessment_type
this.Control[iCurrent+16]=this.st_3
this.Control[iCurrent+17]=this.st_4
this.Control[iCurrent+18]=this.st_treatment_type
this.Control[iCurrent+19]=this.st_all
this.Control[iCurrent+20]=this.st_closed_treatments
this.Control[iCurrent+21]=this.dw_soap
end on

on w_svc_problem_list.destroy
call super::destroy
destroy(this.st_assessment_type_title)
destroy(this.st_open)
destroy(this.st_closed)
destroy(this.st_open_treatments)
destroy(this.st_all_treatments)
destroy(this.st_page)
destroy(this.pb_down)
destroy(this.cb_finished)
destroy(this.cb_be_back)
destroy(this.p_atat)
destroy(this.p_aatt)
destroy(this.p_aa)
destroy(this.p_tt)
destroy(this.pb_up)
destroy(this.st_assessment_type)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_treatment_type)
destroy(this.st_all)
destroy(this.st_closed_treatments)
destroy(this.dw_soap)
end on

event open;call super::open;long ll_rows
long i
string ls_treatment_type
string ls_find
long ll_row
string ls_temp
long ll_menu_id

service = message.powerobjectparm

// Set the title and sizes
If isvalid(current_patient) and not isnull(current_patient) Then
	title = current_patient.id_line()
End If


assessment_status = service.get_attribute("assessment_status")
if upper(assessment_status) = "OPEN" then
	assessment_status = "OPEN"
	st_open.backcolor = color_object_selected
elseif upper(assessment_status) = "CLOSED" then
	assessment_status = "CLOSED"
	st_closed.backcolor = color_object_selected
else
	setnull(assessment_status)
	st_all.backcolor = color_object_selected
end if

treatment_status = service.get_attribute("treatment_status")
if upper(treatment_status) = "OPEN" then
	treatment_status = "OPEN"
	st_open_treatments.backcolor = color_object_selected
elseif upper(treatment_status) = "CLOSED" then
	treatment_status = "CLOSED"
	st_closed_treatments.backcolor = color_object_selected
else
	setnull(treatment_status)
	st_all_treatments.backcolor = color_object_selected
end if

assessment_type = service.get_attribute("assessment_type")
if isnull(assessment_type) or upper(assessment_type) = "<ALL>" then
	setnull(assessment_type)
	st_assessment_type.text = "<All Types>"
else
	st_assessment_type.text = datalist.assessment_type_description( assessment_type)
end if

treatment_type = service.get_attribute("treatment_type")
if isnull(treatment_type) or upper(treatment_type) = "<ALL>" then
	st_treatment_type.text = "<All Types>"
else
	st_treatment_type.text = datalist.treatment_type_description(treatment_type)
end if

display_mode = service.get_attribute("display_mode")
if isnull(display_mode) then display_mode = "ATAT"

CHOOSE CASE display_mode
	CASE "AATT"
		p_aatt.BorderStyle = StyleLowered!
	CASE "AA"
		p_aa.BorderStyle = StyleLowered!
	CASE "TT"
		p_tt.BorderStyle = StyleLowered!
	CASE ELSE
		display_mode = "ATAT"
		p_atat.BorderStyle = StyleLowered!
END CHOOSE

dw_soap.assessment_service = service.get_attribute("assessment_service")
if isnull(dw_soap.assessment_service) then dw_soap.assessment_service = "ASSESSMENT_REVIEW"

dw_soap.treatment_service = service.get_attribute("treatment_service")
if isnull(dw_soap.treatment_service) then dw_soap.treatment_service = "TREATMENT_REVIEW"

ls_temp = service.get_attribute("text_color_new")
if isnull(ls_temp) then
	dw_soap.text_color_new = rgb(0,0,255)
else
	dw_soap.text_color_new = long(ls_temp)
end if

ls_temp = service.get_attribute("back_color_services")
if isnull(ls_temp) then
	dw_soap.back_color_services = rgb(192,255,255)
else
	dw_soap.back_color_services = long(ls_temp)
end if

// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 4
end if

ll_menu_id = long(service.get_attribute("menu_id"))
paint_menu(ll_menu_id)

refresh_display()




end event

event button_pressed;call super::button_pressed;refresh_display()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_problem_list
boolean visible = true
integer x = 2674
integer y = 28
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_problem_list
integer x = 18
integer y = 1560
integer height = 56
end type

type st_assessment_type_title from statictext within w_svc_problem_list
integer x = 2235
integer y = 372
integer width = 654
integer height = 88
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
string text = "Assessments"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_open from statictext within w_svc_problem_list
integer x = 2235
integer y = 644
integer width = 206
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Open"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_closed.backcolor = color_object
st_all.backcolor = color_object
assessment_status = "OPEN"

refresh_display()

end event

type st_closed from statictext within w_svc_problem_list
integer x = 2450
integer y = 644
integer width = 224
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Closed"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_open.backcolor = color_object
st_all.backcolor = color_object
assessment_status = "CLOSED"

refresh_display()

end event

type st_open_treatments from statictext within w_svc_problem_list
integer x = 2235
integer y = 1112
integer width = 206
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Open"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_all_treatments.backcolor = color_object
st_closed_treatments.backcolor = color_object
treatment_status = "OPEN"

refresh_display()

end event

type st_all_treatments from statictext within w_svc_problem_list
integer x = 2683
integer y = 1112
integer width = 206
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "All"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_open_treatments.backcolor = color_object
st_closed_treatments.backcolor = color_object
setnull(treatment_status)

refresh_display()

end event

type st_page from statictext within w_svc_problem_list
integer x = 2222
integer y = 268
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
boolean focusrectangle = false
end type

type pb_down from u_picture_button within w_svc_problem_list
integer x = 2222
integer y = 148
integer width = 137
integer height = 116
integer taborder = 40
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_soap.current_page
li_last_page = dw_soap.last_page

dw_soap.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true


end event

type cb_finished from commandbutton within w_svc_problem_list
integer x = 2427
integer y = 1612
integer width = 443
integer height = 108
integer taborder = 30
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

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)
end event

type cb_be_back from commandbutton within w_svc_problem_list
integer x = 1961
integer y = 1612
integer width = 443
integer height = 108
integer taborder = 40
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

type p_atat from picture within w_svc_problem_list
integer x = 2254
integer y = 1352
integer width = 137
integer height = 116
boolean bringtotop = true
boolean originalsize = true
string picturename = "icon_assessments1.bmp"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;BorderStyle = StyleLowered!
p_aatt.BorderStyle = StyleRaised!
p_aa.BorderStyle = StyleRaised!
p_tt.BorderStyle = StyleRaised!

display_mode = "ATAT"
refresh_display()

end event

type p_aatt from picture within w_svc_problem_list
integer x = 2409
integer y = 1352
integer width = 137
integer height = 116
boolean bringtotop = true
boolean originalsize = true
string picturename = "icon_assessments2.bmp"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;BorderStyle = StyleLowered!
p_atat.BorderStyle = StyleRaised!
p_aa.BorderStyle = StyleRaised!
p_tt.BorderStyle = StyleRaised!

display_mode = "AATT"
refresh_display()

end event

type p_aa from picture within w_svc_problem_list
integer x = 2565
integer y = 1352
integer width = 137
integer height = 116
boolean bringtotop = true
boolean originalsize = true
string picturename = "icon_assessments3.bmp"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;BorderStyle = StyleLowered!
p_atat.BorderStyle = StyleRaised!
p_aatt.BorderStyle = StyleRaised!
p_tt.BorderStyle = StyleRaised!

display_mode = "AA"
refresh_display()

end event

type p_tt from picture within w_svc_problem_list
integer x = 2720
integer y = 1352
integer width = 137
integer height = 116
boolean bringtotop = true
boolean originalsize = true
string picturename = "icon_assessments4.bmp"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;BorderStyle = StyleLowered!
p_atat.BorderStyle = StyleRaised!
p_aatt.BorderStyle = StyleRaised!
p_aa.BorderStyle = StyleRaised!

display_mode = "TT"
refresh_display()

end event

type pb_up from u_picture_button within w_svc_problem_list
integer x = 2222
integer y = 24
integer width = 137
integer height = 116
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_soap.current_page

dw_soap.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type st_assessment_type from statictext within w_svc_problem_list
integer x = 2235
integer y = 464
integer width = 654
integer height = 164
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "<All Types>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_assessment_type_list"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.add_blank_row = true
popup.blank_text = "<All Types>"


openwithparm(w_pop_pick, popup)
popup_return = f_popup_return("w_pop_pick,w_svc_problem_list.st_assessment_type.clicked:0012")
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	text = popup.blank_text
	setnull(assessment_type)
else
	text = popup_return.descriptions[1]
	assessment_type = popup_return.items[1]
end if


refresh_display()

end event

type st_3 from statictext within w_svc_problem_list
integer x = 2235
integer y = 852
integer width = 654
integer height = 88
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
string text = "Treatments"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_svc_problem_list
integer x = 2331
integer y = 1276
integer width = 475
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
string text = "Display Mode"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_treatment_type from statictext within w_svc_problem_list
integer x = 2235
integer y = 936
integer width = 654
integer height = 164
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "<All Types>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_treatment_type_select"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.add_blank_row = true
popup.blank_text = "<All Types>"


openwithparm(w_pop_pick, popup)
popup_return = f_popup_return("w_pop_pick,w_svc_problem_list.st_treatment_type.clicked:0012")
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	text = popup.blank_text
	setnull(treatment_type)
else
	text = popup_return.descriptions[1]
	treatment_type = popup_return.items[1]
end if


refresh_display()

end event

type st_all from statictext within w_svc_problem_list
integer x = 2683
integer y = 644
integer width = 206
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "All"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_open.backcolor = color_object
st_closed.backcolor = color_object
setnull(assessment_status)

refresh_display()

end event

type st_closed_treatments from statictext within w_svc_problem_list
integer x = 2450
integer y = 1112
integer width = 224
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Closed"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_open_treatments.backcolor = color_object
st_all_treatments.backcolor = color_object
treatment_status = "CLOSED"

refresh_display()

end event

type dw_soap from u_soap_display within w_svc_problem_list
integer x = 18
integer y = 20
integer width = 2190
integer height = 1540
integer taborder = 10
end type

event selected;call super::selected;refresh_display()

end event

