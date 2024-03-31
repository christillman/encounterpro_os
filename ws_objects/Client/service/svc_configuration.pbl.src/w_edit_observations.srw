$PBExportHeader$w_edit_observations.srw
forward
global type w_edit_observations from w_window_base
end type
type st_search_title from statictext within w_edit_observations
end type
type st_treatment_type_title from statictext within w_edit_observations
end type
type st_treatment_type from statictext within w_edit_observations
end type
type pb_up from u_picture_button within w_edit_observations
end type
type pb_down from u_picture_button within w_edit_observations
end type
type st_page from statictext within w_edit_observations
end type
type st_category from statictext within w_edit_observations
end type
type st_top_20 from statictext within w_edit_observations
end type
type st_procedure from statictext within w_edit_observations
end type
type st_search_status from statictext within w_edit_observations
end type
type st_specialty from statictext within w_edit_observations
end type
type st_specialty_title from statictext within w_edit_observations
end type
type pb_done from u_picture_button within w_edit_observations
end type
type st_title from statictext within w_edit_observations
end type
type dw_observations from u_dw_observation_list within w_edit_observations
end type
type st_description from statictext within w_edit_observations
end type
type st_common_flag from statictext within w_edit_observations
end type
type st_composite from statictext within w_edit_observations
end type
type st_simple from statictext within w_edit_observations
end type
type st_all from statictext within w_edit_observations
end type
type cb_new_observation from commandbutton within w_edit_observations
end type
type st_active from statictext within w_edit_observations
end type
end forward

global type w_edit_observations from w_window_base
integer height = 1836
windowtype windowtype = response!
st_search_title st_search_title
st_treatment_type_title st_treatment_type_title
st_treatment_type st_treatment_type
pb_up pb_up
pb_down pb_down
st_page st_page
st_category st_category
st_top_20 st_top_20
st_procedure st_procedure
st_search_status st_search_status
st_specialty st_specialty
st_specialty_title st_specialty_title
pb_done pb_done
st_title st_title
dw_observations dw_observations
st_description st_description
st_common_flag st_common_flag
st_composite st_composite
st_simple st_simple
st_all st_all
cb_new_observation cb_new_observation
st_active st_active
end type
global w_edit_observations w_edit_observations

type variables
boolean top_20_list
boolean use_treatment_type
boolean multiselect

string top_20_code
string top_20_user_id
string top_20_bitmap

string top_20_dataobject
string alpha_dataobject
string cat_dataobject
string cat_pick_dataobject

string treatment_type
string treatment_type_description
string observation_type
string specialty_id

string procedure_type

string description

string search_type

u_component_service service
u_component_treatment treatment


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

str_popup			popup
str_picked_observations lstr_observations

lstr_observations.observation_count = 0

dw_observations.mode = "EDIT"

dw_observations.specialty_id = current_user.specialty_id
dw_observations.all_or_common = "Specialty"

if isnull(current_patient) then
	title = "Edit Observations"
else
	title = current_patient.id_line()
end if

dw_observations.object.description.width = dw_observations.width - 225

//dw_observations.initialize(treatment_type)

st_title.text = "Select Observation"

If trim(observation_type) = "" Then Setnull(observation_type)

If trim(dw_observations.specialty_id) = "" Then Setnull(dw_observations.specialty_id)
If Isnull(dw_observations.specialty_id) Then
	st_specialty.text = "<None>"
Else
	st_specialty.text = datalist.specialty_description(dw_observations.specialty_id)
End if

postevent("post_open")


end event

