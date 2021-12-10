$PBExportHeader$w_treatment_properties.srw
forward
global type w_treatment_properties from w_window_base
end type
type pb_done from u_picture_button within w_treatment_properties
end type
type st_title from statictext within w_treatment_properties
end type
type st_desc_title from statictext within w_treatment_properties
end type
type st_description from statictext within w_treatment_properties
end type
type st_begin_title from statictext within w_treatment_properties
end type
type st_begin_date from statictext within w_treatment_properties
end type
type st_created_title from statictext within w_treatment_properties
end type
type st_created from statictext within w_treatment_properties
end type
type st_enc_date_title from statictext within w_treatment_properties
end type
type st_encounter_date from statictext within w_treatment_properties
end type
type st_created_by_title from statictext within w_treatment_properties
end type
type st_created_by from statictext within w_treatment_properties
end type
type st_ordered_by_title from statictext within w_treatment_properties
end type
type st_ordered_by from statictext within w_treatment_properties
end type
type st_encounter_by_title from statictext within w_treatment_properties
end type
type st_encounter_by from statictext within w_treatment_properties
end type
type st_end_date_title from statictext within w_treatment_properties
end type
type st_end_date from statictext within w_treatment_properties
end type
type st_closed_by_title from statictext within w_treatment_properties
end type
type st_closed_by from statictext within w_treatment_properties
end type
type st_status_title from statictext within w_treatment_properties
end type
type st_status from statictext within w_treatment_properties
end type
type dw_progress from u_dw_pick_list within w_treatment_properties
end type
type st_progress_title from statictext within w_treatment_properties
end type
end forward

global type w_treatment_properties from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_done pb_done
st_title st_title
st_desc_title st_desc_title
st_description st_description
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
dw_progress dw_progress
st_progress_title st_progress_title
end type
global w_treatment_properties w_treatment_properties

type variables
u_component_treatment  treatment
end variables

forward prototypes
public function integer load_properties ()
end prototypes

public function integer load_properties ();Long			i,ll_rows
String		ls_format,ls_user_id
Datetime		ldt_date
Long 			ll_progress_sequence
/* user defined */
str_progress_list lstr_progress
string ls_null

setnull(ls_null)

ls_format = date_format_string + " " + time_format_string
st_description.text = treatment.description()

st_begin_date.text = string(treatment.begin_date, ls_format)
st_created.text = string(treatment.created, ls_format)
st_end_date.text = string(treatment.end_date, ls_format)

st_ordered_by.text = user_list.user_full_name(treatment.ordered_by)
st_ordered_by.backcolor = user_list.user_color(treatment.ordered_by)

st_created_by.text = user_list.user_full_name(treatment.created_by)
st_created_by.backcolor = user_list.user_color(treatment.created_by)

SELECT max(treatment_progress_sequence)
INTO :ll_progress_sequence
FROM p_Treatment_Progress
WHERE cpr_id = :current_patient.cpr_id
AND treatment_id = :treatment.treatment_id
AND progress_type in ('CLOSED', 'CANCELLED', 'MODIFIED', 'COLLECTED', 'NEEDSAMPLE');
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	setnull(ls_user_id)
else
	SELECT user_id
	INTO :ls_user_id
	FROM p_Treatment_Progress
	WHERE cpr_id = :current_patient.cpr_id
	AND treatment_id = :treatment.treatment_id
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
AND encounter_id = :treatment.open_encounter_id;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then setnull(ls_user_id)

st_encounter_by.text = user_list.user_full_name(ls_user_id)
st_encounter_by.backcolor = user_list.user_color(ls_user_id)
st_encounter_date.text = string(ldt_date, ls_format)


if isnull(treatment.treatment_status) then
	st_status.text = "Open"
else
	st_status.text = treatment.treatment_status
end if

st_title.text = datalist.treatment_type_description(treatment.treatment_type)

lstr_progress = f_get_progress(current_patient.cpr_id, "Treatment", treatment.treatment_id, ls_null, ls_null)
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

