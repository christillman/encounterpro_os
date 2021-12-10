$PBExportHeader$u_treatment_assessments.sru
forward
global type u_treatment_assessments from u_tabpage
end type
type st_title from statictext within u_treatment_assessments
end type
type pb_down from u_picture_button within u_treatment_assessments
end type
type pb_up from u_picture_button within u_treatment_assessments
end type
type dw_assessments from u_dw_pick_list within u_treatment_assessments
end type
end forward

global type u_treatment_assessments from u_tabpage
string tag = "ASSESSMENT"
integer width = 2802
integer height = 1012
string text = "Assessments"
st_title st_title
pb_down pb_down
pb_up pb_up
dw_assessments dw_assessments
end type
global u_treatment_assessments u_treatment_assessments

type variables
boolean initialized = false
u_component_treatment treatment
string bill_flag

end variables

forward prototypes
public function integer initialize (u_component_treatment puo_treatment)
public function integer display_assessments ()
public function integer initialize ()
public subroutine refresh ()
end prototypes

public function integer initialize (u_component_treatment puo_treatment);
treatment = puo_treatment

dw_assessments.multiselect = true

dw_assessments.x = 12
dw_assessments.y = 12
dw_assessments.height = height - 24
pb_up.x = dw_assessments.x + dw_assessments.width + 20
pb_up.y = 20
pb_down.x = pb_up.x
pb_down.y = pb_up.y + pb_up.height + 20


return 1

end function

public function integer display_assessments ();integer li_count, i
string ls_date
string ls_temp
string ls_find
str_assessment_description lstra_assessments[]
str_assessment_description lstr_assessment
str_treatment_description lstra_treatments[]
integer li_sts
long ll_row
integer li_treatment_count

if initialized then return 1

if isnull(current_display_encounter) then
	log.log(this, "u_treatment_assessments.display_assessments:0015", "Invalid current_display_encounter", 4)
	return -1
end if

//ls_date = "datetime('" + string(current_display_encounter.encounter_date, "[shortdate] [time]") + "')"
//ls_find = "(begin_date<=" + ls_date + " and (isnull(end_date) or end_date>=" + ls_date + "))"
//ls_find += " or open_encounter_id=" + string(current_display_encounter.encounter_id)
//ls_find += " or close_encounter_id=" + string(current_display_encounter.encounter_id)

li_count = current_patient.assessments.get_encounter_assessments(current_display_encounter.encounter_id, &
																						false, &
																						lstra_assessments)

for i = 1 to li_count
//	// Check to see if the allergy has treatments.  Don't show allergies without treatments.
//	if lstra_assessments[i].assessment_type = "ALLERGY" then
//		ls_find = "problem_id=" + string(lstra_assessments[i].problem_id)
//		ls_find += " and isnull(treatment_status)"
//		li_treatment_count = current_patient.treatments.get_treatments(ls_find, lstra_treatments)
//		if li_treatment_count <= 0 then continue
//	end if

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
	
	if treatment.in_problem(lstr_assessment.problem_id) then
		dw_assessments.object.selected_flag[ll_row] = 1
	else
		dw_assessments.object.selected_flag[ll_row] = 0
	end if
next


initialized = true

dw_assessments.last_page = 0
dw_assessments.set_page(1, ls_temp)
if dw_assessments.last_page < 2 then
	pb_up.visible = false
	pb_down.visible = false
else
	pb_up.visible = true
	pb_down.visible = true
	pb_up.enabled = false
	pb_down.enabled = true
end if

return 1


end function

public function integer initialize ();
treatment = parent_tab.service.treatment

dw_assessments.multiselect = true

dw_assessments.x = 12
dw_assessments.y = 12
dw_assessments.height = height - 24
pb_up.x = dw_assessments.x + dw_assessments.width + 20
pb_up.y = 20
pb_down.x = pb_up.x
pb_down.y = pb_up.y + pb_up.height + 20


return 1

end function

public subroutine refresh ();display_assessments()

end subroutine

on u_treatment_assessments.create
int iCurrent
call super::create
this.st_title=create st_title
this.pb_down=create pb_down
this.pb_up=create pb_up
this.dw_assessments=create dw_assessments
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.pb_down
this.Control[iCurrent+3]=this.pb_up
this.Control[iCurrent+4]=this.dw_assessments
end on

on u_treatment_assessments.destroy
call super::destroy
destroy(this.st_title)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.dw_assessments)
end on

type st_title from statictext within u_treatment_assessments
integer x = 1947
integer y = 20
integer width = 768
integer height = 184
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "Associate Treatment with Assessments"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_down from u_picture_button within u_treatment_assessments
integer x = 1769
integer y = 152
integer width = 137
integer height = 116
integer taborder = 20
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;string ls_temp
integer li_page
integer li_last_page

li_page = dw_assessments.current_page
li_last_page = dw_assessments.last_page

dw_assessments.set_page(li_page + 1, ls_temp)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type pb_up from u_picture_button within u_treatment_assessments
integer x = 1769
integer y = 20
integer width = 137
integer height = 116
integer taborder = 20
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;string ls_temp
integer li_page

li_page = dw_assessments.current_page

dw_assessments.set_page(li_page - 1, ls_temp)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type dw_assessments from u_dw_pick_list within u_treatment_assessments
integer x = 14
integer y = 12
integer width = 1751
integer height = 868
integer taborder = 10
string dataobject = "dw_assessment_list"
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylelowered!
end type

event selected;call super::selected;long ll_problem_id
integer li_sts

ll_problem_id = object.problem_id[selected_row]
li_sts = current_patient.treatments.set_treatment_assessment(treatment.treatment_id, ll_problem_id, true)

return

end event

event unselected;call super::unselected;long ll_problem_id
integer li_sts

ll_problem_id = object.problem_id[unselected_row]
li_sts = current_patient.treatments.set_treatment_assessment(treatment.treatment_id, ll_problem_id, false)

return

end event

