HA$PBExportHeader$u_component_config_object.sru
forward
global type u_component_config_object from u_component_base_class
end type
type str_nested_config_object from structure within u_component_config_object
end type
type str_nested_config_objects from structure within u_component_config_object
end type
end forward

type str_nested_config_object from structure
	string		config_object_id
	long		version
	long		installed_local_key
end type

type str_nested_config_objects from structure
	long		config_object_count
	str_nested_config_object		config_object[]
end type

global type u_component_config_object from u_component_base_class
end type
global u_component_config_object u_component_config_object

type variables
boolean checkin_all_nested = false


end variables
forward prototypes
public function integer encapsulate (str_config_object_info pstr_config_object, ref blob pbl_config_object_data)
public function integer install (string ps_config_object_id, long pl_version)
public function string new_config_object (string ps_config_object_type, str_attributes pstr_attributes)
protected function integer read_config_object_version (ref str_config_object_info pstr_config_object, ref u_xml_document pbdom_config_object, ref pbdom_element po_config_object_version_element)
protected function integer set_local_key (ref str_config_object_info pstr_config_object)
public function integer install (string ps_object_xml)
protected function integer read_config_object (ref u_xml_document pbdom_config_object, ref pbdom_element po_config_object_element)
protected function integer read_nested_config_objects (ref u_xml_document pbdom_config_object, ref pbdom_element po_config_object_element)
public function integer install (blob pbl_objectdata)
public function integer xx_install_config_object (ref str_config_object_info pstr_config_object, ref str_config_object_version pstr_version, ref u_xml_document pbdom_config_object, ref pbdom_element po_version_root_element)
public function integer xx_delete_existing_config_object (ref str_config_object_info pstr_config_object)
protected function integer encapsulate_config_object (ref str_config_object_info pstr_config_object, ref pbdom_document pbdom_config_object, ref pbdom_element po_config_object_parent, ref pbdom_element po_nested_parent)
protected function integer xx_add_config_object_body (str_config_object_info pstr_config_object, ref pbdom_document pbdom_config_object, ref pbdom_element po_version_element, ref pbdom_element po_nested_parent)
protected function integer add_nested_config_object (ref string ps_config_object_id, ref pbdom_document pbdom_config_object, ref pbdom_element po_nested_parent)
protected function integer add_attributes_from_datastore (str_config_object_info pstr_config_object, ref pbdom_document pbdom_config_object, ref pbdom_element po_attribute_parent, ref pbdom_element po_nested_parent, u_ds_data puo_attributes)
protected function integer read_nested_config_object (ref u_xml_document pbdom_config_object, ref pbdom_element po_config_object_element)
end prototypes

public function integer encapsulate (str_config_object_info pstr_config_object, ref blob pbl_config_object_data);pbdom_document lo_xml
pbdom_element lo_root
pbdom_element lo_nested
string ls_null
string ls_xml
integer li_sts

Setnull(ls_null)
setnull(lo_nested)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Create the document and the <Nested> parent
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
TRY
	lo_xml = CREATE PBDOM_Document
	lo_xml.newdocument("EPConfigObjects")
	lo_root = lo_xml.Getrootelement()
CATCH (throwable lo_error)
	log.log(this, "f_create_datawindow_config_object()", "Error creating document (" + lo_error.text + ")", 4)
	return -1
END TRY



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Create the <ConfigObject> block under the root and any nested objects under <Nested>
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
li_sts = encapsulate_config_object(pstr_config_object, lo_xml, lo_root, lo_nested)
if li_sts <= 0 then
	log.log(this, "encapsulate()", "Error creating xml shell", 4)
	return -1
end if


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Serialize the xml and convert to blob
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
TRY
	ls_xml = lo_xml.savedocumentintostring()
CATCH (throwable lo_error2)
	log.log(this, "f_create_datawindow_config_object()", "Error saving document (" + lo_error2.text + ")", 4)
	return -1
END TRY

pbl_config_object_data = f_string_to_blob(ls_xml, "UTF-8")

return 1


end function

