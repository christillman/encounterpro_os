$PBExportHeader$w_find_assessment.srw
forward
global type w_find_assessment from w_window_base
end type
type st_search_title from statictext within w_find_assessment
end type
type st_assessment_type_title from statictext within w_find_assessment
end type
type st_assessment_type from statictext within w_find_assessment
end type
type pb_up from u_picture_button within w_find_assessment
end type
type pb_down from u_picture_button within w_find_assessment
end type
type st_page from statictext within w_find_assessment
end type
type st_category from statictext within w_find_assessment
end type
type st_top_20 from statictext within w_find_assessment
end type
type st_icd_code from statictext within w_find_assessment
end type
type st_search_status from statictext within w_find_assessment
end type
type st_specialty from statictext within w_find_assessment
end type
type st_specialty_title from statictext within w_find_assessment
end type
type st_description from statictext within w_find_assessment
end type
type cb_new_assessment from commandbutton within w_find_assessment
end type
type st_common_flag from statictext within w_find_assessment
end type
type dw_assessments from u_dw_assessment_list within w_find_assessment
end type
type cb_ok from commandbutton within w_find_assessment
end type
type cb_cancel from commandbutton within w_find_assessment
end type
type st_title from statictext within w_find_assessment
end type
end forward

global type w_find_assessment from w_window_base
integer height = 1836
windowtype windowtype = response!
st_search_title st_search_title
st_assessment_type_title st_assessment_type_title
st_assessment_type st_assessment_type
pb_up pb_up
pb_down pb_down
st_page st_page
st_category st_category
st_top_20 st_top_20
st_icd_code st_icd_code
st_search_status st_search_status
st_specialty st_specialty
st_specialty_title st_specialty_title
st_description st_description
cb_new_assessment cb_new_assessment
st_common_flag st_common_flag
dw_assessments dw_assessments
cb_ok cb_ok
cb_cancel cb_cancel
st_title st_title
end type
global w_find_assessment w_find_assessment

type variables
boolean top_20_list

string top_20_code
string top_20_user_id
string top_20_bitmap

string top_20_dataobject
string alpha_dataobject
string cat_dataobject
string cat_pick_dataobject

string assessment_type
string assessment_type_description
string specialty_id

string search_type

string common_flag = "Y"

end variables

event open;call super::open;//////////////////////////////////////////////////////////////////////////////////////
//
// Description:Based on treatment type, set the datawindow object names for category
// alpha and top20. [ need to be generalized in future by replacing this case state
// -ment with treatmet component ]
//
// Created By:Mark														Creation dt: 
//
// Modified By:Sumathi Chinnasamy									Creation dt: 02/02/2000
/////////////////////////////////////////////////////////////////////////////////////
str_popup popup
string ls_null
string ls_top_20_code

setnull(ls_null)

popup = message.powerobjectparm
if popup.data_row_count <> 2 then
	log.log(this, "w_find_assessment:open", "Invalid Parameters", 4)
	closewithreturn(this, ls_null)
end if


assessment_type = popup.items[1]
ls_top_20_code = popup.items[2]

if trim(assessment_type) = "" then setnull(assessment_type)

specialty_id = current_user.specialty_id
dw_assessments.specialty_id = current_user.common_list_id()


// mode should be "PICK" or "EDIT"
dw_assessments.mode =  "PICK"

dw_assessments.object.description.width = dw_assessments.width - 150

dw_assessments.initialize(assessment_type, ls_top_20_code)

if isnull(assessment_type) then
	assessment_type_description = "<All>"
else
	assessment_type_description = datalist.assessment_type_description(assessment_type)
	if isnull(assessment_type_description) then
		setnull(assessment_type)
		assessment_type_description = "<All>"
	end if
end if

st_title.text = "Select Assessment"

st_assessment_type.text = assessment_type_description

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

dw_assessments.search_top_20()


end event

