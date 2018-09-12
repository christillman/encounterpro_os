$PBExportHeader$w_svc_refer_treatment.srw
forward
global type w_svc_refer_treatment from w_observation_base
end type
type st_title from statictext within w_svc_refer_treatment
end type
type cb_finished from commandbutton within w_svc_refer_treatment
end type
type cb_be_back from commandbutton within w_svc_refer_treatment
end type
type st_treatment_type_title from statictext within w_svc_refer_treatment
end type
type st_treatment_description_title from statictext within w_svc_refer_treatment
end type
type st_treatment_type from statictext within w_svc_refer_treatment
end type
type st_treatment_description from statictext within w_svc_refer_treatment
end type
type st_refer_to_title from statictext within w_svc_refer_treatment
end type
type st_authority_title from statictext within w_svc_refer_treatment
end type
type dw_consultants from u_dw_pick_list within w_svc_refer_treatment
end type
type st_authority from statictext within w_svc_refer_treatment
end type
type st_page from statictext within w_svc_refer_treatment
end type
type pb_up from picturebutton within w_svc_refer_treatment
end type
type pb_down from picturebutton within w_svc_refer_treatment
end type
type cb_choose_authority from commandbutton within w_svc_refer_treatment
end type
type cb_1 from commandbutton within w_svc_refer_treatment
end type
type st_formulary_title from statictext within w_svc_refer_treatment
end type
type st_formulary from statictext within w_svc_refer_treatment
end type
type st_billing_title from statictext within w_svc_refer_treatment
end type
type st_collection_title from statictext within w_svc_refer_treatment
end type
type st_perform_title from statictext within w_svc_refer_treatment
end type
type st_bill_collection from statictext within w_svc_refer_treatment
end type
type st_bill_perform from statictext within w_svc_refer_treatment
end type
type pb_view_formulary from picturebutton within w_svc_refer_treatment
end type
type st_specimen_id_title from statictext within w_svc_refer_treatment
end type
type sle_specimen_id from singlelineedit within w_svc_refer_treatment
end type
type st_specimen_id_reader from statictext within w_svc_refer_treatment
end type
end forward

global type w_svc_refer_treatment from w_observation_base
integer height = 1840
boolean controlmenu = false
windowtype windowtype = response!
string button_type = "COMMAND"
integer max_buttons = 3
st_title st_title
cb_finished cb_finished
cb_be_back cb_be_back
st_treatment_type_title st_treatment_type_title
st_treatment_description_title st_treatment_description_title
st_treatment_type st_treatment_type
st_treatment_description st_treatment_description
st_refer_to_title st_refer_to_title
st_authority_title st_authority_title
dw_consultants dw_consultants
st_authority st_authority
st_page st_page
pb_up pb_up
pb_down pb_down
cb_choose_authority cb_choose_authority
cb_1 cb_1
st_formulary_title st_formulary_title
st_formulary st_formulary
st_billing_title st_billing_title
st_collection_title st_collection_title
st_perform_title st_perform_title
st_bill_collection st_bill_collection
st_bill_perform st_bill_perform
pb_view_formulary pb_view_formulary
st_specimen_id_title st_specimen_id_title
sle_specimen_id sle_specimen_id
st_specimen_id_reader st_specimen_id_reader
end type
global w_svc_refer_treatment w_svc_refer_treatment

type variables
u_component_service service

string consultant_id
string specialty_id
string authority_id
string progress_key

u_ds_data patient_authorities
u_ds_data authority_treatment_formulary

boolean bill_collection = false
boolean bill_perform = false

u_component_observation specimen_id_reader


end variables

forward prototypes
public function integer set_authority (string ps_authority_id)
public function integer set_billing ()
public function integer save_changes ()
end prototypes

public function integer set_authority (string ps_authority_id);long ll_row
string ls_find
long ll_rows

if isnull(ps_authority_id) then
	ll_row = 0
