HA$PBExportHeader$u_component_attachment_browser.sru
forward
global type u_component_attachment_browser from u_component_attachment
end type
end forward

global type u_component_attachment_browser from u_component_attachment
end type
global u_component_attachment_browser u_component_attachment_browser

forward prototypes
public function integer xx_display ()
public function integer xx_edit ()
end prototypes

public function integer xx_display ();w_attachment_browser_display lw_window

openwithparm(lw_window, this, "w_attachment_browser_display")

return 1

end function

public function integer xx_edit ();w_attachment_browser_display lw_window

openwithparm(lw_window, this, "w_attachment_browser_display")

return 1

end function

on u_component_attachment_browser.create
call super::create
end on

on u_component_attachment_browser.destroy
call super::destroy
end on

