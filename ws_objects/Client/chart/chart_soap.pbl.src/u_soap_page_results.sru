$PBExportHeader$u_soap_page_results.sru
$PBExportComments$show button bar for doing test from observation & treatment types..
forward
global type u_soap_page_results from u_soap_page_base_large
end type
type st_format_1 from statictext within u_soap_page_results
end type
type st_format_2 from statictext within u_soap_page_results
end type
type st_format_3 from statictext within u_soap_page_results
end type
type st_format_4 from statictext within u_soap_page_results
end type
type uo_attachments from u_letter_attachments within u_soap_page_results
end type
type uo_letter_type from u_dw_pick_list within u_soap_page_results
end type
type uo_picture from u_picture_display within u_soap_page_results
end type
type st_attachment_details from statictext within u_soap_page_results
end type
end forward

global type u_soap_page_results from u_soap_page_base_large
integer width = 4206
st_format_1 st_format_1
st_format_2 st_format_2
st_format_3 st_format_3
st_format_4 st_format_4
uo_attachments uo_attachments
uo_letter_type uo_letter_type
uo_picture uo_picture
st_attachment_details st_attachment_details
end type
global u_soap_page_results u_soap_page_results

type variables

long display_script_id_1
long display_script_id_2
long display_script_id_3
long display_script_id_4

long current_display_script_id

string attachment_folder = "Lab Results"
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
end prototypes

public subroutine xx_refresh ();integer li_sts
string ls_text
long ll_page

setredraw(false)

ll_page = uo_attachments.dw_attachments.current_page
if ll_page <= 0 then ll_page = 1

// this would look something like filtering to choose attachments
// which are dated between the chosen encounter date and the next one
//li_sts = uo_attachments.load_encounter(display_mode, new_data)
//if li_sts <= 0 then return

uo_attachments.dw_attachments.last_page = 0
uo_attachments.dw_attachments.set_page(ll_page, ls_text)

uo_attachments.show_attachments(attachment_folder)

setredraw(true)
end subroutine

public subroutine xx_initialize ();integer i
string ls_temp
long ll_null

setnull(ll_null)

this_section.load_params(this_section.page[this_page].page_id)

// this.dw_encounters.visible = false
if this.dw_encounters.visible then
	st_format_1.backcolor = color_object
	st_format_2.backcolor = color_object
	st_format_3.backcolor = color_object
	st_format_4.backcolor = color_object
	
	setnull(current_display_script_id)
		
	display_script_id_1 = long(this_section.get_attribute(this_section.page[this_page].page_id, "display_script_id_1"))
	ls_temp = this_section.get_attribute(this_section.page[this_page].page_id, "display_title_1")
	if isnull(display_script_id_1) then
		st_format_1.visible = false
	else
		st_format_1.visible = true
		if not isnull(ls_temp) then st_format_1.text = left(ls_temp, 3)
		if isnull(current_display_script_id) then
			st_format_1.backcolor = color_object_selected
			current_display_script_id = display_script_id_1
		end if
	end if
	
	display_script_id_2 = long(this_section.get_attribute(this_section.page[this_page].page_id, "display_script_id_2"))
	ls_temp = this_section.get_attribute(this_section.page[this_page].page_id, "display_title_2")
	if isnull(display_script_id_2) then
		st_format_2.visible = false
	else
		st_format_2.visible = true
		if not isnull(ls_temp) then st_format_2.text = left(ls_temp, 3)
		if isnull(current_display_script_id) then
			st_format_2.backcolor = color_object_selected
			current_display_script_id = display_script_id_2
		end if
	end if
	
	display_script_id_3 = long(this_section.get_attribute(this_section.page[this_page].page_id, "display_script_id_3"))
	ls_temp = this_section.get_attribute(this_section.page[this_page].page_id, "display_title_3")
	if isnull(display_script_id_3) then
		st_format_3.visible = false
	else
		st_format_3.visible = true
		if not isnull(ls_temp) then st_format_3.text = left(ls_temp, 3)
		if isnull(current_display_script_id) then
			st_format_3.backcolor = color_object_selected
			current_display_script_id = display_script_id_3
		end if
	end if
	
	display_script_id_4 = long(this_section.get_attribute(this_section.page[this_page].page_id, "display_script_id_4"))
	ls_temp = this_section.get_attribute(this_section.page[this_page].page_id, "display_title_4")
	if isnull(display_script_id_4) then
		st_format_4.visible = false
	else
		st_format_4.visible = true
		if not isnull(ls_temp) then st_format_4.text = left(ls_temp, 3)
		if isnull(current_display_script_id) then
			st_format_4.backcolor = color_object_selected
			current_display_script_id = display_script_id_4
		end if
	end if
	
	st_format_2.x = content_left_edge + (content_width / 2) - st_format_2.width - 8
	st_format_1.x = st_format_2.x - st_format_1.width - 16
	st_format_3.x = st_format_2.x + st_format_2.width + 16
	st_format_4.x = st_format_3.x + st_format_3.width + 16
	
	st_format_1.y = content_bottom_edge - st_format_1.height
	st_format_2.y = content_bottom_edge - st_format_2.height
	st_format_3.y = content_bottom_edge - st_format_3.height
	st_format_4.y = content_bottom_edge - st_format_4.height
