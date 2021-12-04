$PBExportHeader$w_pick_user.srw
forward
global type w_pick_user from w_window_base
end type
type st_search_title from statictext within w_pick_user
end type
type pb_down_sel from u_picture_button within w_pick_user
end type
type pb_up_sel from u_picture_button within w_pick_user
end type
type st_page_sel from statictext within w_pick_user
end type
type pb_up from u_picture_button within w_pick_user
end type
type pb_down from u_picture_button within w_pick_user
end type
type st_page from statictext within w_pick_user
end type
type st_top_20 from statictext within w_pick_user
end type
type st_byrole from statictext within w_pick_user
end type
type st_search_status from statictext within w_pick_user
end type
type dw_selected_items from u_dw_pick_list within w_pick_user
end type
type st_name from statictext within w_pick_user
end type
type dw_users from u_dw_user_list within w_pick_user
end type
type cb_ok from commandbutton within w_pick_user
end type
type cb_cancel from commandbutton within w_pick_user
end type
type cb_new from commandbutton within w_pick_user
end type
type st_user_status from statictext within w_pick_user
end type
type st_user_list from statictext within w_pick_user
end type
type st_role_list from statictext within w_pick_user
end type
type st_system_list from statictext within w_pick_user
end type
type st_special_list from statictext within w_pick_user
end type
type st_by_care_team from statictext within w_pick_user
end type
type st_actor_class_list from statictext within w_pick_user
end type
type st_status_title from statictext within w_pick_user
end type
type st_specialty_filter_title from statictext within w_pick_user
end type
type st_specialty_filter from statictext within w_pick_user
end type
type st_primary_help from statictext within w_pick_user
end type
type st_by_zip from statictext within w_pick_user
end type
type st_zip_filter_title from statictext within w_pick_user
end type
type st_zip_filter from statictext within w_pick_user
end type
type st_distance_filter from statictext within w_pick_user
end type
type st_distance_filter_title from statictext within w_pick_user
end type
type st_zip_filter_disabled from statictext within w_pick_user
end type
type cb_zip_edit from commandbutton within w_pick_user
end type
type st_selected_items from statictext within w_pick_user
end type
type st_title from statictext within w_pick_user
end type
type st_2 from statictext within w_pick_user
end type
type st_support from statictext within w_pick_user
end type
end forward

global type w_pick_user from w_window_base
integer height = 1836
windowtype windowtype = response!
st_search_title st_search_title
pb_down_sel pb_down_sel
pb_up_sel pb_up_sel
st_page_sel st_page_sel
pb_up pb_up
pb_down pb_down
st_page st_page
st_top_20 st_top_20
st_byrole st_byrole
st_search_status st_search_status
dw_selected_items dw_selected_items
st_name st_name
dw_users dw_users
cb_ok cb_ok
cb_cancel cb_cancel
cb_new cb_new
st_user_status st_user_status
st_user_list st_user_list
st_role_list st_role_list
st_system_list st_system_list
st_special_list st_special_list
st_by_care_team st_by_care_team
st_actor_class_list st_actor_class_list
st_status_title st_status_title
st_specialty_filter_title st_specialty_filter_title
st_specialty_filter st_specialty_filter
st_primary_help st_primary_help
st_by_zip st_by_zip
st_zip_filter_title st_zip_filter_title
st_zip_filter st_zip_filter
st_distance_filter st_distance_filter
st_distance_filter_title st_distance_filter_title
st_zip_filter_disabled st_zip_filter_disabled
cb_zip_edit cb_zip_edit
st_selected_items st_selected_items
st_title st_title
st_2 st_2
st_support st_support
end type
global w_pick_user w_pick_user

type variables
boolean top_20_list
boolean allow_multiple
boolean edit_mode

string top_20_code
string top_20_user_id
string top_20_bitmap

string top_20_dataobject
string alpha_dataobject
string cat_dataobject
string cat_pick_dataobject

string search_type


string role_prefix = "Every"

string pick_actor_class

boolean enable_distance_filter
boolean enable_zipcode_filter

string zipcode_filter_domain_id
long zipcode_count
string zipcodes[]

end variables

forward prototypes
public subroutine select_user (string ps_user_id)
public function integer refresh ()
public function integer show_zipcode_filter ()
end prototypes

public subroutine select_user (string ps_user_id);str_user lstr_user
integer li_sts
long ll_row
string ls_role_prefix
str_users lstr_users
string ls_patient_name
string ls_message
long ll_null
datetime ldt_null
long ll_count

setnull(ll_null)
setnull(ldt_null)

if not allow_multiple then
	lstr_users.user_count = 1
	lstr_users.user[1].user_id = ps_user_id
	lstr_users.user[1].user_full_name = user_list.user_full_name(ps_user_id)
	lstr_users.user[1].user_short_name = user_list.user_short_name(ps_user_id)
	lstr_users.user[1].color = user_list.user_color(ps_user_id)

	if dw_users.current_search <> "BY ROLE" &
		and dw_users.current_search <> "CARE TEAM" &
		and len(dw_users.pick_users.cpr_id) > 0 &
		and upper(dw_users.actor_class) <> "USER" then
		
		// See if the selected user is already on the care team
		SELECT count(*)
		INTO :ll_count
		FROM p_Patient_Progress
		WHERE cpr_id = :dw_users.pick_users.cpr_id
		AND progress_type = "Care Team"
		AND progress_key = :ps_user_id
		AND LEFT(progress_value, 1) IN ('T', 'Y')
		AND current_flag = 'Y';
		if not tf_check() then return
		
		if ll_count = 0 then
			SELECT dbo.fn_patient_full_name(:dw_users.pick_users.cpr_id)
			INTO :ls_patient_name
			FROM c_1_Record;
			if not tf_check() then ls_patient_name = "this patient"

			// Mark - Nobody likes this prompt so until we smarten up the preferences just automatically add the selection to the care team
