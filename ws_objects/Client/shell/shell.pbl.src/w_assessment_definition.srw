$PBExportHeader$w_assessment_definition.srw
forward
global type w_assessment_definition from w_window_base
end type
type st_title from statictext within w_assessment_definition
end type
type tab_assessment from u_tab_assessment_definition within w_assessment_definition
end type
type tab_assessment from u_tab_assessment_definition within w_assessment_definition
end type
type cb_ok from commandbutton within w_assessment_definition
end type
type cb_cancel from commandbutton within w_assessment_definition
end type
end forward

global type w_assessment_definition from w_window_base
integer width = 2944
integer height = 1848
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_title st_title
tab_assessment tab_assessment
cb_ok cb_ok
cb_cancel cb_cancel
end type
global w_assessment_definition w_assessment_definition

type variables
boolean allow_editing

string assessment_id

end variables

forward prototypes
public function integer load_assessment ()
public function integer save_assessment ()
end prototypes

public function integer load_assessment ();string ls_assessment_category_id
string ls_category_description
string ls_description
string ls_icd_9_code
string ls_assessment_type
string ls_location_domain
long ll_auto_close_interval_amount
string ls_auto_close_interval_unit
long ll_em_risk_level
long ll_complexity
string ls_long_description
string ls_acuteness
string ls_auto_close
integer li_sts
long ll_billing_id
u_unit luo_unit
string ls_temp
integer li_default_interval
string ls_default_interval_unit
string ls_left
string ls_right
string	ls_desc,ls_icon
long ll_patient_reference_material_id
long ll_provider_reference_material_id
string ls_status
long ll_owner_id

tab_assessment.tabpage_info.assessment_id = assessment_id
tab_assessment.tabpage_info.allow_editing = allow_editing

tab_assessment.tabpage_long_description.assessment_id = assessment_id
tab_assessment.tabpage_long_description.allow_editing = allow_editing

tab_assessment.tabpage_acuteness.assessment_id = assessment_id
tab_assessment.tabpage_acuteness.allow_editing = allow_editing

tab_assessment.tabpage_drugs.assessment_id = assessment_id
tab_assessment.tabpage_drugs.allow_editing = allow_editing

tab_assessment.tabpage_health_maintenance.assessment_id = assessment_id
tab_assessment.tabpage_health_maintenance.allow_editing = allow_editing




  SELECT assessment_type,
  			description,
			icd_9_code,
			auto_close,
			location_domain,
			assessment_category_id,
			billing_code,
			auto_close_interval_amount,
			auto_close_interval_unit,
			risk_level,
			complexity,
			long_description,
			acuteness,
			status,
			patient_reference_material_id,
			provider_reference_material_id,
			owner_id
    INTO :ls_assessment_type,
	 		:ls_description,
			:ls_icd_9_code,
			:ls_auto_close,
			:ls_location_domain,
			:ls_assessment_category_id,
			:ll_billing_id,
			:ll_auto_close_interval_amount,
			:ls_auto_close_interval_unit,
			:ll_em_risk_level,
			:ll_complexity,
			:ls_long_description,
			:ls_acuteness,
			:ls_status,
			:ll_patient_reference_material_id,
			:ll_provider_reference_material_id,
			:ll_owner_id
    FROM c_Assessment_Definition (NOLOCK)
   WHERE assessment_id = :assessment_id;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then return 0


// Set the title
st_title.text = ls_description
if len(ls_icd_9_code) > 0 and pos(ls_description, ls_icd_9_code) = 0 then
	st_title.text += " <" + ls_icd_9_code + ">"
end if

// 7 fields on tabpage_info
tab_assessment.tabpage_info.assessment_type = ls_assessment_type
tab_assessment.tabpage_info.assessment_category_id = ls_assessment_category_id
tab_assessment.tabpage_info.description = ls_description
tab_assessment.tabpage_info.icd_9_code = ls_icd_9_code
tab_assessment.tabpage_info.em_risk_level = ll_em_risk_level
tab_assessment.tabpage_info.complexity = ll_complexity
tab_assessment.tabpage_info.location_domain = ls_location_domain
tab_assessment.tabpage_info.patient_reference_material_id = ll_patient_reference_material_id
tab_assessment.tabpage_info.provider_reference_material_id = ll_provider_reference_material_id
tab_assessment.tabpage_info.status = ls_status
tab_assessment.tabpage_info.owner_id = ll_owner_id

