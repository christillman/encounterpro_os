$PBExportHeader$u_component_service_material.sru
forward
global type u_component_service_material from u_component_service
end type
end forward

global type u_component_service_material from u_component_service
end type
global u_component_service_material u_component_service_material

forward prototypes
public function integer xx_do_service ()
public function integer send_material (long pl_material_id)
end prototypes

public function integer xx_do_service ();string ls_printer
str_popup_return popup_return
str_popup popup
integer li_sts
long ll_material_id
string ls_action
boolean lb_wait_for_completion
boolean lb_offer_ill_be_back
string ls_which_material
long ll_choice
integer li_wait

// which_material:				provider reference = use provider reference for current context
//									patient reference = use patient reference for current context
// material_id:					use specified material_id
// action:							open (default) = Display material on screen
//									print = print material to default printer
//									print with setup = Offer printer setup dialog box and then print material
//									send = send material to document management screen
// synchronous:				true (default) = wait for user to close material before continuing
//									false = display material and continue with EncounterPRO (user closes material whenever they want)
// offer_ill_be_back:			true = offer I'm Finished/I'll Be Back
//									false (default) = assume I'm Finished
//									offer_ill_be_back is ignored if synchronous is false
// 


get_attribute("which_material", ls_which_material)
CHOOSE CASE lower(ls_which_material)
	CASE "provider reference", "patient reference"
		ll_material_id = sqlca.fn_reference_material_id(cpr_id, context_object, object_key, ls_which_material)
		if not tf_check() then return -1
		if isnull(ll_material_id) then
			if cpr_mode = "CLIENT" then
				popup.title = "No " + wordcap(ls_which_material) + " material is configured for this treatment."
				openwithparm(w_pop_choices_2, popup)
				if manual_service then
					openwithparm(w_pop_message, popup.title)
					return 2
				end if
				
				popup.data_row_count = 2
				popup.items[1] = "Cancel Service"
				popup.items[2] = "I'll Be Back"
				openwithparm(w_pop_choices_2, popup)
				ll_choice = message.doubleparm
				
				if ll_choice = 1 then
					return 2
				else
					return 0
				end if
			else
				log.log(this, "u_component_service_material.xx_do_service.0054", "reference material_id could not be determined", 4)
				return -1
			end if
		end if
	CASE ELSE
		get_attribute("material_id", ll_material_id)
		if isnull(ll_material_id) and not isnull(treatment) then
			ll_material_id = treatment.material_id
		end if
END CHOOSE

if isnull(ll_material_id) then
	log.log(this, "u_component_service_material.xx_do_service.0054", "material_id could not be determined", 4)
	return -1
end if

get_attribute("action", ls_action)
if isnull(ls_action) then ls_action = "open"


get_attribute("synchronous", lb_wait_for_completion, true)
if lb_wait_for_completion then
	lb_offer_ill_be_back = true
	get_attribute("offer_ill_be_back", lb_offer_ill_be_back)
else
	lb_offer_ill_be_back = false
end if

CHOOSE CASE lower(ls_action)
	CASE "open"
		li_sts = f_open_patient_material(ll_material_id, "open", lb_wait_for_completion)
		if li_sts <= 0 then
			log.log(this, "u_component_service_material.xx_do_service.0054", "Error opening patient material", 4)
			return -1
		end if
		
		if lb_wait_for_completion and lb_offer_ill_be_back and not manual_service then
			popup.data_row_count = 2
			popup.items[1] = "I'll Be Back"
			popup.items[2] = "I'm Finished"
			openwithparm(w_pop_pick, popup)
			popup_return = message.powerobjectparm
			if popup_return.item_count <> 1 then
				return 0
			else
				if popup_return.item_indexes[1] = 1 then
					return 0
				else
					return 1
				end if
			end if
		end if
	CASE "print"
		li_wait = f_please_wait_open()
		
		li_sts = f_open_patient_material(ll_material_id, "print", false)
		if li_sts <= 0 then
			log.log(this, "u_component_service_material.xx_do_service.0054", "Error printing patient material", 4)
			f_please_wait_close(li_wait)
			return -1
		end if
		
		f_please_wait_close(li_wait)
	CASE "print with setup"
		ls_printer = common_thread.select_printer()
		// If the user didn't select a printer then don't do anything
		if isnull(ls_printer) then
			if manual_service then
				return 1
			else
				popup.data_row_count = 2
				popup.items[1] = "I'll Be Back"
				popup.items[2] = "I'm Finished"
				openwithparm(w_pop_pick, popup)
				popup_return = message.powerobjectparm
				if popup_return.item_count <> 1 then
					return 0
				else
					if popup_return.item_indexes[1] = 1 then
						return 0
					else
						return 1
					end if
				end if
			end if
		end if
		
		li_wait = f_please_wait_open()
		
		common_thread.set_printer(ls_printer)
		li_sts = f_open_patient_material(ll_material_id, "print", false)
		if li_sts <= 0 then
			log.log(this, "u_component_service_material.xx_do_service.0054", "Error printing patient material", 4)
			f_please_wait_close(li_wait)
			return -1
		end if
		common_thread.set_default_printer()
		
		f_please_wait_close(li_wait)
	CASE "send"
		li_sts = send_material(ll_material_id)
		if li_sts < 0 then return -1
END CHOOSE

return 1







end function

public function integer send_material (long pl_material_id);long i
long ll_patient_workplan_item_id
string ls_dispatch_method
string ls_ordered_for
long ll_patient_workplan_id
string ls_purpose
boolean lb_send_now
u_component_wp_item_document luo_document
integer li_sts
u_ds_data luo_data
long ll_count
string ls_ordered_by
string ls_default_dispatch_method
boolean lb_found
str_patient_material lstr_material
string ls_description
string ls_report_id

setnull(ls_report_id)

lstr_material = f_get_patient_material(pl_material_id, false)

get_attribute("ordered_for", ls_ordered_for)
if isnull(ls_ordered_for) then
	ls_ordered_for = "#Patient"
end if

ls_ordered_by = current_user.user_id
if left(ls_ordered_by, 1) = "#" then
	// if the current user is a special user, then use who ordered the material service
	ls_ordered_by = this.ordered_by
end if

get_attribute("dispatch_method", ls_dispatch_method)
if isnull(ls_dispatch_method) then ls_dispatch_method = "Printer"

ll_patient_workplan_id = 0

get_attribute("document_description", ls_description)
if isnull(ls_description) then
	ls_description = lstr_material.title
end if

get_attribute("purpose", ls_purpose)

ll_patient_workplan_item_id = sqlca.jmj_order_document_from_material( cpr_id, &
																								encounter_id, &
																								context_object, &
																								object_key, &
																								ls_report_id, &
																								ls_purpose, &
																								ls_dispatch_method, &
																								ls_ordered_for, &
																								ll_patient_workplan_id, &
																								ls_description, &
																								current_user.user_id, &
																								current_scribe.user_id, &
																								pl_material_id)
if not tf_check() then return -1
if ll_patient_workplan_item_id <= 0 then return -1



return 1

end function

on u_component_service_material.create
call super::create
end on

on u_component_service_material.destroy
call super::destroy
end on

