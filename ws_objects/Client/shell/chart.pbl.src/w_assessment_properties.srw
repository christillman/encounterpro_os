$PBExportHeader$w_assessment_properties.srw
forward
global type w_assessment_properties from w_window_base
end type
type pb_done from u_picture_button within w_assessment_properties
end type
type st_title from statictext within w_assessment_properties
end type
type st_begin_title from statictext within w_assessment_properties
end type
type st_begin_date from statictext within w_assessment_properties
end type
type st_created_title from statictext within w_assessment_properties
end type
type st_created from statictext within w_assessment_properties
end type
type st_enc_date_title from statictext within w_assessment_properties
end type
type st_encounter_date from statictext within w_assessment_properties
end type
type st_created_by_title from statictext within w_assessment_properties
end type
type st_created_by from statictext within w_assessment_properties
end type
type st_ordered_by_title from statictext within w_assessment_properties
end type
type st_ordered_by from statictext within w_assessment_properties
end type
type st_encounter_by_title from statictext within w_assessment_properties
end type
type st_encounter_by from statictext within w_assessment_properties
end type
type st_end_date_title from statictext within w_assessment_properties
end type
type st_end_date from statictext within w_assessment_properties
end type
type st_closed_by_title from statictext within w_assessment_properties
end type
type st_closed_by from statictext within w_assessment_properties
end type
type st_status_title from statictext within w_assessment_properties
end type
type st_status from statictext within w_assessment_properties
end type
type st_type_title from statictext within w_assessment_properties
end type
type st_assessment_type from statictext within w_assessment_properties
end type
type dw_progress from u_dw_pick_list within w_assessment_properties
end type
type st_progress_title from statictext within w_assessment_properties
end type
end forward

global type w_assessment_properties from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_done pb_done
st_title st_title
st_begin_title st_begin_title
st_begin_date st_begin_date
st_created_title st_created_title
st_created st_created
st_enc_date_title st_enc_date_title
st_encounter_date st_encounter_date
st_created_by_title st_created_by_title
st_created_by st_created_by
st_ordered_by_title st_ordered_by_title
st_ordered_by st_ordered_by
st_encounter_by_title st_encounter_by_title
st_encounter_by st_encounter_by
st_end_date_title st_end_date_title
st_end_date st_end_date
st_closed_by_title st_closed_by_title
st_closed_by st_closed_by
st_status_title st_status_title
st_status st_status
st_type_title st_type_title
st_assessment_type st_assessment_type
dw_progress dw_progress
st_progress_title st_progress_title
end type
global w_assessment_properties w_assessment_properties

type variables
u_str_assessment assessment
end variables

forward prototypes
public function integer load_properties ()
end prototypes

public function integer load_properties ();string ls_format
string ls_user_id
datetime ldt_date
long ll_progress_sequence
long ll_rows, i
str_progress_list lstr_progress
string ls_null

setnull(ls_null)

ls_format = date_format_string + " " + time_format_string

st_title.text = assessment.assessment

st_begin_date.text = string(assessment.begin_date, ls_format)
st_created.text = string(assessment.created, ls_format)
st_end_date.text = string(assessment.end_date, ls_format)

st_ordered_by.text = user_list.user_full_name(assessment.diagnosed_by)
st_ordered_by.backcolor = user_list.user_color(assessment.diagnosed_by)

st_created_by.text = user_list.user_full_name(assessment.created_by)
st_created_by.backcolor = user_list.user_color(assessment.created_by)

SELECT max(assessment_progress_sequence)
INTO :ll_progress_sequence
FROM p_Assessment_Progress
WHERE cpr_id = :assessment.parent_patient.cpr_id
AND problem_id = :assessment.problem_id
AND progress_type in ('CLOSED', 'CANCELLED', 'MODIFIED', 'COLLECTED', 'NEEDSAMPLE');
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	setnull(ls_user_id)
else
	SELECT user_id
	INTO :ls_user_id
	FROM p_assessment_Progress
	WHERE cpr_id = :assessment.parent_patient.cpr_id
	AND problem_id = :assessment.problem_id
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
WHERE cpr_id = :assessment.parent_patient.cpr_id
AND encounter_id = :assessment.open_encounter_id;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then setnull(ls_user_id)

