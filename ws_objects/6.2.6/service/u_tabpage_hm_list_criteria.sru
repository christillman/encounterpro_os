HA$PBExportHeader$u_tabpage_hm_list_criteria.sru
forward
global type u_tabpage_hm_list_criteria from u_tabpage_hm_class_base
end type
type st_criteria_title from statictext within u_tabpage_hm_list_criteria
end type
type st_hm_class from statictext within u_tabpage_hm_list_criteria
end type
type st_class_title from statictext within u_tabpage_hm_list_criteria
end type
type st_title from statictext within u_tabpage_hm_list_criteria
end type
type cb_add_criterion from commandbutton within u_tabpage_hm_list_criteria
end type
type dw_criteria from u_dw_pick_list within u_tabpage_hm_list_criteria
end type
end forward

global type u_tabpage_hm_list_criteria from u_tabpage_hm_class_base
integer width = 3118
st_criteria_title st_criteria_title
st_hm_class st_hm_class
st_class_title st_class_title
st_title st_title
cb_add_criterion cb_add_criterion
dw_criteria dw_criteria
end type
global u_tabpage_hm_list_criteria u_tabpage_hm_list_criteria

type variables

end variables

forward prototypes
public subroutine refresh ()
public function integer initialize (str_hm_context pstr_hm_context, long pl_index)
end prototypes

public subroutine refresh ();long i
long ll_row
string ls_sex
string ls_race
long ll_age_range_id

dw_criteria.reset()

//for i = 1 to HMClassTab.hm_class.criteria_count
//	ll_row = dw_criteria.insertrow(0)
//	dw_criteria.object.property[ll_row] = HMClassTab.hm_class.criteria[i].property
//	dw_criteria.object.property_display[ll_row] = wordcap(f_string_substitute(HMClassTab.hm_class.criteria[i].property, "_", " "))
//	dw_criteria.object.value[ll_row] = HMClassTab.hm_class.criteria[i].value
//	dw_criteria.object.operation[ll_row] = HMClassTab.hm_class.criteria[i].operation
//	if isnull(HMClassTab.hm_class.criteria[i].value) then
//		dw_criteria.object.value_display[ll_row] = "<Any>"
//	else
//		dw_criteria.object.value_display[ll_row] = f_property_value_display(HMClassTab.hm_class.criteria[i].property, HMClassTab.hm_class.criteria[i].value)
//	end if
//next

SELECT sex, race, age_range_id
INTO :ls_sex, :ls_race, :ll_age_range_id
FROM c_Maintenance_Patient_Class
WHERE maintenance_rule_id = :hmclasstab.hm_class.maintenance_rule_id;
if not tf_check() then return

ll_row = dw_criteria.insertrow(0)
dw_criteria.object.property[ll_row] = "Sex"
dw_criteria.object.property_display[ll_row] = "Sex"
dw_criteria.object.value[ll_row] = ls_sex
dw_criteria.object.operation[ll_row] = "="
if isnull(ls_sex) then
	dw_criteria.object.value_display[ll_row] = "<Any>"
else
	dw_criteria.object.value_display[ll_row] = f_property_value_display("Sex", ls_sex)
end if

ll_row = dw_criteria.insertrow(0)
dw_criteria.object.property[ll_row] = "Race"
dw_criteria.object.property_display[ll_row] = "Race"
dw_criteria.object.value[ll_row] = ls_race
dw_criteria.object.operation[ll_row] = "="
if isnull(ls_sex) then
	dw_criteria.object.value_display[ll_row] = "<Any>"
else
	dw_criteria.object.value_display[ll_row] = f_property_value_display("Race", ls_race)
end if

ll_row = dw_criteria.insertrow(0)
dw_criteria.object.property[ll_row] = "age_range"
dw_criteria.object.property_display[ll_row] = "Age"
dw_criteria.object.value[ll_row] = ls_race
dw_criteria.object.operation[ll_row] = "In Age Range"
if isnull(ll_age_range_id) then
	dw_criteria.object.value_display[ll_row] = "<Any>"
