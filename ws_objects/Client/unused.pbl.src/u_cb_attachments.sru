$PBExportHeader$u_cb_attachments.sru
forward
global type u_cb_attachments from commandbutton
end type
end forward

global type u_cb_attachments from commandbutton
integer width = 402
integer height = 112
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "none"
end type
global u_cb_attachments u_cb_attachments

type variables
u_attachment_list attachments

end variables

forward prototypes
public subroutine refresh ()
public function integer initialize (u_attachment_list puo_attachments)
end prototypes

public subroutine refresh ();text = "Attachments " + string(attachments.attachment_count)
if attachments.attachment_count > 0 then
	weight = 700
else
	weight = 400
end if

end subroutine

public function integer initialize (u_attachment_list puo_attachments);
attachments = puo_attachments

refresh()

return 1

end function

on u_cb_attachments.create
end on

on u_cb_attachments.destroy
end on

event clicked;//attachments.menu()
refresh()

end event

