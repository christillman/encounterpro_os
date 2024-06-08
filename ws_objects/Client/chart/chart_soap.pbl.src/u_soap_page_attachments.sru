$PBExportHeader$u_soap_page_attachments.sru
$PBExportComments$show button bar for doing test from observation & treatment types..
forward
global type u_soap_page_attachments from u_soap_page_base_large
end type
type uo_picture from u_picture_display within u_soap_page_attachments
end type
type st_attachment_details from statictext within u_soap_page_attachments
end type
type uo_attachments from u_letter_attachments within u_soap_page_attachments
end type
type uo_folder_list from u_dw_pick_list within u_soap_page_attachments
end type
type st_view_toggle from statictext within u_soap_page_attachments
end type
end forward

global type u_soap_page_attachments from u_soap_page_base_large
integer width = 4901
uo_picture uo_picture
st_attachment_details st_attachment_details
uo_attachments uo_attachments
uo_folder_list uo_folder_list
st_view_toggle st_view_toggle
end type
global u_soap_page_attachments u_soap_page_attachments

type variables

string attachment_folder
string attachment_file

long last_selected_attachment_id

u_ds_attachments attachments

string displayed_actual_file
end variables

forward prototypes
public subroutine xx_refresh ()
public subroutine xx_initialize ()
public subroutine prev_encounter ()
public subroutine next_encounter ()
public subroutine key_down (keycode key, unsignedlong keyflags)
public subroutine attachment_menu (long pl_attachment_id, string ps_attachment_type)
public subroutine select_image (long pl_row)
public subroutine initialize (u_cpr_section puo_section, integer pi_page)
public subroutine refresh_folder_list ()
end prototypes

public subroutine xx_refresh ();long ll_first_row_on_page
long i
long ll_new_first_row_on_page
long ll_last
string ls_find
long ll_row
integer li_sts
string ls_text
long ll_page

setredraw(false)

ll_page = uo_attachments.dw_attachments.current_page
if ll_page <= 0 then ll_page = 1

uo_attachments.refresh(attachment_folder)

uo_attachments.dw_attachments.last_page = 0
uo_attachments.dw_attachments.set_page(ll_page, ls_text)

ll_first_row_on_page = long(uo_folder_list.object.DataWindow.FirstRowOnPage)

//refresh_folder_list()

i = 1
DO WHILE true
	i += 1
	ll_new_first_row_on_page = long(uo_folder_list.object.DataWindow.FirstRowOnPage)
	if ll_new_first_row_on_page >= ll_first_row_on_page or ll_new_first_row_on_page <= 0 then exit
	if i > 20 and ll_new_first_row_on_page = ll_last then exit
	uo_folder_list.scrolltorow(i)
	ll_last = ll_new_first_row_on_page
LOOP

if isnull(attachment_folder) then
	ls_find = "folder='<All>'"
else
	ls_find = "folder='" + attachment_folder + "'"
end if

ll_row = uo_folder_list.find(ls_find, 1, uo_folder_list.rowcount())
if ll_row > 0 then
	uo_folder_list.object.selected_flag[ll_row] = 1
end if

setredraw(true)
end subroutine

public subroutine xx_initialize ();integer i
string ls_temp
long ll_null

setnull(ll_null)

st_encounter_count.y = content_top_edge - st_encounter_count.height

st_direct.y = st_encounter_count.y - st_direct.height - 8
st_indirect.y = st_direct.y
st_all.y = st_direct.y

dw_encounters.y = content_top_edge
uo_folder_list.y = dw_encounters.y
dw_encounters.height = ((content_bottom_edge -content_top_edge) - 20 - st_view_toggle.height)
uo_folder_list.height = dw_encounters.height

uo_folder_list.visible = NOT dw_encounters.visible
st_direct.visible = dw_encounters.visible
st_indirect.visible = dw_encounters.visible
st_all.visible = dw_encounters.visible
st_encounter_count.visible = dw_encounters.visible

st_view_toggle.backcolor = color_object
st_view_toggle.y = content_bottom_edge - st_view_toggle.height

uo_attachments.x = content_left_edge
uo_attachments.y = content_top_edge
uo_attachments.height = height - uo_attachments.y - 10

// split the space between attachments list and picture
uo_attachments.width = 1 * content_width / 3 - 20

st_attachment_details.x = uo_attachments.x + uo_attachments.width + 20
st_attachment_details.y = content_bottom_edge - st_attachment_details.height
st_attachment_details.width = content_right_edge - st_attachment_details.x
	
