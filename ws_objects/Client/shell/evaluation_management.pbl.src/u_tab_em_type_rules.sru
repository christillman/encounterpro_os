$PBExportHeader$u_tab_em_type_rules.sru
forward
global type u_tab_em_type_rules from u_tab_manager
end type
type tabpage_rules from u_tabpage_em_type_rules within u_tab_em_type_rules
end type
type tabpage_rules from u_tabpage_em_type_rules within u_tab_em_type_rules
end type
type tabpage_data from u_tabpage_em_type_data within u_tab_em_type_rules
end type
type tabpage_data from u_tabpage_em_type_data within u_tab_em_type_rules
end type
end forward

global type u_tab_em_type_rules from u_tab_manager
integer width = 3127
integer height = 1556
long backcolor = 7191717
boolean boldselectedtext = true
boolean createondemand = false
tabposition tabposition = tabsonbottom!
tabpage_rules tabpage_rules
tabpage_data tabpage_data
event highest_rule_passed ( long pl_highest_rule_passed )
end type
global u_tab_em_type_rules u_tab_em_type_rules

type variables
string em_documentation_guide
string em_component
string em_type

string cpr_id
long encounter_id

w_window_base my_window

end variables

on u_tab_em_type_rules.create
this.tabpage_rules=create tabpage_rules
this.tabpage_data=create tabpage_data
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_rules
this.Control[iCurrent+2]=this.tabpage_data
end on

on u_tab_em_type_rules.destroy
call super::destroy
destroy(this.tabpage_rules)
destroy(this.tabpage_data)
end on

type tabpage_rules from u_tabpage_em_type_rules within u_tab_em_type_rules
integer x = 18
integer y = 16
integer width = 3090
integer height = 1428
string text = "E&M Rules"
end type

type tabpage_data from u_tabpage_em_type_data within u_tab_em_type_rules
integer x = 18
integer y = 16
integer width = 3090
integer height = 1428
string text = "Encounter Data"
end type