public function integer install (string ps_config_object_id, long pl_version);str_config_object_info lstr_config_object
integer li_sts
blob lbl_objectdata
string ls_object_xml

if isnull(ps_config_object_id) then
	log.log(this, "f_config_object_install_comobjmgr()", "config_object_id is null", 4)
	return -1
end if

if isnull(pl_version) then
	log.log(this, "f_config_object_install_comobjmgr()", "Version is null", 4)
	return -1
end if

li_sts = f_get_config_object_info(ps_config_object_id,lstr_config_object)
if li_sts <= 0 then return li_sts

li_sts = f_get_config_object_objectdata(ps_config_object_id, lbl_objectdata)
if li_sts <= 0 then return li_sts

ls_object_xml = f_blob_to_string(lbl_objectdata)

return install(ls_object_xml)

end function

public function string new_config_object (string ps_config_object_type, str_attributes pstr_attributes);integer li_sts
str_popup popup
str_popup popup2
str_popup_return popup_return
string ls_context_object
string ls_description
string ls_config_object_id
string ls_null
long ll_sts
long ll_count
string ls_long_description
blob lbl_configobjectdata
string ls_status
string ls_version_description
string ls_copyright_status
string ls_copyable
string ls_config_object_category
long ll_version

setnull(ls_null)
setnull(ls_long_description)

ls_status = "CheckedIn"
setnull(ls_version_description)
setnull(ls_copyright_status)
setnull(ls_copyable)
setnull(ls_config_object_category)
ll_version = 1

popup.title = "Select " + wordcap(ps_config_object_type) + " Context"
popup.dataobject = "dw_domain_notranslate_list"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = "CONTEXT_OBJECT"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return ls_null

ls_context_object = popup_return.items[1]

DO WHILE true
	popup2.title = "Enter title of new " + lower(ps_config_object_type) 
	openwithparm(w_pop_prompt_string, popup2)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return ls_null
	
	ls_description = popup_return.items[1]
	
	SELECT count(*)
	INTO :ll_count
	FROM c_Config_object
	WHERE config_object_type = :ps_config_object_type
	AND status = 'OK'
	AND context_object = :ls_context_object
	AND description = :ls_description;
	if not tf_check() then return ls_null
	if ll_count > 0 then
		openwithparm(w_pop_message, "There is already a " + ls_context_object + " " + lower(ps_config_object_type) + " with that title.  Please enter a different title for the new " + ps_config_object_type + ".")
	else
		exit
	end if
LOOP

setnull(lbl_configobjectdata)

ls_config_object_id = f_new_guid()

ll_sts = sqlca.config_create_object_version(ls_config_object_id, &
												ps_config_object_type, &
												ls_context_object, &
												sqlca.customer_id, &
												ls_description, &
												ls_long_description, &
												ls_config_object_category, &
												ll_version, &
												lbl_configobjectdata, &
												current_scribe.user_id, &
												ls_status, &
												ls_version_description, &
												ls_copyright_status, &
												ls_copyable, &
												ls_null)
if not tf_check() then return ls_null
if ll_sts <> 1 then
	log.log(this, "new_config_object()", "Error creating new config object", 4)
	return ls_null
end if

return ls_config_object_id

end function

protected function integer read_config_object_version (ref str_config_object_info pstr_config_object, ref u_xml_document pbdom_config_object, ref pbdom_element po_config_object_version_element);integer li_sts
PBDOM_ELEMENT pbdom_element_array[]
PBDOM_ATTRIBUTE pbdom_attribute_array[]
long i
str_config_object_version lstr_version
blob lbl_objectdata
long ll_sts
string ls_null
integer li_concurrent_install_flag
string ls_object_component_id
u_component_config_object luo_config_object

setnull(ls_null)

lstr_version = f_empty_config_object_version()