uo_picture.x = uo_attachments.x + uo_attachments.width + 20
uo_picture.y = content_top_edge
uo_picture.width = content_right_edge - uo_picture.x
uo_picture.height = st_attachment_details.y - uo_picture.y - 30

this_section.load_params(this_section.page[this_page].page_id)

refresh_folder_list()


end subroutine

public subroutine prev_encounter ();string ls_find
long ll_count
long ll_encounter_id
long ll_row
integer li_sts
integer li_please_wait

if isnull(current_display_encounter) then return

ll_count = this.dw_encounters.rowcount()
ls_find = "encounter_id=" + string(current_display_encounter.encounter_id)
ll_row = this.dw_encounters.find(ls_find, 1, ll_count)
if ll_row > 1  then
	ll_encounter_id = this.dw_encounters.object.encounter_id[ll_row - 1]
end if

li_sts = f_set_current_encounter(ll_encounter_id)

refresh()

end subroutine

public subroutine next_encounter ();string ls_find
long ll_count
long ll_encounter_id
long ll_row
integer li_sts
integer li_please_wait


if isnull(current_display_encounter) then return

ll_count = this.dw_encounters.rowcount()
ls_find = "encounter_id=" + string(current_display_encounter.encounter_id)
ll_row = this.dw_encounters.find(ls_find, 1, ll_count)
if ll_row > 0 and ll_row < ll_count then
	ll_encounter_id = this.dw_encounters.object.encounter_id[ll_row + 1]
end if

li_sts = f_set_current_encounter(ll_encounter_id)

li_please_wait = f_please_wait_open()

refresh()

f_please_wait_close(li_please_wait)
end subroutine

public subroutine key_down (keycode key, unsignedlong keyflags);

CHOOSE CASE key
	CASE keyuparrow!
		prev_encounter()
	CASE keydownarrow!
		next_encounter()
	CASE keypageup!
		uo_attachments.pb_up.event post clicked()
	CASE keypagedown!
		uo_attachments.pb_down.event post clicked()
END CHOOSE

return

end subroutine

public subroutine attachment_menu (long pl_attachment_id, string ps_attachment_type);
current_patient.attachments.menu(pl_attachment_id, uo_attachments.context_object, uo_attachments.object_key)

refresh()

end subroutine

public subroutine select_image (long pl_row);Blob 		lbl_attachment
Integer 	li_sts,li_count
String 	ls_extension, ls_file
string ls_find
long ll_row
string   ls_prev_extension
String	ls_title
u_component_attachment luo_displayed_attachment
long 		ll_rowcount
long ll_first_row_on_page
long ll_lastrowonpage

ll_rowcount = uo_attachments.dw_attachments.rowcount()
if ll_rowcount <= 0 then return

CHOOSE CASE pl_row
	CASE IS <=0
		ll_row = 1
	CASE IS > ll_rowcount
		ll_row = ll_rowcount
	CASE ELSE
		ll_row = pl_row
END CHOOSE

last_selected_attachment_id = uo_attachments.dw_attachments.object.attachment_id[ll_row]
ls_extension = uo_attachments.dw_attachments.object.extension[ll_row]

li_sts = attachments.attachment(luo_displayed_attachment, last_selected_attachment_id)
if li_sts <= 0 then
	setnull(displayed_actual_file)
	log.log(this, "u_tabpage_incoming_documents_base.select_image:0034", "Error getting attachment object", 3)
else
	displayed_actual_file = luo_displayed_attachment.get_attachment()
	
	attachment_file = luo_displayed_attachment.render()
	// Display the attachment in the browser object
	uo_picture.display_picture(attachment_file)
end if
component_manager.destroy_component(luo_displayed_attachment)

ls_title = "File Attached by "
ls_title += uo_attachments.dw_attachments.object.user_full_name[ll_row]
ls_title += " on " + string(uo_attachments.dw_attachments.object.created[ll_row], "[shortdate] [time]")
st_attachment_details.text = ls_title



end subroutine

public subroutine initialize (u_cpr_section puo_section, integer pi_page);long ll_rows
string ls_null
long ll_null

SetNull(ls_null)
SetNull(ll_null)

super::initialize(puo_section, pi_page)

attachments = CREATE u_ds_attachments
attachments.settransobject(sqlca)
ll_rows = attachments.retrieve(current_patient.cpr_id)

uo_attachments.initialize("Patient", ll_null)
	
