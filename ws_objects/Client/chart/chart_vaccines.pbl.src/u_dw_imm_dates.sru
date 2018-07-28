$PBExportHeader$u_dw_imm_dates.sru
forward
global type u_dw_imm_dates from datawindow
end type
end forward

type str_diseases from structure
	long		disease_id
	string		description
	string		display_flag
end type

global type u_dw_imm_dates from datawindow
int Width=1161
int Height=592
int TabOrder=1
string DataObject="dw_immunization_dates"
boolean LiveScroll=true
end type
global u_dw_imm_dates u_dw_imm_dates

type variables

end variables

forward prototypes
public function integer load_dates ()
end prototypes

public function integer load_dates ();datetime ldt_due_date_time
integer li_status, i
long ll_row
str_diseases lstr_disease[]
integer li_disease_count
boolean lb_loop
long ll_disease_id
string ls_description
string ls_display_flag
integer li_sort_sequence

 DECLARE lsp_check_vaccine_status PROCEDURE FOR dbo.sp_check_vaccine_status  
         @ps_cpr_id = :current_patient.cpr_id,   
         @pl_disease_id = :lstr_disease[i].disease_id,   
         @pi_status = :li_status OUT,   
         @pdt_due_date_time = :ldt_due_date_time OUT ;

 DECLARE lsp_get_diseases PROCEDURE FOR dbo.sp_get_diseases;


setredraw(false)
reset()

lb_loop = true
li_disease_count = 0

EXECUTE lsp_get_diseases;
if not tf_check() then return -1

DO
	FETCH lsp_get_diseases
	INTO	:ll_disease_id,
			:ls_description,
			:ls_display_flag,
			:li_sort_sequence;
	if not tf_check() then return -1
	
	if sqlca.sqlcode = 0 then
		li_disease_count += 1
		lstr_disease[li_disease_count].disease_id = ll_disease_id
		lstr_disease[li_disease_count].description = ls_description
		lstr_disease[li_disease_count].display_flag = ls_display_flag
	else
		lb_loop = false
	end if
LOOP WHILE lb_loop

CLOSE lsp_get_diseases;

for i = 1 to li_disease_count
	if not (lstr_disease[i].display_flag = "Y") then continue
	EXECUTE lsp_check_vaccine_status;
	if not tf_check() then return -1

	FETCH lsp_check_vaccine_status INTO
		:li_status,
		:ldt_due_date_time;
	if not tf_check() then return -1

	CLOSE lsp_check_vaccine_status;

	if not isnull(li_status) then
		ll_row = insertrow(0)
		setitem(ll_row, 1, lstr_disease[i].disease_id)
		setitem(ll_row, 2, lstr_disease[i].description)
		setitem(ll_row, 3, date(ldt_due_date_time))
		setitem(ll_row, 4, li_status)
	end if
next

setredraw(true)

return rowcount()

end function

