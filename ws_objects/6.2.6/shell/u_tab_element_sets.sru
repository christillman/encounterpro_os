HA$PBExportHeader$u_tab_element_sets.sru
forward
global type u_tab_element_sets from u_tab_manager
end type
end forward

global type u_tab_element_sets from u_tab_manager
boolean createondemand = false
end type
global u_tab_element_sets u_tab_element_sets

type variables
str_document_element_context document_element_context
str_document_elements document_elements
end variables

forward prototypes
public function integer initialize (str_document_element_context pstr_document_element_context)
end prototypes

public function integer initialize (str_document_element_context pstr_document_element_context);u_tabpage_element_set_mappings luo_tabpage
long i

document_element_context = pstr_document_element_context
document_elements = document_element_context.document_elements

for i = 1 to document_elements.element_set_count
	luo_tabpage = open_page("u_tabpage_element_set_mappings", false)
	luo_tabpage.element_set_tab = this
	luo_tabpage.text = document_elements.element_set[i].description
	luo_tabpage.context = document_element_context.context
	luo_tabpage.attributes = document_element_context.attributes
	luo_tabpage.element_set_index = i
	luo_tabpage.initialize()
next


return 1

end function

