HA$PBExportHeader$u_encounter_audit.sru
forward
global type u_encounter_audit from u_tabpage
end type
type cbx_include_object_updates from checkbox within u_encounter_audit
end type
type dw_audit from u_dw_pick_list within u_encounter_audit
end type
type st_begin_date_changed from statictext within u_encounter_audit
end type
end forward

global type u_encounter_audit from u_tabpage
integer width = 2912
integer height = 1164
string text = "Audit"
cbx_include_object_updates cbx_include_object_updates
dw_audit dw_audit
st_begin_date_changed st_begin_date_changed
end type
global u_encounter_audit u_encounter_audit

type variables
str_encounter_description encounter
long display_script_id

boolean first_time = true

end variables

forward prototypes
public subroutine refresh ()
public function integer initialize ()
end prototypes

public subroutine refresh ();string ls_user_id
string ls_audit_date
integer li_sts
string ls_include_object_updates
string ls_include_patient_info

setnull(ls_user_id)
setnull(ls_audit_date)

if first_time then
	li_sts = current_patient.encounters.encounter(encounter, parent_tab.service.encounter_id)
	
	dw_audit.settransobject(sqlca)
	
	dw_audit.object.compute_action.width = width - 2700
	dw_audit.object.compute_object.width = width - 662
	dw_audit.object.l_header.x2 = width
	
	first_time = false
end if

if cbx_include_object_updates.checked then
	ls_include_object_updates = "Y"
else
	ls_include_object_updates = "N"
end if

if current_user.clinical_access_flag then
	ls_include_patient_info = "Y"
else
	ls_include_patient_info = "N"
end if

dw_audit.retrieve(current_patient.cpr_id, encounter.encounter_id, ls_audit_date, ls_audit_date, ls_user_id, ls_include_object_updates, ls_include_patient_info)

return

end subroutine

public function integer initialize ();
cbx_include_object_updates.x = width - cbx_include_object_updates.width - 50
cbx_include_object_updates.y = height - cbx_include_object_updates.height

dw_audit.width = width
dw_audit.height = cbx_include_object_updates.y - 12


return 1

end function

on u_encounter_audit.create
int iCurrent
call super::create
this.cbx_include_object_updates=create cbx_include_object_updates
this.dw_audit=create dw_audit
this.st_begin_date_changed=create st_begin_date_changed
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_include_object_updates
this.Control[iCurrent+2]=this.dw_audit
this.Control[iCurrent+3]=this.st_begin_date_changed
end on

on u_encounter_audit.destroy
call super::destroy
destroy(this.cbx_include_object_updates)
destroy(this.dw_audit)
destroy(this.st_begin_date_changed)
end on

type cbx_include_object_updates from checkbox within u_encounter_audit
integer x = 2066
integer y = 1084
integer width = 795
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Include Object Updates"
boolean checked = true
end type

event clicked;refresh()

end event

type dw_audit from u_dw_pick_list within u_encounter_audit
integer width = 2912
integer height = 912
integer taborder = 10
string dataobject = "dw_fn_audit"
boolean vscrollbar = true
end type

type st_begin_date_changed from statictext within u_encounter_audit
integer x = 3127
integer y = 24
integer width = 50
integer height = 64
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "*"
boolean focusrectangle = false
end type

