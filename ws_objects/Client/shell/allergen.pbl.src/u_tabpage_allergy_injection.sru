$PBExportHeader$u_tabpage_allergy_injection.sru
forward
global type u_tabpage_allergy_injection from u_tabpage
end type
type st_vial_warning from statictext within u_tabpage_allergy_injection
end type
type st_frequency from statictext within u_tabpage_allergy_injection
end type
type st_frequency_title from statictext within u_tabpage_allergy_injection
end type
type st_title from statictext within u_tabpage_allergy_injection
end type
type dw_schedule from u_dw_pick_list within u_tabpage_allergy_injection
end type
type st_5 from statictext within u_tabpage_allergy_injection
end type
type st_vial_title from statictext within u_tabpage_allergy_injection
end type
type st_vial from statictext within u_tabpage_allergy_injection
end type
type dw_shot_history from u_dw_pick_list within u_tabpage_allergy_injection
end type
type st_3 from statictext within u_tabpage_allergy_injection
end type
type sle_comments from singlelineedit within u_tabpage_allergy_injection
end type
type cb_shot from commandbutton within u_tabpage_allergy_injection
end type
type st_amount_title from statictext within u_tabpage_allergy_injection
end type
type st_4 from statictext within u_tabpage_allergy_injection
end type
type st_amount from statictext within u_tabpage_allergy_injection
end type
type st_2 from statictext within u_tabpage_allergy_injection
end type
type st_comment from statictext within u_tabpage_allergy_injection
end type
type uo_picture from u_picture_display within u_tabpage_allergy_injection
end type
type st_portrait from statictext within u_tabpage_allergy_injection
end type
type st_location from statictext within u_tabpage_allergy_injection
end type
type gb_this_injection from groupbox within u_tabpage_allergy_injection
end type
end forward

global type u_tabpage_allergy_injection from u_tabpage
integer width = 2816
integer height = 1428
long backcolor = 12632256
long tabbackcolor = 12632256
st_vial_warning st_vial_warning
st_frequency st_frequency
st_frequency_title st_frequency_title
st_title st_title
dw_schedule dw_schedule
st_5 st_5
st_vial_title st_vial_title
st_vial st_vial
dw_shot_history dw_shot_history
st_3 st_3
sle_comments sle_comments
cb_shot cb_shot
st_amount_title st_amount_title
st_4 st_4
st_amount st_amount
st_2 st_2
st_comment st_comment
uo_picture uo_picture
st_portrait st_portrait
st_location st_location
gb_this_injection gb_this_injection
end type
global u_tabpage_allergy_injection u_tabpage_allergy_injection

type variables
u_component_service		service
str_treatment_description treatment

boolean first_time = true

string location
real dose_amount
string vial_type

string location_domain
u_unit dose_unit

string vial_schedule
boolean custom_schedule

end variables

forward prototypes
public subroutine display_portrait ()
public function integer initialize (string ps_key)
public subroutine refresh ()
public subroutine set_vial_type (string ps_vial_type)
end prototypes

public subroutine display_portrait ();string ls_file
string ls_find
integer li_sts
u_component_attachment luo_image
str_progress_list lstr_attachments
long ll_null

setnull(ll_null)

lstr_attachments = current_patient.attachments.get_attachments( "Patient", ll_null, "Attachment", "Portrait")

If lstr_attachments.progress_count > 0 Then
	ls_file = current_patient.attachments.get_attachment(lstr_attachments.progress[lstr_attachments.progress_count].attachment_id)
	uo_picture.display_picture(ls_file)
	st_portrait.visible = false
	uo_picture.visible = true
	filedelete(ls_file)
else
	st_portrait.visible = true
	uo_picture.visible = false
end if
end subroutine

public function integer initialize (string ps_key);long ll_treatment_id
integer li_sts
real lr_x_factor
real lr_y_factor

ll_treatment_id = long(ps_key)

