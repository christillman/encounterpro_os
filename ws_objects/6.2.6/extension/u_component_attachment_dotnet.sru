HA$PBExportHeader$u_component_attachment_dotnet.sru
forward
global type u_component_attachment_dotnet from u_component_attachment
end type
end forward

global type u_component_attachment_dotnet from u_component_attachment
end type
global u_component_attachment_dotnet u_component_attachment_dotnet

forward prototypes
protected function integer xx_initialize ()
protected function boolean xx_is_displayable ()
protected function boolean xx_is_editable ()
protected function integer xx_shutdown ()
public function integer xx_display ()
public function integer xx_edit ()
protected function boolean xx_is_printable ()
public function integer xx_print ()
public function integer xx_render (string ps_file_type, ref string ps_file, integer pi_width, integer pi_height)
end prototypes

protected function integer xx_initialize ();integer li_sts
str_attributes lstr_attributes

// Get the XML document for the component attributes
lstr_attributes = get_attributes()
//f_attribute_add_attribute(lstr_attributes, "patient_workplan_item_id", string(patient_workplan_item_id))

li_sts = initialize_dotnet_wrapper(lstr_attributes)

return li_sts



end function

protected function boolean xx_is_displayable ();boolean lb_is_displayable

TRY
	lb_is_displayable = com_wrapper.is_displayable(extension)
CATCH (throwable lt_error)
	log.log(this, "xx_is_displayable()", "Error calling is_displayable (" + lt_error.text + ")", 4)
	return false
END TRY

return lb_is_displayable

end function

protected function boolean xx_is_editable ();boolean lb_is_editable

TRY
	lb_is_editable = com_wrapper.is_editable(extension)
CATCH (throwable lt_error)
	log.log(this, "xx_is_editable()", "Error calling is_editable (" + lt_error.text + ")", 4)
	return false
END TRY

return lb_is_editable

end function

protected function integer xx_shutdown ();
TRY
	com_wrapper.disconnectobject( )
CATCH (throwable lt_error)
	log.log(this, "xx_do_source()", "Error disconnecting ConnectClass (" + lt_error.text + ")", 4)
	return -1
END TRY


DESTROY com_wrapper


return 1


end function

public function integer xx_display ();integer li_sts
blob lbl_attachment

li_sts = get_attachment_blob(lbl_attachment)
if li_sts <= 0 then return -1

TRY
	li_sts = com_wrapper.display(lbl_attachment, extension)
CATCH (throwable lt_error)
	log.log(this, "xx_edit()", "Error editing attachment (" + lt_error.text + ")", 4)
	return -1
END TRY

if li_sts < 0 then return -1
if li_sts = 0 then return 0

return 1

end function

public function integer xx_edit ();integer li_sts
blob lbl_attachment
blob lbl_modified_attachment

li_sts = get_attachment_blob(lbl_attachment)
if li_sts <= 0 then return -1

TRY
	lbl_modified_attachment = com_wrapper.edit(lbl_attachment, extension)
CATCH (throwable lt_error)
	log.log(this, "xx_edit()", "Error editing attachment (" + lt_error.text + ")", 4)
	return -1
END TRY

if isnull(lbl_modified_attachment) or len(lbl_modified_attachment) = 0 then
	// attachment wasn't edited
	return 0
end if

li_sts = add_update(lbl_modified_attachment)
if li_sts <= 0 then return -1


return 1

end function

protected function boolean xx_is_printable ();boolean lb_is_printable

TRY
	lb_is_printable = com_wrapper.is_printable(extension)
CATCH (throwable lt_error)
	log.log(this, "xx_is_printable()", "Error calling is_printable (" + lt_error.text + ")", 4)
	return false
END TRY

return lb_is_printable

end function

public function integer xx_print ();integer li_sts
blob lbl_attachment
unsignedlong lul_pid

li_sts = get_attachment_blob(lbl_attachment)
if li_sts <= 0 then return -1

TRY
	li_sts = com_wrapper.print(lbl_attachment, extension)
CATCH (throwable lt_error)
	log.log(this, "xx_edit()", "Error editing attachment (" + lt_error.text + ")", 4)
	return -1
END TRY

if li_sts < 0 then return -1
if li_sts = 0 then return 0

return 1

end function

public function integer xx_render (string ps_file_type, ref string ps_file, integer pi_width, integer pi_height);integer li_sts
blob lbl_attachment
blob lbl_bitmap
string ls_render_file_type

li_sts = get_attachment_blob(lbl_attachment)
if li_sts <= 0 then return -1

ls_render_file_type = ps_file_type

if isnull(pi_width) then
	pi_width = 0
end if

if isnull(pi_height) then
	pi_height = 0
end if

if isnull(ls_render_file_type) then
	ls_render_file_type = ""
end if


TRY
	lbl_bitmap = com_wrapper.render(lbl_attachment, extension, pi_width, pi_height, ls_render_file_type)
CATCH (throwable lt_error)
	log.log(this, "xx_edit()", "Error editing attachment (" + lt_error.text + ")", 4)
	return -1
END TRY

// Assume bitmap if we don't have a render file type
if isnull(ls_render_file_type) or trim(ls_render_file_type) = "" then
	ls_render_file_type = "bmp"
end if

ps_file = f_temp_file(ls_render_file_type)

li_sts = log.file_write(lbl_bitmap, ps_file)
if li_sts <= 0 then return -1

return 1

end function

on u_component_attachment_dotnet.create
call super::create
end on

on u_component_attachment_dotnet.destroy
call super::destroy
end on