else
	dw_criteria.object.value_display[ll_row] = f_property_value_display("age_range", string(ll_age_range_id))
end if


end subroutine

public function integer initialize (str_hm_context pstr_hm_context, long pl_index);long i
long ll_row
str_hm_class_definition lstr_parent_def
integer li_sts

// Set the object positions
st_title.width = width

dw_criteria.x = ((width - dw_criteria.width) / 2) + 110
dw_criteria.height = height - dw_criteria.y - 180

st_class_title.x = (width - st_class_title.width) / 2
st_hm_class.x = (width - st_hm_class.width) / 2
st_criteria_title.x = (width - st_criteria_title.width) / 2

cb_add_criterion.x = (width - cb_add_criterion.width) / 2
cb_add_criterion.y = dw_criteria.y + dw_criteria.height + 36

if hmclasstab.hm_class.filter_maintenance_rule_id > 0 then
	li_sts = f_get_hm_class_definition(hmclasstab.hm_class.filter_maintenance_rule_id, lstr_parent_def)
	if li_sts < 0 then return -1
	
	st_hm_class.text = lstr_parent_def.description
end if

return 1


end function

on u_tabpage_hm_list_criteria.create
int iCurrent
call super::create
this.st_criteria_title=create st_criteria_title
this.st_hm_class=create st_hm_class
this.st_class_title=create st_class_title
this.st_title=create st_title
this.cb_add_criterion=create cb_add_criterion
this.dw_criteria=create dw_criteria
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_criteria_title
this.Control[iCurrent+2]=this.st_hm_class
this.Control[iCurrent+3]=this.st_class_title
this.Control[iCurrent+4]=this.st_title
this.Control[iCurrent+5]=this.cb_add_criterion
this.Control[iCurrent+6]=this.dw_criteria
end on

on u_tabpage_hm_list_criteria.destroy
call super::destroy
destroy(this.st_criteria_title)
destroy(this.st_hm_class)
destroy(this.st_class_title)
destroy(this.st_title)
destroy(this.cb_add_criterion)
destroy(this.dw_criteria)
end on

type st_criteria_title from statictext within u_tabpage_hm_list_criteria
integer x = 553
integer y = 436
integer width = 1787
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 33538240
string text = "Further filter with the following criteria"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_hm_class from statictext within u_tabpage_hm_list_criteria
integer x = 485
integer y = 260
integer width = 1925
integer height = 108
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_class_title from statictext within u_tabpage_hm_list_criteria
integer x = 553
integer y = 164
integer width = 1787
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 33538240
string text = "Start with the patients that qualify for this Maintenance Rule"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title from statictext within u_tabpage_hm_list_criteria
integer width = 2889
integer height = 100
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "List Criteria"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_add_criterion from commandbutton within u_tabpage_hm_list_criteria
integer x = 1234
integer y = 1372
integer width = 494
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Criterion"
end type

type dw_criteria from u_dw_pick_list within u_tabpage_hm_list_criteria
integer y = 540
integer width = 3040
integer height = 784
integer taborder = 10
string dataobject = "dw_hm_criteria_display"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;string ls_operation
string ls_property
string ls_property_display
string ls_value
str_popup_return	popup_return
string ls_new_value
str_popup popup
u_user luo_user
string ls_null
long ll_age_range_id

setnull(ls_null)

ls_property = object.property[selected_row]
ls_property_display = object.property_display[selected_row]
ls_value = object.value[selected_row]
ls_operation = object.operation[selected_row]