if isnull(ll_treatment_id) then
	log.log(this, "u_tabpage_allergy_injection.initialize:0009", "Null treatment_id", 4)
	return -1
end if

li_sts = current_patient.treatments.treatment(treatment, ll_treatment_id)
if li_sts <= 0 then
	log.log(this, "u_tabpage_allergy_injection.initialize:0015", "Error gettting treatment (" + string(ll_treatment_id) + ")", 4)
	return -1
end if

st_title.text = treatment.treatment_description

lr_x_factor = width / 2850
lr_y_factor = height / 1450
f_resize_objects(control, lr_x_factor, lr_y_factor, false, true)

uo_picture.initialize()

return 1

end function

public subroutine refresh ();u_ds_data luo_data
long ll_shot_count
long ll_schedule_count
string ls_vial_type_description
string ls_location_description
string ls_last_location
long i
string ls_temp
string ls_dose_unit
real lr_dose_amount
real lr_last_dose_amount
u_unit luo_unit
string ls_find
long ll_row
long ll_row2
boolean lb_reaction
long ll_lastrowonpage
long ll_last_lastrowonpage
long ll_scrollto
long ll_schedule_row
string ls_last_vial_type
long ll_count

lb_reaction = false

if first_time then
	first_time = false
	display_portrait()
	dw_shot_history.settransobject(sqlca)
	dw_schedule.settransobject(sqlca)
	
	st_frequency.text = treatment.administer_frequency
	
	vial_schedule = f_get_progress_value(current_patient.cpr_id, &
														"Treatment", &
														treatment.treatment_id, &
														"Property", &
														"Vial Schedule")
	if isnull(vial_schedule) then
		vial_schedule = "None"
	end if
	
	SELECT count(*)
	INTO :ll_count
	FROM c_Domain
	WHERE domain_id = 'Vial Schedule'
	AND domain_item = :vial_schedule;
	if not tf_check() then return
	
	if ll_count > 0 then
		custom_schedule = false
	else
		custom_schedule = true
	end if
	
	location_domain = f_get_progress_value(current_patient.cpr_id, &
														"Treatment", &
														treatment.treatment_id, &
														"Property", &
														"allergy_shot_location_domain")
	if isnull(location_domain) then
		location_domain = datalist.get_preference( "PREFERENCES", "allergy_shot_default_location_domain")
		if isnull(location_domain) then
			location_domain = "!AllergyAdmi"
		end if
	end if
	
	dose_unit = unit_list.find_unit(treatment.dose_unit)
	if isnull(dose_unit) then
		dose_unit = unit_list.find_unit("ML")
		if isnull(dose_unit) then
			log.log(this, "u_tabpage_allergy_injection.refresh:0072", "Error - Unable to find the unit object", 4)
			return
		end if
	end if
	
	setnull(dose_amount)
	
	if custom_schedule then
		dw_schedule.setredraw(false)
		ll_row = dw_schedule.insertrow(0)
		dw_schedule.object.comment[ll_row] = vial_schedule
		dw_schedule.setredraw(true)
	else
		ll_schedule_count = dw_schedule.retrieve(vial_schedule)
		for i = 1 to ll_schedule_count
			lr_dose_amount = dw_schedule.object.dose_amount[i]
			ls_dose_unit = dw_schedule.object.dose_unit[i]
			luo_unit = unit_list.find_unit(ls_dose_unit)
			if not isnull(luo_unit) then
				ls_temp = luo_unit.pretty_amount_unit(lr_dose_amount)
				dw_schedule.object.amount[i] = ls_temp
			end if
		next
	end if

end if

ll_schedule_count = dw_schedule.rowcount()

if dw_shot_history.width > 2136 then
	dw_shot_history.object.vial_type_description.width = 600
else
	dw_shot_history.object.vial_type_description.width = dw_shot_history.width - 1536
end if

