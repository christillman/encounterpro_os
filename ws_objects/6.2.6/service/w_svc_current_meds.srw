HA$PBExportHeader$w_svc_current_meds.srw
forward
global type w_svc_current_meds from w_window_base
end type
type cb_add_meds from commandbutton within w_svc_current_meds
end type
type pb_up from u_picture_button within w_svc_current_meds
end type
type pb_down from u_picture_button within w_svc_current_meds
end type
type st_page from statictext within w_svc_current_meds
end type
type cb_done from commandbutton within w_svc_current_meds
end type
type cb_be_back from commandbutton within w_svc_current_meds
end type
type st_1 from statictext within w_svc_current_meds
end type
type dw_soap from u_soap_display within w_svc_current_meds
end type
end forward

global type w_svc_current_meds from w_window_base
integer width = 2944
integer height = 1992
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string button_type = "COMMAND"
cb_add_meds cb_add_meds
pb_up pb_up
pb_down pb_down
st_page st_page
cb_done cb_done
cb_be_back cb_be_back
st_1 st_1
dw_soap dw_soap
end type
global w_svc_current_meds w_svc_current_meds

type variables
string assessment_type
string assessment_status
string assessment_soap_display_rule

string treatment_type
string treatment_status

string display_mode

u_component_service service

end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();long ll_page

ll_page = dw_soap.current_page
if ll_page <= 0 then ll_page = 1

dw_soap.setredraw(false)

dw_soap.load_patient(display_mode, assessment_type, assessment_status, assessment_soap_display_rule, treatment_type, treatment_status)

dw_soap.last_page = 0
dw_soap.set_page(ll_page, pb_up, pb_down, st_page)

dw_soap.setredraw(true)

return 1


end function

on w_svc_current_meds.create
int iCurrent
call super::create
this.cb_add_meds=create cb_add_meds
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
this.cb_done=create cb_done
this.cb_be_back=create cb_be_back
this.st_1=create st_1
this.dw_soap=create dw_soap
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_add_meds
this.Control[iCurrent+2]=this.pb_up
this.Control[iCurrent+3]=this.pb_down
this.Control[iCurrent+4]=this.st_page
this.Control[iCurrent+5]=this.cb_done
this.Control[iCurrent+6]=this.cb_be_back
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.dw_soap
end on

on w_svc_current_meds.destroy
call super::destroy
destroy(this.cb_add_meds)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
destroy(this.cb_done)
destroy(this.cb_be_back)
destroy(this.st_1)
destroy(this.dw_soap)
end on

event open;call super::open;integer li_sts
long ll_menu_id

service = Message.powerobjectparm

title = current_patient.id_line()

setnull(assessment_type)
assessment_status = "OPEN"
assessment_soap_display_rule = "Display If Treatments"

treatment_type = "MEDICATION"
treatment_status = "OPEN"

display_mode = "ATAT"

// If the service is part of an encounter then display that encounter
if not isnull(current_service.encounter_id) then
	li_sts = f_set_current_encounter(current_service.encounter_id)
else
	li_sts = current_patient.encounters.last_encounter()
end if

refresh()

//li_sts = load_meds()
//if li_sts < 0 then
//	log.log(this, "open", "Error loading current meds", 4)
//	close(this)
//	return
//end if

// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 4
end if

ll_menu_id = long(service.get_attribute("menu_id"))
paint_menu(ll_menu_id)


end event

event button_pressed;call super::button_pressed;refresh()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_current_meds
boolean visible = true
integer x = 2446
integer y = 1348
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_current_meds
integer x = 23
integer y = 1576
end type

type cb_add_meds from commandbutton within w_svc_current_meds
integer x = 2309
integer y = 528
integer width = 507
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Meds"
end type

event clicked;Integer						i
datetime						ldt_begin_date
date							ld_begin_date
String						ls_treatment_type,ls_temp

str_picked_drugs 			lstr_drugs
u_component_treatment 	luo_treatment
u_component_treatment 	luo_new_treatment

str_attributes lstr_attributes

ls_treatment_type = "MEDICATION"

luo_treatment = f_get_treatment_component(ls_treatment_type)
If isnull(luo_treatment) Then Return

luo_new_treatment = f_get_treatment_component(ls_treatment_type)
If isnull(luo_treatment) Then Return

luo_treatment.treatment_type = ls_treatment_type
luo_treatment.past_treatment = true // to get the duration for the drugs

luo_treatment.define_treatment()
If luo_treatment.treatment_count > 0 Then
	For i = 1 To luo_treatment.treatment_count
	
 		luo_new_treatment.reset()
		luo_new_treatment.parent_patient = current_patient
		luo_new_treatment.open_encounter_id = current_patient.open_encounter_id
		luo_new_treatment.treatment_type = ls_treatment_type
		Setnull(luo_new_treatment.treatment_id)
		luo_new_treatment.ordered_by = current_user.user_id
		luo_new_treatment.created_by = current_scribe.user_id
		luo_new_treatment.past_treatment = true
		
		lstr_attributes = f_attribute_arrays_to_str(luo_treatment.treatment_definition[i].attribute_count, &
																	luo_treatment.treatment_definition[i].attribute, &
																	luo_treatment.treatment_definition[i].value )

		luo_new_treatment.map_attr_to_data_columns(lstr_attributes)

		current_patient.treatments.new_treatment(luo_new_treatment, false)
	Next
End if

component_manager.destroy_component(luo_treatment)
component_manager.destroy_component(luo_new_treatment)

Parent.function POST refresh()


end event

type pb_up from u_picture_button within w_svc_current_meds
integer x = 2235
integer y = 140
integer width = 137
integer height = 116
integer taborder = 30
boolean bringtotop = true
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;string ls_temp
integer li_page

li_page = dw_soap.current_page

dw_soap.set_page(li_page - 1, ls_temp)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_svc_current_meds
integer x = 2235
integer y = 268
integer width = 137
integer height = 116
integer taborder = 20
boolean bringtotop = true
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;string ls_temp
integer li_page
integer li_last_page

li_page = dw_soap.current_page
li_last_page = dw_soap.last_page

dw_soap.set_page(li_page + 1, ls_temp)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type st_page from statictext within w_svc_current_meds
integer x = 2391
integer y = 140
integer width = 283
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "none"
boolean focusrectangle = false
end type

type cb_done from commandbutton within w_svc_current_meds
integer x = 2441
integer y = 1680
integer width = 443
integer height = 108
integer taborder = 150
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;str_popup_return popup_return
integer li_sts

popup_return.item_count = 1
popup_return.items[1] = "COMPLETE"

closewithreturn(parent, popup_return)

end event

type cb_be_back from commandbutton within w_svc_current_meds
integer x = 1975
integer y = 1680
integer width = 443
integer height = 108
integer taborder = 160
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type st_1 from statictext within w_svc_current_meds
integer width = 2926
integer height = 124
integer textsize = -20
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Current Medications"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_soap from u_soap_display within w_svc_current_meds
integer x = 23
integer y = 136
integer width = 2199
integer height = 1440
integer taborder = 20
end type

event selected;call super::selected;refresh()

end event