on w_find_assessment.create
int iCurrent
call super::create
this.st_search_title=create st_search_title
this.st_assessment_type_title=create st_assessment_type_title
this.st_assessment_type=create st_assessment_type
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
this.st_category=create st_category
this.st_top_20=create st_top_20
this.st_icd_code=create st_icd_code
this.st_search_status=create st_search_status
this.st_specialty=create st_specialty
this.st_specialty_title=create st_specialty_title
this.st_description=create st_description
this.cb_new_assessment=create cb_new_assessment
this.st_common_flag=create st_common_flag
this.dw_assessments=create dw_assessments
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_search_title
this.Control[iCurrent+2]=this.st_assessment_type_title
this.Control[iCurrent+3]=this.st_assessment_type
this.Control[iCurrent+4]=this.pb_up
this.Control[iCurrent+5]=this.pb_down
this.Control[iCurrent+6]=this.st_page
this.Control[iCurrent+7]=this.st_category
this.Control[iCurrent+8]=this.st_top_20
this.Control[iCurrent+9]=this.st_icd_code
this.Control[iCurrent+10]=this.st_search_status
this.Control[iCurrent+11]=this.st_specialty
this.Control[iCurrent+12]=this.st_specialty_title
this.Control[iCurrent+13]=this.st_description
this.Control[iCurrent+14]=this.cb_new_assessment
this.Control[iCurrent+15]=this.st_common_flag
this.Control[iCurrent+16]=this.dw_assessments
this.Control[iCurrent+17]=this.cb_ok
this.Control[iCurrent+18]=this.cb_cancel
this.Control[iCurrent+19]=this.st_title
end on

on w_find_assessment.destroy
call super::destroy
destroy(this.st_search_title)
destroy(this.st_assessment_type_title)
destroy(this.st_assessment_type)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
destroy(this.st_category)
destroy(this.st_top_20)
destroy(this.st_icd_code)
destroy(this.st_search_status)
destroy(this.st_specialty)
destroy(this.st_specialty_title)
destroy(this.st_description)
destroy(this.cb_new_assessment)
destroy(this.st_common_flag)
destroy(this.dw_assessments)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.st_title)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_find_assessment
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_find_assessment
end type

type st_search_title from statictext within w_find_assessment
integer x = 1874
integer y = 600
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
long backcolor = COLOR_BACKGROUND
string text = "Search Options"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_assessment_type_title from statictext within w_find_assessment
integer x = 1454
integer y = 444
integer width = 594
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Assessment Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_assessment_type from statictext within w_find_assessment
integer x = 2053
integer y = 444
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

popup.dataobject = "dw_assessment_type_list"
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
	setnull(assessment_type)
else
	if isnull(specialty_id) then
		st_category.visible = false
	else
		st_category.visible = true
	end if
	assessment_type = popup_return.items[1]
	text = popup_return.descriptions[1]
end if

dw_assessments.initialize(assessment_type)

dw_assessments.search_top_20()


end event

type pb_up from u_picture_button within w_find_assessment
integer x = 1431
integer y = 116
integer width = 137
integer height = 116
integer taborder = 20
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_assessments.current_page

dw_assessments.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_find_assessment
integer x = 1431
integer y = 240
integer width = 137
integer height = 116
integer taborder = 10
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_assessments.current_page
li_last_page = dw_assessments.last_page

dw_assessments.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type st_page from statictext within w_find_assessment
integer x = 1568
integer y = 116
integer width = 274
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Page 99/99"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_category from statictext within w_find_assessment
integer x = 2510
integer y = 804
integer width = 334
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

event clicked;dw_assessments.search_category()

end event

type st_top_20 from statictext within w_find_assessment
integer x = 1467
integer y = 804
integer width = 334
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
	if dw_assessments.search_description = "Personal List" then
		dw_assessments.search_top_20(false)
	else
		dw_assessments.search_top_20(true)
	end if
else
	if dw_assessments.search_description = "Personal List" then
		dw_assessments.search_top_20(true)
	else
		dw_assessments.search_top_20(false)
	end if
