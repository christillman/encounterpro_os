$PBExportHeader$w_attachment_display.srw
forward
global type w_attachment_display from w_window_base
end type
type st_title from statictext within w_attachment_display
end type
type cb_be_back from commandbutton within w_attachment_display
end type
type cb_done from commandbutton within w_attachment_display
end type
type uo_attachments from u_attachments within w_attachment_display
end type
end forward

global type w_attachment_display from w_window_base
string title = "Attachments"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_title st_title
cb_be_back cb_be_back
cb_done cb_done
uo_attachments uo_attachments
end type
global w_attachment_display w_attachment_display

type variables
u_component_service service

end variables

on w_attachment_display.create
int iCurrent
call super::create
this.st_title=create st_title
this.cb_be_back=create cb_be_back
this.cb_done=create cb_done
this.uo_attachments=create uo_attachments
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.cb_be_back
this.Control[iCurrent+3]=this.cb_done
this.Control[iCurrent+4]=this.uo_attachments
end on

on w_attachment_display.destroy
call super::destroy
destroy(this.st_title)
destroy(this.cb_be_back)
destroy(this.cb_done)
destroy(this.uo_attachments)
end on

event open;call super::open;string ls_attachment_tag
string ls_attachment_folder
string ls_new_attachment_folder
long ll_menu_id
string ls_progress_type
string ls_progress_key

service = Message.powerobjectparm

if not isnull(current_patient) then
	title = current_patient.id_line()
end if

service.get_attribute("attachment_folder", ls_attachment_folder)
service.get_attribute("new_attachment_folder", ls_new_attachment_folder)

// Use the attachment_tag or comment_title attribute for the attachment_tag
service.get_attribute("attachment_tag", ls_attachment_tag)
if isnull(ls_attachment_tag) then service.get_attribute("comment_title", ls_attachment_tag)

service.get_attribute("progress_type", ls_progress_type)
service.get_attribute("progress_key", ls_progress_key)

uo_attachments.initialize(service.context_object, &
									ls_attachment_tag, &
									service.object_key, &
									ls_attachment_folder, &
									ls_progress_type, &
									ls_progress_key, &
									ls_new_attachment_folder)

st_title.text = wordcap(service.description)+" Attachments"

uo_attachments.refresh()

// Don't offer the "I'll Be Back" option for manual services
max_buttons = 3
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 4
end if

ll_menu_id = long(service.get_attribute("menu_id"))
paint_menu(ll_menu_id)

end event

type pb_epro_help from w_window_base`pb_epro_help within w_attachment_display
boolean visible = true
integer x = 2670
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_attachment_display
end type

type st_title from statictext within w_attachment_display
integer width = 2921
integer height = 140
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "ATTACHMENTS"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_be_back from commandbutton within w_attachment_display
integer x = 1934
integer y = 1600
integer width = 443
integer height = 108
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
end type

event clicked;closewithreturn(parent, "BEBACK")


end event

type cb_done from commandbutton within w_attachment_display
integer x = 2414
integer y = 1600
integer width = 443
integer height = 108
integer taborder = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;closewithreturn(parent, "OK")

end event

type uo_attachments from u_attachments within w_attachment_display
integer x = 18
integer y = 164
integer width = 2843
integer height = 1388
integer taborder = 30
end type

on uo_attachments.destroy
call u_attachments::destroy
end on

