HA$PBExportHeader$u_component_observation_wlca_suresight.sru
forward
global type u_component_observation_wlca_suresight from u_component_observation
end type
end forward

global type u_component_observation_wlca_suresight from u_component_observation
end type
global u_component_observation_wlca_suresight u_component_observation_wlca_suresight

type variables
oleobject SSResults
oleobject SSWho
oleobject SSDisconnect
oleobject SSCalibrate

//    Set Calibrate = New SSCalibrate
//    Set CID = New SSCID
//    Set PID = New SSPID
//    Set Results = New SSResults
//    Set Test = New SSTest
//    Set Who = New SSWho
//    Set Disc = New SSDisconnect
//    Set PrintControl = New SSPrint

end variables

forward prototypes
protected function integer xx_shutdown ()
private function integer connect_device ()
protected function integer xx_initialize ()
protected function integer xx_do_source ()
end prototypes

protected function integer xx_shutdown ();
SSResults.disconnectobject()

DESTROY SSResults

return 1

end function

private function integer connect_device ();integer li_sts

li_sts = ssWho.sniff()
if li_sts <> 0 then
	set_connected_status(false)
	return -1
end if

set_connected_status(true)

return 1


end function

protected function integer xx_initialize ();integer li_sts
string ls_comport

connected = false

ls_comport = get_attribute("device comm port")

SSResults = CREATE oleobject
SSWho = CREATE oleobject
SSDisconnect = CREATE oleobject
SSCalibrate = CREATE oleobject

li_sts = ssresults.connecttonewobject("SSCOMServer.SSResults")
if li_sts < 0 then
	mylog.log(this, "xx_initialize()", "Error connecting to SSCOMServer.SSResults (" + string(li_sts) + ")", 4)
	return -1
end if

li_sts = SSWho.connecttonewobject("SSCOMServer.SSWho")
if li_sts < 0 then
	mylog.log(this, "xx_initialize()", "Error connecting to SSCOMServer.SSWho (" + string(li_sts) + ")", 4)
	return -1
end if

li_sts = SSDisconnect.connecttonewobject("SSCOMServer.SSDisconnect")
if li_sts < 0 then
	mylog.log(this, "xx_initialize()", "Error connecting to SSCOMServer.SSDisconnect (" + string(li_sts) + ")", 4)
	return -1
end if

li_sts = SSCalibrate.connecttonewobject("SSCOMServer.SSCalibrate")
if li_sts < 0 then
	mylog.log(this, "xx_initialize()", "Error connecting to SSCOMServer.SSCalibrate (" + string(li_sts) + ")", 4)
	return -1
end if

connect_device()
// If we didn't connect, tell the window
if not connected then this.event POST source_disconnected()

return 1

end function

protected function integer xx_do_source ();integer i, j
string ls_external_observation_id
string ls_observation_id
string ls_result_type
string ls_external_observation_result
integer li_result_sequence
string ls_location
string ls_result_date_time
string ls_result_value
string ls_result_unit
string ls_abnormal_flag
string ls_abnormal_nature
string ls_external_location
integer li_sts
str_external_observation_result lstr_collect

