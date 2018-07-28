HA$PBExportHeader$w_do_treatment_old.srw
forward
global type w_do_treatment_old from w_window_base
end type
type cb_done from commandbutton within w_do_treatment_old
end type
type cb_be_back from commandbutton within w_do_treatment_old
end type
type st_perform_service from statictext within w_do_treatment_old
end type
type tab_properties from tab within w_do_treatment_old
end type
type tabpage_treatment from u_treatment_results within tab_properties
end type
type tabpage_treatment from u_treatment_results within tab_properties
end type
type tabpage_followup from u_treatment_followups within tab_properties
end type
type tabpage_followup from u_treatment_followups within tab_properties
end type
type tabpage_assessments from u_treatment_assessments within tab_properties
end type
type tabpage_assessments from u_treatment_assessments within tab_properties
end type
type tabpage_workplan from u_treatment_workplans within tab_properties
end type
type tabpage_workplan from u_treatment_workplans within tab_properties
end type
type tabpage_attachments from u_treatment_attachments within tab_properties
end type
type tabpage_attachments from u_treatment_attachments within tab_properties
end type
type tabpage_billing from u_treatment_billing within tab_properties
end type
type tabpage_billing from u_treatment_billing within tab_properties
end type
type tabpage_properties from u_context_object_properties within tab_properties
end type
type tabpage_properties from u_context_object_properties within tab_properties
end type
type tab_properties from tab within w_do_treatment_old
tabpage_treatment tabpage_treatment
tabpage_followup tabpage_followup
tabpage_assessments tabpage_assessments
tabpage_workplan tabpage_workplan
tabpage_attachments tabpage_attachments
tabpage_billing tabpage_billing
tabpage_properties tabpage_properties
end type
type ln_services from line within w_do_treatment_old
end type
type st_order_service from statictext within w_do_treatment_old
end type
end forward

global type w_do_treatment_old from w_window_base
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean nested_user_object_resize = false
cb_done cb_done
cb_be_back cb_be_back
st_perform_service st_perform_service
tab_properties tab_properties
ln_services ln_services
st_order_service st_order_service
end type
global w_do_treatment_old w_do_treatment_old

type variables
u_component_service service
u_component_treatment treatment


long menu_id

end variables

forward prototypes
public subroutine refresh_tab ()
public subroutine refresh_tab (integer pi_tab)
public function integer display_manual_services ()
public function integer initialize ()
public function integer button_pressed (integer pi_button_index)
public function integer paint_buttons ()
public function integer display_ordered_services ()
end prototypes

public subroutine refresh_tab ();if tab_properties.selectedtab > 0 then refresh_tab(tab_properties.selectedtab)

end subroutine

public subroutine refresh_tab (integer pi_tab);long ll_count

if isnull(pi_tab) or pi_tab <= 0 then return


CHOOSE CASE tab_properties.control[pi_tab].tag
	CASE "TREATMENT"
//		tab_properties.tabpage_treatment.display_treatment()
	CASE "FOLLOWUP"
		tab_properties.tabpage_followup.display_followups()
	CASE "ASSESSMENT"
		tab_properties.tabpage_assessments.display_assessments()
	CASE "WORKPLAN"
		tab_properties.tabpage_workplan.display_workplans()
//	CASE "ATTACHMENT"
//		tab_properties.tabpage_attachments.display_attachments()
	CASE "BILLING"
		tab_properties.tabpage_billing.display_billing()
	CASE "PROPERTIES"
		tab_properties.tabpage_properties.display_properties()
END CHOOSE

// Always update the attachments tab
ll_count = tab_properties.tabpage_attachments.display_attachments()

return


end subroutine

public function integer display_manual_services ();u_ds_data luo_services
long ll_count
string ls_button
string ls_help
string ls_title
long i
integer li_sts
string ls_temp
long ll_button_count
string ls_service

ll_button_count = 0
			
// Display the services permanently associated with this treatment type
If NOT current_patient.display_only AND NOT isnull(current_patient.open_encounter) THEN
	luo_services = CREATE u_ds_data
	
	if isnull(treatment.end_date) then
		luo_services.set_dataobject("dw_do_treatment_before_services")
	else
		luo_services.set_dataobject("dw_do_treatment_after_services")
	end if
	ll_count = luo_services.retrieve(treatment.treatment_type)
	
	for i = 1 to ll_count
		ls_service = luo_services.object.service[i]
		if not isnull(ls_service) then
			if not current_user.check_service(ls_service) then continue
		end if
		ll_button_count += 1
		ls_button = luo_services.object.button[i]
		ls_help = luo_services.object.button_help[i]
		ls_title = luo_services.object.button_title[i]
		li_sts = add_button(ls_button, ls_title, ls_help, "SERVICE", string(luo_services.object.service_sequence[i]))
	next

	DESTROY luo_services
