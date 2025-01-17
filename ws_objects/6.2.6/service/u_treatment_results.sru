HA$PBExportHeader$u_treatment_results.sru
forward
global type u_treatment_results from u_tabpage
end type
type dw_properties from u_dw_pick_list within u_treatment_results
end type
type dw_treatment from u_dw_display within u_treatment_results
end type
end forward

global type u_treatment_results from u_tabpage
integer width = 2912
integer height = 1164
string text = "Treatment"
dw_properties dw_properties
dw_treatment dw_treatment
end type
global u_treatment_results u_treatment_results

type variables
u_component_treatment treatment

end variables

forward prototypes
public function integer display_treatment ()
public function integer initialize (u_component_treatment puo_treatment)
public function integer initialize ()
public subroutine refresh ()
public function integer display_treatment_properties ()
end prototypes

public function integer display_treatment ();integer li_sts
string ls_temp

ls_temp = parent_tab.service.get_attribute("dashboard_datawindow_config_object_id")

if isnull(ls_temp) then
	ls_temp = datalist.treatment_type_field(treatment.treatment_type, "dashboard_datawindow_config_object_id")
end if
if isnull(ls_temp) then
	ls_temp = datalist.get_preference("PREFERENCES", "Default Treatment Dashboard Datawindow")
end if

if len(ls_temp) > 0 then
	dw_treatment.attributes = parent_tab.service.get_attributes()
	dw_treatment.set_datawindow_config_object(ls_temp)
	dw_treatment.refresh()
else
	dw_treatment.reset()
	openwithparm(w_pop_message, "No datawindow config object has been configured for this treatment type and there is no default treatment dashboard datawindow set in preferences")
end if


display_treatment_properties()

return 1

end function

public function integer initialize (u_component_treatment puo_treatment);
treatment = puo_treatment

dw_properties.width = 1029
dw_properties.height = height - 100
dw_properties.x = width - dw_properties.width - 20
dw_properties.y = 20

dw_treatment.width = dw_properties.x - 20
dw_treatment.height = height

return 1

end function

public function integer initialize ();
treatment = parent_tab.service.treatment

dw_properties.width = 1029
dw_properties.height = height - 100
dw_properties.x = width - dw_properties.width - 20
dw_properties.y = 20

dw_treatment.width = dw_properties.x - 20
dw_treatment.height = height

return 1

end function

public subroutine refresh ();
display_treatment()

end subroutine

public function integer display_treatment_properties ();Long			i,ll_rows
String		ls_user_id
Datetime		ldt_date
Long 			ll_progress_sequence
/* user defined */
str_progress_list lstr_progress
string ls_null
integer li_sts
integer li_index
string ls_last_ordered_by
str_treatment_description lstr_treatment

setnull(ls_null)

li_sts = current_patient.treatments.treatment(lstr_treatment, treatment.treatment_id)

dw_properties.reset()
li_index = 0

li_index += 1
dw_properties.object.title[li_index] = "Treatment Type"
dw_properties.object.attribute[li_index] = "treatment_type"
dw_properties.object.value[li_index] = datalist.treatment_type_description(lstr_treatment.treatment_type)

li_index += 1
dw_properties.object.title[li_index] = "Begin Date"
dw_properties.object.attribute[li_index] = "begin_date"
dw_properties.object.value[li_index] = string(lstr_treatment.begin_date)
dw_properties.object.clickable[li_index] = 1

li_index += 1
dw_properties.object.title[li_index] = "End Date"
dw_properties.object.attribute[li_index] = "end_date"
dw_properties.object.value[li_index] = string(lstr_treatment.end_date)
// Don't let the user change the end_date if the treatment is still open
if isnull(lstr_treatment.treatment_status) OR upper(lstr_treatment.treatment_status) = "OPEN" then
	dw_properties.object.clickable[li_index] = 0
else
	dw_properties.object.clickable[li_index] = 1
end if

li_index += 1
dw_properties.object.title[li_index] = "Ordered By"
dw_properties.object.attribute[li_index] = "ordered_by"
dw_properties.object.value[li_index] = user_list.user_full_name(lstr_treatment.ordered_by)
dw_properties.object.color[li_index] = user_list.user_color(lstr_treatment.ordered_by)

SELECT top 1 ordered_by
INTO :ls_last_ordered_by
FROM dbo.fn_patient_treatment_orders(:current_patient.cpr_id, :lstr_treatment.treatment_id)
ORDER BY order_sequence;
if not tf_check() then return -1
if sqlca.sqlnrows = 1 then
	li_index += 1
	dw_properties.object.title[li_index] = "Last Ordered By"
	dw_properties.object.attribute[li_index] = "lastorderedby"
	dw_properties.object.value[li_index] = user_list.user_full_name(ls_last_ordered_by)
	dw_properties.object.color[li_index] = user_list.user_color(ls_last_ordered_by)