ll_shot_count = dw_shot_history.retrieve(current_patient.cpr_id, treatment.treatment_id)
for i = 1 to ll_shot_count
	dw_shot_history.object.shot_number[i] = i
	lr_dose_amount = dw_shot_history.object.dose_amount[i]
	ls_temp = dose_unit.pretty_amount_unit(lr_dose_amount)
	dw_shot_history.object.description[i] = ls_temp
next

// Scroll to the bottom so the user can see the most recent shots
dw_shot_history.scrolltorow(ll_shot_count)

// If the shot button is disabled then don't change any of the shot info
if not cb_shot.enabled then return


// Start by getting the info for the last shot
if ll_shot_count > 0 then
	// If there's a last shot, then use it for the next shot defaults
	lr_last_dose_amount = dw_shot_history.object.dose_amount[ll_shot_count]
	ls_last_vial_type = dw_shot_history.object.vial_type[ll_shot_count]
	ls_last_location = dw_shot_history.object.location[ll_shot_count]
	ls_temp = dw_shot_history.object.reaction[ll_shot_count]
	if len(ls_temp) > 0 then
		lb_reaction = true
	end if
else
	setnull(lr_last_dose_amount)
	setnull(vial_type)
	setnull(ls_last_location)
end if


// Set defaults for any missing shot info...


///////////////////////////////////////////////////////////////////////////////
// If there was no last location, then just get the min location in the domain
///////////////////////////////////////////////////////////////////////////////
if isnull(ls_last_location) then
	SELECT min(location)
	INTO :ls_last_location
	FROM c_Location
	WHERE location_domain = :location_domain
	AND status = 'OK';
	if not tf_check() then return
	if isnull(ls_last_location) then
		log.log(this, "u_tabpage_allergy_injection.refresh:0153", "Error - Unable to find a valid location (" + location_domain + ")", 4)
		return
	end if
end if

// Rotate the location
SELECT min(location)
INTO :location
FROM c_Location
WHERE location_domain = :location_domain
AND status = 'OK'
AND location > :ls_last_location;
if not tf_check() then return
if isnull(location) then
	// We didn't find one greater than the last one, so just get the min again
	SELECT min(location)
	INTO :location
	FROM c_Location
	WHERE location_domain = :location_domain
	AND status = 'OK';
	if not tf_check() then return
	if isnull(location) then
		log.log(this, "u_tabpage_allergy_injection.refresh:0175", "Error - Unable to find a valid location (" + location_domain + ")", 4)
		return
	end if
end if
	
st_location.text = datalist.location_description(location)


//////////////////////////////////////////////////////////
// Find the schedule record associated with the last shot
//////////////////////////////////////////////////////////
if lr_last_dose_amount > 0 and len(ls_last_vial_type) > 0 then
	ls_find = "vial_type='" + ls_last_vial_type + "'"
	// We need to use a small range because equality
	// comparisons don't always work with reals
	ls_find += " and dose_amount > " + string(lr_last_dose_amount - 0.00001)
	ls_find += " and dose_amount < " + string(lr_last_dose_amount + 0.00001)
	
	ll_row = dw_schedule.find(ls_find, 1, ll_schedule_count)
	if ll_row > 0 then
		if lb_reaction then
			// If we had a reaction then back off one row
			if ll_row > 1 then
				// Make sure the next row has an amount
				lr_dose_amount = dw_schedule.object.dose_amount[ll_row - 1]
				if lr_dose_amount > 0 then
					ll_schedule_row = ll_row - 1
				else
					ll_schedule_row = ll_row
				end if
			else
				ll_schedule_row = 1
			end if
		else
			// If we didn't have a reaction then increase to the next row
			if ll_row < ll_schedule_count then
				// Make sure the next row has an amount
				lr_dose_amount = dw_schedule.object.dose_amount[ll_row + 1]
				if lr_dose_amount > 0 then
					ll_schedule_row = ll_row + 1
				else
					ll_schedule_row = ll_row
				end if
			else
				ll_schedule_row = ll_schedule_count
			end if
		end if
	else
		// We didn't find a row matching the last dose, so just display the vial
		// and make the user determine the dose
		set_vial_type(ls_last_vial_type)
		dose_amount = lr_last_dose_amount
		st_amount.text = dose_unit.pretty_amount_unit(dose_amount)
		ll_schedule_row = 0
	end if
