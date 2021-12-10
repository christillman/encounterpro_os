$PBExportHeader$w_svc_config_procedures.srw
forward
global type w_svc_config_procedures from w_window_base
end type
type st_search_title from statictext within w_svc_config_procedures
end type
type st_procedure_type_title from statictext within w_svc_config_procedures
end type
type st_procedure_type from statictext within w_svc_config_procedures
end type
type pb_up from u_picture_button within w_svc_config_procedures
end type
type pb_down from u_picture_button within w_svc_config_procedures
end type
type st_page from statictext within w_svc_config_procedures
end type
type st_category from statictext within w_svc_config_procedures
end type
type st_top_20 from statictext within w_svc_config_procedures
end type
type st_cpt_code from statictext within w_svc_config_procedures
end type
type st_search_status from statictext within w_svc_config_procedures
end type
type st_specialty from statictext within w_svc_config_procedures
end type
type st_specialty_title from statictext within w_svc_config_procedures
end type
type st_description from statictext within w_svc_config_procedures
end type
type st_common_flag from statictext within w_svc_config_procedures
end type
type dw_procedures from u_dw_procedure_list within w_svc_config_procedures
end type
type cb_new_procedure from commandbutton within w_svc_config_procedures
end type
type cb_ok from commandbutton within w_svc_config_procedures
end type
type st_title from statictext within w_svc_config_procedures
end type
end forward

global type w_svc_config_procedures from w_window_base
integer height = 1836
windowtype windowtype = response!
st_search_title st_search_title
st_procedure_type_title st_procedure_type_title
st_procedure_type st_procedure_type
pb_up pb_up
pb_down pb_down
st_page st_page
st_category st_category
st_top_20 st_top_20
st_cpt_code st_cpt_code
st_search_status st_search_status
st_specialty st_specialty
st_specialty_title st_specialty_title
st_description st_description
st_common_flag st_common_flag
dw_procedures dw_procedures
cb_new_procedure cb_new_procedure
cb_ok cb_ok
st_title st_title
end type
global w_svc_config_procedures w_svc_config_procedures

type variables
u_component_service service

String procedure_type
string procedure_type_description
string specialty_id

string search_type

string common_flag = "Y"
end variables

event open;call super::open;
service = message.powerobjectparm


procedure_type = "PROCEDURE"
specialty_id = current_user.specialty_id
dw_procedures.specialty_id = current_user.common_list_id()

common_flag = service.get_attribute("common_flag")
if isnull(common_flag) then common_flag = "Y"
if common_flag = "Y" then
	st_common_flag.text = "Specialty"
	dw_procedures.specialty_id = current_user.common_list_id()
else
	st_common_flag.text = "All"
	setnull(dw_procedures.specialty_id)
end if

dw_procedures.mode = "EDIT"

dw_procedures.object.description.width = dw_procedures.width - 150

dw_procedures.initialize(procedure_type)

if isnull(procedure_type) then
	procedure_type_description = "<All>"
else
	procedure_type_description = datalist.procedure_type_description(procedure_type)
	if isnull(procedure_type_description) then
		setnull(procedure_type)
		procedure_type_description = "<All>"
	end if
end if

st_procedure_type.text = procedure_type_description

if isnull(current_patient) then
	title = st_title.text
else
	title = current_patient.id_line()
end if

If trim(specialty_id) = "" Then Setnull(specialty_id)
If Isnull(specialty_id) Then
	st_specialty.visible = False
	st_specialty_title.visible = False
	st_category.visible = false
Else
	st_specialty.text = datalist.specialty_description(specialty_id)
End if

dw_procedures.search_top_20()
if dw_procedures.rowcount() = 0 then
	dw_procedures.search_description("")
end if


end event

on w_svc_config_procedures.create
int iCurrent
call super::create
this.st_search_title=create st_search_title
this.st_procedure_type_title=create st_procedure_type_title
this.st_procedure_type=create st_procedure_type
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
this.st_category=create st_category
this.st_top_20=create st_top_20
this.st_cpt_code=create st_cpt_code
this.st_search_status=create st_search_status
this.st_specialty=create st_specialty
this.st_specialty_title=create st_specialty_title
this.st_description=create st_description
this.st_common_flag=create st_common_flag
this.dw_procedures=create dw_procedures
this.cb_new_procedure=create cb_new_procedure
this.cb_ok=create cb_ok
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_search_title
this.Control[iCurrent+2]=this.st_procedure_type_title
this.Control[iCurrent+3]=this.st_procedure_type
this.Control[iCurrent+4]=this.pb_up
this.Control[iCurrent+5]=this.pb_down
this.Control[iCurrent+6]=this.st_page
this.Control[iCurrent+7]=this.st_category
this.Control[iCurrent+8]=this.st_top_20
this.Control[iCurrent+9]=this.st_cpt_code
this.Control[iCurrent+10]=this.st_search_status
this.Control[iCurrent+11]=this.st_specialty
this.Control[iCurrent+12]=this.st_specialty_title
this.Control[iCurrent+13]=this.st_description
this.Control[iCurrent+14]=this.st_common_flag
this.Control[iCurrent+15]=this.dw_procedures
this.Control[iCurrent+16]=this.cb_new_procedure
this.Control[iCurrent+17]=this.cb_ok
this.Control[iCurrent+18]=this.st_title
end on

on w_svc_config_procedures.destroy
call super::destroy
destroy(this.st_search_title)
destroy(this.st_procedure_type_title)
destroy(this.st_procedure_type)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
destroy(this.st_category)
destroy(this.st_top_20)
destroy(this.st_cpt_code)
destroy(this.st_search_status)
destroy(this.st_specialty)
destroy(this.st_specialty_title)
destroy(this.st_description)
destroy(this.st_common_flag)
destroy(this.dw_procedures)
destroy(this.cb_new_procedure)
destroy(this.cb_ok)
destroy(this.st_title)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_svc_config_procedures
integer x = 2638
integer y = 0
integer width = 247
integer height = 120
boolean enabled = false
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_config_procedures
end type

