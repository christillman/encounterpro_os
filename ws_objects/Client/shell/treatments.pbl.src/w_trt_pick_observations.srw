$PBExportHeader$w_trt_pick_observations.srw
forward
global type w_trt_pick_observations from w_window_base
end type
type st_search_title from statictext within w_trt_pick_observations
end type
type st_treatment_type_title from statictext within w_trt_pick_observations
end type
type st_treatment_type from statictext within w_trt_pick_observations
end type
type pb_down_sel from u_picture_button within w_trt_pick_observations
end type
type pb_up_sel from u_picture_button within w_trt_pick_observations
end type
type pb_up from u_picture_button within w_trt_pick_observations
end type
type pb_down from u_picture_button within w_trt_pick_observations
end type
type st_page from statictext within w_trt_pick_observations
end type
type st_category from statictext within w_trt_pick_observations
end type
type st_top_20 from statictext within w_trt_pick_observations
end type
type st_procedure from statictext within w_trt_pick_observations
end type
type st_search_status from statictext within w_trt_pick_observations
end type
type st_specialty from statictext within w_trt_pick_observations
end type
type st_specialty_title from statictext within w_trt_pick_observations
end type
type dw_selected_items from u_dw_pick_list within w_trt_pick_observations
end type
type st_title from statictext within w_trt_pick_observations
end type
type st_selected_items from statictext within w_trt_pick_observations
end type
type dw_observations from u_dw_observation_list within w_trt_pick_observations
end type
type st_description from statictext within w_trt_pick_observations
end type
type st_common_flag from statictext within w_trt_pick_observations
end type
type st_composite from statictext within w_trt_pick_observations
end type
type st_simple from statictext within w_trt_pick_observations
end type
type st_all from statictext within w_trt_pick_observations
end type
type st_page_sel from statictext within w_trt_pick_observations
end type
type cb_finished from commandbutton within w_trt_pick_observations
end type
type cb_cancel from commandbutton within w_trt_pick_observations
end type
type cb_new from commandbutton within w_trt_pick_observations
end type
end forward

global type w_trt_pick_observations from w_window_base
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
st_title st_title
st_selected_items st_selected_items
dw_observations dw_observations
st_description st_description
st_common_flag st_common_flag
st_composite st_composite
st_simple st_simple
st_all st_all
st_page_sel st_page_sel
cb_finished cb_finished
cb_cancel cb_cancel
cb_new cb_new
end type
global w_trt_pick_observations w_trt_pick_observations

type variables
boolean top_20_list

string top_20_code
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


end variables

forward prototypes
public subroutine select_observation (string ps_observation_id, string ps_description)
end prototypes

public subroutine select_observation (string ps_observation_id, string ps_description);long ll_row
string ls_preference_id
string ls_treatment_mode
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

ll_row = dw_selected_items.insertrow(0)
dw_selected_items.object.observation_id[ll_row] = ps_observation_id
dw_selected_items.object.description[ll_row] = ps_description
dw_selected_items.object.location[ll_row] = ls_location

ls_treatment_mode = f_get_default_treatment_mode(treatment_type, ps_observation_id)

dw_selected_items.object.treatment_mode[ll_row] = ls_treatment_mode

dw_observations.clear_selected()

cb_finished.enabled = true

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

lstr_observations.observation_count = 0

popup = Message.powerobjectparm

// Item 1 = treatment_type
// Item 2 = specialty_id

if popup.data_row_count <> 2 then
	log.log(this, "w_trt_pick_observations:open", "Invalid Parameters", 4)
	closewithreturn(this, lstr_observations)
	return
end if

treatment_type = popup.items[1]
dw_observations.specialty_id = popup.items[2]

description = datalist.treatment_type_description(treatment_type)

st_title.text = "Select " + description + " observation(s)"

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

// If a composite_flag is set in the c_treatment_type table, then don't let the user change it
if not isnull(dw_observations.composite_flag) then
	st_composite.visible = false
	st_simple.visible = false
	st_all.visible = false
end if

if isnull(treatment_type) then
	treatment_type_description = "<All>"
else
	treatment_type_description = datalist.treatment_type_description(treatment_type)
end if

st_treatment_type.text = treatment_type_description

If trim(dw_observations.specialty_id) = "" or isnull(dw_observations.specialty_id) then dw_observations.specialty_id = current_user.specialty_id

If Isnull(dw_observations.specialty_id) Then
	st_specialty.visible = False
	st_specialty_title.visible = False
	st_category.visible = false
Else
	st_specialty.text = datalist.specialty_description(dw_observations.specialty_id)
End if

dw_selected_items.object.description.width = dw_selected_items.width - 55

dw_observations.search_top_20()
if dw_observations.rowcount() = 0 then dw_observations.search_description("")
if dw_observations.rowcount() = 0 then st_common_flag.event POST clicked()


end event

