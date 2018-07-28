HA$PBExportHeader$u_tab_hm_class_definition.sru
forward
global type u_tab_hm_class_definition from u_tab_hm_class
end type
end forward

global type u_tab_hm_class_definition from u_tab_hm_class
boolean perpendiculartext = true
tabposition tabposition = tabsonleft!
end type
global u_tab_hm_class_definition u_tab_hm_class_definition

forward prototypes
public function integer initialize (str_hm_context pstr_hm_context)
end prototypes

public function integer initialize (str_hm_context pstr_hm_context);long i
u_tabpage_hm_class_base luo_tabpage
integer li_sts
long ll_tabpage_count
string lsa_tabpage_classes[]
string lsa_tabpage_text[]

li_sts = f_get_hm_class_definition(pstr_hm_context.maintenance_rule_id, hm_class)
if li_sts <= 0 then return -1

ll_tabpage_count = 0
initial_tab = 1

ll_tabpage_count++
lsa_tabpage_classes[ll_tabpage_count] = "u_tabpage_hm_class_settings"
lsa_tabpage_text[ll_tabpage_count] = "Definition"

//ll_tabpage_count++
//lsa_tabpage_classes[ll_tabpage_count] = "u_tabpage_hm_class_criteria"
//lsa_tabpage_text[ll_tabpage_count] = "Criteria"

ll_tabpage_count++
lsa_tabpage_classes[ll_tabpage_count] = "u_tabpage_hm_class_assessments"
lsa_tabpage_text[ll_tabpage_count] = "Assessments"

ll_tabpage_count++
lsa_tabpage_classes[ll_tabpage_count] = "u_tabpage_hm_class_treatments"
lsa_tabpage_text[ll_tabpage_count] = "Treatments"

for i = 1 to ll_tabpage_count
	luo_tabpage = open_page(lsa_tabpage_classes[i], false)
	if isnull(luo_tabpage) then
		openwithparm(w_pop_message, "Error initializing health maintenance class (" + lsa_tabpage_classes[ll_tabpage_count] + ")")
		return -1
	end if
	luo_tabpage.text = lsa_tabpage_text[i]
	if lower(lsa_tabpage_text[i]) = lower(pstr_hm_context.tabpage) then initial_tab = i
	luo_tabpage.parent_tab = this
	luo_tabpage.hmclasstab = this
	luo_tabpage.initialize(pstr_hm_context, i)
next



return 1

end function

