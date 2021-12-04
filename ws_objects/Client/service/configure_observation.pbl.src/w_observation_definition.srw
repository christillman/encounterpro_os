$PBExportHeader$w_observation_definition.srw
forward
global type w_observation_definition from w_window_base
end type
type st_obs_type_title from statictext within w_observation_definition
end type
type st_observation_type from statictext within w_observation_definition
end type
type st_display_style_title from statictext within w_observation_definition
end type
type st_display_style from statictext within w_observation_definition
end type
type cb_save from commandbutton within w_observation_definition
end type
type cb_common_lists from commandbutton within w_observation_definition
end type
type cb_categories from commandbutton within w_observation_definition
end type
type st_exclusive_flag from statictext within w_observation_definition
end type
type st_title_exclusive from statictext within w_observation_definition
end type
type st_in_context_flag from statictext within w_observation_definition
end type
type st_title_in_context from statictext within w_observation_definition
end type
type pb_cancel from u_picture_button within w_observation_definition
end type
type sle_description from singlelineedit within w_observation_definition
end type
type st_collection_procedure from statictext within w_observation_definition
end type
type st_perform_procedure from statictext within w_observation_definition
end type
type pb_done from u_picture_button within w_observation_definition
end type
type dw_locations from u_dw_pick_list within w_observation_definition
end type
type st_results from statictext within w_observation_definition
end type
type dw_results from u_dw_pick_list within w_observation_definition
end type
type cb_get_phrase from commandbutton within w_observation_definition
end type
type st_title_pick_loc from statictext within w_observation_definition
end type
type st_location_pick_flag from statictext within w_observation_definition
end type
type st_title_bill_loc from statictext within w_observation_definition
end type
type st_location_bill_flag from statictext within w_observation_definition
end type
type st_title_collection_procedure from statictext within w_observation_definition
end type
type st_title_perform_procedure from statictext within w_observation_definition
end type
type st_narrative from statictext within w_observation_definition
end type
type cb_coding_elements from commandbutton within w_observation_definition
end type
type cb_image from commandbutton within w_observation_definition
end type
type st_locations from statictext within w_observation_definition
end type
type st_result_type from statictext within w_observation_definition
end type
type st_default_view from statictext within w_observation_definition
end type
type r_1 from rectangle within w_observation_definition
end type
type st_default_view_title from statictext within w_observation_definition
end type
type st_title from statictext within w_observation_definition
end type
type cb_equivalence from commandbutton within w_observation_definition
end type
type st_status from statictext within w_observation_definition
end type
type st_status_title from statictext within w_observation_definition
end type
type st_observation_id from statictext within w_observation_definition
end type
type st_1 from statictext within w_observation_definition
end type
end forward

global type w_observation_definition from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_obs_type_title st_obs_type_title
st_observation_type st_observation_type
st_display_style_title st_display_style_title
st_display_style st_display_style
cb_save cb_save
cb_common_lists cb_common_lists
cb_categories cb_categories
st_exclusive_flag st_exclusive_flag
st_title_exclusive st_title_exclusive
st_in_context_flag st_in_context_flag
st_title_in_context st_title_in_context
pb_cancel pb_cancel
sle_description sle_description
st_collection_procedure st_collection_procedure
st_perform_procedure st_perform_procedure
pb_done pb_done
dw_locations dw_locations
st_results st_results
dw_results dw_results
cb_get_phrase cb_get_phrase
st_title_pick_loc st_title_pick_loc
st_location_pick_flag st_location_pick_flag
st_title_bill_loc st_title_bill_loc
st_location_bill_flag st_location_bill_flag
st_title_collection_procedure st_title_collection_procedure
st_title_perform_procedure st_title_perform_procedure
st_narrative st_narrative
cb_coding_elements cb_coding_elements
cb_image cb_image
st_locations st_locations
st_result_type st_result_type
st_default_view st_default_view
r_1 r_1
st_default_view_title st_default_view_title
st_title st_title
cb_equivalence cb_equivalence
st_status st_status
st_status_title st_status_title
st_observation_id st_observation_id
st_1 st_1
end type
global w_observation_definition w_observation_definition

type variables
string observation_id
string collection_procedure_id
string perform_procedure_id

string location_pick_flag
string location_bill_flag
string exclusive_flag
string in_context_flag

string collection_location_domain = "NA"
string perform_location_domain

boolean allow_editing
boolean changed

string result_type = "PERFORM"

string default_view
string display_style
string observation_type

string narrative_phrase

long material_id

string status

long owner_id
end variables

forward prototypes
public subroutine set_flags ()
public subroutine edit_location_domain ()
public subroutine change_location_domain ()
public subroutine new_location_domain ()
public function integer load_observation (string ps_observation_id)
public subroutine new_observation ()
public function integer save_changes ()
end prototypes

public subroutine set_flags ();if perform_location_domain = "NA" then
	st_location_pick_flag.visible = false
	st_title_pick_loc.visible = false
	st_location_bill_flag.visible = false
	st_title_bill_loc.visible = false
