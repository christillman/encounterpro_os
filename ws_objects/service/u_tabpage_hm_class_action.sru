HA$PBExportHeader$u_tabpage_hm_class_action.sru
forward
global type u_tabpage_hm_class_action from u_tabpage_hm_class_base
end type
type cb_add_action from commandbutton within u_tabpage_hm_class_action
end type
type dw_actions from u_dw_pick_list within u_tabpage_hm_class_action
end type
type st_actions_caption from statictext within u_tabpage_hm_class_action
end type
type st_title from statictext within u_tabpage_hm_class_action
end type
end forward

global type u_tabpage_hm_class_action from u_tabpage_hm_class_base
cb_add_action cb_add_action
dw_actions dw_actions
st_actions_caption st_actions_caption
st_title st_title
end type
global u_tabpage_hm_class_action u_tabpage_hm_class_action

type variables
String	age_from_unit,age_to_unit,interval_unit
String assessment_flag,race,sex
Long		interval,age_to,age_from
Long warning_days,age_range_id
end variables

forward prototypes
public function integer add_action ()
public subroutine refresh ()
public function integer initialize (str_hm_context pstr_hm_context, long pl_index)
end prototypes

public function integer add_action ();

return 1

end function

public subroutine refresh ();long i
long ll_row
string ls_action_display
string ls_recipient_name

//for i = 1 to hmclasstab.hm_class.action_count
//	ll_row = dw_actions.insertrow(0)
//	dw_actions.object.action[ll_row] = hmclasstab.hm_class.action[i].action
//	dw_actions.object.action_time[ll_row] = hmclasstab.hm_class.action[i].action_time
//	dw_actions.object.action_time_unit[ll_row] = hmclasstab.hm_class.action[i].action_time_unit
//	dw_actions.object.action_recipient[ll_row] = hmclasstab.hm_class.action[i].action_recipient
//	ls_recipient_name = user_list.user_full_name(hmclasstab.hm_class.action[i].action_recipient)
//	dw_actions.object.action_recipient_name[ll_row] = ls_recipient_name
//	ls_action_display = hmclasstab.hm_class.action[i].action
//	if len(ls_recipient_name) > 0 then
//		ls_action_display += " for " + ls_recipient_name
//	end if
//	dw_actions.object.action_display[ll_row] = ls_action_display
//next

end subroutine

public function integer initialize (str_hm_context pstr_hm_context, long pl_index);long i
long ll_row

// Set the object positions
st_title.width = width

dw_actions.x = ((width - dw_actions.width) / 2) - 110
dw_actions.height = height - dw_actions.y - 180

st_actions_caption.x = dw_actions.x

cb_add_action.x = (width - cb_add_action.width) / 2
cb_add_action.y = dw_actions.y + dw_actions.height + 36

dw_actions.settransobject(sqlca)
//for i = 1 to HMClassTab.hm_class.action_count
//	ll_row = dw_actions.insertrow(0)
//	dw_actions.object.property[ll_row] = HMClassTab.hm_class.action[i].property
//	dw_actions.object.property_display[ll_row] = wordcap(f_string_substitute(HMClassTab.hm_class.action[i].property, "_", " "))
//	dw_actions.object.value[ll_row] = HMClassTab.hm_class.action[i].value
//	dw_actions.object.operation[ll_row] = HMClassTab.hm_class.action[i].operation
//	if isnull(HMClassTab.hm_class.action[i].value) then
//		dw_actions.object.value_display[ll_row] = "<Any>"
//	else
//		dw_actions.object.value_display[ll_row] = f_property_value_display(HMClassTab.hm_class.action[i].property, HMClassTab.hm_class.action[i].value)
//	end if
//next

return 1


end function

on u_tabpage_hm_class_action.create
int iCurrent
call super::create
this.cb_add_action=create cb_add_action
this.dw_actions=create dw_actions
this.st_actions_caption=create st_actions_caption
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_add_action
this.Control[iCurrent+2]=this.dw_actions
this.Control[iCurrent+3]=this.st_actions_caption
this.Control[iCurrent+4]=this.st_title
end on

on u_tabpage_hm_class_action.destroy
call super::destroy
destroy(this.cb_add_action)
destroy(this.dw_actions)
destroy(this.st_actions_caption)
destroy(this.st_title)
end on

type cb_add_action from commandbutton within u_tabpage_hm_class_action
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
string text = "Add Action"
end type

event clicked;add_action()
end event

type dw_actions from u_dw_pick_list within u_tabpage_hm_class_action
integer x = 110
integer y = 332
integer width = 2400
integer height = 840
integer taborder = 10
string dataobject = "dw_hm_action_display"
end type

type st_actions_caption from statictext within u_tabpage_hm_class_action
integer x = 110
integer y = 176
integer width = 1701
integer height = 148
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Perform these actions when a patient qualifies for this class but does not satisfy any  protocol:"
boolean focusrectangle = false
end type

type st_title from statictext within u_tabpage_hm_class_action
integer width = 2446
integer height = 100
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Action"
alignment alignment = center!
boolean focusrectangle = false
end type