else
	st_format_1.visible = false
	st_format_2.visible = false
	st_format_3.visible = false
	st_format_4.visible = false
end if
	
uo_attachments.x = content_left_edge
uo_attachments.y = content_top_edge
uo_attachments.height = st_encounter_count.y - uo_attachments.y - 10

// split the space between attachments list and picture
uo_attachments.width = 1 * content_width / 3 - 20

st_attachment_details.x = uo_attachments.x + uo_attachments.width + 20
st_attachment_details.y = content_bottom_edge - st_attachment_details.height
st_attachment_details.width = content_right_edge - st_attachment_details.x
	
uo_picture.x = uo_attachments.x + uo_attachments.width + 20
uo_picture.y = content_top_edge
uo_picture.width = content_right_edge - uo_picture.x
uo_picture.height = st_attachment_details.y - uo_picture.y - 30


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

li_please_wait = f_please_wait_open()

refresh()

f_please_wait_close(li_please_wait)

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

if pl_row <= 0 then pl_row = 1
if pl_row > ll_rowcount then pl_row = ll_rowcount

last_selected_attachment_id = uo_attachments.dw_attachments.object.attachment_id[pl_row]
ls_extension = uo_attachments.dw_attachments.object.extension[pl_row]

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
ls_title += uo_attachments.dw_attachments.object.user_full_name[pl_row]
ls_title += " on " + string(uo_attachments.dw_attachments.object.created[pl_row], "[shortdate] [time]")
st_attachment_details.text = ls_title

Return


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

// Initially pull out just lab results
uo_attachments.initialize("Patient", "Attachment_Tag", ll_null, attachment_folder)
// for all attachments
// uo_attachments.initialize("Patient", ll_null)
	
uo_attachments.refresh()
uo_picture.initialize()

this.select_image(1)

end subroutine

on u_soap_page_results.create
int iCurrent
call super::create
this.st_format_1=create st_format_1
this.st_format_2=create st_format_2
this.st_format_3=create st_format_3
this.st_format_4=create st_format_4
this.uo_attachments=create uo_attachments
this.uo_letter_type=create uo_letter_type
this.uo_picture=create uo_picture
this.st_attachment_details=create st_attachment_details
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_format_1
this.Control[iCurrent+2]=this.st_format_2
this.Control[iCurrent+3]=this.st_format_3
this.Control[iCurrent+4]=this.st_format_4
this.Control[iCurrent+5]=this.uo_attachments
this.Control[iCurrent+6]=this.uo_letter_type
this.Control[iCurrent+7]=this.uo_picture
this.Control[iCurrent+8]=this.st_attachment_details
end on

on u_soap_page_results.destroy
call super::destroy
destroy(this.st_format_1)
destroy(this.st_format_2)
destroy(this.st_format_3)
destroy(this.st_format_4)
destroy(this.uo_attachments)
destroy(this.uo_letter_type)
destroy(this.uo_picture)
destroy(this.st_attachment_details)
end on

type cb_configure_tab from u_soap_page_base_large`cb_configure_tab within u_soap_page_results
end type

type st_coding_title from u_soap_page_base_large`st_coding_title within u_soap_page_results
boolean visible = false
end type

type st_all from u_soap_page_base_large`st_all within u_soap_page_results
end type

type st_indirect from u_soap_page_base_large`st_indirect within u_soap_page_results
end type

type st_direct from u_soap_page_base_large`st_direct within u_soap_page_results
end type

type st_button_12 from u_soap_page_base_large`st_button_12 within u_soap_page_results
end type

type st_button_9 from u_soap_page_base_large`st_button_9 within u_soap_page_results
end type

type st_button_7 from u_soap_page_base_large`st_button_7 within u_soap_page_results
end type

type st_button_11 from u_soap_page_base_large`st_button_11 within u_soap_page_results
end type

type st_button_10 from u_soap_page_base_large`st_button_10 within u_soap_page_results
end type

type st_button_8 from u_soap_page_base_large`st_button_8 within u_soap_page_results
end type

type pb_12 from u_soap_page_base_large`pb_12 within u_soap_page_results
end type

