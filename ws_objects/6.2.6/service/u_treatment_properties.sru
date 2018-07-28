HA$PBExportHeader$u_treatment_properties.sru
forward
global type u_treatment_properties from userobject
end type
type st_ordered_by_supervisor_title from statictext within u_treatment_properties
end type
type st_ordered_by_supervisor from statictext within u_treatment_properties
end type
type st_end_date_changed from statictext within u_treatment_properties
end type
type st_begin_date_changed from statictext within u_treatment_properties
end type
type st_progress_title from statictext within u_treatment_properties
end type
type dw_progress from u_dw_pick_list within u_treatment_properties
end type
type st_status from statictext within u_treatment_properties
end type
type st_status_title from statictext within u_treatment_properties
end type
type st_closed_by from statictext within u_treatment_properties
end type
type st_closed_by_title from statictext within u_treatment_properties
end type
type st_end_date from statictext within u_treatment_properties
end type
type st_end_date_title from statictext within u_treatment_properties
end type
type st_encounter_by from statictext within u_treatment_properties
end type
type st_encounter_by_title from statictext within u_treatment_properties
end type
type st_ordered_by from statictext within u_treatment_properties
end type
type st_ordered_by_title from statictext within u_treatment_properties
end type
type st_created_by from statictext within u_treatment_properties
end type
type st_created_by_title from statictext within u_treatment_properties
end type
type st_encounter_date from statictext within u_treatment_properties
end type
type st_enc_date_title from statictext within u_treatment_properties
end type
type st_created from statictext within u_treatment_properties
end type
type st_created_title from statictext within u_treatment_properties
end type
type st_begin_date from statictext within u_treatment_properties
end type
type st_begin_title from statictext within u_treatment_properties
end type
end forward

global type u_treatment_properties from userobject
integer width = 2802
integer height = 1012
long backcolor = 33538240
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
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
global u_treatment_properties u_treatment_properties

type variables
u_component_treatment treatment
end variables

forward prototypes
public function integer display_properties ()
public function integer initialize (u_component_treatment puo_treatment)
end prototypes

public function integer display_properties ();Long			i,ll_rows
String		ls_format,ls_user_id
Datetime		ldt_date
Long 			ll_progress_sequence
/* user defined */
str_progress_list lstr_progress
string ls_null

setnull(ls_null)

ls_format = date_format_string + " " + time_format_string

st_begin_date.text = string(treatment.begin_date, ls_format)
st_created.text = string(treatment.created, ls_format)
st_end_date.text = string(treatment.end_date, ls_format)

st_ordered_by.text = user_list.user_full_name(treatment.ordered_by)
st_ordered_by.backcolor = user_list.user_color(treatment.ordered_by)

if len(treatment.ordered_by_supervisor) > 0 then
	st_ordered_by_supervisor.text = user_list.user_full_name(treatment.ordered_by_supervisor)
	st_ordered_by_supervisor.backcolor = user_list.user_color(treatment.ordered_by_supervisor)
else
	st_ordered_by_supervisor.visible = false
	st_ordered_by_supervisor_title.visible = false
end if

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

// Don't let the user change the end_date if the treatment is still open
if isnull(treatment.treatment_status) then
	st_end_date.borderstyle = stylebox!
	st_end_date.enabled = false
else
	st_end_date.borderstyle = styleraised!
	st_end_date.enabled = true
end if

st_begin_date_changed.visible = false
st_end_date_changed.visible = false

lstr_progress = f_get_progress(current_patient.cpr_id, "Treatment", treatment.treatment_id, ls_null, ls_null)
for i = 1 to ll_rows
	dw_progress.object.progress_sequence[i] = lstr_progress.progress[i].progress_sequence
	dw_progress.object.progress_date_time[i] = lstr_progress.progress[i].progress_date_time
	dw_progress.object.description[i] = lstr_progress.progress[i].progress_full_description
	dw_progress.object.user_name[i] = user_list.user_short_name(lstr_progress.progress[i].user_id)
	dw_progress.object.user_color[i] = user_list.user_color(lstr_progress.progress[i].user_id)
	
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

public function integer initialize (u_component_treatment puo_treatment);treatment = puo_treatment

return 1



end function

on u_treatment_properties.create
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
this.Control[]={this.st_ordered_by_supervisor_title,&
this.st_ordered_by_supervisor,&
this.st_end_date_changed,&
this.st_begin_date_changed,&
this.st_progress_title,&
this.dw_progress,&
this.st_status,&
this.st_status_title,&
this.st_closed_by,&
this.st_closed_by_title,&
this.st_end_date,&
this.st_end_date_title,&
this.st_encounter_by,&
this.st_encounter_by_title,&
this.st_ordered_by,&
this.st_ordered_by_title,&
this.st_created_by,&
this.st_created_by_title,&
this.st_encounter_date,&
this.st_enc_date_title,&
this.st_created,&
this.st_created_title,&
this.st_begin_date,&
this.st_begin_title}
end on

on u_treatment_properties.destroy
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

type st_ordered_by_supervisor_title from statictext within u_treatment_properties
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

type st_ordered_by_supervisor from statictext within u_treatment_properties
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

type st_end_date_changed from statictext within u_treatment_properties
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

type st_begin_date_changed from statictext within u_treatment_properties
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

type st_progress_title from statictext within u_treatment_properties
integer x = 55
integer y = 492
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

type dw_progress from u_dw_pick_list within u_treatment_properties
integer x = 41
integer y = 560
integer width = 2729
integer height = 444
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_properties_progress"
boolean vscrollbar = true
boolean border = false
end type

type st_status from statictext within u_treatment_properties
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

type st_status_title from statictext within u_treatment_properties
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

type st_closed_by from statictext within u_treatment_properties
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

type st_closed_by_title from statictext within u_treatment_properties
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

type st_end_date from statictext within u_treatment_properties
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
popup.item = string(treatment.end_date)

openwithparm(w_pop_prompt_date_time, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 2 then return

ldt_end_date = datetime(date(popup_return.items[1]), time(popup_return.items[2]))
li_sts = current_patient.treatments.modify_treatment(treatment.treatment_id, "end_date", string(ldt_end_date))
if li_sts <= 0 then return

treatment.end_date = ldt_end_date

display_properties()

end event

type st_end_date_title from statictext within u_treatment_properties
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

type st_encounter_by from statictext within u_treatment_properties
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

type st_encounter_by_title from statictext within u_treatment_properties
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

type st_ordered_by from statictext within u_treatment_properties
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

type st_ordered_by_title from statictext within u_treatment_properties
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

type st_created_by from statictext within u_treatment_properties
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

type st_created_by_title from statictext within u_treatment_properties
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

type st_encounter_date from statictext within u_treatment_properties
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

type st_enc_date_title from statictext within u_treatment_properties
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

type st_created from statictext within u_treatment_properties
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

type st_created_title from statictext within u_treatment_properties
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

type st_begin_date from statictext within u_treatment_properties
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
popup.item = string(treatment.begin_date)

openwithparm(w_pop_prompt_date_time, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 2 then return

ldt_begin_date = datetime(date(popup_return.items[1]), time(popup_return.items[2]))
li_sts = current_patient.treatments.modify_treatment(treatment.treatment_id, "begin_date", string(ldt_begin_date))
if li_sts <= 0 then return

treatment.begin_date = ldt_begin_date

display_properties()


end event

type st_begin_title from statictext within u_treatment_properties
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

