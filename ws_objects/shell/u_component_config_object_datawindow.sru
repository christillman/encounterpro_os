HA$PBExportHeader$u_component_config_object_datawindow.sru
forward
global type u_component_config_object_datawindow from u_component_config_object
end type
end forward

global type u_component_config_object_datawindow from u_component_config_object
end type
global u_component_config_object_datawindow u_component_config_object_datawindow

forward prototypes
public function integer xx_delete_existing_config_object (ref str_config_object_info pstr_config_object)
protected function integer xx_add_config_object_body (str_config_object_info pstr_config_object, ref pbdom_document pbdom_config_object, ref pbdom_element po_version_element, ref pbdom_element po_nested_parent)
public function integer xx_install_config_object (ref str_config_object_info pstr_config_object, ref str_config_object_version pstr_version, ref u_xml_document pbdom_config_object, ref pbdom_element po_version_root_element)
end prototypes

public function integer xx_delete_existing_config_object (ref str_config_object_info pstr_config_object);

DELETE
FROM dbo.c_Datawindow_Mapping_Attribute
WHERE config_object_id = :pstr_config_object.config_object_id;
if not tf_check() then return -1

DELETE
FROM dbo.c_Datawindow_Mapping
WHERE config_object_id = :pstr_config_object.config_object_id;
if not tf_check() then return -1

DELETE
FROM dbo.c_Datawindow
WHERE config_object_id = :pstr_config_object.config_object_id;
if not tf_check() then return -1


return 1

end function

protected function integer xx_add_config_object_body (str_config_object_info pstr_config_object, ref pbdom_document pbdom_config_object, ref pbdom_element po_version_element, ref pbdom_element po_nested_parent);pbdom_element lo_datawindow
pbdom_element lo_mapping
pbdom_element lo_attribute
string ls_null
string ls_xml
integer li_sts
long i
long j
str_datawindow_config_object lstr_datawindow

Setnull(ls_null)


li_sts = f_get_datawindow_config_object(pstr_config_object.config_object_id, lstr_datawindow)
if li_sts < 0 then return -1
if li_sts = 0 then return 1

TRY
	lo_datawindow = CREATE pbdom_element
	lo_datawindow.setname("Datawindow")

	if len(lstr_datawindow.controller_config_object_id) > 0 then
		li_sts = add_nested_config_object(lstr_datawindow.controller_config_object_id, pbdom_config_object, po_nested_parent)
	end if
	
	
	if not isnull(lstr_datawindow.config_object_id) then
		lo_datawindow.setattribute("config_object_id", lstr_datawindow.config_object_id)
	end if
	if not isnull(lstr_datawindow.context_object) then
		lo_datawindow.setattribute("context_object", lstr_datawindow.context_object)
	end if
	if not isnull(lstr_datawindow.datawindow_name) then
		lo_datawindow.setattribute("datawindow_name", lstr_datawindow.datawindow_name)
	end if
	if not isnull(lstr_datawindow.description) then
		lo_datawindow.setattribute("description", lstr_datawindow.description)
	end if
	if not isnull(lstr_datawindow.library_component_id) then
		lo_datawindow.setattribute("library_component_id", lstr_datawindow.library_component_id)
	end if
	if not isnull(lstr_datawindow.dataobject) then
		lo_datawindow.setattribute("dataobject", lstr_datawindow.dataobject)
	end if
	if not isnull(lstr_datawindow.datawindow_syntax) then
		lo_datawindow.setattribute("datawindow_syntax", lstr_datawindow.datawindow_syntax)
	end if
	if not isnull(lstr_datawindow.controller_config_object_id) then
		lo_datawindow.setattribute("controller_config_object_id", lstr_datawindow.controller_config_object_id)
	end if
	if not isnull(lstr_datawindow.created_by) then
		lo_datawindow.setattribute("created_by", lstr_datawindow.created_by)
	end if
	if not isnull(lstr_datawindow.created) then
		lo_datawindow.setattribute("created", f_datetime_to_xml_string(lstr_datawindow.created))
	end if
	
	for i = 1 to lstr_datawindow.mappings.mapping_count
		lo_mapping = CREATE pbdom_element
		lo_mapping.setname("Mapping")
		lo_datawindow.addcontent(lo_mapping)

		if not isnull(lstr_datawindow.mappings.mapping[i].control_name) then 
			lo_mapping.setattribute("control_name", lstr_datawindow.mappings.mapping[i].control_name)
		end if
		if not isnull(lstr_datawindow.mappings.mapping[i].hotspot_name) then 
			lo_mapping.setattribute("hotspot_name", lstr_datawindow.mappings.mapping[i].hotspot_name)
		end if
		if not isnull(lstr_datawindow.mappings.mapping[i].created_by) then 
			lo_mapping.setattribute("created_by", lstr_datawindow.mappings.mapping[i].created_by)
		end if
		if not isnull(lstr_datawindow.mappings.mapping[i].created) then 
			lo_mapping.setattribute("created", f_datetime_to_xml_string(lstr_datawindow.mappings.mapping[i].created))
		end if
		
		for j = 1 to lstr_datawindow.mappings.mapping[i].attributes.attribute_count
			lo_attribute = CREATE pbdom_element
			lo_attribute.setname("Attribute")
			lo_mapping.addcontent(lo_attribute)
			if not isnull(lstr_datawindow.mappings.mapping[i].attributes.attribute[j].attribute) then 
				lo_attribute.setattribute("attribute", lstr_datawindow.mappings.mapping[i].attributes.attribute[j].attribute)
			end if
			if not isnull(lstr_datawindow.mappings.mapping[i].attributes.attribute[j].value) then 
				lo_attribute.setattribute("value", lstr_datawindow.mappings.mapping[i].attributes.attribute[j].value)
			end if
		next
	next

	po_version_element.addcontent(lo_datawindow)
