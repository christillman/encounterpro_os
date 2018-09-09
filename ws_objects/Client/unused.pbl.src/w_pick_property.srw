$PBExportHeader$w_pick_property.srw
forward
global type w_pick_property from w_window_base
end type
type st_search_title from statictext within w_pick_property
end type
type pb_up from u_picture_button within w_pick_property
end type
type pb_down from u_picture_button within w_pick_property
end type
type st_page from statictext within w_pick_property
end type
type st_top_20 from statictext within w_pick_property
end type
type st_search_status from statictext within w_pick_property
end type
type st_context_general from statictext within w_pick_property
end type
type st_context_object_title from statictext within w_pick_property
end type
type st_title from statictext within w_pick_property
end type
type st_description from statictext within w_pick_property
end type
type dw_property_list from u_dw_property_list within w_pick_property
end type
type st_context_patient from statictext within w_pick_property
end type
type st_context_encounter from statictext within w_pick_property
end type
type st_context_assessment from statictext within w_pick_property
end type
type st_context_treatment from statictext within w_pick_property
end type
type st_context_observation from statictext within w_pick_property
end type
type st_context_attachment from statictext within w_pick_property
end type
type cb_ok from commandbutton within w_pick_property
end type
type cb_cancel from commandbutton within w_pick_property
end type
type st_category from statictext within w_pick_property
end type
type st_status_title from statictext within w_pick_property
end type
type st_status from statictext within w_pick_property
end type
type cb_new_property from commandbutton within w_pick_property
end type
type st_property_name from statictext within w_pick_property
end type
end forward

global type w_pick_property from w_window_base
integer height = 1836
boolean controlmenu = false
windowtype windowtype = response!
st_search_title st_search_title
pb_up pb_up
pb_down pb_down
st_page st_page
st_top_20 st_top_20
st_search_status st_search_status
st_context_general st_context_general
st_context_object_title st_context_object_title
st_title st_title
st_description st_description
dw_property_list dw_property_list
st_context_patient st_context_patient
st_context_encounter st_context_encounter
st_context_assessment st_context_assessment
st_context_treatment st_context_treatment
st_context_observation st_context_observation
st_context_attachment st_context_attachment
cb_ok cb_ok
cb_cancel cb_cancel
st_category st_category
st_status_title st_status_title
st_status st_status
cb_new_property cb_new_property
st_property_name st_property_name
end type
global w_pick_property w_pick_property

type variables
String search_type

boolean allow_context_object_change

end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();dw_property_list.search()

return 1

end function

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
string ls_null
u_ds_data luo_data
long ll_count
long i
string ls_compatible_context_object
boolean lb_same

setnull(ls_null)

dw_property_list.context_object = wordcap(message.stringparm)

allow_context_object_change = false
dw_property_list.mode = "PICK"

if isnull(dw_property_list.context_object) or trim(dw_property_list.context_object) = "" then
	dw_property_list.context_object = "Patient"
	st_context_patient.backcolor = color_object_selected
else
	st_context_general.visible = false
	st_context_patient.visible = false
	st_context_encounter.visible = false
	st_context_assessment.visible = false
	st_context_treatment.visible = false
	st_context_observation.visible = false
	st_context_attachment.visible = false

	if allow_context_object_change then
		luo_data = CREATE u_ds_data
		luo_data.set_dataobject("dw_v_Compatible_Context_Object")
		ll_count = luo_data.retrieve(dw_property_list.context_object)
		
		for i = 1 to ll_count
			ls_compatible_context_object = luo_data.object.compatible_context_object[i]
			if ls_compatible_context_object = dw_property_list.context_object then
				lb_same = true
			else
				lb_same = false
			end if
			CHOOSE CASE wordcap(lower(ls_compatible_context_object))
				CASE "General"
					if lb_same then st_context_general.backcolor = color_object_selected
					st_context_general.visible = true
				CASE "Patient"
					if lb_same then st_context_patient.backcolor = color_object_selected
					st_context_patient.visible = true
				CASE "Encounter"
					if lb_same then st_context_encounter.backcolor = color_object_selected
					st_context_encounter.visible = true
				CASE "Assessment"
					if lb_same then st_context_assessment.backcolor = color_object_selected
					st_context_assessment.visible = true
				CASE "Treatment"
					if lb_same then st_context_treatment.backcolor = color_object_selected
					st_context_treatment.visible = true
				CASE "Observation"
					if lb_same then st_context_observation.backcolor = color_object_selected
					st_context_observation.visible = true
				CASE "Attachment"
					if lb_same then st_context_attachment.backcolor = color_object_selected
					st_context_attachment.visible = true
			END CHOOSE
		next
		
		
		DESTROY luo_data
	else
		st_context_general.visible = true
		st_context_general.enabled = false
		st_context_general.text = wordcap(dw_property_list.context_object)
		st_context_general.borderstyle = StyleBox!
	end if
