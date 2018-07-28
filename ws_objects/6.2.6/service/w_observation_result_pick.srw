HA$PBExportHeader$w_observation_result_pick.srw
forward
global type w_observation_result_pick from w_window_base
end type
type pb_down from picturebutton within w_observation_result_pick
end type
type pb_up from picturebutton within w_observation_result_pick
end type
type dw_pick from u_dw_pick_list within w_observation_result_pick
end type
type st_page from statictext within w_observation_result_pick
end type
type st_title from statictext within w_observation_result_pick
end type
type cb_ok from commandbutton within w_observation_result_pick
end type
end forward

global type w_observation_result_pick from w_window_base
integer x = 741
integer width = 1769
integer height = 1920
windowtype windowtype = response!
pb_down pb_down
pb_up pb_up
dw_pick dw_pick
st_page st_page
st_title st_title
cb_ok cb_ok
end type
global w_observation_result_pick w_observation_result_pick

type variables
u_component_treatment treatment
long observation_sequence
string observation_id
integer result_sequence
string location
string view
string result_type

boolean use_as_defaults

u_ds_observation_results results

end variables

forward prototypes
public function integer display_results ()
public function integer refresh_results ()
public function integer refresh_row (long pl_row)
end prototypes

public function integer display_results ();string ls_bitmap
integer li_sts
long ll_rowcount
integer li_selected_flag
long ll_row
long ll_result_count
string ls_perform_location_domain
long i
long ll_location_count
string ls_abnormal_flag
string ls_abnormal_nature
str_observation_results lstr_results
string lsa_location[]
string lsa_location_description[]
string ls_description

setnull(ls_abnormal_nature)
ls_perform_location_domain = datalist.observation_perform_location_domain(observation_id)

if view = "R" then
	ll_location_count = datalist.locations_in_domain(ls_perform_location_domain, lsa_location, lsa_location_description)
	
	for i = 1 to ll_location_count
		ll_row = dw_pick.insertrow(0)
		dw_pick.object.description[ll_row] = lsa_location_description[i]
		dw_pick.object.base_description[ll_row] = lsa_location_description[i]
		dw_pick.object.location[ll_row] = lsa_location[i]
		dw_pick.object.result_sequence[ll_row] = result_sequence
	next
else
	lstr_results = datalist.observation_results(observation_id)
	
	for i = 1 to lstr_results.result_count
		if lstr_results.result[i].result_type = result_type then
			ll_row = dw_pick.insertrow(0)
			dw_pick.object.description[ll_row] = lstr_results.result[i].result
			dw_pick.object.base_description[ll_row] = lstr_results.result[i].result
			dw_pick.object.location[ll_row] = location
			dw_pick.object.result_sequence[ll_row] = lstr_results.result[i].result_sequence
			ls_bitmap = datalist.domain_item_bitmap("RESULTSEVERITY", string(lstr_results.result[i].severity))
			if isnull(ls_bitmap) then ls_bitmap = "result_0.bmp"
			dw_pick.object.icon[ll_row] = ls_bitmap
		end if
	next
end if


return 1


end function

public function integer refresh_results ();string ls_location
integer li_result_sequence
string ls_result_amount
long ll_rows
long ll_rowcount
long i
integer li_sts
string ls_find
long ll_row
string ls_description

ll_rows = results.retrieve(current_patient.cpr_id, treatment.treatment_id)

ll_rowcount = dw_pick.rowcount()

for i = 1 to ll_rowcount
	refresh_row(i)
next

dw_pick.set_page(1, pb_up, pb_down, st_page)

return 1


end function

public function integer refresh_row (long pl_row);string ls_location
integer li_result_sequence
string ls_result_amount
long ll_rows
long ll_rowcount
integer li_sts
string ls_find
long ll_row
string ls_description

ll_rows = results.rowcount()

// Get the location and result_sequence
ls_location = dw_pick.object.location[pl_row]
li_result_sequence = dw_pick.object.result_sequence[pl_row]

// Set the selected flag
ls_find = "observation_sequence=" + string(observation_sequence)
ls_find += " and location='" + ls_location + "'"
ls_find += " and result_sequence=" + string(li_result_sequence)
ls_find += " and record_type='Result'"
ll_row = results.find(ls_find, 1, ll_rows)
if ll_row > 0 then
	dw_pick.object.selected_flag[pl_row] = 1
else
	dw_pick.object.selected_flag[pl_row] = 0
end if

// See if there's any result amount to display
ls_result_amount = ""
li_sts = results.display_observation_result(observation_id, &
															result_type, &
															"N", &
															ls_location, &
															li_result_sequence, &
															false, &
															true, &
															true, &
															ls_result_amount)

if len(ls_result_amount) > 0 then
	ls_description = ls_result_amount
else
	ls_description = dw_pick.object.base_description[pl_row]