elseif ll_schedule_count > 0 then
	lr_dose_amount = dw_schedule.object.dose_amount[1]
	if lr_dose_amount > 0 then
		ll_schedule_row = 1
	end if
end if


// Scroll the schedule down so that the entire vial is visible
ls_find = "vial_type='" + ls_last_vial_type + "'"
ll_row = dw_schedule.find(ls_find, 1, ll_schedule_count)
if ll_row > 0 then
	ls_find = "isnull(vial_type) or vial_type<>'" + ls_last_vial_type + "'"
	ll_row2 = dw_schedule.find(ls_find, ll_row + 1, ll_schedule_count)
	if ll_row2 > 0 then
		ll_scrollto = ll_row2
	else
		ll_scrollto = ll_schedule_count
	end if
elseif ll_shot_count > ll_schedule_count then
	// If we didn't find a vial record, then guess where we are in the schedule by
	// the number of shots
	ll_scrollto = ll_schedule_count
else
	ll_scrollto = ll_shot_count
end if

dw_schedule.scroll_to_row(ll_scrollto)

if ll_schedule_row > 0 then
	dw_schedule.object.selected_flag[ll_schedule_row] = 1
	dw_schedule.event POST selected(ll_schedule_row)
end if

return

end subroutine

public subroutine set_vial_type (string ps_vial_type);datetime ldt_max_expiration_date


vial_type = ps_vial_type
st_vial.text = datalist.vial_type_description(vial_type)

SELECT MAX(expiration_date)
INTO :ldt_max_expiration_date
FROM p_Treatment_Item
WHERE cpr_id = :current_patient.cpr_id
AND parent_treatment_id = :treatment.treatment_id
AND treatment_type = 'AllergyVialInstance'
AND ISNULL(p_Treatment_Item.treatment_status, 'OPEN') = 'OPEN'
AND p_Treatment_Item.vial_type = :vial_type;
if not tf_check() then return

if isnull(ldt_max_expiration_date) then
	// no open vial found
	st_vial_warning.text = "No Open Vials"
	st_vial_warning.visible = true
	cb_shot.enabled = false
elseif date(ldt_max_expiration_date) <= today() then
	// All vials expired
	st_vial_warning.text = "Warning: Vial is Expired"
	st_vial_warning.visible = true
	cb_shot.enabled = true
else
	// Non expired vial found
	st_vial_warning.visible = false
	cb_shot.enabled = true
end if


return

end subroutine

on u_tabpage_allergy_injection.create
int iCurrent
call super::create
this.st_vial_warning=create st_vial_warning
this.st_frequency=create st_frequency
this.st_frequency_title=create st_frequency_title
this.st_title=create st_title
this.dw_schedule=create dw_schedule
this.st_5=create st_5
this.st_vial_title=create st_vial_title
this.st_vial=create st_vial
this.dw_shot_history=create dw_shot_history
this.st_3=create st_3
this.sle_comments=create sle_comments
this.cb_shot=create cb_shot
this.st_amount_title=create st_amount_title
this.st_4=create st_4
this.st_amount=create st_amount
this.st_2=create st_2
this.st_comment=create st_comment
this.uo_picture=create uo_picture
this.st_portrait=create st_portrait
this.st_location=create st_location
this.gb_this_injection=create gb_this_injection
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_vial_warning
this.Control[iCurrent+2]=this.st_frequency
this.Control[iCurrent+3]=this.st_frequency_title
this.Control[iCurrent+4]=this.st_title
this.Control[iCurrent+5]=this.dw_schedule
this.Control[iCurrent+6]=this.st_5
this.Control[iCurrent+7]=this.st_vial_title
this.Control[iCurrent+8]=this.st_vial
this.Control[iCurrent+9]=this.dw_shot_history
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.sle_comments
this.Control[iCurrent+12]=this.cb_shot
this.Control[iCurrent+13]=this.st_amount_title
this.Control[iCurrent+14]=this.st_4
this.Control[iCurrent+15]=this.st_amount
this.Control[iCurrent+16]=this.st_2
this.Control[iCurrent+17]=this.st_comment
this.Control[iCurrent+18]=this.uo_picture
this.Control[iCurrent+19]=this.st_portrait
this.Control[iCurrent+20]=this.st_location
this.Control[iCurrent+21]=this.gb_this_injection
end on