end if


dw_property_list.initialize("property")

if dw_property_list.allow_editing then
	cb_new_property.visible = true
else
	cb_new_property.visible = false
end if

if isnull(current_patient) then
	title = st_title.text
else
	title = current_patient.id_line()
end if

if dw_property_list.mode = "PICK" then
	cb_ok.enabled = false
	cb_cancel.visible = true
else
	cb_ok.enabled = true
	cb_cancel.visible = false
end if

st_status.text = "Active"
dw_property_list.status = "OK"

dw_property_list.search_top_20()
if dw_property_list.rowcount() = 0 then
	dw_property_list.search_description(ls_null)
end if


end event

on w_pick_property.create
int iCurrent
call super::create
this.st_search_title=create st_search_title
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
this.st_top_20=create st_top_20
this.st_search_status=create st_search_status
this.st_context_general=create st_context_general
this.st_context_object_title=create st_context_object_title
this.st_title=create st_title
this.st_description=create st_description
this.dw_property_list=create dw_property_list
this.st_context_patient=create st_context_patient
this.st_context_encounter=create st_context_encounter
this.st_context_assessment=create st_context_assessment
this.st_context_treatment=create st_context_treatment
this.st_context_observation=create st_context_observation
this.st_context_attachment=create st_context_attachment
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.st_category=create st_category
this.st_status_title=create st_status_title
this.st_status=create st_status
this.cb_new_property=create cb_new_property
this.st_property_name=create st_property_name
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_search_title
this.Control[iCurrent+2]=this.pb_up
this.Control[iCurrent+3]=this.pb_down
this.Control[iCurrent+4]=this.st_page
this.Control[iCurrent+5]=this.st_top_20
this.Control[iCurrent+6]=this.st_search_status
this.Control[iCurrent+7]=this.st_context_general
this.Control[iCurrent+8]=this.st_context_object_title
this.Control[iCurrent+9]=this.st_title
this.Control[iCurrent+10]=this.st_description
this.Control[iCurrent+11]=this.dw_property_list
this.Control[iCurrent+12]=this.st_context_patient
this.Control[iCurrent+13]=this.st_context_encounter
this.Control[iCurrent+14]=this.st_context_assessment
this.Control[iCurrent+15]=this.st_context_treatment
this.Control[iCurrent+16]=this.st_context_observation
this.Control[iCurrent+17]=this.st_context_attachment
this.Control[iCurrent+18]=this.cb_ok
this.Control[iCurrent+19]=this.cb_cancel
this.Control[iCurrent+20]=this.st_category
this.Control[iCurrent+21]=this.st_status_title
this.Control[iCurrent+22]=this.st_status
this.Control[iCurrent+23]=this.cb_new_property
this.Control[iCurrent+24]=this.st_property_name
end on

on w_pick_property.destroy
call super::destroy
destroy(this.st_search_title)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
destroy(this.st_top_20)
destroy(this.st_search_status)
destroy(this.st_context_general)
destroy(this.st_context_object_title)
destroy(this.st_title)
destroy(this.st_description)
destroy(this.dw_property_list)
destroy(this.st_context_patient)
destroy(this.st_context_encounter)
destroy(this.st_context_assessment)
destroy(this.st_context_treatment)
destroy(this.st_context_observation)
destroy(this.st_context_attachment)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.st_category)
destroy(this.st_status_title)
destroy(this.st_status)
destroy(this.cb_new_property)
destroy(this.st_property_name)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_pick_property
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pick_property
end type

type st_search_title from statictext within w_pick_property
integer x = 1888
integer y = 872
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

