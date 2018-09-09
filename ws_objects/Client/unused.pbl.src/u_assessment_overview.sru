$PBExportHeader$u_assessment_overview.sru
forward
global type u_assessment_overview from userobject
end type
type rtf from u_rich_text_edit within u_assessment_overview
end type
type dw_properties from u_dw_pick_list within u_assessment_overview
end type
type st_begin_date_changed from statictext within u_assessment_overview
end type
end forward

global type u_assessment_overview from userobject
integer width = 2912
integer height = 1164
long backcolor = 33538240
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
rtf rtf
dw_properties dw_properties
st_begin_date_changed st_begin_date_changed
end type
global u_assessment_overview u_assessment_overview

type variables
u_str_assessment		assessment
long display_script_id

end variables

forward prototypes
public function integer initialize (u_str_assessment puo_assessment)
public function integer assessment_overview ()
public function integer display_assessment_properties (str_assessment_description pstr_assessment)
end prototypes

public function integer initialize (u_str_assessment puo_assessment);long ll_backcolor
integer li_sts
str_assessment_description lstr_assessment

ll_backcolor = datalist.get_preference_int("SYSTEM", "assessment_review_background_color")
if not isnull(ll_backcolor) then rtf.set_background_color(ll_backcolor)

assessment = puo_assessment

li_sts = current_patient.assessments.assessment(lstr_assessment, assessment.problem_id)
if li_sts <= 0 then return -1

dw_properties.width = 1029
dw_properties.height = height - 100
dw_properties.x = width - dw_properties.width - 20
dw_properties.y = 20

//rtf.width = dw_properties.x - 20
//rtf.height = this.height

//st_begin_date.x = width - st_begin_date.width - 20
//st_end_date.x = st_begin_date.x
//st_created.x = st_begin_date.x
//st_ordered_by.x = st_begin_date.x
//st_closed_by.x = st_begin_date.x
//st_created_by.x = st_begin_date.x
//st_status.x = st_begin_date.x
//st_acuteness.x = st_begin_date.x
//
//st_begin_date_title.x = st_begin_date.x - st_begin_date_title.width - 8
//st_end_date_title.x = st_begin_date_title.x
//st_created_title.x = st_begin_date_title.x
//st_ordered_by_title.x = st_begin_date_title.x
//st_closed_by_title.x = st_begin_date_title.x
//st_created_by_title.x = st_begin_date_title.x
//st_status_title.x = st_begin_date_title.x
//st_acuteness_title.x = st_begin_date_title.x
//
return 1

end function

public function integer assessment_overview ();integer li_sts
str_assessment_description lstr_assessment

li_sts = current_patient.assessments.assessment(lstr_assessment, assessment.problem_id)
if li_sts <= 0 then return -1

//rtf.setredraw(false)

//rtf.width = dw_properties.x - 20
rtf.width = width
rtf.height = height

rtf.clear_rtf()

rtf.display_assessment(lstr_assessment, display_script_id)
rtf.top()

display_assessment_properties(lstr_assessment)

//rtf.setredraw(true)

return 1

end function

public function integer display_assessment_properties (str_assessment_description pstr_assessment);Long			i,ll_rows
String		ls_user_id
Datetime		ldt_date
Long 			ll_progress_sequence
/* user defined */
str_progress_list lstr_progress
string ls_null
integer li_sts

setnull(ls_null)

dw_properties.reset()

dw_properties.object.title[1] = "Begin Date"
dw_properties.object.attribute[1] = "begin_date"
dw_properties.object.value[1] = string(pstr_assessment.begin_date)
dw_properties.object.clickable[1] = 1

dw_properties.object.title[2] = "End Date"
dw_properties.object.attribute[2] = "end_date"
dw_properties.object.value[2] = string(pstr_assessment.end_date)
// Don't let the user change the end_date if the assessment is still open
if isnull(pstr_assessment.assessment_status) then
	dw_properties.object.clickable[2] = 0
else
	dw_properties.object.clickable[2] = 1
end if

dw_properties.object.title[3] = "Created"
dw_properties.object.attribute[3] = "created"
dw_properties.object.value[3] = string(pstr_assessment.created)

dw_properties.object.title[4] = "Ordered By"
dw_properties.object.attribute[4] = "ordered_by"
dw_properties.object.value[4] = user_list.user_full_name(pstr_assessment.diagnosed_by)
dw_properties.object.color[4] = user_list.user_color(pstr_assessment.diagnosed_by)

SELECT max(assessment_progress_sequence)
INTO :ll_progress_sequence
FROM p_assessment_Progress
WHERE cpr_id = :current_patient.cpr_id
AND problem_id = :pstr_assessment.problem_id
AND progress_type in ('CLOSED', 'CANCELLED', 'MODIFIED', 'COLLECTED', 'NEEDSAMPLE');
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	setnull(ls_user_id)
else
	SELECT user_id
	INTO :ls_user_id
	FROM p_assessment_Progress
	WHERE cpr_id = :current_patient.cpr_id
	AND problem_id = :pstr_assessment.problem_id
	AND assessment_progress_sequence = :ll_progress_sequence;
	if not tf_check() then return -1
	if sqlca.sqlcode = 100 then setnull(ls_user_id)
