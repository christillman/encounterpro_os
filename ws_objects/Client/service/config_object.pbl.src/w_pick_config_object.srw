$PBExportHeader$w_pick_config_object.srw
forward
global type w_pick_config_object from w_window_base
end type
type st_search_title from statictext within w_pick_config_object
end type
type pb_up from u_picture_button within w_pick_config_object
end type
type pb_down from u_picture_button within w_pick_config_object
end type
type st_page from statictext within w_pick_config_object
end type
type st_top_20 from statictext within w_pick_config_object
end type
type st_search_status from statictext within w_pick_config_object
end type
type st_context_general from statictext within w_pick_config_object
end type
type st_context_object_title from statictext within w_pick_config_object
end type
type st_title from statictext within w_pick_config_object
end type
type st_description from statictext within w_pick_config_object
end type
type dw_config_object_list from u_dw_config_object_list within w_pick_config_object
end type
type st_context_patient from statictext within w_pick_config_object
end type
type st_context_encounter from statictext within w_pick_config_object
end type
type st_context_assessment from statictext within w_pick_config_object
end type
type st_context_treatment from statictext within w_pick_config_object
end type
type st_context_observation from statictext within w_pick_config_object
end type
type st_context_attachment from statictext within w_pick_config_object
end type
type cb_cancel from commandbutton within w_pick_config_object
end type
type st_category from statictext within w_pick_config_object
end type
type st_status_title from statictext within w_pick_config_object
end type
type st_status from statictext within w_pick_config_object
end type
type cb_new_config_object from commandbutton within w_pick_config_object
end type
type st_library from statictext within w_pick_config_object
end type
type cb_import from commandbutton within w_pick_config_object
end type
type cb_refresh_library from commandbutton within w_pick_config_object
end type
type st_show_beta_title from statictext within w_pick_config_object
end type
type st_show_beta from statictext within w_pick_config_object
end type
type st_owner_filter_title from statictext within w_pick_config_object
end type
type st_owner_filter from statictext within w_pick_config_object
end type
end forward

global type w_pick_config_object from w_window_base
integer height = 1836
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
dw_config_object_list dw_config_object_list
st_context_patient st_context_patient
st_context_encounter st_context_encounter
st_context_assessment st_context_assessment
st_context_treatment st_context_treatment
st_context_observation st_context_observation
st_context_attachment st_context_attachment
cb_cancel cb_cancel
st_category st_category
st_status_title st_status_title
st_status st_status
cb_new_config_object cb_new_config_object
st_library st_library
cb_import cb_import
cb_refresh_library cb_refresh_library
st_show_beta_title st_show_beta_title
st_show_beta st_show_beta
st_owner_filter_title st_owner_filter_title
st_owner_filter st_owner_filter
end type
global w_pick_config_object w_pick_config_object

type variables
String search_type
string config_object_type

end variables

forward prototypes
public function integer refresh ()
public subroutine select_config_object (long pl_row)
end prototypes

public function integer refresh ();dw_config_object_list.search()

return 1

end function

public subroutine select_config_object (long pl_row);//string ls_config_object_id
str_popup_return popup_return

popup_return.item_count = 1

popup_return.items[1] = dw_config_object_list.object.config_object_id[pl_row]
popup_return.descriptions[1] = dw_config_object_list.object.description[pl_row]

Closewithreturn(this, popup_return)


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
string ls_null
str_popup popup
u_ds_data luo_data
long ll_count
long i
string ls_compatible_context_object
boolean lb_same
str_pick_config_object lstr_pick_config_object

setnull(ls_null)

lstr_pick_config_object = message.powerobjectparm
config_object_type= lstr_pick_config_object.config_object_type
dw_config_object_list.context_object = lstr_pick_config_object.context_object

if len(lstr_pick_config_object.mode) > 0 then
	dw_config_object_list.mode = lstr_pick_config_object.mode
else
	dw_config_object_list.mode = "PICK"
end if