//li_sts = connect_device()
//if li_sts <= 0 then return -1
//
//li_sts = SSResults.results()
//if li_sts <> 0 then return -1
//
////Set Results = New SSResults
////    cmdRESULTS.Enabled = False
////    cmdDisconnect.Enabled = True
////    Screen.MousePointer = vbHourglass
////    ReturnMSG = Results.Results
////    If ReturnMSG = errOK Then
////        txtStatus.Text = STR_RESOK
////        'Assigns each text display to the approrpriate data from Results
////        txtCONl.Text = Results.CONl
////        txtCONr.Text = Results.CONr
////        txtCYLl.Text = Results.CYLl
////        txtCYLr.Text = Results.CYLr
////        txtSPHl.Text = Results.SPHl
////        txtSPHr.Text = Results.SPHr
////        txtDIF.Text = Results.DIF
////        txtCID.Text = Results.CID
////        txtPID.Text = Results.PID
////    ElseIf ReturnMSG = errTimeout Then
////        txtStatus.Text = STR_RESTIMEOUT
////        cmdDisconnect.Enabled = False
////    ElseIf ReturnMSG = errNACK Then
////        txtStatus.Text = STR_RESNACK
////    ElseIf ReturnMSG = errCheckSum Then
////        txtStatus.Text = STR_RESCHECKSUM
////    End If
////    cmdRESULTS.Enabled = True
////    Screen.MousePointer = vbNormal
//
//
//observation_count = 0
//
//// Get Sphere
//ls_external_observation_id = "Sphere"
//ls_observation_id = internal_observation_id(ls_external_observation_id)
//if not isnull(ls_observation_id) then
//	observation_count += 1
//	observations[observation_count].result_count = 0
//	observations[observation_count].observation_id = ls_observation_id
//
//	// Get Sphere-Left results
//	ls_external_observation_result = "Sphere"
//	ls_result_value = trim(SSResults.SPHl)
//	li_result_sequence = internal_result_sequence(ls_external_observation_id, ls_external_observation_result)
//	if not isnull(li_result_sequence) and not isnull(ls_result_value) and ls_result_value <> "" and ls_result_value <> "0" then
//		// Set Location
//		ls_external_location = "Left Eye"
//		ls_location = internal_location(ls_external_observation_id, ls_external_location)
//
//		// Set other properties
//		ls_result_unit = internal_result_unit(ls_external_observation_id, ls_external_observation_result)
//		setnull(ls_abnormal_flag)
//		setnull(ls_abnormal_nature)
//		
//		// Add result to observations structure
//		observations[observation_count].result_count += 1
//		observations[observation_count].result[observations[observation_count].result_count].observation_id = ls_observation_id
//		observations[observation_count].result[observations[observation_count].result_count].result_type = "PERFORM"
//		observations[observation_count].result[observations[observation_count].result_count].location = ls_location
//		observations[observation_count].result[observations[observation_count].result_count].result_sequence = li_result_sequence
//		observations[observation_count].result[observations[observation_count].result_count].result_date_time = datetime(today(), now())
//		observations[observation_count].result[observations[observation_count].result_count].result_value = ls_result_value
//		observations[observation_count].result[observations[observation_count].result_count].result_unit = ls_result_unit
//		observations[observation_count].result[observations[observation_count].result_count].abnormal_flag = ls_abnormal_flag
//		observations[observation_count].result[observations[observation_count].result_count].abnormal_nature = ls_abnormal_nature
//	end if
//
//	// Get Sphere-Right results
//	ls_external_observation_result = "Sphere"
//	ls_result_value = trim(SSResults.SPHr)
//	li_result_sequence = internal_result_sequence(ls_external_observation_id, ls_external_observation_result)
//	if not isnull(li_result_sequence) and not isnull(ls_result_value) and ls_result_value <> "" and ls_result_value <> "0" then
//		// Set Location
//		ls_external_location = "Right Eye"
//		ls_location = internal_location(ls_external_observation_id, ls_external_location)
//
//		// Set other properties
//		ls_result_unit = internal_result_unit(ls_external_observation_id, ls_external_observation_result)
//		setnull(ls_abnormal_flag)
//		setnull(ls_abnormal_nature)
//		
//		// Add result to observations structure
//		observations[observation_count].result_count += 1
//		observations[observation_count].result[observations[observation_count].result_count].observation_id = ls_observation_id
//		observations[observation_count].result[observations[observation_count].result_count].result_type = "PERFORM"
//		observations[observation_count].result[observations[observation_count].result_count].location = ls_location
//		observations[observation_count].result[observations[observation_count].result_count].result_sequence = li_result_sequence
//		observations[observation_count].result[observations[observation_count].result_count].result_date_time = datetime(today(), now())
//		observations[observation_count].result[observations[observation_count].result_count].result_value = ls_result_value
//		observations[observation_count].result[observations[observation_count].result_count].result_unit = ls_result_unit
//		observations[observation_count].result[observations[observation_count].result_count].abnormal_flag = ls_abnormal_flag
//		observations[observation_count].result[observations[observation_count].result_count].abnormal_nature = ls_abnormal_nature
//	end if
//end if
//
//
//// Get Cylinder
//ls_external_observation_id = "Cylinder"
//ls_observation_id = internal_observation_id(ls_external_observation_id)
//if not isnull(ls_observation_id) then
//	observation_count += 1
//	observations[observation_count].result_count = 0
//	observations[observation_count].observation_id = ls_observation_id
//
//	// Get Cylinder-Left results
//	ls_external_observation_result = "Cylinder"
//	ls_result_value = trim(SSResults.CYLl)
//	li_result_sequence = internal_result_sequence(ls_external_observation_id, ls_external_observation_result)
//	if not isnull(li_result_sequence) and not isnull(ls_result_value) and ls_result_value <> "" and ls_result_value <> "0" then
//		// Set Location
//		ls_external_location = "Left Eye"
//		ls_location = internal_location(ls_external_observation_id, ls_external_location)
//
//		// Set other properties
//		ls_result_unit = internal_result_unit(ls_external_observation_id, ls_external_observation_result)
//		setnull(ls_abnormal_flag)
//		setnull(ls_abnormal_nature)
//		
//		// Add result to observations structure
//		observations[observation_count].result_count += 1
//		observations[observation_count].result[observations[observation_count].result_count].observation_id = ls_observation_id
//		observations[observation_count].result[observations[observation_count].result_count].result_type = "PERFORM"
//		observations[observation_count].result[observations[observation_count].result_count].location = ls_location
//		observations[observation_count].result[observations[observation_count].result_count].result_sequence = li_result_sequence
//		observations[observation_count].result[observations[observation_count].result_count].result_date_time = datetime(today(), now())
//		observations[observation_count].result[observations[observation_count].result_count].result_value = ls_result_value
//		observations[observation_count].result[observations[observation_count].result_count].result_unit = ls_result_unit
//		observations[observation_count].result[observations[observation_count].result_count].abnormal_flag = ls_abnormal_flag
//		observations[observation_count].result[observations[observation_count].result_count].abnormal_nature = ls_abnormal_nature
//	end if
//
//	// Get Cylinder-Right results
//	ls_external_observation_result = "Cylinder"
//	ls_result_value = trim(SSResults.CYLr)
//	li_result_sequence = internal_result_sequence(ls_external_observation_id, ls_external_observation_result)
//	if not isnull(li_result_sequence) and not isnull(ls_result_value) and ls_result_value <> "" and ls_result_value <> "0" then
//		// Set Location
//		ls_external_location = "Right Eye"
//		ls_location = internal_location(ls_external_observation_id, ls_external_location)
//
//		// Set other properties
//		ls_result_unit = internal_result_unit(ls_external_observation_id, ls_external_observation_result)
//		setnull(ls_abnormal_flag)
//		setnull(ls_abnormal_nature)
//		
//		// Add result to observations structure
//		observations[observation_count].result_count += 1
//		observations[observation_count].result[observations[observation_count].result_count].observation_id = ls_observation_id
//		observations[observation_count].result[observations[observation_count].result_count].result_type = "PERFORM"
//		observations[observation_count].result[observations[observation_count].result_count].location = ls_location
//		observations[observation_count].result[observations[observation_count].result_count].result_sequence = li_result_sequence
//		observations[observation_count].result[observations[observation_count].result_count].result_date_time = datetime(today(), now())
//		observations[observation_count].result[observations[observation_count].result_count].result_value = ls_result_value
//		observations[observation_count].result[observations[observation_count].result_count].result_unit = ls_result_unit
//		observations[observation_count].result[observations[observation_count].result_count].abnormal_flag = ls_abnormal_flag
//		observations[observation_count].result[observations[observation_count].result_count].abnormal_nature = ls_abnormal_nature
//	end if
//end if
//
//
//// Get Confidence
//ls_external_observation_id = "Confidence"
//ls_observation_id = internal_observation_id(ls_external_observation_id)
//if not isnull(ls_observation_id) then
//	observation_count += 1
//	observations[observation_count].result_count = 0
//	observations[observation_count].observation_id = ls_observation_id
//
//	// Get Confidence-Left results
//	ls_external_observation_result = "Confidence"
//	ls_result_value = trim(SSResults.CONl)
//	li_result_sequence = internal_result_sequence(ls_external_observation_id, ls_external_observation_result)
//	if not isnull(li_result_sequence) and not isnull(ls_result_value) and ls_result_value <> "" and ls_result_value <> "0" then
//		// Set Location
//		ls_external_location = "Left Eye"
//		ls_location = internal_location(ls_external_observation_id, ls_external_location)
//
//		// Set other properties
//		ls_result_unit = internal_result_unit(ls_external_observation_id, ls_external_observation_result)
//		setnull(ls_abnormal_flag)
//		setnull(ls_abnormal_nature)
//		
//		// Add result to observations structure
//		observations[observation_count].result_count += 1
//		observations[observation_count].result[observations[observation_count].result_count].observation_id = ls_observation_id
//		observations[observation_count].result[observations[observation_count].result_count].result_type = "PERFORM"
//		observations[observation_count].result[observations[observation_count].result_count].location = ls_location
//		observations[observation_count].result[observations[observation_count].result_count].result_sequence = li_result_sequence
//		observations[observation_count].result[observations[observation_count].result_count].result_date_time = datetime(today(), now())
//		observations[observation_count].result[observations[observation_count].result_count].result_value = ls_result_value
//		observations[observation_count].result[observations[observation_count].result_count].result_unit = ls_result_unit
//		observations[observation_count].result[observations[observation_count].result_count].abnormal_flag = ls_abnormal_flag
//		observations[observation_count].result[observations[observation_count].result_count].abnormal_nature = ls_abnormal_nature
//	end if
//
//	// Get Sphere-Right results
//	ls_external_observation_result = "Confidence"
//	ls_result_value = trim(SSResults.CONr)
//	li_result_sequence = internal_result_sequence(ls_external_observation_id, ls_external_observation_result)
//	if not isnull(li_result_sequence) and not isnull(ls_result_value) and ls_result_value <> "" and ls_result_value <> "0" then
//		// Set Location
//		ls_external_location = "Right Eye"
//		ls_location = internal_location(ls_external_observation_id, ls_external_location)
//
//		// Set other properties
//		ls_result_unit = internal_result_unit(ls_external_observation_id, ls_external_observation_result)
//		setnull(ls_abnormal_flag)
//		setnull(ls_abnormal_nature)
//		
//		// Add result to observations structure
//		observations[observation_count].result_count += 1
//		observations[observation_count].result[observations[observation_count].result_count].observation_id = ls_observation_id
//		observations[observation_count].result[observations[observation_count].result_count].result_type = "PERFORM"
//		observations[observation_count].result[observations[observation_count].result_count].location = ls_location
//		observations[observation_count].result[observations[observation_count].result_count].result_sequence = li_result_sequence
//		observations[observation_count].result[observations[observation_count].result_count].result_date_time = datetime(today(), now())
//		observations[observation_count].result[observations[observation_count].result_count].result_value = ls_result_value
//		observations[observation_count].result[observations[observation_count].result_count].result_unit = ls_result_unit
//		observations[observation_count].result[observations[observation_count].result_count].abnormal_flag = ls_abnormal_flag
//		observations[observation_count].result[observations[observation_count].result_count].abnormal_nature = ls_abnormal_nature
//	end if
//end if
//
//// Get Difference
//ls_external_observation_id = "Difference"
//ls_observation_id = internal_observation_id(ls_external_observation_id)
//if not isnull(ls_observation_id) then
//	observation_count += 1
//	observations[observation_count].result_count = 0
//	observations[observation_count].observation_id = ls_observation_id
//
//	// Get Confidence-Left results
//	ls_external_observation_result = "Difference"
//	ls_result_value = trim(SSResults.DIF)
//	li_result_sequence = internal_result_sequence(ls_external_observation_id, ls_external_observation_result)
//	if not isnull(li_result_sequence) and not isnull(ls_result_value) and ls_result_value <> "" and ls_result_value <> "0" then
//		// Set Location
//		ls_location = "NA"
//
//		// Set other properties
//		ls_result_unit = internal_result_unit(ls_external_observation_id, ls_external_observation_result)
//		setnull(ls_abnormal_flag)
//		setnull(ls_abnormal_nature)
//		
//		// Add result to observations structure
//		observations[observation_count].result_count += 1
//		observations[observation_count].result[observations[observation_count].result_count].observation_id = ls_observation_id
//		observations[observation_count].result[observations[observation_count].result_count].result_type = "PERFORM"
//		observations[observation_count].result[observations[observation_count].result_count].location = ls_location
//		observations[observation_count].result[observations[observation_count].result_count].result_sequence = li_result_sequence
//		observations[observation_count].result[observations[observation_count].result_count].result_date_time = datetime(today(), now())
//		observations[observation_count].result[observations[observation_count].result_count].result_value = ls_result_value
//		observations[observation_count].result[observations[observation_count].result_count].result_unit = ls_result_unit
//		observations[observation_count].result[observations[observation_count].result_count].abnormal_flag = ls_abnormal_flag
//		observations[observation_count].result[observations[observation_count].result_count].abnormal_nature = ls_abnormal_nature
//	end if
//end if

return observation_count


end function

on u_component_observation_wlca_suresight.create
call super::create
end on

on u_component_observation_wlca_suresight.destroy
call super::destroy
end on

