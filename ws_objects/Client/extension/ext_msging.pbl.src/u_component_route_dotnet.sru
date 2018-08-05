$PBExportHeader$u_component_route_dotnet.sru
forward
global type u_component_route_dotnet from u_component_route
end type
end forward

global type u_component_route_dotnet from u_component_route
end type
global u_component_route_dotnet u_component_route_dotnet

forward prototypes
protected function integer xx_send_document (u_component_wp_item_document puo_document)
private function integer add_document_to_componentdata (ref string ps_componentdata_xml, u_component_wp_item_document puo_document)
protected function integer xx_initialize ()
end prototypes

protected function integer xx_send_document (u_component_wp_item_document puo_document);string ls_new_xml
integer li_sts
str_patient_material lstr_material
long ll_material_id
blob lbl_temp
string ls_xslt
u_xml_script lo_xml
str_attributes lstr_attributes
str_context lstr_context
u_xml_document lo_document
long ll_xml_script_id
str_patient_materials lstr_patient_materials
string ls_message
long ll_return_status


lstr_attributes = get_attributes()

lstr_context = f_attributes_to_context(lstr_attributes)
if isnull(lstr_context.cpr_id) or lower(lstr_context.context_object) = "general" then
	lstr_context = f_current_context()
end if


setnull(ls_xslt)

get_attribute("ls_xslt_material_id", ll_material_id)
lstr_material = f_get_patient_material(ll_material_id, true)
if isnull(lstr_material.material_id) then
	ls_xslt = string(lstr_material.material_object)
end if

li_sts = f_attribute_get_materials(lstr_attributes, true, lstr_patient_materials)

setnull(ll_xml_script_id)
lo_xml = CREATE u_xml_script
li_sts = lo_xml.create_xml(puo_document.patient_workplan_item_id, &
									ll_xml_script_id, &
									"JMJComponentData", &
									lstr_context, &
									lstr_attributes,&
									lstr_patient_materials, &
									lo_document)
dotnet_xml_data = lo_document.xml_string
if isnull(dotnet_xml_data) then
	log.log(this, "u_component_route_dotnet.xx_send_document:0046", "Error getting xml data", 4)
	return -1
end if

li_sts = add_document_to_componentdata(dotnet_xml_data, puo_document)
if li_sts < 0 then return -1

TRY
	ll_return_status = com_wrapper.SendDocument(dotnet_xml_data)
CATCH (oleruntimeerror lt_error)
	ls_message += lt_error.text + "~r~n" + lt_error.description
	log.log(this, "u_component_route_dotnet.xx_send_document:0057", "Error calling SendDocument:~r~n" + ls_message, 4)
	dotnet_create_test_case()
	return -1
END TRY
if debug_mode then
	dotnet_create_test_case()
end if

if ll_return_status <= 0 OR isnull(ll_return_status)  then
	if isnull(ll_return_status) then
		ls_message = ".NET component returned an error code (null)"
	else
		ls_message = ".NET component returned an error code (" + string(ll_return_status) + ")"
	end if
	log.log(this, "u_component_route_dotnet.xx_send_document:0071", ls_message, 4)
	return -1
end if

return 1


end function

private function integer add_document_to_componentdata (ref string ps_componentdata_xml, u_component_wp_item_document puo_document);u_ds_data luo_data
long ll_count
long i
long ll_rows
PBDOM_BUILDER pbdombuilder_new
PBDOM_Document lo_document
PBDOM_Document lo_document2
PBDOM_ELEMENT lo_root
PBDOM_ELEMENT lo_root2
PBDOM_ELEMENT lo_data2
PBDOM_ELEMENT lo_data3
PBDOM_ELEMENT lo_rows[]
PBDOM_ELEMENT lo_data
string ls_sql
str_external_observation_attachment lstr_document
integer li_sts
string ls_encoded_data
string ls_xml
string ls_document_encoding