end if

li_index += 1
dw_properties.object.title[li_index] = "Ordered For"
dw_properties.object.attribute[li_index] = "ordered_for"
dw_properties.object.value[li_index] = user_list.user_full_name(lstr_treatment.ordered_for)
dw_properties.object.color[li_index] = user_list.user_color(lstr_treatment.ordered_for)

li_index += 1
dw_properties.object.title[li_index] = "Created By"
dw_properties.object.attribute[li_index] = "created_by"
dw_properties.object.value[li_index] = user_list.user_full_name(lstr_treatment.created_by)
dw_properties.object.color[li_index] = user_list.user_color(lstr_treatment.created_by)

li_index += 1
dw_properties.object.title[li_index] = "Created"
dw_properties.object.attribute[li_index] = "created"
dw_properties.object.value[li_index] = string(lstr_treatment.created)


li_index += 1
dw_properties.object.title[li_index] = "Status"
dw_properties.object.attribute[li_index] = "treatment_status"
if isnull(lstr_treatment.treatment_status) OR upper(lstr_treatment.treatment_status) = "OPEN" then
	dw_properties.object.value[li_index] = "Open"
else
	dw_properties.object.value[li_index] = wordcap(lstr_treatment.treatment_status)
end if
if upper(lstr_treatment.treatment_status) = "CANCELLED" then
	dw_properties.object.clickable[li_index] = 1
elseif upper(lstr_treatment.treatment_status) = "CLOSED" then
	dw_properties.object.clickable[li_index] = 1
else
	dw_properties.object.clickable[li_index] = 0
end if


return 1


end function

on u_treatment_results.create
int iCurrent
call super::create
this.dw_properties=create dw_properties
this.dw_treatment=create dw_treatment
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_properties
this.Control[iCurrent+2]=this.dw_treatment
end on

on u_treatment_results.destroy
call super::destroy
destroy(this.dw_properties)
destroy(this.dw_treatment)
end on

type dw_properties from u_dw_pick_list within u_treatment_results
integer x = 1874
integer y = 16
integer width = 1029
integer height = 928
integer taborder = 20
string dataobject = "dw_attribute_value_display_list"
end type

event clicked;call super::clicked;str_popup popup
str_popup_return popup_return
datetime ldt_begin_date
integer li_sts
string ls_attribute
integer li_clickable
string ls_old_value
string ls_new_value
string ls_null

setnull(ls_null)

if isnull(row) or row <= 0 then return

ls_attribute = object.attribute[row]
li_clickable = object.clickable[row]
ls_old_value = object.value[row]

if isnull(li_clickable) or li_clickable <= 0 then return

CHOOSE CASE lower(ls_attribute)
	CASE "begin_date"
		popup.title = "Begin Date/Time"
		popup.item = ls_old_value
		
		openwithparm(w_pop_prompt_date_time, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 2 then return
		
		ldt_begin_date = datetime(date(popup_return.items[1]), time(popup_return.items[2]))
		ls_new_value = string(ldt_begin_date)
		
		li_sts = current_patient.treatments.modify_treatment(treatment.treatment_id, ls_attribute, ls_new_value)
		if li_sts <= 0 then return
		
		refresh()
	CASE "end_date"
		popup.title = "End Date/Time"
		popup.item = ls_old_value
		
		openwithparm(w_pop_prompt_date_time, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 2 then return
		
		ldt_begin_date = datetime(date(popup_return.items[1]), time(popup_return.items[2]))
		ls_new_value = string(ldt_begin_date)
		
		li_sts = current_patient.treatments.modify_treatment(treatment.treatment_id, ls_attribute, ls_new_value)
		if li_sts <= 0 then return
		
		refresh()
	CASE "treatment_status"
		if lower(ls_old_value) = "cancelled" then
			openwithparm(w_pop_yes_no, "Do you wish to un-cancel this treatment?")
			popup_return = message.powerobjectparm
			if popup_return.item <> "YES" then return
			
			treatment.set_progress('UNCancelled', ls_null)
			
			refresh()
			return
		elseif lower(ls_old_value) = "closed" then
			openwithparm(w_pop_yes_no, "Do you wish to Reopen this treatment?")
			popup_return = message.powerobjectparm
			if popup_return.item <> "YES" then return
			
			treatment.set_progress('Reopen', ls_null)
			
			refresh()
			return
		end if
END CHOOSE



end event

type dw_treatment from u_dw_display within u_treatment_results
integer width = 1861
integer height = 1044
integer taborder = 30
end type