if lower(sqlca.database_mode) = "testing" then
	st_show_beta_title.text = "Show Testing && Beta"
else
	st_show_beta_title.text = "Show Beta Versions"
end if

dw_config_object_list.show_beta = lstr_pick_config_object.show_beta
if dw_config_object_list.show_beta then
	st_show_beta.text = "Yes"
else
	st_show_beta.text = "No"
end if



if isnull(dw_config_object_list.context_object) or trim(dw_config_object_list.context_object) = "" then
	dw_config_object_list.context_object = "Patient"
	st_context_patient.backcolor = color_object_selected
else
	st_context_general.visible = false
	st_context_patient.visible = false
	st_context_encounter.visible = false
	st_context_assessment.visible = false
	st_context_treatment.visible = false
	st_context_observation.visible = false
	st_context_attachment.visible = false

	luo_data = CREATE u_ds_data
	luo_data.set_dataobject("dw_v_Compatible_Context_Object")
	ll_count = luo_data.retrieve(dw_config_object_list.context_object)
	
	for i = 1 to ll_count
		ls_compatible_context_object = luo_data.object.compatible_context_object[i]
		if ls_compatible_context_object = dw_config_object_list.context_object then
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
end if


dw_config_object_list.initialize(config_object_type)

if lstr_pick_config_object.owner_filter = 0 then
	// for backward compatibility, we can't default to owner=0 because that is the default value of dw_config_object_list.owner_filter
	setnull(dw_config_object_list.owner_filter)
else
	dw_config_object_list.owner_filter = lstr_pick_config_object.owner_filter
	if dw_config_object_list.owner_filter > 0 and dw_config_object_list.owner_filter < 900 then
		st_owner_filter.borderstyle = stylebox!
	end if
end if

st_title.text = "Select " + wordcap(config_object_type)

if dw_config_object_list.allow_editing then
	cb_new_config_object.visible = true
else
	cb_new_config_object.visible = false
end if

if isnull(current_patient) then
	title = st_title.text
else
	title = current_patient.id_line()
end if

if dw_config_object_list.mode = "PICK" then
	// If we're in Pick mode then the cancel button is labeled "Cancel"
	cb_cancel.text = "Cancel"
else
	// any other mode and the cancel button is labeled "OK" and moved to the lower right
	cb_cancel.text = "OK"
	cb_cancel.x = width - cb_cancel.width - 50
end if

st_status.text = "Active"
dw_config_object_list.status = "OK"

dw_config_object_list.search_top_20()
if dw_config_object_list.rowcount() = 0 then
	dw_config_object_list.search_description(ls_null)
end if




end event

on w_pick_config_object.create
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
this.dw_config_object_list=create dw_config_object_list
this.st_context_patient=create st_context_patient
this.st_context_encounter=create st_context_encounter
this.st_context_assessment=create st_context_assessment
this.st_context_treatment=create st_context_treatment
this.st_context_observation=create st_context_observation
this.st_context_attachment=create st_context_attachment
this.cb_cancel=create cb_cancel
this.st_category=create st_category
this.st_status_title=create st_status_title
this.st_status=create st_status
this.cb_new_config_object=create cb_new_config_object
this.st_library=create st_library
this.cb_import=create cb_import
this.cb_refresh_library=create cb_refresh_library
this.st_show_beta_title=create st_show_beta_title
this.st_show_beta=create st_show_beta
this.st_owner_filter_title=create st_owner_filter_title
this.st_owner_filter=create st_owner_filter
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
this.Control[iCurrent+11]=this.dw_config_object_list
this.Control[iCurrent+12]=this.st_context_patient
this.Control[iCurrent+13]=this.st_context_encounter
this.Control[iCurrent+14]=this.st_context_assessment
this.Control[iCurrent+15]=this.st_context_treatment
this.Control[iCurrent+16]=this.st_context_observation
this.Control[iCurrent+17]=this.st_context_attachment
this.Control[iCurrent+18]=this.cb_cancel
this.Control[iCurrent+19]=this.st_category
this.Control[iCurrent+20]=this.st_status_title
this.Control[iCurrent+21]=this.st_status
this.Control[iCurrent+22]=this.cb_new_config_object
this.Control[iCurrent+23]=this.st_library
this.Control[iCurrent+24]=this.cb_import
this.Control[iCurrent+25]=this.cb_refresh_library
this.Control[iCurrent+26]=this.st_show_beta_title
this.Control[iCurrent+27]=this.st_show_beta
this.Control[iCurrent+28]=this.st_owner_filter_title
this.Control[iCurrent+29]=this.st_owner_filter
end on

