$PBExportHeader$u_component_epie_download.sru
forward
global type u_component_epie_download from u_component_epie_base
end type
end forward

global type u_component_epie_download from u_component_epie_base
end type
global u_component_epie_download u_component_epie_download

type variables
SoapConnection conn // Define SoapConnection
EpieGateway_service EpIE_Gateway // Declare proxy
epiegateway_credentialsheader credentials
end variables

forward prototypes
protected function integer xx_do_source ()
protected function integer xx_initialize ()
protected function integer xx_set_processed (string ps_id, integer pi_status)
protected function integer xx_shutdown ()
end prototypes

protected function integer xx_do_source ();integer li_sts
long ll_owner_id
any la_rtn
long rVal, lLog
real amount
string ls_templog
string ls_customer_id
string ls_results_xml

set_connected_status(true)

get_attribute("owner_id", ll_owner_id)

ls_customer_id = string(sqlca.customer_id)

// Create proxy object
TRY
	la_rtn = EpIE_Gateway.getmessagebag(ls_customer_id, "XML.JMJ")
	if classname(la_rtn) = "string" then
		ls_results_xml = string(la_rtn)
	else
		ls_results_xml = ""
	end if
CATCH ( SoapException lt_error )
	log.log(this, "u_component_epie_download.xx_do_source:0025", "Error calling EpIE download gateway (" + lt_error.text + ")", 4)
	return -1
END TRY


if isnull(ls_results_xml) or ls_results_xml = "" then return 0


li_sts = read_data(ls_results_xml, "")
if li_sts < 0 then
	log.log(this, "u_component_epie_download.xx_do_source:0035", "Error reading xml documents", 4)
	return -1
end if

Return 1

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

set_connected_status(true)

conn = create SoapConnection  //Instantiated connection

ls_usr = datalist.get_preference( "SYSTEM", "epie_user")
ls_pwd = datalist.get_preference( "SYSTEM", "epie_pwd")

ll_sts = conn.SetSoapLogFile (ls_templog) 

rVal = Conn.CreateInstance(EpIE_Gateway, "EpieGateway_service")
if rVal <> 0 then
	log.log(this, "u_component_epie_download.xx_initialize:0022", "Creating SOAP proxy failed (" + string(rVal) + ")", 4)
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

protected function integer xx_set_processed (string ps_id, integer pi_status);integer li_sts


TRY
	EpIE_Gateway.complete(ps_id, pi_status)
CATCH ( SoapException lt_error )
	log.log(this, "u_component_epie_download.xx_set_processed:0007", "Error calling gateway complete (" + lt_error.text + ")", 4)
	return -1
END TRY

Return li_sts


end function

protected function integer xx_shutdown ();DESTROY conn
DESTROY credentials

return 1

end function

on u_component_epie_download.create
call super::create
end on

on u_component_epie_download.destroy
call super::destroy
end on