end if

dw_pick.object.description[pl_row] = ls_description

return 1


end function

event open;call super::open;str_popup popup
string ls_exclusive_flag
str_c_observation_result lstr_result
boolean lb_title

popup = message.powerobjectparm

if popup.data_row_count <> 5 then
	log.log(this, "open", "Invalid Parameters", 4)
	close(this)
	return
end if

treatment = popup.objectparm
observation_sequence = long(popup.items[1])
observation_id = popup.items[2]
view = popup.items[3]
result_type = popup.items[5]

if isnull(popup.title) or trim(popup.title) = "" then
	lb_title = true
	st_title.text = datalist.observation_description(observation_id)
else
	lb_title = false
	st_title.text = popup.title
end if

if view = "R" then
	result_sequence = integer(popup.items[4])
	lstr_result = datalist.observation_result(observation_id, result_sequence)
	if lb_title then st_title.text += " - " + lstr_result.result
else
	location = popup.items[4]
	if lb_title then st_title.text += " - " + datalist.location_description(location)
end if

ls_exclusive_flag = datalist.observation_exclusive_flag(observation_id)
if ls_exclusive_flag = "Y" then
	dw_pick.multiselect = false
else
	dw_pick.multiselect = true
end if

results = CREATE u_ds_observation_results
results.set_dataobject("dw_sp_obstree_treatment")

display_results()

refresh_results()

use_as_defaults = false

setfocus()

end event

on w_observation_result_pick.create
int iCurrent
call super::create
this.pb_down=create pb_down
this.pb_up=create pb_up
this.dw_pick=create dw_pick
this.st_page=create st_page
this.st_title=create st_title
this.cb_ok=create cb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_down
this.Control[iCurrent+2]=this.pb_up
this.Control[iCurrent+3]=this.dw_pick
this.Control[iCurrent+4]=this.st_page
this.Control[iCurrent+5]=this.st_title
this.Control[iCurrent+6]=this.cb_ok
end on

on w_observation_result_pick.destroy
call super::destroy
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.dw_pick)
destroy(this.st_page)
destroy(this.st_title)
destroy(this.cb_ok)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_observation_result_pick
boolean visible = true
integer x = 59
integer y = 1696
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_observation_result_pick
end type

type pb_down from picturebutton within w_observation_result_pick
integer x = 1563
integer y = 408
integer width = 137
integer height = 116
integer taborder = 30
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;dw_pick.set_page(dw_pick.current_page + 1, st_page.text)

end event

type pb_up from picturebutton within w_observation_result_pick
integer x = 1563
integer y = 276
integer width = 137
integer height = 116
integer taborder = 20
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;dw_pick.set_page(dw_pick.current_page - 1, st_page.text)

end event

type dw_pick from u_dw_pick_list within w_observation_result_pick
integer x = 14
integer y = 268
integer width = 1545
integer height = 1380
integer taborder = 10
string dataobject = "dw_observation_result_pick"
boolean border = false
end type

event selected;integer li_result_sequence
string ls_location
string ls_description
integer li_sts
long ll_rows

li_result_sequence = object.result_sequence[selected_row]
ls_location = object.location[selected_row]

li_sts = treatment.set_result(observation_sequence, li_result_sequence, ls_location)
if li_sts <= 0 then return

ll_rows = results.retrieve(current_patient.cpr_id, treatment.treatment_id)

refresh_row(selected_row)



end event

event unselected;call super::unselected;integer li_result_sequence
string ls_location
string ls_description
integer li_sts
long ll_rows

li_result_sequence = object.result_sequence[unselected_row]
ls_location = object.location[unselected_row]

li_sts = treatment.remove_result(observation_sequence, li_result_sequence, ls_location)
if li_sts <= 0 then return

ll_rows = results.retrieve(current_patient.cpr_id, treatment.treatment_id)

refresh_row(unselected_row)


end event

type st_page from statictext within w_observation_result_pick
integer x = 1568
integer y = 536
integer width = 133
integer height = 112
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

type st_title from statictext within w_observation_result_pick
integer x = 5
integer y = 12
integer width = 1728
integer height = 248
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_observation_result_pick
integer x = 1271
integer y = 1688
integer width = 402
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;
 DECLARE lsp_set_loc_as_default PROCEDURE FOR dbo.sp_set_loc_as_default  
         @ps_cpr_id = :current_patient.cpr_id,   
         @pl_encounter_id = :current_patient.open_encounter_id,   
         @pl_treatment_id = :treatment.treatment_id,   
         @ps_observation_id = :observation_id,   
         @ps_location = :location,   
         @ps_user_id = :current_user.user_id  ;

if use_as_defaults then
	EXECUTE lsp_set_loc_as_default;
	if not tf_check() then close(parent)
end if

close(parent)
end event

