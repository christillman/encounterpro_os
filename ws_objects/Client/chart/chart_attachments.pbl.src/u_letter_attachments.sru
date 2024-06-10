$PBExportHeader$u_letter_attachments.sru
forward
global type u_letter_attachments from u_attachments
end type
end forward

global type u_letter_attachments from u_attachments
integer width = 2043
integer height = 1116
event ue_attachment_clicked ( string ps_attachment_type,  long pl_attachment_id )
event ue_set_bold ( boolean pb_bold )
end type
global u_letter_attachments u_letter_attachments

on u_letter_attachments.create
call super::create
end on

on u_letter_attachments.destroy
call super::destroy
end on

event ue_clicked;// Override the script (override menus of ancestor)

Long ll_attachment_id,ll_row
String ls_attachment_type

ll_row = dw_attachments.get_selected_row()
If ll_row > 0 Then
	ll_attachment_id = dw_attachments.object.attachment_id[ll_row]
	ls_attachment_type = dw_attachments.object.attachment_type[ll_row]
	yield() // sometimes, it says this event doesn't exist
	event Post ue_attachment_clicked(ls_attachment_type,ll_attachment_id)
Else
	// show new encounter
	parent.dynamic event post ue_clicked()
End If

end event

type pb_new_attachments from u_attachments`pb_new_attachments within u_letter_attachments
integer x = 1723
integer y = 32
end type

event pb_new_attachments::clicked;call super::clicked;If dw_attachments.rowcount() > 0 Then
	Parent.Event Post ue_set_bold(true)
Else
	Parent.Event Post ue_set_bold(false)
End if
end event

type st_page from u_attachments`st_page within u_letter_attachments
integer x = 1728
integer y = 568
end type

type pb_down from u_attachments`pb_down within u_letter_attachments
integer x = 1728
integer y = 440
integer width = 142
integer height = 120
end type

type pb_up from u_attachments`pb_up within u_letter_attachments
integer x = 1728
integer y = 300
integer width = 142
integer height = 120
boolean originalsize = false
end type

type dw_attachments from u_attachments`dw_attachments within u_letter_attachments
integer width = 1641
integer height = 1076
boolean livescroll = false
end type

