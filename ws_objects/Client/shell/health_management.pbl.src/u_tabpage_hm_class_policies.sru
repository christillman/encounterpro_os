$PBExportHeader$u_tabpage_hm_class_policies.sru
forward
global type u_tabpage_hm_class_policies from u_tabpage_hm_class_base
end type
type st_no_policies from statictext within u_tabpage_hm_class_policies
end type
type cb_add_policy from commandbutton within u_tabpage_hm_class_policies
end type
type st_title from statictext within u_tabpage_hm_class_policies
end type
type dw_policies from u_dw_pick_list within u_tabpage_hm_class_policies
end type
end forward

global type u_tabpage_hm_class_policies from u_tabpage_hm_class_base
integer width = 2935
st_no_policies st_no_policies
cb_add_policy cb_add_policy
st_title st_title
dw_policies dw_policies
end type
global u_tabpage_hm_class_policies u_tabpage_hm_class_policies

type variables
String	age_from_unit,age_to_unit,interval_unit
String assessment_flag,race,sex
Long		interval,age_to,age_from
Long warning_days,age_range_id

u_ds_data events

end variables

forward prototypes
public subroutine refresh ()
public function integer initialize (str_hm_context pstr_hm_context, long pl_index)
public function integer add_policy ()
end prototypes

public subroutine refresh ();long i
long ll_row
string ls_policy_display
string ls_recipient_name
str_c_workplan lstr_workplan
long ll_events_row
string ls_find
long ll_days
u_unit luo_unit

if hmclasstab.hm_class.policy_count <= 0 then
	dw_policies.visible = false
	st_no_policies.visible = true
else
	dw_policies.setredraw(false)
	dw_policies.reset()
	for i = 1 to hmclasstab.hm_class.policy_count
		ll_row = dw_policies.insertrow(0)
		dw_policies.object.policy_event[ll_row] = hmclasstab.hm_class.policy[i].policy_event
		dw_policies.object.policy_sequence[ll_row] = hmclasstab.hm_class.policy[i].policy_sequence
		dw_policies.object.include_new_flag[ll_row] = hmclasstab.hm_class.policy[i].include_new_flag
		dw_policies.object.time_offset_amount[ll_row] = hmclasstab.hm_class.policy[i].time_offset_amount
		dw_policies.object.time_offset_unit[ll_row] = hmclasstab.hm_class.policy[i].time_offset_unit
		dw_policies.object.action_workplan_recipient[ll_row] = hmclasstab.hm_class.policy[i].action_workplan_recipient
		ls_recipient_name = user_list.user_full_name(hmclasstab.hm_class.policy[i].action_workplan_recipient)
		if len(ls_recipient_name) > 0 then
			dw_policies.object.action_workplan_recipient_name[ll_row] = ls_recipient_name
		else
			dw_policies.object.action_workplan_recipient_name[ll_row] = "<Unspecified Recipient>"
		end if
		if hmclasstab.hm_class.policy[i].action_workplan_id > 0 then
			dw_policies.object.action_workplan_id[ll_row] = hmclasstab.hm_class.policy[i].action_workplan_id
			lstr_workplan = datalist.get_workplan(hmclasstab.hm_class.policy[i].action_workplan_id)
			dw_policies.object.action_workplan_name[ll_row] = lstr_workplan.description
		end if
		
		ls_find = "lower(domain_item)='" + lower(hmclasstab.hm_class.policy[i].policy_event) + "'"
		ll_events_row = events.find(ls_find, 1, events.rowcount())
		dw_policies.object.policy_event_sort[ll_row] = ll_events_row
		
		ll_days = 0
		if not isnull(hmclasstab.hm_class.policy[i].time_offset_amount) and not isnull(hmclasstab.hm_class.policy[i].time_offset_unit) then
			luo_unit = unit_list.find_unit(hmclasstab.hm_class.policy[i].time_offset_unit)
			if not isnull(luo_unit) then
				ll_days = long(luo_unit.convert("Day", string(hmclasstab.hm_class.policy[i].time_offset_amount)))
			end if
		end if
		dw_policies.object.time_offset_sort[ll_row] = ll_days
	next
	
	dw_policies.sort()
	dw_policies.setredraw(true)
	dw_policies.visible = true
	st_no_policies.visible = false
end if

end subroutine

public function integer initialize (str_hm_context pstr_hm_context, long pl_index);long i
long ll_row

// Set the object positions
st_title.width = width

dw_policies.width = width - dw_policies.x
dw_policies.height = height - dw_policies.y - 180
dw_policies.object.t_background.width = dw_policies.width - 100

st_no_policies.x = (width - st_no_policies.width) / 2
st_no_policies.y = (height - st_no_policies.height) / 2

