HA$PBExportHeader$u_component_config_object_menu.sru
forward
global type u_component_config_object_menu from u_component_config_object
end type
end forward

global type u_component_config_object_menu from u_component_config_object
end type
global u_component_config_object_menu u_component_config_object_menu

forward prototypes
protected function integer xx_install_config_object (ref str_config_object_info pstr_config_object, ref str_config_object_version pstr_version, ref u_xml_document pbdom_config_object, ref pbdom_element po_version_root_element)
public function integer save_menu (ref str_menu pstr_menu)
protected function integer xx_delete_existing_config_object (ref str_config_object_info pstr_config_object)
protected function integer xx_add_config_object_body (str_config_object_info pstr_config_object, ref pbdom_document pbdom_config_object, ref pbdom_element po_version_element, ref pbdom_element po_nested_parent)
end prototypes

protected function integer xx_install_config_object (ref str_config_object_info pstr_config_object, ref str_config_object_version pstr_version, ref u_xml_document pbdom_config_object, ref pbdom_element po_version_root_element);integer li_sts
PBDOM_ELEMENT pbdom_element_array[]
PBDOM_ELEMENT pbdom_element_array2[]
PBDOM_ATTRIBUTE pbdom_attribute_array[]
long i
long j
long k
str_config_object_version lstr_version
blob lbl_objectdata
long ll_sts
string ls_null
str_menu lstr_menu
str_menu_item lstr_menu_item
string ls_attribute
string ls_value

setnull(ls_null)

lstr_menu = f_empty_menu()

po_version_root_element.GetAttributes(ref pbdom_attribute_array[])
for i = 1 to UpperBound(pbdom_attribute_array)
	CHOOSE CASE lower(pbdom_attribute_array[i].GetName())
		CASE "menu_id"
//			lstr_menu.menu_id = long(pbdom_attribute_array[i].GetText())
		CASE "description"
			lstr_menu.description = pbdom_attribute_array[i].GetText()
		CASE "context_object"
			lstr_menu.context_object = pbdom_attribute_array[i].GetText()
	END CHOOSE
next

// Get the child elements of the <ConfigObjectVersion> element.  There should only be one, but just call the descendent class
// handler for every element found
po_version_root_element.GetChildElements(ref pbdom_element_array)
for i = 1 to UpperBound(pbdom_element_array)
	lstr_menu_item = f_empty_menu_item()

	pbdom_element_array[i].GetAttributes(ref pbdom_attribute_array[])
	for j = 1 to UpperBound(pbdom_attribute_array)
		CHOOSE CASE lower(pbdom_attribute_array[j].GetName())
			CASE "menu_item_id"
//				lstr_menu_item.menu_item_id = long(pbdom_attribute_array[j].GetText())
			CASE "menu_item_type"
				lstr_menu_item.menu_item_type = pbdom_attribute_array[j].GetText()
			CASE "menu_item"
				lstr_menu_item.menu_item = pbdom_attribute_array[j].GetText()
			CASE "context_object"
				lstr_menu_item.context_object = pbdom_attribute_array[j].GetText()
			CASE "button_title"
				lstr_menu_item.button_title = pbdom_attribute_array[j].GetText()
			CASE "button_help"
				lstr_menu_item.button_help = pbdom_attribute_array[j].GetText()
			CASE "button"
				lstr_menu_item.button = pbdom_attribute_array[j].GetText()
			CASE "sort_sequence"
				lstr_menu_item.sort_sequence = integer(pbdom_attribute_array[j].GetText())
			CASE "auto_close_flag"
				lstr_menu_item.auto_close_flag = pbdom_attribute_array[j].GetText()
			CASE "authorized_user_id"
				lstr_menu_item.authorized_user_id = pbdom_attribute_array[j].GetText()
		END CHOOSE
	next
	

	pbdom_element_array[i].GetChildElements(ref pbdom_element_array2)
	for j = 1 to UpperBound(pbdom_element_array2)
		if lower(pbdom_element_array2[j].GetName()) = "attribute" then
			setnull(ls_attribute)
			setnull(ls_value)
			
			pbdom_element_array2[j].GetAttributes(ref pbdom_attribute_array)
			for k = 1 to UpperBound(pbdom_attribute_array)
				CHOOSE CASE lower(pbdom_attribute_array[k].GetName())
					CASE "attribute"
						ls_attribute = pbdom_attribute_array[k].GetText()
					CASE "value"
						ls_value = pbdom_attribute_array[k].GetText()
				END CHOOSE
			next
			
			if len(ls_attribute) > 0 AND len(ls_value) > 0 then
				f_attribute_add_attribute(lstr_menu_item.attributes, ls_attribute, ls_value)
			end if
		end if
	next
	
	
	lstr_menu.menu_item_count += 1
	lstr_menu.menu_item[lstr_menu.menu_item_count] = lstr_menu_item
