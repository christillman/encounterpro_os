HA$PBExportHeader$w_svc_config_drugs.srw
forward
global type w_svc_config_drugs from w_window_base
end type
type st_search_title from statictext within w_svc_config_drugs
end type
type pb_up from u_picture_button within w_svc_config_drugs
end type
type pb_down from u_picture_button within w_svc_config_drugs
end type
type st_page from statictext within w_svc_config_drugs
end type
type st_category from statictext within w_svc_config_drugs
end type
type st_top_20 from statictext within w_svc_config_drugs
end type
type st_generic_code from statictext within w_svc_config_drugs
end type
type st_search_status from statictext within w_svc_config_drugs
end type
type st_specialty from statictext within w_svc_config_drugs
end type
type st_specialty_title from statictext within w_svc_config_drugs
end type
type st_title from statictext within w_svc_config_drugs
end type
type st_description from statictext within w_svc_config_drugs
end type
type st_common_flag from statictext within w_svc_config_drugs
end type
type dw_drugs from u_dw_drug_list within w_svc_config_drugs
end type
type cb_new_drug from commandbutton within w_svc_config_drugs
end type
type st_drug_type from statictext within w_svc_config_drugs
end type
type st_2 from statictext within w_svc_config_drugs
end type
type cb_finished from commandbutton within w_svc_config_drugs
end type
end forward

global type w_svc_config_drugs from w_window_base
integer height = 1836
windowtype windowtype = response!
st_search_title st_search_title
pb_up pb_up
pb_down pb_down
st_page st_page
st_category st_category
st_top_20 st_top_20
st_generic_code st_generic_code
st_search_status st_search_status
st_specialty st_specialty
st_specialty_title st_specialty_title
st_title st_title
st_description st_description
st_common_flag st_common_flag
dw_drugs dw_drugs
cb_new_drug cb_new_drug
st_drug_type st_drug_type
st_2 st_2
cb_finished cb_finished
end type
global w_svc_config_drugs w_svc_config_drugs

type variables
String procedure_type
string procedure_type_description
string specialty_id

string search_type

string common_flag = "Y"

u_component_service service

end variables

event open;call super::open;string ls_drug_type
string ls_drug_id
service = message.powerobjectparm
str_drug_definition lstr_drug
boolean lb_drug_search
w_config_drug lw_config_drug

specialty_id = current_user.specialty_id
dw_drugs.specialty_id = current_user.common_list_id()

ls_drug_id = service.get_attribute("drug_id")
if isnull(ls_drug_id) then
	if not isnull(service.treatment) then
		ls_drug_id = service.treatment.drug_id
	end if
end if

// Let the caller force a drug search, even if a drug_id is specified
service.get_attribute("drug_search", lb_drug_search)

// If a drug_id is specified then edit it instead of displaying the search screen
if len(ls_drug_id) > 0 and not lb_drug_search then
	lstr_drug.drug_id = ls_drug_id
	openwithparm(lw_config_drug, ls_drug_id, "w_config_drug")
	close(this)
	return
end if


ls_drug_type = service.get_attribute("drug_type")
if isnull(ls_drug_type) then
	st_drug_type.text = "All Drugs"
	st_drug_type.borderstyle = styleraised!
	st_drug_type.enabled = true
	ls_drug_type = "Drug"
else
	st_drug_type.text = ls_drug_type
	st_drug_type.borderstyle = stylebox!
	st_drug_type.enabled = false
end if

cb_new_drug.text = "New " + wordcap(ls_drug_type)

common_flag = service.get_attribute("common_flag")
if isnull(common_flag) then common_flag = "Y"
if common_flag = "Y" then
	st_common_flag.text = "Specialty"
	dw_drugs.specialty_id = current_user.common_list_id()
else
	st_common_flag.text = "All"
	setnull(dw_drugs.specialty_id)
end if


dw_drugs.mode = "EDIT"

