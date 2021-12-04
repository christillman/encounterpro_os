$PBExportHeader$u_tabpage_patient_encounters.sru
forward
global type u_tabpage_patient_encounters from u_tabpage
end type
type st_canceled_encounters from statictext within u_tabpage_patient_encounters
end type
type st_all_encounters from statictext within u_tabpage_patient_encounters
end type
type st_open_encounters from statictext within u_tabpage_patient_encounters
end type
type dw_encounters from u_dw_pick_list within u_tabpage_patient_encounters
end type
type st_cpr_id from statictext within u_tabpage_patient_encounters
end type
type st_title from statictext within u_tabpage_patient_encounters
end type
end forward

global type u_tabpage_patient_encounters from u_tabpage
integer width = 2875
integer height = 1268
string text = "none"
st_canceled_encounters st_canceled_encounters
st_all_encounters st_all_encounters
st_open_encounters st_open_encounters
dw_encounters dw_encounters
st_cpr_id st_cpr_id
st_title st_title
end type
global u_tabpage_patient_encounters u_tabpage_patient_encounters

type variables
string summary_report_id
long summary_display_script_id
string report_service

string encounter_status

end variables

forward prototypes
public function integer initialize ()
public subroutine refresh ()
end prototypes

public function integer initialize ();integer li_count
integer li_sts
string ls_temp

this.event TRIGGER resize_tabpage()

if isnull(current_patient) then
	log.log(this, "u_tabpage_patient_encounters.initialize:0008", "No current patient", 4)
	return -1
else
	st_cpr_id.text = current_patient.cpr_id
end if


summary_report_id = datalist.get_preference("PREFERENCES", "summary_report_id")
if isnull(summary_report_id) then summary_report_id = "{4B657EFA-AB67-482B-9FAB-1764440DF116}"

summary_display_script_id = long(datalist.get_preference("PREFERENCES", "default_encounter_display_script_id"))

report_service = datalist.get_preference("PREFERENCES", "summary_report_service")
if isnull(report_service) then report_service = "REPORT"

encounter_status = 'OPEN'
st_open_encounters.backcolor = color_object_selected

SELECT count(*)
INTO :li_count
FROM p_Patient_Encounter
WHERE cpr_id = :current_patient.cpr_id
AND encounter_status = 'OPEN';
if not tf_check() then return -1

if li_count > 0 then
	text = "Open Encounters (" + string(li_count) + ")"
else
	text = "Open Encounters (0)"
end if

return 1

end function

public subroutine refresh ();long ll_rows
integer li_count

dw_encounters.settransobject(sqlca)
if encounter_status = "CANCELED" then
	dw_encounters.setfilter("")
else
	dw_encounters.setfilter("upper(encounter_status) = 'OPEN' or  upper(encounter_status) = 'CLOSED'")
end if
ll_rows = dw_encounters.retrieve(current_patient.cpr_id, '%', '%', encounter_status)

li_count = dw_encounters.rowcount()

if upper(encounter_status) = "OPEN" then
	if li_count > 0 then
		text = "Open Encounters (" + string(li_count) + ")"
	else
		text = "Open Encounters (0)"
	end if
elseif upper(encounter_status) = "CANCELED" then
	if li_count > 0 then
		text = "Canceled Encounters (" + string(li_count) + ")"
	else
		text = "Canceled Encounters (0)"
	end if
else
	if li_count > 0 then
		text = "Encounters (" + string(li_count) + ")"
	else
		text = "Encounters (0)"
	end if
end if

return

end subroutine

on u_tabpage_patient_encounters.create
int iCurrent
call super::create
this.st_canceled_encounters=create st_canceled_encounters
this.st_all_encounters=create st_all_encounters
this.st_open_encounters=create st_open_encounters
this.dw_encounters=create dw_encounters
this.st_cpr_id=create st_cpr_id
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_canceled_encounters
this.Control[iCurrent+2]=this.st_all_encounters
this.Control[iCurrent+3]=this.st_open_encounters
this.Control[iCurrent+4]=this.dw_encounters
this.Control[iCurrent+5]=this.st_cpr_id
this.Control[iCurrent+6]=this.st_title
end on