li_sts = puo_document.get_document(lstr_document)
if li_sts <= 0 then
	log.log(this, "u_component_route_dotnet.add_document_to_componentdata:0023", "Error sending document (" + string(puo_document.patient_workplan_item_id) + ")", 4)
	return -1
end if

ls_document_encoding = get_attribute("document_encoding")
if isnull(ls_document_encoding) then
	ls_document_encoding = "base64"
end if
CHOOSE CASE lower(ls_document_encoding)
	CASE "base64"
		TRY
			ls_encoded_data = common_thread.eprolibnet4.convertbinarytobase64(lstr_document.attachment)
			if isnull(ls_encoded_data) or len(ls_encoded_data) = 0 then
				log.log(this, "u_component_route_dotnet.add_document_to_componentdata:0036", "Error converting file data to base64 (" + string(lstr_document.attachment) + ")", 4)
				return -1
			end if
		CATCH (oleruntimeerror lt_error)
			log.log(this, "u_component_route_dotnet.add_document_to_componentdata:0040", "Error converting document datar ~r~n" + lt_error.text + "~r~n" + lt_error.description, 4)
		END TRY
	CASE "hex", "binhex"
		ls_document_encoding = "hex"
		TRY
			ls_encoded_data = common_thread.eprolibnet4.convertbinarytohex(lstr_document.attachment)
			if isnull(ls_encoded_data) or len(ls_encoded_data) = 0 then
				log.log(this, "u_component_route_dotnet.add_document_to_componentdata:0047", "Error converting file data to hex (" + string(lstr_document.attachment) + ")", 4)
				return -1
			end if
		CATCH (oleruntimeerror lt_error2)
			log.log(this, "u_component_route_dotnet.add_document_to_componentdata:0051", "Error converting document datar ~r~n" + lt_error2.text + "~r~n" + lt_error2.description, 4)
		END TRY
	CASE "string"
		ls_encoded_data = f_blob_to_string(lstr_document.attachment)
	CASE ELSE
END CHOOSE