//			ls_message = "Would you like to add "
//			ls_message += lstr_users.user[1].user_full_name
//			ls_message += " to the Care Team for "
//			ls_message += ls_patient_name + "?"
//			if f_popup_yes_no(ls_message) then
				li_sts = f_set_progress(dw_users.pick_users.cpr_id, &
									"Patient", &
									ll_null, &
									"Care Team", &
									ps_user_id, &
									"True", &
									ldt_null, &
									ll_null, &
									ll_null, &
									ll_null)
//			end if
		end if
	end if
	
	
	closewithreturn(this, lstr_users)
	return
end if

if isnull(role_prefix) or role_prefix = "" then
	ls_role_prefix = "<"
else
	ls_role_prefix = "<" + role_prefix + " "
end if

li_sts = user_list.get_user(ps_user_id, lstr_user)
if li_sts <= 0 then
	log.log(this, "w_pick_user.select_user:0077", "user not found (" + ps_user_id + ")", 4)
	return
end if

if not allow_multiple then dw_selected_items.reset()

ll_row = dw_selected_items.insertrow(0)
dw_selected_items.object.user_id[ll_row] = ps_user_id
if left(ps_user_id, 1) = "!" then
	if lower(left(lstr_user.user_full_name, 4)) = "any " then
		lstr_user.user_full_name = mid(lstr_user.user_full_name, 5)
	end if
	dw_selected_items.object.user_full_name[ll_row] = ls_role_prefix + lstr_user.user_full_name + ">"
else
	dw_selected_items.object.user_full_name[ll_row] = lstr_user.user_full_name
end if
dw_selected_items.object.user_short_name[ll_row] = lstr_user.user_short_name
dw_selected_items.object.color[ll_row] = lstr_user.color

dw_selected_items.recalc_page(pb_up_sel, pb_down_sel, st_page_sel)

dw_users.clear_selected()

dw_selected_items.scrolltorow(ll_row)
dw_selected_items.recalc_page( pb_up_sel, pb_down_sel, st_page_sel)

end subroutine

public function integer refresh ();dw_users.search()

return 1

end function

public function integer show_zipcode_filter ();u_ds_data luo_data
long i


st_zip_filter.text = ""

zipcode_filter_domain_id = "ActorZipFilter_" + gnv_app.office_id

// Load the zip codes from the c_Domain table
luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_domain_pick_list")
zipcode_count = luo_data.retrieve(zipcode_filter_domain_id)
for i = 1 to zipcode_count
	zipcodes[i] = luo_data.object.domain_item[i]
	if len(st_zip_filter.text) > 0 then st_zip_filter.text += ", "
	st_zip_filter.text += zipcodes[i]
next
DESTROY luo_data

return 1

end function

event open;call super::open;/////////////////////////////////////////////////////////////////////////////////////
//
// Description:Based on treatment type, set the datawindow object names for category
// alpha and top20. [ need to be generalized in future by replacing this case state
// -ment with treatmet component ]
//
// Created By:Mark														Creation dt: 
//
// Modified By:Sumathi Chinnasamy									Creation dt: 02/02/2000
/////////////////////////////////////////////////////////////////////////////////////

str_pick_users lstr_pick_users
integer i
boolean lb_default_to_care_team
string ls_search_option
string ls_distance_filter
string ls_amount
string ls_unit

lstr_pick_users = message.powerobjectparm

// treat empty strings as nulls
if trim(lstr_pick_users.specialty_id) = "" then
	setnull(lstr_pick_users.specialty_id)
end if
if trim(lstr_pick_users.actor_class) = "" then
	setnull(lstr_pick_users.actor_class)
elseif lower(lstr_pick_users.actor_class) = "role" then
	lstr_pick_users.allow_roles = true
	setnull(lstr_pick_users.actor_class)
elseif lower(lstr_pick_users.actor_class) = "system" then
	lstr_pick_users.allow_system_users = true
	setnull(lstr_pick_users.actor_class)
elseif lower(lstr_pick_users.actor_class) = "special" then
	lstr_pick_users.allow_special_users = true
	setnull(lstr_pick_users.actor_class)
elseif lower(lstr_pick_users.actor_class) = "support" then
	lstr_pick_users.allow_support = true
	setnull(lstr_pick_users.actor_class)
elseif lower(lstr_pick_users.actor_class) = "user" then
	lstr_pick_users.hide_users = false
	setnull(lstr_pick_users.actor_class)
end if

if user_list.is_user_service(current_scribe.user_id, "CONFIG_USERS") then
	dw_users.allow_editing = true
else
	dw_users.allow_editing = false
end if

