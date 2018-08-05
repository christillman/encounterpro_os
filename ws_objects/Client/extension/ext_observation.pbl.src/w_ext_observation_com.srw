$PBExportHeader$w_ext_observation_com.srw
forward
global type w_ext_observation_com from window
end type
end forward

global type w_ext_observation_com from window
boolean visible = false
integer width = 2533
integer height = 1408
boolean titlebar = true
string title = "Untitled"
long backcolor = 67108864
event source_event pbm_custom01
end type
global w_ext_observation_com w_ext_observation_com

type variables
u_component_observation_jmj_com external_source

string xslt

boolean debug_mode

end variables

event source_event;//
integer li_sts

CHOOSE CASE wparam
	CASE 1
		li_sts = external_source.do_source()
	CASE 2
		external_source.set_connected_status(true)
	CASE 3
		external_source.set_connected_status(false)
END CHOOSE


end event

event open;integer li_pole_timer

external_source = message.powerobjectparm

// Set up poling if needed
external_source.get_attribute("pole_timer", li_pole_timer)
if li_pole_timer > 0 then timer(li_pole_timer)


end event

on w_ext_observation_com.create
end on

on w_ext_observation_com.destroy
end on

event timer;boolean lb_connected
integer li_sts

// Make sure the component still exists
if isnull(external_source) or not isvalid(external_source) then
	close(this)
end if

// If we're poling for data, then call do_source

li_sts = external_source.do_source()
if li_sts <= 0 then
	// We didn't get anything so make sure we're still connected
	TRY
		lb_connected = external_source.com_source.is_connected()
	CATCH (throwable lt_error)
		log.log(this, "w_ext_observation_com:time", "Error calling com source (" + lt_error.text + ")", 4)
		return -1
	END TRY
	
	external_source.set_connected_status(lb_connected)
end if


end event

