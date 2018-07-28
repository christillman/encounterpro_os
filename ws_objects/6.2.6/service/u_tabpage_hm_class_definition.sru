HA$PBExportHeader$u_tabpage_hm_class_definition.sru
forward
global type u_tabpage_hm_class_definition from u_tabpage_hm_class_base
end type
type tab_definition from u_tab_hm_class_definition within u_tabpage_hm_class_definition
end type
type tab_definition from u_tab_hm_class_definition within u_tabpage_hm_class_definition
end type
end forward

global type u_tabpage_hm_class_definition from u_tabpage_hm_class_base
tab_definition tab_definition
end type
global u_tabpage_hm_class_definition u_tabpage_hm_class_definition

forward prototypes
public function integer initialize (str_hm_context pstr_hm_context, long pl_index)
end prototypes

public function integer initialize (str_hm_context pstr_hm_context, long pl_index);integer li_sts

tab_definition.width = width
tab_definition.height = height
li_sts = tab_definition.initialize(pstr_hm_context)

return li_sts

end function

on u_tabpage_hm_class_definition.create
int iCurrent
call super::create
this.tab_definition=create tab_definition
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_definition
end on

on u_tabpage_hm_class_definition.destroy
call super::destroy
destroy(this.tab_definition)
end on

type tab_definition from u_tab_hm_class_definition within u_tabpage_hm_class_definition
integer width = 2002
integer height = 1000
end type

