$PBExportHeader$w_svc_treatment_associate_assessments.srw
forward
global type w_svc_treatment_associate_assessments from w_svc_generic
end type
type dw_assessments from u_dw_pick_list within w_svc_treatment_associate_assessments
end type
type st_treatment_description from statictext within w_svc_treatment_associate_assessments
end type
type st_assessments_title from statictext within w_svc_treatment_associate_assessments
end type
end forward

global type w_svc_treatment_associate_assessments from w_svc_generic
dw_assessments dw_assessments
st_treatment_description st_treatment_description
st_assessments_title st_assessments_title
end type
global w_svc_treatment_associate_assessments w_svc_treatment_associate_assessments

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();integer li_count, i
string ls_date
string ls_temp
string ls_find
str_assessment_description lstra_assessments[]
str_assessment_description lstr_assessment
str_treatment_description lstra_treatments[]
integer li_sts
long ll_row
integer li_treatment_count

if isnull(current_display_encounter) then
	log.log(this, "w_svc_treatment_associate_assessments.refresh:0013", "Invalid current_display_encounter", 4)
	return -1
end if

ls_date = "datetime('" + string(current_display_encounter.encounter_date, "[shortdate] [time]") + "')"
ls_find = "(begin_date<=" + ls_date + " and (isnull(end_date) or end_date>=" + ls_date + "))"
ls_find += " or open_encounter_id=" + string(current_display_encounter.encounter_id)
ls_find += " or close_encounter_id=" + string(current_display_encounter.encounter_id)

li_count = current_patient.assessments.get_assessments(ls_find, lstra_assessments)

dw_assessments.reset()

for i = 1 to li_count
	// Check to see if the allergy has treatments.  Don't show allergies without treatments.
	if lstra_assessments[i].assessment_type = "ALLERGY" then
		ls_find = "problem_id=" + string(lstra_assessments[i].problem_id)
		ls_find += " and isnull(treatment_status)"
		li_treatment_count = current_patient.treatments.get_treatments(ls_find, lstra_treatments)
		if li_treatment_count <= 0 then continue
	end if
	li_sts = current_patient.assessments.assessment(lstr_assessment, lstra_assessments[i].problem_id, lstra_assessments[i].diagnosis_sequence)
	if li_sts <= 0 then continue
	
	ll_row = dw_assessments.insertrow(0)
	dw_assessments.object.problem_id[ll_row] = lstr_assessment.problem_id
	dw_assessments.object.description[ll_row] = f_assessment_description(lstr_assessment)
	if isnull(lstr_assessment.assessment_status) then
		dw_assessments.object.icon_bitmap[ll_row] = datalist.assessment_type_icon_open(lstr_assessment.assessment_type)
	else
		dw_assessments.object.icon_bitmap[ll_row] = datalist.assessment_type_icon_closed(lstr_assessment.assessment_type)
	end if
	
	if service.treatment.in_problem(lstr_assessment.problem_id) then
		dw_assessments.object.selected_flag[ll_row] = 1
	else
		dw_assessments.object.selected_flag[ll_row] = 0
	end if
next


return 1


end function

on w_svc_treatment_associate_assessments.create
int iCurrent
call super::create
this.dw_assessments=create dw_assessments
this.st_treatment_description=create st_treatment_description
this.st_assessments_title=create st_assessments_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_assessments
this.Control[iCurrent+2]=this.st_treatment_description
this.Control[iCurrent+3]=this.st_assessments_title
end on

on w_svc_treatment_associate_assessments.destroy
call super::destroy
destroy(this.dw_assessments)
destroy(this.st_treatment_description)
destroy(this.st_assessments_title)
end on

event open;call super::open;str_popup_return popup_return

dw_assessments.multiselect = true

popup_return.item_count = 1
popup_return.items[1] = "ERROR"

if isnull(service.treatment) then
	log.log(this, "w_svc_treatment_associate_assessments:open", "No treatment context", 4)
	closewithreturn(this, popup_return)
end if

st_treatment_description.text = service.treatment.treatment_description

dw_assessments.object.description.width = dw_assessments.width - 247

refresh()

return 1

end event

type pb_epro_help from w_svc_generic`pb_epro_help within w_svc_treatment_associate_assessments
end type

type st_config_mode_menu from w_svc_generic`st_config_mode_menu within w_svc_treatment_associate_assessments
end type

type cb_finished from w_svc_generic`cb_finished within w_svc_treatment_associate_assessments
end type

type cb_be_back from w_svc_generic`cb_be_back within w_svc_treatment_associate_assessments
end type

type cb_cancel from w_svc_generic`cb_cancel within w_svc_treatment_associate_assessments
end type

type st_title from w_svc_generic`st_title within w_svc_treatment_associate_assessments
string text = "Associate Treatment with Assessments"
end type

type dw_assessments from u_dw_pick_list within w_svc_treatment_associate_assessments
integer x = 558
integer y = 552
integer width = 1815
integer height = 868
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_assessment_list"
boolean vscrollbar = true
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylelowered!
end type

event unselected;call super::unselected;long ll_problem_id
integer li_sts

ll_problem_id = object.problem_id[unselected_row]
li_sts = current_patient.treatments.set_treatment_assessment(service.treatment.treatment_id, ll_problem_id, false)

return

end event

event selected;call super::selected;long ll_problem_id
integer li_sts

ll_problem_id = object.problem_id[selected_row]
li_sts = current_patient.treatments.set_treatment_assessment(service.treatment.treatment_id, ll_problem_id, true)

return

end event

type st_treatment_description from statictext within w_svc_treatment_associate_assessments
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
string text = "Treatment Description"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_assessments_title from statictext within w_svc_treatment_associate_assessments
integer x = 942
integer y = 400
integer width = 1047
integer height = 152
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Associate with the Following Selected Assessments"
alignment alignment = center!
boolean focusrectangle = false
end type