else
	st_location_pick_flag.visible = true
	st_title_pick_loc.visible = true
	if location_pick_flag = "Y" then
		st_location_pick_flag.text = "Yes"
		st_location_bill_flag.visible = true
		st_title_bill_loc.visible = true
		if location_bill_flag = "Y" then
			st_location_bill_flag.text = "Yes"
		else
			st_location_bill_flag.text = "No"
		end if
	else
		st_location_pick_flag.text = "No"
		st_location_bill_flag.visible = false
		st_title_bill_loc.visible = false
	end if
end if

end subroutine

public subroutine edit_location_domain ();str_popup popup
string ls_location_domain

if result_type = "PERFORM" then
	ls_location_domain = perform_location_domain
else
	ls_location_domain = collection_location_domain
end if

popup.data_row_count = 1
popup.items[1] = ls_location_domain
openwithparm(w_location_domain_edit, popup)

dw_locations.retrieve(ls_location_domain)

datalist.clear_cache("locations")

end subroutine

public subroutine change_location_domain ();str_popup_return popup_return

open(w_pick_location_domain)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if result_type = "PERFORM" then
	perform_location_domain = popup_return.items[1]
	dw_locations.retrieve(perform_location_domain)
else
	collection_location_domain = popup_return.items[1]
	dw_locations.retrieve(collection_location_domain)
end if

set_flags()

changed = true

end subroutine

public subroutine new_location_domain ();str_popup popup
str_popup_return popup_return
long ll_next_key
integer li_sts
string ls_location_domain

 DECLARE lsp_new_location_domain PROCEDURE FOR dbo.sp_new_location_domain  
         @ps_location_domain = :ls_location_domain OUT,   
         @ps_description = :popup_return.item  ;

popup.item = "Enter New Location Domain:"
openwithparm(w_pop_get_string, popup)
popup_return = message.powerobjectparm
if isnull(popup_return.item) or popup_return.item = "" then return

EXECUTE lsp_new_location_domain;
if not tf_check() then return

FETCH lsp_new_location_domain INTO :ls_location_domain;
if not tf_check() then return

CLOSE lsp_new_location_domain;

changed = true

if result_type = "PERFORM" then
	perform_location_domain = ls_location_domain
else
	collection_location_domain = ls_location_domain
end if

set_flags()

edit_location_domain()

end subroutine

public function integer load_observation (string ps_observation_id);integer li_sts
string ls_description
string ls_collection_procedure_id
string ls_perform_procedure_id
string ls_perform_location_domain
string ls_collection_location_domain
string ls_type_description
string ls_cat_description
string ls_procedure_description
decimal ldc_charge
string ls_cpt_code
string ls_category_id
string ls_in_context_flag

SELECT description,
		collection_procedure_id,
		perform_procedure_id,
		perform_location_domain,
		collection_location_domain,
		location_pick_flag,
		location_bill_flag,
		exclusive_flag,
		in_context_flag,
		observation_type,
		default_view,
		display_style,
		narrative_phrase,
		material_id,
		status,
		owner_id
INTO	:ls_description,
		:ls_collection_procedure_id,
		:ls_perform_procedure_id,
		:ls_perform_location_domain,
		:ls_collection_location_domain,
		:location_pick_flag,
		:location_bill_flag,
		:exclusive_flag,
		:in_context_flag,
		:observation_type,
		:default_view,
		:display_style,
		:narrative_phrase,
		:material_id,
		:status,
		:owner_id
FROM c_Observation
WHERE observation_id = :ps_observation_id;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	setnull(observation_id)
	return 0
end if

st_observation_id.text = ps_observation_id
observation_id = ps_observation_id
sle_description.text = ls_description
st_default_view.text = default_view
st_display_style.text = display_style

if not isnull(ls_collection_procedure_id) then
	li_sts = tf_get_procedure_detail(ls_collection_procedure_id, &
												ls_procedure_description, &
												ls_cpt_code, &
												ls_category_id, &
												ls_cat_description, &
												ldc_charge)
	if li_sts < 0 then return li_sts
	if li_sts = 0 then
		log.log(this, "w_observation_definition.load_observation:0070", "Invalid collection procedure id (" + ps_observation_id + &
														", " + ls_collection_procedure_id + ")", 4)
		setnull(collection_procedure_id)
		st_collection_procedure.text = "N/A"
	else
		collection_procedure_id = ls_collection_procedure_id
		st_collection_procedure.text = ls_procedure_description + " (" + ls_cpt_code + ")"
	end if
else
	setnull(collection_procedure_id)
	st_collection_procedure.text = "N/A"
end if

if not isnull(ls_perform_procedure_id) then
	li_sts = tf_get_procedure_detail(ls_perform_procedure_id, &
												ls_procedure_description, &
												ls_cpt_code, &
												ls_category_id, &
												ls_cat_description, &
												ldc_charge)
	if li_sts < 0 then return li_sts
	if li_sts = 0 then
		log.log(this, "w_observation_definition.load_observation:0092", "Invalid perform procedure id (" + ps_observation_id + &
														", " + ls_perform_procedure_id + ")", 4)
		setnull(perform_procedure_id)
		st_perform_procedure.text = "N/A"
	else
		perform_procedure_id = ls_perform_procedure_id
		st_perform_procedure.text = ls_procedure_description + " (" + ls_cpt_code + ")"
	end if
