HA$PBExportHeader$u_tab_component_manage.sru
forward
global type u_tab_component_manage from u_tab_manager
end type
end forward

global type u_tab_component_manage from u_tab_manager
integer width = 2414
integer height = 1480
long backcolor = 33538240
boolean boldselectedtext = true
boolean perpendiculartext = true
boolean createondemand = false
tabposition tabposition = tabsonleft!
end type
global u_tab_component_manage u_tab_component_manage

type variables
boolean allow_editing

end variables

forward prototypes
public function integer initialize ()
end prototypes

public function integer initialize ();integer i
u_tabpage_component_manage_base luo_tab

luo_tab = open_page("u_tabpage_component_manage_avail_upd")

return 1

end function

