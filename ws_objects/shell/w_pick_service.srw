HA$PBExportHeader$w_pick_service.srw
forward
global type w_pick_service from w_window_base
end type
type pb_up from u_picture_button within w_pick_service
end type
type pb_down from u_picture_button within w_pick_service
end type
type st_page from statictext within w_pick_service
end type
type st_context_general from statictext within w_pick_service
end type
type st_context_object_title from statictext within w_pick_service
end type
type st_title from statictext within w_pick_service
end type
type st_context_patient from statictext within w_pick_service
end type
type st_context_encounter from statictext within w_pick_service
end type
type st_context_assessment from statictext within w_pick_service
end type
type st_context_treatment from statictext within w_pick_service
end type
type st_context_observation from statictext within w_pick_service
end type
type st_context_attachment from statictext within w_pick_service
end type
type cb_cancel from commandbutton within w_pick_service
end type
type dw_services from u_dw_pick_list within w_pick_service
end type
end forward

global type w_pick_service from w_window_base
integer height = 1836
boolean controlmenu = false
windowtype windowtype = response!
pb_up pb_up
pb_down pb_down
st_page st_page
st_context_general st_context_general
st_context_object_title st_context_object_title
st_title st_title
st_context_patient st_context_patient
st_context_encounter st_context_encounter
st_context_assessment st_context_assessment
st_context_treatment st_context_treatment
st_context_observation st_context_observation
st_context_attachment st_context_attachment
cb_cancel cb_cancel
dw_services dw_services
end type
global w_pick_service w_pick_service

type variables
String search_type
string compatible_context_object

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
string ls_null
str_popup popup
u_ds_data luo_data
long ll_count
long i
string ls_compatible_context_object
boolean lb_same

setnull(ls_null)

compatible_context_object = message.stringparm


if isnull(compatible_context_object) or trim(compatible_context_object) = "" then
	compatible_context_object = "Patient"
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
	ll_count = luo_data.retrieve(compatible_context_object)
	
	for i = 1 to ll_count
		ls_compatible_context_object = luo_data.object.compatible_context_object[i]
		if ls_compatible_context_object = compatible_context_object then
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


dw_services.settransobject(sqlca)
dw_services.retrieve(compatible_context_object)

if isnull(current_patient) then
	title = st_title.text
else
	title = current_patient.id_line()
end if



end event

on w_pick_service.create
int iCurrent
call super::create
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
this.st_context_general=create st_context_general
this.st_context_object_title=create st_context_object_title
this.st_title=create st_title
this.st_context_patient=create st_context_patient
this.st_context_encounter=create st_context_encounter
this.st_context_assessment=create st_context_assessment
this.st_context_treatment=create st_context_treatment
this.st_context_observation=create st_context_observation
this.st_context_attachment=create st_context_attachment
this.cb_cancel=create cb_cancel
this.dw_services=create dw_services
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_up
this.Control[iCurrent+2]=this.pb_down
this.Control[iCurrent+3]=this.st_page
this.Control[iCurrent+4]=this.st_context_general
this.Control[iCurrent+5]=this.st_context_object_title
this.Control[iCurrent+6]=this.st_title
this.Control[iCurrent+7]=this.st_context_patient
this.Control[iCurrent+8]=this.st_context_encounter
this.Control[iCurrent+9]=this.st_context_assessment
this.Control[iCurrent+10]=this.st_context_treatment
this.Control[iCurrent+11]=this.st_context_observation
this.Control[iCurrent+12]=this.st_context_attachment
this.Control[iCurrent+13]=this.cb_cancel
this.Control[iCurrent+14]=this.dw_services
end on

on w_pick_service.destroy
call super::destroy
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
destroy(this.st_context_general)
destroy(this.st_context_object_title)
destroy(this.st_title)
destroy(this.st_context_patient)
destroy(this.st_context_encounter)
destroy(this.st_context_assessment)
destroy(this.st_context_treatment)
destroy(this.st_context_observation)
destroy(this.st_context_attachment)
destroy(this.cb_cancel)
destroy(this.dw_services)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_pick_service
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pick_service
end type

type pb_up from u_picture_button within w_pick_service
integer x = 1344
integer y = 116
integer width = 137
integer height = 116
integer taborder = 20
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_services.current_page

dw_services.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_pick_service
integer x = 1344
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

li_page = dw_services.current_page
li_last_page = dw_services.last_page

dw_services.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type st_page from statictext within w_pick_service
integer x = 1481
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

type st_context_general from statictext within w_pick_service
integer x = 1865
integer y = 568
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

backcolor = color_object_selected

dw_services.retrieve("General")

end event

type st_context_object_title from statictext within w_pick_service
integer x = 1755
integer y = 464
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

type st_title from statictext within w_pick_service
integer width = 2926
integer height = 108
integer textsize = -14
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Select Service"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_context_patient from statictext within w_pick_service
integer x = 1605
integer y = 688
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

backcolor = color_object_selected

dw_services.retrieve("Patient")

end event

type st_context_encounter from statictext within w_pick_service
integer x = 1605
integer y = 804
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

backcolor = color_object_selected

dw_services.retrieve("Encounter")

end event

type st_context_assessment from statictext within w_pick_service
integer x = 1605
integer y = 920
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

backcolor = color_object_selected

dw_services.retrieve("Assessment")

end event

type st_context_treatment from statictext within w_pick_service
integer x = 2139
integer y = 688
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

backcolor = color_object_selected

dw_services.retrieve("Treatment")

end event

type st_context_observation from statictext within w_pick_service
integer x = 2139
integer y = 804
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

backcolor = color_object_selected

dw_services.retrieve("Observation")

end event

type st_context_attachment from statictext within w_pick_service
integer x = 2139
integer y = 920
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

backcolor = color_object_selected

dw_services.retrieve("Attachment")

end event

type cb_cancel from commandbutton within w_pick_service
integer x = 1806
integer y = 1588
integer width = 594
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

event clicked;string ls_service

setnull(ls_service)

Closewithreturn(parent, ls_service)


end event

type dw_services from u_dw_pick_list within w_pick_service
integer x = 14
integer y = 108
integer width = 1312
integer height = 1592
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_service_for_context"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;string ls_service

ls_service = object.service[selected_row]
if len(ls_service) > 0 then
	closewithreturn(parent, ls_service)
end if

end event