on w_edit_observations.create
int iCurrent
call super::create
this.st_search_title=create st_search_title
this.st_treatment_type_title=create st_treatment_type_title
this.st_treatment_type=create st_treatment_type
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
this.st_category=create st_category
this.st_top_20=create st_top_20
this.st_procedure=create st_procedure
this.st_search_status=create st_search_status
this.st_specialty=create st_specialty
this.st_specialty_title=create st_specialty_title
this.pb_done=create pb_done
this.st_title=create st_title
this.dw_observations=create dw_observations
this.st_description=create st_description
this.st_common_flag=create st_common_flag
this.st_composite=create st_composite
this.st_simple=create st_simple
this.st_all=create st_all
this.cb_new_observation=create cb_new_observation
this.st_active=create st_active
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_search_title
this.Control[iCurrent+2]=this.st_treatment_type_title
this.Control[iCurrent+3]=this.st_treatment_type
this.Control[iCurrent+4]=this.pb_up
this.Control[iCurrent+5]=this.pb_down
this.Control[iCurrent+6]=this.st_page
this.Control[iCurrent+7]=this.st_category
this.Control[iCurrent+8]=this.st_top_20
this.Control[iCurrent+9]=this.st_procedure
this.Control[iCurrent+10]=this.st_search_status
this.Control[iCurrent+11]=this.st_specialty
this.Control[iCurrent+12]=this.st_specialty_title
this.Control[iCurrent+13]=this.pb_done
this.Control[iCurrent+14]=this.st_title
this.Control[iCurrent+15]=this.dw_observations
this.Control[iCurrent+16]=this.st_description
this.Control[iCurrent+17]=this.st_common_flag
this.Control[iCurrent+18]=this.st_composite
this.Control[iCurrent+19]=this.st_simple
this.Control[iCurrent+20]=this.st_all
this.Control[iCurrent+21]=this.cb_new_observation
this.Control[iCurrent+22]=this.st_active
end on

on w_edit_observations.destroy
call super::destroy
destroy(this.st_search_title)
destroy(this.st_treatment_type_title)
destroy(this.st_treatment_type)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
destroy(this.st_category)
destroy(this.st_top_20)
destroy(this.st_procedure)
destroy(this.st_search_status)
destroy(this.st_specialty)
destroy(this.st_specialty_title)
destroy(this.pb_done)
destroy(this.st_title)
destroy(this.dw_observations)
destroy(this.st_description)
destroy(this.st_common_flag)
destroy(this.st_composite)
destroy(this.st_simple)
destroy(this.st_all)
destroy(this.cb_new_observation)
destroy(this.st_active)
end on

event post_open;call super::post_open;st_treatment_type.EVENT TRIGGER clicked()

// If the user cancelled the treatment_type selection then close the window
if isnull(dw_observations.treatment_type) then
	close(this)
	return
end if

if dw_observations.rowcount() = 0 then dw_observations.search_description("")
if dw_observations.rowcount() = 0 then st_common_flag.event POST clicked()
	


end event

