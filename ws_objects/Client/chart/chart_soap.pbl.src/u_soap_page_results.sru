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
type pb_down from picturebutton within u_soap_page_results
end type
type pb_up from picturebutton within u_soap_page_results
end type
type uo_attachments from u_letter_attachments within u_soap_page_results
end type
end forward

global type u_soap_page_results from u_soap_page_base_large
st_format_1 st_format_1
st_format_2 st_format_2
st_format_3 st_format_3
st_format_4 st_format_4
pb_down pb_down
pb_up pb_up
uo_attachments uo_attachments
end type
global u_soap_page_results u_soap_page_results

type variables

long display_script_id_1
long display_script_id_2
long display_script_id_3
long display_script_id_4

long current_display_script_id

end variables

forward prototypes
public subroutine xx_refresh ()
public subroutine xx_initialize ()
public subroutine prev_encounter ()
public subroutine next_encounter ()
public subroutine key_down (keycode key, unsignedlong keyflags)
end prototypes

public subroutine xx_refresh ();integer li_sts
string ls_text
long ll_page

setredraw(false)

ll_page = uo_attachments.dw_attachments.current_page
if ll_page <= 0 then ll_page = 1

//li_sts = uo_attachments.load_encounter(display_mode, new_data)
if li_sts <= 0 then return

uo_attachments.dw_attachments.last_page = 0
uo_attachments.dw_attachments.set_page(ll_page, ls_text)

uo_attachments.refresh("Lab Results")

setredraw(true)
end subroutine

public subroutine xx_initialize ();integer i
string ls_temp
long ll_null

setnull(ll_null)

pb_up.visible = false
pb_down.visible = false

this_section.load_params(this_section.page[this_page].page_id)

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

if dw_encounters.visible then
	pb_up.visible = true
	pb_down.visible = true
	uo_attachments.visible = true

	pb_down.x = content_right_edge - pb_down.width
	pb_up.x = pb_down.x - pb_up.width - 12
	
	pb_up.y = content_bottom_edge - pb_up.height
	pb_down.y = content_bottom_edge - pb_down.height
	
	st_format_2.x = content_left_edge + (content_width / 2) - st_format_2.width - 8
	st_format_1.x = st_format_2.x - st_format_1.width - 16
	st_format_3.x = st_format_2.x + st_format_2.width + 16
	st_format_4.x = st_format_3.x + st_format_3.width + 16
	
	st_format_1.y = content_bottom_edge - st_format_1.height
	st_format_2.y = content_bottom_edge - st_format_2.height
	st_format_3.y = content_bottom_edge - st_format_3.height
	st_format_4.y = content_bottom_edge - st_format_4.height

	uo_attachments.x = content_left_edge
	uo_attachments.y = content_top_edge
	uo_attachments.width = content_width
	uo_attachments.height = st_format_1.y - uo_attachments.y - 20
	
	// Initially pull out all the patient results
	uo_attachments.initialize("Patient", "Tag", ll_null, "Lab Results")

else
	pb_up.visible = false
	pb_down.visible = false
	uo_attachments.visible = false
	st_format_1.visible = false
	st_format_2.visible = false
	st_format_3.visible = false
	st_format_4.visible = false
end if


end subroutine

public subroutine prev_encounter ();string ls_find
long ll_count
long ll_encounter_id
long ll_row
integer li_sts
integer li_please_wait

if isnull(current_display_encounter) then return

ll_count = dw_encounters.rowcount()
ls_find = "encounter_id=" + string(current_display_encounter.encounter_id)
ll_row = dw_encounters.find(ls_find, 1, ll_count)
if ll_row > 1  then
	ll_encounter_id = dw_encounters.object.encounter_id[ll_row - 1]
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

ll_count = dw_encounters.rowcount()
ls_find = "encounter_id=" + string(current_display_encounter.encounter_id)
ll_row = dw_encounters.find(ls_find, 1, ll_count)
if ll_row > 0 and ll_row < ll_count then
	ll_encounter_id = dw_encounters.object.encounter_id[ll_row + 1]
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
		pb_up.event post clicked()
	CASE keypagedown!
		pb_down.event post clicked()
END CHOOSE

return

end subroutine

on u_soap_page_results.create
int iCurrent
call super::create
this.st_format_1=create st_format_1
this.st_format_2=create st_format_2
this.st_format_3=create st_format_3
this.st_format_4=create st_format_4
this.pb_down=create pb_down
this.pb_up=create pb_up
this.uo_attachments=create uo_attachments
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_format_1
this.Control[iCurrent+2]=this.st_format_2
this.Control[iCurrent+3]=this.st_format_3
this.Control[iCurrent+4]=this.st_format_4
this.Control[iCurrent+5]=this.pb_down
this.Control[iCurrent+6]=this.pb_up
this.Control[iCurrent+7]=this.uo_attachments
end on

on u_soap_page_results.destroy
call super::destroy
destroy(this.st_format_1)
destroy(this.st_format_2)
destroy(this.st_format_3)
destroy(this.st_format_4)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.uo_attachments)
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
end type

type st_no_encounters from u_soap_page_base_large`st_no_encounters within u_soap_page_results
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

type pb_down from picturebutton within u_soap_page_results
integer x = 2994
integer y = 2008
integer width = 137
integer height = 116
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
alignment htextalign = left!
end type

event clicked;string ls_text
//uo_attachments.dw_attachments.set_page(uo_attachments.dw_attachments.current_page + 1, ls_text)
//pb_up.enabled = true
//
//if uo_attachments.dw_attachments.current_page >= uo_attachments.dw_attachments.last_page then
//	enabled = false
//else
//	enabled = true
//end if
end event

type pb_up from picturebutton within u_soap_page_results
integer x = 2834
integer y = 2008
integer width = 137
integer height = 116
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
alignment htextalign = left!
end type

event clicked;string ls_text
//uo_attachments.dw_attachments.set_page(uo_attachments.dw_attachments.current_page - 1, ls_text)
pb_down.enabled = true

//if uo_attachments.dw_attachments.current_page <= 1 then
	enabled = false
//else
	enabled = true
//end if

end event

type uo_attachments from u_letter_attachments within u_soap_page_results
integer x = 1266
integer y = 140
integer taborder = 40
boolean bringtotop = true
end type

on uo_attachments.destroy
call u_letter_attachments::destroy
end on