CATCH (throwable lo_error)
	log.log(this, "xx_add_config_object_body()", "Error adding datawindow xml to document (" + lo_error.text + ")", 4)
	return -1
END TRY


return 1


end function

public function integer xx_install_config_object (ref str_config_object_info pstr_config_object, ref str_config_object_version pstr_version, ref u_xml_document pbdom_config_object, ref pbdom_element po_version_root_element);integer li_sts
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
str_datawindow_config_object lstr_datawindow
str_datawindow_mapping lstr_mapping
string ls_attribute
string ls_value

setnull(ls_null)

lstr_datawindow = f_empty_datawindow_config_object()


lstr_datawindow.config_object_id = pstr_config_object.config_object_id
lstr_datawindow.status = "OK"

po_version_root_element.GetAttributes(ref pbdom_attribute_array[])
for i = 1 to UpperBound(pbdom_attribute_array)
	CHOOSE CASE lower(pbdom_attribute_array[i].GetName())
		CASE "context_object"
			lstr_datawindow.context_object = pbdom_attribute_array[i].GetText()
		CASE "datawindow_name"
			lstr_datawindow.datawindow_name = pbdom_attribute_array[i].GetText()
		CASE "description"
			lstr_datawindow.description = pbdom_attribute_array[i].GetText()
		CASE "library_component_id"
			lstr_datawindow.library_component_id = pbdom_attribute_array[i].GetText()
		CASE "dataobject"
			lstr_datawindow.dataobject = pbdom_attribute_array[i].GetText()
		CASE "datawindow_syntax"
			lstr_datawindow.datawindow_syntax = pbdom_attribute_array[i].GetText()
		CASE "controller_config_object_id"
			lstr_datawindow.controller_config_object_id = pbdom_attribute_array[i].GetText()
		CASE "created_by"
			lstr_datawindow.created_by = pbdom_attribute_array[i].GetText()
		CASE "created"
			lstr_datawindow.created = f_xml_datetime(pbdom_attribute_array[i].GetText())
	END CHOOSE
next

po_version_root_element.GetChildElements(ref pbdom_element_array)
for i = 1 to UpperBound(pbdom_element_array)
	lstr_mapping = f_empty_datawindow_mapping()

	lstr_mapping.status = "OK"
	string		control_name
	string		hotspot_name
	string		status
	string		created_by
	datetime		created

	pbdom_element_array[i].GetAttributes(ref pbdom_attribute_array[])
	for j = 1 to UpperBound(pbdom_attribute_array)
		CHOOSE CASE lower(pbdom_attribute_array[j].GetName())
			CASE "control_name"
				lstr_mapping.control_name = pbdom_attribute_array[j].GetText()
			CASE "hotspot_name"
				lstr_mapping.hotspot_name = pbdom_attribute_array[j].GetText()
			CASE "created_by"
				lstr_mapping.created_by = pbdom_attribute_array[j].GetText()
			CASE "created"
				lstr_mapping.created = f_xml_datetime(pbdom_attribute_array[j].GetText())
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
				f_attribute_add_attribute(lstr_mapping.attributes, ls_attribute, ls_value)
			end if
		end if
	next
	
	
	lstr_datawindow.mappings.mapping_count += 1
	lstr_datawindow.mappings.mapping[lstr_datawindow.mappings.mapping_count] = lstr_mapping
next

li_sts = f_save_datawindow_config_object(lstr_datawindow)
if li_sts < 0 then return -1


return 1


end function

on u_component_config_object_datawindow.create
call super::create
end on

on u_component_config_object_datawindow.destroy
call super::destroy
end on