on w_pick_config_object.destroy
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
destroy(this.dw_config_object_list)
destroy(this.st_context_patient)
destroy(this.st_context_encounter)
destroy(this.st_context_assessment)
destroy(this.st_context_treatment)
destroy(this.st_context_observation)
destroy(this.st_context_attachment)
destroy(this.cb_cancel)
destroy(this.st_category)
destroy(this.st_status_title)
destroy(this.st_status)
destroy(this.cb_new_config_object)
destroy(this.st_library)
destroy(this.cb_import)
destroy(this.cb_refresh_library)
destroy(this.st_show_beta_title)
destroy(this.st_show_beta)
destroy(this.st_owner_filter_title)
destroy(this.st_owner_filter)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_pick_config_object
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pick_config_object
end type

type st_search_title from statictext within w_pick_config_object
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
long backcolor = 7191717
string text = "Search Options"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_up from u_picture_button within w_pick_config_object
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

li_page = dw_config_object_list.current_page

dw_config_object_list.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_pick_config_object
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

li_page = dw_config_object_list.current_page
li_last_page = dw_config_object_list.last_page

dw_config_object_list.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type st_page from statictext within w_pick_config_object
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
long backcolor = 7191717
string text = "Page 99/99"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_top_20 from statictext within w_pick_config_object
integer x = 1499
integer y = 984
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

event clicked;if search_type = "TOP20" then
	if dw_config_object_list.search_description = "Personal List" then
		dw_config_object_list.search_top_20(false)
	else
		dw_config_object_list.search_top_20(true)
	end if
else
	if dw_config_object_list.search_description = "Personal List" then
		dw_config_object_list.search_top_20(true)
	else
		dw_config_object_list.search_top_20(false)
	end if
end if


end event

type st_search_status from statictext within w_pick_config_object
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

type st_context_general from statictext within w_pick_config_object
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

dw_config_object_list.context_object = "General"
backcolor = color_object_selected

dw_config_object_list.search()

end event

type st_context_object_title from statictext within w_pick_config_object
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
long backcolor = 7191717
boolean enabled = false
string text = "Context Object"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title from statictext within w_pick_config_object
integer width = 2926
integer height = 108
integer textsize = -14
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Select config_object"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_description from statictext within w_pick_config_object
integer x = 1865
integer y = 984
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

event clicked;dw_config_object_list.search_description()

end event

type dw_config_object_list from u_dw_config_object_list within w_pick_config_object
integer x = 14
integer y = 108
integer width = 1440
integer height = 1476
integer taborder = 90
boolean vscrollbar = true
end type

event config_objects_loaded;call super::config_objects_loaded;search_type = current_search

st_top_20.backcolor = color_object
st_description.backcolor = color_object
st_category.backcolor = color_object
st_library.backcolor = color_object

st_search_status.text = ps_description
cb_refresh_library.visible = false

if owner_filter = -1 then
	st_owner_filter.text = "Shareware"
elseif owner_filter >= 0 then
	st_owner_filter.text = sqlca.fn_owner_description(owner_filter)
else
	st_owner_filter.text = "All Owners"
end if

CHOOSE CASE upper(current_search)
	CASE "TOP20"
		st_top_20.backcolor = color_object_selected
	CASE "DESCRIPTION"
		st_description.backcolor = color_object_selected
	CASE "CATEGORY"
		st_category.backcolor = color_object_selected
	CASE "LIBRARY"
		st_library.backcolor = color_object_selected
		cb_refresh_library.visible = true
