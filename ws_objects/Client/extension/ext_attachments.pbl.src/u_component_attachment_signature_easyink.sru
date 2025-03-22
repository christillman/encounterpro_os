$PBExportHeader$u_component_attachment_signature_easyink.sru
forward
global type u_component_attachment_signature_easyink from u_component_attachment
end type
end forward

global type u_component_attachment_signature_easyink from u_component_attachment
end type
global u_component_attachment_signature_easyink u_component_attachment_signature_easyink

type variables

end variables

forward prototypes
public function integer xx_display ()
public function integer xx_render (string ps_file_type, ref string ps_file, integer pi_width, integer pi_height)
end prototypes

public function integer xx_display ();w_attachment_signature_easyink_display lw_window

openwithparm(lw_window, this, "w_attachment_signature_easyink_display")

return 1

end function

public function integer xx_render (string ps_file_type, ref string ps_file, integer pi_width, integer pi_height);Integer		li_sts
string ls_tempfile
oleobject luo_ImageControl
integer li_luminanceCutoff
string ls_error
blob lbl_attachment

w_render_easyink_signature lw_window
str_popup popup

ls_tempfile = f_temp_file(".bmp")

li_sts = get_attachment_blob(lbl_attachment)
If li_sts <= 0 Then Return -1

log.file_write(lbl_attachment, ls_tempfile)

//if cpr_mode = "CLIENT" then
//	li_sts = get_attachment_blob(lbl_attachment)
//	If li_sts <= 0 Then Return -1
//
//	main_window.ole_signature_easyink.object.imagedata = lbl_attachment
//	main_window.ole_signature_easyink.object.saveimage(ls_tempfile)
//else
//	popup.data_row_count = 3
//	popup.items[1] = ls_tempfile
//	popup.items[2] = string(pi_width)
//	popup.items[3] = string(pi_height)
//	popup.objectparm = this
//	
//	openwithparm(lw_window, popup, "w_render_easyink_signature")
//end if

if pi_width > 0 and pi_height > 0 then
	li_luminanceCutoff = integer(get_attribute("luminance_cutoff"))
	if isnull(li_luminanceCutoff) then li_luminanceCutoff = 245
	
	ps_file = f_resize_signature_bitmap(ls_tempfile, pi_width, pi_height, li_luminanceCutoff)
else
	log.log(this, "u_component_attachment_signature_easyink.xx_render:0038", "Width or height not positive", 3)
	return -1
end if

Return 1


end function

on u_component_attachment_signature_easyink.create
call super::create
end on

on u_component_attachment_signature_easyink.destroy
call super::destroy
end on