uo_attachments.refresh()
uo_picture.initialize()

this.select_image(1)

end subroutine

public subroutine refresh_folder_list ();long ll_row

uo_folder_list.settransobject(sqlca)
uo_folder_list.retrieve(current_patient.cpr_id)
ll_row = uo_folder_list.insertrow(0)
uo_folder_list.object.folder[ll_row] = '<All>'
uo_folder_list.object.description[ll_row] = '<All>'

end subroutine

on u_soap_page_attachments.create
int iCurrent
call super::create
this.uo_picture=create uo_picture
this.st_attachment_details=create st_attachment_details
this.uo_attachments=create uo_attachments
this.uo_folder_list=create uo_folder_list
this.st_view_toggle=create st_view_toggle
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_picture
this.Control[iCurrent+2]=this.st_attachment_details
this.Control[iCurrent+3]=this.uo_attachments
this.Control[iCurrent+4]=this.uo_folder_list
this.Control[iCurrent+5]=this.st_view_toggle
end on

on u_soap_page_attachments.destroy
call super::destroy
destroy(this.uo_picture)
destroy(this.st_attachment_details)
destroy(this.uo_attachments)
destroy(this.uo_folder_list)
destroy(this.st_view_toggle)
end on

type cb_configure_tab from u_soap_page_base_large`cb_configure_tab within u_soap_page_attachments
end type

type st_coding_title from u_soap_page_base_large`st_coding_title within u_soap_page_attachments
boolean visible = false
end type

type st_all from u_soap_page_base_large`st_all within u_soap_page_attachments
integer x = 754
integer y = 16
integer width = 270
end type

type st_indirect from u_soap_page_base_large`st_indirect within u_soap_page_attachments
integer x = 462
integer y = 16
integer width = 270
end type

type st_direct from u_soap_page_base_large`st_direct within u_soap_page_attachments
integer x = 169
integer y = 16
integer width = 270
end type

type st_button_12 from u_soap_page_base_large`st_button_12 within u_soap_page_attachments
end type

type st_button_9 from u_soap_page_base_large`st_button_9 within u_soap_page_attachments
end type

type st_button_7 from u_soap_page_base_large`st_button_7 within u_soap_page_attachments
end type

type st_button_11 from u_soap_page_base_large`st_button_11 within u_soap_page_attachments
end type

type st_button_10 from u_soap_page_base_large`st_button_10 within u_soap_page_attachments
end type

type st_button_8 from u_soap_page_base_large`st_button_8 within u_soap_page_attachments
end type

type pb_12 from u_soap_page_base_large`pb_12 within u_soap_page_attachments
end type

type pb_11 from u_soap_page_base_large`pb_11 within u_soap_page_attachments
end type

type pb_10 from u_soap_page_base_large`pb_10 within u_soap_page_attachments
end type

type pb_9 from u_soap_page_base_large`pb_9 within u_soap_page_attachments
end type

type pb_8 from u_soap_page_base_large`pb_8 within u_soap_page_attachments
end type

type pb_7 from u_soap_page_base_large`pb_7 within u_soap_page_attachments
end type

type dw_encounters from u_soap_page_base_large`dw_encounters within u_soap_page_attachments
integer x = 32
integer y = 164
integer height = 844
boolean vscrollbar = true
end type

type cb_coding from u_soap_page_base_large`cb_coding within u_soap_page_attachments
boolean visible = false
end type

type pb_4 from u_soap_page_base_large`pb_4 within u_soap_page_attachments
end type

type cb_current from u_soap_page_base_large`cb_current within u_soap_page_attachments
end type

type pb_1 from u_soap_page_base_large`pb_1 within u_soap_page_attachments
end type

type pb_5 from u_soap_page_base_large`pb_5 within u_soap_page_attachments
end type

type pb_2 from u_soap_page_base_large`pb_2 within u_soap_page_attachments
end type

type pb_3 from u_soap_page_base_large`pb_3 within u_soap_page_attachments
end type

type pb_6 from u_soap_page_base_large`pb_6 within u_soap_page_attachments
end type

type st_button_1 from u_soap_page_base_large`st_button_1 within u_soap_page_attachments
end type

type st_button_2 from u_soap_page_base_large`st_button_2 within u_soap_page_attachments
end type

type st_button_3 from u_soap_page_base_large`st_button_3 within u_soap_page_attachments
end type

type st_button_4 from u_soap_page_base_large`st_button_4 within u_soap_page_attachments
end type

