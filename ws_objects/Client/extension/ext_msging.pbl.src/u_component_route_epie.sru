$PBExportHeader$u_component_route_epie.sru
forward
global type u_component_route_epie from u_component_route
end type
end forward

global type u_component_route_epie from u_component_route
end type
global u_component_route_epie u_component_route_epie

type variables
SoapConnection conn // Define SoapConnection
EpieGateway_service EpIE_Gateway // Declare proxy
epiegateway_credentialsheader credentials


end variables

forward prototypes
protected function integer xx_send_document (u_component_wp_item_document puo_document)
protected function integer xx_initialize ()
end prototypes

protected function integer xx_send_document (u_component_wp_item_document puo_document);long ll_addressee
string ls_route_document_type
string ls_document_type
integer li_sts
str_external_observation_attachment lstr_document
string ls_test_message_flag
str_patient lstr_patient

// Get information about this route
SELECT send_via_addressee, document_type
INTO :ll_addressee, :ls_route_document_type
FROM dbo.fn_document_route_information(:puo_document.dispatch_method);
if not tf_check() then return -1
if sqlca.sqlnrows <> 1 then
	log.log(this, "u_component_route_epie.xx_send_document:0015", "Invalid dispatch_method (" + puo_document.dispatch_method + ")", 4)
	return -1
end if

 ls_document_type = puo_document.get_attribute("document_type")
 if isnull(ls_document_type) then
	ls_document_type = ls_route_document_type
end if

if isnull(ll_addressee) then
	log.log(this, "u_component_route_epie.xx_send_document:0025", puo_document.dispatch_method + " dispatch_method does not have a valid send-to-addressee", 4)
	return -1
end if

if isnull(ls_document_type) then
	log.log(this, "u_component_route_epie.xx_send_document:0030", puo_document.dispatch_method + " dispatch_method does not have a valid document type", 4)
	return -1
end if

li_sts = puo_document.get_document(lstr_document)
if li_sts <= 0 then
	log.log(this, "u_component_route_epie.xx_send_document:0036", "Error sending document (" + string(puo_document.patient_workplan_item_id) + ")", 4)
	return -1
end if

ls_test_message_flag = puo_document.get_attribute("test_message_flag")
if isnull(ls_test_message_flag) then
	if isnull(puo_document.cpr_id) then
		ls_test_message_flag = "N"
	else
		li_sts = f_get_patient(puo_document.cpr_id, lstr_patient)
		if li_sts <= 0 then
			ls_test_message_flag = "N"
		elseif lstr_patient.test_patient then
			ls_test_message_flag = "Y"
		else
			ls_test_message_flag = "N"
		end if
	end if
end if

if f_file_is_text(lstr_document.extension) then
	li_sts = f_send_document(ls_document_type, ll_addressee, "XML", f_blob_to_string(lstr_document.attachment), puo_document.id, puo_document.ordered_by, puo_document.ordered_for, f_string_to_boolean(ls_test_message_flag))
else
	li_sts = f_send_document_blob(ls_document_type, ll_addressee, lstr_document.attachment, puo_document.id, puo_document.ordered_by, puo_document.ordered_for, f_string_to_boolean(ls_test_message_flag))
end if
if li_sts <= 0 then return -1

return 1

end function

protected function integer xx_initialize ();integer li_sts
long ll_sts
long rVal
real amount
string ls_templog
string ls_usr
string ls_pwd
string ls_options
string ls_ipaddr

conn = create SoapConnection  //Instantiated connection

ls_usr = datalist.get_preference( "SYSTEM", "epie_user")
ls_pwd = datalist.get_preference( "SYSTEM", "epie_pwd")

ll_sts = conn.SetSoapLogFile (ls_templog) 

rVal = Conn.CreateInstance(EpIE_Gateway, "EpieGateway_service")
if rVal <> 0 then
	log.log(this, "u_component_route_epie.xx_initialize:0020", "Creating SOAP proxy failed (" + string(rVal) + ")", 4)
	destroy conn
	return -1
end if

credentials = CREATE epiegateway_credentialsheader
credentials.user = ls_usr
credentials.password = ls_pwd
setnull(credentials.actor)
setnull(credentials.encodedmustunderstand)
setnull(credentials.encodedmustunderstand12)
setnull(credentials.encodedrelay)
setnull(credentials.role)

EpIE_Gateway.setcredentialsheadervalue(credentials)


Return 1

end function

on u_component_route_epie.create
call super::create
end on

on u_component_route_epie.destroy
call super::destroy
end on