on u_tabpage_allergy_injection.destroy
call super::destroy
destroy(this.st_vial_warning)
destroy(this.st_frequency)
destroy(this.st_frequency_title)
destroy(this.st_title)
destroy(this.dw_schedule)
destroy(this.st_5)
destroy(this.st_vial_title)
destroy(this.st_vial)
destroy(this.dw_shot_history)
destroy(this.st_3)
destroy(this.sle_comments)
destroy(this.cb_shot)
destroy(this.st_amount_title)
destroy(this.st_4)
destroy(this.st_amount)
destroy(this.st_2)
destroy(this.st_comment)
destroy(this.uo_picture)
destroy(this.st_portrait)
destroy(this.st_location)
destroy(this.gb_this_injection)
end on

type st_vial_warning from statictext within u_tabpage_allergy_injection
boolean visible = false
integer x = 1047
integer y = 1140
integer width = 1563
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 12632256
string text = "Warning: Vial is Expired"
boolean focusrectangle = false
end type

type st_frequency from statictext within u_tabpage_allergy_injection
integer x = 398
integer y = 1344
integer width = 398
integer height = 68
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "1X/WEEK"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_frequency_title from statictext within u_tabpage_allergy_injection
integer x = 59
integer y = 1344
integer width = 338
integer height = 68
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Frequency:"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title from statictext within u_tabpage_allergy_injection
integer x = 882
integer width = 1943
integer height = 100
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_schedule from u_dw_pick_list within u_tabpage_allergy_injection
integer x = 27
integer y = 592
integer width = 814
integer height = 740
integer taborder = 110
string dataobject = "dw_vial_schedule"
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event selected;call super::selected;real lr_dose_amount
string ls_vial_type

if custom_schedule then
	openwithparm(w_pop_message, vial_schedule)
else
	lr_dose_amount = object.dose_amount[selected_row]
	if lr_dose_amount > 0 then
		dose_amount = lr_dose_amount
		st_amount.text = dose_unit.pretty_amount_unit(dose_amount)
	end if
	ls_vial_type = object.vial_type[selected_row]
	if len(ls_vial_type) > 0 then
		set_vial_type(ls_vial_type)
	end if
end if



end event

type st_5 from statictext within u_tabpage_allergy_injection
integer x = 87
integer y = 528
integer width = 713
integer height = 68
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Schedule"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_vial_title from statictext within u_tabpage_allergy_injection
integer x = 1042
integer y = 956
integer width = 654
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Concentration"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_vial from statictext within u_tabpage_allergy_injection
integer x = 1042
integer y = 1032
integer width = 654
integer height = 104
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_vial_type_list"
popup.datacolumn = 1
popup.displaycolumn = 5
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

set_vial_type(popup_return.items[1])


end event

type dw_shot_history from u_dw_pick_list within u_tabpage_allergy_injection
integer x = 891
integer y = 204
integer width = 1897
integer height = 656
integer taborder = 100
string dataobject = "dw_jmj_allergy_shot_history"
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

type st_3 from statictext within u_tabpage_allergy_injection
integer x = 891
integer y = 132
integer width = 1897
integer height = 68
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Shot History"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_comments from singlelineedit within u_tabpage_allergy_injection
integer x = 933
integer y = 1276
integer width = 1243
integer height = 96
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type cb_shot from commandbutton within u_tabpage_allergy_injection
integer x = 2350
integer y = 1252
integer width = 389
integer height = 120
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Shot Given"
end type

