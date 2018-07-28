HA$PBExportHeader$u_tabpage_encounter_attachments.sru
forward
global type u_tabpage_encounter_attachments from u_tabpage
end type
type uo_attachments from u_attachments within u_tabpage_encounter_attachments
end type
end forward

global type u_tabpage_encounter_attachments from u_tabpage
integer width = 2903
string text = "Attachments"
uo_attachments uo_attachments
end type
global u_tabpage_encounter_attachments u_tabpage_encounter_attachments

type variables
boolean first_time = true

end variables

forward prototypes
public function integer initialize ()
public subroutine refresh ()
public subroutine refresh_tabtext ()
end prototypes

public function integer initialize ();uo_attachments.width = width
uo_attachments.height = height

refresh_tabtext()

return 1

end function

public subroutine refresh ();long ll_count

if first_time then
	uo_attachments.initialize("Encounter", parent_tab.service.encounter_id)
	first_time = false
end if

ll_count = uo_attachments.refresh()
refresh_tabtext()

end subroutine

public subroutine refresh_tabtext ();long ll_count

ll_count = sqlca.fn_count_attachments(current_patient.cpr_id, "Encounter", parent_tab.service.encounter_id)
if ll_count > 0 then
	text = "Attachments " + string(ll_count)
else
	text = "Attachments"
end if

end subroutine

on u_tabpage_encounter_attachments.create
int iCurrent
call super::create
this.uo_attachments=create uo_attachments
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_attachments
end on

on u_tabpage_encounter_attachments.destroy
call super::destroy
destroy(this.uo_attachments)
end on

type uo_attachments from u_attachments within u_tabpage_encounter_attachments
integer taborder = 30
end type

on uo_attachments.destroy
call u_attachments::destroy
end on

event refreshed;call super::refreshed;refresh_tabtext()

end event