else
	setnull(perform_procedure_id)
	st_perform_procedure.text = "N/A"
end if

dw_locations.settransobject(sqlca)
perform_location_domain = ls_perform_location_domain
collection_location_domain = ls_collection_location_domain
// Initialize to show perform locations
st_result_type.text = "Perform"
result_type = "PERFORM"
dw_locations.retrieve(perform_location_domain)

set_flags()

if status = "OK" then
	st_status.text = "Active"
else
	st_status.text = "Inactive"
end if

if exclusive_flag = "Y" then
	st_exclusive_flag.text = "Yes"
else
	st_exclusive_flag.text = "No"
end if

if in_context_flag = "Y" then
	st_in_context_flag.text = "Yes"
else
	st_in_context_flag.text = "No"
end if

if isnull(narrative_phrase) then
	st_narrative.weight = 400
else
	st_narrative.weight = 700
end if

if isnull(material_id) then
	cb_image.weight = 400
else
	cb_image.weight = 700
end if

st_observation_type.text = observation_type

dw_results.settransobject(sqlca)
dw_results.retrieve(observation_id, result_type)

changed = false

if allow_editing then
	sle_description.enabled = true
	st_collection_procedure.enabled = true
	st_perform_procedure.enabled = true
	st_in_context_flag.enabled = true
	st_exclusive_flag.enabled = true
	st_location_bill_flag.enabled = true
	st_location_pick_flag.enabled = true
	cb_categories.enabled = true
	cb_common_lists.enabled = true
	cb_save.visible = true
	st_observation_type.enabled = true
	st_display_style.enabled = true
	st_narrative.enabled = true
else
	sle_description.enabled = false
	st_collection_procedure.enabled = false
	st_perform_procedure.enabled = false
	st_in_context_flag.enabled = false
	st_exclusive_flag.enabled = false
	st_location_bill_flag.enabled = false
	st_location_pick_flag.enabled = false
	cb_categories.enabled = false
	cb_common_lists.enabled = false
	cb_save.visible = false
	st_observation_type.enabled = false
	st_display_style.enabled = false
	st_narrative.enabled = false
end if
sle_description.setfocus()

return 1

end function

public subroutine new_observation ();setnull(observation_id)
sle_description.text = ""

setnull(collection_procedure_id)
st_collection_procedure.text = "N/A"
setnull(perform_procedure_id)
st_perform_procedure.text = "N/A"

dw_locations.settransobject(sqlca)
perform_location_domain = "NA"
collection_location_domain = "NA"
// Initialize to show perform locations
st_result_type.text = "Perform"
result_type = "PERFORM"
dw_locations.retrieve(perform_location_domain)

in_context_flag = "N"
exclusive_flag = "N"
location_bill_flag = "N"
location_pick_flag = "N"

st_in_context_flag.text = "No"
st_exclusive_flag.text = "No"
st_location_bill_flag.text = "No"
st_location_pick_flag.text = "No"

default_view = "R"
st_default_view.text = default_view

st_observation_id.text = "<New Observation>"

setnull(display_style)
st_display_style.text = display_style

if isnull(observation_type) then st_observation_type.postevent("clicked")

status = "OK"

set_flags()

cb_categories.enabled = false
cb_common_lists.enabled = false

sle_description.setfocus()

changed = false


end subroutine

public function integer save_changes ();string ls_composite_flag

//CWW, BEGIN
u_ds_data luo_sp_new_observation
integer li_spdw_count
// DECLARE lsp_new_observation PROCEDURE FOR dbo.sp_new_observation  
//         @ps_observation_id = :observation_id OUT,   
//         @ps_collection_location_domain = :collection_location_domain,   
//         @ps_perform_location_domain = :perform_location_domain,   
//         @ps_collection_procedure_id = :collection_procedure_id,   
//         @ps_perform_procedure_id = :perform_procedure_id,   
//         @ps_description = :sle_description.text,   
//         @ps_composite_flag = :ls_composite_flag,   
//         @ps_exclusive_flag = :exclusive_flag,
//         @ps_in_context_flag = :in_context_flag,
//			@ps_location_pick_flag = :location_pick_flag,
//			@ps_location_bill_flag = :location_bill_flag,
//			@ps_observation_type = :observation_type,
//			@ps_default_view = :default_view,
//			@ps_display_style = :display_style;
//CWW,END

		
datalist.clear_cache("observations")

if isnull(default_view) or default_view <> "L" then
	default_view = "R"
end if

if isnull(display_style) or trim(display_style) = "" then
	setnull(display_style)
end if

ls_composite_flag = "N"

if sle_description.text = "" or isnull(sle_description.text) then
	openwithparm(w_pop_message, "You must enter a description")
	return 0
end if

