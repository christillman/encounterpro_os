$PBExportHeader$u_component_attachment_isf.sru
forward
global type u_component_attachment_isf from u_component_attachment
end type
end forward

global type u_component_attachment_isf from u_component_attachment
string render_filetype = "gif"
end type
global u_component_attachment_isf u_component_attachment_isf

type variables

end variables

forward prototypes
public function integer xx_display ()
public function integer xx_render (string ps_file_type, ref string ps_file, integer pi_width, integer pi_height)
end prototypes

public function integer xx_display ();w_attachment_signature_isf_display lw_window

openwithparm(lw_window, this, "w_attachment_signature_isf_display")

return 1

end function

public function integer xx_render (string ps_file_type, ref string ps_file, integer pi_width, integer pi_height);Integer		li_sts
string ls_imagefile
oleobject luo_ImageControl
integer li_luminanceCutoff
string ls_error

w_render_isf_signature lw_window
str_popup popup

openwithparm(lw_window, this, "w_render_isf_signature")
ls_imagefile = message.stringparm
if not fileexists(ls_imagefile) then
	setnull(ps_file)
	return -1
end if


ps_file = ls_imagefile

Return 1


end function

on u_component_attachment_isf.create
call super::create
end on

on u_component_attachment_isf.destroy
call super::destroy
end on

