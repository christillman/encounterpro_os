HA$PBExportHeader$w_pick_assessments.srw
forward
global type w_pick_assessments from w_window_base
end type
type st_search_title from statictext within w_pick_assessments
end type
type st_assessment_type_title from statictext within w_pick_assessments
end type
type st_assessment_type from statictext within w_pick_assessments
end type
type pb_down_sel from u_picture_button within w_pick_assessments
end type
type pb_up_sel from u_picture_button within w_pick_assessments
end type
type st_page_sel from statictext within w_pick_assessments
end type
type pb_up from u_picture_button within w_pick_assessments
end type
type pb_down from u_picture_button within w_pick_assessments
end type
type st_page from statictext within w_pick_assessments
end type
type st_category from statictext within w_pick_assessments
end type
type st_top_20 from statictext within w_pick_assessments
end type
type st_icd_code from statictext within w_pick_assessments
end type
type st_search_status from statictext within w_pick_assessments
end type
type st_specialty from statictext within w_pick_assessments
end type
type st_specialty_title from statictext within w_pick_assessments
end type
type dw_selected_items from u_dw_pick_list within w_pick_assessments
end type
type pb_done from u_picture_button within w_pick_assessments
end type
type st_title from statictext within w_pick_assessments
end type
type pb_cancel from u_picture_button within w_pick_assessments
end type
type st_selected_items from statictext within w_pick_assessments
end type
type st_description from statictext within w_pick_assessments
end type
type cb_new_assessment from commandbutton within w_pick_assessments
end type
type st_common_flag from statictext within w_pick_assessments
end type
type dw_assessments from u_dw_assessment_list within w_pick_assessments
end type
end forward

global type w_pick_assessments from w_window_base
integer height = 1836
windowtype windowtype = response!
st_search_title st_search_title
st_assessment_type_title st_assessment_type_title
st_assessment_type st_assessment_type
pb_down_sel pb_down_sel
pb_up_sel pb_up_sel
st_page_sel st_page_sel
pb_up pb_up
pb_down pb_down
st_page st_page
st_category st_category
st_top_20 st_top_20
st_icd_code st_icd_code
st_search_status st_search_status
st_specialty st_specialty
st_specialty_title st_specialty_title
dw_selected_items dw_selected_items
pb_done pb_done
st_title st_title
pb_cancel pb_cancel
st_selected_items st_selected_items
st_description st_description
cb_new_assessment cb_new_assessment
st_common_flag st_common_flag
dw_assessments dw_assessments
end type
global w_pick_assessments w_pick_assessments

type variables
boolean top_20_list
boolean multiselect = true
boolean past_encounter
boolean allow_properties

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

long open_encounter_id

string default_assessment_category_id

end variables

forward prototypes
public subroutine picked_assessment_menu (long pl_row)
public subroutine get_assessment_properties (long pl_row)
public subroutine select_assessment (str_c_assessment_definition pstr_assessment)
end prototypes

public subroutine picked_assessment_menu (long pl_row);str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_description
string ls_assessment_id
string ls_null
long ll_null
setnull(ls_null)
setnull(ll_null)
str_picked_assessment lstr_assessment

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Remove from picked assessments list"
	popup.button_titles[popup.button_count] = "Remove"
	buttons[popup.button_count] = "REMOVE"
end if

if allow_properties then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button21.bmp"
	popup.button_helps[popup.button_count] = "Edit picked assessment properties"
	popup.button_titles[popup.button_count] = "Properties"
	buttons[popup.button_count] = "PROPERTIES"
end if

if popup.button_count > 1 then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	button_pressed = message.doubleparm
	if button_pressed < 1 or button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if

CHOOSE CASE buttons[button_pressed]
	CASE "REMOVE"
		dw_selected_items.deleterow(pl_row)
	CASE "PROPERTIES"
		get_assessment_properties(pl_row)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return



end subroutine

public subroutine get_assessment_properties (long pl_row);datetime ldt_begin_date
datetime ldt_end_date
string ls_assessment_id
integer li_sts

ls_assessment_id = dw_selected_items.object.assessment_id[pl_row]
ldt_begin_date = datetime(dw_selected_items.object.begin_date[pl_row], time(""))
ldt_end_date = datetime(dw_selected_items.object.end_date[pl_row], time(""))

li_sts = f_get_assessment_dates(ls_assessment_id, open_encounter_id, ldt_begin_date, ldt_end_date)
if li_sts <= 0 then return

