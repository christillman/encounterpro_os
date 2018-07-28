HA$PBExportHeader$u_tab_vials_for_injection.sru
forward
global type u_tab_vials_for_injection from u_tab_manager
end type
end forward

global type u_tab_vials_for_injection from u_tab_manager
integer width = 2921
integer height = 1576
long backcolor = 33538240
boolean boldselectedtext = true
boolean createondemand = false
tabposition tabposition = tabsonbottom!
end type
global u_tab_vials_for_injection u_tab_vials_for_injection

type variables
u_component_service		service

end variables

forward prototypes
public function integer initialize ()
end prototypes

public function integer initialize ();long				ll_rowcount
long				ll_treatment_id
string			ls_cpr_id,ls_desc
string			ls_tabpage_injection = "u_tabpage_allergy_injection"
integer			i

u_ds_data 						luo_allergy_trts
u_tabpage	luo_page


ls_cpr_id = current_patient.cpr_id

luo_allergy_trts = CREATE u_ds_data
luo_allergy_trts.set_dataobject("dw_sp_get_open_allergy_treatments", sqlca)

ll_rowcount = luo_allergy_trts.retrieve(ls_cpr_id)

If ll_rowcount <= 0 Then
	log.log(this,"initialize()","no open allergy treatments",3)
	return -1
End If

For i = 1 to ll_rowcount
	luo_page = open_page(ls_tabpage_injection, false)

	ls_desc = luo_allergy_trts.object.treatment_description[i]
	ll_treatment_id = luo_allergy_trts.object.treatment_id[i]
	
	luo_page.text = ls_desc
	luo_page.initialize(string(ll_treatment_id))
Next

destroy luo_allergy_trts

Return 1
end function

