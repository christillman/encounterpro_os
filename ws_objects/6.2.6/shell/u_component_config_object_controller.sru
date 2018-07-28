HA$PBExportHeader$u_component_config_object_controller.sru
forward
global type u_component_config_object_controller from u_component_config_object
end type
end forward

global type u_component_config_object_controller from u_component_config_object
end type
global u_component_config_object_controller u_component_config_object_controller

forward prototypes
protected function integer xx_install_config_object (ref str_config_object_info pstr_config_object, ref str_config_object_version pstr_version, ref u_xml_document pbdom_config_object, ref pbdom_element po_version_root_element)
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
str_controller lstr_controller
str_controller_hotspot lstr_hotspot
string ls_attribute
string ls_value
string ls_menu_config_object_id

setnull(ls_null)

lstr_controller = f_empty_controller()

// Get the child elements of the <ConfigObjectVersion> element.  There should only be one, but just call the descendent class
// handler for every element found
po_version_root_element.GetChildElements(ref pbdom_element_array)
for i = 1 to UpperBound(pbdom_element_array)
	lstr_hotspot = f_empty_controller_hotspot()

	pbdom_element_array[i].GetAttributes(ref pbdom_attribute_array[])
	for j = 1 to UpperBound(pbdom_attribute_array)
		CHOOSE CASE lower(pbdom_attribute_array[j].GetName())
			CASE "context_object"
				lstr_hotspot.context_object = pbdom_attribute_array[j].GetText()
			CASE "hotspot_name"
				lstr_hotspot.hotspot_name = pbdom_attribute_array[j].GetText()
			CASE "description"
				lstr_hotspot.description = pbdom_attribute_array[j].GetText()
			CASE "created"
				lstr_hotspot.created = f_string_to_datetime(pbdom_attribute_array[j].GetText())
			CASE "menu_id"
				lstr_hotspot.menu_config_object_id = pbdom_attribute_array[j].GetText()
			CASE "status"
				lstr_hotspot.status = pbdom_attribute_array[j].GetText()
			CASE "created_by"
				lstr_hotspot.created_by = pbdom_attribute_array[j].GetText()
		END CHOOSE
	next
	
	lstr_controller.hotspot_count += 1
	lstr_controller.hotspot[lstr_controller.hotspot_count] = lstr_hotspot
next

li_sts = f_save_controller_config_object(lstr_controller)
if li_sts < 0 then return -1


return 1


end function

protected function integer xx_delete_existing_config_object (ref str_config_object_info pstr_config_object);
DELETE
FROM dbo.c_Controller_Hotspot
WHERE config_object_id = :pstr_config_object.config_object_id;
if not tf_check() then return -1


return 1

end function

protected function integer xx_add_config_object_body (str_config_object_info pstr_config_object, ref pbdom_document pbdom_config_object, ref pbdom_element po_version_element, ref pbdom_element po_nested_parent);pbdom_element lo_root
string ls_null
string ls_xml
integer li_sts
u_ds_data luo_controller
u_xml_document lo_controllerdoc
long ll_count
long i
string ls_menu_config_object_id

Setnull(ls_null)

luo_controller = CREATE u_ds_data

luo_controller.set_dataobject("dw_controller_hotspots")
ll_count = luo_controller.retrieve(pstr_config_object.config_object_id)

for i = 1 to ll_count
	ls_menu_config_object_id = luo_controller.object.menu_config_object_id[i]
	if len(ls_menu_config_object_id) > 0 then
		li_sts = add_nested_config_object(ls_menu_config_object_id, pbdom_config_object, po_nested_parent)
	end if
next


ls_xml =  luo_controller.describe("datawindow.data.xml")

li_sts = f_get_xml_document(ls_xml, lo_controllerdoc)
if li_sts <= 0 then return -1

TRY
	lo_root = lo_controllerdoc.XML_Document.DetachRootElement()
	po_version_element.addcontent(lo_root)
CATCH (throwable lo_error)
	log.log(this, "xx_add_config_object_body()", "Error adding controller xml to document (" + lo_error.text + ")", 4)
	return -1
END TRY


return 1


end function

on u_component_config_object_controller.create
call super::create
end on

on u_component_config_object_controller.destroy
call super::destroy
end on

