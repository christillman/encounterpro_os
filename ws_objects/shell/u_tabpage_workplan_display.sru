HA$PBExportHeader$u_tabpage_workplan_display.sru
forward
global type u_tabpage_workplan_display from u_tabpage
end type
type tv_workplan_definition from u_tv_workplan within u_tabpage_workplan_display
end type
type dw_workplan from u_dw_patient_object_workplan within u_tabpage_workplan_display
end type
end forward

global type u_tabpage_workplan_display from u_tabpage
tv_workplan_definition tv_workplan_definition
dw_workplan dw_workplan
end type
global u_tabpage_workplan_display u_tabpage_workplan_display

type variables
//long patient_workplan_id
//string context_object
//long object_key
str_p_patient_wp patient_workplan

end variables

forward prototypes
public subroutine refresh ()
public subroutine set_workplan (long pl_patient_workplan_id)
end prototypes

public subroutine refresh ();boolean lb_allow_editing

dw_workplan.display_workplan()

lb_allow_editing = user_list.is_user_authorized(current_user.user_id, "CONFIG_WORKPLANS", "General")

if tv_workplan_definition.visible then
	tv_workplan_definition.display_workplan(patient_workplan.workplan_id, lb_allow_editing)
end if


end subroutine

public subroutine set_workplan (long pl_patient_workplan_id);integer li_sts

dw_workplan.patient_workplan_id = pl_patient_workplan_id

li_sts = datalist.clinical_data_cache.patient_workplan(pl_patient_workplan_id, patient_workplan)

if patient_workplan.workplan_id > 0 then
	dw_workplan.x = 0
	dw_workplan.width = (width / 2) - 4
	dw_workplan.y = 0
	dw_workplan.height = height
	
	tv_workplan_definition.visible = true
	tv_workplan_definition.x = (width / 2) + 8
	tv_workplan_definition.width = (width / 2) - 4
	tv_workplan_definition.y = 0
	tv_workplan_definition.height = height
else
	dw_workplan.x = 0
	dw_workplan.width = width
	dw_workplan.y = 0
	dw_workplan.height = height
	tv_workplan_definition.visible = false
end if

end subroutine

on u_tabpage_workplan_display.create
int iCurrent
call super::create
this.tv_workplan_definition=create tv_workplan_definition
this.dw_workplan=create dw_workplan
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tv_workplan_definition
this.Control[iCurrent+2]=this.dw_workplan
end on

on u_tabpage_workplan_display.destroy
call super::destroy
destroy(this.tv_workplan_definition)
destroy(this.dw_workplan)
end on

type tv_workplan_definition from u_tv_workplan within u_tabpage_workplan_display
integer x = 1339
integer y = 84
integer taborder = 20
long backcolor = 12632256
borderstyle borderstyle = stylebox!
end type

type dw_workplan from u_dw_patient_object_workplan within u_tabpage_workplan_display
integer taborder = 10
end type

