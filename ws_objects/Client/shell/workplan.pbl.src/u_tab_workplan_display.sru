$PBExportHeader$u_tab_workplan_display.sru
forward
global type u_tab_workplan_display from u_tab_manager
end type
end forward

global type u_tab_workplan_display from u_tab_manager
integer width = 2071
integer height = 1216
long backcolor = 7191717
end type
global u_tab_workplan_display u_tab_workplan_display

type variables
str_p_patient_wp patient_workplan

end variables

forward prototypes
public function integer initialize (string ps_context_object, long pl_object_key)
public function integer initialize (long pl_patient_workplan_id)
public function integer initialize (str_context pstr_context)
end prototypes

public function integer initialize (string ps_context_object, long pl_object_key);str_context lstr_context

lstr_context.cpr_id = current_patient.cpr_id
lstr_context.context_object = ps_context_object
lstr_context.object_key = pl_object_key

return initialize(lstr_context)

end function

public function integer initialize (long pl_patient_workplan_id);long ll_count
long i
u_ds_data luo_workplans
//string ls_workplan_description
//string ls_workplan_type
u_tabpage_workplan_display luo_tabpage
string ls_tabtext
integer li_main_count
integer li_sts

li_sts = datalist.clinical_data_cache.patient_workplan(pl_patient_workplan_id, patient_workplan)
if li_sts <= 0 then return -1


//ls_workplan_description = luo_workplans.object.description[i]
//ls_workplan_type = luo_workplans.object.workplan_type[i]

luo_tabpage = open_page("u_tabpage_workplan_display")

CHOOSE CASE upper(patient_workplan.workplan_type)
	CASE "REFERRAL", "FOLLOWUP"
		ls_tabtext = wordcap(patient_workplan.workplan_type)
	CASE ELSE
		li_main_count += 1
		if li_main_count > 1 then
			ls_tabtext = "Workplan #" + string(li_main_count)
		else
			ls_tabtext = "Primary"
		end if
END CHOOSE
luo_tabpage.text = ls_tabtext
luo_tabpage.set_workplan(pl_patient_workplan_id)

// Open a tabpage for the Manual Services
//luo_tabpage = open_page("u_tabpage_workplan_display")
//luo_tabpage.text = "Manual Services"
//luo_tabpage.set_manual_services(ps_context_object, pl_object_key)


return 1

end function

public function integer initialize (str_context pstr_context);long ll_count
long i
u_ds_data luo_workplans
string ls_workplan_description
string ls_workplan_type
long ll_patient_workplan_id
u_tabpage_workplan_display luo_tabpage
string ls_tabtext
integer li_main_count
long ll_workplan_id

luo_workplans = CREATE u_ds_data
luo_workplans.set_dataobject("dw_sp_patient_object_workplans")
ll_count = luo_workplans.retrieve(pstr_context.cpr_id, pstr_context.context_object, pstr_context.object_key)

if ll_count < 0 then return -1
if ll_count = 0 then return 0

for i = 1 to ll_count
	ll_patient_workplan_id = luo_workplans.object.patient_workplan_id[i]
	ls_workplan_description = luo_workplans.object.description[i]
	ls_workplan_type = luo_workplans.object.workplan_type[i]
	ll_workplan_id = luo_workplans.object.workplan_id[i]
	
	luo_tabpage = open_page("u_tabpage_workplan_display")
	
	CHOOSE CASE upper(ls_workplan_type)
		CASE "REFERRAL", "FOLLOWUP"
			ls_tabtext = wordcap(ls_workplan_type)
		CASE ELSE
			if ll_workplan_id > 0 then
				li_main_count += 1
				if li_main_count > 1 then
					ls_tabtext = "Workplan #" + string(li_main_count)
				else
					ls_tabtext = "Primary"
				end if
			else
				ls_tabtext = "Manual Services"
			end if
	END CHOOSE
	luo_tabpage.text = ls_tabtext
	luo_tabpage.set_workplan(ll_patient_workplan_id)
next



return 1

end function