else
	ls_find = "authority_id='" + ps_authority_id + "'"
	ll_row = patient_authorities.find(ls_find, 1, patient_authorities.rowcount())
end if

if ll_row > 0 then
	authority_id = ps_authority_id
	st_authority.text = patient_authorities.object.authority_name[ll_row]
	dw_consultants.settransobject(sqlca)
	dw_consultants.retrieve(authority_id, specialty_id)
else
	setnull(authority_id)
	st_authority.text = "<None>"
	dw_consultants.reset()
end if

dw_consultants.set_page(1, pb_up, pb_down, st_page)

// Set the formulary
if isnull(authority_id) then
	ll_rows = 0
else
	authority_treatment_formulary.set_dataobject("dw_sp_authority_treatment_formulary")
	ll_rows = authority_treatment_formulary.retrieve(current_patient.cpr_id, service.treatment.treatment_id, authority_id)
end if

if ll_rows > 0 then
	st_formulary.text = authority_treatment_formulary.object.description[1]
	pb_view_formulary.picturename = authority_treatment_formulary.object.button[1]
	st_formulary_title.visible = true
	st_formulary.visible = true
	pb_view_formulary.visible = true
else
	st_formulary_title.visible = false
	st_formulary.visible = false
	pb_view_formulary.visible = false
end if		


return 1


end function

public function integer set_billing ();long ll_problem_id
string ls_bill_flag
integer li_bill_observation_collect
integer li_bill_observation_perform

setnull(ll_problem_id)

if st_collection_title.text = "Bill Procedure" then
	// we're using the bill_collection flag to control the billing of treatments
	// with procedure id's and not observation_id's.
	if bill_collection then
		ls_bill_flag = "Y"
	else
		ls_bill_flag = "N"
	end if
	
	sqlca.sp_set_treatment_billing(current_patient.cpr_id, &
											service.encounter_id, &
											ll_problem_id, &
											service.treatment.treatment_id, &
											"PROCEDURE", &
											ls_bill_flag, &
											current_scribe.user_id )
	
	if not tf_check() then return -1
elseif st_bill_collection.visible then
	// This is an observation treatment so bill the collect and perform procedures
	
	// First the collect procedure
	if bill_collection then
		li_bill_observation_collect = 1
	else
		li_bill_observation_collect = 0
	end if

	// Then the perform procedure
	if bill_perform then
		li_bill_observation_perform = 1
	else
		li_bill_observation_perform = 0
	end if

	UPDATE p_Treatment_Item
	SET bill_observation_collect = :li_bill_observation_collect,
			bill_observation_perform = :li_bill_observation_perform
	WHERE cpr_id = :current_patient.cpr_id
	AND treatment_id = :service.treatment.treatment_id;
	if not tf_check() then return -1

	sqlca.jmj_set_treatment_observation_billing(current_patient.cpr_id, &
															service.encounter_id, &
															service.treatment.treatment_id, &
															current_scribe.user_id )
	if not tf_check() then return -1
end if


return 1

end function

public function integer save_changes ();str_popup_return popup_return
integer li_sts
string ls_description

if len(trim(sle_specimen_id.text)) > 0 then
	service.treatment.specimen_id = sle_specimen_id.text
	current_patient.treatments.modify_treatment(service.treatment.treatment_id, "specimen_id", sle_specimen_id.text)
end if

li_sts = set_billing()
if li_sts < 0 then
	openwithparm(w_pop_message, "Setting the billing failed")
	return -1
end if

if not isnull(consultant_id) then
	ls_description = datalist.consultant_description(consultant_id)
	current_patient.treatments.set_treatment_progress(service.treatment.treatment_id, &
																		"Property", &
																		progress_key, &
																		ls_description)
	
	current_patient.treatments.set_treatment_progress(service.treatment.treatment_id, &
																		"Property", &
																		"consultant_id", &
																		string(consultant_id))
end if

return 1

end function

