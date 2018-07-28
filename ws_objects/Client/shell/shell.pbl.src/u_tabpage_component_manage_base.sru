$PBExportHeader$u_tabpage_component_manage_base.sru
forward
global type u_tabpage_component_manage_base from u_tabpage
end type
end forward

global type u_tabpage_component_manage_base from u_tabpage
end type
global u_tabpage_component_manage_base u_tabpage_component_manage_base

forward prototypes
public function integer initialize ()
end prototypes

public function integer initialize ();
this.event trigger resize_tabpage()

return 1

end function

on u_tabpage_component_manage_base.create
call super::create
end on

on u_tabpage_component_manage_base.destroy
call super::destroy
end on

