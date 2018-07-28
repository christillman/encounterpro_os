$PBExportHeader$u_component_attachment_link.sru
forward
global type u_component_attachment_link from u_component_attachment
end type
end forward

global type u_component_attachment_link from u_component_attachment
end type
global u_component_attachment_link u_component_attachment_link

forward prototypes
public function integer xx_display ()
end prototypes

public function integer xx_display ();blob lbl_link
integer li_sts
string ls_link
inet l_Inet

li_sts = get_attachment_blob(lbl_link)
if li_sts <= 0 then return -1

ls_link = f_blob_to_string(lbl_link)

// Open html file with HyperlinkToURL
// So, a new browser is launched
// (with the code using ShellExecuteEx, it is not sure)
GetContextService("Internet", l_Inet)
li_sts = l_Inet.HyperlinkToURL(ls_link)


return 1

end function

on u_component_attachment_link.create
call super::create
end on

on u_component_attachment_link.destroy
call super::destroy
end on