type pb_up from u_picture_button within w_pick_property
integer x = 1463
integer y = 120
integer width = 137
integer height = 116
integer taborder = 20
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_property_list.current_page

dw_property_list.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_pick_property
integer x = 1463
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

li_page = dw_property_list.current_page
li_last_page = dw_property_list.last_page

dw_property_list.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type st_page from statictext within w_pick_property
integer x = 1600
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

type st_top_20 from statictext within w_pick_property
integer x = 1522
integer y = 984
integer width = 302
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
	if dw_property_list.search_description = "Personal List" then
		dw_property_list.search_top_20(false)
	else
		dw_property_list.search_top_20(true)
	end if
else
	if dw_property_list.search_description = "Personal List" then
		dw_property_list.search_top_20(true)
	else
		dw_property_list.search_top_20(false)
	end if
end if


end event

type st_search_status from statictext within w_pick_property
integer x = 1495
integer y = 1120
integer width = 1349
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

type st_context_general from statictext within w_pick_property
integer x = 1929
integer y = 284
integer width = 475
integer height = 108
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "General"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_context_assessment.backcolor = color_object
st_context_attachment.backcolor = color_object
st_context_encounter.backcolor = color_object
st_context_general.backcolor = color_object
st_context_observation.backcolor = color_object
st_context_patient.backcolor = color_object
st_context_treatment.backcolor = color_object

dw_property_list.context_object = "General"
backcolor = color_object_selected

dw_property_list.search()

end event

type st_context_object_title from statictext within w_pick_property
integer x = 1819
integer y = 180
integer width = 695
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Context Object"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title from statictext within w_pick_property
integer width = 2926
integer height = 108
integer textsize = -14
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Select property"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_description from statictext within w_pick_property
integer x = 1838
integer y = 984
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
string text = "Description"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_property_list.search_description()

end event

type dw_property_list from u_dw_property_list within w_pick_property
integer x = 14
integer y = 108
integer width = 1440
integer height = 1592
integer taborder = 90
boolean vscrollbar = true
end type

event list_loaded;call super::list_loaded;search_type = current_search

st_top_20.backcolor = color_object
st_description.backcolor = color_object
st_category.backcolor = color_object

st_search_status.text = ps_description

CHOOSE CASE upper(current_search)
	CASE "TOP20"
		st_top_20.backcolor = color_object_selected
	CASE "DESCRIPTION"
		st_description.backcolor = color_object_selected
	CASE "PROPERTY NAME"
		st_property_name.backcolor = color_object_selected
	CASE "CATEGORY"
		st_category.backcolor = color_object_selected
END CHOOSE

last_page = 0
set_page(1, pb_up, pb_down, st_page)


end event

event selected;call super::selected;if dw_property_list.mode = "PICK" then
	cb_ok.enabled = true
end if

end event

event unselected;call super::unselected;if dw_property_list.mode = "PICK" then
	cb_ok.enabled = false
end if

end event

type st_context_patient from statictext within w_pick_property
integer x = 1669
integer y = 404
integer width = 475
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Patient"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_context_assessment.backcolor = color_object
st_context_attachment.backcolor = color_object
st_context_encounter.backcolor = color_object
st_context_general.backcolor = color_object
st_context_observation.backcolor = color_object
st_context_patient.backcolor = color_object
st_context_treatment.backcolor = color_object

dw_property_list.context_object = "Patient"
backcolor = color_object_selected

dw_property_list.search()

end event

type st_context_encounter from statictext within w_pick_property
integer x = 1669
integer y = 520
integer width = 475
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Encounter"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_context_assessment.backcolor = color_object
st_context_attachment.backcolor = color_object
st_context_encounter.backcolor = color_object
st_context_general.backcolor = color_object
st_context_observation.backcolor = color_object
st_context_patient.backcolor = color_object
st_context_treatment.backcolor = color_object

dw_property_list.context_object = "Encounter"
backcolor = color_object_selected

dw_property_list.search()

end event

type st_context_assessment from statictext within w_pick_property
integer x = 1669
integer y = 636
integer width = 475
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Assessment"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_context_assessment.backcolor = color_object
st_context_attachment.backcolor = color_object
st_context_encounter.backcolor = color_object
st_context_general.backcolor = color_object
st_context_observation.backcolor = color_object
st_context_patient.backcolor = color_object
st_context_treatment.backcolor = color_object