dw_drugs.object.description.width = dw_drugs.width - 150

dw_drugs.initialize("MEDICATION", ls_drug_type)

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

dw_drugs.search_top_20()
if dw_drugs.rowcount() = 0 then
	dw_drugs.search_description("")
end if


end event

on w_svc_config_drugs.create
int iCurrent
call super::create
this.st_search_title=create st_search_title
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
this.st_category=create st_category
this.st_top_20=create st_top_20
this.st_generic_code=create st_generic_code
this.st_search_status=create st_search_status
this.st_specialty=create st_specialty
this.st_specialty_title=create st_specialty_title
this.st_title=create st_title
this.st_description=create st_description
this.st_common_flag=create st_common_flag
this.dw_drugs=create dw_drugs
this.cb_new_drug=create cb_new_drug
this.st_drug_type=create st_drug_type
this.st_2=create st_2
this.cb_finished=create cb_finished
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_search_title
this.Control[iCurrent+2]=this.pb_up
this.Control[iCurrent+3]=this.pb_down
this.Control[iCurrent+4]=this.st_page
this.Control[iCurrent+5]=this.st_category
this.Control[iCurrent+6]=this.st_top_20
this.Control[iCurrent+7]=this.st_generic_code
this.Control[iCurrent+8]=this.st_search_status
this.Control[iCurrent+9]=this.st_specialty
this.Control[iCurrent+10]=this.st_specialty_title
this.Control[iCurrent+11]=this.st_title
this.Control[iCurrent+12]=this.st_description
this.Control[iCurrent+13]=this.st_common_flag
this.Control[iCurrent+14]=this.dw_drugs
this.Control[iCurrent+15]=this.cb_new_drug
this.Control[iCurrent+16]=this.st_drug_type
this.Control[iCurrent+17]=this.st_2
this.Control[iCurrent+18]=this.cb_finished
end on

on w_svc_config_drugs.destroy
call super::destroy
destroy(this.st_search_title)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
destroy(this.st_category)
destroy(this.st_top_20)
destroy(this.st_generic_code)
destroy(this.st_search_status)
destroy(this.st_specialty)
destroy(this.st_specialty_title)
destroy(this.st_title)
destroy(this.st_description)
destroy(this.st_common_flag)
destroy(this.dw_drugs)
destroy(this.cb_new_drug)
destroy(this.st_drug_type)
destroy(this.st_2)
destroy(this.cb_finished)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_svc_config_drugs
integer x = 2830
integer y = 1636
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_config_drugs
end type

type st_search_title from statictext within w_svc_config_drugs
integer x = 1870
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
long backcolor = 33538240
string text = "Search Options"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_up from u_picture_button within w_svc_config_drugs
integer x = 1435
integer y = 120
integer width = 137
integer height = 116
integer taborder = 20
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_drugs.current_page

dw_drugs.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_svc_config_drugs
integer x = 1435
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

li_page = dw_drugs.current_page
li_last_page = dw_drugs.last_page

dw_drugs.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type st_page from statictext within w_svc_config_drugs
integer x = 1573
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
long backcolor = 33538240
string text = "Page 99/99"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_category from statictext within w_svc_config_drugs
integer x = 2514
integer y = 656
integer width = 347
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

event clicked;dw_drugs.search_category()

end event

type st_top_20 from statictext within w_svc_config_drugs
integer x = 1445
integer y = 656
integer width = 347
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
	if dw_drugs.search_description = "Personal List" then
		dw_drugs.search_top_20(false)
	else
		dw_drugs.search_top_20(true)
	end if
else
	if dw_drugs.search_description = "Personal List" then
		dw_drugs.search_top_20(true)
	else
		dw_drugs.search_top_20(false)
	end if
end if


end event

type st_generic_code from statictext within w_svc_config_drugs
integer x = 2158
integer y = 656
integer width = 347
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
string text = "Generic"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_drugs.search_generic()

end event