po_config_object_version_element.GetAttributes(ref pbdom_attribute_array[])
for i = 1 to UpperBound(pbdom_attribute_array)
	CHOOSE CASE lower(pbdom_attribute_array[i].GetName())
		CASE "status"
			lstr_version.status = pbdom_attribute_array[i].GetText()
		CASE "created"
			lstr_version.created = f_string_to_datetime(pbdom_attribute_array[i].GetText())
		CASE "version"
			lstr_version.version = long(pbdom_attribute_array[i].GetText())
		CASE "created_from_version"
			lstr_version.created_from_version = long(pbdom_attribute_array[i].GetText())
		CASE "owner_id"
			lstr_version.owner_id = long(pbdom_attribute_array[i].GetText())
		CASE "created_by"
			lstr_version.created_by = pbdom_attribute_array[i].GetText()
		CASE "description"
			lstr_version.description = pbdom_attribute_array[i].GetText()
		CASE "version_description"
			lstr_version.version_description = pbdom_attribute_array[i].GetText()
		CASE "release_status"
			lstr_version.release_status = pbdom_attribute_array[i].GetText()
		CASE "release_status_date_time"
			lstr_version.release_status_date_time =  f_string_to_datetime(pbdom_attribute_array[i].GetText())
		CASE "checked_in"
			lstr_version.checked_in =  f_string_to_datetime(pbdom_attribute_array[i].GetText())
		CASE "config_object_id"
			lstr_version.config_object_id = pbdom_attribute_array[i].GetText()
		CASE "status_date_time"
			lstr_version.status_date_time =  f_string_to_datetime(pbdom_attribute_array[i].GetText())
		CASE "config_object_type"
			lstr_version.config_object_type = pbdom_attribute_array[i].GetText()
	END CHOOSE
next

lbl_objectdata = f_string_to_blob(pbdom_config_object.xml_string, "UTF-8")

ll_sts = sqlca.config_new_config_object_version(pstr_config_object.config_object_id, &
														lstr_version.version, &
														lbl_objectdata, &
														lstr_version.created_from_version, &
														lstr_version.created_by, &
														lstr_version.status, &
														lstr_version.status_date_time, &
														lstr_version.version_description, &
														lstr_version.release_status, &
														lstr_version.release_status_date_time)
if not tf_check() then return -1
if ll_sts <> 1 then
	log.log(this, "read_config_object_version()", "Error creating new datawindow", 4)
	return -1
end if

// See if we should install the config object now
SELECT installed_local_key, installed_version
INTO :pstr_config_object.installed_local_key, :pstr_config_object.installed_version
FROM c_Config_Object
WHERE config_object_id = :pstr_config_object.config_object_id;
if not tf_check() then return -1
if sqlca.sqlnrows <> 1 then
	setnull(pstr_config_object.installed_local_key)
	setnull(pstr_config_object.installed_version)
end if

if isnull(pstr_config_object.installed_version) or pstr_config_object.installed_version < lstr_version.version then
	SELECT concurrent_install_flag, object_component_id
	INTO :li_concurrent_install_flag, :ls_object_component_id
	FROM c_Config_Object_Type
	WHERE config_object_type = :pstr_config_object.config_object_type;
	if not tf_check() then return -1
	if sqlca.sqlnrows <> 1 then
		log.log(this, "read_config_object_version()", "config_object_type record not found (" + pstr_config_object.config_object_type + ")", 4)
		return -1
	end if
	
	
	luo_config_object = component_manager.get_component(ls_object_component_id)
	if isnull(luo_config_object) then
		log.log(this, "read_config_object_version()", "Error getting config object component (" + ls_object_component_id + ")", 4)
		return -1
	end if
	
	if not isnull(pstr_config_object.installed_local_key) then
		li_sts =  luo_config_object.xx_delete_existing_config_object(pstr_config_object)
		if li_sts < 0 then return -1
		if li_sts > 0 then
			setnull(pstr_config_object.installed_local_key)
		end if
	end if
	
	// Get the child elements of the <ConfigObjectVersion> element.  There should only be one, but just call the descendent class
	// handler for every element found
	po_config_object_version_element.GetChildElements(ref pbdom_element_array)
	for i = 1 to UpperBound(pbdom_element_array)
		li_sts = luo_config_object.xx_install_config_object(pstr_config_object, lstr_version, pbdom_config_object, pbdom_element_array[i])
		if ll_sts < 0 then
			log.log(this, "read_config_object_version()", "Error installing config object (" + pstr_config_object.config_object_id + ")", 4)
			return -1
		end if
	next

	li_sts = set_local_key(pstr_config_object)

	component_manager.destroy_component(luo_config_object)
