HA$PBExportHeader$u_tab_hm_class_metrics.sru
forward
global type u_tab_hm_class_metrics from u_tab_hm_class
end type
end forward

global type u_tab_hm_class_metrics from u_tab_hm_class
boolean perpendiculartext = true
tabposition tabposition = tabsonleft!
end type
global u_tab_hm_class_metrics u_tab_hm_class_metrics

forward prototypes
public function integer initialize (str_hm_context pstr_hm_context)
public function integer remove_metric (long pl_index)
end prototypes

public function integer initialize (str_hm_context pstr_hm_context);long i
u_tabpage_hm_class_base luo_tabpage
integer li_sts

for i = page_count to 1 step -1
	closetab(pages[i])
next
page_count = 0

if isnull(hm_class.maintenance_rule_id) or hm_class.maintenance_rule_id <= 0 then
	li_sts = f_get_hm_class_definition(pstr_hm_context.maintenance_rule_id, hm_class)
	if li_sts <= 0 then return -1
end if

if hm_class.metric_count > 0 then
	for i = 1 to hm_class.metric_count
		luo_tabpage = open_page("u_tabpage_hm_class_metric", false)
		if isnull(luo_tabpage) then
			openwithparm(w_pop_message, "Error initializing health maintenance metric class")
			return -1
		end if
		luo_tabpage.text = hm_class.metric[i].title
		luo_tabpage.parent_tab = this
		luo_tabpage.hmclasstab = this
		luo_tabpage.initialize(pstr_hm_context, i)
	next
else
	return 0
end if


return 1

end function

public function integer remove_metric (long pl_index);long i
str_hm_context lstr_hm_context

DELETE c_Maintenance_metric
WHERE maintenance_rule_id = :hm_class.maintenance_rule_id
AND metric_sequence = :hm_class.metric[pl_index].metric_sequence;
if not tf_check() then return -1

for i = pl_index to hm_class.metric_count - 1
	hm_class.metric[i] = hm_class.metric[i + 1]
next
hm_class.metric_count -= 1

lstr_hm_context.maintenance_rule_id = hm_class.maintenance_rule_id
initialize(lstr_hm_context)

return 1


end function

