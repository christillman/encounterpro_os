$PBExportHeader$u_tab_vaccine_schedule_config.sru
forward
global type u_tab_vaccine_schedule_config from u_tab_manager
end type
type tabpage_disease_groups from u_tabpage_vaccine_schedule_disease_groups within u_tab_vaccine_schedule_config
end type
type tabpage_disease_groups from u_tabpage_vaccine_schedule_disease_groups within u_tab_vaccine_schedule_config
end type
type tabpage_schedule from u_tabpage_vaccine_schedule_schedule within u_tab_vaccine_schedule_config
end type
type tabpage_schedule from u_tabpage_vaccine_schedule_schedule within u_tab_vaccine_schedule_config
end type
end forward

global type u_tab_vaccine_schedule_config from u_tab_manager
integer width = 2702
integer height = 1364
boolean raggedright = false
boolean boldselectedtext = true
tabpage_disease_groups tabpage_disease_groups
tabpage_schedule tabpage_schedule
end type
global u_tab_vaccine_schedule_config u_tab_vaccine_schedule_config

type variables
str_config_object_info config_object_info

boolean rule_changes

end variables

forward prototypes
public function integer initialize ()
public function integer save_changes ()
end prototypes

public function integer initialize ();integer i
u_tabpage_vaccine_schedule_base luo_tab

page_count = upperbound(control)

for i = 1 to page_count
	pages[i] = control[i]
	luo_tab = pages[i]
	luo_tab.parent_tab = this
	luo_tab.config_object_info = config_object_info
	luo_tab.my_parent_tab = this
	luo_tab.initialize()
next

rule_changes = false

return 1

end function

public function integer save_changes ();integer i
integer li_sts
u_tabpage_vaccine_schedule_base luo_tab

for i = 1 to page_count
	luo_tab = pages[i]
	li_sts = luo_tab.save_changes()
	if li_sts < 0 then return -1
next

rule_changes = false

return 1

end function

on u_tab_vaccine_schedule_config.create
this.tabpage_disease_groups=create tabpage_disease_groups
this.tabpage_schedule=create tabpage_schedule
call super::create
this.Control[]={this.tabpage_disease_groups,&
this.tabpage_schedule}
end on

on u_tab_vaccine_schedule_config.destroy
call super::destroy
destroy(this.tabpage_disease_groups)
destroy(this.tabpage_schedule)
end on

type tabpage_disease_groups from u_tabpage_vaccine_schedule_disease_groups within u_tab_vaccine_schedule_config
integer x = 18
integer y = 116
integer width = 2665
integer height = 1232
string text = "Disease Groups"
end type

type tabpage_schedule from u_tabpage_vaccine_schedule_schedule within u_tab_vaccine_schedule_config
integer x = 18
integer y = 116
integer width = 2665
integer height = 1232
string text = "Schedule"
end type

