$PBExportHeader$w_post_attachment_to_object.srw
forward
global type w_post_attachment_to_object from w_window_base
end type
type dw_post_to from u_dw_pick_list within w_post_attachment_to_object
end type
type st_existing_title from statictext within w_post_attachment_to_object
end type
type st_page from statictext within w_post_attachment_to_object
end type
type pb_up from u_picture_button within w_post_attachment_to_object
end type
type pb_down from u_picture_button within w_post_attachment_to_object
end type
type cb_post_existing from commandbutton within w_post_attachment_to_object
end type
type cb_cancel from commandbutton within w_post_attachment_to_object
end type
type st_new_title from statictext within w_post_attachment_to_object
end type
type st_begin_date_title from statictext within w_post_attachment_to_object
end type
type st_type_title from statictext within w_post_attachment_to_object
end type
type st_end_date_title from statictext within w_post_attachment_to_object
end type
type st_type from statictext within w_post_attachment_to_object
end type
type st_begin_date from statictext within w_post_attachment_to_object
end type
type st_end_date from statictext within w_post_attachment_to_object
end type
type st_description_title from statictext within w_post_attachment_to_object
end type
type mle_description from multilineedit within w_post_attachment_to_object
end type
type cb_post_new from commandbutton within w_post_attachment_to_object
end type
type st_pick_title from statictext within w_post_attachment_to_object
end type
type st_pick from statictext within w_post_attachment_to_object
end type
type dw_attributes from u_dw_pick_list within w_post_attachment_to_object
end type
type st_show_open from statictext within w_post_attachment_to_object
end type
type st_show_all from statictext within w_post_attachment_to_object
end type
type st_1 from statictext within w_post_attachment_to_object
end type
type ln_1 from line within w_post_attachment_to_object
end type
type str_post_to_object from structure within w_post_attachment_to_object
end type
end forward

type str_post_to_object from structure
	string		object_type
	long		treatment_id
	date		object_date
	string		description
	long		encounter_id
	string		letter_type
end type

global type w_post_attachment_to_object from w_window_base
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event post_open pbm_custom01
dw_post_to dw_post_to
st_existing_title st_existing_title
st_page st_page
pb_up pb_up
pb_down pb_down
cb_post_existing cb_post_existing
cb_cancel cb_cancel
st_new_title st_new_title
st_begin_date_title st_begin_date_title
st_type_title st_type_title
st_end_date_title st_end_date_title
st_type st_type
st_begin_date st_begin_date
st_end_date st_end_date
st_description_title st_description_title
mle_description mle_description
cb_post_new cb_post_new
st_pick_title st_pick_title
st_pick st_pick
dw_attributes dw_attributes
st_show_open st_show_open
st_show_all st_show_all
st_1 st_1
ln_1 ln_1
end type
global w_post_attachment_to_object w_post_attachment_to_object

type variables
str_attachment_context attachment_context

datetime begin_date
datetime end_date

str_attributes folder_attributes

long encounter_id

boolean open_only = true
end variables

forward prototypes
public function integer initialize ()
public function integer pick_treatment ()
public function integer order_treatment ()
public function integer order_assessment ()
public function integer pick_assessment ()
public function integer pick_encounter ()
public function integer order_encounter ()
public function string get_context_object_type (boolean pb_initial)
public subroutine display_attributes ()
end prototypes

event post_open;call super::post_open;integer li_sts
str_popup popup
str_popup_return popup_return
string ls_message

// Now we need to determine the context_object_type
if isnull(attachment_context.context_object_type) or trim(attachment_context.context_object_type) = "" then
	attachment_context.context_object_type = get_context_object_type(true)
end if

//// If the context_object_type is still null then return an error
//if isnull(attachment_context.context_object_type) or trim(attachment_context.context_object_type) = "" then
//	ls_message = "Context Object Type could not be determined (" + attachment_context.folder + ")"
//	openwithparm(w_pop_message, ls_message)
//	log.log(this, "w_post_attachment_to_object:post", ls_message, 4)
//	setnull(attachment_context.object_key)
//	closewithreturn(this, attachment_context)
//	Return
//end if

li_sts = initialize()
if li_sts <= 0 then
	log.log(this,"w_post_attachment_to_object:post","Initialize failed", 4)
	setnull(attachment_context.object_key)
	closewithreturn(this, attachment_context)
	Return
End If

end event

public function integer initialize ();long ll_count
string ls_in_office_flag
u_ds_data luo_folder_attributes
str_treatment_description lstr_treatments[]
str_assessment_description lstr_assessments[]
str_encounter_description lstr_encounters[]
str_encounter_description lstr_new_encounter
string ls_find
long i
long ll_row
integer li_sts
long ll_new_encounter_id
string ls_preference_id

