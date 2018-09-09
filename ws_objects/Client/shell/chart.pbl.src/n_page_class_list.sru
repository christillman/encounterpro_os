$PBExportHeader$n_page_class_list.sru
forward
global type n_page_class_list from nonvisualobject
end type
end forward

global type n_page_class_list from nonvisualobject
end type
global n_page_class_list n_page_class_list

forward prototypes
public subroutine page_class_list ()
end prototypes

public subroutine page_class_list ();
// The purpose here is to reference objects which may not otherwise
// be referenced literally for cross reference purposes. 

// These objects are in c_Chart_Section_Page.page_class

int lx

lx = u_cpr_drug_history.x
lx = u_cpr_exit.x
lx = u_cpr_graph.x
lx = u_cpr_page_browser_nav.x
lx = u_cpr_page_growth_percentiles.x
lx = u_cpr_page_maintenance.x
lx = u_cpr_page_rtf.x
lx = u_immunization.x
lx = u_letters.x
lx = u_soap_page_assessments.x
lx = u_soap_page_observations.x
lx = u_summary_page.x


// These objects are in c_Chart_Page_Attribute.page_class

lx = u_soap_page_base_large.x
lx = u_soap_page_problem_list.x

// These objects are in c_Chart_Page_Definition.page_class

lx = u_cpr_drug_history.x
lx = u_cpr_exit.x
lx = u_cpr_family_history.x
lx = u_cpr_graph.x
// lx = u_cpr_history_tabs.x
lx = u_cpr_page_browser.x
lx = u_cpr_page_browser_nav.x
lx = u_cpr_page_growth_percentiles.x
// lx = u_cpr_page_history.x
lx = u_cpr_page_maintenance.x
lx = u_cpr_page_rtf.x
lx = u_cpr_proc_history.x
lx = u_cpr_test_history.x
// lx = u_develop.x
// lx = u_develop_combo.x
lx = u_immunization.x
lx = u_letters.x
// lx = u_problem_list.x
lx = u_soap_page_assessments.x
lx = u_soap_page_encounter_notes.x
lx = u_soap_page_observations.x
lx = u_summary_page.x
end subroutine

on n_page_class_list.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_page_class_list.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

