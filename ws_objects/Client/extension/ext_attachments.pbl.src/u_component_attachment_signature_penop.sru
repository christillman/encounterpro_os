$PBExportHeader$u_component_attachment_signature_penop.sru
forward
global type u_component_attachment_signature_penop from u_component_attachment
end type
end forward

global type u_component_attachment_signature_penop from u_component_attachment
end type
global u_component_attachment_signature_penop u_component_attachment_signature_penop

forward prototypes
public function integer xx_display ()
public function integer xx_render (string ps_file_type, ref string ps_file, integer pi_width, integer pi_height)
end prototypes

public function integer xx_display ();w_attachment_signature_penop_display lw_window

//openwithparm(lw_window, this, "w_attachment_signature_penop_display")

return 1

end function

public function integer xx_render (string ps_file_type, ref string ps_file, integer pi_width, integer pi_height);String		ls_filename
Integer		li_sts,li_resx,li_resy

ls_filename = get_attachment()
ps_file = f_temp_file(".bmp")
if fileexists(ps_file) then filedelete(ps_file)

li_resx = 600
li_resy = 600

if common_thread.utilities_ok() then
	li_sts = common_thread.mm.render_bmp(ls_filename, ps_file, li_resx, li_resy)
	If li_sts <= 0 Then
		log.log(this, "u_component_attachment_signature_penop.xx_render:0014", "Unable to render signature", 3)
	End If
else
	log.log(this, "u_component_attachment_signature_penop.xx_render:0017", "Unable to render signature (Utilities not available)", 3)
end if

filedelete(ls_filename)

Return 1

end function

on u_component_attachment_signature_penop.create
call super::create
end on

on u_component_attachment_signature_penop.destroy
call super::destroy
end on

