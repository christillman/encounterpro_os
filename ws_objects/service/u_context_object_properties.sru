HA$PBExportHeader$u_context_object_properties.sru
forward
global type u_context_object_properties from u_tabpage
end type
type st_ordered_by_supervisor_title from statictext within u_context_object_properties
end type
type st_ordered_by_supervisor from statictext within u_context_object_properties
end type
type st_end_date_changed from statictext within u_context_object_properties
end type
type st_begin_date_changed from statictext within u_context_object_properties
end type
type st_progress_title from statictext within u_context_object_properties
end type
type dw_progress from u_dw_pick_list within u_context_object_properties
end type
type st_status from statictext within u_context_object_properties
end type
type st_status_title from statictext within u_context_object_properties
end type
type st_closed_by from statictext within u_context_object_properties
end type
type st_closed_by_title from statictext within u_context_object_properties
end type
type st_end_date from statictext within u_context_object_properties
end type
type st_end_date_title from statictext within u_context_object_properties
end type
type st_encounter_by from statictext within u_context_object_properties
end type
type st_encounter_by_title from statictext within u_context_object_properties
end type
type st_ordered_by from statictext within u_context_object_properties
end type
type st_ordered_by_title from statictext within u_context_object_properties
end type
type st_created_by from statictext within u_context_object_properties
end type
type st_created_by_title from statictext within u_context_object_properties
end type
type st_encounter_date from statictext within u_context_object_properties
end type
type st_enc_date_title from statictext within u_context_object_properties
end type
type st_created from statictext within u_context_object_properties
end type
type st_created_title from statictext within u_context_object_properties
end type
type st_begin_date from statictext within u_context_object_properties
end type
type st_begin_title from statictext within u_context_object_properties
end type
end forward

global type u_context_object_properties from u_tabpage
integer width = 2802
integer height = 1012
string text = "Properties"
st_ordered_by_supervisor_title st_ordered_by_supervisor_title
st_ordered_by_supervisor st_ordered_by_supervisor
st_end_date_changed st_end_date_changed
st_begin_date_changed st_begin_date_changed
st_progress_title st_progress_title
dw_progress dw_progress
st_status st_status
st_status_title st_status_title
st_closed_by st_closed_by
st_closed_by_title st_closed_by_title
st_end_date st_end_date
st_end_date_title st_end_date_title
st_encounter_by st_encounter_by
st_encounter_by_title st_encounter_by_title
st_ordered_by st_ordered_by
st_ordered_by_title st_ordered_by_title
st_created_by st_created_by
st_created_by_title st_created_by_title
st_encounter_date st_encounter_date
st_enc_date_title st_enc_date_title
st_created st_created
st_created_title st_created_title
st_begin_date st_begin_date
st_begin_title st_begin_title
end type
global u_context_object_properties u_context_object_properties

type variables
string context_object
long context_object_key
boolean first_time = true

end variables

forward prototypes
public function integer display_properties ()
public function integer initialize (string ps_context_object, long pl_context_object_key)
public function integer display_treatment_properties ()
public function integer modify_property (string ps_property, string ps_new_value)
public function integer display_assessment_properties ()
public function integer display_progress ()
public function integer display_encounter_properties ()
public subroutine refresh ()
end prototypes

public function integer display_properties ();

CHOOSE CASE lower(context_object)
	CASE "treatment"
		return display_treatment_properties()
	CASE "assessment"
		return display_assessment_properties()
	CASE "encounter"
		return display_encounter_properties()
END CHOOSE

return 0



end function

public function integer initialize (string ps_context_object, long pl_context_object_key);long ll_offset

context_object = ps_context_object
context_object_key = pl_context_object_key

dw_progress.width = width - (2 * dw_progress.x)
dw_progress.height = height - dw_progress.y - 8
dw_progress.object.description.width = dw_progress.width - 1380


