$PBExportHeader$u_component_route_file.sru
forward
global type u_component_route_file from u_component_route
end type
end forward

global type u_component_route_file from u_component_route
end type
global u_component_route_file u_component_route_file

forward prototypes
protected function integer xx_send_document (u_component_wp_item_document puo_document)
end prototypes

protected function integer xx_send_document (u_component_wp_item_document puo_document);long ll_addressee
string ls_document_type
integer li_sts
str_external_observation_attachment lstr_document
u_ds_data luo_data
long ll_attribute_count
long ll_transportsequence
str_attributes lstr_attributes
string ls_temp
long ll_attachment_location_id
string ls_send_to_directory
str_attachment_location lstr_attachment_location
string ls_save_path
string ls_save_file
string ls_filename_prefix
long i

// Get information about this route
SELECT send_via_addressee, document_type, transportsequence
INTO :ll_addressee, :ls_document_type, :ll_transportsequence
FROM dbo.fn_document_route_information(:puo_document.dispatch_method);
if not tf_check() then return -1
if sqlca.sqlnrows <> 1 then
	log.log(this, "u_component_route_file.xx_send_document:0024", "Invalid dispatch_method (" + puo_document.dispatch_method + ")", 4)
	return -1
end if


if isnull(ll_addressee) then
	log.log(this, "u_component_route_file.xx_send_document:0030", puo_document.dispatch_method + " dispatch_method does not have a valid send-to-addressee", 4)
	return -1
end if

li_sts = puo_document.get_document(lstr_document)
if li_sts <= 0 then
	log.log(this, "u_component_route_file.xx_send_document:0036", "Error sending document (" + string(puo_document.patient_workplan_item_id) + ")", 4)
	return -1
end if

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_practice_interface_transport_properties")
ll_attribute_count = luo_data.retrieve(sqlca.customer_id, ll_addressee, ll_transportsequence)
f_attribute_ds_to_str(luo_data, lstr_attributes)
DESTROY luo_data

ls_temp = f_attribute_find_attribute(lstr_attributes, "attachment_location_id")
if isnull(ls_temp) then
	log.log(this, "u_component_route_file.xx_send_document:0048", puo_document.dispatch_method + " dispatch_method is not properly configured - missing attachment_location_id", 4)
	return -1
end if
ll_attachment_location_id = long(ls_temp)
ls_send_to_directory = f_attribute_find_attribute(lstr_attributes, "send_to_directory")
if isnull(ls_send_to_directory) then
	log.log(this, "u_component_route_file.xx_send_document:0054", puo_document.dispatch_method + " dispatch_method is not properly configured - missing directory", 4)
	return -1
end if

lstr_attachment_location = datalist.get_attachment_location(ll_attachment_location_id)
if isnull(lstr_attachment_location.attachment_location_id) then
	log.log(this, "u_component_route_file.xx_send_document:0060", puo_document.dispatch_method + " dispatch_method is not properly configured - invalid attachment location", 4)
	return -1
end if

ls_save_path = "\\" + lstr_attachment_location.attachment_server + "\" + lstr_attachment_location.attachment_share

ls_send_to_directory = f_string_substitute(ls_send_to_directory, "/", "\")

if left(ls_send_to_directory, 1) = "\" then
	ls_save_path += ls_send_to_directory
else
	ls_save_path += "\" + ls_send_to_directory
end if

if right(ls_save_path, 1) <> "\" then ls_save_path += "\"

// Determine the filename
ls_filename_prefix = f_attribute_find_attribute(lstr_attributes, "filename_prefix")
if len(ls_filename_prefix) > 0 then
	ls_save_path += ls_filename_prefix + "_"
end if

ls_save_path += right("000000000000" + string(puo_document.patient_workplan_item_id), 12)
ls_save_file += "." + lstr_document.extension

// Make sure the file is unique
i = 0
DO WHILE fileexists(ls_save_file)
	i += 1
	if i >= 1000 then
		log.log(this, "u_component_route_file.xx_send_document:0090", "Unable to determine file path that does not already exist (" + ls_save_file + ")", 4)
		return -1
	end if
	ls_save_file = ls_save_path + "_" + string(i) + "." + lstr_document.extension
LOOP


li_sts = log.file_write(lstr_document.attachment, ls_save_file)
if li_sts < 0 then
	log.log(this, "u_component_route_file.xx_send_document:0099", puo_document.dispatch_method + "Error saving document (" + ls_save_file + ")", 4)
	return -1
end if

return 1


end function

on u_component_route_file.create
call super::create
end on

on u_component_route_file.destroy
call super::destroy
end on