end if


end event

type st_icd_code from statictext within w_find_assessment
integer x = 2162
integer y = 804
integer width = 334
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
string text = "ICD Code"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_assessments.search_icd()

end event

type st_search_status from statictext within w_find_assessment
integer x = 1463
integer y = 940
integer width = 1381
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

type st_specialty from statictext within w_find_assessment
integer x = 2053
integer y = 332
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

type st_specialty_title from statictext within w_find_assessment
integer x = 1751
integer y = 332
integer width = 297
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Specialty:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_description from statictext within w_find_assessment
integer x = 1815
integer y = 804
integer width = 334
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

event clicked;dw_assessments.search_description()

end event

type cb_new_assessment from commandbutton within w_find_assessment
integer x = 1893
integer y = 1212
integer width = 521
integer height = 112
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Assessment"
end type

event clicked;string ls_assessment_id
string ls_description
long ll_row
string ls_find

ls_assessment_id = f_new_assessment(assessment_type, true)
if isnull(ls_assessment_id) then return

ls_description = datalist.assessment_description(ls_assessment_id)

// Locate new assessment and highlight it
dw_assessments.search_description(ls_description)
ls_find = "assessment_id'" + ls_assessment_id + "'"
ll_row = dw_assessments.find(ls_find, 1, dw_assessments.rowcount())
if ll_row > 0 then
	dw_assessments.object.selected_flag[ll_row] = 1
end if


end event

type st_common_flag from statictext within w_find_assessment
integer x = 2574
integer y = 700
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
	setnull(dw_assessments.specialty_id)
else
	common_flag = "Y"
	text = "Specialty"
	dw_assessments.specialty_id = specialty_id
end if

dw_assessments.search()

end event

type dw_assessments from u_dw_assessment_list within w_find_assessment
integer x = 14
integer y = 108
integer width = 1408
integer height = 1592
integer taborder = 11
boolean vscrollbar = true
end type

event assessments_loaded;
search_type = current_search

st_top_20.backcolor = color_object
st_category.backcolor = color_object
st_icd_code.backcolor = color_object
st_description.backcolor = color_object

st_search_status.text = ps_description

CHOOSE CASE current_search
	CASE "TOP20"
		st_top_20.backcolor = color_object_selected
		st_common_flag.visible = false
	CASE "CATEGORY"
		st_category.backcolor = color_object_selected
		st_common_flag.visible = true
	CASE "ICD"
		st_icd_code.backcolor = color_object_selected
		st_common_flag.visible = true
	CASE "DESCRIPTION"
		st_description.backcolor = color_object_selected
		st_common_flag.visible = true
END CHOOSE

set_page(1, st_page.text)
if last_page < 2 then
	pb_down.visible = false
	pb_up.visible = false
	st_page.visible = false
else
	pb_down.visible = true
	pb_up.visible = true
	st_page.visible = true
	pb_down.enabled = true
	pb_up.enabled = false
end if


end event

event selected;cb_ok.enabled = true

end event

event unselected;call super::unselected;cb_ok.enabled = false

end event

type cb_ok from commandbutton within w_find_assessment
integer x = 2414
integer y = 1600
integer width = 402
integer height = 112
integer taborder = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "OK"
boolean default = true
end type

event clicked;long ll_row
string ls_assessment_id

ll_row = dw_assessments.get_selected_row()
if ll_row > 0 then
	ls_assessment_id = dw_assessments.object.assessment_id[ll_row]
else
	return
end if

closewithreturn(parent, ls_assessment_id)


end event

type cb_cancel from commandbutton within w_find_assessment
integer x = 1467
integer y = 1600
integer width = 402
integer height = 112
integer taborder = 110
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

event clicked;string ls_assessment_id

setnull(ls_assessment_id)

closewithreturn(parent, ls_assessment_id)


end event

type st_title from statictext within w_find_assessment
integer width = 2926
integer height = 108
boolean bringtotop = true
integer textsize = -14
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

