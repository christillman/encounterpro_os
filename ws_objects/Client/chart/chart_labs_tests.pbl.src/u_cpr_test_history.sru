$PBExportHeader$u_cpr_test_history.sru
forward
global type u_cpr_test_history from u_cpr_page_base
end type
type dw_history from u_dw_pick_list within u_cpr_test_history
end type
end forward

global type u_cpr_test_history from u_cpr_page_base
dw_history dw_history
end type
global u_cpr_test_history u_cpr_test_history

forward prototypes
public subroutine initialize (u_cpr_section puo_section, integer pi_page)
public subroutine refresh ()
end prototypes

public subroutine initialize (u_cpr_section puo_section, integer pi_page);this_section = puo_section
this_page = pi_page

dw_history.width = width
dw_history.height = height

end subroutine

public subroutine refresh ();/* ModIFied by Sumathi Chinnasamy On 08/04/99 */
/* Included unperformed lab/test functionality */

Real				lr_result_amount
Boolean 			lb_loop
Long				ll_last_treatment_id, ll_row, ll_treatment_id, ll_result_attachment_id
Long				ll_encounter_id, ll_objective_attachment_id,ll_last_encounter_id
Integer			li_sort1, li_sort2,li_location_count,li_result_sequence, i , li_count
Integer			li_result_sort_sequence, li_location_sort_sequence, li_type_sort_order
Datetime			ldt_last_begin_date, ldt_begin_date, ldt_result_date_time
String			ls_treatment_type
String			ls_objecttype, ls_objectkey, ls_objectdesc,ls_objectcollapsedbitmap
String			ls_last_observation_id,ls_last_location, ls_last_location_description
String			ls_last_observation_description,  ls_objectexpANDedbitmap
String 			ls_last_bitmap, ls_last_observation_type, ls_last_user_id
String			ls_result_list, ls_result_item, ls_temp, ls_location_item, ls_location_list
String			ls_collection_location_domain,ls_perform_location_domain, ls_last_perform_location_domain
String			ls_observation_id, ls_location
String			ls_observation_description, ls_result_unit, ls_result
String			ls_result_amount_flag, ls_abnormal_flag, ls_result_status
String			ls_location_description, ls_observation_type, ls_bitmap
String			ls_send_out_flag, ls_user_id, ls_find
/* object declaration */
u_user								luo_user
str_treatment_description 		lstra_treatments[]

DECLARE	lsp_get_performed_history PROCEDURE FOR dbo.sp_get_performed_history  
         @ps_cpr_id = :current_patient.cpr_id ;

dw_history.setredraw(false)
dw_history.reset()

EXECUTE lsp_get_performed_history;
IF not tf_check() THEN RETURN

lb_loop = TRUE
setnull(ls_last_observation_id)
setnull(ls_last_location)
setnull(ll_last_encounter_id)

