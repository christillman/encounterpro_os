$PBExportHeader$u_tabpage_hm_class_base.sru
forward
global type u_tabpage_hm_class_base from u_tabpage
end type
end forward

global type u_tabpage_hm_class_base from u_tabpage
end type
global u_tabpage_hm_class_base u_tabpage_hm_class_base

type variables
u_tab_hm_class HMClassTab
end variables

forward prototypes
public function integer initialize (str_hm_context pstr_hm_context, long pl_index)
end prototypes

public function integer initialize (str_hm_context pstr_hm_context, long pl_index);

return 1

end function

on u_tabpage_hm_class_base.create
call super::create
end on

on u_tabpage_hm_class_base.destroy
call super::destroy
end on