end if

return 1


end function

protected function integer set_local_key (ref str_config_object_info pstr_config_object);

UPDATE c_Config_Object
SET installed_local_key = :pstr_config_object.installed_local_key
WHERE config_object_id = :pstr_config_object.config_object_id;
if not tf_check() then return -1

return 1

end function

public function integer install (string ps_object_xml);integer li_sts
u_xml_document pbdom_doc
PBDOM_ELEMENT pbdom_root
PBDOM_ELEMENT pbdom_nested
PBDOM_ELEMENT pbdom_config_object
PBDOM_ELEMENT pbdom_element_array[]
string ls_root
long i
string ls_file
string ls_element


li_sts = f_get_xml_document(ps_object_xml, pbdom_doc)
if li_sts <= 0 then return -1

pbdom_root = pbdom_doc.XML_Document.GetRootElement()

ls_root = pbdom_root.GetName()

if lower(ls_root) <> "epconfigobjects" then
	log.log(this, "f_datawindow_read_config_object()", "Root element is not ~"EPConfigObjects~"", 4)
	return -1
end if

pbdom_root.GetChildElements(ref pbdom_element_array)
for i = 1 to UpperBound(pbdom_element_array)
	ls_element = pbdom_element_array[i].getname()
	if len(ls_element) > 0 then
		CHOOSE CASE lower(ls_element)
			CASE "nested"
				pbdom_nested = pbdom_element_array[i]
			CASE "configobject"
				pbdom_config_object = pbdom_element_array[i]
		END CHOOSE
	end if
next

// Config Object attributes
if not isnull(pbdom_nested) and isvalid(pbdom_nested) then
	li_sts = read_nested_config_objects(pbdom_doc, pbdom_nested)
	if li_sts < 0 then return -1
end if

// Config Object attributes
li_sts = read_config_object(pbdom_doc, pbdom_config_object)
if li_sts < 0 then return -1

return 1

end function

protected function integer read_config_object (ref u_xml_document pbdom_config_object, ref pbdom_element po_config_object_element);integer li_sts
long ll_sts
PBDOM_ELEMENT pbdom_element_array[]
PBDOM_ATTRIBUTE pbdom_attribute_array[]
long i
string ls_element
blob lbl_objectdata
str_config_object_info lstr_config_object

setnull(lbl_objectdata)

lstr_config_object = f_empty_config_object_info()

po_config_object_element.GetAttributes(ref pbdom_attribute_array[])
for i = 1 to UpperBound(pbdom_attribute_array)
	CHOOSE CASE lower(pbdom_attribute_array[i].GetName())
		CASE "config_object_id"
			lstr_config_object.config_object_id = pbdom_attribute_array[i].GetText()
		CASE "config_object_type"
			lstr_config_object.config_object_type = pbdom_attribute_array[i].GetText()
		CASE "context_object"
			lstr_config_object.context_object = pbdom_attribute_array[i].GetText()
		CASE "description"
			lstr_config_object.description = pbdom_attribute_array[i].GetText()
		CASE "long_description"
			lstr_config_object.long_description = pbdom_attribute_array[i].GetText()
		CASE "config_object_category"
			lstr_config_object.config_object_category = pbdom_attribute_array[i].GetText()
		CASE "owner_id"
			lstr_config_object.owner_id = long(pbdom_attribute_array[i].GetText())
		CASE "owner_description"
			lstr_config_object.owner_description = pbdom_attribute_array[i].GetText()
		CASE "created"
			lstr_config_object.created = f_string_to_datetime(pbdom_attribute_array[i].GetText())
		CASE "created_by"
			lstr_config_object.created_by = pbdom_attribute_array[i].GetText()
		CASE "status"
			lstr_config_object.status = pbdom_attribute_array[i].GetText()
	END CHOOSE
next

