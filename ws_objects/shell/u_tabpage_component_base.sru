HA$PBExportHeader$u_tabpage_component_base.sru
forward
global type u_tabpage_component_base from u_tabpage
end type
end forward

global type u_tabpage_component_base from u_tabpage
end type
global u_tabpage_component_base u_tabpage_component_base

type variables
str_component_definition component
boolean allow_editing

end variables

on u_tabpage_component_base.create
call super::create
end on

on u_tabpage_component_base.destroy
call super::destroy
end on

