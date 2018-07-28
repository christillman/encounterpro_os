$PBExportHeader$u_tab_new_treatment.sru
forward
global type u_tab_new_treatment from u_tab_manager
end type
type tabpage_personal from u_tabpage_new_treatment_picklist within u_tab_new_treatment
end type
type tabpage_personal from u_tabpage_new_treatment_picklist within u_tab_new_treatment
end type
type tabpage_common from u_tabpage_new_treatment_picklist within u_tab_new_treatment
end type
type tabpage_common from u_tabpage_new_treatment_picklist within u_tab_new_treatment
end type
type tabpage_default from u_tabpage_new_treatment_picklist within u_tab_new_treatment
end type
type tabpage_default from u_tabpage_new_treatment_picklist within u_tab_new_treatment
end type
type tabpage_references from u_tabpage_new_treatment_references within u_tab_new_treatment
end type
type tabpage_references from u_tabpage_new_treatment_references within u_tab_new_treatment
end type
end forward

global type u_tab_new_treatment from u_tab_manager
integer width = 2862
integer height = 1608
boolean raggedright = false
boolean boldselectedtext = true
boolean createondemand = false
tabpage_personal tabpage_personal
tabpage_common tabpage_common
tabpage_default tabpage_default
tabpage_references tabpage_references
end type
global u_tab_new_treatment u_tab_new_treatment

forward prototypes
public function integer order_selected_treatments ()
public function integer initialize ()
public function str_treatment_lists get_treatment_lists ()
end prototypes

public function integer order_selected_treatments ();u_tabpage_new_treatment_picklist luo_treatments
long i
integer li_sts

for i = 1 to page_count
	CHOOSE CASE lower(pages[i].tag)
		CASE "personal", "common", "default"
			luo_treatments = pages[i]
			li_sts = luo_treatments.order_selected_treatments()
			if li_sts < 0 then return -1
	END CHOOSE
next

return 1


end function

public function integer initialize ();integer i
u_tabpage luo_tab
integer li_sts
integer li_found_tab

page_count = upperbound(control)

li_found_tab = 0
for i = 1 to page_count
	pages[i] = control[i]
	luo_tab = pages[i]
	luo_tab.parent_tab = this
	li_sts = luo_tab.initialize()
	if li_sts > 0 and li_found_tab = 0 and pages[i].visible then li_found_tab = i
next

if li_found_tab > 0 then
	this.function POST selecttab(li_found_tab)
else
	// default to the common list
	this.function POST selecttab(2)
end if

return 1

end function

public function str_treatment_lists get_treatment_lists ();str_treatment_lists lstr_treatment_lists
str_treatment_list lstr_treatment_list
u_tabpage_new_treatment_picklist luo_tabpage
long i
string ls_classname

lstr_treatment_lists.treatment_list_count = 0

for i = 1 to page_count
	if lower(pages[i].text) <> "references" then
		luo_tabpage = pages[i]
		lstr_treatment_list.list_assessment_id = luo_tabpage.list_assessment_id
		lstr_treatment_list.list_user_id = luo_tabpage.list_user_id
		lstr_treatment_list.description = luo_tabpage.text
		
		// Add the treatment list to the list
		lstr_treatment_lists.treatment_list_count++
		lstr_treatment_lists.treatment_list[lstr_treatment_lists.treatment_list_count] = lstr_treatment_list
	end if
next

return lstr_treatment_lists

end function

on u_tab_new_treatment.create
this.tabpage_personal=create tabpage_personal
this.tabpage_common=create tabpage_common
this.tabpage_default=create tabpage_default
this.tabpage_references=create tabpage_references
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_personal
this.Control[iCurrent+2]=this.tabpage_common
this.Control[iCurrent+3]=this.tabpage_default
this.Control[iCurrent+4]=this.tabpage_references
end on

on u_tab_new_treatment.destroy
call super::destroy
destroy(this.tabpage_personal)
destroy(this.tabpage_common)
destroy(this.tabpage_default)
destroy(this.tabpage_references)
end on

type tabpage_personal from u_tabpage_new_treatment_picklist within u_tab_new_treatment
string tag = "Personal"
integer x = 18
integer y = 112
integer width = 2825
integer height = 1480
string text = "Personal List"
end type

type tabpage_common from u_tabpage_new_treatment_picklist within u_tab_new_treatment
string tag = "Common"
integer x = 18
integer y = 112
integer width = 2825
integer height = 1480
string text = "Common List"
end type

type tabpage_default from u_tabpage_new_treatment_picklist within u_tab_new_treatment
string tag = "Default"
integer x = 18
integer y = 112
integer width = 2825
integer height = 1480
string text = "Default List"
end type

type tabpage_references from u_tabpage_new_treatment_references within u_tab_new_treatment
string tag = "References"
boolean visible = false
integer x = 18
integer y = 112
integer width = 2825
integer height = 1480
string text = "References"
end type

