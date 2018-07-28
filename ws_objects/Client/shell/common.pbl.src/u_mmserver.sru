$PBExportHeader$u_mmserver.sru
forward
global type u_mmserver from oleobject
end type
end forward

global type u_mmserver from oleobject
end type
global u_mmserver u_mmserver

type variables
integer error_code
string error_text
end variables

forward prototypes
public function integer compress_file (string ps_uncompressed_file, string ps_compressed_file, string ps_compression_type, boolean pb_delete)
public function integer uncompress_file (string ps_compressed_file, ref string ps_uncompressed_file, string ps_compression_type, boolean pb_delete)
end prototypes

public function integer compress_file (string ps_uncompressed_file, string ps_compressed_file, string ps_compression_type, boolean pb_delete);integer li_sts

if isnull(ps_compression_type) or trim(ps_compression_type) = "" then return 0

CHOOSE CASE ps_compression_type
	CASE "ZIP"
		li_sts = this.zip_file(ps_uncompressed_file, ps_compressed_file)
	CASE ELSE
		li_sts = this.zip_file(ps_uncompressed_file, ps_compressed_file)
END CHOOSE

if li_sts <= 0 then return li_sts

if not fileexists(ps_compressed_file) then return -1

if pb_delete then filedelete(ps_uncompressed_file)

return 1


end function

public function integer uncompress_file (string ps_compressed_file, ref string ps_uncompressed_file, string ps_compression_type, boolean pb_delete);string ls_drive
string ls_directory
string ls_filename
string ls_extension
string ls_target_dir

if isnull(ps_compression_type) or trim(ps_compression_type) = "" then
	log.log(this, "uncompress_file()", "Null or empty compression type", 3)
	return 0
end if

log.log(this, "uncompress_file()", ps_compressed_file, 1)

f_parse_filepath(ps_compressed_file, ls_drive, ls_directory, ls_filename, ls_extension)
ls_target_dir = ls_drive + ls_directory

CHOOSE CASE ps_compression_type
	CASE "ZIP"
		ps_uncompressed_file = this.unzip_file(ps_compressed_file, ls_target_dir)
	CASE "ELSE"
		ps_uncompressed_file = this.unzip_file(ps_compressed_file, ls_target_dir)
END CHOOSE

if isnull(ps_uncompressed_file) or trim(ps_uncompressed_file) = "" then return -1

if not fileexists(ps_uncompressed_file) then
	log.log(this, "uncompress_file()", "Error uncompressing file", 3)
	return -1
end if

if pb_delete then filedelete(ps_compressed_file)

return 1


end function

on u_mmserver.create
call oleobject::create
TriggerEvent( this, "constructor" )
end on

on u_mmserver.destroy
call oleobject::destroy
TriggerEvent( this, "destructor" )
end on

event externalexception;error_code = integer(resultcode)
error_text = description
log.log(this, "externalexception", "ERROR (" + string(error_code) + ") - " + error_text, 4)

action = ExceptionSubstituteReturnValue!
returnvalue = -1

end event

