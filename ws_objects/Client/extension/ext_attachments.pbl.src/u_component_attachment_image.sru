$PBExportHeader$u_component_attachment_image.sru
forward
global type u_component_attachment_image from u_component_attachment
end type
end forward

global type u_component_attachment_image from u_component_attachment
end type
global u_component_attachment_image u_component_attachment_image

forward prototypes
public function integer xx_display ()
public function integer xx_render (string ps_file_type, ref string ps_file, integer pi_width, integer pi_height)
public function integer convert_tiff_to_bmp (string ps_tiff_file, ref string ps_bmp_file)
end prototypes

public function integer xx_display ();w_attachment_image_display lw_window

openwithparm(lw_window, this, "w_attachment_image_display")

return 1

end function

public function integer xx_render (string ps_file_type, ref string ps_file, integer pi_width, integer pi_height);string ls_file
integer li_sts

ls_file = get_attachment()

CHOOSE CASE lower(extension)
	CASE "tif", "tiff"
		li_sts = convert_tiff_to_bmp(ls_file, ps_file)
		if li_sts <= 0 then return 0
	CASE ELSE
		ps_file = ls_file
END CHOOSE

if fileexists(ps_file) then
	return 1
else
	return 0
end if


end function

public function integer convert_tiff_to_bmp (string ps_tiff_file, ref string ps_bmp_file);oleobject lo_tiffdll
string ls_param
string ls_temp
integer li_sts
long ll_result
string ls_temp_file


if isnull(ps_tiff_file) then
	log.log(this, "u_component_attachment_image.convert_tiff_to_bmp:0010", "Null file name", 3)
	return -1
end if

if not fileexists(ps_tiff_file) then
	log.log(this, "u_component_attachment_image.convert_tiff_to_bmp:0015", "File not found (" + ps_tiff_file + ")", 3)
	return -1
end if

lo_tiffdll = CREATE oleobject
li_sts = lo_tiffdll.connecttonewobject("TiffDLL50vic.ClsTiffDLL50")
if li_sts < 0 then
	log.log(this, "u_component_attachment_image.convert_tiff_to_bmp:0022", "Connection to TiffDLL failed (" + string(li_sts) + ")", 4)
	return -1
end if

ls_param = "in=" + ps_tiff_file + ";"

ls_temp_file = f_temp_file("bmp")
ls_param += "out=" + ls_temp_file

ls_param += ";format=bmp/0;"
ll_result = lo_tiffdll.runtiffdll(ls_param)
/*if ll_result = 0 then
	log.log(this, "u_component_attachment_image.convert_tiff_to_bmp:0034", "RunTiffDLL returned zero.  Check tiffdll license (" + ls_param + ")", 4)
	return -1
end if*/
if ll_result < 0 then
	log.log(this, "u_component_attachment_image.convert_tiff_to_bmp:0038", "RunTiffDLL failed (" + string(ll_result) + ", " + ls_param + ")", 4)
	return -1
end if

lo_tiffdll.disconnectobject()
DESTROY lo_tiffdll

ps_bmp_file = ls_temp_file

return 1

end function

on u_component_attachment_image.create
call super::create
end on

on u_component_attachment_image.destroy
call super::destroy
end on