if st_end_date_changed.x < width - 200 then
	ll_offset = (width - st_end_date_changed.x) / 2
	st_begin_date.x += ll_offset
	st_begin_date_changed.x += ll_offset
	st_begin_title.x += ll_offset
	st_closed_by.x += ll_offset
	st_closed_by_title.x += ll_offset
	st_created.x += ll_offset
	st_created_by.x += ll_offset
	st_created_by_title.x += ll_offset
	st_created_title.x += ll_offset
	st_enc_date_title.x += ll_offset
	st_encounter_by.x += ll_offset
	st_encounter_by_title.x += ll_offset
	st_encounter_date.x += ll_offset
	st_end_date.x += ll_offset
	st_end_date_changed.x += ll_offset
	st_end_date_title.x += ll_offset
	st_ordered_by.x += ll_offset
	st_ordered_by_supervisor.x += ll_offset
	st_ordered_by_supervisor_title.x += ll_offset
	st_ordered_by_title.x += ll_offset
	st_status.x += ll_offset
	st_status_title.x += ll_offset
end if


return 1



end function

public function integer display_treatment_properties ();Long			i,ll_rows
String		ls_user_id
Datetime		ldt_date
string ls_description
Long 			ll_progress_sequence
/* user defined */
str_progress_list lstr_progress
string ls_null
str_treatment_description lstr_treatment
integer li_sts

setnull(ls_null)

li_sts = current_patient.treatments.treatment(lstr_treatment, context_object_key)
if li_sts <= 0 then return -1

st_begin_date.text = string(lstr_treatment.begin_date)
st_created.text = string(lstr_treatment.created)
st_end_date.text = string(lstr_treatment.end_date)

st_ordered_by.text = user_list.user_full_name(lstr_treatment.ordered_by)
st_ordered_by.backcolor = user_list.user_color(lstr_treatment.ordered_by)

if len(lstr_treatment.ordered_by_supervisor) > 0 then
	st_ordered_by_supervisor.text = user_list.user_full_name(lstr_treatment.ordered_by_supervisor)
	st_ordered_by_supervisor.backcolor = user_list.user_color(lstr_treatment.ordered_by_supervisor)
else
	st_ordered_by_supervisor.visible = false
	st_ordered_by_supervisor_title.visible = false
end if

st_created_by.text = user_list.user_full_name(lstr_treatment.created_by)
st_created_by.backcolor = user_list.user_color(lstr_treatment.created_by)

SELECT max(treatment_progress_sequence)
INTO :ll_progress_sequence
FROM p_Treatment_Progress
WHERE cpr_id = :current_patient.cpr_id
AND treatment_id = :lstr_treatment.treatment_id
AND progress_type in ('CLOSED', 'CANCELLED', 'MODIFIED', 'COLLECTED', 'NEEDSAMPLE');
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	setnull(ls_user_id)
else
	SELECT user_id
	INTO :ls_user_id
	FROM p_Treatment_Progress
	WHERE cpr_id = :current_patient.cpr_id
	AND treatment_id = :lstr_treatment.treatment_id
	AND treatment_progress_sequence = :ll_progress_sequence;
	if not tf_check() then return -1
	if sqlca.sqlcode = 100 then setnull(ls_user_id)
end if

st_closed_by.text = user_list.user_full_name(ls_user_id)
st_closed_by.backcolor = user_list.user_color(ls_user_id)


SELECT encounter_date,
		attending_doctor
INTO :ldt_date,
	  :ls_user_id
FROM p_Patient_Encounter
WHERE cpr_id = :current_patient.cpr_id
AND encounter_id = :lstr_treatment.open_encounter_id;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then setnull(ls_user_id)

st_encounter_by.text = user_list.user_full_name(ls_user_id)
st_encounter_by.backcolor = user_list.user_color(ls_user_id)
st_encounter_date.text = string(ldt_date)


if isnull(lstr_treatment.treatment_status) then
	st_status.text = "Open"