end if

dw_properties.object.title[5] = "Closed By"
dw_properties.object.attribute[5] = "closed_by"
dw_properties.object.value[5] = user_list.user_full_name(ls_user_id)
dw_properties.object.color[5] = user_list.user_color(ls_user_id)

dw_properties.object.title[6] = "Created By"
dw_properties.object.attribute[6] = "created_by"
dw_properties.object.value[6] = user_list.user_full_name(pstr_assessment.created_by)
dw_properties.object.color[6] = user_list.user_color(pstr_assessment.created_by)



dw_properties.object.title[7] = "Status"
dw_properties.object.attribute[7] = "assessment_status"
if isnull(pstr_assessment.assessment_status) OR upper(pstr_assessment.assessment_status) = "OPEN" then
	dw_properties.object.value[7] = "Open"
else
	dw_properties.object.value[7] = wordcap(pstr_assessment.assessment_status)
end if
if upper(pstr_assessment.assessment_status) = "CANCELLED" then
	dw_properties.object.clickable[7] = 1
else
	dw_properties.object.clickable[7] = 0
end if


dw_properties.object.title[8] = "Acuteness"
dw_properties.object.attribute[8] = "acuteness"
dw_properties.object.value[8] = wordcap(pstr_assessment.acuteness)
dw_properties.object.clickable[8] = 1
	
return 1


end function

on u_assessment_overview.create
this.rtf=create rtf
this.dw_properties=create dw_properties
this.st_begin_date_changed=create st_begin_date_changed
this.Control[]={this.rtf,&
this.dw_properties,&
this.st_begin_date_changed}
end on

on u_assessment_overview.destroy
destroy(this.rtf)
destroy(this.dw_properties)
destroy(this.st_begin_date_changed)
end on

type rtf from u_rich_text_edit within u_assessment_overview
integer width = 1883
integer height = 1164
integer taborder = 30
end type

type dw_properties from u_dw_pick_list within u_assessment_overview
integer x = 1874
integer y = 16
integer width = 1029
integer height = 928
integer taborder = 20
string dataobject = "dw_attribute_value_display_list"
end type

event clicked;call super::clicked;str_popup popup
str_popup_return popup_return
datetime ldt_begin_date
integer li_sts
string ls_attribute
integer li_clickable
string ls_old_value
string ls_new_value
string ls_null

setnull(ls_null)

if isnull(row) or row <= 0 then return

ls_attribute = object.attribute[row]
li_clickable = object.clickable[row]
ls_old_value = object.value[row]

if isnull(li_clickable) or li_clickable <= 0 then return

CHOOSE CASE lower(ls_attribute)
	CASE "begin_date"
		popup.title = "Begin Date/Time"
		popup.item = ls_old_value
		
		openwithparm(w_pop_prompt_date_time, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 2 then return
		
		ldt_begin_date = datetime(date(popup_return.items[1]), time(popup_return.items[2]))
		ls_new_value = string(ldt_begin_date, db_datetime_format)
		
		li_sts = current_patient.assessments.modify_assessment(assessment.problem_id, ls_attribute, ls_new_value)
		if li_sts <= 0 then return
		
		object.value[row] = ls_new_value
	CASE "end_date"
		popup.title = "End Date/Time"
		popup.item = ls_old_value
		
		openwithparm(w_pop_prompt_date_time, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 2 then return
		
		ldt_begin_date = datetime(date(popup_return.items[1]), time(popup_return.items[2]))
		ls_new_value = string(ldt_begin_date, db_datetime_format)
		
		li_sts = current_patient.assessments.modify_assessment(assessment.problem_id, ls_attribute, ls_new_value)
		if li_sts <= 0 then return
		
		object.value[row] = ls_new_value
	CASE "assessment_status"
		if ls_old_value = "Cancelled" then
			openwithparm(w_pop_yes_no, "Do you wish to un-cancel this assessment?")
			popup_return = message.powerobjectparm
			if popup_return.item <> "YES" then return
			
			current_patient.assessments.set_progress(assessment.problem_id, 'UNCancelled', ls_null, ls_null)
			
			assessment_overview()
			return
		end if
	CASE "acuteness"
		popup.dataobject = "dw_domain_notranslate_list"
		popup.datacolumn = 2
		popup.displaycolumn = 2
		popup.argument_count = 1
		popup.argument[1] = "Acuteness"
		openwithparm(w_pop_pick, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return 0
		
		ls_new_value = popup_return.items[1]
		
		li_sts = current_patient.assessments.modify_assessment(assessment.problem_id, ls_attribute, ls_new_value)
		if li_sts <= 0 then return
		
		object.value[row] = ls_new_value
		
END CHOOSE



end event

type st_begin_date_changed from statictext within u_assessment_overview
integer x = 3127
integer y = 24
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

