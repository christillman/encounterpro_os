HA$PBExportHeader$u_component_attachment_psreport.sru
forward
global type u_component_attachment_psreport from u_component_attachment
end type
end forward

global type u_component_attachment_psreport from u_component_attachment
end type
global u_component_attachment_psreport u_component_attachment_psreport

forward prototypes
public function integer xx_display ()
public function integer xx_render (string ps_file_type, ref string ps_file, integer pi_width, integer pi_height)
public function integer xx_print ()
end prototypes

public function integer xx_display ();w_attachment_psreport_display lw_window

openwithparm(lw_window, this, "w_attachment_psreport_display")
lw_window.visible = true

return 1

end function

public function integer xx_render (string ps_file_type, ref string ps_file, integer pi_width, integer pi_height);w_attachment_psreport_display lw_window
string ls_temp_file
integer li_sts

openwithparm(lw_window, this, "w_attachment_psreport_display")
TRY
	li_sts = lw_window.render(ls_temp_file)
	if li_sts > 0 then
		ps_file = ls_temp_file
	end if
CATCH (throwable lt_error)
	log.log(this, "xx_render()", "Error calling render (" + lt_error.text + ")", 4)
	li_sts = -1
END TRY

close(lw_window)

return li_sts


end function

public function integer xx_print ();w_attachment_psreport_display lw_window
integer li_sts

openwithparm(lw_window, this, "w_attachment_psreport_display")
TRY
	li_sts = lw_window.print_datawindow()
CATCH (throwable lt_error)
	log.log(this, "xx_print()", "Error calling print_datawindow (" + lt_error.text + ")", 4)
	li_sts = -1
END TRY

close(lw_window)

return li_sts


end function

on u_component_attachment_psreport.create
call super::create
end on

on u_component_attachment_psreport.destroy
call super::destroy
end on