// 1 field on tabpage_long_description
tab_assessment.tabpage_long_description.long_description = ls_long_description

// 4 fields on tabpage_acuteness
tab_assessment.tabpage_acuteness.acuteness = ls_acuteness
tab_assessment.tabpage_acuteness.auto_close = ls_auto_close
tab_assessment.tabpage_acuteness.auto_close_interval_amount = ll_auto_close_interval_amount
tab_assessment.tabpage_acuteness.auto_close_interval_unit = ls_auto_close_interval_unit


if upper(ls_assessment_type) = "ALLERGY" and upper(ls_assessment_category_id) = "DA" then
	tab_assessment.tabpage_drugs.visible = true
else
	tab_assessment.tabpage_drugs.visible = false
end if

//postevent("check_billing")

tab_assessment.initialize()

return 1

end function

public function integer save_assessment ();integer li_sts


UPDATE c_Assessment_Definition
SET description = :tab_assessment.tabpage_info.description,
	assessment_category_id = :tab_assessment.tabpage_info.assessment_category_id,
	icd_9_code = :tab_assessment.tabpage_info.icd_9_code,
	risk_level = :tab_assessment.tabpage_info.em_risk_level,
	complexity = :tab_assessment.tabpage_info.complexity,
	location_domain = :tab_assessment.tabpage_info.location_domain,
	long_description = :tab_assessment.tabpage_long_description.long_description,
	auto_close = :tab_assessment.tabpage_acuteness.auto_close,
	auto_close_interval_amount = :tab_assessment.tabpage_acuteness.auto_close_interval_amount,
	auto_close_interval_unit = :tab_assessment.tabpage_acuteness.auto_close_interval_unit,
	acuteness = :tab_assessment.tabpage_acuteness.acuteness,
	patient_reference_material_id = :tab_assessment.tabpage_info.patient_reference_material_id,
	provider_reference_material_id = :tab_assessment.tabpage_info.provider_reference_material_id,
	status = :tab_assessment.tabpage_info.status
WHERE assessment_id = :assessment_id;
if not tf_check() then return -1

// drugs tab
li_sts = tab_assessment.tabpage_drugs.dw_drugs.update()
if li_sts < 0 then return -1

return 1

end function

event open;call super::open;str_popup popup
integer li_sts

assessment_id = message.stringparm

if user_list.is_user_service(current_user.user_id, "CONFIG_ASSESSMENTS") then
	allow_editing = true
else
	allow_editing = false
end if

li_sts = load_assessment()
if li_sts <= 0 then
	close(this)
	return
end if


end event

on w_assessment_definition.create
int iCurrent
call super::create
this.st_title=create st_title
this.tab_assessment=create tab_assessment
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.tab_assessment
this.Control[iCurrent+3]=this.cb_ok
this.Control[iCurrent+4]=this.cb_cancel
end on

on w_assessment_definition.destroy
call super::destroy
destroy(this.st_title)
destroy(this.tab_assessment)
destroy(this.cb_ok)
destroy(this.cb_cancel)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_assessment_definition
integer x = 2670
integer y = 16
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_assessment_definition
end type

type st_title from statictext within w_assessment_definition
integer width = 2926
integer height = 108
integer textsize = -22
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Assessment Definition"
alignment alignment = center!
boolean focusrectangle = false
end type

type tab_assessment from u_tab_assessment_definition within w_assessment_definition
integer y = 124
integer width = 2944
integer taborder = 20
boolean bringtotop = true
end type

type cb_ok from commandbutton within w_assessment_definition
integer x = 2414
integer y = 1712
integer width = 489
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;integer li_sts

li_sts = save_assessment()
if li_sts <= 0 then 
	openwithparm(w_pop_message, "An error occured saving the assessment")
	return
end if

datalist.clear_cache("assessments")

close(parent)

end event

type cb_cancel from commandbutton within w_assessment_definition
integer x = 27
integer y = 1712
integer width = 489
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;close(parent)

end event