next

li_sts = save_menu(lstr_menu)
if li_sts < 0 then return -1

pstr_config_object.installed_local_key = lstr_menu.menu_id

return 1


end function

public function integer save_menu (ref str_menu pstr_menu);integer li_sts
string ls_service_id
u_ds_data luo_menu
u_ds_data luo_menu_items
u_ds_data luo_menu_item_attributes
long i
long j
long ll_row

luo_menu = CREATE u_ds_data
luo_menu.set_dataobject("dw_c_menu")

luo_menu_items = CREATE u_ds_data
luo_menu_items.set_dataobject("dw_c_menu_item")

luo_menu_item_attributes = CREATE u_ds_data
luo_menu_item_attributes.set_dataobject("dw_menu_item_attribute")


ll_row = luo_menu.insertrow(0)
luo_menu.object.context_object[ll_row] = pstr_menu.context_object
luo_menu.object.description[ll_row] = pstr_menu.description

li_sts = luo_menu.update()
if li_sts <= 0 then return -1

pstr_menu.menu_id = luo_menu.object.menu_id[ll_row]

for i = 1 to pstr_menu.menu_item_count
	pstr_menu.menu_item[i].menu_id = pstr_menu.menu_id
	
	ll_row = luo_menu_items.insertrow(0)
	luo_menu_items.object.menu_id[ll_row] = pstr_menu.menu_item[i].menu_id
	luo_menu_items.object.menu_item_type[ll_row] = pstr_menu.menu_item[i].menu_item_type
	luo_menu_items.object.menu_item[ll_row] = pstr_menu.menu_item[i].menu_item
	luo_menu_items.object.context_object[ll_row] = pstr_menu.menu_item[i].context_object
	luo_menu_items.object.button_title[ll_row] = pstr_menu.menu_item[i].button_title
	luo_menu_items.object.button_help[ll_row] = pstr_menu.menu_item[i].button_help
	luo_menu_items.object.button[ll_row] = pstr_menu.menu_item[i].button
	luo_menu_items.object.sort_sequence[ll_row] = pstr_menu.menu_item[i].sort_sequence
	luo_menu_items.object.auto_close_flag[ll_row] = pstr_menu.menu_item[i].auto_close_flag
	luo_menu_items.object.authorized_user_id[ll_row] = pstr_menu.menu_item[i].authorized_user_id
	
	li_sts = luo_menu_items.update()
	if li_sts <= 0 then return -1
	pstr_menu.menu_item[i].menu_item_id = luo_menu_items.object.menu_item_id[ll_row]
	
	f_attribute_str_to_ds_with_removal(pstr_menu.menu_item[i].attributes, luo_menu_item_attributes)
	
	// For any new records, add the key values
	for j = 1 to luo_menu_item_attributes.rowcount()
		if isnull(long(luo_menu_item_attributes.object.menu_id[j])) then
			luo_menu_item_attributes.object.menu_id[j] = pstr_menu.menu_id
			luo_menu_item_attributes.object.menu_item_id[j] = pstr_menu.menu_item[i].menu_item_id
		end if
	next
	
	// Update the attributes
	li_sts = luo_menu_item_attributes.update()
	if li_sts <= 0 then return -1
next

DESTROY luo_menu_item_attributes

return 1

end function

protected function integer xx_delete_existing_config_object (ref str_config_object_info pstr_config_object);long ll_menu_id

ll_menu_id = pstr_config_object.installed_local_key

if isnull(ll_menu_id) or ll_menu_id <= 0 then return 0

DELETE
FROM dbo.c_menu_item_attribute
WHERE menu_id = :ll_menu_id;
if not tf_check() then return -1

DELETE
FROM dbo.c_menu_item
WHERE menu_id = :ll_menu_id;
if not tf_check() then return -1

DELETE
FROM dbo.c_menu
WHERE menu_id = :ll_menu_id;
if not tf_check() then return -1


return 1

end function

protected function integer xx_add_config_object_body (str_config_object_info pstr_config_object, ref pbdom_document pbdom_config_object, ref pbdom_element po_version_element, ref pbdom_element po_nested_parent);pbdom_element lo_menu
pbdom_element lo_menu_item
string ls_null
string ls_xml
integer li_sts
u_ds_data luo_menu_items
u_ds_data luo_menu_item_attributes
u_xml_document lo_menudoc
str_menu lstr_menu
long i
string ls_filter
long ll_attribute_count

Setnull(ls_null)

lstr_menu.menu_id = pstr_config_object.installed_local_key

SELECT description,
		specialty_id,
		context_object
INTO :lstr_menu.description,
		:lstr_menu.specialty_id,
		:lstr_menu.context_object