dw_selected_items.object.begin_date[pl_row] = date(ldt_begin_date)
dw_selected_items.object.end_date[pl_row] = date(ldt_end_date)

if isnull(ldt_end_date) then
	dw_selected_items.object.leave_open_flag[pl_row] = "T"
else
	dw_selected_items.object.leave_open_flag[pl_row] = "F"
end if


end subroutine

public subroutine select_assessment (str_c_assessment_definition pstr_assessment);long ll_row
string ls_preference_id
string ls_location
string ls_location_description
string ls_description

if multiselect then // allow multiple selections
	ll_row = dw_selected_items.insertrow(0)
else // single selection
	ll_row = dw_selected_items.rowcount()
	if ll_row <= 0 Then ll_row = dw_selected_items.insertrow(0)
end if

dw_selected_items.object.assessment_type[ll_row] = pstr_assessment.assessment_type
dw_selected_items.object.assessment_id[ll_row] = pstr_assessment.assessment_id

// If the assessment has a location_domain then prompt the user for a location
ls_description = pstr_assessment.description
if not isnull(pstr_assessment.location_domain) and pstr_assessment.location_domain <> "NA" then
	ls_location = f_pick_location(pstr_assessment.location_domain)
	if isnull(ls_location) then
		dw_selected_items.deleterow(ll_row)
		return
	end if
	ls_location_description = datalist.location_description(ls_location)
	if isnull(ls_location_description) then return
	ls_description += " (" + ls_location_description + ")"
	dw_selected_items.object.location[ll_row] = ls_location
end if

dw_selected_items.object.description[ll_row] = ls_description

// If this is a past assessment, then prompt the user for begin and end dates
if past_encounter then get_assessment_properties(ll_row)

dw_assessments.clear_selected()

pb_done.enabled = true

dw_selected_items.scrolltorow(ll_row)
dw_selected_items.recalc_page( pb_up_sel, pb_down_sel, st_page_sel)

end subroutine

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
string			ls_top_20_code,ls_title
str_popup		popup
str_picked_assessments lstr_assessments
string ls_encounter_status

popup = message.powerobjectparm
If popup.data_row_count = 2 Then
	assessment_type = popup.items[1]
	if trim(popup.items[2]) = "" then
		setnull(open_encounter_id)
	else
		open_encounter_id = long(popup.items[2])
	end if
	Setnull(ls_top_20_code)
	multiselect = true
	Setnull(ls_title)
Else
	log.log(this,"open()","Invalid Parameters",4)
	lstr_assessments.assessment_count = 0
	closewithreturn(this, lstr_assessments)
	return
End If

if trim(assessment_type) = "" then setnull(assessment_type)

default_assessment_category_id = datalist.get_preference("PREFERENCES", "default_new_assessment_category")

// Set the flags for the assessment dates behavior
if isnull(open_encounter_id) then
	allow_properties = false
else
	allow_properties = true
	ls_encounter_status = current_patient.encounters.encounter_status(open_encounter_id)
	if ls_encounter_status = "OPEN" then
		past_encounter = false
	else
		past_encounter = true
	end if
end if

specialty_id = current_user.specialty_id
dw_assessments.specialty_id = current_user.common_list_id()

dw_assessments.mode = "PICK"

pb_down_sel.visible = false
pb_up_sel.visible = false
st_page_sel.visible = false

dw_assessments.object.description.width = dw_assessments.width - 150

dw_assessments.initialize(assessment_type,ls_top_20_code)

if isnull(assessment_type) then
	assessment_type_description = "<All>"
else
	assessment_type_description = datalist.assessment_type_description(assessment_type)
	if isnull(assessment_type_description) then
		setnull(assessment_type)
		assessment_type_description = "<All>"
	end if
end if

st_assessment_type.text = assessment_type_description

st_title.text = "Select " + assessment_type_description + " Assessment(s)"

if isnull(current_patient) then
	title = st_title.text
elseif not isnull(ls_title) then
	st_title.text = ls_title
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

dw_selected_items.object.description.width = dw_selected_items.width - 55

dw_assessments.search_top_20()
end event