else
	st_status.text = lstr_treatment.treatment_status
end if

// Don't let the user change the end_date if the treatment is still open
if isnull(lstr_treatment.treatment_status) then
	st_end_date.borderstyle = stylebox!
	st_end_date.enabled = false
else
	st_end_date.borderstyle = styleraised!
	st_end_date.enabled = true
end if

display_progress()
	
return 1


end function

public function integer modify_property (string ps_property, string ps_new_value);integer li_sts

li_sts = 0

CHOOSE CASE lower(context_object)
	CASE "treatment"
		li_sts = current_patient.treatments.modify_treatment(context_object_key, ps_property, ps_new_value)
	CASE "assessment"
		li_sts = current_patient.assessments.modify_assessment(context_object_key, ps_property, ps_new_value)
END CHOOSE

return li_sts




end function

public function integer display_assessment_properties ();Long			i,ll_rows
String		ls_user_id
Datetime		ldt_date
Long 			ll_progress_sequence
/* user defined */
str_progress_list lstr_progress
string ls_null
str_assessment_description lstr_assessment
integer li_sts

setnull(ls_null)

li_sts = current_patient.assessments.assessment(lstr_assessment, context_object_key)
if li_sts <= 0 then return -1

st_begin_date.text = string(lstr_assessment.begin_date)
st_created.text = string(lstr_assessment.created)
st_end_date.text = string(lstr_assessment.end_date)

st_ordered_by.text = user_list.user_full_name(lstr_assessment.diagnosed_by)
st_ordered_by.backcolor = user_list.user_color(lstr_assessment.diagnosed_by)

st_ordered_by_supervisor.visible = false
st_ordered_by_supervisor_title.visible = false

st_created_by.text = user_list.user_full_name(lstr_assessment.created_by)
st_created_by.backcolor = user_list.user_color(lstr_assessment.created_by)

SELECT max(assessment_progress_sequence)
INTO :ll_progress_sequence
FROM p_assessment_Progress
WHERE cpr_id = :current_patient.cpr_id
AND problem_id = :lstr_assessment.problem_id
AND progress_type in ('CLOSED', 'CANCELLED', 'MODIFIED', 'COLLECTED', 'NEEDSAMPLE');
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	setnull(ls_user_id)
else
	SELECT user_id
	INTO :ls_user_id
	FROM p_assessment_Progress
	WHERE cpr_id = :current_patient.cpr_id
	AND problem_id = :lstr_assessment.problem_id
	AND assessment_progress_sequence = :ll_progress_sequence;
	if not tf_check() then return -1
	if sqlca.sqlcode = 100 then setnull(ls_user_id)
end if

st_closed_by.text = user_list.user_full_name(ls_user_id)
st_closed_by.backcolor = user_list.user_color(ls_user_id)


SELECT encounter_date,
		attending_doctor
INTO :ldt_date,
	  :ls_user_id
FROM p_Patient_Encounter
WHERE cpr_id = :current_patient.cpr_id
AND encounter_id = :lstr_assessment.open_encounter_id;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then setnull(ls_user_id)

st_encounter_by.text = user_list.user_full_name(ls_user_id)
st_encounter_by.backcolor = user_list.user_color(ls_user_id)
st_encounter_date.text = string(ldt_date)


if isnull(lstr_assessment.assessment_status) then
	st_status.text = "Open"
else
	st_status.text = lstr_assessment.assessment_status
end if

// Don't let the user change the end_date if the assessment is still open
if isnull(lstr_assessment.assessment_status) then
	st_end_date.borderstyle = stylebox!
	st_end_date.enabled = false
else
	st_end_date.borderstyle = styleraised!
	st_end_date.enabled = true
end if

display_progress()
	
return 1


end function

public function integer display_progress ();str_progress_list lstr_progress
long i
string ls_description

st_begin_date_changed.visible = false
st_end_date_changed.visible = false

dw_progress.reset()

