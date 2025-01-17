﻿$PBExportHeader$w_pick_observations.srw
forward
global type w_pick_observations from w_window_base
end type
type st_search_title from statictext within w_pick_observations
end type
type st_treatment_type_title from statictext within w_pick_observations
end type
type st_treatment_type from statictext within w_pick_observations
end type
type pb_down_sel from u_picture_button within w_pick_observations
end type
type pb_up_sel from u_picture_button within w_pick_observations
end type
type pb_up from u_picture_button within w_pick_observations
end type
type pb_down from u_picture_button within w_pick_observations
end type
type st_page from statictext within w_pick_observations
end type
type st_category from statictext within w_pick_observations
end type
type st_top_20 from statictext within w_pick_observations
end type
type st_procedure from statictext within w_pick_observations
end type
type st_search_status from statictext within w_pick_observations
end type
type st_specialty from statictext within w_pick_observations
end type
type st_specialty_title from statictext within w_pick_observations
end type
type dw_selected_items from u_dw_pick_list within w_pick_observations
end type
type pb_done from u_picture_button within w_pick_observations
end type
type st_title from statictext within w_pick_observations
end type
type pb_cancel from u_picture_button within w_pick_observations
end type
type st_selected_items from statictext within w_pick_observations
end type
type dw_observations from u_dw_observation_list within w_pick_observations
end type
type st_description from statictext within w_pick_observations
end type
type st_common_flag from statictext within w_pick_observations
end type
type st_composite from statictext within w_pick_observations
end type
type st_simple from statictext within w_pick_observations
end type
type st_all from statictext within w_pick_observations
end type
type st_page_sel from statictext within w_pick_observations
end type
type cb_new_observation from commandbutton within w_pick_observations
end type
type st_active from statictext within w_pick_observations
end type
end forward

global type w_pick_observations from w_window_base
integer height = 1836
windowtype windowtype = response!
st_search_title st_search_title
st_treatment_type_title st_treatment_type_title
st_treatment_type st_treatment_type
pb_down_sel pb_down_sel
pb_up_sel pb_up_sel
pb_up pb_up
pb_down pb_down
st_page st_page
st_category st_category
st_top_20 st_top_20
st_procedure st_procedure
st_search_status st_search_status
st_specialty st_specialty
st_specialty_title st_specialty_title
dw_selected_items dw_selected_items
pb_done pb_done
st_title st_title
pb_cancel pb_cancel
st_selected_items st_selected_items
dw_observations dw_observations
st_description st_description
st_common_flag st_common_flag
st_composite st_composite
st_simple st_simple
st_all st_all
st_page_sel st_page_sel
cb_new_observation cb_new_observation
st_active st_active
end type
global w_pick_observations w_pick_observations

type variables
boolean top_20_list
boolean multiselect

string top_20_code,special_top_20_code
string top_20_user_id
string top_20_bitmap

string top_20_dataobject
string alpha_dataobject
string cat_dataobject
string cat_pick_dataobject

string treatment_type
string treatment_type_description

string description

string search_type

string composite_flag
end variables

forward prototypes
public subroutine select_observation (string ps_observation_id, string ps_description)
end prototypes

public subroutine select_observation (string ps_observation_id, string ps_description);long ll_row
string ls_preference_id
string ls_perform_location_domain
string ls_composite_flag
string ls_location
string ls_location_description

setnull(ls_location)

ls_composite_flag = datalist.observation_composite_flag(ps_observation_id)
if ls_composite_flag = "Y" then
	ls_perform_location_domain = datalist.observation_perform_location_domain(ps_observation_id)
	if not isnull(ls_perform_location_domain) and ls_perform_location_domain <> "NA" then
		ls_location = f_pick_location(ls_perform_location_domain)
		if isnull(ls_location) then return
		ls_location_description = datalist.location_description(ls_location)
		if isnull(ls_location_description) then return
		ps_description += " (" + ls_location_description + ")"
	end if
end if

if multiselect or dw_selected_items.rowcount() <= 0 then
	ll_row = dw_selected_items.insertrow(0)
else
	ll_row = 1
end if