setnull(end_date)
setnull(encounter_id)
dw_post_to.reset()

ls_preference_id = "PostObject|" + attachment_context.context_object
if len(attachment_context.context_object_type) > 0 then
	ls_preference_id += "|" + attachment_context.context_object_type
end if
open_only = datalist.get_preference_boolean( "PREFERENCES", ls_preference_id, false)
if open_only then
	st_show_open.backcolor = color_object_selected
	st_show_all.backcolor = color_object
else
	st_show_open.backcolor = color_object
	st_show_all.backcolor = color_object_selected
end if

if attachment_context.begin_date > datetime(date('1/1/1901'), time("")) then
	begin_date = attachment_context.begin_date
else
	begin_date = datetime(today(), time(""))
end if
st_begin_date.text = string(date(begin_date))

if not isnull(current_service) then
	encounter_id = current_service.encounter_id
end if

if len(attachment_context.folder) > 0 then
	luo_folder_attributes = CREATE u_ds_data
	luo_folder_attributes.set_dataobject("dw_c_folder_attribute")
	ll_count = luo_folder_attributes.retrieve(attachment_context.folder)
	if ll_count < 0 then return -1
	
	f_attribute_ds_to_str(luo_folder_attributes, folder_attributes)
	
	DESTROY luo_folder_attributes
end if


st_pick_title.text = "Select " + wordcap(attachment_context.context_object)
cb_post_existing.text = "Post to " + wordcap(attachment_context.context_object)
cb_post_new.text = "New " + wordcap(attachment_context.context_object)
st_existing_title.text = "Post to Existing " + wordcap(attachment_context.context_object)
st_new_title.text = "Post to New " + wordcap(attachment_context.context_object)
st_type_title.text = wordcap(attachment_context.context_object) + " Type"

// Set the encounter context
if isnull(current_display_encounter) then current_patient.encounters.last_encounter()