DO
	FETCH lsp_get_performed_history INTO
		:ll_treatment_id,
		:ls_observation_id,
		:ls_location,
		:li_result_sequence,
		:ll_encounter_id,
		:ll_result_attachment_id,
		:lr_result_amount,
		:ldt_result_date_time,
		:ls_observation_description,
		:ls_collection_location_domain,
		:ls_perform_location_domain,
		:ls_result_unit,
		:ls_result,
		:ls_result_amount_flag,
		:ls_abnormal_flag,
		:li_result_sort_sequence,
		:ls_result_status,
		:li_location_sort_sequence,
		:ls_location_description,
		:ls_observation_type,
		:li_type_sort_order,
		:ls_bitmap,
		:ll_objective_attachment_id,
		:ls_send_out_flag,
		:ldt_begin_date,
		:ls_user_id;
	IF not tf_check() THEN RETURN

	IF sqlca.sqlcode = 100 THEN
		lb_loop = false
		setnull(ls_observation_id)
		setnull(ls_location)
	ELSE
		IF ls_result_amount_flag = "Y" AND not isnull(lr_result_amount) THEN
			ls_result_item = ls_result + "=" + f_pretty_amount_unit(lr_result_amount, ls_result_unit)
		ELSE
			ls_result_item = ls_result
		END IF
	END IF

	IF ls_observation_id = ls_last_observation_id &
    AND ll_treatment_id = ll_last_treatment_id &
	 AND ls_location = ls_last_location &
	 AND ll_encounter_id = ll_last_encounter_id THEN
			ls_result_list += "; " + ls_result_item
	ELSE
		IF not isnull(ls_last_location) THEN
			IF ls_last_perform_location_domain = "NA" THEN
				ls_location_item = ls_result_list
			ELSE
				ls_location_item = ls_last_location_description + " - " + ls_result_list
			END IF

			IF li_location_count > 0 THEN
				ls_location_list += "~n" + ls_location_item
				li_location_count += 1
			ELSE
				ls_location_list = ls_location_item
				li_location_count = 1
			END IF
		END IF

		ls_last_location = ls_location
		ls_last_perform_location_domain = ls_perform_location_domain
		ls_last_location_description = ls_location_description
		ls_result_list = ls_result_item
	END IF

	IF ls_observation_id = ls_last_observation_id &
     AND ll_treatment_id = ll_last_treatment_id &
	  AND ll_encounter_id = ll_last_encounter_id THEN
	ELSE
		IF not isnull(ls_last_observation_id) THEN
			ls_objecttype = "OBJECTIVE_" + ls_last_observation_type
			ls_objectkey = String(ll_last_treatment_id) + "," + ls_last_observation_id

			ls_objectdesc = String(ldt_last_begin_date, date_format_String)

			IF li_location_count = 1 THEN
				ls_objectdesc += "  " + ls_last_observation_description + ": " + ls_location_list
			ELSE
				ls_objectdesc += "  " + ls_last_observation_description + "~n" + ls_location_list
			END IF

			ll_row = dw_history.insertrow(0)
			dw_history.SetItem(ll_row, "performed_date_time", ldt_last_begin_date)
			dw_history.SetItem(ll_row, "description", ls_objectdesc)
			dw_history.SetItem(ll_row, "bitmap", ls_last_bitmap)
			/* included by sumathi chinnasamy to show treatment status */
			dw_history.Setitem(ll_row,"treatment_status","CLOSED")
			dw_history.Setitem(ll_row,"sort_by_status",2)
	END IF

		ls_last_bitmap = ls_bitmap
		ls_last_observation_type = ls_observation_type
		ls_last_observation_id = ls_observation_id
		ls_last_observation_description = ls_observation_description
		ls_last_perform_location_domain = ls_perform_location_domain
		ll_last_treatment_id = ll_treatment_id
		ll_last_encounter_id = ll_encounter_id
		ls_last_user_id = ls_user_id
		ldt_last_begin_date = ldt_begin_date
		li_location_count = 0
	END IF

LOOP WHILE lb_loop

CLOSE lsp_get_performed_history;

/* Included by Sumathi Chinnasamy On 08/04/99 => populate records for treatment status other than 'Closed' */

ls_find = "(treatment_type = 'TEST')"
ls_find += " And (isnull(treatment_status) OR treatment_status = 'COLLECTED' OR treatment_status = 'NEEDSAMPLE')"
li_count = current_patient.treatments.get_treatments(ls_find, lstra_treatments)
FOR i = 1 TO li_count
	ll_row = dw_history.Insertrow(0)
	dw_history.Setitem(ll_row,"performed_date_time",lstra_treatments[i].begin_date)
	// By Sumathi Chinnasamy On 11/26/1999 - Included begin date with description
	ls_objectdesc = String(lstra_treatments[i].begin_date, date_format_String)
	ls_treatment_type = lstra_treatments[i].treatment_type
	dw_history.Setitem(ll_row,"description",ls_objectdesc+space(2)+lstra_treatments[i].treatment_description)
	dw_history.Setitem(ll_row,"bitmap",datalist.treatment_type_icon(ls_treatment_type))
	dw_history.Setitem(ll_row,"treatment_status",lstra_treatments[i].treatment_status)
	dw_history.Setitem(ll_row,"sort_by_status",1)
NEXT
dw_history.Setsort("sort_by_status A,treatment_status A,performed_date_time D")
dw_history.Sort()
dw_history.Groupcalc()
dw_history.Setredraw(TRUE)

end subroutine

on u_cpr_test_history.create
int iCurrent
call super::create
this.dw_history=create dw_history
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_history
end on

on u_cpr_test_history.destroy
call super::destroy
destroy(this.dw_history)
end on

type dw_history from u_dw_pick_list within u_cpr_test_history
integer width = 2642
string dataobject = "dw_test_history"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