dw_selected_items.object.observation_id[ll_row] = ps_observation_id
dw_selected_items.object.description[ll_row] = ps_description
dw_selected_items.object.location[ll_row] = ls_location

dw_observations.clear_selected()

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

str_popup			popup
str_picked_observations lstr_observations

setnull(composite_flag)

lstr_observations.observation_count = 0

popup = Message.powerobjectparm

// item 1 = treatment_type
// item 2 = specialty_id
// item 3 = top 20 code [special top 20 code from asst timeline & graphs]
// item 4 = for graphs & timeline it should be always 'Composite' selection.
// multiselect = allow multiple items to be selected

If popup.data_row_count = 2 Then
	treatment_type = popup.items[1]
	dw_observations.specialty_id = popup.items[2]
	Setnull(special_top_20_code)
ElseIf popup.data_row_count = 3 Then
	treatment_type = popup.items[1]
	dw_observations.specialty_id = popup.items[2]
	special_top_20_code = popup.items[3]
ElseIf popup.data_row_count = 4 Then
	treatment_type = popup.items[1]
	dw_observations.specialty_id = popup.items[2]
	special_top_20_code = popup.items[3]
	composite_flag = popup.items[4] // 'Y'-Composite , 'N' - Simple
Else
	log.log(this, "w_pick_observations:open", "Invalid Parameters", 4)
	closewithreturn(this, lstr_observations)
	Return
End If

multiselect = popup.multiselect

dw_observations.mode = "PICK"
dw_observations.all_or_common = "Specialty"

if isnull(current_patient) then
	title = st_title.text
else
	title = current_patient.id_line()
end if

pb_down_sel.visible = false
pb_up_sel.visible = false
st_page_sel.visible = false

dw_observations.object.description.width = dw_observations.width - 225

dw_observations.initialize(treatment_type)

// override top20 for assessment timeline
if not isnull(special_top_20_code) then 
	dw_observations.top_20_code = special_top_20_code
	dw_observations.top_20_prefix = special_top_20_code
end if
// as on this dt 3/20/02, we know asst timeline and graph will pass this
If upper(composite_flag) = 'Y' Then
	dw_observations.composite_flag = 'Y'
	st_simple.enabled = false
	st_all.enabled = false
Elseif upper(composite_flag) = 'N' Then
	dw_observations.composite_flag = 'N'
	st_composite.enabled = false
	st_all.enabled = false
End If

if isnull(treatment_type) then
	treatment_type_description = "<All>"
else
	treatment_type_description = datalist.treatment_type_description(treatment_type)
end if
description = treatment_type_description
st_title.text = "Select " + treatment_type_description + " observation(s)"
st_treatment_type.text = treatment_type_description

If trim(dw_observations.specialty_id) = "" or isnull(dw_observations.specialty_id) then dw_observations.specialty_id = current_user.specialty_id

If Isnull(dw_observations.specialty_id) Then
	st_specialty.visible = False
	st_specialty_title.visible = False
	st_category.visible = false
Else
	st_specialty.text = datalist.specialty_description(dw_observations.specialty_id)
End if

dw_observations.search_top_20()
if dw_observations.rowcount() = 0 then dw_observations.search_description("")
if dw_observations.rowcount() = 0 then st_common_flag.event POST clicked()


end event