if isnull(observation_id) then
	//CWW, BEGIN
	//EXECUTE lsp_new_observation;
	//if not tf_check() then return -1
	//FETCH lsp_new_observation INTO :observation_id;
	//if not tf_check() then return -1
	//CLOSE lsp_new_observation;
	
	luo_sp_new_observation = CREATE u_ds_data
	luo_sp_new_observation.set_dataobject("dw_sp_new_observation")
	li_spdw_count = luo_sp_new_observation.retrieve(collection_location_domain, perform_location_domain, &
																	collection_procedure_id, perform_procedure_id, sle_description.text, & 
																	ls_composite_flag, exclusive_flag, in_context_flag, &
																	location_pick_flag, location_bill_flag, observation_type, & 
																	default_view, display_style)
	if li_spdw_count <= 0 then
		setnull(observation_id)
	else
		observation_id = luo_sp_new_observation.object.observation_id[1]
		st_observation_id.text = observation_id
	end if

	destroy luo_sp_new_observation	
	
	//CWW, END
	
else
	sqlca.sp_update_observation( &
			observation_id, &
			collection_location_domain, &
			perform_location_domain, &
			collection_procedure_id, &
			perform_procedure_id, &
			sle_description.text, &
			ls_composite_flag, &
			exclusive_flag, &
			in_context_flag, &
			location_pick_flag, &
			location_bill_flag, &
			observation_type, &
			default_view, &
			display_style, &
			status)

	if not tf_check() then return -1
end if

UPDATE c_Observation
SET narrative_phrase = :narrative_phrase
WHERE observation_id = :observation_id;
if not tf_check() then return -1

cb_categories.enabled = true
cb_common_lists.enabled = true


return 1
end function

event open;call super::open;str_popup popup
integer li_sts

popup = message.powerobjectparm

setnull(material_id)

if popup.data_row_count = 2 then
	// Edit existing observation
	observation_id = popup.items[1]
	allow_editing = f_string_to_boolean(popup.items[2])
	li_sts = load_observation(observation_id)
elseif popup.data_row_count = 1 then
	// New observation
	observation_type = popup.items[1]
	allow_editing = true
	new_observation()
elseif popup.data_row_count = 0 then
	// New observation
	setnull(observation_type)
	allow_editing = true
	new_observation()
else
	log.log(this, "w_observation_definition:open", "Invalid Parameters", 4)
	close(this)
	return
end if

end event

on w_observation_definition.create
int iCurrent
call super::create
this.st_obs_type_title=create st_obs_type_title
this.st_observation_type=create st_observation_type
this.st_display_style_title=create st_display_style_title
this.st_display_style=create st_display_style
this.cb_save=create cb_save
this.cb_common_lists=create cb_common_lists
this.cb_categories=create cb_categories
this.st_exclusive_flag=create st_exclusive_flag
this.st_title_exclusive=create st_title_exclusive
this.st_in_context_flag=create st_in_context_flag
this.st_title_in_context=create st_title_in_context
this.pb_cancel=create pb_cancel
this.sle_description=create sle_description
this.st_collection_procedure=create st_collection_procedure
this.st_perform_procedure=create st_perform_procedure
this.pb_done=create pb_done
this.dw_locations=create dw_locations
this.st_results=create st_results
this.dw_results=create dw_results
this.cb_get_phrase=create cb_get_phrase
this.st_title_pick_loc=create st_title_pick_loc
this.st_location_pick_flag=create st_location_pick_flag
this.st_title_bill_loc=create st_title_bill_loc
this.st_location_bill_flag=create st_location_bill_flag
this.st_title_collection_procedure=create st_title_collection_procedure
this.st_title_perform_procedure=create st_title_perform_procedure
this.st_narrative=create st_narrative
this.cb_coding_elements=create cb_coding_elements
this.cb_image=create cb_image
this.st_locations=create st_locations
this.st_result_type=create st_result_type
this.st_default_view=create st_default_view
this.r_1=create r_1
this.st_default_view_title=create st_default_view_title
this.st_title=create st_title
this.cb_equivalence=create cb_equivalence
this.st_status=create st_status
this.st_status_title=create st_status_title
this.st_observation_id=create st_observation_id
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_obs_type_title
this.Control[iCurrent+2]=this.st_observation_type
this.Control[iCurrent+3]=this.st_display_style_title
this.Control[iCurrent+4]=this.st_display_style
this.Control[iCurrent+5]=this.cb_save
this.Control[iCurrent+6]=this.cb_common_lists
this.Control[iCurrent+7]=this.cb_categories
this.Control[iCurrent+8]=this.st_exclusive_flag
this.Control[iCurrent+9]=this.st_title_exclusive
this.Control[iCurrent+10]=this.st_in_context_flag
this.Control[iCurrent+11]=this.st_title_in_context
this.Control[iCurrent+12]=this.pb_cancel
this.Control[iCurrent+13]=this.sle_description
this.Control[iCurrent+14]=this.st_collection_procedure
this.Control[iCurrent+15]=this.st_perform_procedure
this.Control[iCurrent+16]=this.pb_done
this.Control[iCurrent+17]=this.dw_locations
this.Control[iCurrent+18]=this.st_results
this.Control[iCurrent+19]=this.dw_results
this.Control[iCurrent+20]=this.cb_get_phrase
this.Control[iCurrent+21]=this.st_title_pick_loc
this.Control[iCurrent+22]=this.st_location_pick_flag
this.Control[iCurrent+23]=this.st_title_bill_loc
this.Control[iCurrent+24]=this.st_location_bill_flag
this.Control[iCurrent+25]=this.st_title_collection_procedure
this.Control[iCurrent+26]=this.st_title_perform_procedure
this.Control[iCurrent+27]=this.st_narrative
this.Control[iCurrent+28]=this.cb_coding_elements
this.Control[iCurrent+29]=this.cb_image
this.Control[iCurrent+30]=this.st_locations
this.Control[iCurrent+31]=this.st_result_type
this.Control[iCurrent+32]=this.st_default_view
this.Control[iCurrent+33]=this.r_1
this.Control[iCurrent+34]=this.st_default_view_title
this.Control[iCurrent+35]=this.st_title
this.Control[iCurrent+36]=this.cb_equivalence
this.Control[iCurrent+37]=this.st_status
this.Control[iCurrent+38]=this.st_status_title
this.Control[iCurrent+39]=this.st_observation_id
this.Control[iCurrent+40]=this.st_1
end on