event open;call super::open;long ll_menu_id
long ll_rows
str_popup_return popup_return
string ls_null
long ll_property_id
integer li_bill_observation_collect
integer li_bill_observation_perform

setnull(ls_null)

popup_return.item_count = 1
popup_return.items[1] = "ERROR"

service = message.powerobjectparm
if isnull(service.treatment) then
	log.log(this, "w_svc_refer_treatment:open", "No treatment object", 4)
	closewithreturn(this, popup_return)
	return
end if

progress_key = service.get_attribute("progress_key")
if isnull(progress_key) then progress_key = "Referred To"

// Set the title and sizes
title = current_patient.id_line()

st_treatment_type.text = datalist.treatment_type_description(service.treatment.treatment_type)
st_treatment_description.text = service.treatment.treatment_description
specialty_id = datalist.treatment_type_referral_specialty_id(service.treatment.treatment_type)

if len(st_title.text) > 42 then
	if len(st_title.text) > 60 then
		if len(st_title.text) > 70 then
			st_title.textsize = -10
		else
			st_title.textsize = -12
		end if
	else
		st_title.textsize = -14
	end if
else
	st_title.textsize = -18
end if

// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 4
end if

ll_menu_id = long(service.get_attribute("menu_id"))
if not isnull(ll_menu_id) then paint_menu(ll_menu_id)

patient_authorities = CREATE u_ds_data
authority_treatment_formulary = CREATE u_ds_data


setnull(authority_id)
setnull(consultant_id)

patient_authorities.set_dataobject("dw_p_patient_authority")
ll_rows = patient_authorities.retrieve(current_patient.cpr_id)
if ll_rows > 0 then
	set_authority(patient_authorities.object.authority_id[1])
	if ll_rows > 1 then
		cb_choose_authority.visible = true
	else
		cb_choose_authority.visible = false
	end if
else
	set_authority(ls_null)
	cb_choose_authority.visible = false
end if

if len(service.treatment.specimen_id) > 0 then
	sle_specimen_id.text = service.treatment.specimen_id
end if

if isnull(service.treatment.procedure_id) then
	if isnull(service.treatment.observation_id) then
		st_billing_title.visible = false
		st_collection_title.visible = false
		st_perform_title.visible = false
		st_bill_collection.visible = false
		st_bill_perform.visible = false
	else
		SELECT bill_observation_collect, bill_observation_perform
		INTO :li_bill_observation_collect, :li_bill_observation_perform
		FROM p_Treatment_Item
		WHERE cpr_id = :current_patient.cpr_id
		AND treatment_id = :service.treatment.treatment_id;
		if not tf_check() then return -1
		
		if li_bill_observation_collect = 0 then
			bill_collection = false
			st_bill_collection.text = "No"
		else
			bill_collection = true
			st_bill_collection.text = "Yes"
		end if

		if li_bill_observation_perform = 0 then
			bill_perform = false
			st_bill_perform.text = "No"
		else
			bill_perform = true
			st_bill_perform.text = "Yes"
		end if
	end if
else
	st_perform_title.visible = false
	st_bill_perform.visible = false
	st_collection_title.text = "Bill Procedure"
end if

postevent("post_open")

end event