on w_pick_observations.create
int iCurrent
call super::create
this.st_search_title=create st_search_title
this.st_treatment_type_title=create st_treatment_type_title
this.st_treatment_type=create st_treatment_type
this.pb_down_sel=create pb_down_sel
this.pb_up_sel=create pb_up_sel
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
this.st_category=create st_category
this.st_top_20=create st_top_20
this.st_procedure=create st_procedure
this.st_search_status=create st_search_status
this.st_specialty=create st_specialty
this.st_specialty_title=create st_specialty_title
this.dw_selected_items=create dw_selected_items
this.pb_done=create pb_done
this.st_title=create st_title
this.pb_cancel=create pb_cancel
this.st_selected_items=create st_selected_items
this.dw_observations=create dw_observations
this.st_description=create st_description
this.st_common_flag=create st_common_flag
this.st_composite=create st_composite
this.st_simple=create st_simple
this.st_all=create st_all
this.st_page_sel=create st_page_sel
this.cb_new_observation=create cb_new_observation
this.st_active=create st_active
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_search_title
this.Control[iCurrent+2]=this.st_treatment_type_title
this.Control[iCurrent+3]=this.st_treatment_type
this.Control[iCurrent+4]=this.pb_down_sel
this.Control[iCurrent+5]=this.pb_up_sel
this.Control[iCurrent+6]=this.pb_up
this.Control[iCurrent+7]=this.pb_down
this.Control[iCurrent+8]=this.st_page
this.Control[iCurrent+9]=this.st_category
this.Control[iCurrent+10]=this.st_top_20
this.Control[iCurrent+11]=this.st_procedure
this.Control[iCurrent+12]=this.st_search_status
this.Control[iCurrent+13]=this.st_specialty
this.Control[iCurrent+14]=this.st_specialty_title
this.Control[iCurrent+15]=this.dw_selected_items
this.Control[iCurrent+16]=this.pb_done
this.Control[iCurrent+17]=this.st_title
this.Control[iCurrent+18]=this.pb_cancel
this.Control[iCurrent+19]=this.st_selected_items
this.Control[iCurrent+20]=this.dw_observations
this.Control[iCurrent+21]=this.st_description
this.Control[iCurrent+22]=this.st_common_flag
this.Control[iCurrent+23]=this.st_composite
this.Control[iCurrent+24]=this.st_simple
this.Control[iCurrent+25]=this.st_all
this.Control[iCurrent+26]=this.st_page_sel
this.Control[iCurrent+27]=this.cb_new_observation
this.Control[iCurrent+28]=this.st_active
end on

on w_pick_observations.destroy
call super::destroy
destroy(this.st_search_title)
destroy(this.st_treatment_type_title)
destroy(this.st_treatment_type)
destroy(this.pb_down_sel)
destroy(this.pb_up_sel)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
destroy(this.st_category)
destroy(this.st_top_20)
destroy(this.st_procedure)
destroy(this.st_search_status)
destroy(this.st_specialty)
destroy(this.st_specialty_title)
destroy(this.dw_selected_items)
destroy(this.pb_done)
destroy(this.st_title)
destroy(this.pb_cancel)
destroy(this.st_selected_items)
destroy(this.dw_observations)
destroy(this.st_description)
destroy(this.st_common_flag)
destroy(this.st_composite)
destroy(this.st_simple)
destroy(this.st_all)
destroy(this.st_page_sel)
destroy(this.cb_new_observation)
destroy(this.st_active)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_pick_observations
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pick_observations
end type

type st_search_title from statictext within w_pick_observations
integer x = 1893
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
long backcolor = 7191717
string text = "Search Options"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_treatment_type_title from statictext within w_pick_observations
integer x = 1682
integer y = 252
integer width = 489
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
string text = "Treatment Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_treatment_type from statictext within w_pick_observations
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

popup.dataobject = "dw_observation_treatment_types"
popup.datacolumn = 2
popup.displaycolumn = 4
popup.add_blank_row = true
popup.blank_text = "<All>"
openwithparm(w_pop_pick, popup)
popup_return = f_popup_return("w_pop_pick,w_pick_observations.st_treatment_type.clicked:10")
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	st_category.visible = false
	text = "<All>"
	setnull(treatment_type)
else
	if isnull(dw_observations.specialty_id) then
		st_category.visible = false
	else
		st_category.visible = true
	end if
	treatment_type = popup_return.items[1]
	text = popup_return.descriptions[1]
end if

dw_observations.initialize(treatment_type)
If not isnull(special_top_20_code) then 
	dw_observations.top_20_code = special_top_20_code
	dw_observations.top_20_prefix = special_top_20_code
End If
dw_observations.search_top_20()


end event

type pb_down_sel from u_picture_button within w_pick_observations
integer x = 2688
integer y = 972
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

type pb_up_sel from u_picture_button within w_pick_observations
integer x = 2688
integer y = 844
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