on w_trt_pick_observations.create
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
this.st_title=create st_title
this.st_selected_items=create st_selected_items
this.dw_observations=create dw_observations
this.st_description=create st_description
this.st_common_flag=create st_common_flag
this.st_composite=create st_composite
this.st_simple=create st_simple
this.st_all=create st_all
this.st_page_sel=create st_page_sel
this.cb_finished=create cb_finished
this.cb_cancel=create cb_cancel
this.cb_new=create cb_new
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
this.Control[iCurrent+16]=this.st_title
this.Control[iCurrent+17]=this.st_selected_items
this.Control[iCurrent+18]=this.dw_observations
this.Control[iCurrent+19]=this.st_description
this.Control[iCurrent+20]=this.st_common_flag
this.Control[iCurrent+21]=this.st_composite
this.Control[iCurrent+22]=this.st_simple
this.Control[iCurrent+23]=this.st_all
this.Control[iCurrent+24]=this.st_page_sel
this.Control[iCurrent+25]=this.cb_finished
this.Control[iCurrent+26]=this.cb_cancel
this.Control[iCurrent+27]=this.cb_new
end on

on w_trt_pick_observations.destroy
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
destroy(this.st_title)
destroy(this.st_selected_items)
destroy(this.dw_observations)
destroy(this.st_description)
destroy(this.st_common_flag)
destroy(this.st_composite)
destroy(this.st_simple)
destroy(this.st_all)
destroy(this.st_page_sel)
destroy(this.cb_finished)
destroy(this.cb_cancel)
destroy(this.cb_new)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_trt_pick_observations
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_trt_pick_observations
end type

type st_search_title from statictext within w_trt_pick_observations
integer x = 1824
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
long backcolor = COLOR_BACKGROUND
string text = "Search Options"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_treatment_type_title from statictext within w_trt_pick_observations
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
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Treatment Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_treatment_type from statictext within w_trt_pick_observations
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
popup_return = message.powerobjectparm
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

dw_observations.search_top_20()


end event

type pb_down_sel from u_picture_button within w_trt_pick_observations
integer x = 2697
integer y = 980
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

type pb_up_sel from u_picture_button within w_trt_pick_observations
integer x = 2697
integer y = 852
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

type pb_up from u_picture_button within w_trt_pick_observations
integer x = 1445
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

type pb_down from u_picture_button within w_trt_pick_observations
integer x = 1445
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

type st_page from statictext within w_trt_pick_observations
integer x = 1582
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
long backcolor = COLOR_BACKGROUND
string text = "Page 99/99"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_category from statictext within w_trt_pick_observations
integer x = 2537
integer y = 492
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

event clicked;dw_observations.search_category()

end event

type st_top_20 from statictext within w_trt_pick_observations
integer x = 1509
integer y = 492
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

event clicked;dw_observations.search_top_20()

end event

type st_procedure from statictext within w_trt_pick_observations
integer x = 2194
integer y = 492
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
string text = "Procedure"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_observations.search_procedure()

end event

type st_search_status from statictext within w_trt_pick_observations
integer x = 1504
integer y = 628
integer width = 1367
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

type st_specialty from statictext within w_trt_pick_observations
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

type st_specialty_title from statictext within w_trt_pick_observations
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
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Specialty:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_selected_items from u_dw_pick_list within w_trt_pick_observations
integer x = 1527
integer y = 848
integer width = 1157
integer height = 596
integer taborder = 20
string dataobject = "dw_selected_observations"
end type

event post_click;//////////////////////////////////////////////////////////////////////////////////////
//
// Description: Ask the user to choose an option based on treatment.
//
// Created By:Mark														Creation dt:
//
// Modified By:Sumathi Chinnasamy									Modified On:02/02/2000
/////////////////////////////////////////////////////////////////////////////////////

str_popup				popup
str_popup_return		popup_return
String					ls_observation_id,ls_treatment_mode,default_workplan
integer					i,j
long						ll_rows
datastore				lds_datastore


If clicked_row <= 0 Then Return

ls_treatment_mode = object.treatment_mode[clicked_row]
ls_observation_id = object.observation_id[clicked_row]

If isnull(treatment_type) Then
	deleterow(lastrow)
Else 
	lds_datastore = Create datastore
	lds_datastore.dataobject = "dw_treatment_mode_pick"
	lds_datastore.Settransobject(SQLCA)
	ll_rows = lds_datastore.retrieve(treatment_type)
	If ll_rows > 0 Then // if any treatment modes
		default_workplan = "<Default Mode>"
		
		If Not isnull(default_workplan) Then
			i++
			popup.items[i] = default_workplan
		End if
		For j = 1 To ll_rows
			i++
			popup.items[i] = lds_datastore.object.treatment_mode[j]
		Next
		i++
		popup.items[i] = "<Remove>"
		popup.data_row_count = i
		popup.auto_singleton = True
		openwithparm(w_pop_pick, popup, parent)
		popup_return = message.powerobjectparm
		If popup_return.item_count <> 1 Then Return
	
		If popup_return.items[1] = "<Remove>" Then
			deleterow(lastrow)
		Else
			ls_treatment_mode = popup_return.items[1]
			if ls_treatment_mode = "<Default Mode>" then setnull(ls_treatment_mode)
			object.treatment_mode[clicked_row] = ls_treatment_mode
			if current_user.check_privilege("Edit Common Short Lists") then
				openwithparm(w_pop_yes_no, "Do you wish to make this treatment mode the default for this treatment?")
				popup_return = message.powerobjectparm
				if popup_return.item = "YES" then
					f_set_default_treatment_mode(treatment_type, ls_observation_id, ls_treatment_mode)
				end if
			end if
		End If
	Else
		deleterow(lastrow)
	End If
	Destroy lds_datastore