END CHOOSE

last_page = 0
set_page(1, pb_up, pb_down, st_page)


end event

event item_selected;call super::item_selected;select_config_object(pl_row)

end event

type st_context_patient from statictext within w_pick_config_object
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

dw_config_object_list.context_object = "Patient"
backcolor = color_object_selected

dw_config_object_list.search()

end event

type st_context_encounter from statictext within w_pick_config_object
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

dw_config_object_list.context_object = "Encounter"
backcolor = color_object_selected

dw_config_object_list.search()

end event

type st_context_assessment from statictext within w_pick_config_object
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

dw_config_object_list.context_object = "Assessment"
backcolor = color_object_selected

dw_config_object_list.search()

end event

type st_context_treatment from statictext within w_pick_config_object
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

dw_config_object_list.context_object = "Treatment"
backcolor = color_object_selected

dw_config_object_list.search()

end event

type st_context_observation from statictext within w_pick_config_object
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

dw_config_object_list.context_object = "Observation"
backcolor = color_object_selected

dw_config_object_list.search()

end event

type st_context_attachment from statictext within w_pick_config_object
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

dw_config_object_list.context_object = "Attachment"
backcolor = color_object_selected

dw_config_object_list.search()

end event

type cb_cancel from commandbutton within w_pick_config_object
integer x = 18
integer y = 1604
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

event clicked;str_popup_return popup_return

popup_return.item_count = 0
Closewithreturn(parent, popup_return)


end event

type st_category from statictext within w_pick_config_object
integer x = 2231
integer y = 984
integer width = 288
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

event clicked;dw_config_object_list.search_category()

end event

type st_status_title from statictext within w_pick_config_object
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
long backcolor = 7191717
string text = "Show"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_status from statictext within w_pick_config_object
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

event clicked;if dw_config_object_list.status = "OK" then
	dw_config_object_list.status = "NA"
	text = "Inactive"
else
	dw_config_object_list.status = "OK"
	text = "Active"
end if

refresh()

end event

type cb_new_config_object from commandbutton within w_pick_config_object
integer x = 2117
integer y = 1392
integer width = 603
integer height = 112
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Create New"
end type

event clicked;string ls_config_object_id
string ls_description
str_popup_return popup_return
str_attributes lstr_attributes

ls_config_object_id = f_new_config_object(config_object_type, lstr_attributes)
if len(ls_config_object_id) > 0 then
	SELECT description
	INTO :ls_description
	FROM c_config_object
	WHERE config_object_id = :ls_config_object_id;
	if not tf_check() then return
	if sqlca.sqlcode = 100 then return

	if dw_config_object_list.mode = "PICK" then
		popup_return.item_count = 1
		popup_return.items[1] = ls_config_object_id
		popup_return.descriptions[1] = ls_description
		
		Closewithreturn(parent, popup_return)
		return
	end if
end if

f_configure_config_object(ls_config_object_id)

refresh()

end event

type st_library from statictext within w_pick_config_object
integer x = 2542
integer y = 984
integer width = 288
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
string text = "Library"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_config_object_list.search_library()

end event

type cb_import from commandbutton within w_pick_config_object
integer x = 2117
integer y = 1256
integer width = 603
integer height = 112
integer taborder = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Import From File"
end type

event clicked;string ls_id
string ls_url
long ll_from_material_id
string ls_parent_config_object_id
long ll_category
long ll_material_id
string ls_config_object_id
string ls_description
str_attributes lstr_attributes
integer li_sts
string ls_object_xml
blob lbl_object_data
str_config_object_version lstr_config_object_version
str_config_object_info lstr_config_object_info
str_config_object_type lstr_config_object_type
string ls_pathname
string ls_filename
string ls_filter
str_popup popup
long ll_choice
string ls_top_20_code
string ls_null
long ll_null
str_filepath lstr_filepath
u_ds_data luo_data
long ll_count
string ls_extension
long i
str_popup_return popup_return
string ls_component_id

