$PBExportHeader$u_letters.sru
forward
global type u_letters from u_cpr_page_base
end type
type uo_attachments from u_letter_attachments within u_letters
end type
type st_attachments_title from statictext within u_letters
end type
type st_title from statictext within u_letters
end type
type uo_letter_type from u_dw_pick_list within u_letters
end type
end forward

global type u_letters from u_cpr_page_base
uo_attachments uo_attachments
st_attachments_title st_attachments_title
st_title st_title
uo_letter_type uo_letter_type
end type
global u_letters u_letters

type variables
String attachment_folder



end variables

forward prototypes
public function integer next_page ()
public subroutine refresh ()
public subroutine initialize (u_cpr_section puo_section, integer pi_page)
public subroutine attachment_menu (long pl_attachment_id, string ps_attachment_type)
public subroutine refresh_folder_list ()
end prototypes

public function integer next_page ();integer li_sts
//u_attachment_image luo_attachment
//str_popup popup
//str_popup_return popup_return

//if isnull(attachment_list) then return 0

//luo_attachment = attachment_list.find_tagged_attachment("IMAGE", "LETTER")
//if isnull(luo_attachment) then return 0

//li_sts = luo_attachment.record_append()

//if li_sts > 0 then
//	refresh()
//end if

return li_sts

end function

public subroutine refresh ();long ll_first_row_on_page
long i
long ll_new_first_row_on_page
long ll_last
string ls_find
long ll_row

uo_letter_type.setredraw(false)

uo_attachments.refresh(attachment_folder)

ll_first_row_on_page = long(uo_letter_type.object.DataWindow.FirstRowOnPage)

refresh_folder_list()

i = 1
DO WHILE true
	i += 1
	ll_new_first_row_on_page = long(uo_letter_type.object.DataWindow.FirstRowOnPage)
	if ll_new_first_row_on_page >= ll_first_row_on_page or ll_new_first_row_on_page <= 0 then exit
	if i > 20 and ll_new_first_row_on_page = ll_last then exit
	uo_letter_type.scrolltorow(i)
	ll_last = ll_new_first_row_on_page
LOOP

if isnull(attachment_folder) then
	ls_find = "folder='<All>'"
else
	ls_find = "folder='" + attachment_folder + "'"
end if

ll_row = uo_letter_type.find(ls_find, 1, uo_letter_type.rowcount())
if ll_row > 0 then
	uo_letter_type.object.selected_flag[ll_row] = 1
end if

uo_letter_type.setredraw(true)

end subroutine

public subroutine initialize (u_cpr_section puo_section, integer pi_page);Long ll_rowcount
string ls_find
long ll_row
long ll_null

setnull(ll_null)

this_section = puo_section
this_page = pi_page

refresh_folder_list()

ll_rowcount = uo_letter_type.rowcount()
if ll_rowcount > 0 then
	ls_find = "folder='<All>'"
	ll_row = uo_letter_type.find(ls_find, 1, ll_rowcount)
	if ll_row > 0 then
		uo_letter_type.object.selected_flag[ll_row] = 1
		setnull(attachment_folder)
	else
		ll_row = 1
		uo_letter_type.object.selected_flag[1] = 1
		attachment_folder = uo_letter_type.object.folder[1]
	end if
	
	uo_letter_type.scrolltorow(ll_row)
end if

uo_attachments.width = width - uo_attachments.x
uo_attachments.height = height - uo_attachments.y
st_attachments_title.width = uo_attachments.width - 120
st_attachments_title.height = height - st_attachments_title.y

uo_letter_type.height = height - uo_letter_type.y - 40

// Initially pull out all the patient attachments
uo_attachments.initialize("Patient", ll_null)

end subroutine

public subroutine attachment_menu (long pl_attachment_id, string ps_attachment_type);current_patient.attachments.menu(pl_attachment_id, uo_attachments.context_object, uo_attachments.object_key)
refresh()

end subroutine

public subroutine refresh_folder_list ();long ll_row

uo_letter_type.settransobject(sqlca)
uo_letter_type.retrieve(current_patient.cpr_id)
ll_row = uo_letter_type.insertrow(0)
uo_letter_type.object.folder[ll_row] = '<All>'
uo_letter_type.object.description[ll_row] = '<All>'

end subroutine

on u_letters.create
int iCurrent
call super::create
this.uo_attachments=create uo_attachments
this.st_attachments_title=create st_attachments_title
this.st_title=create st_title
this.uo_letter_type=create uo_letter_type
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_attachments
this.Control[iCurrent+2]=this.st_attachments_title
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.uo_letter_type
end on

on u_letters.destroy
call super::destroy
destroy(this.uo_attachments)
destroy(this.st_attachments_title)
destroy(this.st_title)
destroy(this.uo_letter_type)
end on

type cb_configure_tab from u_cpr_page_base`cb_configure_tab within u_letters
end type

type uo_attachments from u_letter_attachments within u_letters
event destroy ( )
integer x = 873
integer y = 100
integer width = 1998
integer height = 1156
integer taborder = 20
end type

on uo_attachments.destroy
call u_letter_attachments::destroy
end on

event ue_attachment_clicked;call super::ue_attachment_clicked;attachment_menu(pl_attachment_id,ps_attachment_type)
end event

type st_attachments_title from statictext within u_letters
integer x = 873
integer width = 1883
integer height = 96
integer textsize = -14
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Attachments"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title from statictext within u_letters
integer width = 814
integer height = 104
integer textsize = -14
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Folders"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_letter_type from u_dw_pick_list within u_letters
integer x = 9
integer y = 104
integer width = 855
integer height = 1128
integer taborder = 10
string dataobject = "dw_sp_get_patient_folder_list"
boolean vscrollbar = true
boolean border = false
end type

event constructor;call super::constructor;active_header = true
end event

event selected;call super::selected;String ls_null

Setnull(ls_null)

attachment_folder = object.folder[selected_row]
If attachment_folder = '<All>' Then attachment_folder = ls_null

Refresh()

end event