on w_observation_definition.destroy
call super::destroy
destroy(this.st_obs_type_title)
destroy(this.st_observation_type)
destroy(this.st_display_style_title)
destroy(this.st_display_style)
destroy(this.cb_save)
destroy(this.cb_common_lists)
destroy(this.cb_categories)
destroy(this.st_exclusive_flag)
destroy(this.st_title_exclusive)
destroy(this.st_in_context_flag)
destroy(this.st_title_in_context)
destroy(this.pb_cancel)
destroy(this.sle_description)
destroy(this.st_collection_procedure)
destroy(this.st_perform_procedure)
destroy(this.pb_done)
destroy(this.dw_locations)
destroy(this.st_results)
destroy(this.dw_results)
destroy(this.cb_get_phrase)
destroy(this.st_title_pick_loc)
destroy(this.st_location_pick_flag)
destroy(this.st_title_bill_loc)
destroy(this.st_location_bill_flag)
destroy(this.st_title_collection_procedure)
destroy(this.st_title_perform_procedure)
destroy(this.st_narrative)
destroy(this.cb_coding_elements)
destroy(this.cb_image)
destroy(this.st_locations)
destroy(this.st_result_type)
destroy(this.st_default_view)
destroy(this.r_1)
destroy(this.st_default_view_title)
destroy(this.st_title)
destroy(this.cb_equivalence)
destroy(this.st_status)
destroy(this.st_status_title)
destroy(this.st_observation_id)
destroy(this.st_1)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_observation_definition
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_observation_definition
end type

type st_obs_type_title from statictext within w_observation_definition
integer x = 37
integer y = 896
integer width = 494
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Observation Type"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_observation_type from statictext within w_observation_definition
integer x = 37
integer y = 964
integer width = 494
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_observation_type_pick_list"
popup.datacolumn = 1
popup.displaycolumn = 1
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then
	// If the observation_type is null, then this is a new observation.
	// In that case, if the user cancels the observation_type selection,
	// then they've also cancelled the new observation
	if isnull(observation_type) then
		popup_return.item_count = 0
		closewithreturn(parent, popup_return)
	end if
	return
end if

observation_type = popup_return.items[1]
text = observation_type

changed = true

end event

type st_display_style_title from statictext within w_observation_definition
integer x = 2272
integer y = 1008
integer width = 539
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Display Style"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_display_style from statictext within w_observation_definition
integer x = 2272
integer y = 1080
integer width = 539
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.title = "Enter Display Style"
popup.item = display_style
popup.argument_count = 1
popup.argument[1] = "observation_display_style"
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

text = popup_return.items[1]
display_style = text



end event

type cb_save from commandbutton within w_observation_definition
integer x = 2565
integer y = 1396
integer width = 247
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Save"
end type

event clicked;integer li_sts

if allow_editing then
	li_sts = save_changes()
	if li_sts <= 0 then return
end if

end event

type cb_common_lists from commandbutton within w_observation_definition
integer x = 37
integer y = 1236
integer width = 494
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Specialty List"
end type

event clicked;str_popup popup

popup.title = sle_description.text
popup.items[1] = observation_id
popup.data_row_count = 1

openwithparm(w_observation_common_lists, popup)

end event

type cb_categories from commandbutton within w_observation_definition
integer x = 37
integer y = 1096
integer width = 494
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Treatment Types"
end type

event clicked;str_popup popup

popup.title = sle_description.text
popup.items[1] = observation_id
popup.data_row_count = 1

openwithparm(w_observation_treatment_types, popup)

end event

type st_exclusive_flag from statictext within w_observation_definition
integer x = 2519
integer y = 608
integer width = 288
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if exclusive_flag = "Y" then
	exclusive_flag = "N"
	text = "No"
else
	exclusive_flag = "Y"
	text = "Yes"
end if

changed = true

end event