on w_svc_refer_treatment.create
int iCurrent
call super::create
this.st_title=create st_title
this.cb_finished=create cb_finished
this.cb_be_back=create cb_be_back
this.st_treatment_type_title=create st_treatment_type_title
this.st_treatment_description_title=create st_treatment_description_title
this.st_treatment_type=create st_treatment_type
this.st_treatment_description=create st_treatment_description
this.st_refer_to_title=create st_refer_to_title
this.st_authority_title=create st_authority_title
this.dw_consultants=create dw_consultants
this.st_authority=create st_authority
this.st_page=create st_page
this.pb_up=create pb_up
this.pb_down=create pb_down
this.cb_choose_authority=create cb_choose_authority
this.cb_1=create cb_1
this.st_formulary_title=create st_formulary_title
this.st_formulary=create st_formulary
this.st_billing_title=create st_billing_title
this.st_collection_title=create st_collection_title
this.st_perform_title=create st_perform_title
this.st_bill_collection=create st_bill_collection
this.st_bill_perform=create st_bill_perform
this.pb_view_formulary=create pb_view_formulary
this.st_specimen_id_title=create st_specimen_id_title
this.sle_specimen_id=create sle_specimen_id
this.st_specimen_id_reader=create st_specimen_id_reader
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.cb_finished
this.Control[iCurrent+3]=this.cb_be_back
this.Control[iCurrent+4]=this.st_treatment_type_title
this.Control[iCurrent+5]=this.st_treatment_description_title
this.Control[iCurrent+6]=this.st_treatment_type
this.Control[iCurrent+7]=this.st_treatment_description
this.Control[iCurrent+8]=this.st_refer_to_title
this.Control[iCurrent+9]=this.st_authority_title
this.Control[iCurrent+10]=this.dw_consultants
this.Control[iCurrent+11]=this.st_authority
this.Control[iCurrent+12]=this.st_page
this.Control[iCurrent+13]=this.pb_up
this.Control[iCurrent+14]=this.pb_down
this.Control[iCurrent+15]=this.cb_choose_authority
this.Control[iCurrent+16]=this.cb_1
this.Control[iCurrent+17]=this.st_formulary_title
this.Control[iCurrent+18]=this.st_formulary
this.Control[iCurrent+19]=this.st_billing_title
this.Control[iCurrent+20]=this.st_collection_title
this.Control[iCurrent+21]=this.st_perform_title
this.Control[iCurrent+22]=this.st_bill_collection
this.Control[iCurrent+23]=this.st_bill_perform
this.Control[iCurrent+24]=this.pb_view_formulary
this.Control[iCurrent+25]=this.st_specimen_id_title
this.Control[iCurrent+26]=this.sle_specimen_id
this.Control[iCurrent+27]=this.st_specimen_id_reader
end on

on w_svc_refer_treatment.destroy
call super::destroy
destroy(this.st_title)
destroy(this.cb_finished)
destroy(this.cb_be_back)
destroy(this.st_treatment_type_title)
destroy(this.st_treatment_description_title)
destroy(this.st_treatment_type)
destroy(this.st_treatment_description)
destroy(this.st_refer_to_title)
destroy(this.st_authority_title)
destroy(this.dw_consultants)
destroy(this.st_authority)
destroy(this.st_page)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.cb_choose_authority)
destroy(this.cb_1)
destroy(this.st_formulary_title)
destroy(this.st_formulary)
destroy(this.st_billing_title)
destroy(this.st_collection_title)
destroy(this.st_perform_title)
destroy(this.st_bill_collection)
destroy(this.st_bill_perform)
destroy(this.pb_view_formulary)
destroy(this.st_specimen_id_title)
destroy(this.sle_specimen_id)
destroy(this.st_specimen_id_reader)
end on

event post_open;call super::post_open;long i
str_external_sources lstr_sources
string ls_null
string ls_external_source_type
setnull(ls_null)
str_attributes lstr_attributes
string ls_specimen_id

ls_external_source_type = service.get_attribute("external_source_type")
if isnull(ls_external_source_type) then ls_external_source_type = "Bar Code Reader"

lstr_sources = common_thread.get_external_sources(ls_external_source_type)

// If there's more than one, just use the first one
if lstr_sources.external_source_count > 0 then
	f_attribute_add_attribute(lstr_attributes, "external_source", lstr_sources.external_source[1].external_source)
	
	specimen_id_reader = component_manager.get_component(lstr_sources.external_source[1].component_id, lstr_attributes)
	if isnull(specimen_id_reader) then
		st_specimen_id_reader.visible = false
	else
		// We have a source in hand, so set it's display_window to this window
		specimen_id_reader.display_window = this
		st_specimen_id_reader.text = lstr_sources.external_source[1].description
		st_specimen_id_reader.visible = true
	end if
