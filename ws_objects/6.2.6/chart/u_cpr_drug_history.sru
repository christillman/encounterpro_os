HA$PBExportHeader$u_cpr_drug_history.sru
forward
global type u_cpr_drug_history from u_cpr_page_base
end type
type dw_history from u_dw_pick_list within u_cpr_drug_history
end type
end forward

global type u_cpr_drug_history from u_cpr_page_base
dw_history dw_history
end type
global u_cpr_drug_history u_cpr_drug_history

forward prototypes
public subroutine initialize (u_cpr_section puo_section, integer pi_page)
public subroutine refresh ()
end prototypes

public subroutine initialize (u_cpr_section puo_section, integer pi_page);this_section = puo_section
this_page = pi_page

dw_history.width = width
dw_history.height = height

end subroutine

public subroutine refresh ();/* Modified by sumathi Chinnasamy On 08/04/1999 */
/* Included treatment status in report and grouped records by treatment status */

/* variable declaration */
Integer								i
Long									ll_row
Long									ll_count
String								ls_drug
String								ls_find, ls_bitmap
Integer								li_sts
/* objects creation */
str_treatment_description 		lstra_treatments[]
str_encounter_description		lstr_encounter
Setnull(lstr_encounter.encounter_id)
dw_history.Setredraw(FALSE)
dw_history.Reset()

ls_find = "treatment_type='MEDICATION'" // AND NOT (open_encounter_id=close_encounter_id)"

ll_count = current_patient.treatments.get_treatments(ls_find, lstra_treatments)
FOR i = 1 TO ll_count
	ls_drug = f_treatment_full_description(lstra_treatments[i], lstr_encounter)
	IF NOT isnull(ls_drug) THEN
		ls_bitmap = datalist.treatment_type_icon(lstra_treatments[i].treatment_type)
		ll_row = dw_history.Insertrow(0)
		dw_history.setitem(ll_row, "bitmap",ls_bitmap)
		dw_history.setitem(ll_row, "drug", ls_drug)
		dw_history.setitem(ll_row, "start_date", lstra_treatments[i].begin_date)
		if isnull(lstra_treatments[i].treatment_status) then
			dw_history.Setitem(ll_row,"treatment_status","** CURRENT MEDICATIONS **")
			dw_history.Setitem(ll_row,"status_sort",1)
		else
			dw_history.Setitem(ll_row,"treatment_status","** PAST MEDICATIONS **")
			dw_history.Setitem(ll_row,"status_sort",2)
		end if
	END IF
NEXT

ls_find = "treatment_type='OFFICEMED' AND treatment_status = 'CLOSED'"

ll_count = current_patient.treatments.get_treatments(ls_find, lstra_treatments)
FOR i = 1 TO ll_count
	ls_drug = f_treatment_full_description(lstra_treatments[i], lstr_encounter)
	ls_bitmap = datalist.treatment_type_icon(lstra_treatments[i].treatment_type)
	IF NOT isnull(ls_drug) THEN
		ll_row = dw_history.Insertrow(0)
		dw_history.setitem(ll_row, "bitmap", ls_bitmap)
		dw_history.setitem(ll_row, "drug", ls_drug)
		dw_history.setitem(ll_row, "start_date", lstra_treatments[i].begin_date)
		dw_history.Setitem(ll_row,"treatment_status","** OFFICE MEDICATIONS **")
		dw_history.Setitem(ll_row,"status_sort",3)
	END IF
NEXT

dw_history.Sort()
dw_history.Groupcalc()
dw_history.Setredraw(TRUE)
end subroutine

on u_cpr_drug_history.create
int iCurrent
call super::create
this.dw_history=create dw_history
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_history
end on

on u_cpr_drug_history.destroy
call super::destroy
destroy(this.dw_history)
end on

type dw_history from u_dw_pick_list within u_cpr_drug_history
integer y = 4
integer width = 2642
string dataobject = "dw_drug_history"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