dw_property_list.context_object = "Assessment"
backcolor = color_object_selected

dw_property_list.search()

end event

type st_context_treatment from statictext within w_pick_property
integer x = 2203
integer y = 404
integer width = 475
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Treatment"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_context_assessment.backcolor = color_object
st_context_attachment.backcolor = color_object
st_context_encounter.backcolor = color_object
st_context_general.backcolor = color_object
st_context_observation.backcolor = color_object
st_context_patient.backcolor = color_object
st_context_treatment.backcolor = color_object

dw_property_list.context_object = "Treatment"
backcolor = color_object_selected

dw_property_list.search()

end event

type st_context_observation from statictext within w_pick_property
integer x = 2203
integer y = 520
integer width = 475
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Observation"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_context_assessment.backcolor = color_object
st_context_attachment.backcolor = color_object
st_context_encounter.backcolor = color_object
st_context_general.backcolor = color_object
st_context_observation.backcolor = color_object
st_context_patient.backcolor = color_object
st_context_treatment.backcolor = color_object

dw_property_list.context_object = "Observation"
backcolor = color_object_selected

dw_property_list.search()

end event

type st_context_attachment from statictext within w_pick_property
integer x = 2203
integer y = 636
integer width = 475
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Attachment"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_context_assessment.backcolor = color_object
st_context_attachment.backcolor = color_object
st_context_encounter.backcolor = color_object
st_context_general.backcolor = color_object
st_context_observation.backcolor = color_object
st_context_patient.backcolor = color_object
st_context_treatment.backcolor = color_object

dw_property_list.context_object = "Attachment"
backcolor = color_object_selected

dw_property_list.search()

end event

type cb_ok from commandbutton within w_pick_property
integer x = 2441
integer y = 1580
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
string text = "OK"
boolean default = true
end type

event clicked;string ls_property_id
long ll_row
str_property lstr_property
long ll_property_id

if dw_property_list.mode = "EDIT" then
	setnull(lstr_property.property_id)
	Closewithreturn(parent, lstr_property)

	return
end if

ll_row = dw_property_list.get_selected_row()
if ll_row <= 0 then return

ll_property_id = dw_property_list.object.property_id[ll_row]

lstr_property = datalist.find_property(ll_property_id)
if isnull(lstr_property.property_id) then
	openwithparm(w_pop_message, "Property not found")
	return
end if

Closewithreturn(parent, lstr_property)


end event

type cb_cancel from commandbutton within w_pick_property
integer x = 1943
integer y = 1580
integer width = 402
integer height = 112
integer taborder = 110
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

event clicked;str_property lstr_property

setnull(lstr_property.property_id)
Closewithreturn(parent, lstr_property)


end event

type st_category from statictext within w_pick_property
integer x = 2514
integer y = 984
integer width = 302
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

event clicked;dw_property_list.search_category()

end event

type st_status_title from statictext within w_pick_property
integer x = 1513
integer y = 1268
integer width = 434
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Show"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_status from statictext within w_pick_property
integer x = 1513
integer y = 1340
integer width = 434
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Active"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if dw_property_list.status = "OK" then
	dw_property_list.status = "NA"
	text = "Inactive"
else
	dw_property_list.status = "OK"
	text = "Active"
end if

refresh()

end event

type cb_new_property from commandbutton within w_pick_property
boolean visible = false
integer x = 2121
integer y = 1340
integer width = 709
integer height = 112
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Create New property"
end type

event clicked;string ls_property_id
string ls_description
str_popup_return popup_return


//ls_property_id = f_new_property()
if len(ls_property_id) > 0 then
	SELECT description
	INTO :ls_description
	FROM c_property_Definition
	WHERE property_id = :ls_property_id;
	if not tf_check() then return
	if sqlca.sqlcode = 100 then return

	popup_return.item_count = 1
	popup_return.items[1] = ls_property_id
	popup_return.descriptions[1] = ls_description
	
	Closewithreturn(parent, popup_return)
end if




end event

type st_property_name from statictext within w_pick_property
integer x = 2199
integer y = 984
integer width = 302
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
string text = "Name"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_property_list.search_property_name( )


end event

