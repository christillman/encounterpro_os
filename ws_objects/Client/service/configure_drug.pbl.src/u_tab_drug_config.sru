$PBExportHeader$u_tab_drug_config.sru
forward
global type u_tab_drug_config from u_tab_manager
end type
type tabpage_properties from u_tabpage_drug_properties within u_tab_drug_config
end type
type tabpage_properties from u_tabpage_drug_properties within u_tab_drug_config
end type
type tabpage_procedures from u_tabpage_drug_procedures within u_tab_drug_config
end type
type tabpage_procedures from u_tabpage_drug_procedures within u_tab_drug_config
end type
type tabpage_vaccine_disease from u_tabpage_drug_vaccine_disease within u_tab_drug_config
end type
type tabpage_vaccine_disease from u_tabpage_drug_vaccine_disease within u_tab_drug_config
end type
type tabpage_packages from u_tabpage_drug_packages within u_tab_drug_config
end type
type tabpage_packages from u_tabpage_drug_packages within u_tab_drug_config
end type
type tabpage_admin from u_tabpage_drug_admin within u_tab_drug_config
end type
type tabpage_admin from u_tabpage_drug_admin within u_tab_drug_config
end type
type tabpage_categories from u_tabpage_drug_categories within u_tab_drug_config
end type
type tabpage_categories from u_tabpage_drug_categories within u_tab_drug_config
end type
type tabpage_specialties from u_tabpage_drug_specialties within u_tab_drug_config
end type
type tabpage_specialties from u_tabpage_drug_specialties within u_tab_drug_config
end type
type tabpage_billing from u_tabpage_drug_billing within u_tab_drug_config
end type
type tabpage_billing from u_tabpage_drug_billing within u_tab_drug_config
end type
type tabpage_makers from u_tabpage_drug_makers within u_tab_drug_config
end type
type tabpage_makers from u_tabpage_drug_makers within u_tab_drug_config
end type
type tabpage_mappings from u_tabpage_drug_mappings within u_tab_drug_config
end type
type tabpage_mappings from u_tabpage_drug_mappings within u_tab_drug_config
end type
end forward

global type u_tab_drug_config from u_tab_manager
integer width = 2967
integer height = 1500
long backcolor = 7191717
boolean boldselectedtext = true
boolean createondemand = false
tabposition tabposition = tabsonbottom!
tabpage_properties tabpage_properties
tabpage_procedures tabpage_procedures
tabpage_vaccine_disease tabpage_vaccine_disease
tabpage_packages tabpage_packages
tabpage_admin tabpage_admin
tabpage_categories tabpage_categories
tabpage_specialties tabpage_specialties
tabpage_billing tabpage_billing
tabpage_makers tabpage_makers
tabpage_mappings tabpage_mappings
end type
global u_tab_drug_config u_tab_drug_config

type variables
str_drug_definition drug

end variables

forward prototypes
public function integer initialize_drug_tabs (string ps_drug_id)
end prototypes

public function integer initialize_drug_tabs (string ps_drug_id);integer li_sts
integer i
u_tabpage_drug_base luo_tab

service = current_service

if isnull(ps_drug_id) or trim(ps_drug_id) = "" then
	log.log(this, "u_tab_drug_config.initialize_drug_tabs:0008", "No Drug_id", 4)
	return -1
end if

// We don't want a cached drug for this, so clear the drug cache and reload the drug definition
drugdb.clear_cache()
li_sts = drugdb.get_drug_definition(ps_drug_id, drug)
if li_sts <= 0 then
	log.log(this, "u_tab_drug_config.initialize_drug_tabs:0016", "Error getting drug definition (" + ps_drug_id + ")", 4)
	return -1
end if


page_count = upperbound(control)

for i = 1 to page_count
	pages[i] = control[i]
	luo_tab = pages[i]
	luo_tab.parent_tab = this
	luo_tab.drug_tab = this
	luo_tab.initialize()
next

return 1

end function

on u_tab_drug_config.create
this.tabpage_properties=create tabpage_properties
this.tabpage_procedures=create tabpage_procedures
this.tabpage_vaccine_disease=create tabpage_vaccine_disease
this.tabpage_packages=create tabpage_packages
this.tabpage_admin=create tabpage_admin
this.tabpage_categories=create tabpage_categories
this.tabpage_specialties=create tabpage_specialties
this.tabpage_billing=create tabpage_billing
this.tabpage_makers=create tabpage_makers
this.tabpage_mappings=create tabpage_mappings
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_properties
this.Control[iCurrent+2]=this.tabpage_procedures
this.Control[iCurrent+3]=this.tabpage_vaccine_disease
this.Control[iCurrent+4]=this.tabpage_packages
this.Control[iCurrent+5]=this.tabpage_admin
this.Control[iCurrent+6]=this.tabpage_categories
this.Control[iCurrent+7]=this.tabpage_specialties
this.Control[iCurrent+8]=this.tabpage_billing
this.Control[iCurrent+9]=this.tabpage_makers
this.Control[iCurrent+10]=this.tabpage_mappings
end on

on u_tab_drug_config.destroy
call super::destroy
destroy(this.tabpage_properties)
destroy(this.tabpage_procedures)
destroy(this.tabpage_vaccine_disease)
destroy(this.tabpage_packages)
destroy(this.tabpage_admin)
destroy(this.tabpage_categories)
destroy(this.tabpage_specialties)
destroy(this.tabpage_billing)
destroy(this.tabpage_makers)
destroy(this.tabpage_mappings)
end on

type tabpage_properties from u_tabpage_drug_properties within u_tab_drug_config
integer x = 18
integer y = 16
integer width = 2930
integer height = 1372
string text = "Properties"
end type

type tabpage_procedures from u_tabpage_drug_procedures within u_tab_drug_config
integer x = 18
integer y = 16
integer width = 2930
integer height = 1372
string text = "Procedures"
end type

type tabpage_vaccine_disease from u_tabpage_drug_vaccine_disease within u_tab_drug_config
integer x = 18
integer y = 16
integer width = 2930
integer height = 1372
string text = "Diseases"
end type

type tabpage_packages from u_tabpage_drug_packages within u_tab_drug_config
integer x = 18
integer y = 16
integer width = 2930
integer height = 1372
string text = "Packages"
end type

type tabpage_admin from u_tabpage_drug_admin within u_tab_drug_config
integer x = 18
integer y = 16
integer width = 2930
integer height = 1372
string text = "Administration"
end type

type tabpage_categories from u_tabpage_drug_categories within u_tab_drug_config
integer x = 18
integer y = 16
integer width = 2930
integer height = 1372
string text = "Categories"
end type

type tabpage_specialties from u_tabpage_drug_specialties within u_tab_drug_config
integer x = 18
integer y = 16
integer width = 2930
integer height = 1372
string text = "Specialties"
end type

type tabpage_billing from u_tabpage_drug_billing within u_tab_drug_config
integer x = 18
integer y = 16
integer width = 2930
integer height = 1372
string text = "HCPCS"
end type

type tabpage_makers from u_tabpage_drug_makers within u_tab_drug_config
integer x = 18
integer y = 16
integer width = 2930
integer height = 1372
string text = "Makers"
end type

type tabpage_mappings from u_tabpage_drug_mappings within u_tab_drug_config
integer x = 18
integer y = 16
integer width = 2930
integer height = 1372
string text = "Drug Codes"
end type