lstr_progress = f_get_progress_audit(current_patient.cpr_id, context_object, context_object_key)
for i = 1 to lstr_progress.progress_count
	dw_progress.object.progress_sequence[i] = lstr_progress.progress[i].progress_sequence
	dw_progress.object.created[i] = lstr_progress.progress[i].created
	dw_progress.object.progress_type[i] = lstr_progress.progress[i].progress_type
	dw_progress.object.progress_date_time[i] = lstr_progress.progress[i].progress_date_time
	dw_progress.object.user_name[i] = user_list.user_short_name(lstr_progress.progress[i].user_id)
	dw_progress.object.user_color[i] = user_list.user_color(lstr_progress.progress[i].user_id)

	// Construct the description
	// If the progress_date_time is within 5 seconds of the created date_time, then don't show the progress_date_time
	if f_date_time_nearly_equal(lstr_progress.progress[i].progress_date_time, lstr_progress.progress[i].created, 5) then
		ls_description = ""
	else
		ls_description = string(lstr_progress.progress[i].progress_date_time) + " "
	end if
	if not isnull(lstr_progress.progress[i].progress_full_description) then
		ls_description += lstr_progress.progress[i].progress_full_description
	end if
	
	if len(trim(ls_description)) > 0 then
		dw_progress.object.description[i] = ls_description
	end if
	
	if lower(lstr_progress.progress[i].progress_type) = "modify" and lower(lstr_progress.progress[i].progress_key) = "begin_date" then
		st_begin_date_changed.visible = true
	end if
	if lower(lstr_progress.progress[i].progress_type) = "modify" and lower(lstr_progress.progress[i].progress_key) = "end_date" then
		st_end_date_changed.visible = true
	end if
next

dw_progress.sort()

	
return 1


end function

public function integer display_encounter_properties ();Long			i,ll_rows
String		ls_user_id
Datetime		ldt_date
Long 			ll_progress_sequence
/* user defined */
str_progress_list lstr_progress
string ls_null
str_encounter_description lstr_encounter
integer li_sts

setnull(ls_null)

li_sts = current_patient.encounters.encounter(lstr_encounter, context_object_key)
if li_sts <= 0 then return -1

st_begin_date.text = string(lstr_encounter.encounter_date)
st_created.text = string(lstr_encounter.created)
st_end_date.text = string(lstr_encounter.discharge_date)

st_ordered_by_title.text = "Owned By"
st_ordered_by.text = user_list.user_full_name(lstr_encounter.attending_doctor)
st_ordered_by.backcolor = user_list.user_color(lstr_encounter.attending_doctor)

st_ordered_by_supervisor.text = user_list.user_full_name(lstr_encounter.supervising_doctor)
st_ordered_by_supervisor.backcolor = user_list.user_color(lstr_encounter.supervising_doctor)

st_created_by.text = user_list.user_full_name(lstr_encounter.created_by)
st_created_by.backcolor = user_list.user_color(lstr_encounter.created_by)

st_closed_by.visible = false
st_closed_by_title.visible = false

st_encounter_by.visible = false
st_encounter_by_title.visible = false

st_encounter_date.visible = false
st_enc_date_title.visible = false


if isnull(lstr_encounter.encounter_status) then
	st_status.text = "Open"
else
	st_status.text = lstr_encounter.encounter_status
end if

// Don't let the user change the end_date if the encounter is still open
if isnull(lstr_encounter.encounter_status) then
	st_end_date.borderstyle = stylebox!
	st_end_date.enabled = false
else
	st_end_date.borderstyle = styleraised!
	st_end_date.enabled = true
end if

display_progress()

return 1


end function

public subroutine refresh ();integer li_sts

if first_time then
	li_sts = initialize(parent_tab.service.context_object, parent_tab.service.object_key)
	first_time = false
end if

display_properties()

return

end subroutine

