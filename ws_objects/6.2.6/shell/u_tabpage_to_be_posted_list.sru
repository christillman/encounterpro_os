HA$PBExportHeader$u_tabpage_to_be_posted_list.sru
forward
global type u_tabpage_to_be_posted_list from u_tabpage_incoming_documents_base
end type
end forward

global type u_tabpage_to_be_posted_list from u_tabpage_incoming_documents_base
end type
global u_tabpage_to_be_posted_list u_tabpage_to_be_posted_list

type variables
u_tab_to_be_posted_lists parent_lists

end variables

forward prototypes
public function integer initialize ()
end prototypes

public function integer initialize ();
super::initialize()

parent_lists = parent_tab

return 1

end function

on u_tabpage_to_be_posted_list.create
int iCurrent
call super::create
end on

on u_tabpage_to_be_posted_list.destroy
call super::destroy
end on

event patient_posted;call super::patient_posted;string ls_patient_name

SELECT dbo.fn_patient_full_name(:ps_cpr_id)
INTO :ls_patient_name
FROM c_1_record;
if not tf_check() then return

parent_lists.event POST patient_posted(ps_cpr_id, ls_patient_name)

end event

type st_attachment_details from u_tabpage_incoming_documents_base`st_attachment_details within u_tabpage_to_be_posted_list
end type

type cb_clear_all from u_tabpage_incoming_documents_base`cb_clear_all within u_tabpage_to_be_posted_list
end type

type cb_select_all from u_tabpage_incoming_documents_base`cb_select_all within u_tabpage_to_be_posted_list
end type

type cb_sort from u_tabpage_incoming_documents_base`cb_sort within u_tabpage_to_be_posted_list
end type

type dw_holding_list from u_tabpage_incoming_documents_base`dw_holding_list within u_tabpage_to_be_posted_list
end type

type uo_picture from u_tabpage_incoming_documents_base`uo_picture within u_tabpage_to_be_posted_list
end type