type pb_up from u_picture_button within w_pick_observations
integer x = 1449
integer y = 116
integer width = 137
integer height = 116
integer taborder = 20
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_observations.current_page

dw_observations.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_pick_observations
integer x = 1449
integer y = 240
integer width = 137
integer height = 116
integer taborder = 10
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_observations.current_page
li_last_page = dw_observations.last_page

dw_observations.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type st_page from statictext within w_pick_observations
integer x = 1586
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
long backcolor = 7191717
string text = "Page 99/99"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_category from statictext within w_pick_observations
integer x = 2528
integer y = 492
integer width = 343
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

event clicked;dw_observations.search_category()

end event

type st_top_20 from statictext within w_pick_observations
integer x = 1472
integer y = 492
integer width = 343
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

event clicked;dw_observations.search_top_20()

end event

type st_procedure from statictext within w_pick_observations
integer x = 2176
integer y = 492
integer width = 343
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
string text = "Procedure"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_observations.search_procedure()

end event

type st_search_status from statictext within w_pick_observations
integer x = 1467
integer y = 628
integer width = 1403
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

event clicked;if dw_observations.search_description = "Personal List" then
	dw_observations.search_top_20(false)
else
	dw_observations.search_top_20(true)
end if

end event

type st_specialty from statictext within w_pick_observations
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

type st_specialty_title from statictext within w_pick_observations
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
long backcolor = 7191717
boolean enabled = false
string text = "Specialty:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_selected_items from u_dw_pick_list within w_pick_observations
integer x = 1518
integer y = 840
integer width = 1157
integer height = 596
integer taborder = 20
string dataobject = "dw_selected_observations"
end type

event post_click(long clicked_row);
If clicked_row <= 0 Then Return

deleterow(clicked_row)

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

type pb_done from u_picture_button within w_pick_observations
event clicked pbm_bnclicked
integer x = 2569
integer y = 1496
integer width = 256
integer height = 224
integer taborder = 80
boolean enabled = false
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;str_picked_observations lstr_observations
string ls_observation_id
string ls_description
string ls_send_out_flag
long i
long ll_rowcount

lstr_observations.observation_count = dw_selected_items.rowcount()

for i = 1 to lstr_observations.observation_count
	lstr_observations.observation_id[i] = dw_selected_items.object.observation_id[i]
	lstr_observations.description[i] = dw_selected_items.object.description[i]
	lstr_observations.location[i] = dw_selected_items.object.location[i]
next

closewithreturn(parent, lstr_observations)


end event

type st_title from statictext within w_pick_observations
integer width = 2926
integer height = 108
integer textsize = -14
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_cancel from u_picture_button within w_pick_observations
integer x = 2281
integer y = 1496
integer taborder = 100
boolean originalsize = false
string picturename = "button11.bmp"
string disabledname = "button11.bmp"
end type

event clicked;str_picked_observations lstr_observations

lstr_observations.observation_count = 0

closewithreturn(parent, lstr_observations)


end event

type st_selected_items from statictext within w_pick_observations
integer x = 1518
integer y = 744
integer width = 1157
integer height = 92
integer textsize = -14
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Selected Items"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_observations from u_dw_observation_list within w_pick_observations
integer x = 14
integer y = 108
integer width = 1417
integer height = 1592
integer taborder = 50
boolean vscrollbar = true
boolean select_computed = false
end type

event observations_loaded;call super::observations_loaded;
search_type = current_search

st_top_20.backcolor = color_object
st_category.backcolor = color_object
st_procedure.backcolor = color_object
st_description.backcolor = color_object

st_search_status.text = ps_description
st_common_flag.text = all_or_common

if this.status = "OK" then
	st_active.text = "Active"
else
	st_active.text = "Inactive"
end if