// If the config object does not exist then create it
if isnull(lstr_config_object.config_object_id) then
	ll_sts = sqlca.config_new_config_object(lstr_config_object.config_object_id, &
													lstr_config_object.config_object_type, &
													lstr_config_object.context_object, &
													lstr_config_object.description, &
													lstr_config_object.long_description, &
													lstr_config_object.config_object_category, &
													lstr_config_object.owner_id, &
													lstr_config_object.created_by &
													)
	if not tf_check() then return -1
	if ll_sts <> 1 then
		log.log(this, "f_new_datawindow()", "Error creating new datawindow", 4)
		return -1
	end if
end if

// Get the child elements of the <ConfigObject> element
po_config_object_element.GetChildElements(ref pbdom_element_array)
for i = 1 to UpperBound(pbdom_element_array)
	ls_element = pbdom_element_array[i].getname()
	if len(ls_element) > 0 then
		CHOOSE CASE lower(ls_element)
			CASE "configobjectversion"
				// Config Object attributes
				li_sts = read_config_object_version(lstr_config_object, pbdom_config_object, pbdom_element_array[i])
		END CHOOSE
	end if
next


return 1


end function

protected function integer read_nested_config_objects (ref u_xml_document pbdom_config_object, ref pbdom_element po_config_object_element);integer li_sts
long ll_sts
PBDOM_ELEMENT pbdom_element_array[]
long i
string ls_element

po_config_object_element.GetChildElements(ref pbdom_element_array)
for i = 1 to UpperBound(pbdom_element_array)
	ls_element = pbdom_element_array[i].getname()
	if len(ls_element) > 0 then
		CHOOSE CASE lower(ls_element)
			CASE "configobjectdata"
				li_sts = read_nested_config_object(pbdom_config_object,  pbdom_element_array[i])
		END CHOOSE
	end if
next



return 1


end function

public function integer install (blob pbl_objectdata);string ls_object_xml

ls_object_xml = f_blob_to_string(pbl_objectdata)

return install(ls_object_xml)

end function

public function integer xx_install_config_object (ref str_config_object_info pstr_config_object, ref str_config_object_version pstr_version, ref u_xml_document pbdom_config_object, ref pbdom_element po_version_root_element);// This method will be overridden by the descendent classes and will provide the body content for the encapsulated config object
// The "version_root_element" is the first level child element of the <ConfigObjectVersion> element


return 0


end function

public function integer xx_delete_existing_config_object (ref str_config_object_info pstr_config_object);// This method will be overridden by the descendent class with the appropriate logic for deleting the installed config object in preparation for installing/re-installing


return 0

end function

protected function integer encapsulate_config_object (ref str_config_object_info pstr_config_object, ref pbdom_document pbdom_config_object, ref pbdom_element po_config_object_parent, ref pbdom_element po_nested_parent);pbdom_element lo_config_object
pbdom_element lo_version_element
pbdom_element lo_element
string ls_description
string ls_null
integer li_sts
string ls_version_description
string ls_config_object_type
long ll_owner_id
datetime ldt_created
string ls_created_by
string ls_status
datetime ldt_status_date_time
string ls_release_status
string ls_temp

Setnull(ls_null)

SELECT description,
			version_description,
			config_object_type,
			owner_id,
			created,
			created_by,
			status,
			status_date_time,
			release_status
INTO :ls_description,
		:ls_version_description,
		:ls_config_object_type,
		:ll_owner_id,
		:ldt_created,
		:ls_created_by,
		:ls_status,
		:ldt_status_date_time,
		:ls_release_status
FROM c_Config_Object_Version
WHERE config_object_id = :pstr_config_object.config_object_id
AND version = :pstr_config_object.installed_version;
if not tf_check() then return -1


