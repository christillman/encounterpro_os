$PBExportHeader$u_component_attachment_activex.sru
forward
global type u_component_attachment_activex from u_component_attachment
end type
end forward

global type u_component_attachment_activex from u_component_attachment
end type
global u_component_attachment_activex u_component_attachment_activex

forward prototypes
public function integer xx_display ()
public function integer xx_edit ()
end prototypes

public function integer xx_display ();w_attachment_activex_display lw_window

openwithparm(lw_window, this, "w_attachment_activex_display")

return 1

end function

public function integer xx_edit ();w_attachment_activex_display lw_window

openwithparm(lw_window, this, "w_attachment_activex_display")

return 1

end function

on u_component_attachment_activex.create
call super::create
end on

on u_component_attachment_activex.destroy
call super::destroy
end on