on w_pick_assessments.create
int iCurrent
call super::create
this.st_search_title=create st_search_title
this.st_assessment_type_title=create st_assessment_type_title
this.st_assessment_type=create st_assessment_type
this.pb_down_sel=create pb_down_sel
this.pb_up_sel=create pb_up_sel
this.st_page_sel=create st_page_sel
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
this.st_category=create st_category
this.st_top_20=create st_top_20
this.st_icd_code=create st_icd_code
this.st_search_status=create st_search_status
this.st_specialty=create st_specialty
this.st_specialty_title=create st_specialty_title
this.dw_selected_items=create dw_selected_items
this.pb_done=create pb_done
this.st_title=create st_title
this.pb_cancel=create pb_cancel
this.st_selected_items=create st_selected_items
this.st_description=create st_description
this.cb_new_assessment=create cb_new_assessment
this.st_common_flag=create st_common_flag
this.dw_assessments=create dw_assessments
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_search_title
this.Control[iCurrent+2]=this.st_assessment_type_title
this.Control[iCurrent+3]=this.st_assessment_type
this.Control[iCurrent+4]=this.pb_down_sel
this.Control[iCurrent+5]=this.pb_up_sel
this.Control[iCurrent+6]=this.st_page_sel
this.Control[iCurrent+7]=this.pb_up
this.Control[iCurrent+8]=this.pb_down
this.Control[iCurrent+9]=this.st_page
this.Control[iCurrent+10]=this.st_category
this.Control[iCurrent+11]=this.st_top_20
this.Control[iCurrent+12]=this.st_icd_code
this.Control[iCurrent+13]=this.st_search_status
this.Control[iCurrent+14]=this.st_specialty
this.Control[iCurrent+15]=this.st_specialty_title
this.Control[iCurrent+16]=this.dw_selected_items
this.Control[iCurrent+17]=this.pb_done
this.Control[iCurrent+18]=this.st_title
this.Control[iCurrent+19]=this.pb_cancel
this.Control[iCurrent+20]=this.st_selected_items
this.Control[iCurrent+21]=this.st_description
this.Control[iCurrent+22]=this.cb_new_assessment
this.Control[iCurrent+23]=this.st_common_flag
this.Control[iCurrent+24]=this.dw_assessments
end on

on w_pick_assessments.destroy
call super::destroy
destroy(this.st_search_title)
destroy(this.st_assessment_type_title)
destroy(this.st_assessment_type)
destroy(this.pb_down_sel)
destroy(this.pb_up_sel)
destroy(this.st_page_sel)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
destroy(this.st_category)
destroy(this.st_top_20)
destroy(this.st_icd_code)
destroy(this.st_search_status)
destroy(this.st_specialty)
destroy(this.st_specialty_title)
destroy(this.dw_selected_items)
destroy(this.pb_done)
destroy(this.st_title)
destroy(this.pb_cancel)
destroy(this.st_selected_items)
destroy(this.st_description)
destroy(this.cb_new_assessment)
destroy(this.st_common_flag)
destroy(this.dw_assessments)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_pick_assessments
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pick_assessments
end type

type st_search_title from statictext within w_pick_assessments
integer x = 1883
integer y = 380
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

type st_assessment_type_title from statictext within w_pick_assessments
integer x = 1582
integer y = 252
integer width = 594
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
string text = "Assessment Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_assessment_type from statictext within w_pick_assessments
integer x = 2176
integer y = 252
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

type pb_down_sel from u_picture_button within w_pick_assessments
integer x = 2679
integer y = 996
integer width = 137
integer height = 116
integer taborder = 10
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_selected_items.current_page
li_last_page = dw_selected_items.last_page