End If

return ll_button_count

end function

public function integer initialize ();integer li_sts
integer li_count
string ls_flag
string ls_null
string ls_temp
string ls_button
string ls_help
string ls_title
string ls_observation_type
integer i

setnull(ls_null)

button_count = 0

// Display buttons
paint_buttons()

// Check presence of treatment workplan
SELECT count(*)
INTO :li_count
FROM p_Patient_WP
WHERE cpr_id = :current_patient.cpr_id
AND treatment_id = :treatment.treatment_id;
if not tf_check() then return -1

tab_properties.width = width - 30
tab_properties.height = button_top - 52

ls_flag = datalist.treatment_type_followup_flag(treatment.treatment_type)
if ls_flag = "F" then
	tab_properties.tabpage_followup.visible = true
	tab_properties.tabpage_followup.text = "Followup"
elseif ls_flag = "R" then
	tab_properties.tabpage_followup.visible = true
	tab_properties.tabpage_followup.text = "Referral"
else
	tab_properties.tabpage_followup.visible = false
end if
	
if li_count > 0 then
	tab_properties.tabpage_workplan.visible = true
else
	tab_properties.tabpage_workplan.visible = false
end if

//tab_properties.tabpage_treatment.initialize(treatment)
tab_properties.tabpage_followup.initialize(treatment)
tab_properties.tabpage_assessments.initialize(treatment)
tab_properties.tabpage_workplan.initialize(treatment)
tab_properties.tabpage_attachments.initialize("treatment",treatment.treatment_id)
tab_properties.tabpage_properties.initialize("treatment",treatment.treatment_id)

if isnull(current_display_encounter) then
	tab_properties.tabpage_billing.visible = false
else
	tab_properties.tabpage_billing.initialize(treatment)
end if


state_attributes.attribute_count = 1
state_attributes.attribute[1].attribute = "treatment_id"
state_attributes.attribute[1].value = string(treatment.treatment_id)


return 1

end function

public function integer button_pressed (integer pi_button_index);str_popup_return popup_return
long ll_service_sequence
str_attributes lstr_attributes
string ls_attribute
string ls_value
integer li_sts
string ls_service
string ls_observation_tag
long ll_patient_workplan_item_id

DECLARE lsp_get_treatment_service_attributes PROCEDURE FOR dbo.sp_get_treatment_service_attributes
		@ps_treatment_type = :treatment.treatment_type,
		@pl_service_sequence = :ll_service_sequence ;


lstr_attributes = state_attributes

CHOOSE CASE upper(buttons.button[pi_button_index].action)
	CASE "WPITEM"
		ll_patient_workplan_item_id = long(buttons.button[pi_button_index].argument)
		li_sts = service_list.do_service(ll_patient_workplan_item_id, treatment)

	CASE "SERVICE"
		ll_service_sequence = long(buttons.button[pi_button_index].argument)

		SELECT service, observation_tag
		INTO :ls_service, :ls_observation_tag
		FROM c_Treatment_Type_Service
		WHERE treatment_type = :treatment.treatment_type
		AND service_sequence = :ll_service_sequence;
		if not tf_check() then return -1
		if sqlca.sqlcode = 100 then
			log.log(this, "button_pressed", "invalid service_sequence (" + string(ll_service_sequence) + ")", 4)
			return -1
		end if
		
		EXECUTE lsp_get_treatment_service_attributes;
		if not tf_check() then return -1
		
		FETCH lsp_get_treatment_service_attributes INTO :ls_attribute,:ls_value;
		if not tf_check() then return -1

		Do While Sqlca.Sqlcode = 0
			lstr_attributes.attribute_count++
			lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = ls_attribute
			lstr_attributes.attribute[lstr_attributes.attribute_count].value = ls_value
			FETCH lsp_get_treatment_service_attributes INTO :ls_attribute,:ls_value;
			if not tf_check() then return -1
		Loop
		CLOSE lsp_get_treatment_service_attributes;
		
		// Add the observation_tag to the attributes if it's not null
		if not isnull(ls_observation_tag) then
			lstr_attributes.attribute_count++
			lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = "observation_tag"
			lstr_attributes.attribute[lstr_attributes.attribute_count].value = ls_observation_tag
		end if
			

		li_sts = service_list.do_service(current_patient.cpr_id, &
													current_patient.open_encounter_id, &
													ls_service, &
													treatment, &
													lstr_attributes)