setnull(ls_null)
setnull(ll_null)

ls_filter += "JMJ Config File (*.jmjcfg), *.jmjcfg"

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_config_object_template_extensions")
ll_count = luo_data.retrieve(config_object_type)
for i = 1 to ll_count
	ls_extension = luo_data.object.extension[i]
	ls_filter += ", " + upper(ls_extension) + " File (*." + lower(ls_extension) + "), *." + lower(ls_extension)
next

ls_filter += ", All Files (*.*), *.*"


li_sts = GetFileOpenName("Select File", ls_pathname, ls_filename, "jmjcfg", ls_filter)
if li_sts <= 0 then return

if not fileexists(ls_filename) then return

li_sts = log.file_read(ls_filename, lbl_object_data)
if li_sts <= 0 then return

lstr_filepath = f_parse_filepath2(ls_filename)

if lower(lstr_filepath.extension) = "xml" or lower(lstr_filepath.extension) = "jmjcfg" then
	ls_object_xml = f_blob_to_string(lbl_object_data)
	
	li_sts = f_config_object_import_xml(ls_object_xml, lstr_config_object_version)
	if li_sts <= 0 then
		openwithparm(w_pop_message, "Import Failed")
		return
	end if

	li_sts = f_get_config_object_info(lstr_config_object_version.config_object_id, lstr_config_object_info)
	if li_sts <= 0 then
		openwithparm(w_pop_message, "Import Succeeded but getting object info failed (" + lstr_config_object_version.config_object_id + ")")
		return
	end if

	// See if we should automatically install this component
	lstr_config_object_type = datalist.get_config_object_type(lstr_config_object_version.config_object_type)
	if lstr_config_object_type.auto_install then
		li_sts = f_config_object_install(lstr_config_object_version.config_object_id, lstr_config_object_version.version)
		if li_sts <= 0 then
			openwithparm(w_pop_message, "Import Succeeded but install failed (" + lstr_config_object_version.config_object_id + ")")
			return
		end if
	end if
else
	// See if there is a report that uses this filetype as a template
	popup.title = "Select Component for New " + wordcap(config_object_type)
	popup.dataobject = "dw_config_components_for_extension"
	popup.argument_count = 2
	popup.argument[1] = config_object_type
	popup.argument[2] = lstr_filepath.extension
	popup.datacolumn = 1
	popup.displaycolumn = 2
	popup.auto_singleton = true
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then
		if popup_return.choices_count > 0 then return
		openwithparm(w_pop_message, "There is no available " + lower(config_object_type) + " component for a template of type ~"" + upper(lstr_filepath.extension) + "~"")
		return
	end if
	
	ls_component_id = popup_return.items[1]
	
	f_attribute_add_attribute(lstr_attributes, "component_id", ls_component_id)

	setnull(ls_id)
	setnull(ls_url)
	setnull(ll_from_material_id)
	setnull(ls_parent_config_object_id)
	setnull(ll_category)
	
	ll_material_id = sqlca.jmj_new_material(lstr_filepath.filename, ll_category, "OK", lstr_filepath.extension, ls_id, ls_url, current_scribe.user_id, lstr_filepath.filename, ll_from_material_id, ls_parent_config_object_id)
	if not tf_check() then return
	
	if ll_material_id > 0 then
		// Update the blob column of the new material record
		UpdateBlob c_patient_material
		Set object = :lbl_object_data 
		Where material_id = :ll_material_id;
		If not tf_check() Then return

		f_attribute_add_attribute(lstr_attributes, "template_material_id", string(ll_material_id))
	
		ls_config_object_id = f_new_config_object(config_object_type, lstr_attributes)
		if len(ls_config_object_id) > 0 then
			SELECT description
			INTO :ls_description
			FROM c_config_object
			WHERE config_object_id = :ls_config_object_id;
			if not tf_check() then return
			if sqlca.sqlcode = 100 then return
		
			popup_return.item_count = 1
			popup_return.items[1] = ls_config_object_id
			popup_return.descriptions[1] = ls_description
			
			Closewithreturn(parent, popup_return)
			return
		else
			openwithparm(w_pop_message, "An error occured creating the new " + lower(config_object_type))
			return
		end if
	end if