CHOOSE CASE lower(attachment_context.context_object)
	CASE "encounter"
		st_type.visible = false
		st_type_title.visible = false
		st_pick_title.text = "Encounter Type"

		mle_description.text = attachment_context.description
		
		if not isnull(attachment_context.context_object_type) then
			st_pick.text = datalist.encounter_type_description(attachment_context.context_object_type)
			if isnull(st_pick.text) then st_pick.text = wordcap(attachment_context.context_object_type)
			if isnull(mle_description.text) or trim(mle_description.text) = "" then
				mle_description.text = st_pick.text
			end if
		end if
		
		st_end_date.visible = false
		st_end_date_title.visible = false
		st_begin_date_title.text = "Encounter Date"
		
		if isnull(attachment_context.context_object_type) then
			ls_find = "1=1"
		else
			ls_find = "upper(encounter_type)='" + upper(attachment_context.context_object_type) + "'"
		end if
		
		if open_only then
			ls_find += " and encounter_type='OPEN'"
		end if
		
		ll_count = current_patient.encounters.get_encounters(ls_find, lstr_encounters)
		// Put the most recent treatments at the top
		for i = ll_count to 1 step -1
			ll_row = dw_post_to.insertrow(0)
			dw_post_to.object.context_object[ll_row] = attachment_context.context_object
			dw_post_to.object.object_key[ll_row] = lstr_encounters[i].encounter_id
			dw_post_to.object.description[ll_row] = lstr_encounters[i].description
			dw_post_to.object.begin_date[ll_row] = lstr_encounters[i].encounter_date
			dw_post_to.object.end_date[ll_row] = lstr_encounters[i].discharge_date
		next
	CASE "assessment"
		if isnull(attachment_context.context_object_type) then
			st_type.text = "Unknown"
			mle_description.text = ""
			ls_find = "1=1"
		else
			st_type.text = datalist.assessment_type_description(attachment_context.context_object_type)
			mle_description.text = st_type.text
			ls_find = "upper(assessment_type)='" + upper(attachment_context.context_object_type) + "'"
		end if
		
		if open_only then
			ls_find += " and (isnull(assessment_status) or assessment_status='OPEN')"
		end if
		
		if len(attachment_context.description) > 0 then
			mle_description.text = attachment_context.description
		end if
		
		ll_count = current_patient.assessments.get_assessments(ls_find, lstr_assessments)
		// Put the most recent assessments at the top
		for i = ll_count to 1 step -1
			ll_row = dw_post_to.insertrow(0)
			dw_post_to.object.context_object[ll_row] = attachment_context.context_object
			dw_post_to.object.object_key[ll_row] = lstr_assessments[i].problem_id
			dw_post_to.object.description[ll_row] = lstr_assessments[i].assessment
			dw_post_to.object.begin_date[ll_row] = lstr_assessments[i].begin_date
			dw_post_to.object.end_date[ll_row] = lstr_assessments[i].end_date
		next
	CASE "treatment"
		// Make sure we have an encounter context
		if isnull(current_display_encounter) then
			lstr_new_encounter.office_id = gnv_app.office_id
			lstr_new_encounter.encounter_type = "REVIEW"
			lstr_new_encounter.encounter_date = datetime(today(), now())
			lstr_new_encounter.new_flag = "N"
			lstr_new_encounter.description = "Chart Maintenance - Posting scanned item(s)"
			lstr_new_encounter.attending_doctor = current_user.user_id
			setnull(lstr_new_encounter.indirect_flag)
			setnull(lstr_new_encounter.referring_doctor)
			setnull(lstr_new_encounter.supervising_doctor)
			lstr_new_encounter.bill_flag = "N"
			
			ll_new_encounter_id = current_patient.new_encounter(lstr_new_encounter, current_scribe.user_id, false)
			if isnull(ll_new_encounter_id) or ll_new_encounter_id <= 0 then
				openwithparm(w_pop_message, "You may not post to a treatment until this patient has an encounter")
				return -1
			end if
		end if
		
		if isnull(attachment_context.context_object_type) then
			st_type.text = "Unknown"
			mle_description.text = ""
			ls_in_office_flag = "N"
			ls_find = "lower(observation_type) = 'lab/test'"
		else
			st_type.text = datalist.treatment_type_description(attachment_context.context_object_type)
			mle_description.text = st_type.text
			
			ls_in_office_flag = datalist.treatment_type_in_office_flag(attachment_context.context_object_type)
			
			ls_find = "upper(treatment_type)='" + upper(attachment_context.context_object_type) + "'"
		end if
		
		if len(attachment_context.description) > 0 then
			mle_description.text = attachment_context.description
		end if

		if upper(ls_in_office_flag) = "Y" then
			st_end_date.visible = false
			st_end_date_title.visible = false
			st_begin_date_title.text = "Treatment Date"
		else
			st_end_date.visible = true
			st_end_date_title.visible = true
			st_begin_date_title.text = "Begin Date"
		end if
		
		if open_only then
			ls_find += " and (isnull(treatment_status) or treatment_status='OPEN')"
		end if
		
		ll_count = current_patient.treatments.get_treatments(ls_find, lstr_treatments)
		// Put the most recent treatments at the top
		for i = ll_count to 1 step -1
			ll_row = dw_post_to.insertrow(0)
			dw_post_to.object.context_object[ll_row] = attachment_context.context_object
			dw_post_to.object.object_key[ll_row] = lstr_treatments[i].treatment_id
			dw_post_to.object.description[ll_row] = lstr_treatments[i].treatment_description
			dw_post_to.object.begin_date[ll_row] = lstr_treatments[i].begin_date
			dw_post_to.object.end_date[ll_row] = lstr_treatments[i].end_date
			if len(lstr_treatments[i].specimen_id) > 0 then
				dw_post_to.object.extra_info[ll_row] = "Specimen ID:  " + lstr_treatments[i].specimen_id
			end if
		next
	CASE ELSE
		log.log(this, "w_post_attachment_to_object.initialize:0201", "Invalid attachment_context.context_object (" + attachment_context.context_object + ")", 4)
		return -1
END CHOOSE

dw_post_to.set_page(1, pb_up, pb_down, st_page)

display_attributes()

return 1

end function

public function integer pick_treatment ();u_component_treatment luo_treatment
integer li_sts
long ll_null
long ll_count
string lsa_attributes[]
string lsa_values[]
string ls_treatment_type
long i
long ll_encounter_id

setnull(ll_null)
ll_count = 0

ls_treatment_type = attachment_context.context_object_type
if isnull(ls_treatment_type) then return 0

luo_treatment = f_get_treatment_component(ls_treatment_type)
if isnull(luo_treatment) then
	log.log(this, "w_post_attachment_to_object.pick_treatment:0019", "Unable to get treatment object (" + ls_treatment_type + ")", 4)
	return -1
end if

li_sts = luo_treatment.define_treatment()
if luo_treatment.treatment_count <= 0 then return 0

st_pick.text = luo_treatment.treatment_definition[1].item_description
mle_description.text = st_pick.text

