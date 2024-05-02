$PBExportHeader$u_dw_prior_drugs_list.sru
forward
global type u_dw_prior_drugs_list from u_dw_pick_list
end type
end forward

global type u_dw_prior_drugs_list from u_dw_pick_list
integer width = 2107
integer height = 1044
string dataobject = "dw_treatment_list"
end type
global u_dw_prior_drugs_list u_dw_prior_drugs_list

forward prototypes
public function integer load_treatments ()
end prototypes

public function integer load_treatments ();

long ll_count
string ls_find
long i, ll_row

str_treatment_description lstra_treatments[]
str_encounter_description lstr_encounter

ls_find = "treatment_type='PRIORMEDICATION' AND ISNULL(treatment_status)"
ll_count = current_patient.treatments.get_treatments(ls_find, lstra_treatments)
for i = 1 to ll_count
	ll_row = this.insertrow(0)
	this.object.treatment_id[ll_row] = lstra_treatments[i].treatment_id
	this.object.description[ll_row] = f_treatment_full_description(lstra_treatments[i], lstr_encounter)
	this.object.icon_bitmap[ll_row] = datalist.treatment_type_icon(lstra_treatments[i].treatment_type)
	this.object.selected_flag[ll_row] = 0
next

RETURN ll_count
end function

on u_dw_prior_drugs_list.create
call super::create
end on

on u_dw_prior_drugs_list.destroy
call super::destroy
end on

