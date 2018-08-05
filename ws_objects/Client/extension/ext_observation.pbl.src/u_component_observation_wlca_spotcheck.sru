$PBExportHeader$u_component_observation_wlca_spotcheck.sru
forward
global type u_component_observation_wlca_spotcheck from u_component_observation
end type
end forward

global type u_component_observation_wlca_spotcheck from u_component_observation
end type
global u_component_observation_wlca_spotcheck u_component_observation_wlca_spotcheck

type variables
w_ext_observation_wlca_spotcheck spotcheck_window

end variables

forward prototypes
protected function integer xx_shutdown ()
private function integer connect_device ()
protected function integer xx_initialize ()
protected function integer xx_do_source ()
end prototypes

protected function integer xx_shutdown ();integer li_sts

if isvalid(spotcheck_window) then
	spotcheck_window.ole_spotcheck.object.DisconnectDevice()
	close(spotcheck_window)
end if

return 1

end function

private function integer connect_device ();

if not isvalid(spotcheck_window) then
	mylog.log(this, "u_component_observation_wlca_spotcheck.connect_device:0004", "No valid window", 4)
	return -1
end if

return spotcheck_window.connect_device()

end function

protected function integer xx_initialize ();integer li_sts
string ls_comport

openwithparm(spotcheck_window, this)

ls_comport = get_attribute("device comm port")

spotcheck_window.connect_device(ls_comport)

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

li_sts = connect_device()
if li_sts <= 0 then return -1

observation_count = 0