type st_title_exclusive from statictext within w_observation_definition
integer x = 1595
integer y = 624
integer width = 887
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Results Mutually Exclusive:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_in_context_flag from statictext within w_observation_definition
integer x = 2519
integer y = 492
integer width = 288
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if in_context_flag = "Y" then
	in_context_flag = "N"
	text = "No"
else
	in_context_flag = "Y"
	text = "Yes"
end if

changed = true

end event

type st_title_in_context from statictext within w_observation_definition
integer x = 1458
integer y = 508
integer width = 1024
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Must Be In Composite Observation:"
alignment alignment = right!
boolean focusrectangle = false
end type

type pb_cancel from u_picture_button within w_observation_definition
integer x = 2258
integer y = 1560
integer taborder = 0
boolean bringtotop = true
boolean cancel = true
boolean originalsize = false
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

setnull(popup_return.item)
popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type sle_description from singlelineedit within w_observation_definition
integer x = 37
integer y = 240
integer width = 2578
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;changed = true

end event

type st_collection_procedure from statictext within w_observation_definition
event clicked pbm_bnclicked
integer x = 320
integer y = 476
integer width = 946
integer height = 144
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
string ls_description
integer li_update_flag
string ls_cpt_code
decimal ldc_charge
str_picked_procedures lstr_procedures

if not isnull(collection_procedure_id) then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Procedure Details"
	popup.button_titles[popup.button_count] = "Edit Procedure"
	buttons[popup.button_count] = "EDIT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button05.bmp"
	popup.button_helps[popup.button_count] = "Change Procedure"
	popup.button_titles[popup.button_count] = "Change Procedure"
	buttons[popup.button_count] = "CHANGE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonx5.bmp"
	popup.button_helps[popup.button_count] = "Not Applicable"
	popup.button_titles[popup.button_count] = "N/A"
	buttons[popup.button_count] = "NA"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	button_pressed = message.doubleparm
	if button_pressed < 1 or button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if