else
	st_specimen_id_reader.visible = false
end if

return 0


end event

event source_connected;call super::source_connected;st_specimen_id_reader.textcolor = rgb(64,255,64)


end event

event source_disconnected;call super::source_disconnected;st_specimen_id_reader.textcolor = rgb(255,0,0)

end event

event close;call super::close;
if not isnull(specimen_id_reader) then
	component_manager.destroy_component(specimen_id_reader)
end if

end event

event results_posted;call super::results_posted;
if puo_observation.observation_count > 0 then
	if puo_observation.observations[1].result_count > 0 then
		sle_specimen_id.text = puo_observation.observations[1].result[1].result_value
	end if
end if

end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_refer_treatment
boolean visible = true
integer taborder = 20
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_refer_treatment
end type

type st_title from statictext within w_svc_refer_treatment
integer width = 2898
integer height = 132
integer textsize = -22
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Refer Patient For Treatment"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_finished from commandbutton within w_svc_refer_treatment
integer x = 2427
integer y = 1620
integer width = 443
integer height = 108
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;str_popup_return popup_return
integer li_sts

li_sts = save_changes()
if li_sts <= 0 then return

if isnull(consultant_id) then
	openwithparm(w_pop_yes_no, "Do you wish to exit without selecting a consultant?")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return
end if

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type cb_be_back from commandbutton within w_svc_refer_treatment
integer x = 1961
integer y = 1620
integer width = 443
integer height = 108
integer taborder = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
end type

event clicked;str_popup_return popup_return

integer li_sts

li_sts = save_changes()
if li_sts <= 0 then return

popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type st_treatment_type_title from statictext within w_svc_refer_treatment
integer x = 288
integer y = 244
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

type st_treatment_description_title from statictext within w_svc_refer_treatment
integer x = 288
integer y = 380
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
string text = "Treatment:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_treatment_type from statictext within w_svc_refer_treatment
integer x = 805
integer y = 232
integer width = 1093
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type st_treatment_description from statictext within w_svc_refer_treatment
integer x = 805
integer y = 380
integer width = 1824
integer height = 148
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type st_refer_to_title from statictext within w_svc_refer_treatment
integer x = 123
integer y = 836
integer width = 1248
integer height = 92
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Refer To"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_authority_title from statictext within w_svc_refer_treatment
integer x = 288
integer y = 596
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
string text = "Authority:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_consultants from u_dw_pick_list within w_svc_refer_treatment
integer x = 123
integer y = 920
integer width = 1239
integer height = 540
integer taborder = 50
boolean bringtotop = true
string dataobject = "dw_authority_preferred_consultants"
boolean vscrollbar = true
boolean border = false
end type

event unselected;call super::unselected;setnull(consultant_id)

end event

event selected;call super::selected;consultant_id = object.consultant_id[selected_row]

end event

type st_authority from statictext within w_svc_refer_treatment
integer x = 805
integer y = 584
integer width = 1093
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "<None>"
boolean border = true
boolean focusrectangle = false
end type

type st_page from statictext within w_svc_refer_treatment
integer x = 1371
integer y = 1176
integer width = 256
integer height = 56
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "99 of 99"
boolean focusrectangle = false
end type

type pb_up from picturebutton within w_svc_refer_treatment
integer x = 1362
integer y = 928
integer width = 137
integer height = 116
integer taborder = 30
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;integer li_page

li_page = dw_consultants.current_page

dw_consultants.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from picturebutton within w_svc_refer_treatment
integer x = 1362
integer y = 1052
integer width = 137
integer height = 116
integer taborder = 60
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_consultants.current_page
li_last_page = dw_consultants.last_page

dw_consultants.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type cb_choose_authority from commandbutton within w_svc_refer_treatment
integer x = 1906
integer y = 584
integer width = 133
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ". . ."
end type

