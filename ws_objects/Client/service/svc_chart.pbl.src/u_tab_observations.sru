$PBExportHeader$u_tab_observations.sru
forward
global type u_tab_observations from u_tab_manager
end type
end forward

global type u_tab_observations from u_tab_manager
integer width = 1728
integer height = 1352
end type
global u_tab_observations u_tab_observations

type variables
u_component_service service

end variables

forward prototypes
public function integer initialize ()
end prototypes

public function integer initialize ();long ll_display_script_id
u_tabpage_patient_rtf luo_rtf
string ls_title
string ls_script_attribute
string ls_title_attribute
string ls_suffix
integer i

// See if we need to open an RTF page
i = 0
ls_script_attribute = "rtf_display_script_id"
ls_title_attribute = "rtf_display_script_title"
ls_suffix = ""
DO WHILE true
	if i > 0 then ls_suffix = "_" + string(i)
	
	service.get_attribute(ls_script_attribute + ls_suffix, ll_display_script_id)
	if isnull(ll_display_script_id) then exit

	ls_title = service.get_attribute(ls_title_attribute + ls_suffix)
	if isnull(ls_title) then ls_title = "Report"
	
	luo_rtf = open_page("u_tabpage_patient_rtf", false)
	if not isnull(luo_rtf) then
		luo_rtf.display_script_id = ll_display_script_id
		luo_rtf.text = ls_title
	end if
	
	i += 1
LOOP

return 1

end function