end if

popup.title = "Import Succeeded.  Do you wish to add ~"" + lstr_config_object_version.description + "~" to your Top-20 list?"
popup.data_row_count = 3
popup.items[1] = "Add to Personal Top-20 List"
popup.items[2] = "Add to Common Top-20 List"
popup.items[3] = "Do not add to Top-20 List"
openwithparm(w_pop_choices_3, popup)
ll_choice = message.doubleparm
if ll_choice = 1 then
	ls_top_20_code = dw_config_object_list.pick_top_20_code(lstr_config_object_info.context_object)
	if not isnull(ls_top_20_code) then
		li_sts = tf_add_personal_top_20(ls_top_20_code, lstr_config_object_info.description, lstr_config_object_info.config_object_id, ls_null, ll_null)
	end if
elseif ll_choice = 2 then
	ls_top_20_code = dw_config_object_list.pick_top_20_code(lstr_config_object_info.context_object)
	if not isnull(ls_top_20_code) then
		li_sts = tf_add_common_top_20(ls_top_20_code, lstr_config_object_info.description, lstr_config_object_info.config_object_id, ls_null, ll_null)
	end if
end if

refresh()

return

end event

type cb_refresh_library from commandbutton within w_pick_config_object
boolean visible = false
integer x = 2478
integer y = 864
integer width = 384
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Refresh Library"
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_message
integer li_idx

messagebox("Obsolete", "dbo.jmjsys_sync_config_objects is no more")
//ls_message = "Are you sure you want to refresh the library database?  This may take several minutes."
//
//openwithparm(w_pop_yes_no, ls_message)
//popup_return = message.powerobjectparm
//if popup_return.item <> "YES" then return
//
//li_idx = f_please_wait_open()
//
//DECLARE lsp_sync_library PROCEDURE FOR dbo.jmjsys_sync_config_objects;
//
//EXECUTE lsp_sync_library;
//if not tf_check() then
//	f_please_wait_close(li_idx)
//	openwithparm(w_pop_message, "An error occured refreshing the library database.  Please try again later or contact JMJ Customer Support for assistance.")
//	return
//end if
//
//f_please_wait_close(li_idx)
//
dw_config_object_list.search()

end event

type st_show_beta_title from statictext within w_pick_config_object
integer x = 1559
integer y = 1480
integer width = 343
integer height = 112
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Show Beta Versions"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_show_beta from statictext within w_pick_config_object
integer x = 1618
integer y = 1600
integer width = 224
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if dw_config_object_list.show_beta then
	dw_config_object_list.show_beta = false
	text = "No"
else
	dw_config_object_list.show_beta = true
	text = "Yes"
end if

refresh()

end event

type st_owner_filter_title from statictext within w_pick_config_object
integer x = 1669
integer y = 768
integer width = 219
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
string text = "Owner:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_owner_filter from statictext within w_pick_config_object
integer x = 1902
integer y = 768
integer width = 777
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "All Owners"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
u_user luo_user

if borderstyle = stylebox! then
	if not config_mode then return
	if not user_list.is_superuser(current_scribe.user_id) then return
end if

popup.dataobject = "dw_fn_config_object_owner_pick"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.argument_count = 0
popup.add_blank_row = true
popup.blank_text = "All Owners"
popup.blank_at_bottom = true
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	// All Owners
	dw_config_object_list.owner_filter = -99
else
	dw_config_object_list.owner_filter = long(popup_return.items[1])
end if

text = popup_return.descriptions[1]


refresh()

end event