type st_button_5 from u_soap_page_base_large`st_button_5 within u_soap_page_attachments
end type

type st_button_6 from u_soap_page_base_large`st_button_6 within u_soap_page_attachments
end type

type st_config_mode_menu from u_soap_page_base_large`st_config_mode_menu within u_soap_page_attachments
end type

type st_encounter_count from u_soap_page_base_large`st_encounter_count within u_soap_page_attachments
integer x = 421
integer y = 112
end type

type st_7 from u_soap_page_base_large`st_7 within u_soap_page_attachments
boolean visible = false
end type

type st_no_encounters from u_soap_page_base_large`st_no_encounters within u_soap_page_attachments
boolean visible = false
integer y = 632
boolean enabled = false
end type

type uo_picture from u_picture_display within u_soap_page_attachments
event destroy ( )
integer x = 3264
integer y = 108
integer width = 1376
integer height = 1652
integer taborder = 30
boolean bringtotop = true
boolean border = true
end type

on uo_picture.destroy
call u_picture_display::destroy
end on

event picture_clicked;call super::picture_clicked;integer li_sts
string ls_drive1
string ls_directory1
string ls_file1
string ls_extension1
string ls_drive2
string ls_directory2
string ls_file2
string ls_extension2
boolean lb_show_original
str_popup popup

f_parse_filepath(displayed_actual_file, ls_drive1, ls_directory1, ls_file1, ls_extension1)
f_parse_filepath(picture_file, ls_drive2, ls_directory2, ls_file2, ls_extension2)

if lower(ls_extension1) = lower(ls_extension2) then
	lb_show_original = true
elseif left(lower(ls_extension1), 3) = "tif" then
	lb_show_original = true
else
	popup.title = "The attachment has been converted to display on the screen."
	popup.title += "  Do you wish to open the original ~"" + ls_extension1 + "~" file"
	popup.title += " or the converted ~"" + ls_extension2 + "~" file?"
	
	popup.data_row_count = 2
	popup.items[1] = "Open the original ~"" + ls_extension1 + "~" file"
	popup.items[2] = "Open the converted ~"" + ls_extension2 + "~" file"
	
	openwithparm(w_pop_choices_2, popup)
	if message.doubleparm = 1 then
		lb_show_original = true
	else
		lb_show_original = false
	end if
	
end if

if lb_show_original then
	li_sts = f_open_file(displayed_actual_file, false)
else
	li_sts = f_open_file(picture_file, false)
end if

return

end event

type st_attachment_details from statictext within u_soap_page_attachments
integer x = 3291
integer y = 1752
integer width = 1367
integer height = 152
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_attachments from u_letter_attachments within u_soap_page_attachments
integer x = 1294
integer y = 108
integer width = 1920
integer height = 1628
integer taborder = 40
boolean bringtotop = true
end type

on uo_attachments.destroy
call u_letter_attachments::destroy
end on

event ue_attachment_clicked;call super::ue_attachment_clicked;
long ll_row

ll_row = this.dw_attachments.get_selected_row()

select_image(ll_row)

attachment_menu(pl_attachment_id, ps_attachment_type)

this.dw_attachments.set_row(ll_row)

end event

event ue_clicked;
if dw_encounters.visible then
	load_encounters()
	// select the newly created encoutner
	dw_encounters.event selected(1)
end if


end event

type uo_folder_list from u_dw_pick_list within u_soap_page_attachments
integer x = 32
integer y = 1048
integer width = 1216
integer height = 824
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_sp_get_patient_folder_list"
boolean vscrollbar = true
boolean border = false
end type

event constructor;call super::constructor;active_header = true
end event

event selected;call super::selected;String ls_null

Setnull(ls_null)

attachment_folder = object.folder[selected_row]

Refresh()

end event

type st_view_toggle from statictext within u_soap_page_attachments
integer x = 274
integer y = 2008
integer width = 686
integer height = 112
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "View Folders"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;
// toggle
If dw_encounters.visible Then
		dw_encounters.visible = False
		text = "View Appointments"
		attachment_folder = "<All>"
Else
		dw_encounters.visible = True
		text = "View Folders"
		attachment_folder = ""
End If

// follow along
uo_folder_list.visible = NOT dw_encounters.visible
st_direct.visible = dw_encounters.visible
st_indirect.visible = dw_encounters.visible
st_all.visible = dw_encounters.visible
st_encounter_count.visible = dw_encounters.visible

refresh()

end event

