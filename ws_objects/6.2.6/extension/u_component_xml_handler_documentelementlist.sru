HA$PBExportHeader$u_component_xml_handler_documentelementlist.sru
forward
global type u_component_xml_handler_documentelementlist from u_component_xml_handler_base
end type
end forward

global type u_component_xml_handler_documentelementlist from u_component_xml_handler_base
end type
global u_component_xml_handler_documentelementlist u_component_xml_handler_documentelementlist

type variables

end variables

forward prototypes
protected function integer xx_interpret_xml ()
protected function integer xx_initialize ()
public function str_document_element get_element_type (str_element pstr_element)
public function str_document_table get_table_type (str_element pstr_element)
public function str_document_element_mapping_rule get_mapping_rule_type (str_element pstr_element)
public function str_document_element_mapping get_element_mapping_type (str_element pstr_element)
public function str_document_element_set get_element_set_type (str_element pstr_element)
public function str_property_suffix get_property_suffix_type (str_element pstr_element)
end prototypes

protected function integer xx_interpret_xml ();PBDOM_ELEMENT lo_root
PBDOM_ELEMENT lo_from_block
PBDOM_ELEMENT lo_to_block
PBDOM_ELEMENT lo_elem[]
str_element lstr_element
integer li_sts
int i
string ls_root
string ls_tag
string ls_value
long ll_count
str_document_elements lstr_document_elements

lstr_document_elements.element_set_count = 0

TRY
	lo_root = xml.XML_Document.GetRootElement()
	ls_root = lo_root.getname()
	
	lo_root.GetChildElements(ref lo_elem)
	ll_count = UpperBound(lo_elem)
	
CATCH (pbdom_exception lo_error)
	log.log(this, "process_xml", "Error - " + lo_error.text, 4)
	return -1
END TRY


for i = 1 to ll_count
	ls_tag = lo_elem[i].getname()
	ls_value = lo_elem[i].gettexttrim( )
	
	CHOOSE CASE lower(ls_tag)
		CASE "element"
			// Create a default element set for backward compatibility
			if lstr_document_elements.element_set_count = 0 then
				lstr_document_elements.element_set_count = 1
				lstr_document_elements.element_set[1].description = "Document Elements"
			end if
			lstr_document_elements.element_set[1].element_count += 1
			lstr_element = get_element(lo_elem[i])
			lstr_document_elements.element_set[1].element[lstr_document_elements.element_set[1].element_count] = get_element_type(lstr_element)
		CASE "table"
			// Create a default element set for backward compatibility
			if lstr_document_elements.element_set_count = 0 then
				lstr_document_elements.element_set_count = 1
				lstr_document_elements.element_set[1].description = "Document Elements"
			end if
			lstr_document_elements.element_set[1].table_count += 1
			lstr_element = get_element(lo_elem[i])
			lstr_document_elements.element_set[1].table[lstr_document_elements.element_set[1].table_count] = get_table_type(lstr_element)
		CASE "elementset"
			lstr_document_elements.element_set_count += 1
			lstr_element = get_element(lo_elem[i])
			lstr_document_elements.element_set[lstr_document_elements.element_set_count] = get_element_set_type(lstr_element)
	END CHOOSE
next

document_payload = lstr_document_elements

return 1


end function

protected function integer xx_initialize ();

return 1

end function

public function str_document_element get_element_type (str_element pstr_element);string ls_description
str_document_element lstr_document_element
long i
string ls_date_and_time
string ls_amount
string ls_unit
long ll_amount
date ld_date
string ls_id
integer li_sts
string ls_temp
str_element lstr_element

setnull(lstr_document_element.element)
setnull(lstr_document_element.description)
setnull(lstr_document_element.datatype)
setnull(lstr_document_element.maxlength)
lstr_document_element.enumerated_count = 0
lstr_document_element.mapped_property_count = 0

if not pstr_element.valid then return lstr_document_element

// Assume that this is a "Name" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "name"
			lstr_document_element.element = pstr_element.child[i].gettexttrim()
		CASE "description"
			lstr_document_element.description = pstr_element.child[i].gettexttrim()
		CASE "datatype"
			lstr_document_element.datatype = pstr_element.child[i].gettexttrim()
		CASE "maxlength"
			ls_temp = pstr_element.child[i].gettexttrim()
			if isnumber(ls_temp) then
				lstr_document_element.maxlength = long(ls_temp)
			end if
		CASE "domainitem"
			ls_temp = pstr_element.child[i].gettexttrim()
			lstr_document_element.enumerated_count += 1
			lstr_document_element.enumerated_value[lstr_document_element.enumerated_count] = ls_temp
		CASE "mappedproperty"
			lstr_document_element.mapped_property_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_document_element.mapped_property[lstr_document_element.mapped_property_count] = get_element_mapping_type(lstr_element)
	END CHOOSE
next


return lstr_document_element


end function

public function str_document_table get_table_type (str_element pstr_element);str_document_table lstr_document_table
str_element lstr_element
long i

setnull(lstr_document_table.description)
lstr_document_table.element_count = 0

if not pstr_element.valid then return lstr_document_table

// Assume that this is a "Name" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "description"
			lstr_document_table.description = pstr_element.child[i].gettexttrim()
		CASE "element"
			lstr_document_table.element_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_document_table.element[lstr_document_table.element_count] = get_element_type(lstr_element)
	END CHOOSE
next


return lstr_document_table


end function