CHOOSE CASE buttons[button_pressed]
	CASE "EDIT"
		popup.data_row_count = 2
		popup.items[1] = "TESTCOLLECT"
		popup.items[2] = collection_procedure_id
		openwithparm(w_procedure_definition, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 4 then return
		collection_procedure_id = popup_return.item
		text = popup_return.items[4] + " (" + popup_return.items[1] + ")"
	CASE "CHANGE"
		popup.data_row_count = 1
		popup.items[1] = "TESTCOLLECT"
		popup.multiselect = false
		openwithparm(w_pick_procedures, popup)
		lstr_procedures = message.powerobjectparm

		if lstr_procedures.procedure_count < 1 then return

		li_sts = tf_get_procedure_charge(lstr_procedures.procedures[1].procedure_id, ls_cpt_code, ldc_charge)
		if li_sts <= 0 then return
		collection_procedure_id = lstr_procedures.procedures[1].procedure_id
		text = lstr_procedures.procedures[1].description + " (" + ls_cpt_code + ")"
		changed = true
	CASE "NA"
		setnull(collection_procedure_id)
		text = "N/A"
		changed = true
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end event

type st_perform_procedure from statictext within w_observation_definition
event clicked pbm_bnclicked
integer x = 320
integer y = 728
integer width = 946
integer height = 144
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
string ls_cpt_code
decimal ldc_charge
integer li_update_flag
str_picked_procedures lstr_procedures

if not isnull(perform_procedure_id) then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Procedure Details"
	popup.button_titles[popup.button_count] = "Edit Procedure"
	buttons[popup.button_count] = "EDIT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button05.bmp"
	popup.button_helps[popup.button_count] = "Change Procedure"
	popup.button_titles[popup.button_count] = "Change Procedure"
	buttons[popup.button_count] = "CHANGE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonx5.bmp"
	popup.button_helps[popup.button_count] = "Not Applicable"
	popup.button_titles[popup.button_count] = "N/A"
	buttons[popup.button_count] = "NA"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	button_pressed = message.doubleparm
	if button_pressed < 1 or button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if

CHOOSE CASE buttons[button_pressed]
	CASE "EDIT"
		popup.data_row_count = 2
		popup.items[1] = "TESTPERFORM"
		popup.items[2] = perform_procedure_id
		openwithparm(w_procedure_definition, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 4 then return
		perform_procedure_id = popup_return.item
		text = popup_return.items[4] + " (" + popup_return.items[1] + ")"
	CASE "CHANGE"
		popup.data_row_count = 1
		popup.items[1] = "TESTPERFORM"
		popup.multiselect = false
		openwithparm(w_pick_procedures, popup)
		lstr_procedures = message.powerobjectparm

		if lstr_procedures.procedure_count < 1 then return

		li_sts = tf_get_procedure_charge(lstr_procedures.procedures[1].procedure_id, ls_cpt_code, ldc_charge)
		if li_sts <= 0 then return
		perform_procedure_id = lstr_procedures.procedures[1].procedure_id
		text = lstr_procedures.procedures[1].description + " (" + ls_cpt_code + ")"
		changed = true
	CASE "NA"
		setnull(perform_procedure_id)
		text = "N/A"
		changed = true
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end event

type pb_done from u_picture_button within w_observation_definition
event clicked pbm_bnclicked
integer x = 2565
integer y = 1560
integer taborder = 40
boolean default = true
boolean originalsize = false
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;str_popup_return popup_return
integer li_sts

if allow_editing then
	li_sts = save_changes()
	if li_sts <= 0 then return
	
	popup_return.item_count = 1
	popup_return.items[1] = observation_id
	popup_return.descriptions[1] = sle_description.text
else
	popup_return.item_count = 0
end if

closewithreturn(parent, popup_return)

end event

type dw_locations from u_dw_pick_list within w_observation_definition
integer x = 590
integer y = 1080
integer width = 741
integer height = 692
integer taborder = 30
string dataobject = "dw_location_list"
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
string ls_assessment_id
integer li_update_flag
string ls_location_domain

if result_type = "PERFORM" then
	ls_location_domain = perform_location_domain
else
	ls_location_domain = collection_location_domain
end if


if not isnull(ls_location_domain) and ls_location_domain <> "NA" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Locations in this Domain"
	popup.button_titles[popup.button_count] = "Edit Domain"
	buttons[popup.button_count] = "EDIT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Change Location Domain"
	popup.button_titles[popup.button_count] = "Change Domain"
	buttons[popup.button_count] = "CHANGE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonx5.bmp"
	popup.button_helps[popup.button_count] = "Not Applicable"
	popup.button_titles[popup.button_count] = "Not Applicable"
	buttons[popup.button_count] = "NA"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	button_pressed = message.doubleparm
	if button_pressed < 1 or button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if

CHOOSE CASE buttons[button_pressed]
	CASE "EDIT"
		edit_location_domain()
	CASE "CHANGE"
		change_location_domain()
	CASE "NEW"
		new_location_domain()
	CASE "NA"
		if result_type = "PERFORM" then
			perform_location_domain = "NA"
			retrieve(perform_location_domain)
		else
			collection_location_domain = "NA"
			retrieve(collection_location_domain)
		end if
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end event

type st_results from statictext within w_observation_definition
integer x = 1458
integer y = 1004
integer width = 741
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Results"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_results from u_dw_pick_list within w_observation_definition
event clicked pbm_dwnlbuttonclk
integer x = 1458
integer y = 1080
integer width = 741
integer height = 692
integer taborder = 20
string dataobject = "dw_result_display_list"
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;str_popup popup
integer li_sts

li_sts = save_changes()
if li_sts <= 0 then return

popup.data_row_count = 2
popup.items[1] = observation_id
popup.items[2] = result_type
popup.title = sle_description.text

openwithparm(w_observation_result_edit, popup)

settransobject(sqlca)

retrieve(observation_id, result_type)


end event

type cb_get_phrase from commandbutton within w_observation_definition
boolean visible = false
integer x = 2633
integer y = 256
integer width = 146
integer height = 100
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ". . ."
end type

event clicked;u_component_nomenclature luo_nomenclature
string ls_phrase

//luo_nomenclature = component_manager.get_component("NOMENCLATURE","PHRASE")
setnull(luo_nomenclature)
if isnull(luo_nomenclature) then
	openwithparm(w_pop_message, "A nomenclature component has not been installed")
	return
end if

ls_phrase = luo_nomenclature.get_phrase("")
if not (isnull(ls_phrase) or trim(ls_phrase) = "") then
	sle_description.text = ls_phrase
end if

component_manager.destroy_component(luo_nomenclature)


end event

type st_title_pick_loc from statictext within w_observation_definition
integer x = 1595
integer y = 740
integer width = 887
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Pick Location When Ordering:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_location_pick_flag from statictext within w_observation_definition
integer x = 2519
integer y = 724
integer width = 288
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if location_pick_flag = "Y" then
	location_pick_flag = "N"
else
	location_pick_flag = "Y"
end if

set_flags()

changed = true

end event

type st_title_bill_loc from statictext within w_observation_definition
integer x = 1595
integer y = 856
integer width = 887
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Bill Locations Separately:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_location_bill_flag from statictext within w_observation_definition
integer x = 2519
integer y = 840
integer width = 288
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if location_bill_flag = "Y" then
	location_bill_flag = "N"
else
	location_bill_flag = "Y"
end if

set_flags()

changed = true

end event

type st_title_collection_procedure from statictext within w_observation_definition
integer x = 320
integer y = 412
integer width = 946
integer height = 76
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Collection Procedure"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title_perform_procedure from statictext within w_observation_definition
integer x = 320
integer y = 664
integer width = 946
integer height = 76
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Perform Procedure"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_narrative from statictext within w_observation_definition
integer x = 2437
integer y = 1240
integer width = 375
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Narrative"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
integer li_sts

li_sts = save_changes()
if li_sts <= 0 then return

popup.data_row_count = 3
popup.items[1] = observation_id
popup.items[2] = narrative_phrase
popup.items[3] = f_boolean_to_string(allow_editing)
popup.title = sle_description.text

openwithparm(w_observation_narrative_phrase, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

narrative_phrase = popup_return.items[1]
if isnull(narrative_phrase) then
	weight = 400
else
	weight = 700
end if

end event

type cb_coding_elements from commandbutton within w_observation_definition
integer x = 37
integer y = 1376
integer width = 494
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Coding Elements"
end type

event clicked;str_popup popup

popup.title = sle_description.text
popup.items[1] = observation_id
popup.data_row_count = 1

openwithparm(w_observation_coding_elements, popup)

end event

type cb_image from commandbutton within w_observation_definition
integer x = 37
integer y = 1516
integer width = 494
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Image"
end type

event clicked;//////////////////////////////////////////////////////////////////////////////////////
//
// Description: popup the material categories
//
// Created By:Sumathi Chinnasamy										Creation dt: 02/02/2000
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

str_popup			popup
str_popup_return	popup_return
long ll_material_category_id
integer li_choice
integer li_sts
long ll_material_id

if isnull(observation_id) then return

if isnull(material_id) then
	li_choice = 3
else
	popup.title = "Select One:"
	popup.data_row_count = 3
	popup.items[1] = "Display Image"
	popup.items[2] = "Remove Image"
	popup.items[3] = "Change Image"
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return
	
	li_choice = popup_return.item_indexes[1]
end if


CHOOSE CASE li_choice
	CASE 1
		li_sts = f_display_patient_material(material_id)
	CASE 2
		UPDATE c_Observation
		SET material_id = NULL
		WHERE observation_id = :observation_id;
		if not tf_check() then return
		
		weight = 400
		return
	CASE 3
		open(w_pick_patient_material)
		ll_material_id = message.doubleparm
		if ll_material_id > 0 then
			material_id = ll_material_id
			
			UPDATE c_Observation
			SET material_id = :material_id
			WHERE observation_id = :observation_id;
			if not tf_check() then return
			
			weight = 700
		end if
END CHOOSE



end event

type st_locations from statictext within w_observation_definition
integer x = 590
integer y = 1004
integer width = 741
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Locations"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_result_type from statictext within w_observation_definition
integer x = 1175
integer y = 960
integer width = 439
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Perform"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup			popup
str_popup_return	popup_return
string ls_result_type

if isnull(observation_id) then return

popup.dataobject = "dw_simple_result_types"
popup.datacolumn = 1
popup.displaycolumn = 1

Openwithparm(w_pop_pick, popup)
popup_return = Message.powerobjectparm
If popup_return.item_count <> 1 Then Return

result_type = popup_return.items[1]
text = result_type

CHOOSE CASE upper(result_type)
	CASE "COLLECT"
		st_locations.visible = true
		dw_locations.visible = true
		st_results.visible = true
		dw_results.x = st_results.x
		dw_locations.retrieve(collection_location_domain)
	CASE "PERFORM"
		st_locations.visible = true
		dw_locations.visible = true
		st_results.visible = true
		dw_results.x = st_results.x
		dw_locations.retrieve(perform_location_domain)
	CASE ELSE
		st_locations.visible = false
		dw_locations.visible = false
		st_results.visible = false
		dw_results.x = st_result_type.x + (st_result_type.width / 2) - (dw_results.width	/ 2)
END CHOOSE

setposition(ToTop!)

dw_results.retrieve(observation_id, result_type)


end event

type st_default_view from statictext within w_observation_definition
integer x = 2272
integer y = 1240
integer width = 119
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "R"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if default_view = "R" then
	default_view = "L"
else
	default_view = "R"
end if

text = default_view

end event

type r_1 from rectangle within w_observation_definition
integer linethickness = 1
long fillcolor = COLOR_BACKGROUND
integer x = 562
integer y = 940
integer width = 1664
integer height = 856
end type

type st_default_view_title from statictext within w_observation_definition
integer x = 2272
integer y = 1188
integer width = 119
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "R/L"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title from statictext within w_observation_definition
integer width = 2926
integer height = 144
integer textsize = -24
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Observation Definition"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_equivalence from commandbutton within w_observation_definition
integer x = 37
integer y = 1656
integer width = 494
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Equivalence"
end type

event clicked;str_content_object lstr_item
w_object_equivalence lw_window

if isnull(observation_id) then return

lstr_item.object_id = sqlca.fn_object_id_from_key("Observation", observation_id)
lstr_item.object_type = "Observation"
lstr_item.object_key = observation_id
lstr_item.description = sle_description.text
lstr_item.owner_id = owner_id

openwithparm(lw_window, lstr_item, "w_object_equivalence")

end event

type st_status from statictext within w_observation_definition
integer x = 2519
integer y = 376
integer width = 288
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Active"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if status = "OK" then
	status = "NA"
	text = "Inactive"
else
	status = "OK"
	text = "Active"
end if

changed = true

end event

type st_status_title from statictext within w_observation_definition
integer x = 2213
integer y = 392
integer width = 270
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Status:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_observation_id from statictext within w_observation_definition
integer x = 46
integer y = 340
integer width = 919
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Observation ID"
boolean focusrectangle = false
end type

event clicked;clipboard(text)

end event

type st_1 from statictext within w_observation_definition
integer x = 46
integer y = 172
integer width = 398
integer height = 76
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Description:"
boolean focusrectangle = false
end type