type pb_11 from u_soap_page_base_large`pb_11 within u_soap_page_results
end type

type pb_10 from u_soap_page_base_large`pb_10 within u_soap_page_results
end type

type pb_9 from u_soap_page_base_large`pb_9 within u_soap_page_results
end type

type pb_8 from u_soap_page_base_large`pb_8 within u_soap_page_results
end type

type pb_7 from u_soap_page_base_large`pb_7 within u_soap_page_results
end type

type dw_encounters from u_soap_page_base_large`dw_encounters within u_soap_page_results
end type

type cb_coding from u_soap_page_base_large`cb_coding within u_soap_page_results
boolean visible = false
end type

type pb_4 from u_soap_page_base_large`pb_4 within u_soap_page_results
end type

type cb_current from u_soap_page_base_large`cb_current within u_soap_page_results
end type

type pb_1 from u_soap_page_base_large`pb_1 within u_soap_page_results
end type

type pb_5 from u_soap_page_base_large`pb_5 within u_soap_page_results
end type

type pb_2 from u_soap_page_base_large`pb_2 within u_soap_page_results
end type

type pb_3 from u_soap_page_base_large`pb_3 within u_soap_page_results
end type

type pb_6 from u_soap_page_base_large`pb_6 within u_soap_page_results
end type

type st_button_1 from u_soap_page_base_large`st_button_1 within u_soap_page_results
end type

type st_button_2 from u_soap_page_base_large`st_button_2 within u_soap_page_results
end type

type st_button_3 from u_soap_page_base_large`st_button_3 within u_soap_page_results
end type

type st_button_4 from u_soap_page_base_large`st_button_4 within u_soap_page_results
end type

type st_button_5 from u_soap_page_base_large`st_button_5 within u_soap_page_results
end type

type st_button_6 from u_soap_page_base_large`st_button_6 within u_soap_page_results
end type

type st_config_mode_menu from u_soap_page_base_large`st_config_mode_menu within u_soap_page_results
end type

type st_encounter_count from u_soap_page_base_large`st_encounter_count within u_soap_page_results
end type

type st_7 from u_soap_page_base_large`st_7 within u_soap_page_results
boolean visible = false
end type

type st_no_encounters from u_soap_page_base_large`st_no_encounters within u_soap_page_results
boolean visible = false
integer y = 632
boolean enabled = false
end type

type st_format_1 from statictext within u_soap_page_results
integer x = 1842
integer y = 2008
integer width = 137
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
string text = "1"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_format_2.backcolor = color_object
st_format_3.backcolor = color_object
st_format_4.backcolor = color_object

current_display_script_id = display_script_id_1

refresh()

end event

type st_format_2 from statictext within u_soap_page_results
integer x = 2002
integer y = 2008
integer width = 137
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
string text = "2"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_format_1.backcolor = color_object
st_format_3.backcolor = color_object
st_format_4.backcolor = color_object

current_display_script_id = display_script_id_2

refresh()

end event

type st_format_3 from statictext within u_soap_page_results
integer x = 2162
integer y = 2008
integer width = 137
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
string text = "3"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_format_2.backcolor = color_object
st_format_1.backcolor = color_object
st_format_4.backcolor = color_object

current_display_script_id = display_script_id_3

refresh()

end event

type st_format_4 from statictext within u_soap_page_results
integer x = 2322
integer y = 2008
integer width = 137
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
string text = "4"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_format_2.backcolor = color_object
st_format_3.backcolor = color_object
st_format_1.backcolor = color_object

current_display_script_id = display_script_id_4

refresh()

end event

type uo_attachments from u_letter_attachments within u_soap_page_results
integer x = 919
integer y = 128
integer width = 2030
integer height = 1524
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

end event

type uo_letter_type from u_dw_pick_list within u_soap_page_results
boolean visible = false
integer x = 402
integer y = 240
integer width = 855
integer height = 1128
integer taborder = 20
boolean bringtotop = true
boolean enabled = false
string title = "Invisible folder list"
string dataobject = "dw_sp_get_patient_folder_list"
boolean border = false
boolean livescroll = false
end type

event constructor;call super::constructor;active_header = true
end event

event selected;call super::selected;String ls_null

Setnull(ls_null)

// invisible object cannot be selected?
attachment_folder = object.folder[selected_row]
If attachment_folder = '<All>' Then attachment_folder = ls_null

Refresh()

end event

type uo_picture from u_picture_display within u_soap_page_results
event destroy ( )
integer x = 2775
integer y = 148
integer width = 1367
integer height = 1520
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

type st_attachment_details from statictext within u_soap_page_results
integer x = 2135
integer y = 1716
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

