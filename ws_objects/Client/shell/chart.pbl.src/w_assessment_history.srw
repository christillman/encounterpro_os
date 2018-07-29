$PBExportHeader$w_assessment_history.srw
forward
global type w_assessment_history from w_window_base
end type
type dw_assessment_history from datawindow within w_assessment_history
end type
type st_title from statictext within w_assessment_history
end type
type pb_ok from u_picture_button within w_assessment_history
end type
type st_major from u_st_icd10_part within w_assessment_history
end type
type st_icd10 from statictext within w_assessment_history
end type
type st_minor_1 from u_st_icd10_part within w_assessment_history
end type
end forward

global type w_assessment_history from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
dw_assessment_history dw_assessment_history
st_title st_title
pb_ok pb_ok
st_major st_major
st_icd10 st_icd10
st_minor_1 st_minor_1
end type
global w_assessment_history w_assessment_history

type variables
string current_icd10_part
string assessment_id
end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();integer i, j, li_treatment_count, li_sts
long ll_row
long ll_count
long ll_problem_id
integer li_diagnosis_sequence
long ll_null
string ls_treatment
string ls_find, ls_bitmap
long ll_treatment_ids[]
/* user defined */
//str_treatment_description lstra_treatments[]
str_popup popup
str_encounter_description lstr_encounter
str_assessment_description lstr_assessment
str_treatment_description lstr_treatment
boolean lb_treatment

setnull(ll_null)
setnull(lstr_encounter.encounter_id)

if isnull(current_icd10_part) then
	temp_datastore.set_dataobject("dw_assessments_assessment_id")
	temp_datastore.retrieve(current_patient.cpr_id, assessment_id)
else
	temp_datastore.set_dataobject("dw_assessments_icd10")
	temp_datastore.retrieve(current_patient.cpr_id, current_icd10_part + "%")
end if

ll_count = temp_datastore.rowcount()

dw_assessment_history.setredraw(false)
dw_assessment_history.reset()

ll_problem_id = 0

for i = 1 to ll_count
	ll_problem_id = long(temp_datastore.object.problem_id[i])
	li_diagnosis_sequence = long(temp_datastore.object.diagnosis_sequence[i])

	li_sts = current_patient.assessments.assessment(lstr_assessment, ll_problem_id, li_diagnosis_sequence)
	if li_sts <= 0 then continue
// By Sumathi Chinnasamy On 10/13/2000
// get all treatment ids for a given problem id
	lb_treatment = false
	li_treatment_count = current_patient.treatments.get_assessment_treatments(ll_problem_id, ll_treatment_ids)
	for j = 1 to li_treatment_count
		li_sts = current_patient.treatments.treatment(lstr_treatment, ll_treatment_ids[j])
		if li_sts > 0 then
			ls_bitmap = datalist.treatment_type_icon(lstr_treatment.treatment_type)
			ll_row = dw_assessment_history.insertrow(0)
			dw_assessment_history.object.problem_id[ll_row] = ll_problem_id
			dw_assessment_history.object.assessment[ll_row] = f_assessment_description(lstr_assessment)
			dw_assessment_history.object.bitmap[ll_row] = ls_bitmap
			dw_assessment_history.object.treatment[ll_row] = f_treatment_full_description(lstr_treatment, lstr_encounter)
			dw_assessment_history.object.begin_date[ll_row] = lstr_treatment.begin_date
			lb_treatment = true
		end if
	next

	if not lb_treatment then
		ll_row = dw_assessment_history.insertrow(0)
		dw_assessment_history.object.problem_id[ll_row] = ll_problem_id
		dw_assessment_history.object.assessment[ll_row] = f_assessment_description(lstr_assessment)
		dw_assessment_history.object.treatment[ll_row] = "No Treatments"
	end if
next

dw_assessment_history.sort()
dw_assessment_history.groupcalc()
dw_assessment_history.setredraw(true)

return 1

end function

event open;call super::open;str_popup popup
string ls_icd10_code
string ls_left, ls_right
string ls_description

popup = message.powerobjectparm

assessment_id = popup.item
if isnull(assessment_id) then
	log.log(this, "open", "Null assessment_id", 4)
	close(this)
	return
end if

SELECT icd10_code,
		 description
INTO :ls_icd10_code,
		:ls_description
FROM c_assessment_definition (NOLOCK)
WHERE assessment_id = :assessment_id;
if not tf_check() then close(this)

st_title.text = ls_description + " History"

if isnull(ls_icd10_code) then
	st_major.visible = false
	st_minor_1.visible = false
	st_icd10.visible = false
	setnull(current_icd10_part)
	refresh()
else
	f_split_string(ls_icd10_code, ".", ls_left, ls_right)

	st_major.text = ls_left + "." + "xx"
	st_major.icd10_part = ls_left
	
	if ls_right = "" then
		st_minor_1.visible = false
	else
		st_minor_1.text = ls_left + "." + left(ls_right, 1) + "x"
		st_minor_1.icd10_part = ls_left + "." + left(ls_right, 1)
	end if
	st_major.postevent("clicked")
end if


end event

on w_assessment_history.create
int iCurrent
call super::create
this.dw_assessment_history=create dw_assessment_history
this.st_title=create st_title
this.pb_ok=create pb_ok
this.st_major=create st_major
this.st_icd10=create st_icd10
this.st_minor_1=create st_minor_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_assessment_history
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.pb_ok
this.Control[iCurrent+4]=this.st_major
this.Control[iCurrent+5]=this.st_icd10
this.Control[iCurrent+6]=this.st_minor_1
end on

on w_assessment_history.destroy
call super::destroy
destroy(this.dw_assessment_history)
destroy(this.st_title)
destroy(this.pb_ok)
destroy(this.st_major)
destroy(this.st_icd10)
destroy(this.st_minor_1)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_assessment_history
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_assessment_history
end type

type dw_assessment_history from datawindow within w_assessment_history
integer x = 55
integer y = 112
integer width = 2478
integer height = 1680
integer taborder = 10
string dataobject = "dw_assessment_history"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_title from statictext within w_assessment_history
integer x = 55
integer y = 12
integer width = 2478
integer height = 96
integer textsize = -14
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Assessment History"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_ok from u_picture_button within w_assessment_history
integer x = 2606
integer y = 1596
integer taborder = 20
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

on clicked;call u_picture_button::clicked;close(parent)
end on

type st_major from u_st_icd10_part within w_assessment_history
integer x = 2569
integer y = 316
integer width = 261
integer height = 92
string text = ""
end type

on clicked;call u_st_icd10_part::clicked;current_icd10_part = icd10_part
refresh()

end on

type st_icd10 from statictext within w_assessment_history
integer x = 2583
integer y = 152
integer width = 224
integer height = 136
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "ICD10 Part"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_minor_1 from u_st_icd10_part within w_assessment_history
integer x = 2569
integer y = 460
integer width = 261
integer height = 92
string text = ""
end type

on clicked;call u_st_icd10_part::clicked;current_icd10_part = icd10_part
refresh()

end on