edit_mode = lstr_pick_users.allow_editing
allow_multiple = lstr_pick_users.allow_multiple

if allow_multiple then
	// Display any pre-selected users
	for i = 1 to lstr_pick_users.selected_users.user_count
		select_user(lstr_pick_users.selected_users.user[i].user_id)
	next
	role_prefix = "Every"
else
	dw_selected_items.visible = false
	st_selected_items.visible = false
	pb_up_sel.visible = false
	pb_down_sel.visible = false
	st_page_sel.visible = false
	role_prefix = "Any"
	cb_ok.visible = false
	cb_cancel.x = cb_ok.x
	if edit_mode then
		cb_cancel.text = "OK"
		cb_cancel.weight = 700
	end if
	cb_cancel.default = true
	cb_cancel.cancel = true
end if

// Turn on the actor classes asked for
if lstr_pick_users.hide_users then
	st_user_list.visible = false
else
	st_user_list.visible = true
end if

if lstr_pick_users.allow_roles then
	st_role_list.visible = true
else
	st_role_list.visible = false
end if

if lstr_pick_users.allow_system_users then
	st_system_list.visible = true
else
	st_system_list.visible = false
end if

if lstr_pick_users.allow_special_users then
	st_special_list.visible = true
else
	st_special_list.visible = false
end if

if lstr_pick_users.allow_support and datalist.get_preference_boolean("SUBSCRIPTIONS", "Show Support Providers", false)   then
	st_support.visible = true
else
	st_support.visible = false
end if

if len(lstr_pick_users.actor_class) > 0 then
	st_actor_class_list.visible = true
	pick_actor_class = lstr_pick_users.actor_class
	st_actor_class_list.text = wordcap(pick_actor_class)
else
	st_actor_class_list.visible = false
end if

// If no other buttons are visible, then make the user button invisible too
if not st_role_list.visible &
	and not st_actor_class_list.visible &
	and not st_special_list.visible &
	and not st_system_list.visible then
	st_user_list.visible = false
end if

dw_users.mode = "PICK"

pb_down_sel.visible = false
pb_up_sel.visible = false
st_page_sel.visible = false

dw_users.role_prefix = role_prefix

dw_users.initialize(lstr_pick_users)

if len(lstr_pick_users.pick_screen_title) > 0 then
	st_title.text = lstr_pick_users.pick_screen_title
elseif lstr_pick_users.allow_multiple then
	st_title.text = "Select Users"
else
	st_title.text = "Select User"
end if

if isnull(current_patient) then
	title = st_title.text
else
	title = current_patient.id_line()
end if

if lower(pick_actor_class) = "information system" then
	enable_zipcode_filter = false
else
	enable_zipcode_filter = datalist.get_preference_boolean("PREFERENCES", "Actor Filter Zipcode", false)
end if

dw_users.disable_zipcode_filter = not enable_zipcode_filter

if enable_zipcode_filter then
	// FOr now we can only use one filter at a time
	enable_distance_filter = false
	
	show_zipcode_filter()
else
	enable_distance_filter = datalist.get_preference_boolean("PREFERENCES", "Actor Filter Distance", false)
	ls_distance_filter = datalist.get_preference("PREFERENCES", "Actor Filter Default Distance")
	if isnull(ls_distance_filter) then ls_distance_filter = "10 Miles"
	
	f_split_string(ls_distance_filter, " ", ls_amount, ls_unit)
	if isnumber(ls_amount) and len(ls_unit) > 0 then
		// We have a valid filter
		dw_users.distance_filter_amount = long(ls_amount)
		if upper(left(ls_unit, 1)) = "K" then
			dw_users.distance_filter_unit = "Km"
		else
			dw_users.distance_filter_unit = "Mile"
		end if
	else
		dw_users.distance_filter_amount = 10
		dw_users.distance_filter_unit = "Mile"
	end if
end if

CHOOSE CASE upper(lstr_pick_users.search_option)
	CASE "SHORT LIST"
		dw_users.search_short_list()
		if dw_users.rowcount() <= 0 then
			dw_users.search_name("")
		end if
	CASE "BY NAME"
		dw_users.search_name(lstr_pick_users.user_name)
	CASE "BY ROLE"
		dw_users.search_by_role(lstr_pick_users.role_id)
		if dw_users.rowcount() <= 0 then
			dw_users.search_name("")
		end if
	CASE "CARE TEAM"
		dw_users.search_care_team()
		if dw_users.rowcount() <= 0 then
			dw_users.search_name("")
		end if
	CASE ELSE
		lb_default_to_care_team = datalist.get_preference_boolean("PREFERENCES", "Default to Care Team", true)
		if len(lstr_pick_users.cpr_id) > 0 and lb_default_to_care_team then
			dw_users.search_care_team()
		end if
		if dw_users.rowcount() <= 0 then
			dw_users.search_short_list()
		end if
		if dw_users.rowcount() <= 0 then
			dw_users.search_name("")
		end if
END CHOOSE