type st_search_status from statictext within w_svc_config_drugs
integer x = 1435
integer y = 792
integer width = 1426
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

type st_specialty from statictext within w_svc_config_drugs
integer x = 2007
integer y = 412
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

type st_specialty_title from statictext within w_svc_config_drugs
integer x = 1705
integer y = 412
integer width = 297
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Specialty:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_title from statictext within w_svc_config_drugs
integer width = 2926
integer height = 108
integer textsize = -14
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Drug Configuration"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_description from statictext within w_svc_config_drugs
integer x = 1801
integer y = 656
integer width = 347
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
string text = "Trade Name"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_drugs.search_description()

end event

type st_common_flag from statictext within w_svc_config_drugs
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
	setnull(dw_drugs.specialty_id)
else
	common_flag = "Y"
	text = "Specialty"
	dw_drugs.specialty_id = specialty_id
end if

dw_drugs.search()

end event

type dw_drugs from u_dw_drug_list within w_svc_config_drugs
integer x = 14
integer y = 108
integer width = 1408
integer height = 1592
integer taborder = 11
boolean bringtotop = true
boolean vscrollbar = true
boolean select_computed = false
end type

event selected(long selected_row);call super::selected;drug_menu(selected_row)
clear_selected()

end event

event drugs_loaded(string ps_description);
search_type = current_search

st_top_20.backcolor = color_object
st_category.backcolor = color_object
st_generic_code.backcolor = color_object
st_description.backcolor = color_object

st_search_status.text = ps_description

CHOOSE CASE current_search
	CASE "TOP20"
		st_top_20.backcolor = color_object_selected
		st_common_flag.visible = false
	CASE "CATEGORY"
		st_category.backcolor = color_object_selected
		st_common_flag.visible = true
	CASE "GENERIC"
		st_generic_code.backcolor = color_object_selected
		st_common_flag.visible = true
	CASE "DESCRIPTION"
		st_description.backcolor = color_object_selected
		st_common_flag.visible = true
END CHOOSE

last_page = 0
set_page(1, pb_up, pb_down, st_page)


end event

type cb_new_drug from commandbutton within w_svc_config_drugs
integer x = 1897
integer y = 1084
integer width = 503
integer height = 112
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Drug"
end type

event clicked;//
//str_popup_return popup_return
//str_drug_definition lstr_drug
//
//setnull(lstr_drug.drug_id)
//if left(dw_drugs.drug_type, 1) = "%" then
//	setnull(lstr_drug.drug_type)
//else
//	lstr_drug.drug_type = dw_drugs.drug_type
//end if
//openwithparm(w_drug_attributes, lstr_drug)
//popup_return = message.powerobjectparm
//
//if isnull(popup_return.item) then return
//
//dw_drugs.search()
//
//
str_drug_definition lstr_drug
w_config_drug lw_config_drug

lstr_drug = f_new_drug(dw_drugs.drug_type)
if isnull(lstr_drug.drug_id) then return

openwithparm(lw_config_drug, lstr_drug.drug_id, "w_config_drug")

dw_drugs.search_description(lstr_drug.common_name)


end event

type st_drug_type from statictext within w_svc_config_drugs
integer x = 2007
integer y = 248
integer width = 695
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
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

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_drug_type_pick"
popup.displaycolumn = 1
popup.datacolumn = 1
popup.add_blank_row = true
popup.blank_text = "All Drugs"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	dw_drugs.drug_type = "Drug"
	text = "All Drugs"
else
	dw_drugs.drug_type = popup_return.items[1]
	text = popup_return.items[1]
end if

dw_drugs.search()

end event

type st_2 from statictext within w_svc_config_drugs
integer x = 1673
integer y = 264
integer width = 329
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Drug Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_finished from commandbutton within w_svc_config_drugs
integer x = 2382
integer y = 1544
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
string text = "Finished"
end type

event clicked;Close(Parent)
end event

