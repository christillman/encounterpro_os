$PBExportHeader$u_tab_hm_class_protocols.sru
forward
global type u_tab_hm_class_protocols from u_tab_hm_class
end type
end forward

global type u_tab_hm_class_protocols from u_tab_hm_class
boolean perpendiculartext = true
tabposition tabposition = tabsonleft!
end type
global u_tab_hm_class_protocols u_tab_hm_class_protocols

forward prototypes
public function integer initialize (str_hm_context pstr_hm_context)
public function integer open_protocol (long pl_protocol_index)
end prototypes

public function integer initialize (str_hm_context pstr_hm_context);long i
integer li_sts

last_hm_context = pstr_hm_context

if isnull(hm_class.maintenance_rule_id) or hm_class.maintenance_rule_id <= 0 then
	li_sts = f_get_hm_class_definition(pstr_hm_context.maintenance_rule_id, hm_class)
	if li_sts <= 0 then return -1
end if

if hm_class.protocol_count > 0 then
	for i = 1 to hm_class.protocol_count
		open_protocol(i)
	next
else
	return 0
end if


return 1

end function

public function integer open_protocol (long pl_protocol_index);u_tabpage_hm_class_base luo_tabpage

luo_tabpage = open_page("u_tabpage_hm_class_protocol", false)
if isnull(luo_tabpage) then
	openwithparm(w_pop_message, "Error initializing health maintenance protocol class")
	return -1
end if
luo_tabpage.text = hm_class.protocol[pl_protocol_index].title
luo_tabpage.parent_tab = this
luo_tabpage.hmclasstab = this
luo_tabpage.initialize(last_hm_context, pl_protocol_index)

return 1

end function

