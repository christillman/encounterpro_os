$PBExportHeader$w_svc_prior_meds.srw
forward
global type w_svc_prior_meds from w_window_base
end type
type cb_add_formulation from commandbutton within w_svc_prior_meds
end type
type cb_done from commandbutton within w_svc_prior_meds
end type
type cb_be_back from commandbutton within w_svc_prior_meds
end type
type st_1 from statictext within w_svc_prior_meds
end type
type dw_treatments from u_dw_prior_drugs_list within w_svc_prior_meds
end type
type cb_add_drug from commandbutton within w_svc_prior_meds
end type
end forward

global type w_svc_prior_meds from w_window_base
integer width = 2944
integer height = 1992
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string button_type = "COMMAND"
cb_add_formulation cb_add_formulation
cb_done cb_done
cb_be_back cb_be_back
st_1 st_1
dw_treatments dw_treatments
cb_add_drug cb_add_drug
end type
global w_svc_prior_meds w_svc_prior_meds

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
public subroutine wf_add_meds (boolean pb_include_strength)
end prototypes

public function integer refresh ();
long ll_page

ll_page = dw_treatments.current_page
if ll_page <= 0 then ll_page = 1

dw_treatments.reset()
dw_treatments.load_treatments()

return 1


end function

public subroutine wf_add_meds (boolean pb_include_strength);Integer						i
datetime						ldt_begin_date
date							ld_begin_date
String						ls_treatment_type,ls_temp
long ll_null
long ll_treatment_id

SetNull(ll_null)

str_picked_drugs 			lstr_drugs
u_component_treatment 	luo_treatment
u_component_treatment 	luo_new_treatment

str_attributes lstr_trt_attributes

ls_treatment_type = "PRIORMEDICATION"

luo_treatment = f_get_treatment_component(ls_treatment_type)
If isnull(luo_treatment) Then Return

luo_new_treatment = f_get_treatment_component(ls_treatment_type)
If isnull(luo_treatment) Then Return

luo_treatment.past_treatment = true // to get the duration for the drugs
luo_treatment.prior_treatment = true // to indicate not prescribed here
luo_treatment.include_strength = pb_include_strength

luo_treatment.define_treatment()
If luo_treatment.treatment_count > 0 Then
	For i = 1 To luo_treatment.treatment_count
	
 		luo_new_treatment.reset()
		luo_new_treatment.parent_patient = current_patient
		luo_new_treatment.open_encounter_id = current_patient.open_encounter_id
		luo_new_treatment.treatment_type = ls_treatment_type
		Setnull(luo_new_treatment.treatment_id)
		luo_new_treatment.ordered_by = "#Unknown"
		luo_new_treatment.created_by = current_scribe.user_id
		
		lstr_trt_attributes = f_attribute_arrays_to_str(luo_treatment.treatment_definition[i].attribute_count, &
																	luo_treatment.treatment_definition[i].attribute, &
																	luo_treatment.treatment_definition[i].value )

		luo_new_treatment.map_attr_to_data_columns(lstr_trt_attributes)

		current_patient.treatments.new_treatment(luo_new_treatment, false)
	Next
End if

component_manager.destroy_component(luo_treatment)
component_manager.destroy_component(luo_new_treatment)

refresh()

end subroutine

on w_svc_prior_meds.create
int iCurrent
call super::create
this.cb_add_formulation=create cb_add_formulation
this.cb_done=create cb_done
this.cb_be_back=create cb_be_back
this.st_1=create st_1
this.dw_treatments=create dw_treatments
this.cb_add_drug=create cb_add_drug
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_add_formulation
this.Control[iCurrent+2]=this.cb_done
this.Control[iCurrent+3]=this.cb_be_back
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.dw_treatments
this.Control[iCurrent+6]=this.cb_add_drug
end on

on w_svc_prior_meds.destroy
call super::destroy
destroy(this.cb_add_formulation)
destroy(this.cb_done)
destroy(this.cb_be_back)
destroy(this.st_1)
destroy(this.dw_treatments)
destroy(this.cb_add_drug)
end on

event open;call super::open;integer li_sts
long ll_menu_id

service = Message.powerobjectparm

title = current_patient.id_line()

setnull(assessment_type)
assessment_status = "OPEN"
assessment_soap_display_rule = "Display If Treatments"

treatment_type = "PRIORMEDICATION"
treatment_status = "OPEN"

display_mode = "ATAT"

// If the service is part of an encounter then display that encounter
if not isnull(current_service.encounter_id) then
	li_sts = f_set_current_encounter(current_service.encounter_id)
else
	li_sts = current_patient.encounters.last_encounter()
end if


refresh()

// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 4
end if

ll_menu_id = long(service.get_attribute("menu_id"))
paint_menu(ll_menu_id)

dw_treatments.object.description.width = dw_treatments.width - 247

end event

event button_pressed;call super::button_pressed;refresh()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_prior_meds
boolean visible = true
integer x = 2446
integer y = 1348
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_prior_meds
integer x = 23
integer y = 1576
end type

type cb_add_formulation from commandbutton within w_svc_prior_meds
integer x = 2295
integer y = 528
integer width = 617
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Name and Strength"
end type

event clicked;wf_add_meds(true)

RETURN 1
end event

type cb_done from commandbutton within w_svc_prior_meds
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

type cb_be_back from commandbutton within w_svc_prior_meds
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

type st_1 from statictext within w_svc_prior_meds
integer width = 2926
integer height = 124
integer textsize = -20
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
string text = "Prior Medications"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_treatments from u_dw_prior_drugs_list within w_svc_prior_meds
integer x = 32
integer y = 124
integer width = 2199
integer height = 1272
integer taborder = 10
boolean bringtotop = true
end type

type cb_add_drug from commandbutton within w_svc_prior_meds
integer x = 2295
integer y = 652
integer width = 617
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Name Only"
end type

event clicked;wf_add_meds(false)

RETURN 1
end event