type pb_epro_help from w_window_base`pb_epro_help within w_edit_observations
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_edit_observations
end type

type st_search_title from statictext within w_edit_observations
integer x = 1851
integer y = 680
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

type st_treatment_type_title from statictext within w_edit_observations
integer x = 1499
integer y = 480
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

type st_treatment_type from statictext within w_edit_observations
integer x = 2007
integer y = 468
integer width = 695
integer height = 96
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
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	st_top_20.visible = false
	st_category.visible = false
	text = "<All>"
	setnull(treatment_type)
else
	st_top_20.visible = true
	if isnull(dw_observations.specialty_id) then
		st_category.visible = false
	else
		st_category.visible = true
	end if
	treatment_type = popup_return.items[1]
	text = popup_return.descriptions[1]
end if

dw_observations.initialize(treatment_type)

dw_observations.search()


end event

type pb_up from u_picture_button within w_edit_observations
integer x = 1426
integer y = 120
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

type pb_down from u_picture_button within w_edit_observations
integer x = 1426
integer y = 244
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

type st_page from statictext within w_edit_observations
integer x = 1563
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

type st_category from statictext within w_edit_observations
integer x = 2501
integer y = 792
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

type st_top_20 from statictext within w_edit_observations
integer x = 1431
integer y = 792
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

type st_procedure from statictext within w_edit_observations
integer x = 2144
integer y = 792
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

type st_search_status from statictext within w_edit_observations
integer x = 1431
integer y = 928
integer width = 1413
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

type st_specialty from statictext within w_edit_observations
integer x = 2007
integer y = 260
integer width = 695
integer height = 96
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

event clicked;string ls_specialty_id

ls_specialty_id = f_pick_specialty("<None>")
if isnull(ls_specialty_id) then return

dw_observations.all_or_common = "Specialty"

if ls_specialty_id = "<None>" then
	text = "<None>"
	setnull(specialty_id)
	setnull(dw_observations.specialty_id)
else
	specialty_id = ls_specialty_id
	dw_observations.specialty_id = ls_specialty_id
	text = datalist.specialty_description(specialty_id)
end if

if isnull(treatment_type) then
	st_top_20.visible = false
	st_category.visible = false
	st_common_flag.visible = false
else
	st_top_20.visible = true
	if isnull(dw_observations.specialty_id) then
		st_category.visible = false
		st_common_flag.visible = false
	else
		st_category.visible = true
		st_common_flag.visible = true
	end if
end if

dw_observations.search()


end event

type st_specialty_title from statictext within w_edit_observations
integer x = 1691
integer y = 272
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

type pb_done from u_picture_button within w_edit_observations
event clicked pbm_bnclicked
integer x = 2569
integer y = 1496
integer width = 256
integer height = 224
integer taborder = 80
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;close(parent)


end event

type st_title from statictext within w_edit_observations
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

type dw_observations from u_dw_observation_list within w_edit_observations
integer x = 14
integer y = 108
integer width = 1394
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

event selected;if lasttype <> 'compute' then
	observation_menu(selected_row)
	clear_selected()
end if

end event

type st_description from statictext within w_edit_observations
integer x = 1787
integer y = 792
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

type st_common_flag from statictext within w_edit_observations
integer x = 2574
integer y = 684
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

type st_composite from statictext within w_edit_observations
integer x = 1431
integer y = 1180
integer width = 357
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
string text = "Composite"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_observations.composite_flag = "Y"
backcolor = color_object_selected
st_simple.backcolor = color_object
st_all.backcolor = color_object

dw_observations.search()

end event

type st_simple from statictext within w_edit_observations
integer x = 1431
integer y = 1316
integer width = 357
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
string text = "Simple"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_observations.composite_flag = "N"
backcolor = color_object_selected
st_composite.backcolor = color_object
st_all.backcolor = color_object

dw_observations.search()

end event

type st_all from statictext within w_edit_observations
integer x = 1431
integer y = 1452
integer width = 357
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
string text = "All"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;setnull(dw_observations.composite_flag)
backcolor = color_object_selected
st_composite.backcolor = color_object
st_simple.backcolor = color_object

dw_observations.search()

end event

type cb_new_observation from commandbutton within w_edit_observations
integer x = 1883
integer y = 1104
integer width = 498
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
int li_count

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

popup.data_row_count = 0

if ls_composite_flag = "Y" then
	openwithparm(w_composite_observation_definition, popup)
else
	openwithparm(w_observation_definition, popup)
end if

popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

// Automatically associate the new observation with the current treatment_type
// if not already done
if not isnull(treatment_type) then
	SELECT count(*) INTO :li_count
	FROM c_Observation_Treatment_Type
	WHERE observation_id = :popup_return.items[1]
	AND treatment_type = :treatment_type;
	if li_count = 0 then
		INSERT INTO c_Observation_Treatment_Type (
			observation_id,
			treatment_type)
		VALUES (
			:popup_return.items[1],
			:treatment_type);
		if not tf_check() then return
	end if
end if


end event

type st_active from statictext within w_edit_observations
integer x = 1431
integer y = 684
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