END CHOOSE

refresh_tab()

paint_buttons()

Return 1
end function

public function integer paint_buttons ();integer i
integer li_sts
long ll_perform_buttons

for i = 1 to button_count
	closeuserobject(pbuttons[i])
	closeuserobject(titles[i])
next

// Reset counters
button_count = 0
buttons.button_count = 0

// Reset labels
st_perform_service.visible = false
st_order_service.visible = false
ln_services.visible = false

li_sts = display_ordered_services()
if li_sts < 0 then return -1

ll_perform_buttons = button_count

if ll_perform_buttons > 0 then
	// Make the "Perform" title visible
	st_perform_service.x = spacing + 4
	st_perform_service.y = button_top - st_perform_service.height
	st_perform_service.visible = true
	
	// Make the delimiter bar visible
	ln_services.beginx = pbuttons[button_count].x + button_width + (spacing / 2)
	ln_services.endx = ln_services.beginx
	ln_services.beginy = st_perform_service.y
	ln_services.endy = titles[button_count].y + titles[button_count].height
	ln_services.visible = true
end if

li_sts = display_manual_services()
if li_sts < 0 then return -1

if button_count > ll_perform_buttons then
	st_order_service.x = pbuttons[ll_perform_buttons + 1].x + 4
	st_order_service.visible = true
	st_order_service.y = button_top - st_order_service.height
end if

return 1

end function

public function integer display_ordered_services ();u_ds_data luo_services
u_ds_data luo_locked_services
long ll_count
string ls_button
string ls_help
string ls_title
string ls_service
long i
integer li_sts
string ls_temp,ls_ordered_service
long ll_button_count
long ll_patient_workplan_item_id
long ll_locked_count
string ls_find
long ll_row

ll_button_count = 0

// Display the services already ordered and dispatched for this treatment
If NOT current_patient.display_only AND NOT isnull(current_patient.open_encounter) THEN
	luo_services = CREATE u_ds_data
	luo_locked_services = CREATE u_ds_data
	
	luo_services.set_dataobject("dw_do_treatment_items")
	ll_count = luo_services.retrieve(current_patient.cpr_id, treatment.treatment_id)
	
	luo_locked_services.set_dataobject("dw_o_user_service_lock_mine")
	ll_locked_count = luo_locked_services.retrieve(current_scribe.user_id, computer_id)
	
	for i = 1 to ll_count
		ls_service = luo_services.object.ordered_service[i]
		if not isnull(ls_service) then
			if not current_user.check_service(ls_service) then continue
		end if
		
		// Don't display a button for the current active service
		ll_patient_workplan_item_id = luo_services.object.patient_workplan_item_id[i]
		ls_ordered_service = luo_services.object.ordered_service[i]
		
		// Make sure the service isn't already locked by me
		ls_find = "patient_workplan_item_id=" + string(ll_patient_workplan_item_id)
		ll_row = luo_locked_services.find(ls_find, 1, ll_locked_count)
		if ll_row > 0 then continue
		
		ll_button_count += 1
		ls_button = luo_services.object.button[i]
		ls_help = luo_services.object.description[i]
		ls_title = luo_services.object.service_description[i]
		li_sts = add_button(ls_button, ls_title, ls_help, "WPITEM", string(ll_patient_workplan_item_id))
	next

	DESTROY luo_services
	DESTROY luo_locked_services
End If


return ll_button_count

end function

on w_do_treatment_old.create
int iCurrent
call super::create
this.cb_done=create cb_done
this.cb_be_back=create cb_be_back
this.st_perform_service=create st_perform_service
this.tab_properties=create tab_properties
this.ln_services=create ln_services
this.st_order_service=create st_order_service
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_done
this.Control[iCurrent+2]=this.cb_be_back
this.Control[iCurrent+3]=this.st_perform_service
this.Control[iCurrent+4]=this.tab_properties
this.Control[iCurrent+5]=this.ln_services
this.Control[iCurrent+6]=this.st_order_service
end on

on w_do_treatment_old.destroy
call super::destroy
destroy(this.cb_done)
destroy(this.cb_be_back)
destroy(this.st_perform_service)
destroy(this.tab_properties)
destroy(this.ln_services)
destroy(this.st_order_service)
end on

event open;call super::open;integer li_sts
str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "ERROR"

service = message.powerobjectparm
treatment = service.treatment

if isnull(treatment) then
	log.log(this, "open", "No Treatment Context", 4)
	closewithreturn(this, popup_return)
	return