attachment_context.object_attributes.attribute_count = 0
for i = 1 to luo_treatment.treatment_definition[1].attribute_count
	f_attribute_add_attribute(attachment_context.object_attributes, &
										luo_treatment.treatment_definition[1].attribute[i], &
										luo_treatment.treatment_definition[1].value[i])
next

display_attributes()

return 1

end function

public function integer order_treatment ();integer li_sts
long ll_null
string ls_treatment_type
long i
long ll_treatment_id
string ls_ordered_by

setnull(ll_null)

ls_treatment_type = attachment_context.context_object_type
if isnull(ls_treatment_type) then return 0

f_attribute_add_attribute(attachment_context.object_attributes, "begin_date", string(begin_date))
f_attribute_add_attribute(attachment_context.object_attributes, "end_date", string(end_date))

if len(attachment_context.user_id) > 0 then
	ls_ordered_by = attachment_context.user_id
else
	ls_ordered_by = current_user.user_id
end if

ll_treatment_id = current_patient.treatments.order_treatment(current_patient.cpr_id, &
																				encounter_id, &
																				ls_treatment_type, &
																				mle_description.text, &
																				ll_null, &
																				true, &
																				ls_ordered_by, &
																				ll_null, &
																				attachment_context.object_attributes, &
																				false)
if ll_treatment_id <= 0 then return -1	

attachment_context.object_key = ll_treatment_id
attachment_context.description = mle_description.text

return 1

end function

public function integer order_assessment ();integer li_sts
long ll_null
long i
long ll_problem_id
string ls_location
long ll_attachment_id
string ls_assessment_id
boolean lb_leave_open
string ls_temp
integer li_diagnosis_sequence
string ls_null
string ls_assessment_type

setnull(ls_null)
setnull(li_diagnosis_sequence)
setnull(ll_null)
setnull(ll_attachment_id)

ls_assessment_id = f_attribute_find_attribute(attachment_context.object_attributes, "assessment_id")
if isnull(ls_assessment_id) then
	openwithparm(w_pop_message, "Please select an assessment")
	return 0
end if

ls_assessment_type = attachment_context.context_object_type
if isnull(ls_assessment_type) then
	openwithparm(w_pop_message, "Please select an assessment type")
	return 0
end if

if isnull(ls_assessment_id) or isnull(ls_assessment_type) then
	openwithparm(w_pop_message, "Please select an assessment")
	return 0
end if

ls_location = f_attribute_find_attribute(attachment_context.object_attributes, "location")
ls_temp = f_attribute_find_attribute(attachment_context.object_attributes, "leave_open")
if isnull(ls_temp) then
	// By default, leave the assessment open if it has no end date
	lb_leave_open = true
else
	lb_leave_open = f_string_to_boolean(ls_temp)
end if

if isnull(attachment_context.context_object_type) then return 0
if isnull(ls_assessment_id) then return 0

ll_problem_id = current_patient.assessments.add_assessment( encounter_id, &
																				ls_assessment_type, &
																				ls_assessment_id, &
																				mle_description.text, &
																				ll_attachment_id, &
																				begin_date, &
																				current_user.user_id, &
																				ls_location, &
																				current_scribe.user_id &
																				)
if ll_problem_id <= 0 then return -1	

// If we have and end_date then close the assessment
if not isnull(end_date) or not lb_leave_open then
	// If the assessment has an end date or if the leave_open flag is false then close the assessment
	if isnull(end_date) then end_date = begin_date
	current_patient.assessments.set_progress(ll_problem_id, &
															li_diagnosis_sequence, &
															"CLOSED", &
															ls_null, &
															ls_null, &
															end_date)
end if

attachment_context.object_key = ll_problem_id
attachment_context.description = mle_description.text

return 1

end function

public function integer pick_assessment ();string ls_assessment_type
string ls_assessment_id
string ls_list_id
integer li_sts
w_window_base lw_pick_assessments
str_popup popup
str_picked_assessments lstr_assessments
str_picked_assessment lstr_picked_assessment
long ll_problem_id
long i
long ll_attachment_id
u_str_assessment luo_assessment

setnull(ll_attachment_id)

ls_assessment_type = upper(attachment_context.context_object_type)

// Otherwise, just let the user pick the assessment(s)
popup.data_row_count = 2
popup.items[1] = ls_assessment_type
popup.items[2] = string(encounter_id)

openwithparm(lw_pick_assessments, popup, "w_pick_assessments")
lstr_assessments = message.powerobjectparm
if lstr_assessments.assessment_count = 0 then return 0
lstr_picked_assessment = lstr_assessments.assessments[1]

st_pick.text = lstr_picked_assessment.description
mle_description.text = st_pick.text

