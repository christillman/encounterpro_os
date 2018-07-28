HA$PBExportHeader$u_component_observation_brentwood_ecg.sru
forward
global type u_component_observation_brentwood_ecg from u_component_observation
end type
end forward

global type u_component_observation_brentwood_ecg from u_component_observation
end type
global u_component_observation_brentwood_ecg u_component_observation_brentwood_ecg

type variables
w_ext_observation_brentwood_ecg ecg_window

end variables

forward prototypes
protected function integer xx_shutdown ()
protected function integer xx_initialize ()
protected function integer xx_do_source ()
end prototypes

protected function integer xx_shutdown ();integer li_sts

if isvalid(ecg_window) then
	close(ecg_window)
end if

return 1

end function

protected function integer xx_initialize ();set_connected_status(true)
return 1

end function

protected function integer xx_do_source ();
observation_count = 0

openwithparm(ecg_window, this, "w_ext_observation_brentwood_ecg")

if not isnull(display_window) and isvalid(display_window) then
	display_window.event post results_posted(this)
end if

return observation_count



end function

on u_component_observation_brentwood_ecg.create
call super::create
end on

on u_component_observation_brentwood_ecg.destroy
call super::destroy
end on