TRY
	// Create the child elements
	lo_config_object = CREATE PBDOM_Element
	lo_config_object.setname("ConfigObject")
	// Add attributes
	if not isnull(pstr_config_object.config_object_id) then
		lo_config_object.setattribute("config_object_id", pstr_config_object.config_object_id)
	end if
	if not isnull(pstr_config_object.config_object_type) then
		lo_config_object.setattribute("config_object_type", pstr_config_object.config_object_type)
	end if
	if not isnull(pstr_config_object.context_object) then
		lo_config_object.setattribute("context_object", pstr_config_object.context_object)
	end if
	if not isnull(pstr_config_object.description) then
		lo_config_object.setattribute("description", pstr_config_object.description)
	end if
	if not isnull(pstr_config_object.owner_id) then
		ls_temp = string(pstr_config_object.owner_id)
		lo_config_object.setattribute("owner_id", ls_temp)
	end if
	if not isnull(pstr_config_object.owner_description) then
		lo_config_object.setattribute("owner_description", pstr_config_object.owner_description)
	end if
	if not isnull(pstr_config_object.created) then
		ls_temp = string(pstr_config_object.created)
		lo_config_object.setattribute("created", ls_temp)
	end if
	if not isnull(pstr_config_object.created_by) then
		lo_config_object.setattribute("created_by", pstr_config_object.created_by)
	end if
	if not isnull(pstr_config_object.status) then
		lo_config_object.setattribute("status", pstr_config_object.status)
	end if
	if not isnull(pstr_config_object.copyright_status) then
		lo_config_object.setattribute("copyright_status", pstr_config_object.copyright_status)
	end if
	if not isnull(pstr_config_object.copyable) then
		ls_temp = string(pstr_config_object.copyable)
		lo_config_object.setattribute("copyable", ls_temp)
	end if
	po_config_object_parent.addcontent(lo_config_object)
	
	lo_version_element = CREATE PBDOM_Element
	lo_version_element.setname("ConfigObjectVersion")
	// Add the config object version attributes
	if not isnull(pstr_config_object.config_object_id) then
		lo_version_element.setattribute("config_object_id", pstr_config_object.config_object_id)
	end if
	if not isnull(pstr_config_object.installed_version) then
		ls_temp = string(pstr_config_object.installed_version)
		lo_version_element.setattribute("version", ls_temp)
	end if
	if not isnull(ls_description) then
		lo_version_element.setattribute("description", ls_description)
	end if
	if not isnull(ls_version_description) then
		lo_version_element.setattribute("version_description", ls_version_description)
	end if
	if not isnull(ls_config_object_type) then
		lo_version_element.setattribute("config_object_type", ls_config_object_type)
	end if
	if not isnull(ll_owner_id) then
		ls_temp = string(ll_owner_id)
		lo_version_element.setattribute("owner_id", ls_temp)
	end if
	if not isnull(ldt_created) then
		ls_temp = string(ldt_created)
		lo_version_element.setattribute("created", ls_temp)
	end if
	if not isnull(ls_created_by) then
		lo_version_element.setattribute("created_by", ls_created_by)
	end if
	if not isnull(ls_status) then
		lo_version_element.setattribute("status", ls_status)
	end if
	if not isnull(ldt_status_date_time) then
		ls_temp = string(ldt_status_date_time)
		lo_version_element.setattribute("status_date_time", ls_temp)
	end if
	if not isnull(ls_release_status) then
		lo_version_element.setattribute("release_status", ls_release_status)
	end if
	lo_config_object.addcontent(lo_version_element)
	
CATCH (throwable lo_error)
	log.log(this, "f_create_datawindow_config_object()", "Error creating document (" + lo_error.text + ")", 4)
	return -1
END TRY

// Now add the body under the config object version element
li_sts = xx_add_config_object_body(pstr_config_object, pbdom_config_object, lo_version_element, po_nested_parent)
if li_sts <= 0 then
	log.log(this, "encapsulate_config_object()", "Error generating xml config object body", 4)
	return -1
end if


return 1


end function

protected function integer xx_add_config_object_body (str_config_object_info pstr_config_object, ref pbdom_document pbdom_config_object, ref pbdom_element po_version_element, ref pbdom_element po_nested_parent);// This method will be overridden by the descendent classes and will provide the body content for the encapsulated config object


return 1


end function