End If

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

If rowcount() = 0 Then cb_finished.enabled = False
end event

type st_title from statictext within w_trt_pick_observations
integer width = 2926
integer height = 108
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

type st_selected_items from statictext within w_trt_pick_observations
integer x = 1527
integer y = 752
integer width = 1157
integer height = 92
integer textsize = -14
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Selected Items"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_observations from u_dw_observation_list within w_trt_pick_observations
integer x = 14
integer y = 108
integer width = 1422
integer height = 1592
integer taborder = 50
boolean vscrollbar = true
boolean select_computed = false
end type

event observations_loaded(string ps_description);call super::observations_loaded;
search_type = current_search

st_top_20.backcolor = color_object
st_category.backcolor = color_object
st_procedure.backcolor = color_object
st_description.backcolor = color_object

st_search_status.text = ps_description
st_common_flag.text = all_or_common

CHOOSE CASE current_search
	CASE "TOP20"
		st_top_20.backcolor = color_object_selected
		st_common_flag.visible = false
		st_search_status.borderstyle = styleraised!
		st_search_status.enabled = true
	CASE "CATEGORY"
		st_category.backcolor = color_object_selected
		st_common_flag.visible = true
		st_search_status.borderstyle = stylebox!
		st_search_status.enabled = false
	CASE "PROCEDURE"
		st_procedure.backcolor = color_object_selected
		st_common_flag.visible = true
		st_search_status.borderstyle = stylebox!
		st_search_status.enabled = false
	CASE "DESCRIPTION"
		st_description.backcolor = color_object_selected
		st_common_flag.visible = true
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

last_page = 0
set_page(1, pb_up, pb_down, st_page)

end event

event observation_selected;call super::observation_selected;select_observation(ps_observation_id, ps_observation_description)

end event

type st_description from statictext within w_trt_pick_observations
integer x = 1851
integer y = 492
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

event clicked;dw_observations.search_description()

end event

type st_common_flag from statictext within w_trt_pick_observations
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

type st_composite from statictext within w_trt_pick_observations
integer x = 1454
integer y = 1464
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
end type

event clicked;dw_observations.composite_flag = "Y"
backcolor = color_object_selected
st_simple.backcolor = color_object
st_all.backcolor = color_object

dw_observations.search()

end event

type st_simple from statictext within w_trt_pick_observations
integer x = 1454
integer y = 1552
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
end type

event clicked;dw_observations.composite_flag = "N"
backcolor = color_object_selected
st_composite.backcolor = color_object
st_all.backcolor = color_object

dw_observations.search()

end event

type st_all from statictext within w_trt_pick_observations
integer x = 1454
integer y = 1640
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
end type

event clicked;setnull(dw_observations.composite_flag)
backcolor = color_object_selected
st_composite.backcolor = color_object
st_simple.backcolor = color_object

dw_observations.search()

end event

type st_page_sel from statictext within w_trt_pick_observations
integer x = 2560
integer y = 784
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
long backcolor = COLOR_BACKGROUND
string text = "Page 99/99"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_finished from commandbutton within w_trt_pick_observations
integer x = 2496
integer y = 1608
integer width = 357
integer height = 108
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Finished"
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
	lstr_observations.treatment_mode[i] = dw_selected_items.object.treatment_mode[i]
	lstr_observations.location[i] = dw_selected_items.object.location[i]
next

closewithreturn(parent, lstr_observations)


end event

type cb_cancel from commandbutton within w_trt_pick_observations
integer x = 1765
integer y = 1608
integer width = 357
integer height = 108
integer taborder = 80
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
	lstr_observations.treatment_mode[i] = dw_selected_items.object.treatment_mode[i]
	lstr_observations.location[i] = dw_selected_items.object.location[i]
next

closewithreturn(parent, lstr_observations)


end event

type cb_new from commandbutton within w_trt_pick_observations
integer x = 1829
integer y = 1456
integer width = 549
integer height = 88
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
	openwithparm(lw_window, popup, "w_composite_observation_definition", f_active_window())
else
	openwithparm(lw_window, popup, "w_observation_definition", f_active_window())
end if

popup_return = message.powerobjectparm
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

//do_search()


end event