attachment_context.object_attributes.attribute_count = 0
f_attribute_add_attribute(attachment_context.object_attributes, "assessment_type", lstr_picked_assessment.assessment_type)
f_attribute_add_attribute(attachment_context.object_attributes, "assessment_id", lstr_picked_assessment.assessment_id)
f_attribute_add_attribute(attachment_context.object_attributes, "location", lstr_picked_assessment.location)
f_attribute_add_attribute(attachment_context.object_attributes, "leave_open", f_boolean_to_string(lstr_picked_assessment.leave_open))

display_attributes()

return 1


end function

public function integer pick_encounter ();str_popup popup
string ls_encounter_type

popup.data_row_count = 2
popup.items[1] = "PICK"
popup.items[2] = "D"

openwithparm(w_pick_encounter_type, popup)
ls_encounter_type = message.stringparm
if isnull(ls_encounter_type) then return 0

st_pick.text = datalist.encounter_type_description(ls_encounter_type)
mle_description.text = st_pick.text

attachment_context.object_attributes.attribute_count = 0
f_attribute_add_attribute(attachment_context.object_attributes, "encounter_type", ls_encounter_type)

display_attributes()

return 1


end function

public function integer order_encounter ();integer li_sts
long i
str_encounter_description lstr_encounter

lstr_encounter = f_empty_encounter()

lstr_encounter.encounter_type = attachment_context.context_object_type
if isnull(lstr_encounter.encounter_type) then
	openwithparm(w_pop_message, "Please select an encounter type")
	return 0
end if

lstr_encounter.encounter_date = begin_date
lstr_encounter.discharge_date = end_date
lstr_encounter.description = mle_description.text

lstr_encounter.encounter_id = current_patient.new_encounter(lstr_encounter, &
																				current_scribe.user_id, &
																				false)
if lstr_encounter.encounter_id <= 0 then
	log.log(this, "w_post_attachment_to_object.order_encounter:0021", "Could not create a new encounter", 4)
	return -1
end if



attachment_context.object_key = lstr_encounter.encounter_id
attachment_context.description = mle_description.text

return 1

end function

public function string get_context_object_type (boolean pb_initial);str_popup popup
str_popup_return popup_return
string ls_null

setnull(ls_null)

if len(attachment_context.folder) > 0 then
	// If the folder has more than one context_object_type, then ask the user which one to use
	popup.dataobject = "dw_sp_pick_folder_context_object_type"
	popup.datacolumn = 1
	popup.displaycolumn = 2
	popup.argument_count = 1
	popup.auto_singleton = true
	popup.argument[1] = attachment_context.folder
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return ls_null
	
	return popup_return.items[1]
else
	if pb_initial then
		return ls_null
	else
		return f_pick_context_object_type(attachment_context.context_object, attachment_context.description)
	end if
end if

end function

public subroutine display_attributes ();long i
long ll_row

dw_attributes.reset()

if attachment_context.object_attributes.attribute_count > 0 then
	for i = 1 to attachment_context.object_attributes.attribute_count
		ll_row = dw_attributes.insertrow(0)
		dw_attributes.object.attribute[ll_row] = attachment_context.object_attributes.attribute[i].attribute
		dw_attributes.object.value[ll_row] = attachment_context.object_attributes.attribute[i].value
		dw_attributes.object.attribute_description[ll_row] = sqlca.fn_attribute_description(attachment_context.object_attributes.attribute[i].attribute, attachment_context.object_attributes.attribute[i].value)
	next
	dw_attributes.visible = true
else
	dw_attributes.visible = false
end if

end subroutine