event clicked;// Create Allergy injection Record
string ls_comment
string ls_location
string ls_description
long	ll_treatment_id,ll_null
datetime ldt_null
long ll_vial_treatment_id
str_popup popup
str_popup_return popup_return
string ls_message
datetime ldt_expiration_date

DECLARE lsp_create_allergy_injection PROCEDURE FOR dbo.sp_create_allergy_injection
			@ps_cpr_id = :current_patient.cpr_id,
			@pl_encounter_id = :current_patient.open_encounter.encounter_id,
			@pl_parent_treatment_id = :ll_vial_treatment_id,
			@ps_ordered_by = :current_user.user_id,
			@ps_created_by = :current_scribe.user_id,
			@ps_description = :ls_description,
			@pl_treatment_id = :ll_treatment_id OUT;


setnull(ldt_null)
setnull(ll_null)

popup.dataobject = "dw_allergy_open_vials_of_type"
popup.displaycolumn = 1
popup.datacolumn = 22
popup.auto_singleton = true
popup.title = "Select Vial"
popup.argument_count = 2
popup.numeric_argument = true
popup.argument[1] = string(treatment.treatment_id)
popup.argument[2] = vial_type
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then
	if popup_return.choices_count = 0 then
		openwithparm(w_pop_message, "There are no open vials of the specified type")
	end if
	return
end if
ll_vial_treatment_id = long(popup_return.items[1])

// Check the expiration date
SELECT expiration_date
INTO :ldt_expiration_date
FROM p_Treatment_item
WHERE cpr_id = :current_patient.cpr_id
AND treatment_id = :ll_vial_treatment_id;
if not tf_check() then return
if date(ldt_expiration_date) <= today() then
	ls_message = "The selected vial expired on " + string(date(ldt_expiration_date))
	ls_message += ".  Are you sure you want to administer an injection from this vial?"
	openwithparm(w_pop_yes_no, ls_message)
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return
end if

// Check the amount
IF isnull(dose_amount) or dose_amount <= 0 then
	OpenwithParm(w_pop_message,"Enter a valid amount")
	Return
END IF

ls_message = "Are you sure this dose was administered?"
ls_message += "~r~n"
ls_message += st_vial.text
ls_message += "    " + st_amount.text
ls_message += "    " + st_location.text
openwithparm(w_pop_yes_no, ls_message)
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

// set the allergy treatment desc with vial desc
ls_description = st_title.text + " - " + st_vial.text

// create a new injection
EXECUTE lsp_create_allergy_injection;
if not tf_check() then return -1
	
// injection treatment id
FETCH lsp_create_allergy_injection INTO :ll_treatment_id;
if not tf_check() then return -1
	
CLOSE lsp_create_allergy_injection;

// Disable the shot info buttons 
enabled = false
st_amount.enabled = false
sle_comments.enabled = false
st_vial.enabled = false
st_location.enabled = false
st_comment.enabled = false

// set the comments
ls_comment = sle_comments.text

// if an allergy injection treatment is created then
if not isnull(ll_treatment_id) and ll_treatment_id > 0 Then
	
	// update the dose amount
	if not isnull(location) Then
		f_set_progress(current_patient.cpr_id, &
              "Treatment", &
               ll_treatment_id, &
               'Modify', &
               'dose_amount', &
               dose_unit.pretty_amount(dose_amount), &
               ldt_null, &
               ll_null, &
               ll_null, &
               ll_null)
	end if

	// update the dose unit
	if not isnull(location) Then
		f_set_progress(current_patient.cpr_id, &
              "Treatment", &
               ll_treatment_id, &
               'Modify', &
               'dose_unit', &
               dose_unit.unit_id, &
               ldt_null, &
               ll_null, &
               ll_null, &
               ll_null)
	end if

	// update the location
	if not isnull(location) Then
		f_set_progress(current_patient.cpr_id, &
              "Treatment", &
               ll_treatment_id, &
               'Modify', &
               'location', &
               location, &
               ldt_null, &
               ll_null, &
               ll_null, &
               ll_null)
	end if

	// update the comments
	if not isnull(ls_comment) Then
		f_set_progress(current_patient.cpr_id, &
              "Treatment", &
               ll_treatment_id, &
               'Property', &
               'Comment', &
               ls_comment, &
               ldt_null, &
               ll_null, &
               ll_null, &
               ll_null)
	end if
	
