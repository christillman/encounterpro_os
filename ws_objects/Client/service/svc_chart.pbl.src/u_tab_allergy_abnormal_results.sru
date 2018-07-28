$PBExportHeader$u_tab_allergy_abnormal_results.sru
forward
global type u_tab_allergy_abnormal_results from u_tab_manager
end type
type tabpage_tests from u_tabpage_allergy_abnormal_results within u_tab_allergy_abnormal_results
end type
type tabpage_tests from u_tabpage_allergy_abnormal_results within u_tab_allergy_abnormal_results
end type
type tabpage_history from u_tabpage_allergy_pph within u_tab_allergy_abnormal_results
end type
type tabpage_history from u_tabpage_allergy_pph within u_tab_allergy_abnormal_results
end type
end forward

global type u_tab_allergy_abnormal_results from u_tab_manager
integer width = 1728
integer height = 1352
long backcolor = 33538240
boolean raggedright = false
tabpage_tests tabpage_tests
tabpage_history tabpage_history
end type
global u_tab_allergy_abnormal_results u_tab_allergy_abnormal_results

type variables
u_component_service service

end variables

on u_tab_allergy_abnormal_results.create
this.tabpage_tests=create tabpage_tests
this.tabpage_history=create tabpage_history
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_tests
this.Control[iCurrent+2]=this.tabpage_history
end on

on u_tab_allergy_abnormal_results.destroy
call super::destroy
destroy(this.tabpage_tests)
destroy(this.tabpage_history)
end on

type tabpage_tests from u_tabpage_allergy_abnormal_results within u_tab_allergy_abnormal_results
integer x = 18
integer y = 112
integer width = 1691
integer height = 1224
string text = "Abnormal"
end type

type tabpage_history from u_tabpage_allergy_pph within u_tab_allergy_abnormal_results
integer x = 18
integer y = 112
integer width = 1691
integer height = 1224
string text = "Highlighted"
end type