on u_tabpage_patient_encounters.destroy
call super::destroy
destroy(this.st_canceled_encounters)
destroy(this.st_all_encounters)
destroy(this.st_open_encounters)
destroy(this.dw_encounters)
destroy(this.st_cpr_id)
destroy(this.st_title)
end on

event resize_tabpage;call super::resize_tabpage;
// Restore the original dimensions cuz they got resized by the window base class and some of the tab pages still need that
st_title.height = 136
dw_encounters.width = 2423
st_all_encounters.height = 100
st_all_encounters.width = 475
st_open_encounters.height = 100
st_open_encounters.width = 475
st_canceled_encounters.height = 100
st_canceled_encounters.width = 475


// Place the objects
st_title.width = width

st_all_encounters.x = (width - st_all_encounters.width) / 2
st_all_encounters.y = height - st_all_encounters.height - 50

st_open_encounters.x = st_all_encounters.x - st_open_encounters.width - 50
st_open_encounters.y = st_all_encounters.y

st_canceled_encounters.x = st_all_encounters.x + st_all_encounters.width + 50
st_canceled_encounters.y = st_all_encounters.y

dw_encounters.width = 2423
dw_encounters.x = (width - dw_encounters.width) / 2
dw_encounters.y = st_title.y + st_title.height + 30
dw_encounters.height = st_all_encounters.y - dw_encounters.y - 30



end event

type st_canceled_encounters from statictext within u_tabpage_patient_encounters
integer x = 1687
integer y = 1032
integer width = 475
integer height = 100
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Canceled"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_open_encounters.backcolor = color_object
st_all_encounters.backcolor = color_object
encounter_status = "CANCELED"
refresh()

end event

type st_all_encounters from statictext within u_tabpage_patient_encounters
integer x = 1175
integer y = 1032
integer width = 475
integer height = 100
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "All"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_open_encounters.backcolor = color_object
st_canceled_encounters.backcolor = color_object
encounter_status = "%"
refresh()

end event

type st_open_encounters from statictext within u_tabpage_patient_encounters
integer x = 663
integer y = 1032
integer width = 475
integer height = 100
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Open"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_all_encounters.backcolor = color_object
st_canceled_encounters.backcolor = color_object
encounter_status = "OPEN"
refresh()

end event

type dw_encounters from u_dw_pick_list within u_tabpage_patient_encounters
integer x = 279
integer y = 164
integer width = 2423
integer height = 852
integer taborder = 10
string dataobject = "dw_sp_get_encounter_list"
boolean vscrollbar = true
boolean border = false
end type

event computed_clicked;call super::computed_clicked;str_attributes lstr_attributes
long ll_encounter_id

ll_encounter_id = object.encounter_id[clicked_row]

f_attribute_add_attribute(lstr_attributes, "report_id", summary_report_id)
f_attribute_add_attribute(lstr_attributes, "display_script_id", string(summary_display_script_id))
f_attribute_add_attribute(lstr_attributes, "destination", "SCREEN")

service_list.do_service(current_patient.cpr_id, ll_encounter_id, report_service, lstr_attributes)


end event

event selected;call super::selected;integer li_sts
string ls_null
string ls_encounter_status
string ls_context
long ll_encounter_id
string ls_key

setnull(ls_null)

if not lastcomputed then
	ls_encounter_status = object.encounter_status[selected_row]
	ll_encounter_id = object.encounter_id[selected_row]
	
	li_sts = f_set_current_encounter(ll_encounter_id)
	if li_sts <= 0 then return
	
	ls_context = "Encounter"
	
	ls_key = wordcap(ls_encounter_status)
	
	// Display the room-specific menu
	li_sts = f_display_context_menu(ls_context, ls_key)
	
	f_clear_current_encounter()
	
	refresh()
end if

end event

type st_cpr_id from statictext within u_tabpage_patient_encounters
integer x = 27
integer y = 24
integer width = 375
integer height = 72
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title from statictext within u_tabpage_patient_encounters
integer width = 2885
integer height = 136
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Patient Encounters"
alignment alignment = center!
boolean focusrectangle = false
end type

