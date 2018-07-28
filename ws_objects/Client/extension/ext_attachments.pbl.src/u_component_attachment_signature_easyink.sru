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
//	w_main.ole_signature_easyink.object.imagedata = lbl_attachment
//	w_main.ole_signature_easyink.object.saveimage(ls_tempfile)
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
	luo_ImageControl = CREATE oleobject
	li_sts = luo_ImageControl.connecttonewobject("EncounterPRO.OS.ImageManipulation")
	if li_sts < 0 then
		log.log(this, "xx_render()", "Error creating EPImageControl object (" + string(li_sts) + ")", 3)
		ps_file = ls_tempfile
	else
		li_luminanceCutoff = integer(get_attribute("luminance_cutoff"))
		if isnull(li_luminanceCutoff) then li_luminanceCutoff = 245
		
		ps_file = f_temp_file(".bmp")
		
		TRY
			li_sts = luo_ImageControl.ResizeDarkenBitmap(ls_tempfile, ps_file, pi_width, pi_height, li_luminanceCutoff)
			if li_sts <= 0 then
				log.log(this, "xx_render()", "Error reducing bitmap (" + string(li_sts) + ")", 3)
				ps_file = ls_tempfile
			end if
		CATCH (throwable lo_error)
			log.log(this, "xx_render()", "Error calling ResizeDarkenBitmap (" + lo_error.text + ")", 3)
			ps_file = ls_tempfile
		FINALLY
			luo_ImageControl.disconnectobject()
		END TRY
		
	end if
	
	DESTROY luo_ImageControl
	
	// remove the extraneous temp file
	if fileexists(ls_tempfile) and ls_tempfile <> ps_file then
		filedelete(ls_tempfile)
	end if
else
	ps_file = ls_tempfile
end if


Return 1


end function

on u_component_attachment_signature_easyink.create
call super::create
end on

on u_component_attachment_signature_easyink.destroy
call super::destroy
end on