CHOOSE CASE current_search
	CASE "TOP20"
		st_top_20.backcolor = color_object_selected
		st_common_flag.visible = false
		st_active.visible = false
		st_search_status.borderstyle = styleraised!
		st_search_status.enabled = true
	CASE "CATEGORY"
		st_category.backcolor = color_object_selected
		st_common_flag.visible = true
		st_active.visible = true
		st_search_status.borderstyle = stylebox!
		st_search_status.enabled = false
	CASE "PROCEDURE"
		st_procedure.backcolor = color_object_selected
		st_common_flag.visible = true
		st_active.visible = true
		st_search_status.borderstyle = stylebox!
		st_search_status.enabled = false
	CASE "DESCRIPTION"
		st_description.backcolor = color_object_selected
		st_common_flag.visible = true
		st_active.visible = true
		st_search_status.borderstyle = stylebox!
		st_search_status.enabled = false
END CHOOSE

// Display any change to the composite_flag
st_composite.backcolor = color_object
st_simple.backcolor = color_object
st_all.backcolor = color_object
if isnull(composite_flag) then
	st_all.backcolor = color_object_selected
elseif composite_flag = "Y" then
	st_composite.backcolor = color_object_selected
else
	st_simple.backcolor = color_object_selected
end if


set_page(1, pb_up, pb_down, st_page)

end event

event observation_selected;call super::observation_selected;select_observation(ps_observation_id, ps_observation_description)

end event

type st_description from statictext within w_pick_observations
integer x = 1824
integer y = 492
integer width = 343
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

event clicked;dw_observations.search_description()

end event

type st_common_flag from statictext within w_pick_observations
integer x = 2601
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

event clicked;dw_observations.toggle_all_or_common()


end event

type st_composite from statictext within w_pick_observations
integer x = 1467
integer y = 1460
integer width = 274
integer height = 76
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Composite"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
boolean disabledlook = true
end type

event clicked;dw_observations.composite_flag = "Y"
backcolor = color_object_selected
st_simple.backcolor = color_object
st_all.backcolor = color_object

dw_observations.search()

end event

type st_simple from statictext within w_pick_observations
integer x = 1467
integer y = 1548
integer width = 274
integer height = 76
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Simple"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
boolean disabledlook = true
end type

event clicked;dw_observations.composite_flag = "N"
backcolor = color_object_selected
st_composite.backcolor = color_object
st_all.backcolor = color_object

dw_observations.search()

end event

type st_all from statictext within w_pick_observations
integer x = 1467
integer y = 1636
integer width = 274
integer height = 76
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "All"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
boolean disabledlook = true
end type

event clicked;setnull(dw_observations.composite_flag)
backcolor = color_object_selected
st_composite.backcolor = color_object
st_simple.backcolor = color_object

dw_observations.search()

end event

type st_page_sel from statictext within w_pick_observations
integer x = 2551
integer y = 776
integer width = 274
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
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_new_observation from commandbutton within w_pick_observations
integer x = 1760
integer y = 1600
integer width = 480
integer height = 112
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Observation"
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_composite_flag
w_window_base lw_window

If upper(composite_flag)='Y' Then //Composite
	ls_composite_flag = 'Y'
Elseif upper(composite_flag)='N' Then // Simple
	ls_composite_flag = 'N'
Else
	popup.data_row_count = 2
	popup.items[1] = "Simple Observation"
	popup.items[2] = "Composite Observation"
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return
	if popup_return.item_indexes[1] = 1 then
		ls_composite_flag = "N"
	else
		ls_composite_flag = "Y"
	end if
End If
popup.data_row_count = 0

if ls_composite_flag = "Y" then
	openwithparm(lw_window, popup, "w_composite_observation_definition")
	popup_return = f_popup_return("w_composite_observation_definition,w_pick_observation.cb_new_observation.clicked:27")
else
	openwithparm(lw_window, popup, "w_observation_definition")
	popup_return = f_popup_return("w_observation_definition,w_pick_observation.cb_new_observation.clicked:30")
end if
if popup_return.item_count <> 1 then return

// Automatically associate the new observation with the current treatment_type
if not isnull(treatment_type) then
	INSERT INTO c_Observation_Treatment_Type (
		observation_id,
		treatment_type)
	VALUES (
		:popup_return.items[1],
		:treatment_type);
	if not tf_check() then return
end if

select_observation(popup_return.items[1], popup_return.descriptions[1])
end event

type st_active from statictext within w_pick_observations
integer x = 1472
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
string text = "Active"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_observations.toggle_status()


end event

