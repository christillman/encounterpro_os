HA$PBExportHeader$u_tab_component.sru
forward
global type u_tab_component from u_tab_manager
end type
end forward

global type u_tab_component from u_tab_manager
integer width = 2926
integer height = 1416
long backcolor = 33538240
boolean boldselectedtext = true
boolean perpendiculartext = true
boolean createondemand = false
tabposition tabposition = tabsonleft!
end type
global u_tab_component u_tab_component

type variables
str_component_definition component
boolean allow_editing

end variables

forward prototypes
public function integer initialize (string ps_key)
public function integer initialize (string ps_component, string ps_version_name)
end prototypes

public function integer initialize (string ps_key);return initialize(ps_key, "")

end function

public function integer initialize (string ps_component, string ps_version_name);u_tabpage_component_base luo_tab
u_tabpage_component_version_properties luo_version_tab
long i
string ls_version_name
str_component_versions lstr_versions
long ll_start_tab = 1

component = f_get_component_definition(ps_component)
if isnull(component.component_id) then return -1

close_pages()

luo_tab = open_page("u_tabpage_component_properties", false)
luo_tab.allow_editing = allow_editing
luo_tab.component = component
luo_tab.initialize()

lstr_versions = f_get_component_versions(component.component_id)

for i = 1 to lstr_versions.version_count
	luo_version_tab = open_page("u_tabpage_component_version_properties", false)
	luo_version_tab.allow_editing = allow_editing
	luo_version_tab.component = component
	luo_version_tab.component_version = lstr_versions.version[i]
	luo_version_tab.initialize()
	if lower(ps_version_name) = lower(lstr_versions.version[i].version_name) then
		ll_start_tab = i + 1
	end if
next

if ll_start_tab > 1 then
	this.function POST selecttab(ll_start_tab)
end if

return 1

end function