on w_treatment_properties.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.st_title=create st_title
this.st_desc_title=create st_desc_title
this.st_description=create st_description
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
this.dw_progress=create dw_progress
this.st_progress_title=create st_progress_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.st_desc_title
this.Control[iCurrent+4]=this.st_description
this.Control[iCurrent+5]=this.st_begin_title
this.Control[iCurrent+6]=this.st_begin_date
this.Control[iCurrent+7]=this.st_created_title
this.Control[iCurrent+8]=this.st_created
this.Control[iCurrent+9]=this.st_enc_date_title
this.Control[iCurrent+10]=this.st_encounter_date
this.Control[iCurrent+11]=this.st_created_by_title
this.Control[iCurrent+12]=this.st_created_by
this.Control[iCurrent+13]=this.st_ordered_by_title
this.Control[iCurrent+14]=this.st_ordered_by
this.Control[iCurrent+15]=this.st_encounter_by_title
this.Control[iCurrent+16]=this.st_encounter_by
this.Control[iCurrent+17]=this.st_end_date_title
this.Control[iCurrent+18]=this.st_end_date
this.Control[iCurrent+19]=this.st_closed_by_title
this.Control[iCurrent+20]=this.st_closed_by
this.Control[iCurrent+21]=this.st_status_title
this.Control[iCurrent+22]=this.st_status
this.Control[iCurrent+23]=this.dw_progress
this.Control[iCurrent+24]=this.st_progress_title
end on

on w_treatment_properties.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.st_title)
destroy(this.st_desc_title)
destroy(this.st_description)
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
destroy(this.dw_progress)
destroy(this.st_progress_title)
end on

event open;call super::open;str_popup popup
integer li_sts

popup = Message.powerobjectparm

treatment = popup.objectparm

if isnull(treatment) or not isvalid(treatment) then
	log.log(this, "w_treatment_properties:open", "Invalid Treatment", 4)
	close(this)
	return
end if

li_sts = load_properties()
if li_sts < 0 then
	log.log(this, "w_treatment_properties:open", "Error loading properties", 4)
	close(this)
	return
end if



end event

type pb_epro_help from w_window_base`pb_epro_help within w_treatment_properties
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_treatment_properties
end type

type pb_done from u_picture_button within w_treatment_properties
integer x = 2569
integer y = 1552
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;close(parent)

end event

type st_title from statictext within w_treatment_properties
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
long backcolor = 7191717
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type st_desc_title from statictext within w_treatment_properties
integer x = 407
integer y = 200
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
long backcolor = 7191717
boolean enabled = false
string text = "Description:"
boolean focusrectangle = false
end type

type st_description from statictext within w_treatment_properties
integer x = 407
integer y = 268
integer width = 2071
integer height = 196
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

type st_begin_title from statictext within w_treatment_properties
integer x = 155
integer y = 596
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
long backcolor = 7191717
boolean enabled = false
string text = "Begin Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_begin_date from statictext within w_treatment_properties
integer x = 594
integer y = 596
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

type st_created_title from statictext within w_treatment_properties
integer x = 1458
integer y = 852
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
long backcolor = 7191717
boolean enabled = false
string text = "Create Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_created from statictext within w_treatment_properties
integer x = 1902
integer y = 852
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

type st_enc_date_title from statictext within w_treatment_properties
integer x = 87
integer y = 852
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
long backcolor = 7191717
boolean enabled = false
string text = "Encounter Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_encounter_date from statictext within w_treatment_properties
integer x = 594
integer y = 852
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

type st_created_by_title from statictext within w_treatment_properties
integer x = 1390
integer y = 956
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
long backcolor = 7191717
boolean enabled = false
string text = "Created By:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_created_by from statictext within w_treatment_properties
integer x = 1902
integer y = 956
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

type st_ordered_by_title from statictext within w_treatment_properties
integer x = 87
integer y = 700
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
long backcolor = 7191717
boolean enabled = false
string text = "Ordered By:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_ordered_by from statictext within w_treatment_properties
integer x = 594
integer y = 700
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

type st_encounter_by_title from statictext within w_treatment_properties
integer x = 87
integer y = 956
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
long backcolor = 7191717
boolean enabled = false
string text = "Encounter By:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_encounter_by from statictext within w_treatment_properties
integer x = 594
integer y = 956
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

type st_end_date_title from statictext within w_treatment_properties
integer x = 1536
integer y = 596
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
long backcolor = 7191717
boolean enabled = false
string text = "End Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_end_date from statictext within w_treatment_properties
integer x = 1902
integer y = 596
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

type st_closed_by_title from statictext within w_treatment_properties
integer x = 1518
integer y = 700
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
long backcolor = 7191717
boolean enabled = false
string text = "Closed By:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_closed_by from statictext within w_treatment_properties
integer x = 1902
integer y = 700
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

type st_status_title from statictext within w_treatment_properties
integer x = 1390
integer y = 1088
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
long backcolor = 7191717
boolean enabled = false
string text = "Current Status:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_status from statictext within w_treatment_properties
integer x = 1902
integer y = 1088
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

type dw_progress from u_dw_pick_list within w_treatment_properties
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

type st_progress_title from statictext within w_treatment_properties
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
long backcolor = 7191717
boolean enabled = false
string text = "Progress:"
boolean focusrectangle = false
end type

