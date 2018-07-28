HA$PBExportHeader$u_tab_interface_domain_mappings.sru
forward
global type u_tab_interface_domain_mappings from u_tab_manager
end type
type tabpage_code_mappings from u_tabpage_interface_code_mappings within u_tab_interface_domain_mappings
end type
type tabpage_code_mappings from u_tabpage_interface_code_mappings within u_tab_interface_domain_mappings
end type
type tabpage_epro_id_mappings from u_tabpage_interface_code_mappings within u_tab_interface_domain_mappings
end type
type tabpage_epro_id_mappings from u_tabpage_interface_code_mappings within u_tab_interface_domain_mappings
end type
end forward

global type u_tab_interface_domain_mappings from u_tab_manager
integer width = 2053
integer height = 1308
long backcolor = 33538240
boolean boldselectedtext = true
boolean createondemand = false
tabposition tabposition = tabsonbottom!
tabpage_code_mappings tabpage_code_mappings
tabpage_epro_id_mappings tabpage_epro_id_mappings
event mappingchanged ( )
end type
global u_tab_interface_domain_mappings u_tab_interface_domain_mappings

type variables
long interface_owner_id
string code_domain
string code_version

string mapping_filter
string document_code_domain_filter
string document_mapping_filter

string successful_document_mappings
string failed_document_mappings
string all_document_mappings

string successful_codes
string failed_codes
string all_codes

u_component_wp_item_document document

string document_direction
end variables

on u_tab_interface_domain_mappings.create
this.tabpage_code_mappings=create tabpage_code_mappings
this.tabpage_epro_id_mappings=create tabpage_epro_id_mappings
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_code_mappings
this.Control[iCurrent+2]=this.tabpage_epro_id_mappings
end on

on u_tab_interface_domain_mappings.destroy
call super::destroy
destroy(this.tabpage_code_mappings)
destroy(this.tabpage_epro_id_mappings)
end on

type tabpage_code_mappings from u_tabpage_interface_code_mappings within u_tab_interface_domain_mappings
integer x = 18
integer y = 16
integer width = 2016
integer height = 1180
string text = "Interface Codes"
end type

type tabpage_epro_id_mappings from u_tabpage_interface_code_mappings within u_tab_interface_domain_mappings
string tag = "BY EPRO_ID"
integer x = 18
integer y = 16
integer width = 2016
integer height = 1180
string text = "EncounterPRO IDs"
end type

