$PBExportHeader$w_svc_assessment_associate_treatments.srw
forward
global type w_svc_assessment_associate_treatments from w_svc_generic
end type
type dw_treatments from u_dw_pick_list within w_svc_assessment_associate_treatments
end type
type st_assessment_description from statictext within w_svc_assessment_associate_treatments
end type
type st_assessments_title from statictext within w_svc_assessment_associate_treatments
end type
end forward

global type w_svc_assessment_associate_treatments from w_svc_generic
integer width = 2935
integer height = 1912
dw_treatments dw_treatments
st_assessment_description st_assessment_description
st_assessments_title st_assessments_title
end type
global w_svc_assessment_associate_treatments w_svc_assessment_associate_treatments

type variables
str_assessment_description assessment

end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();integer i
long ll_count
string ls_date
string ls_temp
string ls_find
str_treatment_description lstra_treatments[]
str_treatment_description lstr_treatment
integer li_sts
long ll_row
long ll_treatment_id
integer li_selected_flag
long j
u_ds_data luo_data
str_encounter_description lstr_encounter


dw_treatments.reset()

// First load the treatments created since the last encounter
luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_sp_get_objects_since_last_encounter")
luo_data.setfilter("lower(context_object)='treatment'")
ll_count = luo_data.retrieve(current_patient.cpr_id, service.encounter_id)
for i = 1 to ll_count
	ll_treatment_id = luo_data.object.object_key[i]
	li_sts = current_patient.treatments.treatment(lstr_treatment, ll_treatment_id)
	if li_sts > 0 then
		ll_row = dw_treatments.insertrow(0)
		dw_treatments.object.treatment_id[ll_row] = lstr_treatment.treatment_id
		dw_treatments.object.treatment_type[ll_row] = lstr_treatment.treatment_type
		dw_treatments.object.description[ll_row] = lstr_treatment.treatment_description
		dw_treatments.object.icon_bitmap[ll_row] = datalist.treatment_type_icon(lstr_treatment.treatment_type)
		
		// See if the treatment is in the assessment
		li_selected_flag = 0
		for j = 1 to lstr_treatment.problem_count
			if lstr_treatment.problem_ids[j] = assessment.problem_id then
				li_selected_flag = 1
				exit
			end if
		next
		dw_treatments.object.selected_flag[ll_row] = li_selected_flag
	end if
next

// Then load the treatments created during this encounter
current_patient.encounters.encounter(lstr_encounter, service.encounter_id)
ls_find = "open_encounter_id=" + string(service.encounter_id)
ls_find += " and isnull(parent_treatment_id)"
ll_count = current_patient.treatments.get_treatments(ls_find, lstra_treatments)
for i = 1 to ll_count
	ll_row = dw_treatments.insertrow(0)
	dw_treatments.object.treatment_id[ll_row] = lstra_treatments[i].treatment_id
	dw_treatments.object.description[ll_row] = f_treatment_full_description(lstra_treatments[i], lstr_encounter)
	dw_treatments.object.icon_bitmap[ll_row] = datalist.treatment_type_icon(lstra_treatments[i].treatment_type)
	
	// See if the treatment is in the assessment
	li_selected_flag = 0
	for j = 1 to lstra_treatments[i].problem_count
		if lstra_treatments[i].problem_ids[j] = assessment.problem_id then
			li_selected_flag = 1
			exit
		end if
	next
	dw_treatments.object.selected_flag[ll_row] = li_selected_flag
next


return 1


end function

on w_svc_assessment_associate_treatments.create
int iCurrent
call super::create
this.dw_treatments=create dw_treatments
this.st_assessment_description=create st_assessment_description
this.st_assessments_title=create st_assessments_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_treatments
this.Control[iCurrent+2]=this.st_assessment_description
this.Control[iCurrent+3]=this.st_assessments_title
end on

on w_svc_assessment_associate_treatments.destroy
call super::destroy
destroy(this.dw_treatments)
destroy(this.st_assessment_description)
destroy(this.st_assessments_title)
end on

event open;call super::open;str_popup_return popup_return
integer li_sts

dw_treatments.multiselect = true

popup_return.item_count = 1
popup_return.items[1] = "ERROR"

if isnull(service.problem_id) then
	log.log(this, "w_svc_assessment_associate_treatments.open.0010", "No assessment context", 4)
	closewithreturn(this, popup_return)
end if

li_sts = current_patient.assessments.assessment(assessment, service.problem_id)
if li_sts <= 0 then
	log.log(this, "w_svc_assessment_associate_treatments.open.0010", "Error getting assessment (" + string(service.problem_id) + ")", 4)
	closewithreturn(this, popup_return)
end if

st_assessment_description.text = assessment.assessment

dw_treatments.object.description.width = dw_treatments.width - 247

refresh()

return 1

end event

type pb_epro_help from w_svc_generic`pb_epro_help within w_svc_assessment_associate_treatments
end type

type st_config_mode_menu from w_svc_generic`st_config_mode_menu within w_svc_assessment_associate_treatments
end type

type cb_finished from w_svc_generic`cb_finished within w_svc_assessment_associate_treatments
end type

type cb_be_back from w_svc_generic`cb_be_back within w_svc_assessment_associate_treatments
end type

type cb_cancel from w_svc_generic`cb_cancel within w_svc_assessment_associate_treatments
end type

type st_title from w_svc_generic`st_title within w_svc_assessment_associate_treatments
string text = "Associate Assessment with Treatments"
end type

type dw_treatments from u_dw_pick_list within w_svc_assessment_associate_treatments
integer x = 558
integer y = 552
integer width = 1815
integer height = 868
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_treatment_list"
boolean vscrollbar = true
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylelowered!
end type

event unselected;call super::unselected;long ll_treatment_id
integer li_sts

ll_treatment_id = object.treatment_id[unselected_row]
li_sts = current_patient.treatments.set_treatment_assessment(ll_treatment_id, assessment.problem_id, false)

return

end event

event selected;call super::selected;long ll_treatment_id
integer li_sts

ll_treatment_id = object.treatment_id[selected_row]
li_sts = current_patient.treatments.set_treatment_assessment(ll_treatment_id, assessment.problem_id, true)

return

end event

type st_assessment_description from statictext within w_svc_assessment_associate_treatments
integer y = 208
integer width = 2926
integer height = 88
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Assessment Description"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_assessments_title from statictext within w_svc_assessment_associate_treatments
integer x = 942
integer y = 400
integer width = 1088
integer height = 152
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Associate with the Following Selected Treatments"
alignment alignment = center!
boolean focusrectangle = false
end type