FROM c_Menu
WHERE menu_id = :lstr_menu.menu_id;
if not tf_check() then return -1

luo_menu_items = CREATE u_ds_data
luo_menu_items.set_dataobject("dw_c_menu_item")
lstr_menu.menu_item_count = luo_menu_items.retrieve(pstr_config_object.installed_local_key)

for i = 1 to lstr_menu.menu_item_count
	lstr_menu.menu_item[i].menu_item_id = luo_menu_items.object.menu_item_id[i]
	lstr_menu.menu_item[i].menu_item_type = luo_menu_items.object.menu_item_type[i]
	lstr_menu.menu_item[i].menu_item = luo_menu_items.object.menu_item[i]
	lstr_menu.menu_item[i].context_object = luo_menu_items.object.context_object[i]
	lstr_menu.menu_item[i].button_title = luo_menu_items.object.button_title[i]
	lstr_menu.menu_item[i].button_help = luo_menu_items.object.button_help[i]
	lstr_menu.menu_item[i].button = luo_menu_items.object.button[i]
	lstr_menu.menu_item[i].sort_sequence = luo_menu_items.object.sort_sequence[i]
	lstr_menu.menu_item[i].auto_close_flag = luo_menu_items.object.auto_close_flag[i]
	lstr_menu.menu_item[i].authorized_user_id = luo_menu_items.object.authorized_user_id[i]
	lstr_menu.menu_item[i].id = luo_menu_items.object.id[i]
next

luo_menu_item_attributes = CREATE u_ds_data
luo_menu_item_attributes.set_dataobject("dw_cfg_menu_item_attributes")
ll_attribute_count = luo_menu_item_attributes.retrieve(pstr_config_object.installed_local_key)


TRY
	lo_menu = CREATE pbdom_element
	lo_menu.setname("Menu")
	
	if not isnull(lstr_menu.description) then
		lo_menu.setattribute("description", lstr_menu.description)
	end if
	if not isnull(lstr_menu.context_object) then
		lo_menu.setattribute("context_object", lstr_menu.context_object)
	end if
	
	for i = 1 to lstr_menu.menu_item_count
		lo_menu_item = CREATE pbdom_element
		lo_menu_item.setname("MenuItem")
		lo_menu.addcontent(lo_menu_item)
		
		if not isnull(lstr_menu.menu_item[i].menu_item_type) then 
			lo_menu_item.setattribute("menu_item_type", lstr_menu.menu_item[i].menu_item_type)
		end if
		if not isnull(lstr_menu.menu_item[i].menu_item) then 
			lo_menu_item.setattribute("menu_item", lstr_menu.menu_item[i].menu_item)
		end if
		if not isnull(lstr_menu.menu_item[i].context_object) then 
			lo_menu_item.setattribute("context_object", lstr_menu.menu_item[i].context_object)
		end if
		if not isnull(lstr_menu.menu_item[i].button_title) then 
			lo_menu_item.setattribute("button_title", lstr_menu.menu_item[i].button_title)
		end if
		if not isnull(lstr_menu.menu_item[i].button_help) then 
			lo_menu_item.setattribute("button_help", lstr_menu.menu_item[i].button_help)
		end if
		if not isnull(lstr_menu.menu_item[i].button) then 
			lo_menu_item.setattribute("button", lstr_menu.menu_item[i].button)
		end if
		if not isnull(lstr_menu.menu_item[i].sort_sequence) then 
			lo_menu_item.setattribute("sort_sequence", string(lstr_menu.menu_item[i].sort_sequence))
		end if
		if not isnull(lstr_menu.menu_item[i].auto_close_flag) then 
			lo_menu_item.setattribute("auto_close_flag", lstr_menu.menu_item[i].auto_close_flag)
		end if
		if not isnull(lstr_menu.menu_item[i].authorized_user_id) then 
			lo_menu_item.setattribute("authorized_user_id", lstr_menu.menu_item[i].authorized_user_id)
		end if
		
		ls_filter = "menu_item_id=" + string(lstr_menu.menu_item[i].menu_item_id)
		luo_menu_item_attributes.setfilter(ls_filter)
		luo_menu_item_attributes.filter()
		
		li_sts = add_attributes_from_datastore(pstr_config_object, pbdom_config_object, lo_menu_item, po_nested_parent, luo_menu_item_attributes)
		
	next

	po_version_element.addcontent(lo_menu)
CATCH (throwable lo_error)
	log.log(this, "xx_add_config_object_body()", "Error adding menu xml to document (" + lo_error.text + ")", 4)
	return -1
END TRY


return 1


end function

on u_component_config_object_menu.create
call super::create
end on

on u_component_config_object_menu.destroy
call super::destroy
end on