on w_post_attachment_to_object.create
int iCurrent
call super::create
this.dw_post_to=create dw_post_to
this.st_existing_title=create st_existing_title
this.st_page=create st_page
this.pb_up=create pb_up
this.pb_down=create pb_down
this.cb_post_existing=create cb_post_existing
this.cb_cancel=create cb_cancel
this.st_new_title=create st_new_title
this.st_begin_date_title=create st_begin_date_title
this.st_type_title=create st_type_title
this.st_end_date_title=create st_end_date_title
this.st_type=create st_type
this.st_begin_date=create st_begin_date
this.st_end_date=create st_end_date
this.st_description_title=create st_description_title
this.mle_description=create mle_description
this.cb_post_new=create cb_post_new
this.st_pick_title=create st_pick_title
this.st_pick=create st_pick
this.dw_attributes=create dw_attributes
this.st_show_open=create st_show_open
this.st_show_all=create st_show_all
this.st_1=create st_1
this.ln_1=create ln_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_post_to
this.Control[iCurrent+2]=this.st_existing_title
this.Control[iCurrent+3]=this.st_page
this.Control[iCurrent+4]=this.pb_up
this.Control[iCurrent+5]=this.pb_down
this.Control[iCurrent+6]=this.cb_post_existing
this.Control[iCurrent+7]=this.cb_cancel
this.Control[iCurrent+8]=this.st_new_title
this.Control[iCurrent+9]=this.st_begin_date_title
this.Control[iCurrent+10]=this.st_type_title
this.Control[iCurrent+11]=this.st_end_date_title
this.Control[iCurrent+12]=this.st_type
this.Control[iCurrent+13]=this.st_begin_date
this.Control[iCurrent+14]=this.st_end_date
this.Control[iCurrent+15]=this.st_description_title
this.Control[iCurrent+16]=this.mle_description
this.Control[iCurrent+17]=this.cb_post_new
this.Control[iCurrent+18]=this.st_pick_title
this.Control[iCurrent+19]=this.st_pick
this.Control[iCurrent+20]=this.dw_attributes
this.Control[iCurrent+21]=this.st_show_open
this.Control[iCurrent+22]=this.st_show_all
this.Control[iCurrent+23]=this.st_1
this.Control[iCurrent+24]=this.ln_1
end on

on w_post_attachment_to_object.destroy
call super::destroy
destroy(this.dw_post_to)
destroy(this.st_existing_title)
destroy(this.st_page)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.cb_post_existing)
destroy(this.cb_cancel)
destroy(this.st_new_title)
destroy(this.st_begin_date_title)
destroy(this.st_type_title)
destroy(this.st_end_date_title)
destroy(this.st_type)
destroy(this.st_begin_date)
destroy(this.st_end_date)
destroy(this.st_description_title)
destroy(this.mle_description)
destroy(this.cb_post_new)
destroy(this.st_pick_title)
destroy(this.st_pick)
destroy(this.dw_attributes)
destroy(this.st_show_open)
destroy(this.st_show_all)
destroy(this.st_1)
destroy(this.ln_1)
end on

event open;call super::open;integer li_sts
str_popup popup
str_popup_return popup_return
string ls_message

attachment_context = message.powerobjectparm

// First we need to determine the context object

// If one is passed in, then we're done here
if isnull(attachment_context.context_object) or trim(attachment_context.context_object) = "" then
	// Null out any context_object_type passed in because it can't be
	// valid without also passing in the context_object
	setnull(attachment_context.context_object_type)
	
	// If a context object is not passed in, then figure it out from the folder
	
	// Make sure we have a folder
	if isnull(attachment_context.folder) then
		log.log(this,"w_post_attachment_to_object:open","Null Folder",4)
		setnull(attachment_context.object_key)
		closewithreturn(this, attachment_context)
		Return
	end if
	
	// Make sure our folder exists and get its context info
	SELECT context_object
	INTO :attachment_context.context_object
	FROM c_Folder
	WHERE folder = :attachment_context.folder;
	if not tf_check() then
		log.log(this,"w_post_attachment_to_object:open","Error getting Folder",4)
		setnull(attachment_context.object_key)
		closewithreturn(this, attachment_context)
		Return
	end if
	if sqlca.sqlcode = 100 then
		log.log(this,"w_post_attachment_to_object:open","Folder not found (" + attachment_context.folder + ")",4)
		setnull(attachment_context.object_key)
		closewithreturn(this, attachment_context)
		Return
	end if
end if


postevent("post_open")

end event