//	CASE "SPECIALTY"
//		if len(lstr_pick_users.specialty_id) > 0 then
//			dw_users.search_by_specialty(lstr_pick_users.specialty_id)
//		else
//			dw_users.function POST search_by_specialty()
//		end if
//	CASE "ROLE"
//		dw_users.search_role()
//	CASE "SYSTEM"
//		dw_users.search_system()
//	CASE "SPECIAL"
//		dw_users.search_special()
//	CASE "EDIT"
//		if not allow_multiple then
//			cb_cancel.text = "OK"
//			cb_cancel.weight = 700
//		end if
//		edit_mode = true
//		dw_users.search_top_20()
//		if dw_users.rowcount() <= 0 then
//			dw_users.search_name("")
//		end if
//	CASE ELSE
////		lb_default_to_care_team = datalist.get_preference_boolean("PREFERENCES", "Default to Care Team", true)
////		if st_care_team_list.visible and lb_default_to_care_team then
////			dw_users.search_care_team()
////		else
////			dw_users.search_top_20()
////			if dw_users.rowcount() <= 0 then
////				dw_users.search_name("")
////			end if
////		end if
//END CHOOSE

dw_selected_items.object.user_full_name.width = dw_users.width - 155

postevent("post_open")


end event

on w_pick_user.create
int iCurrent
call super::create
this.st_search_title=create st_search_title
this.pb_down_sel=create pb_down_sel
this.pb_up_sel=create pb_up_sel
this.st_page_sel=create st_page_sel
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
this.st_top_20=create st_top_20
this.st_byrole=create st_byrole
this.st_search_status=create st_search_status
this.dw_selected_items=create dw_selected_items
this.st_name=create st_name
this.dw_users=create dw_users
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.cb_new=create cb_new
this.st_user_status=create st_user_status
this.st_user_list=create st_user_list
this.st_role_list=create st_role_list
this.st_system_list=create st_system_list
this.st_special_list=create st_special_list
this.st_by_care_team=create st_by_care_team
this.st_actor_class_list=create st_actor_class_list
this.st_status_title=create st_status_title
this.st_specialty_filter_title=create st_specialty_filter_title
this.st_specialty_filter=create st_specialty_filter
this.st_primary_help=create st_primary_help
this.st_by_zip=create st_by_zip
this.st_zip_filter_title=create st_zip_filter_title
this.st_zip_filter=create st_zip_filter
this.st_distance_filter=create st_distance_filter
this.st_distance_filter_title=create st_distance_filter_title
this.st_zip_filter_disabled=create st_zip_filter_disabled
this.cb_zip_edit=create cb_zip_edit
this.st_selected_items=create st_selected_items
this.st_title=create st_title
this.st_2=create st_2
this.st_support=create st_support
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_search_title
this.Control[iCurrent+2]=this.pb_down_sel
this.Control[iCurrent+3]=this.pb_up_sel
this.Control[iCurrent+4]=this.st_page_sel
this.Control[iCurrent+5]=this.pb_up
this.Control[iCurrent+6]=this.pb_down
this.Control[iCurrent+7]=this.st_page
this.Control[iCurrent+8]=this.st_top_20
this.Control[iCurrent+9]=this.st_byrole
this.Control[iCurrent+10]=this.st_search_status
this.Control[iCurrent+11]=this.dw_selected_items
this.Control[iCurrent+12]=this.st_name
this.Control[iCurrent+13]=this.dw_users
this.Control[iCurrent+14]=this.cb_ok
this.Control[iCurrent+15]=this.cb_cancel
this.Control[iCurrent+16]=this.cb_new
this.Control[iCurrent+17]=this.st_user_status
this.Control[iCurrent+18]=this.st_user_list
this.Control[iCurrent+19]=this.st_role_list
this.Control[iCurrent+20]=this.st_system_list
this.Control[iCurrent+21]=this.st_special_list
this.Control[iCurrent+22]=this.st_by_care_team
this.Control[iCurrent+23]=this.st_actor_class_list
this.Control[iCurrent+24]=this.st_status_title
this.Control[iCurrent+25]=this.st_specialty_filter_title
this.Control[iCurrent+26]=this.st_specialty_filter
this.Control[iCurrent+27]=this.st_primary_help
this.Control[iCurrent+28]=this.st_by_zip
this.Control[iCurrent+29]=this.st_zip_filter_title
this.Control[iCurrent+30]=this.st_zip_filter
this.Control[iCurrent+31]=this.st_distance_filter
this.Control[iCurrent+32]=this.st_distance_filter_title
this.Control[iCurrent+33]=this.st_zip_filter_disabled
this.Control[iCurrent+34]=this.cb_zip_edit
this.Control[iCurrent+35]=this.st_selected_items
this.Control[iCurrent+36]=this.st_title
this.Control[iCurrent+37]=this.st_2
this.Control[iCurrent+38]=this.st_support
end on

on w_pick_user.destroy
call super::destroy
destroy(this.st_search_title)
destroy(this.pb_down_sel)
destroy(this.pb_up_sel)
destroy(this.st_page_sel)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
destroy(this.st_top_20)
destroy(this.st_byrole)
destroy(this.st_search_status)
destroy(this.dw_selected_items)
destroy(this.st_name)
destroy(this.dw_users)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.cb_new)
destroy(this.st_user_status)
destroy(this.st_user_list)
destroy(this.st_role_list)
destroy(this.st_system_list)
destroy(this.st_special_list)
destroy(this.st_by_care_team)
destroy(this.st_actor_class_list)
destroy(this.st_status_title)
destroy(this.st_specialty_filter_title)
destroy(this.st_specialty_filter)
destroy(this.st_primary_help)
destroy(this.st_by_zip)
destroy(this.st_zip_filter_title)
destroy(this.st_zip_filter)
destroy(this.st_distance_filter)
destroy(this.st_distance_filter_title)
destroy(this.st_zip_filter_disabled)
destroy(this.cb_zip_edit)
destroy(this.st_selected_items)
destroy(this.st_title)
destroy(this.st_2)
destroy(this.st_support)
end on

