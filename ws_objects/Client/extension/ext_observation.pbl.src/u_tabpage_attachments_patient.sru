$PBExportHeader$u_tabpage_attachments_patient.sru
forward
global type u_tabpage_attachments_patient from u_tabpage
end type
type st_title from statictext within u_tabpage_attachments_patient
end type
type uo_letter_type from u_dw_pick_list within u_tabpage_attachments_patient
end type
type st_attachment_title from statictext within u_tabpage_attachments_patient
end type
type uo_attachments from u_attachments within u_tabpage_attachments_patient
end type
end forward

global type u_tabpage_attachments_patient from u_tabpage
integer width = 2734
st_title st_title
uo_letter_type uo_letter_type
st_attachment_title st_attachment_title
uo_attachments uo_attachments
end type
global u_tabpage_attachments_patient u_tabpage_attachments_patient

type variables
string attachment_folder
boolean first_time = true

end variables

forward prototypes
public function integer initialize ()
public subroutine refresh ()
end prototypes

public function integer initialize ();st_attachment_title.width = width - st_attachment_title.x

uo_attachments.width = st_attachment_title.width
uo_attachments.height = height - uo_attachments.y

uo_letter_type.height = height - uo_letter_type.y

return 1

end function

public subroutine refresh ();long ll_row
long ll_null

setnull(ll_null)

if first_time then
	uo_letter_type.settransobject(sqlca)
	uo_letter_type.retrieve(current_patient.cpr_id)
	ll_row = uo_letter_type.insertrow(0)
	uo_letter_type.object.attachment_folder[ll_row] = '<ALL>'
	uo_letter_type.object.selected_flag[ll_row] = 1
	uo_letter_type.object.attachment_attachment_folder[ll_row] = '<ALL>'
	setnull(attachment_folder)
	
	// Initially pull out all the patient attachments
	uo_attachments.initialize("Patient", ll_null)
	
	first_time = false
end if

uo_attachments.refresh(attachment_folder)


end subroutine

on u_tabpage_attachments_patient.create
int iCurrent
call super::create
this.st_title=create st_title
this.uo_letter_type=create uo_letter_type
this.st_attachment_title=create st_attachment_title
this.uo_attachments=create uo_attachments
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.uo_letter_type
this.Control[iCurrent+3]=this.st_attachment_title
this.Control[iCurrent+4]=this.uo_attachments
end on

on u_tabpage_attachments_patient.destroy
call super::destroy
destroy(this.st_title)
destroy(this.uo_letter_type)
destroy(this.st_attachment_title)
destroy(this.uo_attachments)
end on

type st_title from statictext within u_tabpage_attachments_patient
integer x = 18
integer width = 773
integer height = 104
integer textsize = -14
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Folders"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_letter_type from u_dw_pick_list within u_tabpage_attachments_patient
integer x = 9
integer y = 104
integer width = 818
integer height = 1128
integer taborder = 10
string dataobject = "dw_sp_get_letter_count"
boolean vscrollbar = true
boolean border = false
end type

event constructor;call super::constructor;active_header = true
end event

event post_click;String ls_null

Setnull(ls_null)
if lastrow <= 0 then return

attachment_folder = object.attachment_folder[lastrow]
If attachment_folder = '<ALL>' Then attachment_folder = ls_null

refresh()

end event

type st_attachment_title from statictext within u_tabpage_attachments_patient
integer x = 818
integer width = 1874
integer height = 96
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Attachments"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_attachments from u_attachments within u_tabpage_attachments_patient
integer x = 809
integer y = 96
integer width = 1893
integer height = 1200
integer taborder = 20
boolean bringtotop = true
end type

on uo_attachments.destroy
call u_attachments::destroy
end on

event ue_clicked;string buttons[]
integer button_pressed, li_sts, li_service_count
string ls_attachment_type
long ll_attachment_id
long ll_row
u_tab_attachments luo_parent
str_external_observation_attachment lstr_attachment
u_component_attachment luo_attachment

str_popup popup
str_popup_return popup_return
window lw_pop_buttons

ll_row = dw_attachments.get_selected_row()
If ll_row > 0 Then
	ll_attachment_id = dw_attachments.object.attachment_id[ll_row]
	ls_attachment_type = upper(string(dw_attachments.object.attachment_type[ll_row]))
else
	return
End If

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Select Attachment"
	popup.button_titles[popup.button_count] = "Select Attachment"
	buttons[popup.button_count] = "SELECT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Display Attachment"
	popup.button_titles[popup.button_count] = "Display Attachment"
	buttons[popup.button_count] = "DISPLAY"
end if

if ls_attachment_type = "IMAGE" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Attachment"
	popup.button_titles[popup.button_count] = "Edit Attachment"
	buttons[popup.button_count] = "EDIT"
end if

If true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Delete Attachment"
	popup.button_titles[popup.button_count] = "Delete Attachment"
	buttons[popup.button_count] = "DELETE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	button_pressed = message.doubleparm
	if button_pressed < 1 or button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if

CHOOSE CASE buttons[button_pressed]
	CASE "SELECT"
		li_sts = current_patient.attachments.attachment(luo_attachment, ll_attachment_id)
		if li_sts <= 0 then return
		
		lstr_attachment.attachment_type = luo_attachment.attachment_type
		lstr_attachment.extension = luo_attachment.extension
		lstr_attachment.attachment_comment_title = luo_attachment.attachment_tag
		lstr_attachment.attachment_comment = luo_attachment.attachment_text
		li_sts = luo_attachment.get_attachment_blob(lstr_attachment.attachment)
		
		component_manager.destroy_component(luo_attachment)
		
		luo_parent = parent_tab
		luo_parent.event POST attachment_selected(lstr_attachment)
	CASE "DELETE"
		openwithparm(w_pop_yes_no, "Do you want to delete this attachment?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		
		delete_attachment()
	CASE "DISPLAY"
		if ls_attachment_type = "IMAGE" then
			display_image()
		else
			display()
		end if
	CASE "EDIT"
		display()
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

Return

end event

