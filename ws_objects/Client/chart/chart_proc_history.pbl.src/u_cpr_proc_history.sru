$PBExportHeader$u_cpr_proc_history.sru
forward
global type u_cpr_proc_history from u_cpr_page_base
end type
type dw_history from u_dw_pick_list within u_cpr_proc_history
end type
end forward

global type u_cpr_proc_history from u_cpr_page_base
dw_history dw_history
end type
global u_cpr_proc_history u_cpr_proc_history

forward prototypes
public subroutine initialize (u_cpr_section puo_section, integer pi_page)
public subroutine refresh ()
end prototypes

public subroutine initialize (u_cpr_section puo_section, integer pi_page);this_section = puo_section
this_page = pi_page

dw_history.width = width
dw_history.height = height

end subroutine

public subroutine refresh ();integer i
long ll_row
long ll_count
string ls_description, ls_bitmap
str_treatment_description lstra_treatments[]
str_encounter_description lstr_encounter
string ls_find
integer li_sts

setnull(lstr_encounter.encounter_id)

dw_history.setredraw(false)
dw_history.reset()

ls_find = "treatment_type='PROCEDURE'"

ll_count = current_patient.treatments.get_treatments(ls_find, lstra_treatments)

for i = 1 to ll_count
	ls_description = f_treatment_full_description(lstra_treatments[i], lstr_encounter)
	ls_bitmap = datalist.treatment_type_icon(lstra_treatments[i].treatment_type)
	if not isnull(ls_description) then
		ll_row = dw_history.insertrow(0)
		dw_history.setitem(ll_row, "bitmap", ls_bitmap)
		dw_history.setitem(ll_row, "proc", ls_description)
		dw_history.setitem(ll_row, "start_date", lstra_treatments[i].begin_date)
	end if
next

dw_history.sort()
dw_history.setredraw(true)

end subroutine

on u_cpr_proc_history.create
int iCurrent
call super::create
this.dw_history=create dw_history
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_history
end on

on u_cpr_proc_history.destroy
call super::destroy
destroy(this.dw_history)
end on

type dw_history from u_dw_pick_list within u_cpr_proc_history
integer width = 2642
string dataobject = "dw_proc_history"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