st_encounter_by.text = user_list.user_full_name(ls_user_id)
st_encounter_by.backcolor = user_list.user_color(ls_user_id)
st_encounter_date.text = string(ldt_date, ls_format)


if isnull(assessment.assessment_status) then
	st_status.text = "Open"
else
	st_status.text = assessment.assessment_status
end if

st_assessment_type.text = datalist.assessment_type_description(assessment.assessment_type)


lstr_progress = f_get_progress(current_patient.cpr_id, "Assessment", assessment.problem_id, ls_null, ls_null)
for i = 1 to ll_rows
	dw_progress.object.progress_sequence[i] = lstr_progress.progress[i].progress_sequence
	dw_progress.object.progress_date_time[i] = lstr_progress.progress[i].progress_date_time
	dw_progress.object.description[i] = lstr_progress.progress[i].progress_full_description
	dw_progress.object.user_name[i] = user_list.user_short_name(lstr_progress.progress[i].user_id)
	dw_progress.object.user_color[i] = user_list.user_color(lstr_progress.progress[i].user_id)
next

dw_progress.sort()


return 1


end function

on w_assessment_properties.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.st_title=create st_title
this.st_begin_title=create st_begin_title
this.st_begin_date=create st_begin_date
this.st_created_title=create st_created_title
this.st_created=create st_created
this.st_enc_date_title=create st_enc_date_title
this.st_encounter_date=create st_encounter_date
this.st_created_by_title=create st_created_by_title
this.st_created_by=create st_created_by
this.st_ordered_by_title=create st_ordered_by_title
this.st_ordered_by=create st_ordered_by
this.st_encounter_by_title=create st_encounter_by_title
this.st_encounter_by=create st_encounter_by
this.st_end_date_title=create st_end_date_title
this.st_end_date=create st_end_date
this.st_closed_by_title=create st_closed_by_title
this.st_closed_by=create st_closed_by
this.st_status_title=create st_status_title
this.st_status=create st_status
this.st_type_title=create st_type_title
this.st_assessment_type=create st_assessment_type
this.dw_progress=create dw_progress
this.st_progress_title=create st_progress_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.st_begin_title
this.Control[iCurrent+4]=this.st_begin_date
this.Control[iCurrent+5]=this.st_created_title
this.Control[iCurrent+6]=this.st_created
this.Control[iCurrent+7]=this.st_enc_date_title
this.Control[iCurrent+8]=this.st_encounter_date
this.Control[iCurrent+9]=this.st_created_by_title
this.Control[iCurrent+10]=this.st_created_by
this.Control[iCurrent+11]=this.st_ordered_by_title
this.Control[iCurrent+12]=this.st_ordered_by
this.Control[iCurrent+13]=this.st_encounter_by_title
this.Control[iCurrent+14]=this.st_encounter_by
this.Control[iCurrent+15]=this.st_end_date_title
this.Control[iCurrent+16]=this.st_end_date
this.Control[iCurrent+17]=this.st_closed_by_title
this.Control[iCurrent+18]=this.st_closed_by
this.Control[iCurrent+19]=this.st_status_title
this.Control[iCurrent+20]=this.st_status
this.Control[iCurrent+21]=this.st_type_title
this.Control[iCurrent+22]=this.st_assessment_type
this.Control[iCurrent+23]=this.dw_progress
this.Control[iCurrent+24]=this.st_progress_title
end on