end if

// re-load patient treatments
current_patient.load_treatments()

refresh()



end event

type st_amount_title from statictext within u_tabpage_allergy_injection
integer x = 1778
integer y = 956
integer width = 306
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Amount"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within u_tabpage_allergy_injection
integer x = 937
integer y = 1208
integer width = 329
integer height = 68
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Comments:"
boolean focusrectangle = false
end type

type st_amount from statictext within u_tabpage_allergy_injection
integer x = 1778
integer y = 1032
integer width = 306
integer height = 104
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string 	ls_dose
real 		lr_dose
decimal {3} ld_dose
str_popup popup
str_popup_return popup_return

lr_dose = dose_amount
if isnull(lr_dose) then lr_dose = 0.00

popup.realitem = lr_dose
popup.objectparm = dose_unit
Openwithparm(w_number, popup)
popup_return = message.powerobjectparm

if popup_return.item <> "OK" then 
	return
end if

dose_amount = popup_return.realitem
text = dose_unit.pretty_amount_unit(dose_amount)



end event

type st_2 from statictext within u_tabpage_allergy_injection
integer x = 2167
integer y = 956
integer width = 448
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Location"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_comment from statictext within u_tabpage_allergy_injection
integer x = 2194
integer y = 1280
integer width = 110
integer height = 92
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "..."
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;long   			ll_null
datetime 		ldt_null

str_popup			popup
str_popup_return  popup_return

setnull(ldt_null)
setnull(ll_null)


// Call progress note edit to get the comments
popup.data_row_count = 3
popup.items[1] = "ADMIN_VIAL"
popup.items[2] = "ADMIN_VIAL" 
popup.items[3] = sle_comments.text

Openwithparm(w_progress_note_edit,popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 0 then return

sle_comments.text = popup_return.items[1]


end event

type uo_picture from u_picture_display within u_tabpage_allergy_injection
event destroy ( )
integer x = 64
integer y = 16
integer width = 759
integer height = 500
integer taborder = 100
long backcolor = 12632256
end type

on uo_picture.destroy
call u_picture_display::destroy
end on

type st_portrait from statictext within u_tabpage_allergy_injection
integer x = 64
integer y = 16
integer width = 759
integer height = 500
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Portrait"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

event clicked;string ls_service

ls_service = datalist.get_preference("PREFERENCES", "portrait_service")
if isnull(ls_service) then ls_service = "PORTRAIT"

service_list.do_service(current_patient.cpr_id,current_patient.open_encounter_id,ls_service)

display_portrait()

end event

type st_location from statictext within u_tabpage_allergy_injection
integer x = 2167
integer y = 1032
integer width = 448
integer height = 104
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return


popup.dataobject = "dw_location_pick"
popup.argument_count = 1
popup.argument[1] = location_domain
popup.datacolumn = 1
popup.displaycolumn = 2
popup.add_blank_row = true
popup.blank_text = "<Other>"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 0 then return

if popup_return.items[1] = "" then
	setnull(location)
else
	location = popup_return.items[1]
end if

text = popup_return.descriptions[1]


end event

type gb_this_injection from groupbox within u_tabpage_allergy_injection
integer x = 910
integer y = 892
integer width = 1856
integer height = 516
integer taborder = 110
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 12632256
string text = "This Injection"
end type