protected function integer add_nested_config_object (ref string ps_config_object_id, ref pbdom_document pbdom_config_object, ref pbdom_element po_nested_parent);pbdom_element lo_config_object
pbdom_element lo_version_element
pbdom_element lo_element
pbdom_element lo_root
string ls_description
string ls_null
integer li_sts
string ls_version_description
string ls_config_object_type
long ll_owner_id
datetime ldt_created
string ls_created_by
string ls_status
datetime ldt_status_date_time
string ls_release_status
string ls_temp
str_config_object_info lstr_config_object
integer li_concurrent_install_flag
string ls_object_component_id
u_component_config_object luo_config_object
str_popup popup
long ll_choice
blob lbl_objectdata
string ls_encoded_data

Setnull(ls_null)

// If we haven't created the nested parent yet then do so now
if isnull(po_nested_parent) then
	lo_root = pbdom_config_object.GetRootElement()

	po_nested_parent = CREATE pbdom_element
	po_nested_parent.setname("Nested")
	
	lo_root.addcontent(po_nested_parent)
end if

li_sts = f_get_config_object_info(ps_config_object_id, lstr_config_object)
if li_sts <= 0 then return li_sts

if lower(lstr_config_object.installed_version_status) <> "checkedin" then
	if not checkin_all_nested then
		popup.title = "A nested configuration object (" + lstr_config_object.config_object_type + ":" + lstr_config_object.description + ") is currently checked out and must be checked in prior to checking in this configuration object.  Do you wish to check in the nested " + lstr_config_object.config_object_type + " now?"
		popup.data_row_count = 3
		popup.items[1] = "Yes"
		popup.items[2] = "No (Cancel Checkin)"
		popup.items[3] = "Yes to all"
		openwithparm(w_pop_choices_3, popup)
		ll_choice = message.doubleparm
		if ll_choice = 2 then return -1
		if ll_choice = 3 then checkin_all_nested = true
	end if
	
	li_sts = f_check_in_config_object_silent(lstr_config_object, ls_null)
	if li_sts < 0 then
		openwithparm(w_pop_message, "Check in nested config object failed")
		return -1
	end if
end if

li_sts = f_get_config_object_objectdata(ps_config_object_id, lbl_objectdata)
if li_sts < 0 then return -1

TRY
	ls_encoded_data = common_thread.eprolibnet4.convertbinarytobase64(lbl_objectdata)
	if isnull(ls_encoded_data) or len(ls_encoded_data) = 0 then
		log.log(this, "add_nested_config_object()", "Error converting objectdata to base64 (" + ps_config_object_id + ")", 4)
		return -1
	end if
CATCH (oleruntimeerror lt_error)
	log.log(this, "add_nested_config_object()", "Error converting objectdatar ~r~n" + lt_error.text + "~r~n" + lt_error.description, 4)
END TRY

TRY
	// Create the child elements
	lo_config_object = CREATE PBDOM_Element
	lo_config_object.setname("ConfigObjectData")
	// Add attributes
	if not isnull(lstr_config_object.config_object_id) then
		lo_config_object.setattribute("config_object_id", lstr_config_object.config_object_id)
	end if
	if not isnull(lstr_config_object.config_object_type) then
		lo_config_object.setattribute("config_object_type", lstr_config_object.config_object_type)
	end if
	if not isnull(lstr_config_object.context_object) then
		lo_config_object.setattribute("context_object", lstr_config_object.context_object)
	end if
	if not isnull(lstr_config_object.description) then
		lo_config_object.setattribute("description", lstr_config_object.description)
	end if
	if not isnull(lstr_config_object.installed_version) then
		ls_temp = string(lstr_config_object.installed_version)
		lo_config_object.setattribute("version", ls_temp)
	end if
	if not isnull(lstr_config_object.owner_id) then
		ls_temp = string(lstr_config_object.owner_id)
		lo_config_object.setattribute("owner_id", ls_temp)
	end if
	if not isnull(lstr_config_object.owner_description) then
		lo_config_object.setattribute("owner_description", lstr_config_object.owner_description)
	end if
	
	lo_config_object.addcontent(ls_encoded_data)
	
	po_nested_parent.addcontent(lo_config_object)
CATCH (throwable lo_error)
	log.log(this, "add_nested_config_object()", "Error creating document (" + lo_error.text + ")", 4)
	return -1