TRY
	pbdombuilder_new = CREATE PBDOM_BUILDER
	lo_document = pbdombuilder_new.buildfromstring(ps_componentdata_xml)
	lo_root = lo_document.GetRootElement()
	lo_data = lo_root.getchildelement("Data")
	if isnull(lo_data) then
		lo_data = CREATE PBDOM_ELEMENT
		lo_data.setname("Data")
		lo_root.addcontent(lo_data)
	end if
	
	luo_data = CREATE u_ds_data
	
	// Add the Document Route data
	ls_sql = "select * from dbo.fn_document_route_information('" + puo_document.dispatch_method + "')"

	ll_count = luo_data.load_query(ls_sql, lo_document2, "Root", "DocumentRoute")
	if ll_count < 0 then return -1
	if ll_count > 0 then
		ls_xml = lo_document2.savedocumentintostring()
		lo_root2 = lo_document2.getrootelement()
		if lo_root2.getchildelements(lo_rows) then
			ll_count = upperbound(lo_rows)
			for i = 1 to ll_count
				lo_rows[i].detach()
				lo_data.addcontent(lo_rows[i])
			next
		end if
	end if
	
	// Add the Component Interface data
	ls_sql = "select i.* from dbo.fn_document_route_information('" + puo_document.dispatch_method + "')	 r	LEFT OUTER JOIN c_component_interface i   ON i.subscriber_owner_id = r.owner_id   AND i.interfaceserviceid = r.send_via_addressee"
	
	ll_count = luo_data.load_query(ls_sql, lo_document2, "Root", "ComponentInterface")
	if ll_count < 0 then return -1
	if ll_count > 0 then
		lo_root2 = lo_document2.getrootelement()
		if lo_root2.getchildelements(lo_rows) then
			ll_count = upperbound(lo_rows)
			for i = 1 to ll_count
				lo_rows[i].detach()
				lo_data.addcontent(lo_rows[i])
			next
		end if
	end if
	
	// Add the Component Interface Route data
	ls_sql = "select ir.* from dbo.fn_document_route_information('" + puo_document.dispatch_method + "') r LEFT OUTER JOIN c_component_interface_route ir  ON ir.subscriber_owner_id = r.owner_id AND ir.interfaceserviceid = r.send_via_addressee  AND ir.transportsequence = r.transportsequence"
	ll_count = luo_data.load_query(ls_sql, lo_document2, "Root", "ComponentInterfaceRoute")
	if ll_count < 0 then return -1
	if ll_count > 0 then
		lo_root2 = lo_document2.getrootelement()
		if lo_root2.getchildelements(lo_rows) then
			ll_count = upperbound(lo_rows)
			for i = 1 to ll_count
				lo_rows[i].detach()
				lo_data.addcontent(lo_rows[i])
			next
		end if
	end if
	
	// Add the Component Interface Route Properties data
	ls_sql = "select p.* from dbo.fn_document_route_information('" + puo_document.dispatch_method + "') r LEFT OUTER JOIN c_component_interface_route_property p   ON p.subscriber_owner_id = r.owner_id  AND p.interfaceserviceid = r.send_via_addressee  AND p.transportsequence = r.transportsequence"
	ll_count = luo_data.load_query(ls_sql, lo_document2, "ComponentInterfaceRouteProperties", "ComponentInterfaceRouteProperty")
	if ll_count < 0 then return -1
	if ll_count > 0 then
		lo_root2 = lo_document2.getrootelement()
		lo_root2.detach()
		lo_data.addcontent(lo_root2)
	end if
	
	lo_data2 = CREATE PBDOM_ELEMENT
	lo_data2.setname("Document")
	
	if len(lstr_document.filename) > 0 then
		lo_data3 = CREATE PBDOM_ELEMENT
		lo_data3.setname("filename")
		lo_data3.addcontent(lstr_document.filename)
		lo_data2.addcontent(lo_data3)
	end if

	if len(lstr_document.extension) > 0 then
		lo_data3 = CREATE PBDOM_ELEMENT
		lo_data3.setname("extension")
		lo_data3.addcontent(lstr_document.extension)
		lo_data2.addcontent(lo_data3)
	end if

	if len(lstr_document.attachment_comment_title) > 0 then
		lo_data3 = CREATE PBDOM_ELEMENT
		lo_data3.setname("description")
		lo_data3.addcontent(lstr_document.attachment_comment_title)
		lo_data2.addcontent(lo_data3)
	end if

	if len(lstr_document.attachment) > 0 then
		lo_data3 = CREATE PBDOM_ELEMENT
		lo_data3.setname("documentdata")
		lo_data3.addcontent(ls_encoded_data)
		lo_data3.setattribute("encoding", ls_document_encoding)
		lo_data2.addcontent(lo_data3)
	end if

	lo_data.addcontent(lo_data2)
	
	ps_componentdata_xml = lo_document.savedocumentintostring()
CATCH (PBDOM_EXCEPTION pbdom_except)
	log.log(this, "u_component_route_dotnet.add_document_to_componentdata:0165", "XML Error: " + string(pbdom_except.GetExceptionCode()) + "~r~nText : " + pbdom_except.Text, 4)
	return -1
CATCH (throwable lo_error)
	log.log(this, "u_component_route_dotnet.add_document_to_componentdata:0168", "XML Error: " + lo_error.Text, 4)
	return -1
end try

return 1


end function

protected function integer xx_initialize ();integer li_sts
str_attributes lstr_attributes


if debug_mode then
	log.log(this, "u_component_route_dotnet.xx_initialize:0006", "Debug Mode", 2)
end if

// Get the XML document for the component attributes
lstr_attributes = get_attributes()
//f_attribute_add_attribute(lstr_attributes, "patient_workplan_item_id", string(patient_workplan_item_id))

li_sts = initialize_dotnet_wrapper(lstr_attributes)

return li_sts



end function

on u_component_route_dotnet.create
call super::create
end on

on u_component_route_dotnet.destroy
call super::destroy
end on