on u_context_object_properties.create
int iCurrent
call super::create
this.st_ordered_by_supervisor_title=create st_ordered_by_supervisor_title
this.st_ordered_by_supervisor=create st_ordered_by_supervisor
this.st_end_date_changed=create st_end_date_changed
this.st_begin_date_changed=create st_begin_date_changed
this.st_progress_title=create st_progress_title
this.dw_progress=create dw_progress
this.st_status=create st_status
this.st_status_title=create st_status_title
this.st_closed_by=create st_closed_by
this.st_closed_by_title=create st_closed_by_title
this.st_end_date=create st_end_date
this.st_end_date_title=create st_end_date_title
this.st_encounter_by=create st_encounter_by
this.st_encounter_by_title=create st_encounter_by_title
this.st_ordered_by=create st_ordered_by
this.st_ordered_by_title=create st_ordered_by_title
this.st_created_by=create st_created_by
this.st_created_by_title=create st_created_by_title
this.st_encounter_date=create st_encounter_date
this.st_enc_date_title=create st_enc_date_title
this.st_created=create st_created
this.st_created_title=create st_created_title
this.st_begin_date=create st_begin_date
this.st_begin_title=create st_begin_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_ordered_by_supervisor_title
this.Control[iCurrent+2]=this.st_ordered_by_supervisor
this.Control[iCurrent+3]=this.st_end_date_changed
this.Control[iCurrent+4]=this.st_begin_date_changed
this.Control[iCurrent+5]=this.st_progress_title
this.Control[iCurrent+6]=this.dw_progress
this.Control[iCurrent+7]=this.st_status
this.Control[iCurrent+8]=this.st_status_title
this.Control[iCurrent+9]=this.st_closed_by
this.Control[iCurrent+10]=this.st_closed_by_title
this.Control[iCurrent+11]=this.st_end_date
this.Control[iCurrent+12]=this.st_end_date_title
this.Control[iCurrent+13]=this.st_encounter_by
this.Control[iCurrent+14]=this.st_encounter_by_title
this.Control[iCurrent+15]=this.st_ordered_by
this.Control[iCurrent+16]=this.st_ordered_by_title
this.Control[iCurrent+17]=this.st_created_by
this.Control[iCurrent+18]=this.st_created_by_title
this.Control[iCurrent+19]=this.st_encounter_date
this.Control[iCurrent+20]=this.st_enc_date_title
this.Control[iCurrent+21]=this.st_created
this.Control[iCurrent+22]=this.st_created_title
this.Control[iCurrent+23]=this.st_begin_date
this.Control[iCurrent+24]=this.st_begin_title
end on

on u_context_object_properties.destroy
call super::destroy
destroy(this.st_ordered_by_supervisor_title)
destroy(this.st_ordered_by_supervisor)
destroy(this.st_end_date_changed)
destroy(this.st_begin_date_changed)
destroy(this.st_progress_title)
destroy(this.dw_progress)
destroy(this.st_status)
destroy(this.st_status_title)
destroy(this.st_closed_by)
destroy(this.st_closed_by_title)
destroy(this.st_end_date)
destroy(this.st_end_date_title)
destroy(this.st_encounter_by)
destroy(this.st_encounter_by_title)
destroy(this.st_ordered_by)
destroy(this.st_ordered_by_title)
destroy(this.st_created_by)
destroy(this.st_created_by_title)
destroy(this.st_encounter_date)
destroy(this.st_enc_date_title)
destroy(this.st_created)
destroy(this.st_created_title)
destroy(this.st_begin_date)
destroy(this.st_begin_title)
end on

type st_ordered_by_supervisor_title from statictext within u_context_object_properties
integer y = 232
integer width = 494
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Supervisor:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_ordered_by_supervisor from statictext within u_context_object_properties
integer x = 517
integer y = 232
integer width = 818
integer height = 72
boolean bringtotop = true
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