END TRY

return li_sts


end function

protected function integer add_attributes_from_datastore (str_config_object_info pstr_config_object, ref pbdom_document pbdom_config_object, ref pbdom_element po_attribute_parent, ref pbdom_element po_nested_parent, u_ds_data puo_attributes);long ll_rowcount
long i
string ls_attribute
string ls_value
pbdom_element lo_attribute

ll_rowcount = puo_attributes.rowcount()

TRY
	for i = 1 to ll_rowcount
		ls_attribute = puo_attributes.object.attribute[i]
		ls_value = puo_attributes.object.value[i]
		
		if len(ls_attribute) > 0 and len(ls_value) > 0 then
			lo_attribute = CREATE pbdom_element
			lo_attribute.setname("Attribute")
			lo_attribute.setattribute("Attribute", ls_attribute)
			lo_attribute.setattribute("Value", ls_value)
			po_attribute_parent.addcontent(lo_attribute)
		end if
	next
CATCH (throwable lo_error)
	log.log(this, "add_attributes_from_datastore()", "Error adding attributes (" + lo_error.text + ")", 4)
	return -1
END TRY



return 1


end function

protected function integer read_nested_config_object (ref u_xml_document pbdom_config_object, ref pbdom_element po_config_object_element);integer li_sts
long ll_sts
PBDOM_ATTRIBUTE pbdom_attribute_array[]
long i
string ls_element
blob lbl_objectdata
str_config_object_info lstr_config_object
string ls_encoded_object

setnull(lbl_objectdata)

lstr_config_object = f_empty_config_object_info()

po_config_object_element.GetAttributes(ref pbdom_attribute_array[])
for i = 1 to UpperBound(pbdom_attribute_array)
	CHOOSE CASE lower(pbdom_attribute_array[i].GetName())
		CASE "config_object_id"
			lstr_config_object.config_object_id = pbdom_attribute_array[i].GetText()
		CASE "config_object_type"
			lstr_config_object.config_object_type = pbdom_attribute_array[i].GetText()
		CASE "context_object"
			lstr_config_object.context_object = pbdom_attribute_array[i].GetText()
		CASE "description"
			lstr_config_object.description = pbdom_attribute_array[i].GetText()
		CASE "long_description"
			lstr_config_object.long_description = pbdom_attribute_array[i].GetText()
		CASE "config_object_category"
			lstr_config_object.config_object_category = pbdom_attribute_array[i].GetText()
		CASE "owner_id"
			lstr_config_object.owner_id = long(pbdom_attribute_array[i].GetText())
		CASE "owner_description"
			lstr_config_object.owner_description = pbdom_attribute_array[i].GetText()
		CASE "created"
			lstr_config_object.created = f_string_to_datetime(pbdom_attribute_array[i].GetText())
		CASE "created_by"
			lstr_config_object.created_by = pbdom_attribute_array[i].GetText()
		CASE "status"
			lstr_config_object.status = pbdom_attribute_array[i].GetText()
	END CHOOSE
next

ls_encoded_object = po_config_object_element.GetText()

TRY
	lbl_objectdata = common_thread.eprolibnet4.convertbase64toBinary(ls_encoded_object)
	if isnull(lbl_objectdata) or len(lbl_objectdata) = 0 then
		log.log(this, "read_nested_config_object()", "Error converting nested base64 to objectdata (" + lstr_config_object.config_object_id + ")", 4)
		return -1
	end if
CATCH (oleruntimeerror lt_error)
	log.log(this, "read_nested_config_object()", "Error converting nested base64 to objectdata (" + lstr_config_object.config_object_id + ")r ~r~n" + lt_error.text + "~r~n" + lt_error.description, 4)
END TRY

// We have the nested blob in hand now, so install it
li_sts = f_config_object_install_blob(lbl_objectdata)
if ll_sts < 0 then
	log.log(this, "read_config_object_version()", "Error installing config object (" + lstr_config_object.config_object_id + ")", 4)
	return -1
end if


return 1


end function

on u_component_config_object.create
call super::create
end on

on u_component_config_object.destroy
call super::destroy
end on