if lower(lastcolumnname) = "value_display" then
	CHOOSE CASE lower(ls_property)
		CASE "age_range"
			openwithparm(w_age_range_selection,"Maintenance")
			popup_return = Message.powerobjectparm
			If popup_return.item_count > 0 Then
				object.value_display[selected_row] = popup_return.descriptions[1]
				object.value[selected_row] = popup_return.items[1]

				ll_age_range_id = long(popup_return.items[1])
				
				UPDATE c_Maintenance_Patient_Class
				SET age_range_id = :ll_age_range_id
				WHERE maintenance_rule_id = :hmclasstab.hm_class.maintenance_rule_id;
				if not tf_check() then return
			End if	
		CASE "sex"
			popup.dataobject = "dw_domain_translate_list"
			popup.datacolumn = 2
			popup.displaycolumn = 3
			popup.argument_count = 1
			popup.argument[1] = "SEX"
			popup.add_blank_row = true
			popup.blank_text = "<Any>"
			
			openwithparm(w_pop_pick, popup)
			popup_return = message.powerobjectparm
			if popup_return.item_count <> 1 then
				clear_selected()
				return
			end if
			
			if trim(popup_return.items[1]) = "" then
				object.value[selected_row] = ls_null
				object.value_display[selected_row] = "N/A"

				UPDATE c_Maintenance_Patient_Class
				SET sex = NULL
				WHERE maintenance_rule_id = :hmclasstab.hm_class.maintenance_rule_id;
				if not tf_check() then
					clear_selected()
					return
				end if
			else
				object.value[selected_row] = popup_return.items[1]
				object.value_display[selected_row] = popup_return.descriptions[1]

				UPDATE c_Maintenance_Patient_Class
				SET sex = :popup_return.items[1]
				WHERE maintenance_rule_id = :hmclasstab.hm_class.maintenance_rule_id;
				if not tf_check() then
					clear_selected()
					return
				end if
			end if
		CASE "race"
			popup.dataobject = "dw_domain_showtranslate_list"
			popup.datacolumn = 2
			popup.displaycolumn = 3
			popup.argument_count = 1
			popup.argument[1] = "RACE"
			popup.add_blank_row = true
			popup.blank_text = "N/A"
			
			openwithparm(w_pop_pick, popup)
			popup_return = message.powerobjectparm
			if popup_return.item_count <> 1 then
				clear_selected()
				return
			end if
			
			if trim(popup_return.items[1]) = "" then
				object.value[selected_row] = ls_null
				object.value_display[selected_row] = "N/A"

				UPDATE c_Maintenance_Patient_Class
				SET race = NULL
				WHERE maintenance_rule_id = :hmclasstab.hm_class.maintenance_rule_id;
				if not tf_check() then
					clear_selected()
					return
				end if
			else
				object.value[selected_row] = popup_return.items[1]
				object.value_display[selected_row] = popup_return.descriptions[1]

				UPDATE c_Maintenance_Patient_Class
				SET race = :popup_return.items[1]
				WHERE maintenance_rule_id = :hmclasstab.hm_class.maintenance_rule_id;
				if not tf_check() then
					clear_selected()
					return
				end if
			end if
		CASE ELSE
			ls_new_value = f_popup_prompt_string_init("Select Patient Class Criteria: " + ls_property_display, ls_value, "PatientClassCriteria|" + ls_property)
			if not isnull(ls_new_value) then
				object.value[selected_row] = ls_new_value
				object.value_display[selected_row] = ls_new_value
			end if
	END CHOOSE
end if

clear_selected()

end event

event buttonclicked;call super::buttonclicked;string ls_property
string ls_null

setnull(ls_null)

if lower(dwo.name) = "b_clear" then
	ls_property = object.property[row]
	object.value[row] = ls_null
	object.value_display[row] = "<Any>"
	
	CHOOSE CASE lower(ls_property)
		CASE "sex"
			UPDATE c_Maintenance_Patient_Class
			SET sex = NULL
			WHERE maintenance_rule_id = :hmclasstab.hm_class.maintenance_rule_id;
			if not tf_check() then return
		CASE "race"
			UPDATE c_Maintenance_Patient_Class
			SET race = NULL
			WHERE maintenance_rule_id = :hmclasstab.hm_class.maintenance_rule_id;
			if not tf_check() then return
		CASE "age_range"
			UPDATE c_Maintenance_Patient_Class
			SET age_range_id = NULL
			WHERE maintenance_rule_id = :hmclasstab.hm_class.maintenance_rule_id;
			if not tf_check() then return
	END CHOOSE
end if

end event