dw_selected_items.set_page(li_page + 1, st_page_sel.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up_sel.enabled = true

end event

type pb_up_sel from u_picture_button within w_pick_assessments
integer x = 2679
integer y = 868
integer width = 137
integer height = 116
integer taborder = 10
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_selected_items.current_page

dw_selected_items.set_page(li_page - 1, st_page_sel.text)

if li_page <= 2 then enabled = false
pb_down_sel.enabled = true

end event

type st_page_sel from statictext within w_pick_assessments
integer x = 2542
integer y = 800
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

type pb_up from u_picture_button within w_pick_assessments
integer x = 1435
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

type pb_down from u_picture_button within w_pick_assessments
integer x = 1435
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

type st_page from statictext within w_pick_assessments
integer x = 1573
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
long backcolor = 33538240
string text = "Page 99/99"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_category from statictext within w_pick_assessments
integer x = 2514
integer y = 492
integer width = 329
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

type st_top_20 from statictext within w_pick_assessments
integer x = 1486
integer y = 492
integer width = 329
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

type st_icd_code from statictext within w_pick_assessments
integer x = 2171
integer y = 492
integer width = 329
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

type st_search_status from statictext within w_pick_assessments
integer x = 1481
integer y = 628
integer width = 1353
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

type st_specialty from statictext within w_pick_assessments
integer x = 2176
integer y = 140
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

type st_specialty_title from statictext within w_pick_assessments
integer x = 1874
integer y = 140
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

type dw_selected_items from u_dw_pick_list within w_pick_assessments
integer x = 1509
integer y = 864
integer width = 1157
integer height = 596
integer taborder = 20
string dataobject = "dw_selected_assessments"
end type

event selected;call super::selected;picked_assessment_menu(selected_row)
clear_selected()

last_page = 0
recalc_page(st_page_sel.text)
if last_page < 2 then
	pb_down_sel.visible = false
	pb_up_sel.visible = false
	st_page_sel.visible = false
else
	pb_down_sel.visible = true
	pb_up_sel.visible = true
	st_page_sel.visible = true
	if current_page > 1 then
		pb_up_sel.enabled = true
	else
		pb_up_sel.enabled = false
	end if
	if current_page < last_page then
		pb_down_sel.enabled = true
	else
		pb_down_sel.enabled = false
	end if
end if

If rowcount() = 0 Then pb_done.enabled = False

end event

type pb_done from u_picture_button within w_pick_assessments
event clicked pbm_bnclicked
integer x = 2569
integer y = 1496
integer taborder = 80
boolean enabled = false
boolean originalsize = false
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;str_picked_assessments lstr_assessments
long i

lstr_assessments.assessment_count = dw_selected_items.rowcount()

for i = 1 to lstr_assessments.assessment_count
	lstr_assessments.assessments[i].assessment_type = dw_selected_items.object.assessment_type[i]
	lstr_assessments.assessments[i].assessment_id = dw_selected_items.object.assessment_id[i]
	lstr_assessments.assessments[i].description = dw_selected_items.object.description[i]
	lstr_assessments.assessments[i].begin_date = dw_selected_items.object.begin_date[i]
	lstr_assessments.assessments[i].end_date = dw_selected_items.object.end_date[i]
	lstr_assessments.assessments[i].leave_open = f_string_to_boolean(string(dw_selected_items.object.leave_open_flag[i]))
	lstr_assessments.assessments[i].location = dw_selected_items.object.location[i]
next

closewithreturn(parent, lstr_assessments)


end event

type st_title from statictext within w_pick_assessments
integer width = 2926
integer height = 108
integer textsize = -14
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_cancel from u_picture_button within w_pick_assessments
integer x = 2217
integer y = 1496
integer taborder = 100
boolean originalsize = false
string picturename = "button11.bmp"
string disabledname = "button11.bmp"
end type

event clicked;str_picked_assessments lstr_assessments

lstr_assessments.assessment_count = 0

closewithreturn(parent, lstr_assessments)


end event

type st_selected_items from statictext within w_pick_assessments
integer x = 1509
integer y = 768
integer width = 1157
integer height = 92
integer textsize = -14
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Selected Items"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_description from statictext within w_pick_assessments
integer x = 1829
integer y = 492
integer width = 329
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

type cb_new_assessment from commandbutton within w_pick_assessments
integer x = 1536
integer y = 1548
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
long ll_row
string ls_find
str_c_assessment_definition lstr_assessment

ls_assessment_id = f_new_assessment(assessment_type, true)
if isnull(ls_assessment_id) then return

// Select new assessment
lstr_assessment = datalist.get_assessment(ls_assessment_id)
if isnull(lstr_assessment.assessment_id) then return

select_assessment(lstr_assessment)



end event

type st_common_flag from statictext within w_pick_assessments
integer x = 2574
integer y = 388
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

type dw_assessments from u_dw_assessment_list within w_pick_assessments
integer x = 14
integer y = 108
integer width = 1408
integer height = 1592
integer taborder = 11
boolean vscrollbar = true
boolean select_computed = false
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

set_page(1, pb_up, pb_down, st_page)

end event

event selected;string ls_assessment_id
str_c_assessment_definition lstr_assessment

ls_assessment_id = object.assessment_id[selected_row]
lstr_assessment = datalist.get_assessment(ls_assessment_id)
if isnull(lstr_assessment.assessment_id) then return

select_assessment(lstr_assessment)

end event