//// Get blood pressure
//ls_external_observation_id = "Blood Pressure"
//ls_observation_id = internal_observation_id(ls_external_observation_id)
//if not isnull(ls_observation_id) then
//	observation_count += 1
//	observations[observation_count].result_count = 0
//	observations[observation_count].observation_id = ls_observation_id
//
//	// Get collection
//	setnull(lstr_collect.observation_id)
//	ls_external_observation_result = "Body Position"
//	li_result_sequence = internal_result_sequence(ls_external_observation_id, ls_external_observation_result)
//	if not isnull(li_result_sequence) then
//		// Determine location
//		if spotcheck_window.ole_spotcheck.object.BPSitting then
//			ls_external_location = "Sitting"
//		elseif spotcheck_window.ole_spotcheck.object.BPStanding then
//			ls_external_location = "Standing"
//		elseif spotcheck_window.ole_spotcheck.object.BPSupine then
//			ls_external_location = "Supine"
//		end if
//		ls_location = internal_location(ls_external_observation_id, ls_external_location)
//
//		// Set other porperties
//		setnull(ls_result_value)
//		setnull(ls_result_unit)
//		setnull(ls_abnormal_flag)
//		setnull(ls_abnormal_nature)
//		
//		// Add result to observations structure
//		lstr_collect.observation_id = ls_observation_id
//		lstr_collect.result_type = "COLLECT"
//		lstr_collect.location = ls_location
//		lstr_collect.result_sequence = li_result_sequence
//		lstr_collect.result_date_time = datetime(today(), now())
//		lstr_collect.result_value = ls_result_value
//		lstr_collect.result_unit = ls_result_unit
//		lstr_collect.abnormal_flag = ls_abnormal_flag
//		lstr_collect.abnormal_nature = ls_abnormal_nature
//	end if
//
//	// Get systolic
//	ls_external_observation_result = "Systolic"
//	ls_result_value = trim(spotcheck_window.ole_spotcheck.object.systolic)
//	li_result_sequence = internal_result_sequence(ls_external_observation_id, ls_external_observation_result)
//	if not isnull(li_result_sequence) and not isnull(ls_result_value) and ls_result_value <> "" and ls_result_value <> "0" then
//		// Determine location
//		if spotcheck_window.ole_spotcheck.object.BPLeftArm then
//			ls_external_location = "Left Arm"
//		elseif spotcheck_window.ole_spotcheck.object.BPRightArm then
//			ls_external_location = "Right Arm"
//		end if
//		ls_location = internal_location(ls_external_observation_id, ls_external_location)
//
//		// Set other porperties
//		ls_result_unit = internal_result_unit(ls_external_observation_id, ls_external_observation_result)
//		setnull(ls_abnormal_flag)
//		setnull(ls_abnormal_nature)
//		
//		// Add the collection result
//		if not isnull(lstr_collect.observation_id) then
//			observations[observation_count].result_count += 1
//			observations[observation_count].result[observations[observation_count].result_count] = lstr_collect
//			setnull(lstr_collect.observation_id)
//		end if
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
//	// Get diastolic
//	ls_external_observation_result = "Diastolic"
//	ls_result_value = trim(spotcheck_window.ole_spotcheck.object.diastolic)
//	li_result_sequence = internal_result_sequence(ls_external_observation_id, ls_external_observation_result)
//	if not isnull(li_result_sequence) and not isnull(ls_result_value) and ls_result_value <> "" and ls_result_value <> "0" then
//		// Determine location
//		if spotcheck_window.ole_spotcheck.object.BPLeftArm then
//			ls_external_location = "Left Arm"
//		elseif spotcheck_window.ole_spotcheck.object.BPRightArm then
//			ls_external_location = "Right Arm"
//		end if
//		ls_location = internal_location(ls_external_observation_id, ls_external_location)
//
//		// Set other porperties
//		ls_result_unit = internal_result_unit(ls_external_observation_id, ls_external_observation_result)
//		setnull(ls_abnormal_flag)
//		setnull(ls_abnormal_nature)
//		
//		// Add the collection result
//		if not isnull(lstr_collect.observation_id) then
//			observations[observation_count].result_count += 1
//			observations[observation_count].result[observations[observation_count].result_count] = lstr_collect
//			setnull(lstr_collect.observation_id)
//		end if
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
//// Get Heart Rate
//ls_external_observation_id = "Heart Rate"
//ls_observation_id = internal_observation_id(ls_external_observation_id)
//if not isnull(ls_observation_id) then
//	observation_count += 1
//	observations[observation_count].result_count = 0
//	observations[observation_count].observation_id = ls_observation_id
//
//	// Get BP Heart Rate
//	ls_external_observation_result = "BP Heart Rate"
//	ls_result_value = trim(spotcheck_window.ole_spotcheck.object.bphr)
//	li_result_sequence = internal_result_sequence(ls_external_observation_id, ls_external_observation_result)
//	if not isnull(li_result_sequence) and not isnull(ls_result_value) and ls_result_value <> "" and ls_result_value <> "0" then
//		ls_location = "NA"
//
//		// Set other porperties
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
//	// Get PulseOx Heart Rate
//	ls_external_observation_result = "Pulse Oximetry Heart Rate"
//	ls_result_value = trim(spotcheck_window.ole_spotcheck.object.spo2hr)
//	li_result_sequence = internal_result_sequence(ls_external_observation_id, ls_external_observation_result)
//	if not isnull(li_result_sequence) and not isnull(ls_result_value) and ls_result_value <> "" and ls_result_value <> "0" then
//		ls_location = "NA"
//
//		// Set other porperties
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
//// Get Temp
//ls_external_observation_id = "Temperature"
//ls_observation_id = internal_observation_id(ls_external_observation_id)
//if not isnull(ls_observation_id) then
//	observation_count += 1
//	observations[observation_count].result_count = 0
//	observations[observation_count].observation_id = ls_observation_id
//
//	// Get collection
//	setnull(lstr_collect.observation_id)
//	ls_external_observation_result = "Temperature Method"
//	li_result_sequence = internal_result_sequence(ls_external_observation_id, ls_external_observation_result)
//	if not isnull(li_result_sequence) then
//		// MSC for now, hard code "Oral" as the collection location until we get more
//		// information from Welch Allyn about how to read the probe type
//		ls_external_location = "Oral"
//		ls_location = internal_location(ls_external_observation_id, ls_external_location)
//
//		// Set other porperties
//		setnull(ls_result_value)
//		setnull(ls_result_unit)
//		setnull(ls_abnormal_flag)
//		setnull(ls_abnormal_nature)
//		
//		// Add result to observations structure
//		lstr_collect.observation_id = ls_observation_id
//		lstr_collect.result_type = "COLLECT"
//		lstr_collect.location = ls_location
//		lstr_collect.result_sequence = li_result_sequence
//		lstr_collect.result_date_time = datetime(today(), now())
//		lstr_collect.result_value = ls_result_value
//		lstr_collect.result_unit = ls_result_unit
//		lstr_collect.abnormal_flag = ls_abnormal_flag
//		lstr_collect.abnormal_nature = ls_abnormal_nature
//	end if
//
//	// Get celcius temp
//	ls_external_observation_result = "Temperature (Celcius)"
//	ls_result_value = trim(spotcheck_window.ole_spotcheck.object.tempc)
//	li_result_sequence = internal_result_sequence(ls_external_observation_id, ls_external_observation_result)
//	if not isnull(li_result_sequence) and not isnull(ls_result_value) and ls_result_value <> "" and ls_result_value <> "0" then
//		ls_location = "NA"
//
//		// Set other porperties
//		ls_result_unit = internal_result_unit(ls_external_observation_id, ls_external_observation_result)
//		setnull(ls_abnormal_flag)
//		setnull(ls_abnormal_nature)
//		
//		// Add the collection result
//		if not isnull(lstr_collect.observation_id) then
//			observations[observation_count].result_count += 1
//			observations[observation_count].result[observations[observation_count].result_count] = lstr_collect
//			setnull(lstr_collect.observation_id)
//		end if
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
//	// Get Fahrenheit Temp
//	ls_external_observation_result = "Temperature (Fahrenheit)"
//	ls_result_value = trim(spotcheck_window.ole_spotcheck.object.tempf)
//	li_result_sequence = internal_result_sequence(ls_external_observation_id, ls_external_observation_result)
//	if not isnull(li_result_sequence) and not isnull(ls_result_value) and ls_result_value <> "" and ls_result_value <> "0" then
//		ls_location = "NA"
//
//		// Set other porperties
//		ls_result_unit = internal_result_unit(ls_external_observation_id, ls_external_observation_result)
//		setnull(ls_abnormal_flag)
//		setnull(ls_abnormal_nature)
//		
//		// Add the collection result
//		if not isnull(lstr_collect.observation_id) then
//			observations[observation_count].result_count += 1
//			observations[observation_count].result[observations[observation_count].result_count] = lstr_collect
//			setnull(lstr_collect.observation_id)
//		end if
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
//// Get SpO2
//ls_external_observation_id = "Pulse Oximetry"
//ls_observation_id = internal_observation_id(ls_external_observation_id)
//if not isnull(ls_observation_id) then
//	observation_count += 1
//	observations[observation_count].result_count = 0
//	observations[observation_count].observation_id = ls_observation_id
//
//	// Get systolic
//	ls_external_observation_result = "Pulse Oximetry"
//	ls_result_value = trim(spotcheck_window.ole_spotcheck.object.spo2)
//	li_result_sequence = internal_result_sequence(ls_external_observation_id, ls_external_observation_result)
//	if not isnull(li_result_sequence) and not isnull(ls_result_value) and ls_result_value <> "" and ls_result_value <> "0" then
//		ls_location = "NA"
//
//		// Set other porperties
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

on u_component_observation_wlca_spotcheck.create
call super::create
end on

on u_component_observation_wlca_spotcheck.destroy
call super::destroy
end on