on w_assessment_properties.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.st_title)
destroy(this.st_begin_title)
destroy(this.st_begin_date)
destroy(this.st_created_title)
destroy(this.st_created)
destroy(this.st_enc_date_title)
destroy(this.st_encounter_date)
destroy(this.st_created_by_title)
destroy(this.st_created_by)
destroy(this.st_ordered_by_title)
destroy(this.st_ordered_by)
destroy(this.st_encounter_by_title)
destroy(this.st_encounter_by)
destroy(this.st_end_date_title)
destroy(this.st_end_date)
destroy(this.st_closed_by_title)
destroy(this.st_closed_by)
destroy(this.st_status_title)
destroy(this.st_status)
destroy(this.st_type_title)
destroy(this.st_assessment_type)
destroy(this.dw_progress)
destroy(this.st_progress_title)
end on

event open;call super::open;str_popup popup
integer li_sts

popup = message.powerobjectparm

assessment = popup.objectparm

if isnull(assessment) or not isvalid(assessment) then
	log.log(this, "w_assessment_properties.open.0009", "Invalid Assessment", 4)
	close(this)
	return
end if

li_sts = load_properties()
if li_sts < 0 then
	log.log(this, "w_assessment_properties.open.0009", "Error loading properties", 4)
	close(this)
	return
end if



end event

type pb_epro_help from w_window_base`pb_epro_help within w_assessment_properties
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_assessment_properties
end type

type pb_done from u_picture_button within w_assessment_properties
integer x = 2569
integer y = 1552
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;close(parent)

end event

type st_title from statictext within w_assessment_properties
integer width = 2921
integer height = 140
boolean bringtotop = true
integer textsize = -20
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type st_begin_title from statictext within w_assessment_properties
integer x = 160
integer y = 488
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

type st_begin_date from statictext within w_assessment_properties
integer x = 599
integer y = 488
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

type st_created_title from statictext within w_assessment_properties
integer x = 1463
integer y = 744
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

type st_created from statictext within w_assessment_properties
integer x = 1906
integer y = 744
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

type st_enc_date_title from statictext within w_assessment_properties
integer x = 91
integer y = 744
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

type st_encounter_date from statictext within w_assessment_properties
integer x = 599
integer y = 744
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

type st_created_by_title from statictext within w_assessment_properties
integer x = 1394
integer y = 848
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

type st_created_by from statictext within w_assessment_properties
integer x = 1906
integer y = 848
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

type st_ordered_by_title from statictext within w_assessment_properties
integer x = 41
integer y = 592
integer width = 544
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
string text = "Assessed By:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_ordered_by from statictext within w_assessment_properties
integer x = 599
integer y = 592
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

type st_encounter_by_title from statictext within w_assessment_properties
integer x = 91
integer y = 848
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

type st_encounter_by from statictext within w_assessment_properties
integer x = 599
integer y = 848
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

type st_end_date_title from statictext within w_assessment_properties
integer x = 1541
integer y = 488
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

type st_end_date from statictext within w_assessment_properties
integer x = 1906
integer y = 488
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

type st_closed_by_title from statictext within w_assessment_properties
integer x = 1522
integer y = 592
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

type st_closed_by from statictext within w_assessment_properties
integer x = 1906
integer y = 592
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

type st_status_title from statictext within w_assessment_properties
integer x = 1394
integer y = 992
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

type st_status from statictext within w_assessment_properties
integer x = 1906
integer y = 992
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

type st_type_title from statictext within w_assessment_properties
integer x = 677
integer y = 224
integer width = 599
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
string text = "Assessment Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_assessment_type from statictext within w_assessment_properties
integer x = 1294
integer y = 224
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

type dw_progress from u_dw_pick_list within w_assessment_properties
integer x = 114
integer y = 1288
integer width = 2341
integer height = 476
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_properties_progress"
boolean vscrollbar = true
boolean border = false
end type

type st_progress_title from statictext within w_assessment_properties
integer x = 119
integer y = 1216
integer width = 297
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
string text = "Progress:"
boolean focusrectangle = false
end type