end if
	

title = current_patient.id_line()

// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_be_back.visible = false
end if

li_sts = initialize()

if li_sts < 0 then
	log.log(this, "open", "Error initializing window", 4)
	closewithreturn(this, popup_return)
	return
end if


end event

event close;integer i

for i = 1 to button_count
	closeuserobject(pbuttons[i])
	closeuserobject(titles[i])
next

button_count = 0

end event

event button_pressed;call super::button_pressed;//refresh_tab()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_do_treatment_old
boolean visible = true
integer x = 2647
integer y = 1500
boolean originalsize = false
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_do_treatment_old
end type

type cb_done from commandbutton within w_do_treatment_old
integer x = 2437
integer y = 1624
integer width = 443
integer height = 108
integer taborder = 170
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

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type cb_be_back from commandbutton within w_do_treatment_old
integer x = 1970
integer y = 1624
integer width = 443
integer height = 108
integer taborder = 180
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

popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type st_perform_service from statictext within w_do_treatment_old
integer x = 32
integer y = 1300
integer width = 251
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Perform..."
boolean focusrectangle = false
end type

type tab_properties from tab within w_do_treatment_old
integer width = 2921
integer height = 1300
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean focusonbuttondown = true
boolean boldselectedtext = true
tabposition tabposition = tabsonbottom!
integer selectedtab = 1
tabpage_treatment tabpage_treatment
tabpage_followup tabpage_followup
tabpage_assessments tabpage_assessments
tabpage_workplan tabpage_workplan
tabpage_attachments tabpage_attachments
tabpage_billing tabpage_billing
tabpage_properties tabpage_properties
end type

event selectionchanged;refresh_tab(newindex)

end event

on tab_properties.create
this.tabpage_treatment=create tabpage_treatment
this.tabpage_followup=create tabpage_followup
this.tabpage_assessments=create tabpage_assessments
this.tabpage_workplan=create tabpage_workplan
this.tabpage_attachments=create tabpage_attachments
this.tabpage_billing=create tabpage_billing
this.tabpage_properties=create tabpage_properties
this.Control[]={this.tabpage_treatment,&
this.tabpage_followup,&
this.tabpage_assessments,&
this.tabpage_workplan,&
this.tabpage_attachments,&
this.tabpage_billing,&
this.tabpage_properties}
end on

on tab_properties.destroy
destroy(this.tabpage_treatment)
destroy(this.tabpage_followup)
destroy(this.tabpage_assessments)
destroy(this.tabpage_workplan)
destroy(this.tabpage_attachments)
destroy(this.tabpage_billing)
destroy(this.tabpage_properties)
end on

type tabpage_treatment from u_treatment_results within tab_properties
string tag = "TREATMENT"
integer x = 18
integer y = 16
integer width = 2885
integer height = 1172
long tabbackcolor = 12632256
end type

type tabpage_followup from u_treatment_followups within tab_properties
string tag = "FOLLOWUP"
integer x = 18
integer y = 16
integer width = 2885
integer height = 1172
string text = "Followup"
long tabbackcolor = 12632256
end type

type tabpage_assessments from u_treatment_assessments within tab_properties
integer x = 18
integer y = 16
integer width = 2885
integer height = 1172
long tabbackcolor = 12632256
end type

type tabpage_workplan from u_treatment_workplans within tab_properties
string tag = "WORKPLAN"
integer x = 18
integer y = 16
integer width = 2885
integer height = 1172
string text = "Workplans"
long tabbackcolor = 12632256
long picturemaskcolor = 0
end type

type tabpage_attachments from u_treatment_attachments within tab_properties
string tag = "ATTACHMENT"
integer x = 18
integer y = 16
integer width = 2885
integer height = 1172
string text = "Attachments"
long tabbackcolor = 12632256
end type

type tabpage_billing from u_treatment_billing within tab_properties
string tag = "BILLING"
integer x = 18
integer y = 16
integer width = 2885
integer height = 1172
string text = "Billing"
long tabbackcolor = 12632256
end type

type tabpage_properties from u_context_object_properties within tab_properties
string tag = "PROPERTIES"
integer x = 18
integer y = 16
integer width = 2885
integer height = 1172
long tabbackcolor = 12632256
end type

type ln_services from line within w_do_treatment_old
integer linethickness = 4
integer beginx = 398
integer beginy = 1400
integer endx = 402
integer endy = 1700
end type

type st_order_service from statictext within w_do_treatment_old
integer x = 1184
integer y = 1300
integer width = 224
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Order..."
boolean focusrectangle = false
end type