type pb_epro_help from w_window_base`pb_epro_help within w_post_attachment_to_object
boolean visible = true
integer x = 2619
integer y = 1604
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_post_attachment_to_object
end type

type dw_post_to from u_dw_pick_list within w_post_attachment_to_object
integer x = 18
integer y = 132
integer width = 1216
integer height = 1272
integer taborder = 10
string dataobject = "dw_object_post_to_list"
boolean vscrollbar = true
boolean border = false
end type

type st_existing_title from statictext within w_post_attachment_to_object
integer x = 14
integer y = 36
integer width = 1303
integer height = 84
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 33538240
boolean enabled = false
string text = "Post To Existing Treatment"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_page from statictext within w_post_attachment_to_object
integer x = 1257
integer y = 396
integer width = 146
integer height = 124
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99/99"
boolean focusrectangle = false
end type

type pb_up from u_picture_button within w_post_attachment_to_object
integer x = 1253
integer y = 140
integer width = 137
integer height = 116
integer taborder = 40
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_post_to.current_page

dw_post_to.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_post_attachment_to_object
integer x = 1253
integer y = 264
integer width = 137
integer height = 116
integer taborder = 50
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_post_to.current_page
li_last_page = dw_post_to.last_page

dw_post_to.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true


end event

type cb_post_existing from commandbutton within w_post_attachment_to_object
integer x = 306
integer y = 1408
integer width = 672
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Post To Treatment"
end type

event clicked;long ll_row
integer li_sts
date ld_object_begin_date
date ld_context_begin_date
string ls_message
str_popup popup
str_popup_return popup_return
long ll_response

ll_row = dw_post_to.get_selected_row( )
if ll_row <= 0 then return


// Warn user if dates don't match
ld_object_begin_date = date(datetime(dw_post_to.object.begin_date[ll_row]))
ld_context_begin_date = date(begin_date)
if not attachment_context.posting_file and (ld_context_begin_date < relativedate(ld_object_begin_date, -3) or ld_context_begin_date > relativedate(ld_object_begin_date, 3)) then
	ls_message = "The date of the existing" 
	if len(attachment_context.context_object) > 0 then
		ls_message += " " + lower(attachment_context.context_object)
	else
		ls_message += " item"
	end if
	ls_message += " (" + string(ld_object_begin_date) + ")"
	ls_message += " is very different from the date of the"
	if len(attachment_context.context_object) > 0 then
		ls_message += " " + lower(attachment_context.context_object)
	else
		ls_message += " item"
	end if
	ls_message += " being posted (" + string(ld_context_begin_date) + ")."
	ls_message += "  It is recommended in this case to use ~"Post To New Treatment~" instead."
	ls_message += "  Are you sure you want to post this data to the selected"
	if len(attachment_context.context_object) > 0 then
		ls_message += " " + lower(attachment_context.context_object)
	else
		ls_message += " item"
	end if
	ls_message += "?"
	
	popup.title = ls_message
	popup.data_row_count = 3
	popup.items[1] = "Post To New Treatment"
	popup.items[2] = "Post To Existing Treatment"
	popup.items[3] = "Cancel"
	openwithparm(w_pop_choices_3, popup)
	ll_response = message.doubleparm
	if ll_response = 1 then
		cb_post_new.event post clicked()
		return
	elseif ll_response = 2 then
		attachment_context.object_key = dw_post_to.object.object_key[ll_row]
		attachment_context.description = dw_post_to.object.description[ll_row]
		attachment_context.new_object = false
		
		closewithreturn(parent, attachment_context)
		return
	else
		return
	end if
else
	attachment_context.object_key = dw_post_to.object.object_key[ll_row]
	attachment_context.description = dw_post_to.object.description[ll_row]
	attachment_context.new_object = false
	
	closewithreturn(parent, attachment_context)
end if


end event

type cb_cancel from commandbutton within w_post_attachment_to_object
integer x = 37
integer y = 1600
integer width = 494
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;
setnull(attachment_context.object_key)

closewithreturn(parent, attachment_context)



end event

type st_new_title from statictext within w_post_attachment_to_object
integer x = 1545
integer y = 36
integer width = 1303
integer height = 84
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 33538240
boolean enabled = false
string text = "Post To New Treatment"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_begin_date_title from statictext within w_post_attachment_to_object
integer x = 1573
integer y = 544
integer width = 480
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Begin Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_type_title from statictext within w_post_attachment_to_object
integer x = 1563
integer y = 196
integer width = 489
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Treatment Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_end_date_title from statictext within w_post_attachment_to_object
integer x = 1573
integer y = 692
integer width = 480
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "End Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_type from statictext within w_post_attachment_to_object
integer x = 2080
integer y = 176
integer width = 795
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_context_object_type
integer li_sts

ls_context_object_type = get_context_object_type(false)
if isnull(ls_context_object_type) then return

attachment_context.context_object_type = ls_context_object_type

li_sts = initialize()
if li_sts <= 0 then
	log.log(this,"w_post_attachment_to_object.st_type.clicked:0011","Initialize failed", 4)
	setnull(attachment_context.object_key)
	closewithreturn(parent, attachment_context)
	Return
End If



end event

type st_begin_date from statictext within w_post_attachment_to_object
integer x = 2080
integer y = 524
integer width = 590
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;date ld_date
time lt_encounter_time
string ls_text

ld_date = date(begin_date)

ls_text = f_select_date(ld_date, st_begin_date_title.text)
if isnull(ls_text) then return

if ld_date > today() then
	openwithparm(w_pop_message, "The begin date cannot be in the future")
	return
end if

if ld_date = today() then
	begin_date = datetime(ld_date, now())
else
	begin_date = datetime(ld_date)
end if
text = ls_text

end event

type st_end_date from statictext within w_post_attachment_to_object
integer x = 2080
integer y = 672
integer width = 590
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;date ld_date
time lt_encounter_time
string ls_text

if isnull(begin_date) then
	openwithparm(w_pop_message, "You must first specify a begin date")
	return
end if

ld_date = date(end_date)

ls_text = f_select_date(ld_date, st_begin_date_title.text)
if isnull(ls_text) then return

if ld_date < date(begin_date) then
	openwithparm(w_pop_message, "The end date cannot be before the begin date")
	return
end if
	
if ld_date > today() then
	openwithparm(w_pop_message, "The end date cannot be in the future")
	return
end if

if ld_date = today() then
	end_date = datetime(ld_date, now())
else
	end_date = datetime(ld_date)
end if

text = ls_text

end event

type st_description_title from statictext within w_post_attachment_to_object
integer x = 1563
integer y = 824
integer width = 480
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Description:"
boolean focusrectangle = false
end type

type mle_description from multilineedit within w_post_attachment_to_object
integer x = 1563
integer y = 888
integer width = 1294
integer height = 232
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autovscroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_post_new from commandbutton within w_post_attachment_to_object
integer x = 1856
integer y = 1408
integer width = 709
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Treatment"
end type

event clicked;integer li_sts
string ls_context_object_type

if isnull(attachment_context.context_object_type) then
	openwithparm(w_pop_message, "You must select a " + st_type_title.text)
	return
end if

if isnull(begin_date) then
	openwithparm(w_pop_message, "You must supply a begin date")
	return
end if

if isnull(mle_description.text) or trim(mle_description.text) = "" then
	openwithparm(w_pop_message, "You must supply a description")
	return
end if


CHOOSE CASE lower(attachment_context.context_object)
	CASE "encounter"
		li_sts = order_encounter()
	CASE "assessment"
		li_sts = order_assessment()
	CASE "treatment"
		li_sts = order_treatment()
END CHOOSE

if li_sts <= 0 then
	openwithparm(w_pop_message, "Error creating " + wordcap(attachment_context.context_object))
	return
end if

attachment_context.new_object = true

closewithreturn(parent, attachment_context)

end event

type st_pick_title from statictext within w_post_attachment_to_object
integer x = 1486
integer y = 344
integer width = 567
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Select Assessment:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_pick from statictext within w_post_attachment_to_object
integer x = 2080
integer y = 324
integer width = 795
integer height = 160
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;

CHOOSE CASE lower(attachment_context.context_object)
	CASE "encounter"
		pick_encounter()
	CASE "assessment"
		pick_assessment()
	CASE "treatment"
		pick_treatment()
END CHOOSE


end event

type dw_attributes from u_dw_pick_list within w_post_attachment_to_object
integer x = 1641
integer y = 1160
integer width = 1138
integer height = 216
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_generic_attribute_list_small"
boolean vscrollbar = true
end type

type st_show_open from statictext within w_post_attachment_to_object
integer x = 1248
integer y = 672
integer width = 174
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 400
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

event clicked;integer li_sts
string ls_preference_id

backcolor = color_object_selected
st_show_all.backcolor = color_object
open_only = true

ls_preference_id = "PostObject|" + attachment_context.context_object
if len(attachment_context.context_object_type) > 0 then
	ls_preference_id += "|" + attachment_context.context_object_type
end if
datalist.update_preference("PREFERENCES", "User", current_user.user_id, ls_preference_id, f_boolean_to_string(open_only))

li_sts = initialize()

end event

type st_show_all from statictext within w_post_attachment_to_object
integer x = 1248
integer y = 784
integer width = 174
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 400
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

event clicked;integer li_sts
string ls_preference_id

backcolor = color_object_selected
st_show_open.backcolor = color_object
open_only = false

ls_preference_id = "PostObject|" + attachment_context.context_object
if len(attachment_context.context_object_type) > 0 then
	ls_preference_id += "|" + attachment_context.context_object_type
end if
datalist.update_preference("PREFERENCES", "User", current_user.user_id, ls_preference_id, f_boolean_to_string(open_only))

li_sts = initialize()

end event

type st_1 from statictext within w_post_attachment_to_object
integer x = 1243
integer y = 600
integer width = 187
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33536444
string text = "Show"
alignment alignment = center!
boolean focusrectangle = false
end type

type ln_1 from line within w_post_attachment_to_object
integer linethickness = 6
integer beginx = 1435
integer beginy = 28
integer endx = 1435
integer endy = 1556
end type

