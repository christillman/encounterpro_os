$PBExportHeader$u_timeline_results.sru
forward
global type u_timeline_results from userobject
end type
type uo_timeline from u_timeline_horizontal within u_timeline_results
end type
type cb_scroll_left from commandbutton within u_timeline_results
end type
type cb_scroll_right from commandbutton within u_timeline_results
end type
type gr_observations from u_gr_observation_results within u_timeline_results
end type
end forward

global type u_timeline_results from userobject
integer width = 2569
integer height = 1516
boolean border = true
long backcolor = 12632256
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
uo_timeline uo_timeline
cb_scroll_left cb_scroll_left
cb_scroll_right cb_scroll_right
gr_observations gr_observations
end type
global u_timeline_results u_timeline_results

type variables
String	observation_id
integer observation_count
str_observation_result_location observations[]

boolean first_time = true

end variables

forward prototypes
public function integer initialize ()
public function integer refresh ()
public function integer set_obj_list (string ps_observation_id)
public function string get_default_obj_list ()
end prototypes

public function integer initialize ();long ll_rightgap
integer li_sts
date ld_null

setnull(ld_null)

uo_timeline.width = width - 338
uo_timeline.height = 150
uo_timeline.x = 188
uo_timeline.y = height - uo_timeline.height - 20

gr_observations.x = 0
gr_observations.y = 0
gr_observations.width = width
gr_observations.height = uo_timeline.y

cb_scroll_left.x = (uo_timeline.x - cb_scroll_left.width) / 2
cb_scroll_left.y = uo_timeline.y
cb_scroll_left.height = uo_timeline.height

ll_rightgap = (width - uo_timeline.x - uo_timeline.width - cb_scroll_right.width ) / 2
cb_scroll_right.x = width - cb_scroll_right.width - ll_rightgap
cb_scroll_right.y = uo_timeline.y
cb_scroll_right.height = uo_timeline.height

uo_timeline.initialize()
if li_sts <= 0 then return -1

return 1


end function

public function integer refresh ();String ls_observation_id
date ld_null

setnull(ld_null)

if first_time then
	ls_observation_id = get_default_obj_list()
	if Not Isnull(ls_observation_id) then set_obj_list(ls_observation_id)
	uo_timeline.set_years(ld_null)
	first_time = false
end if

return 1



end function

public function integer set_obj_list (string ps_observation_id);integer i
str_observation_result_location lstr_observations[]
u_ds_data luo_data
string ls_title

observation_id = ps_observation_id

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_obj_list_item_list")

SELECT description
INTO :ls_title
FROM c_Observation
WHERE observation_id = :observation_id;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	log.log(this, "u_timeline_results.set_obj_list.0017", "Objective list not found (" + observation_id + ")", 3)
	return -1
end if

// If this obj_list doesn't have any constituents, then don't show the graph
observation_count = luo_data.retrieve(observation_id)
if observation_count = 0 then
	gr_observations.reset(All!)
else
	for i = 1 to observation_count
		lstr_observations[i].observation_id = luo_data.object.observation_id[i]
		lstr_observations[i].result_sequence = luo_data.object.result_sequence[i]
		lstr_observations[i].location = luo_data.object.location[i]
		lstr_observations[i].name = luo_data.object.description[i]
	next

	gr_observations.initialize(ls_title, observation_count, lstr_observations)
end if

DESTROY luo_data


return 1


end function

public function string get_default_obj_list ();String ls_observation_id,ls_null

Setnull(ls_null)

 DECLARE lsp_get_obj_list_selection PROCEDURE FOR dbo.sp_get_obj_list_selection  
         @ps_user_id = :current_user.user_id,   
         @ps_root_category = 'GRAPH',   
         @ps_observation_id = :ls_observation_id OUT  ;


EXECUTE lsp_get_obj_list_selection;
if not tf_check() then return ls_null

FETCH lsp_get_obj_list_selection INTO :ls_observation_id;
if not tf_check() then return ls_null

CLOSE lsp_get_obj_list_selection;

return ls_observation_id


end function

on u_timeline_results.create
this.uo_timeline=create uo_timeline
this.cb_scroll_left=create cb_scroll_left
this.cb_scroll_right=create cb_scroll_right
this.gr_observations=create gr_observations
this.Control[]={this.uo_timeline,&
this.cb_scroll_left,&
this.cb_scroll_right,&
this.gr_observations}
end on

on u_timeline_results.destroy
destroy(this.uo_timeline)
destroy(this.cb_scroll_left)
destroy(this.cb_scroll_right)
destroy(this.gr_observations)
end on

type uo_timeline from u_timeline_horizontal within u_timeline_results
event destroy ( )
integer x = 155
integer y = 1292
integer width = 2231
integer taborder = 20
end type

on uo_timeline.destroy
call u_timeline_horizontal::destroy
end on

event date_selected;str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
long ll_total_days
long ll_zoom
date ld_begin_date
date ld_end_date


if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Show Years"
	popup.button_titles[popup.button_count] = "Show Years"
	buttons[popup.button_count] = "YEARS"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Show Quarters"
	popup.button_titles[popup.button_count] = "Show Quarters"
	buttons[popup.button_count] = "QUARTERS"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Show Months"
	popup.button_titles[popup.button_count] = "Show Months"
	buttons[popup.button_count] = "MONTHS"
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
	CASE "YEARS"
		uo_timeline.set_years(date_selected)
	CASE "QUARTERS"
		uo_timeline.set_quarters(date_selected)
	CASE "MONTHS"
		uo_timeline.set_months(date_selected)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE


return






end event

event date_range_changed;gr_observations.refresh(new_begin_date, new_end_date)

end event

type cb_scroll_left from commandbutton within u_timeline_results
integer x = 9
integer y = 1268
integer width = 128
integer height = 196
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<<"
end type

event clicked;uo_timeline.scroll_left()

end event

type cb_scroll_right from commandbutton within u_timeline_results
integer x = 2400
integer y = 1280
integer width = 123
integer height = 196
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">>"
end type

event clicked;uo_timeline.scroll_right()

end event

type gr_observations from u_gr_observation_results within u_timeline_results
integer width = 2565
boolean enabled = true
end type

event clicked;str_popup popup
integer li_sts
str_picked_observations lstr_observations
string ls_treatment_type,ls_observation_id
w_pick_observations lw_pick

// If no objective lists, then let the user select a new one

Setnull(ls_treatment_type)

popup.data_row_count = 4
popup.items[1] = ls_treatment_type
popup.items[2] = current_user.specialty_id
popup.items[3] = "GRAPH"
popup.items[4] = "Y"
popup.multiselect = false
openwithparm(lw_pick, popup, "w_pick_observations")
lstr_observations = message.powerobjectparm
If  lstr_observations.observation_count <> 1 Then Return
ls_observation_id =  lstr_observations.observation_id[1]
set_obj_list(ls_observation_id)

refresh(uo_timeline.begin_date, uo_timeline.end_date)

end event

