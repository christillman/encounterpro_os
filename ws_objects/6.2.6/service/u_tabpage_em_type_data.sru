HA$PBExportHeader$u_tabpage_em_type_data.sru
forward
global type u_tabpage_em_type_data from u_tabpage
end type
type dw_em_data from u_dw_pick_list within u_tabpage_em_type_data
end type
end forward

global type u_tabpage_em_type_data from u_tabpage
integer width = 2907
integer height = 1564
dw_em_data dw_em_data
end type
global u_tabpage_em_type_data u_tabpage_em_type_data

type variables
u_tab_em_type_rules my_parent_tab
boolean include_em_type

end variables

forward prototypes
public function integer initialize ()
public subroutine refresh ()
end prototypes

public function integer initialize ();boolean lb_include_physcial

my_parent_tab = parent_tab

//dw_rules.settransobject(sqlca)
//dw_rules.retrieve(my_parent_tab.em_documentation_guide, my_parent_tab.em_component, my_parent_tab.em_type)


CHOOSE CASE wordcap(my_parent_tab.em_component)
	CASE "Decision Making"
		CHOOSE CASE wordcap(my_parent_tab.em_type)
			CASE "Data Reviewed"
				dw_em_data.dataobject = "dw_encounter_data_reviewed_detail"
				// if we're doing the data-reviewed datawindow, see if we should make the inclusion note visible
				lb_include_physcial = datalist.get_preference_boolean('PREFERENCES', 'E&M Count Physical Results', false)
				if lb_include_physcial then
					dw_em_data.object.t_dont_count_physical.visible = 0
				else
					dw_em_data.object.t_dont_count_physical.visible = 1
				end if
			CASE "Options"
				dw_em_data.dataobject = "dw_encounter_complexity_detail"
			CASE "Risk"
				dw_em_data.dataobject = "dw_encounter_risk_detail"
			CASE ELSE
				visible = false
		END CHOOSE
		include_em_type = false
	CASE ELSE
		dw_em_data.dataobject = "dw_encounter_em_elements_detail"
		include_em_type = true
END CHOOSE

dw_em_data.settransobject(sqlca)

return 1

end function

public subroutine refresh ();if include_em_type then
	dw_em_data.retrieve(my_parent_tab.cpr_id, my_parent_tab.encounter_id, my_parent_tab.em_component, my_parent_tab.em_type)
else
	dw_em_data.retrieve(my_parent_tab.cpr_id, my_parent_tab.encounter_id)
end if


end subroutine

on u_tabpage_em_type_data.create
int iCurrent
call super::create
this.dw_em_data=create dw_em_data
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_em_data
end on

on u_tabpage_em_type_data.destroy
call super::destroy
destroy(this.dw_em_data)
end on

event resize_tabpage;call super::resize_tabpage;dw_em_data.width = width
dw_em_data.height = height

end event

type dw_em_data from u_dw_pick_list within u_tabpage_em_type_data
integer width = 2889
integer height = 1472
integer taborder = 10
boolean hscrollbar = true
boolean vscrollbar = true
end type

event selected;call super::selected;string ls_context_object
long ll_object_key
integer li_sts
str_attributes lstr_attributes

ls_context_object = object.context_object[selected_row]
ll_object_key = object.object_key[selected_row]

f_attribute_add_attribute(lstr_attributes, "encounter_id", string(my_parent_tab.encounter_id))

li_sts = f_context_object_dashboard(my_parent_tab.cpr_id, ls_context_object, ll_object_key, lstr_attributes)

clear_selected()

refresh()

// msc added this because window was de-selected and frozen after service call returned
my_parent_tab.my_window.enable_window( )
end event

