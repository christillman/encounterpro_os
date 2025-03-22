$PBExportHeader$u_component_attachment_signature_cic.sru
forward
global type u_component_attachment_signature_cic from u_component_attachment
end type
end forward

global type u_component_attachment_signature_cic from u_component_attachment
end type
global u_component_attachment_signature_cic u_component_attachment_signature_cic

type variables

end variables

forward prototypes
public function integer xx_display ()
public function integer xx_render (string ps_file_type, ref string ps_file, integer pi_width, integer pi_height)
end prototypes

public function integer xx_display ();w_attachment_signature_cic_display lw_window

openwithparm(lw_window, this, "w_attachment_signature_cic_display")

return 1

end function

public function integer xx_render (string ps_file_type, ref string ps_file, integer pi_width, integer pi_height);blob		lbl_attachment
Integer		li_sts
string ls_tempfile

w_render_cic_signature lw_window
str_popup popup

li_sts = get_attachment_blob(lbl_attachment)
If li_sts <= 0 Then Return -1

ls_tempfile = f_temp_file(".bmp")
ps_file = ls_tempfile

popup.data_row_count = 4
popup.items[1] = f_blob_to_string(lbl_attachment)
popup.items[2] = ls_tempfile
popup.items[3] = string(pi_width)
popup.items[4] = string(pi_height)

openwithparm(lw_window, popup, "w_render_cic_signature")

if not fileexists(ls_tempfile) then
	log.log(this, "u_component_attachment_signature_cic.xx_render:0023", "Error creating signature image", 4)
	return -1
end if

If IsValid(common_thread.imageutils) THEN
	TRY
		ps_file = f_temp_file(".bmp")	
		common_thread.imageutils.of_convertto1bppbmp(ls_tempfile, ps_file)
	CATCH (throwable lo_error)
		log.log(this, "u_component_attachment_signature_cic.xx_render:0032", "Error reducing bitmap", 3)
		ps_file = ls_tempfile
		return -1
	END TRY
Else
	log.log(this, "u_component_attachment_signature_cic.xx_render:0035", "common_thread.imageutils not valid", 3)
	return -1
End If

// remove the extraneous temp file
if fileexists(ls_tempfile) and ls_tempfile <> ps_file then
	filedelete(ls_tempfile)
end if

Return 1
end function

on u_component_attachment_signature_cic.create
call super::create
end on

on u_component_attachment_signature_cic.destroy
call super::destroy
end on