public function str_document_element_mapping_rule get_mapping_rule_type (str_element pstr_element);string ls_description
str_document_element_mapping_rule lstr_document_element_mapping_rule
long i
string ls_date_and_time
string ls_amount
string ls_unit
long ll_amount
date ld_date
string ls_id
integer li_sts
string ls_temp
str_element lstr_element

setnull(lstr_document_element_mapping_rule.operator)
setnull(lstr_document_element_mapping_rule.right_side)
setnull(lstr_document_element_mapping_rule.true_value)
setnull(lstr_document_element_mapping_rule.false_value)

if not pstr_element.valid then return lstr_document_element_mapping_rule

// Assume that this is a "Name" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "operator"
			lstr_document_element_mapping_rule.operator = pstr_element.child[i].gettexttrim()
		CASE "rightside"
			lstr_document_element_mapping_rule.right_side = pstr_element.child[i].gettexttrim()
		CASE "truevalue"
			lstr_document_element_mapping_rule.true_value = pstr_element.child[i].gettexttrim()
		CASE "falsevalue"
			lstr_document_element_mapping_rule.false_value = pstr_element.child[i].gettexttrim()
	END CHOOSE
next


return lstr_document_element_mapping_rule


end function

public function str_document_element_mapping get_element_mapping_type (str_element pstr_element);string ls_description
str_document_element_mapping lstr_document_element_mapping
long i
string ls_date_and_time
string ls_amount
string ls_unit
long ll_amount
date ld_date
string ls_id
integer li_sts
string ls_temp
str_element lstr_element

setnull(lstr_document_element_mapping.mapped_property)
lstr_document_element_mapping.mapping_rule_count = 0

if not pstr_element.valid then return lstr_document_element_mapping

// Assume that this is a "Name" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "mappedproperty"
			lstr_document_element_mapping.mapped_property = pstr_element.child[i].gettexttrim()
		CASE "propertysuffix"
			lstr_element = get_element(pstr_element.child[i])
			lstr_document_element_mapping.suffix = get_property_suffix_type(lstr_element)
		CASE "mappingrule"
			lstr_document_element_mapping.mapping_rule_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_document_element_mapping.mapping_rule[lstr_document_element_mapping.mapping_rule_count] = get_mapping_rule_type(lstr_element)
	END CHOOSE
next


return lstr_document_element_mapping


end function

public function str_document_element_set get_element_set_type (str_element pstr_element);string ls_description
str_document_element_set lstr_document_element_set
long i
string ls_date_and_time
string ls_amount
string ls_unit
long ll_amount
date ld_date
string ls_id
integer li_sts
string ls_temp
str_element lstr_element

setnull(lstr_document_element_set.description)
lstr_document_element_set.maptocollection = false
setnull(lstr_document_element_set.maptocollectiontype)
setnull(lstr_document_element_set.collectiondefinition)
lstr_document_element_set.element_count = 0
lstr_document_element_set.table_count = 0

if not pstr_element.valid then return lstr_document_element_set

// Assume that this is a "Name" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "description"
			lstr_document_element_set.description = pstr_element.child[i].gettexttrim()
		CASE "maptocollection"
			lstr_document_element_set.maptocollection = f_string_to_boolean(pstr_element.child[i].gettexttrim())
		CASE "maptocollectiontype"
			lstr_document_element_set.maptocollectiontype = pstr_element.child[i].gettexttrim()
		CASE "collectiondefinition"
			// replace CR with CRLF
			lstr_document_element_set.collectiondefinition = f_string_substitute(pstr_element.child[i].gettexttrim(), "~n", "~r~n")
		CASE "collectionrule"
			lstr_document_element_set.collection_rule_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_document_element_set.collection_rule[lstr_document_element_set.collection_rule_count] = get_mapping_rule_type(lstr_element)
		CASE "element"
			lstr_document_element_set.element_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_document_element_set.element[lstr_document_element_set.element_count] = get_element_type(lstr_element)
		CASE "table"
			lstr_document_element_set.table_count += 1
			lstr_element = get_element(pstr_element.child[i])
			lstr_document_element_set.table[lstr_document_element_set.table_count] = get_table_type(lstr_element)
	END CHOOSE
next


return lstr_document_element_set


end function

public function str_property_suffix get_property_suffix_type (str_element pstr_element);string ls_description
str_property_suffix lstr_suffix
long i
string ls_date_and_time
string ls_amount
string ls_unit
long ll_amount
date ld_date
string ls_id
integer li_sts
string ls_temp
str_element lstr_element

setnull(lstr_suffix.datatype)
setnull(lstr_suffix.display_code)
setnull(lstr_suffix.format_string)
setnull(lstr_suffix.lookup_owner_id)
setnull(lstr_suffix.lookup_code_domain)

if not pstr_element.valid then return lstr_suffix

// Assume that this is a "Name" element
for i = 1 to pstr_element.child_count
	CHOOSE CASE lower(pstr_element.child[i].getname())
		CASE "datatype"
			lstr_suffix.datatype = pstr_element.child[i].gettexttrim()
		CASE "displaycode"
			lstr_suffix.display_code = f_string_to_boolean(pstr_element.child[i].gettexttrim())
		CASE "formatstring"
			lstr_suffix.format_string = pstr_element.child[i].gettexttrim()
		CASE "lookupownerid"
			lstr_suffix.lookup_owner_id = long(pstr_element.child[i].gettexttrim())
		CASE "lookupcodedomain"
			lstr_suffix.lookup_code_domain = pstr_element.child[i].gettexttrim()
	END CHOOSE
next


return lstr_suffix


end function

on u_component_xml_handler_documentelementlist.create
call super::create
end on

on u_component_xml_handler_documentelementlist.destroy
call super::destroy
end on