event post_open;call super::post_open;
dw_selected_items.set_page(1, pb_up_sel, pb_down_sel, st_page_sel)


end event

type pb_epro_help from w_window_base`pb_epro_help within w_pick_user
integer x = 2830
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pick_user
end type

type st_search_title from statictext within w_pick_user
integer x = 1824
integer y = 388
integer width = 558
integer height = 88
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Search Options"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_down_sel from u_picture_button within w_pick_user
integer x = 2651
integer y = 1052
integer width = 137
integer height = 116
integer taborder = 10
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_selected_items.current_page
li_last_page = dw_selected_items.last_page

dw_selected_items.set_page(li_page + 1, st_page_sel.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up_sel.enabled = true

end event

type pb_up_sel from u_picture_button within w_pick_user
integer x = 2651
integer y = 924
integer width = 137
integer height = 116
integer taborder = 10
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_selected_items.current_page

dw_selected_items.set_page(li_page - 1, st_page_sel.text)

if li_page <= 2 then enabled = false
pb_down_sel.enabled = true

end event

type st_page_sel from statictext within w_pick_user
integer x = 2651
integer y = 1176
integer width = 137
integer height = 116
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Page 99/99"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_up from u_picture_button within w_pick_user
integer x = 1367
integer y = 116
integer width = 137
integer height = 116
integer taborder = 20
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_users.current_page

dw_users.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_pick_user
integer x = 1367
integer y = 240
integer width = 137
integer height = 116
integer taborder = 10
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_users.current_page
li_last_page = dw_users.last_page

dw_users.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type st_page from statictext within w_pick_user
integer x = 1371
integer y = 360
integer width = 270
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Page 99/99"
boolean focusrectangle = false
end type

type st_top_20 from statictext within w_pick_user
integer x = 1376
integer y = 492
integer width = 352
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Short List"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if upper(search_type) = "SHORT LIST" then
	if dw_users.search_description = "Personal List" then
		dw_users.search_short_list(false)
	else
		dw_users.search_short_list(true)
	end if
else
	if dw_users.search_description = "Personal List" then
		dw_users.search_short_list(true)
	else
		dw_users.search_short_list(false)
	end if
end if


end event

type st_byrole from statictext within w_pick_user
integer x = 2117
integer y = 492
integer width = 352
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "By Role"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_users.search_by_role()

end event

type st_search_status from statictext within w_pick_user
integer x = 1376
integer y = 632
integer width = 1458
integer height = 88
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type dw_selected_items from u_dw_pick_list within w_pick_user
integer x = 1481
integer y = 928
integer width = 1157
integer height = 460
integer taborder = 20
string dataobject = "dw_selected_users"
boolean vscrollbar = true
end type

event post_click(long clicked_row);call super::post_click;If clicked_row <= 0 Then Return

deleterow(clicked_row)

last_page = 0
recalc_page(pb_up_sel, pb_down_sel, st_page_sel)


end event

type st_name from statictext within w_pick_user
integer x = 1746
integer y = 492
integer width = 352
integer height = 108
integer taborder = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "By Name"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_users.search_name()

end event

type dw_users from u_dw_user_list within w_pick_user
integer x = 14
integer y = 108
integer width = 1344
integer height = 1576
integer taborder = 90
string dataobject = "dw_pick_top20_user"
boolean vscrollbar = true
boolean select_computed = false
end type

event users_loaded;call super::users_loaded;real lr_amount

search_type = current_search

st_search_status.text = ps_description

if user_status = "OK" then
	st_user_status.text = "Active"
else
	st_user_status.text = "Inactive"
end if

// Turn off all the actor class buttons
st_user_list.backcolor = color_object
st_role_list.backcolor = color_object
st_system_list.backcolor = color_object
st_special_list.backcolor = color_object
st_actor_class_list.backcolor = color_object
st_support.backcolor = color_object

if len(pick_actor_class) > 0 then
	st_actor_class_list.visible = true
	st_actor_class_list.text = wordcap(pick_actor_class)
	st_actor_class_list.borderstyle = StyleRaised!
	st_actor_class_list.enabled = true
else
	st_actor_class_list.visible = false
end if

CHOOSE CASE lower(actor_class)
	CASE "user"
		st_user_list.backcolor = color_object_selected

		// New button
		cb_new.visible = allow_editing
		cb_new.text = "New User"
		
		// Enable/disable buttons
		st_top_20.visible = true
		st_name.visible = true
		st_byrole.visible = true
		st_by_zip.visible = false
		if len(pick_users.cpr_id) > 0 then
			st_by_care_team.visible = true
		else
			st_by_care_team.visible = false
		end if
		st_zip_filter_title.visible = false
		st_zip_filter.visible = false
		st_distance_filter_title.visible = false
		st_distance_filter.visible = false
		st_specialty_filter_title.visible = false
		st_specialty_filter.visible = false
	CASE "role"
		st_role_list.backcolor = color_object_selected
		
		// New button
		cb_new.visible = allow_editing
		cb_new.text = "New Role"
		
		// Enable/disable buttons
		st_top_20.visible = true
		st_name.visible = true
		st_byrole.visible = false
		st_by_zip.visible = false
		st_by_care_team.visible = false
		st_zip_filter_title.visible = false
		st_zip_filter.visible = false
		st_distance_filter_title.visible = false
		st_distance_filter.visible = false
		st_specialty_filter_title.visible = false
		st_specialty_filter.visible = false
	CASE "system"
		st_system_list.backcolor = color_object_selected
		
		// New button
		cb_new.visible = false
		
		// Enable/disable buttons
		st_top_20.visible = true
		st_name.visible = true
		st_byrole.visible = false
		st_by_zip.visible = false
		st_by_care_team.visible = false
		st_zip_filter_title.visible = false
		st_zip_filter.visible = false
		st_distance_filter_title.visible = false
		st_distance_filter.visible = false
		st_specialty_filter_title.visible = false
		st_specialty_filter.visible = false
	CASE "special"
		st_special_list.backcolor = color_object_selected
		
		// New button
		cb_new.visible = false
		
		// Enable/disable buttons
		st_top_20.visible = true
		st_name.visible = true
		st_byrole.visible = false
		st_by_zip.visible = false
		st_by_care_team.visible = false
		st_zip_filter_title.visible = false
		st_zip_filter.visible = false
		st_distance_filter_title.visible = false
		st_distance_filter.visible = false
		st_specialty_filter_title.visible = false
		st_specialty_filter.visible = false
	CASE "support provider"
		st_support.visible = true
		st_support.backcolor = color_object_selected
		
		// New button
		cb_new.visible = allow_editing
		cb_new.text = "New " + wordcap(actor_class)
		
		// Enable/disable buttons
		st_top_20.visible = true
		st_name.visible = true
		st_byrole.visible = false
		st_by_zip.visible = false
		st_by_care_team.visible = false
		st_zip_filter_title.visible = false
		st_zip_filter.visible = false
		st_distance_filter_title.visible = false
		st_distance_filter.visible = false
		
		st_specialty_filter_title.visible = true
		st_specialty_filter.visible = true
		
		if len(specialty_id) > 0 then
			st_specialty_filter.text = datalist.specialty_description(specialty_id)
		else
			st_specialty_filter.text = "<All>"
		end if

		// If a specialty was passed in then we don't allow changes
		if len(pick_users.specialty_id) > 0 then
			st_specialty_filter.borderstyle = stylebox!
			st_specialty_filter.enabled = false
		else
			st_specialty_filter.borderstyle = styleraised!
			st_specialty_filter.enabled = true
		end if
	CASE ELSE
		// Any other actor class is handled by the st_actor_class_list button
		st_actor_class_list.visible = true
		st_actor_class_list.text = wordcap(actor_class)
		st_actor_class_list.backcolor = color_object_selected
		if lower(actor_class) = lower(pick_actor_class) then
			st_actor_class_list.borderstyle = StyleRaised!
			st_actor_class_list.enabled = true
		else
			st_actor_class_list.borderstyle = StyleBox!
			st_actor_class_list.enabled = false
		end if
		
		// New button
		cb_new.visible = allow_editing
		cb_new.text = "New " + wordcap(actor_class)
		
		// Enable/disable buttons
		st_top_20.visible = true
		st_name.visible = true
		st_byrole.visible = false
		st_by_zip.visible = true
		if len(pick_users.cpr_id) > 0 then
			st_by_care_team.visible = true
		else
			st_by_care_team.visible = false
		end if
		if upper(current_search) = "BY NAME" then
			st_zip_filter_title.visible = enable_zipcode_filter
			st_zip_filter.visible = enable_zipcode_filter
			st_distance_filter_title.visible = enable_distance_filter
			st_distance_filter.visible = enable_distance_filter
			if not isnull(distance_filter_amount) and not isnull(distance_filter_unit) then
				lr_amount = real(distance_filter_amount)
				st_distance_filter.text = f_pretty_amount_unit(lr_amount, distance_filter_unit)
			else
				st_distance_filter.text = "<All>"
			end if
		else
			st_zip_filter_title.visible = false
			st_zip_filter.visible = false
			st_distance_filter_title.visible = false
			st_distance_filter.visible = false
		end if

		// For now, only allow the specialty filter for consultants
		if lower(actor_class) = "consultant" then
			st_specialty_filter_title.visible = true
			st_specialty_filter.visible = true
			
			if len(specialty_id) > 0 then
				st_specialty_filter.text = datalist.specialty_description(specialty_id)
			else
				st_specialty_filter.text = "<All>"
			end if
	
			// If a specialty was passed in then we don't allow changes
			if len(pick_users.specialty_id) > 0 then
				st_specialty_filter.borderstyle = stylebox!
				st_specialty_filter.enabled = false
			else
				st_specialty_filter.borderstyle = styleraised!
				st_specialty_filter.enabled = true
			end if
		else
			st_specialty_filter_title.visible = false
			st_specialty_filter.visible = false
		end if
END CHOOSE

st_primary_help.visible = st_by_care_team.visible

// If the zip filter is enabled but the flag says disabled, then show the disabled button instead
if st_zip_filter.visible then
	if this.disable_zipcode_filter then
		st_zip_filter.visible = false
		st_zip_filter_disabled.visible = true
		cb_zip_edit.visible = false
	elseif user_list.is_user_privileged(current_user.user_id, "Office Preferences") then
		cb_zip_edit.visible = true
	else
		cb_zip_edit.visible = false
	end if
else
	st_zip_filter_disabled.visible = false
	cb_zip_edit.visible = false
end if

// Turn off all the search by buttons
st_top_20.backcolor = color_object
st_name.backcolor = color_object
st_byrole.backcolor = color_object
st_by_zip.backcolor = color_object
st_by_care_team.backcolor = color_object

// Turn on the selected search by button
CHOOSE CASE upper(current_search)
	CASE "SHORT LIST"
		st_top_20.backcolor = color_object_selected
	CASE "BY NAME"
		st_name.backcolor = color_object_selected
	CASE "BY ROLE"
		st_byrole.backcolor = color_object_selected
	CASE "BY ZIP"
		st_by_zip.backcolor = color_object_selected
	CASE "CARE TEAM"
		st_by_care_team.backcolor = color_object_selected
END CHOOSE

set_page(1, pb_up, pb_down, st_page)


end event

event selected;call super::selected;string ls_user_id
str_users lstr_users
str_popup popup

if current_search = "SHORT LIST" then
	ls_user_id = object.search_user_id[selected_row]
else
	ls_user_id = object.user_id[selected_row]
end if

if edit_mode then
	if left(ls_user_id, 1) = "!" then
		popup.item = ls_user_id
		openwithparm(w_role_definition, popup)
	else
		popup.data_row_count = 1
		popup.items[1] = ls_user_id
		openwithparm(w_user_definition, popup)
	end if
	refresh()
else
	if lastcolumnname = "user_full_name" or lastcolumnname = "specialty_description" or lastcolumnname = "pretty_address" then
		select_user(ls_user_id)
	end if
end if

end event

type cb_ok from commandbutton within w_pick_user
integer x = 2386
integer y = 1548
integer width = 402
integer height = 112
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;str_users lstr_users
long i

lstr_users.user_count = dw_selected_items.rowcount()

for i = 1 to lstr_users.user_count
	lstr_users.user[i].user_id = dw_selected_items.object.user_id[i]
	lstr_users.user[i].user_full_name = dw_selected_items.object.user_full_name[i]
	lstr_users.user[i].user_short_name = dw_selected_items.object.user_short_name[i]
	lstr_users.user[i].color = dw_selected_items.object.color[i]
next

closewithreturn(parent, lstr_users)


end event

type cb_cancel from commandbutton within w_pick_user
integer x = 1481
integer y = 1548
integer width = 402
integer height = 112
integer taborder = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;str_users lstr_users

lstr_users.user_count = 0

closewithreturn(parent, lstr_users)

end event

type cb_new from commandbutton within w_pick_user
integer x = 2226
integer y = 1420
integer width = 471
integer height = 88
integer taborder = 110
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New User"
end type

event clicked;str_popup popup
string ls_user_id
str_popup_return popup_return
string ls_message
string ls_patient_name
integer li_sts
long ll_null
datetime ldt_null


setnull(ll_null)
setnull(ldt_null)

ls_user_id = user_list.new_user(dw_users.actor_class)

if isnull(ls_user_id) or ls_user_id = "" then return

// Set the specialty
if len(dw_users.specialty_id) > 0 then
	user_list.set_user_progress(ls_user_id, "Modify", "specialty_id", dw_users.specialty_id)
end if

select_user(ls_user_id)


end event

type st_user_status from statictext within w_pick_user
integer x = 1609
integer y = 1428
integer width = 293
integer height = 88
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Inactive Users"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if dw_users.user_status = "OK" then
	dw_users.user_status = "NA"
else
	dw_users.user_status = "OK"
end if

refresh()

end event

type st_user_list from statictext within w_pick_user
integer x = 1655
integer y = 164
integer width = 475
integer height = 92
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Users"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_users.set_actor_class("User")

dw_users.search_short_list()
if dw_users.rowcount() <= 0 then
	dw_users.search_name("")
end if


end event

type st_role_list from statictext within w_pick_user
integer x = 1687
integer y = 276
integer width = 288
integer height = 92
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Roles"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_users.set_actor_class("Role")

dw_users.search_short_list()
if dw_users.rowcount() <= 0 then
	dw_users.search_name("")
end if



end event

type st_system_list from statictext within w_pick_user
integer x = 1998
integer y = 276
integer width = 288
integer height = 92
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "System"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_users.set_actor_class("System")
dw_users.user_status = "OK"

dw_users.search_short_list()
if dw_users.rowcount() <= 0 then
	dw_users.search_name("")
end if



end event

type st_special_list from statictext within w_pick_user
integer x = 2309
integer y = 276
integer width = 288
integer height = 92
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Special"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_users.set_actor_class("Special")
dw_users.user_status = "OK"

dw_users.search_short_list()
if dw_users.rowcount() <= 0 then
	dw_users.search_name("")
end if



end event

type st_by_care_team from statictext within w_pick_user
integer x = 2487
integer y = 492
integer width = 352
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Care Team"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_users.user_status = "OK"
dw_users.search_care_team()


end event

type st_actor_class_list from statictext within w_pick_user
integer x = 2158
integer y = 164
integer width = 475
integer height = 92
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Consultants"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;
dw_users.set_actor_class(pick_actor_class)

dw_users.search_short_list()
if dw_users.rowcount() <= 0 then
	dw_users.search_name("")
end if



end event

type st_status_title from statictext within w_pick_user
integer x = 1394
integer y = 1440
integer width = 206
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Status:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_specialty_filter_title from statictext within w_pick_user
integer x = 2025
integer y = 756
integer width = 251
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
string text = "Specialty:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_specialty_filter from statictext within w_pick_user
integer x = 2290
integer y = 748
integer width = 549
integer height = 84
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "<All>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_specialty_id

openwithparm(w_pick_specialty, "<All>")
ls_specialty_id = message.stringparm


if len(ls_specialty_id) > 0 then
	if ls_specialty_id = "<All>" then
		setnull(dw_users.specialty_id)
	else
		dw_users.specialty_id = ls_specialty_id
	end if
else
	return
end if

dw_users.search_short_list()
if dw_users.rowcount() <= 0 then
	dw_users.search_name("")
end if


end event

type st_primary_help from statictext within w_pick_user
integer x = 2528
integer y = 428
integer width = 274
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "* = Primary"
boolean focusrectangle = false
end type

type st_by_zip from statictext within w_pick_user
boolean visible = false
integer x = 2117
integer y = 492
integer width = 352
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "By Zip"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_users.search_by_zip()

end event

type st_zip_filter_title from statictext within w_pick_user
integer x = 1385
integer y = 756
integer width = 114
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
string text = "Zip:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_zip_filter from statictext within w_pick_user
integer x = 1509
integer y = 748
integer width = 503
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "30328"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_users.disable_zipcode_filter = NOT dw_users.disable_zipcode_filter
refresh()

end event

type st_distance_filter from statictext within w_pick_user
integer x = 1650
integer y = 748
integer width = 325
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "100 Miles"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_filter
string ls_amount
string ls_unit
str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_domain_notranslate_list"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = "Distance Filter"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_filter = popup_return.items[1]

f_split_string(ls_filter, " ", ls_amount, ls_unit)
if isnumber(ls_amount) and len(ls_unit) > 0 then
	// We have a valid filter
	dw_users.distance_filter_amount = long(ls_amount)
	dw_users.distance_filter_unit = ls_unit
else
	setnull(dw_users.distance_filter_amount)
	setnull(dw_users.distance_filter_unit)
end if

refresh()

end event

type st_distance_filter_title from statictext within w_pick_user
integer x = 1385
integer y = 756
integer width = 256
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
string text = "Distance:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_zip_filter_disabled from statictext within w_pick_user
boolean visible = false
integer x = 1509
integer y = 748
integer width = 503
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Disabled"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_users.disable_zipcode_filter = NOT dw_users.disable_zipcode_filter
refresh()

end event

type cb_zip_edit from commandbutton within w_pick_user
integer x = 1509
integer y = 836
integer width = 155
integer height = 60
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Edit"
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_zipcodes
long i
string ls_text
long ll_count
string lsa_zipcodes[]
long ll_good_count
string lsa_good_zipcodes[]

popup.title = "Enter ZipCodes, seperated by commas"
popup.item = st_zip_filter.text
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ll_count = f_parse_string(popup_return.items[1], ",", lsa_zipcodes)

ll_good_count = 0
for i = 1 to ll_count
	if len(trim(lsa_zipcodes[i])) = 5 then
		ll_good_count += 1
		lsa_good_zipcodes[ll_good_count] = trim(lsa_zipcodes[i])
	end if
next

if ll_good_count = 0 then
	openwithparm(w_pop_message, "No valid zip codes found.")
	return
end if


DELETE FROM c_Domain
WHERE domain_id = :zipcode_filter_domain_id;
if not tf_check() then return

ls_text = ""
for i = 1 to ll_good_count
	INSERT INTO c_Domain (
		domain_id,
		domain_sequence,
		domain_item)
	VALUES (
		:zipcode_filter_domain_id,
		:i,
		:lsa_good_zipcodes[i]);
	if not tf_check() then return

	if len(ls_text) > 0 then ls_text += ", "
	ls_text += lsa_good_zipcodes[i]
next

show_zipcode_filter( )

refresh()

end event

type st_selected_items from statictext within w_pick_user
integer x = 1481
integer y = 848
integer width = 1157
integer height = 76
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Selected Users"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title from statictext within w_pick_user
integer width = 2926
integer height = 108
boolean bringtotop = true
integer textsize = -14
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_pick_user
integer x = 1874
integer y = 92
integer width = 558
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Actor Type"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_support from statictext within w_pick_user
integer x = 2158
integer y = 276
integer width = 475
integer height = 92
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Support Provider"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;
dw_users.set_actor_class("Support Provider")

dw_users.search_short_list()
if dw_users.rowcount() <= 0 then
	dw_users.search_name("")
end if



end event