type st_search_title from statictext within w_svc_config_procedures
integer x = 1888
integer y = 544
integer width = 558
integer height = 88
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 7191717
string text = "Search Options"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_procedure_type_title from statictext within w_svc_config_procedures
integer x = 1554
integer y = 372
integer width = 594
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
string text = "Procedure Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_procedure_type from statictext within w_svc_config_procedures
integer x = 2153
integer y = 372
integer width = 695
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_procedure_type_list"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.add_blank_row = true
popup.blank_text = "<All>"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	st_category.visible = false
	text = "<All>"
	setnull(procedure_type)
else
	if isnull(specialty_id) then
		st_category.visible = false
	else
		st_category.visible = true
	end if
	procedure_type = popup_return.items[1]
	text = popup_return.descriptions[1]
end if

dw_procedures.initialize(procedure_type)

dw_procedures.search_top_20()
end event

type pb_up from u_picture_button within w_svc_config_procedures
integer x = 1440
integer y = 120
integer width = 137
integer height = 116
integer taborder = 20
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_procedures.current_page

dw_procedures.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_svc_config_procedures
integer x = 1440
integer y = 244
integer width = 137
integer height = 116
integer taborder = 10
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_procedures.current_page
li_last_page = dw_procedures.last_page

dw_procedures.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type st_page from statictext within w_svc_config_procedures
integer x = 1577
integer y = 120
integer width = 274
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Page 99/99"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_category from statictext within w_svc_config_procedures
integer x = 2523
integer y = 656
integer width = 338
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Category"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_procedures.search_category()

end event

type st_top_20 from statictext within w_svc_config_procedures
integer x = 1481
integer y = 656
integer width = 338
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Short List"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if search_type = "TOP20" then
	if dw_procedures.search_description = "Personal List" then
		dw_procedures.search_top_20(false)
	else
		dw_procedures.search_top_20(true)
	end if
else
	if dw_procedures.search_description = "Personal List" then
		dw_procedures.search_top_20(true)
	else
		dw_procedures.search_top_20(false)
	end if
end if


end event

type st_cpt_code from statictext within w_svc_config_procedures
integer x = 2176
integer y = 656
integer width = 338
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "CPT Code"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_procedures.search_cpt()

end event

type st_search_status from statictext within w_svc_config_procedures
integer x = 1472
integer y = 792
integer width = 1390
integer height = 88
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_specialty from statictext within w_svc_config_procedures
integer x = 2153
integer y = 260
integer width = 695
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_specialty_title from statictext within w_svc_config_procedures
integer x = 1851
integer y = 260
integer width = 297
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
string text = "Specialty:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_description from statictext within w_svc_config_procedures
integer x = 1829
integer y = 656
integer width = 338
integer height = 108
integer taborder = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Description"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_procedures.search_description()

end event

type st_common_flag from statictext within w_svc_config_procedures
integer x = 2592
integer y = 552
integer width = 270
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Specialty"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if common_flag = "Y" then
	common_flag = "N"
	text = "All"
	setnull(dw_procedures.specialty_id)
else
	common_flag = "Y"
	text = "Specialty"
	dw_procedures.specialty_id = current_user.common_list_id()
end if

dw_procedures.search()

end event

type dw_procedures from u_dw_procedure_list within w_svc_config_procedures
integer x = 14
integer y = 108
integer width = 1413
integer height = 1592
integer taborder = 11
boolean bringtotop = true
boolean vscrollbar = true
end type

event procedures_loaded;call super::procedures_loaded;
search_type = current_search

st_top_20.backcolor = color_object
st_category.backcolor = color_object
st_cpt_code.backcolor = color_object
st_description.backcolor = color_object

st_search_status.text = ps_description

CHOOSE CASE current_search
	CASE "TOP20"
		st_top_20.backcolor = color_object_selected
		st_common_flag.visible = false
	CASE "CATEGORY"
		st_category.backcolor = color_object_selected
		st_common_flag.visible = true
	CASE "CPT"
		st_cpt_code.backcolor = color_object_selected
		st_common_flag.visible = true
	CASE "DESCRIPTION"
		st_description.backcolor = color_object_selected
		st_common_flag.visible = true
END CHOOSE

set_page(1, pb_up, pb_down, st_page)

end event

event selected;call super::selected;if lasttype <> 'compute' then
	procedure_menu(selected_row)
end if
clear_selected()

end event

type cb_new_procedure from commandbutton within w_svc_config_procedures
integer x = 1888
integer y = 1100
integer width = 562
integer height = 112
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Procedure"
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_procedure_type

if isnull(procedure_type) then
	popup.dataobject = "dw_procedure_type_list"
	popup.datacolumn = 1
	popup.displaycolumn = 2
	popup.add_blank_row = false
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return
	
	ls_procedure_type = popup_return.items[1]
else
	ls_procedure_type = procedure_type
end if

popup.items[1] = ls_procedure_type
popup.data_row_count = 1
openwithparm(w_procedure_definition, popup)
popup_return = message.powerobjectparm

if isnull(popup_return.item) then return

dw_procedures.search()
end event

type cb_ok from commandbutton within w_svc_config_procedures
integer x = 2437
integer y = 1572
integer width = 402
integer height = 112
integer taborder = 90
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

event clicked;Close(Parent)
end event

type st_title from statictext within w_svc_config_procedures
integer width = 2926
integer height = 108
boolean bringtotop = true
integer textsize = -14
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Procedure Configuration"
alignment alignment = center!
boolean focusrectangle = false
end type