type st_end_date_changed from statictext within u_context_object_properties
integer x = 2734
integer y = 36
integer width = 50
integer height = 64
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "*"
boolean focusrectangle = false
end type

type st_begin_date_changed from statictext within u_context_object_properties
integer x = 1344
integer y = 36
integer width = 50
integer height = 64
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "*"
boolean focusrectangle = false
end type

type st_progress_title from statictext within u_context_object_properties
integer x = 55
integer y = 532
integer width = 553
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Audit (Latest First):"
boolean focusrectangle = false
end type

type dw_progress from u_dw_pick_list within u_context_object_properties
integer x = 41
integer y = 604
integer width = 2729
integer height = 400
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_properties_progress"
boolean vscrollbar = true
boolean border = false
end type

type st_status from statictext within u_context_object_properties
integer x = 1906
integer y = 460
integer width = 818
integer height = 72
boolean bringtotop = true
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

type st_status_title from statictext within u_context_object_properties
integer x = 1390
integer y = 460
integer width = 494
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Current Status:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_closed_by from statictext within u_context_object_properties
integer x = 1906
integer y = 132
integer width = 818
integer height = 72
boolean bringtotop = true
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

type st_closed_by_title from statictext within u_context_object_properties
integer x = 1518
integer y = 132
integer width = 366
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Closed By:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_end_date from statictext within u_context_object_properties
integer x = 1906
integer y = 32
integer width = 818
integer height = 72
boolean bringtotop = true
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
datetime ldt_end_date
integer li_sts

popup.title = "End Date/Time"
popup.item = text

openwithparm(w_pop_prompt_date_time, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 2 then return

ldt_end_date = datetime(date(popup_return.items[1]), time(popup_return.items[2]))
li_sts = modify_property("end_date", string(ldt_end_date))
if li_sts <= 0 then return

display_properties()

end event

type st_end_date_title from statictext within u_context_object_properties
integer x = 1536
integer y = 32
integer width = 347
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "End Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_encounter_by from statictext within u_context_object_properties
integer x = 517
integer y = 432
integer width = 818
integer height = 72
boolean bringtotop = true
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

type st_encounter_by_title from statictext within u_context_object_properties
integer y = 432
integer width = 494
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Encounter By:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_ordered_by from statictext within u_context_object_properties
integer x = 517
integer y = 132
integer width = 818
integer height = 72
boolean bringtotop = true
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

type st_ordered_by_title from statictext within u_context_object_properties
integer x = 50
integer y = 132
integer width = 443
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Ordered By:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_created_by from statictext within u_context_object_properties
integer x = 1906
integer y = 360
integer width = 818
integer height = 72
boolean bringtotop = true
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

type st_created_by_title from statictext within u_context_object_properties
integer x = 1390
integer y = 360
integer width = 494
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Created By:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_encounter_date from statictext within u_context_object_properties
integer x = 517
integer y = 332
integer width = 818
integer height = 72
boolean bringtotop = true
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

type st_enc_date_title from statictext within u_context_object_properties
integer y = 332
integer width = 494
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Encounter Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_created from statictext within u_context_object_properties
integer x = 1906
integer y = 260
integer width = 818
integer height = 72
boolean bringtotop = true
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

type st_created_title from statictext within u_context_object_properties
integer x = 1458
integer y = 260
integer width = 425
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Create Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_begin_date from statictext within u_context_object_properties
integer x = 517
integer y = 32
integer width = 818
integer height = 72
boolean bringtotop = true
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
datetime ldt_begin_date
integer li_sts

popup.title = "Begin Date/Time"
popup.item = text

openwithparm(w_pop_prompt_date_time, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 2 then return

ldt_begin_date = datetime(date(popup_return.items[1]), time(popup_return.items[2]))
li_sts = modify_property("begin_date", string(ldt_begin_date))
if li_sts <= 0 then return

display_properties()


end event

type st_begin_title from statictext within u_context_object_properties
integer x = 69
integer y = 32
integer width = 425
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Begin Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

