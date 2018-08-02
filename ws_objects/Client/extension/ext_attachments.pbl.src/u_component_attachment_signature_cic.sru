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

public function integer xx_render (string ps_file_type, ref string ps_file, integer pi_width, integer pi_height);blob			lbl_attachment
Integer		li_sts
oleobject luo_ImageControl
string ls_tempfile

w_render_cic_signature lw_window
str_popup popup

li_sts = get_attachment_blob(lbl_attachment)
If li_sts <= 0 Then Return -1

ls_tempfile = f_temp_file(".bmp")

popup.data_row_count = 4
popup.items[1] = f_blob_to_string(lbl_attachment)
popup.items[2] = ls_tempfile
popup.items[3] = string(pi_width)
popup.items[4] = string(pi_height)

openwithparm(lw_window, popup, "w_render_cic_signature")

if not fileexists(ls_tempfile) then
	log.log(this, "u_component_attachment_signature_cic.xx_render.0023", "Error creating signature image", 4)
	return -1
end if

luo_ImageControl = CREATE oleobject
li_sts = luo_ImageControl.connecttonewobject("EncounterPRO.OS.ImageManipulation")
if li_sts < 0 then
	log.log(this, "u_component_attachment_signature_cic.xx_render.0030", "Error creating EPImageControl object (" + string(li_sts) + ")", 3)
	ps_file = ls_tempfile
else
	ps_file = f_temp_file(".bmp")
	
	li_sts = luo_ImageControl.ConvertTo1bppBmp(ls_tempfile, ps_file)
	if li_sts <= 0 then
		log.log(this, "u_component_attachment_signature_cic.xx_render.0030", "Error reducing bitmap", 3)
		ps_file = ls_tempfile
	end if
	luo_ImageControl.disconnectobject()
end if

DESTROY luo_ImageControl

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

