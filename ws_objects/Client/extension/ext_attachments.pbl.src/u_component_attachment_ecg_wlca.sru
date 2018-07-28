$PBExportHeader$u_component_attachment_ecg_wlca.sru
forward
global type u_component_attachment_ecg_wlca from u_component_attachment
end type
end forward

global type u_component_attachment_ecg_wlca from u_component_attachment
end type
global u_component_attachment_ecg_wlca u_component_attachment_ecg_wlca

forward prototypes
public function integer xx_display ()
protected function boolean xx_is_transcribeable ()
protected function boolean xx_is_editable ()
end prototypes

public function integer xx_display ();w_attachment_wa_ecg_display lw_window

openwithparm(lw_window, this, "w_attachment_wa_ecg_display")

return 1

end function

protected function boolean xx_is_transcribeable ();return false

end function

protected function boolean xx_is_editable ();return false

end function

on u_component_attachment_ecg_wlca.create
call super::create
end on

on u_component_attachment_ecg_wlca.destroy
call super::destroy
end on

