HA$PBExportHeader$u_tabpage_em_type_rules.sru
forward
global type u_tabpage_em_type_rules from u_tabpage
end type
type dw_rules from u_dw_pick_list within u_tabpage_em_type_rules
end type
type st_type_level_title from statictext within u_tabpage_em_type_rules
end type
type st_type_title from statictext within u_tabpage_em_type_rules
end type
type st_info from statictext within u_tabpage_em_type_rules
end type
end forward

global type u_tabpage_em_type_rules from u_tabpage
integer width = 2821
integer height = 1276
dw_rules dw_rules
st_type_level_title st_type_level_title
st_type_title st_type_title
st_info st_info
end type
global u_tabpage_em_type_rules u_tabpage_em_type_rules

type variables
u_tab_em_type_rules my_parent_tab

end variables

forward prototypes
public subroutine refresh ()
public function integer initialize ()
end prototypes

public subroutine refresh ();long ll_rule_rows
long ll_passed_rows
long i
string ls_em_type
long ll_em_type_level
long ll_rule_id
string ls_find
long ll_row
string ls_description
string ls_filter
long ll_highest_level
u_ds_data luo_rules_passed

ll_highest_level = 0

luo_rules_passed = CREATE u_ds_data
luo_rules_passed.set_dataobject("dw_fn_em_type_rules_passed")

luo_rules_passed.retrieve(my_parent_tab.cpr_id, my_parent_tab.encounter_id, my_parent_tab.em_documentation_guide)
ls_filter = "em_component='" + my_parent_tab.em_component + "'"
ls_filter += " and em_type='" + my_parent_tab.em_type + "'"
ls_filter += " and passed_flag='Y'"
luo_rules_passed.setfilter(ls_filter)
luo_rules_passed.filter()

ll_rule_rows = dw_rules.rowcount()
ll_passed_rows = luo_rules_passed.rowcount()

for i = 1 to ll_passed_rows
	ll_em_type_level = luo_rules_passed.object.em_type_level[i]
	ll_rule_id = luo_rules_passed.object.rule_id[i]
	
	ls_find = "em_type_level=" + string(ll_em_type_level)
	ls_find += " and rule_id=" + string(ll_rule_id)
	ll_row = dw_rules.find(ls_find, 1, ll_rule_rows)
	if ll_row > 0 then
		if ll_em_type_level > ll_highest_level then ll_highest_level = ll_em_type_level
		dw_rules.object.passed_flag[ll_row] = 1
	end if
next

my_parent_tab.event trigger highest_rule_passed(ll_highest_level)

DESTROY luo_rules_passed


end subroutine

public function integer initialize ();
my_parent_tab = parent_tab

dw_rules.settransobject(sqlca)
dw_rules.retrieve(my_parent_tab.em_documentation_guide, my_parent_tab.em_component, my_parent_tab.em_type)

return 1

end function

on u_tabpage_em_type_rules.create
int iCurrent
call super::create
this.dw_rules=create dw_rules
this.st_type_level_title=create st_type_level_title
this.st_type_title=create st_type_title
this.st_info=create st_info
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_rules
this.Control[iCurrent+2]=this.st_type_level_title
this.Control[iCurrent+3]=this.st_type_title
this.Control[iCurrent+4]=this.st_info
end on

on u_tabpage_em_type_rules.destroy
call super::destroy
destroy(this.dw_rules)
destroy(this.st_type_level_title)
destroy(this.st_type_title)
destroy(this.st_info)
end on

event resize_tabpage;call super::resize_tabpage;st_info.width = width
dw_rules.width = width
dw_rules.object.description.width = width - 795

end event

type dw_rules from u_dw_pick_list within u_tabpage_em_type_rules
integer y = 156
integer width = 2784
integer height = 1064
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_em_type_rule"
boolean vscrollbar = true
boolean border = false
end type

type st_type_level_title from statictext within u_tabpage_em_type_rules
integer x = 1006
integer y = 84
integer width = 617
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Rule Description"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_type_title from statictext within u_tabpage_em_type_rules
integer x = 37
integer y = 84
integer width = 631
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "EM Component Level"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_info from statictext within u_tabpage_em_type_rules
integer width = 2816
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "The highlighted records indicated which rules which have passed for this encounter."
alignment alignment = center!
boolean focusrectangle = false
end type

