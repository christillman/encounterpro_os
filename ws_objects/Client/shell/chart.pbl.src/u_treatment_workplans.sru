$PBExportHeader$u_treatment_workplans.sru
forward
global type u_treatment_workplans from u_tabpage
end type
type tab_workplans from u_tab_workplan_display within u_treatment_workplans
end type
type tab_workplans from u_tab_workplan_display within u_treatment_workplans
end type
type st_no_workplans from statictext within u_treatment_workplans
end type
end forward

global type u_treatment_workplans from u_tabpage
integer width = 2802
integer height = 1012
string text = "Workplans"
tab_workplans tab_workplans
st_no_workplans st_no_workplans
end type
global u_treatment_workplans u_treatment_workplans

type variables
//boolean initialized = false
u_component_treatment treatment
//u_ds_data workplans

boolean first_time = true

end variables

forward prototypes
public function integer initialize (u_component_treatment puo_treatment)
public function integer display_workplans ()
public function integer initialize ()
public subroutine refresh ()
end prototypes

public function integer initialize (u_component_treatment puo_treatment);tab_workplans.width = width
tab_workplans.height = height

st_no_workplans.x = (width - st_no_workplans.width)/2
st_no_workplans.y = (height - st_no_workplans.height)/2

return tab_workplans.initialize( 'Treatment', puo_treatment.treatment_id)

//
//workplans = CREATE u_ds_data
//workplans.set_dataobject("dw_treatment_workplans")
//
//treatment = puo_treatment
//
////dw_workplans.x = 0
////dw_workplans.y = 0
////dw_workplans.width = width
////dw_workplans.height = height
////pb_up.x = width - pb_up.width
////pb_up.y = 0
////pb_down.x = pb_up.x
////pb_down.y = height - pb_down.height
////
//
//tab_workplans.width = width
//tab_workplans.height = height
//
//st_no_workplans.x = (width - st_no_workplans.width)/2
//st_no_workplans.y = (height - st_no_workplans.height)/2
//
//// Load a tab for each workplan
//integer li_item_count
//integer li_workplan_count
//long ll_patient_workplan_id
//string ls_workplan_icon
//string ls_workplan_type
//string ls_workplan_description
//integer li_last_step_dispatched
//integer li_step_number
//string ls_step_description
//string ls_step_status
//string ls_item_icon
//string ls_item_description
//string ls_status
//string ls_item_status
//long i
//string ls_filter
//long j
//long ll_row
//u_tabpage luo_tabpage
//string ls_tabtext
//integer li_main_count = 0
//
//// step status = Complete, Dispatched, Pending
//// item status = Complete, Dispatched, Pending, Cancelled
//
//li_workplan_count = workplans.retrieve(current_patient.cpr_id, treatment.treatment_id)
//if li_workplan_count < 0 then return -1
//
//if li_workplan_count = 0 then
//	st_no_workplans.visible = true
//	tab_workplans.visible = false
//	return 0
//end if
//
//for i = 1 to li_workplan_count
//	ll_patient_workplan_id = workplans.object.patient_workplan_id[i]
//	ls_workplan_description = workplans.object.description[i]
//	li_last_step_dispatched = workplans.object.last_step_dispatched[i]
//	ls_workplan_type = workplans.object.workplan_type[i]
//	CHOOSE CASE upper(ls_workplan_type)
//		CASE "REFERRAL", "FOLLOWUP"
//			luo_tabpage = tab_workplans.open_page("u_tabpage_followup_workplan_display")
//			ls_tabtext = wordcap(ls_workplan_type)
//		CASE ELSE
//			luo_tabpage = tab_workplans.open_page("u_tabpage_workplan_display")
//			li_main_count += 1
//			if li_main_count > 1 then
//				ls_tabtext = "Workplan #" + string(li_main_count)
//			else
//				ls_tabtext = "Primary"
//			end if
//	END CHOOSE
//	luo_tabpage.text = ls_tabtext
//	
//next
//
//
//return 1
//
end function

public function integer display_workplans ();integer li_sts
string ls_temp

//li_sts = dw_workplans.display_workplans(treatment.treatment_id, "Treatment")
//if li_sts < 0 then return -1
//
//if li_sts = 0 then
//	pb_up.visible = false
//	pb_down.visible = false
//	return 0
//end if
//
//dw_workplans.last_page = 0
//dw_workplans.set_page(1, ls_temp)
//if dw_workplans.last_page < 2 then
//	pb_up.visible = false
//	pb_down.visible = false
//else
//	pb_up.visible = true
//	pb_down.visible = true
//	pb_up.enabled = false
//	pb_down.enabled = true
//end if
//

tab_workplans.refresh()

return 1

end function

public function integer initialize ();integer li_sts

tab_workplans.width = width
tab_workplans.height = height

st_no_workplans.x = (width - st_no_workplans.width)/2
st_no_workplans.y = (height - st_no_workplans.height)/2

//workplans = CREATE u_ds_data

//li_sts = tab_workplans.initialize('Treatment', parent_tab.service.treatment_id)
//return li_sts

return 1

end function

public subroutine refresh ();integer li_sts

if first_time then
	li_sts = tab_workplans.initialize('Treatment', parent_tab.service.treatment_id)
	first_time = false
end if

tab_workplans.function POST refresh()


end subroutine

on u_treatment_workplans.create
int iCurrent
call super::create
this.tab_workplans=create tab_workplans
this.st_no_workplans=create st_no_workplans
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_workplans
this.Control[iCurrent+2]=this.st_no_workplans
end on

on u_treatment_workplans.destroy
call super::destroy
destroy(this.tab_workplans)
destroy(this.st_no_workplans)
end on

type tab_workplans from u_tab_workplan_display within u_treatment_workplans
integer width = 2423
integer height = 900
end type

type st_no_workplans from statictext within u_treatment_workplans
boolean visible = false
integer x = 626
integer y = 212
integer width = 1499
integer height = 112
integer textsize = -16
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "This treatment has no workplans"
alignment alignment = center!
boolean focusrectangle = false
end type