cb_add_policy.x = (width - cb_add_policy.width) / 2
cb_add_policy.y = dw_policies.y + dw_policies.height + 36

dw_policies.settransobject(sqlca)

events = CREATE u_ds_data
events.set_dataobject("dw_domain_item_list")
events.retrieve("Health Maintenance Event")

return 1


end function

public function integer add_policy ();str_hm_policy_edit lstr_hm_policy_edit

lstr_hm_policy_edit.maintenance_rule_id = hmclasstab.hm_class.maintenance_rule_id
lstr_hm_policy_edit.description = hmclasstab.hm_class.description

openwithparm(w_hm_policy_edit, lstr_hm_policy_edit)
lstr_hm_policy_edit = message.powerobjectparm
if lstr_hm_policy_edit.return_status = "CANCEL" then return 0

INSERT INTO c_Maintenance_Policy
           (maintenance_rule_id
           ,policy_event
           ,include_new_flag
           ,time_offset_amount
           ,time_offset_unit
           ,action_workplan_id
           ,action_workplan_recipient
           ,created_by)
VALUES (
           :hmclasstab.hm_class.maintenance_rule_id,
           :lstr_hm_policy_edit.policy.policy_event,
           :lstr_hm_policy_edit.policy.include_new_flag,
           :lstr_hm_policy_edit.policy.time_offset_amount,
           :lstr_hm_policy_edit.policy.time_offset_unit,
           :lstr_hm_policy_edit.policy.action_workplan_id,
           :lstr_hm_policy_edit.policy.action_workplan_recipient,
           :current_user.user_id);
if not tf_check() then return -1

SELECT scope_identity()
INTO :lstr_hm_policy_edit.policy.policy_sequence
FROM c_1_record;
if not tf_check() then return -1

HMClassTab.hm_class.policy_count += 1
HMClassTab.hm_class.policy[HMClassTab.hm_class.policy_count] = lstr_hm_policy_edit.policy

refresh()

return 1

end function

on u_tabpage_hm_class_policies.create
int iCurrent
call super::create
this.st_no_policies=create st_no_policies
this.cb_add_policy=create cb_add_policy
this.st_title=create st_title
this.dw_policies=create dw_policies
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_no_policies
this.Control[iCurrent+2]=this.cb_add_policy
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.dw_policies
end on

on u_tabpage_hm_class_policies.destroy
call super::destroy
destroy(this.st_no_policies)
destroy(this.cb_add_policy)
destroy(this.st_title)
destroy(this.dw_policies)
end on

type st_no_policies from statictext within u_tabpage_hm_class_policies
boolean visible = false
integer x = 768
integer y = 572
integer width = 1545
integer height = 104
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "No Policies"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_add_policy from commandbutton within u_tabpage_hm_class_policies
integer x = 992
integer y = 1260
integer width = 512
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Policy"
end type

event clicked;add_policy()
end event

type st_title from statictext within u_tabpage_hm_class_policies
integer width = 2935
integer height = 100
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Class Policies"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_policies from u_dw_pick_list within u_tabpage_hm_class_policies
integer x = 110
integer y = 136
integer width = 2715
integer height = 1036
integer taborder = 10
string dataobject = "dw_hm_policy_display"
end type

event selected;call super::selected;str_hm_policy_edit lstr_hm_policy_edit

lstr_hm_policy_edit.maintenance_rule_id = hmclasstab.hm_class.maintenance_rule_id
lstr_hm_policy_edit.description = hmclasstab.hm_class.description
lstr_hm_policy_edit.policy = hmclasstab.hm_class.policy[selected_row]

openwithparm(w_hm_policy_edit, lstr_hm_policy_edit)
lstr_hm_policy_edit = message.powerobjectparm
if lstr_hm_policy_edit.return_status = "CANCEL" then 
	clear_selected()
	return
end if


UPDATE c_Maintenance_Policy
   SET policy_event = :lstr_hm_policy_edit.policy.policy_event,
      include_new_flag =  :lstr_hm_policy_edit.policy.include_new_flag,
      time_offset_amount = :lstr_hm_policy_edit.policy.time_offset_amount,
      time_offset_unit = :lstr_hm_policy_edit.policy.time_offset_unit,
      action_workplan_id =  :lstr_hm_policy_edit.policy.action_workplan_id,
      action_workplan_recipient =  :lstr_hm_policy_edit.policy.action_workplan_recipient
WHERE maintenance_rule_id = :hmclasstab.hm_class.maintenance_rule_id
AND policy_sequence = :lstr_hm_policy_edit.policy.policy_sequence;
if not tf_check() then return


HMClassTab.hm_class.policy[selected_row] = lstr_hm_policy_edit.policy

refresh()

return

end event