event clicked;str_popup popup
str_popup_return popup_return
integer li_sts
string ls_button
long ll_row
integer i
string ls_null

setnull(ls_null)

popup.data_row_count = patient_authorities.rowcount()

for i = 1 to popup.data_row_count
	popup.items[i] = patient_authorities.object.authority_name[i]
next
popup.data_row_count += 1
popup.items[popup.data_row_count] = "<None>"
	
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ll_row = popup_return.item_indexes[1]

if ll_row = popup.data_row_count then
	set_authority(ls_null)
else
	set_authority(patient_authorities.object.authority_id[ll_row])
end if

end event

type cb_1 from commandbutton within w_svc_refer_treatment
integer x = 809
integer y = 1476
integer width = 539
integer height = 84
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select Other Consultant"
end type

event clicked;string ls_find
long ll_row
str_pick_users lstr_pick_users
integer li_sts

lstr_pick_users.hide_users = true
lstr_pick_users.cpr_id = service.cpr_id
lstr_pick_users.actor_class = "Consultant"
lstr_pick_users.specialty_id = specialty_id
lstr_pick_users.pick_screen_title = "Select Refer-To Provider"

li_sts = user_list.pick_users(lstr_pick_users)
if lstr_pick_users.selected_users.user_count < 1 then return

consultant_id = lstr_pick_users.selected_users.user[1].user_id

dw_consultants.clear_selected()

// See if the consultant is already in the list
ls_find = "consultant_id='" + consultant_id + "'"
ll_row = dw_consultants.find(ls_find, 1, dw_consultants.rowcount())
if ll_row <= 0 then
	ll_row = dw_consultants.insertrow(1)
	dw_consultants.object.consultant_id[ll_row] = consultant_id
	dw_consultants.object.description[ll_row] = lstr_pick_users.selected_users.user[1].user_full_name
end if

dw_consultants.object.selected_flag[ll_row] = 1

dw_consultants.set_page(1, pb_up, pb_down, st_page)


end event

type st_formulary_title from statictext within w_svc_refer_treatment
integer x = 288
integer y = 712
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
string text = "Formulary:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_formulary from statictext within w_svc_refer_treatment
integer x = 805
integer y = 708
integer width = 1838
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "<None>"
boolean border = true
boolean focusrectangle = false
end type

type st_billing_title from statictext within w_svc_refer_treatment
integer x = 1682
integer y = 860
integer width = 955
integer height = 100
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 33538240
string text = "Billing"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_collection_title from statictext within w_svc_refer_treatment
integer x = 1637
integer y = 1048
integer width = 608
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Bill Collection Code:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_perform_title from statictext within w_svc_refer_treatment
integer x = 1637
integer y = 1212
integer width = 608
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Bill Perform Code:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_bill_collection from statictext within w_svc_refer_treatment
integer x = 2272
integer y = 1032
integer width = 402
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if bill_collection then
	bill_collection = false
	text = "No"
else
	bill_collection = true
	text = "Yes"
end if


end event

type st_bill_perform from statictext within w_svc_refer_treatment
integer x = 2272
integer y = 1196
integer width = 402
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if bill_perform then
	bill_perform = false
	text = "No"
else
	bill_perform = true
	text = "Yes"
end if


end event

type pb_view_formulary from picturebutton within w_svc_refer_treatment
integer x = 2661
integer y = 688
integer width = 151
integer height = 112
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
end type

type st_specimen_id_title from statictext within w_svc_refer_treatment
integer x = 1435
integer y = 1404
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Specimen ID:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_specimen_id from singlelineedit within w_svc_refer_treatment
integer x = 1847
integer y = 1392
integer width = 987
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_specimen_id_reader from statictext within w_svc_refer_treatment
integer x = 1847
integer y = 1496
integer width = 987
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Bar Code Reader"
alignment alignment = center!
boolean focusrectangle = false
end type

