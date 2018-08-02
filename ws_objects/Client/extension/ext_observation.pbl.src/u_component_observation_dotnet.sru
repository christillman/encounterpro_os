$PBExportHeader$u_component_observation_dotnet.sru
forward
global type u_component_observation_dotnet from u_component_observation
end type
end forward

global type u_component_observation_dotnet from u_component_observation
end type
global u_component_observation_dotnet u_component_observation_dotnet

type variables
string xslt

w_ext_observation_com com_window

end variables

forward prototypes
protected function integer xx_do_source ()
protected function integer xx_initialize ()
protected function integer xx_set_processed (string ps_id, integer pi_status)
protected function integer xx_shutdown ()
end prototypes

protected function integer xx_do_source ();integer li_sts
string ls_results_xml
long ll_owner_id
string ls_new_xml
any la_rtn
boolean lb_connected

lb_connected = com_wrapper.is_connected()
set_connected_status(lb_connected)

if not connected then return 0

get_attribute("owner_id", ll_owner_id)

TRY
	la_rtn = com_wrapper.do_source()
	if classname(la_rtn) = "string" then
		ls_results_xml = string(la_rtn)
	else
		ls_results_xml = ""
	end if
CATCH (throwable lt_error)
	log.log(this, "u_component_observation_dotnet.xx_do_source.0023", "Error calling com source (" + lt_error.text + ")", 4)
	return -1
END TRY

if isnull(ls_results_xml) or ls_results_xml = "" then return 0

// If we need to transform the xml, do it here
if len(xslt) > 0 then
	ls_new_xml = common_thread.eprolibnet4.TransformXML(observations[observation_count].xml_results, xslt)
	if len(ls_new_xml) > 0 then
		ls_results_xml = ls_new_xml
	else
		log.log(this, "u_component_observation_dotnet.xx_do_source.0035", "Error transforming xml", 4)
	end if
end if

li_sts = read_data(ls_results_xml, "")
if li_sts < 0 then
	log.log(this, "u_component_observation_dotnet.xx_do_source.0035", "Error reading xml documents", 4)
	return -1
end if

Return 1

end function

protected function integer xx_initialize ();integer li_sts
str_patient_material lstr_material
long ll_material_id
string ls_com_id
string ls_context_xml
string ls_temp
blob lbl_temp
boolean lb_connected
str_attributes lstr_attributes

setnull(xslt)

if debug_mode then
	log.log(this, "u_component_observation_dotnet.xx_do_source.0023", "Debug Mode", 2)
end if

// Get the XML document for the component attributes
lstr_attributes = get_attributes()

li_sts = initialize_dotnet_wrapper(lstr_attributes)
if li_sts < 0 then
	log.log(this, "u_component_observation_dotnet.xx_initialize.0022", "Error initializing dotnet wrapper", 4)
	return -1
end if


get_attribute("xslt_material_id", ll_material_id)
lstr_material = f_get_patient_material(ll_material_id, true)
if isnull(lstr_material.material_id) then
	xslt = string(lstr_material.material_object)
end if

TRY
	li_sts = com_wrapper.initialize(ls_context_xml)
	if li_sts <= 0 then
		log.log(this, "u_component_observation_dotnet.xx_initialize.0022", "Error initializing com object (" + ls_com_id + ")", 4)
		return -1
	end if
	if debug_mode then
		log.log(this, "u_component_observation_dotnet.xx_initialize.0022", "initialize successful (" + ls_com_id + ")", 2)
	end if
	lb_connected = com_wrapper.is_connected()
	if debug_mode then
		log.log(this, "u_component_observation_dotnet.xx_initialize.0022", "is_connected successful (" + ls_com_id + ")", 2)
	end if
CATCH (throwable lt_error)
	log.log(this, "u_component_observation_dotnet.xx_initialize.0022", "Error calling com source (" + lt_error.text + ")", 4)
	return -1
END TRY


// Open the window to manage events
openwithparm(com_window, this, "w_ext_observation_com")

TRY
	// Set callback window handle to this window
	com_wrapper.SetCallbackWindow(handle(com_window))
CATCH (throwable lt_error2)
	log.log(this, "u_component_observation_dotnet.xx_initialize.0022", "Error setting callback window (" + lt_error2.text + ")", 4)
	return -1
END TRY

set_connected_status(lb_connected)

return 1

end function

protected function integer xx_set_processed (string ps_id, integer pi_status);integer li_sts


TRY
	li_sts = com_wrapper.set_processed(ps_id, pi_status)
CATCH (throwable lt_error)
	log.log(this, "u_component_observation_dotnet.xx_set_processed.0007", "Error calling com source (" + lt_error.text + ")", 4)
	return -1
END TRY

Return li_sts


end function

protected function integer xx_shutdown ();
TRY
	com_wrapper.disconnectobject( )
CATCH (throwable lt_error)
	log.log(this, "u_component_observation_dotnet.xx_do_source.0023", "Error disconnecting ConnectClass (" + lt_error.text + ")", 4)
	return -1
END TRY

DESTROY com_wrapper

if isvalid(com_window) then
	close(com_window)
end if


return 1

end function

on u_component_observation_dotnet.create
call super::create
end on

on u_component_observation_dotnet.destroy
call super::destroy
end on

