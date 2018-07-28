$PBExportHeader$u_soap_page_problem_list.sru
$PBExportComments$show button bar for doing test from observation & treatment types..
forward
global type u_soap_page_problem_list from u_soap_page_base_large
end type
type pb_down from picturebutton within u_soap_page_problem_list
end type
type pb_up from picturebutton within u_soap_page_problem_list
end type
type p_atat from picture within u_soap_page_problem_list
end type
type p_aatt from picture within u_soap_page_problem_list
end type
type p_aa from picture within u_soap_page_problem_list
end type
type p_tt from picture within u_soap_page_problem_list
end type
type st_new_data from statictext within u_soap_page_problem_list
end type
type p_obj from picture within u_soap_page_problem_list
end type
type st_page from statictext within u_soap_page_problem_list
end type
type st_problem_list_title from statictext within u_soap_page_problem_list
end type
type st_include_cancelled from statictext within u_soap_page_problem_list
end type
type p_rtf from picture within u_soap_page_problem_list
end type
type cb_close_multi from commandbutton within u_soap_page_problem_list
end type
type dw_soap_display from u_soap_display within u_soap_page_problem_list
end type
type u_rtf from u_rich_text_edit within u_soap_page_problem_list
end type
end forward

global type u_soap_page_problem_list from u_soap_page_base_large
pb_down pb_down
pb_up pb_up
p_atat p_atat
p_aatt p_aatt
p_aa p_aa
p_tt p_tt
st_new_data st_new_data
p_obj p_obj
st_page st_page
st_problem_list_title st_problem_list_title
st_include_cancelled st_include_cancelled
p_rtf p_rtf
cb_close_multi cb_close_multi
dw_soap_display dw_soap_display
u_rtf u_rtf
end type
global u_soap_page_problem_list u_soap_page_problem_list

type variables
string display_mode
boolean new_data

long display_script_id


string multi_soap_type

end variables

forward prototypes
public subroutine xx_refresh ()
public subroutine xx_initialize ()
public subroutine next_encounter ()
public subroutine prev_encounter ()
public subroutine key_down (keycode key, unsignedlong keyflags)
public function integer new_display_script ()
end prototypes

public subroutine xx_refresh ();integer li_sts
string ls_text
long ll_page

// Show the rtf button in display mode so the user has something to click
if isnull(display_script_id) and not config_mode then
	p_rtf.visible = false
else
	p_rtf.visible = true
end if

if upper(display_mode) = "RTF" then
	st_problem_list_title.text = "Encounter"
	dw_soap_display.visible = false
	u_rtf.visible = true
	u_rtf.clear_rtf()
	u_rtf.display_encounter(current_display_encounter.encounter_id, display_script_id)
	u_rtf.top()
	return
end if

u_rtf.visible = false
dw_soap_display.visible = true


CHOOSE CASE upper(display_mode)
	CASE "AA"
		st_problem_list_title.text = "Assessments"
	CASE "TT"
		st_problem_list_title.text = "Treatments"
	CASE ELSE
		st_problem_list_title.text = "Assessments and Treatments"
END CHOOSE

setredraw(false)

dw_soap_display.object.attachment.x = dw_soap_display.width - 300

ll_page = dw_soap_display.current_page
if ll_page <= 0 then ll_page = 1

li_sts = dw_soap_display.load_encounter(display_mode, new_data)
if li_sts <= 0 then return

dw_soap_display.last_page = 0
dw_soap_display.set_page(ll_page, pb_up, pb_down, st_page)
st_page.visible = false

setredraw(true)

if dw_encounters.visible then
	dw_soap_display.visible = true
	p_atat.visible = true
	p_aatt.visible = true
	p_aa.visible = true
	p_tt.visible = true
	p_obj.visible = true
	st_new_data.visible = true
	st_include_cancelled.visible = true
else
	dw_soap_display.visible = false
	p_atat.visible = false
	p_aatt.visible = false
	p_aa.visible = false
	p_tt.visible = false
	p_obj.visible = false
	st_new_data.visible = false
	st_include_cancelled.visible = false
end if


end subroutine

public subroutine xx_initialize ();string ls_temp

if dw_encounters.visible then
	dw_soap_display.visible = true
	p_rtf.visible = true
	p_atat.visible = true
	p_aatt.visible = true
	p_aa.visible = true
	p_tt.visible = true
	p_obj.visible = true
	st_new_data.visible = true
	st_include_cancelled.visible = true
	
	pb_down.x = content_right_edge - pb_down.width
	pb_up.x = pb_down.x - pb_up.width - 12
	st_page.x = pb_up.x - st_page.width - 8
	
	pb_up.y = content_bottom_edge - pb_up.height
	pb_down.y = content_bottom_edge - pb_down.height
	st_page.y = pb_up.y
	
	p_rtf.y = content_bottom_edge - p_rtf.height
	p_atat.y = content_bottom_edge - p_atat.height
	p_aatt.y = content_bottom_edge - p_aatt.height
	p_aa.y = content_bottom_edge - p_aa.height
	p_tt.y = content_bottom_edge - p_tt.height
	p_obj.y = content_bottom_edge - p_obj.height
	
	st_new_data.y = content_bottom_edge - st_new_data.height
	st_include_cancelled.y = st_new_data.y
	
	dw_soap_display.x = content_left_edge
	dw_soap_display.y = content_top_edge
	dw_soap_display.width = content_width
	dw_soap_display.height = p_atat.y - dw_soap_display.y - 20

	u_rtf.x = dw_soap_display.x
	u_rtf.y = dw_soap_display.y
	u_rtf.width = dw_soap_display.width
	u_rtf.height = dw_soap_display.height

	st_problem_list_title.x = content_left_edge
	st_problem_list_title.y = dw_soap_display.y - st_problem_list_title.height
	
	cb_close_multi.x = dw_soap_display.x + ((dw_soap_display.width - cb_close_multi.width) / 2 )
	cb_close_multi.y = dw_soap_display.y + dw_soap_display.height - cb_close_multi.height
else
	u_rtf.visible = false
	dw_soap_display.visible = false
	p_atat.visible = false
	p_aatt.visible = false
	p_aa.visible = false
	p_tt.visible = false
	p_obj.visible = false
	st_new_data.visible = false
	st_include_cancelled.visible = false
end if

pb_up.visible = false
pb_down.visible = false

display_mode = upper(this_section.get_attribute(this_section.page[this_page].page_id, "display_mode"))
if isnull(display_mode) then display_mode = "ATAT"

CHOOSE CASE display_mode
	CASE "RTF"
		p_rtf.BorderStyle = StyleLowered!
	CASE "AATT"
		p_aatt.BorderStyle = StyleLowered!
	CASE "AA"
		p_aa.BorderStyle = StyleLowered!
	CASE "TT"
		p_tt.BorderStyle = StyleLowered!
	CASE "OBJ"
		p_obj.BorderStyle = StyleLowered!
	CASE ELSE
		display_mode = "ATAT"
		p_atat.BorderStyle = StyleLowered!
END CHOOSE

dw_soap_display.assessment_service = this_section.get_attribute(this_section.page[this_page].page_id, "assessment_service")
if isnull(dw_soap_display.assessment_service) then dw_soap_display.assessment_service = "ASSESSMENT_REVIEW"

dw_soap_display.treatment_service = this_section.get_attribute(this_section.page[this_page].page_id, "treatment_service")
if isnull(dw_soap_display.treatment_service) then dw_soap_display.treatment_service = "TREATMENT_REVIEW"

dw_soap_display.sincelast_display_script_id = long(this_section.get_attribute(this_section.page[this_page].page_id, "sincelast_display_script_id"))

display_script_id = long(this_section.get_attribute(this_section.page[this_page].page_id, "display_script_id"))
if isnull(display_script_id) or display_script_id <= 0 then
	setnull(display_script_id)
	p_rtf.visible = false
end if

ls_temp = this_section.get_attribute(this_section.page[this_page].page_id, "text_color_new")
if isnull(ls_temp) then
	dw_soap_display.text_color_new = rgb(0,0,255)
else
	dw_soap_display.text_color_new = long(ls_temp)
end if

ls_temp = this_section.get_attribute(this_section.page[this_page].page_id, "back_color_services")
if isnull(ls_temp) then
	dw_soap_display.back_color_services = rgb(192,255,255)
else
	dw_soap_display.back_color_services = long(ls_temp)
end if

ls_temp = this_section.get_attribute(this_section.page[this_page].page_id, "back_color_deleted")
if isnull(ls_temp) then
	dw_soap_display.back_color_deleted = rgb(255,196, 196)
else
	dw_soap_display.back_color_deleted = long(ls_temp)
end if

ls_temp = this_section.get_attribute(this_section.page[this_page].page_id, "new_data")
if isnull(ls_temp) then ls_temp = "False"
new_data = f_string_to_boolean(ls_temp)

if new_data then
	st_new_data.BorderStyle = StyleLowered!
else
	st_new_data.BorderStyle = StyleRaised!
end if

ls_temp = this_section.get_attribute(this_section.page[this_page].page_id, "show_deleted")
if isnull(ls_temp) then ls_temp = "False"
dw_soap_display.show_deleted = f_string_to_boolean(ls_temp)

if dw_soap_display.show_deleted then
	st_include_cancelled.BorderStyle = StyleLowered!
else
	st_include_cancelled.BorderStyle = StyleRaised!
end if

dw_soap_display.initialize()


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

public function integer new_display_script ();str_popup popup
long ll_display_script_id
string ls_description
string ls_config_object_id
string ls_display_script_id
w_window_base lw_window

SELECT description, CAST(id AS varchar(38))
INTO :ls_description, :ls_config_object_id
FROM c_Chart
WHERE chart_id = :this_section.chart_id;
if not tf_check() then return -1

ls_description = "SOAP RTF Script for " + ls_description

ll_display_script_id = sqlca.sp_new_display_script("Encounter", &
																	ls_description, &
																	ls_description, &
																	current_user.user_id, &
																	"RTF", &
																	ls_config_object_id)
if not tf_check() then return -1
if isnull(ll_display_script_id) or ll_display_script_id = 0 then return -1

display_script_id = ll_display_script_id
ls_display_script_id = string(display_script_id)

DELETE c_Chart_Section_Page_Attribute
WHERE chart_id = :this_section.chart_id
AND section_id = :this_section.section_id
AND page_id = :this_section.page[this_page].page_id
AND attribute = 'display_script_id'
AND user_id IS NULL;
if not tf_check() then return -1

// Update the chart page attributes with this display script
INSERT INTO c_Chart_Section_Page_Attribute (
	chart_id,
	section_id,
	page_id,
	attribute,
	value)
VALUES (
	:this_section.chart_id,
	:this_section.section_id,
	:this_section.page[this_page].page_id,
	'display_script_id',
	:ls_display_script_id );
if not tf_check() then return -1

popup.items[1] = string(display_script_id)
popup.items[2] = f_boolean_to_string(true)
setnull(popup.items[3])
popup.data_row_count = 3

openwithparm(lw_window, popup, "w_display_script_config")

refresh()

return 1

end function

on u_soap_page_problem_list.create
int iCurrent
call super::create
this.pb_down=create pb_down
this.pb_up=create pb_up
this.p_atat=create p_atat
this.p_aatt=create p_aatt
this.p_aa=create p_aa
this.p_tt=create p_tt
this.st_new_data=create st_new_data
this.p_obj=create p_obj
this.st_page=create st_page
this.st_problem_list_title=create st_problem_list_title
this.st_include_cancelled=create st_include_cancelled
this.p_rtf=create p_rtf
this.cb_close_multi=create cb_close_multi
this.dw_soap_display=create dw_soap_display
this.u_rtf=create u_rtf
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_down
this.Control[iCurrent+2]=this.pb_up
this.Control[iCurrent+3]=this.p_atat
this.Control[iCurrent+4]=this.p_aatt
this.Control[iCurrent+5]=this.p_aa
this.Control[iCurrent+6]=this.p_tt
this.Control[iCurrent+7]=this.st_new_data
this.Control[iCurrent+8]=this.p_obj
this.Control[iCurrent+9]=this.st_page
this.Control[iCurrent+10]=this.st_problem_list_title
this.Control[iCurrent+11]=this.st_include_cancelled
this.Control[iCurrent+12]=this.p_rtf
this.Control[iCurrent+13]=this.cb_close_multi
this.Control[iCurrent+14]=this.dw_soap_display
this.Control[iCurrent+15]=this.u_rtf
end on

on u_soap_page_problem_list.destroy
call super::destroy
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.p_atat)
destroy(this.p_aatt)
destroy(this.p_aa)
destroy(this.p_tt)
destroy(this.st_new_data)
destroy(this.p_obj)
destroy(this.st_page)
destroy(this.st_problem_list_title)
destroy(this.st_include_cancelled)
destroy(this.p_rtf)
destroy(this.cb_close_multi)
destroy(this.dw_soap_display)
destroy(this.u_rtf)
end on

type cb_configure_tab from u_soap_page_base_large`cb_configure_tab within u_soap_page_problem_list
end type

type st_coding_title from u_soap_page_base_large`st_coding_title within u_soap_page_problem_list
end type

type st_all from u_soap_page_base_large`st_all within u_soap_page_problem_list
integer x = 782
end type

type st_indirect from u_soap_page_base_large`st_indirect within u_soap_page_problem_list
integer x = 411
end type

type st_direct from u_soap_page_base_large`st_direct within u_soap_page_problem_list
end type

type st_button_12 from u_soap_page_base_large`st_button_12 within u_soap_page_problem_list
end type

type st_button_9 from u_soap_page_base_large`st_button_9 within u_soap_page_problem_list
end type

type st_button_7 from u_soap_page_base_large`st_button_7 within u_soap_page_problem_list
end type

type st_button_11 from u_soap_page_base_large`st_button_11 within u_soap_page_problem_list
end type

type st_button_10 from u_soap_page_base_large`st_button_10 within u_soap_page_problem_list
end type

type st_button_8 from u_soap_page_base_large`st_button_8 within u_soap_page_problem_list
end type

type pb_12 from u_soap_page_base_large`pb_12 within u_soap_page_problem_list
integer taborder = 0
end type

type pb_11 from u_soap_page_base_large`pb_11 within u_soap_page_problem_list
integer taborder = 0
end type

type pb_10 from u_soap_page_base_large`pb_10 within u_soap_page_problem_list
integer taborder = 0
end type

type pb_9 from u_soap_page_base_large`pb_9 within u_soap_page_problem_list
integer taborder = 0
end type

type pb_8 from u_soap_page_base_large`pb_8 within u_soap_page_problem_list
integer taborder = 0
end type

type pb_7 from u_soap_page_base_large`pb_7 within u_soap_page_problem_list
integer taborder = 0
end type

type dw_encounters from u_soap_page_base_large`dw_encounters within u_soap_page_problem_list
integer taborder = 0
boolean vscrollbar = true
end type

type cb_coding from u_soap_page_base_large`cb_coding within u_soap_page_problem_list
integer taborder = 0
end type

type pb_4 from u_soap_page_base_large`pb_4 within u_soap_page_problem_list
integer taborder = 0
end type

type cb_current from u_soap_page_base_large`cb_current within u_soap_page_problem_list
integer taborder = 0
end type

type pb_1 from u_soap_page_base_large`pb_1 within u_soap_page_problem_list
integer taborder = 0
end type

type pb_5 from u_soap_page_base_large`pb_5 within u_soap_page_problem_list
integer taborder = 0
end type

type pb_2 from u_soap_page_base_large`pb_2 within u_soap_page_problem_list
integer taborder = 0
end type

type pb_3 from u_soap_page_base_large`pb_3 within u_soap_page_problem_list
integer taborder = 0
end type

type pb_6 from u_soap_page_base_large`pb_6 within u_soap_page_problem_list
integer taborder = 0
end type

type st_button_1 from u_soap_page_base_large`st_button_1 within u_soap_page_problem_list
end type

type st_button_2 from u_soap_page_base_large`st_button_2 within u_soap_page_problem_list
end type

type st_button_3 from u_soap_page_base_large`st_button_3 within u_soap_page_problem_list
end type

type st_button_4 from u_soap_page_base_large`st_button_4 within u_soap_page_problem_list
end type

type st_button_5 from u_soap_page_base_large`st_button_5 within u_soap_page_problem_list
end type

type st_button_6 from u_soap_page_base_large`st_button_6 within u_soap_page_problem_list
end type

type st_config_mode_menu from u_soap_page_base_large`st_config_mode_menu within u_soap_page_problem_list
end type

type st_encounter_count from u_soap_page_base_large`st_encounter_count within u_soap_page_problem_list
end type

type st_7 from u_soap_page_base_large`st_7 within u_soap_page_problem_list
end type

type st_no_encounters from u_soap_page_base_large`st_no_encounters within u_soap_page_problem_list
end type

type pb_down from picturebutton within u_soap_page_problem_list
integer x = 2990
integer y = 2008
integer width = 137
integer height = 116
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

if dw_soap_display.current_page >= dw_soap_display.last_page then return

dw_soap_display.set_page(dw_soap_display.current_page + 1, ls_text)
pb_up.enabled = true

if dw_soap_display.current_page >= dw_soap_display.last_page then
	enabled = false
else
	enabled = true
end if

end event

type pb_up from picturebutton within u_soap_page_problem_list
integer x = 2821
integer y = 2008
integer width = 137
integer height = 116
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

if dw_soap_display.current_page <= 1 then return

dw_soap_display.set_page(dw_soap_display.current_page - 1, ls_text)
pb_down.enabled = true

if dw_soap_display.current_page <= 1 then
	enabled = false
else
	enabled = true
end if

end event

type p_atat from picture within u_soap_page_problem_list
integer x = 1371
integer y = 2008
integer width = 137
integer height = 116
boolean bringtotop = true
string picturename = "icon_assessments1.bmp"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;BorderStyle = StyleLowered!
p_rtf.BorderStyle = StyleRaised!
p_aatt.BorderStyle = StyleRaised!
p_aa.BorderStyle = StyleRaised!
p_tt.BorderStyle = StyleRaised!
p_obj.BorderStyle = StyleRaised!

display_mode = "ATAT"
refresh()

end event

type p_aatt from picture within u_soap_page_problem_list
integer x = 1541
integer y = 2008
integer width = 137
integer height = 116
boolean bringtotop = true
boolean originalsize = true
string picturename = "icon_assessments2.bmp"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;BorderStyle = StyleLowered!
p_rtf.BorderStyle = StyleRaised!
p_atat.BorderStyle = StyleRaised!
p_aa.BorderStyle = StyleRaised!
p_tt.BorderStyle = StyleRaised!
p_obj.BorderStyle = StyleRaised!

display_mode = "AATT"
refresh()

end event

type p_aa from picture within u_soap_page_problem_list
integer x = 1710
integer y = 2008
integer width = 137
integer height = 116
boolean bringtotop = true
boolean originalsize = true
string picturename = "icon_assessments3.bmp"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;BorderStyle = StyleLowered!
p_rtf.BorderStyle = StyleRaised!
p_atat.BorderStyle = StyleRaised!
p_aatt.BorderStyle = StyleRaised!
p_tt.BorderStyle = StyleRaised!
p_obj.BorderStyle = StyleRaised!

display_mode = "AA"
refresh()

end event

type p_tt from picture within u_soap_page_problem_list
integer x = 1879
integer y = 2008
integer width = 137
integer height = 116
boolean bringtotop = true
boolean originalsize = true
string picturename = "icon_assessments4.bmp"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;BorderStyle = StyleLowered!
p_rtf.BorderStyle = StyleRaised!
p_atat.BorderStyle = StyleRaised!
p_aatt.BorderStyle = StyleRaised!
p_aa.BorderStyle = StyleRaised!
p_obj.BorderStyle = StyleRaised!

display_mode = "TT"
refresh()

end event

type st_new_data from statictext within u_soap_page_problem_list
integer x = 2281
integer y = 2008
integer width = 137
integer height = 116
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "New Only"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if new_data then
	new_data = false
	BorderStyle = StyleRaised!
else
	new_data = true
	BorderStyle = StyleLowered!
end if

refresh()

end event

type p_obj from picture within u_soap_page_problem_list
integer x = 2048
integer y = 2008
integer width = 137
integer height = 116
boolean bringtotop = true
boolean originalsize = true
string picturename = "icon_encounter_objects.bmp"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;BorderStyle = StyleLowered!
p_rtf.BorderStyle = StyleRaised!
p_atat.BorderStyle = StyleRaised!
p_aatt.BorderStyle = StyleRaised!
p_aa.BorderStyle = StyleRaised!
p_tt.BorderStyle = StyleRaised!

display_mode = "OBJ"
refresh()

end event

type st_page from statictext within u_soap_page_problem_list
boolean visible = false
integer x = 2546
integer y = 2008
integer width = 256
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean focusrectangle = false
end type

type st_problem_list_title from statictext within u_soap_page_problem_list
integer x = 1143
integer y = 56
integer width = 1129
integer height = 76
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Assessments and Treatments"
boolean focusrectangle = false
end type

event clicked;dw_soap_display.setfocus()

end event

type st_include_cancelled from statictext within u_soap_page_problem_list
integer x = 2432
integer y = 2008
integer width = 160
integer height = 116
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Incl Cancld"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if dw_soap_display.show_deleted then
	dw_soap_display.show_deleted = false
	BorderStyle = StyleRaised!
else
	dw_soap_display.show_deleted = true
	BorderStyle = StyleLowered!
end if

refresh()

end event

type p_rtf from picture within u_soap_page_problem_list
integer x = 1202
integer y = 2008
integer width = 137
integer height = 116
boolean bringtotop = true
string picturename = "icon_rtf.bmp"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup_return popup_return
integer li_sts

BorderStyle = StyleLowered!
p_atat.BorderStyle = StyleRaised!
p_aatt.BorderStyle = StyleRaised!
p_aa.BorderStyle = StyleRaised!
p_tt.BorderStyle = StyleRaised!
p_obj.BorderStyle = StyleRaised!

display_mode = "RTF"

if isnull(display_script_id) then
	openwithparm(w_pop_yes_no, "This chart has no SOAP RTF script defined.  Do you want to create one now?")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return
	
	li_sts = new_display_script()
end if

refresh()

end event

type cb_close_multi from commandbutton within u_soap_page_problem_list
boolean visible = false
integer x = 1979
integer y = 1916
integer width = 311
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Close"
end type

event clicked;integer li_sts
long ll_row
str_popup_return popup_return
long ll_treatment_id
string ls_soap_type
string ls_null
long ll_null
integer li_null
integer li_index
long ll_count
long ll_closed_count
str_assessment_description lstr_assessment
str_treatment_description lstr_treatment
string ls_object_key
long ll_problem_id
string ls_problem_id
string ls_diagnosis_sequence

setnull(ls_null)
setnull(ll_null)
setnull(li_null)

ll_row = dw_soap_display.get_selected_row()
if ll_row > 0 then
	ls_soap_type = dw_soap_display.object.soap_type[ll_row]
	if ls_soap_type = "TREATCHILD" then ls_soap_type = "TREATMENT"

	openwithparm(w_pop_yes_no, "This operation will close all of the selected " + lower(ls_soap_type) + "s.  You will not have an opportunity to specify any quality metrics.  Are you sure you want to do this?")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return
	
	ll_count = dw_soap_display.count_selected()
	
	ll_closed_count = 0
	li_index = f_please_wait_open()
	f_please_wait_progress_bar(li_index, ll_closed_count, ll_count)
	
	DO WHILE ll_row > 0
		ls_soap_type = dw_soap_display.object.soap_type[ll_row]
		if ls_soap_type = "TREATCHILD" then ls_soap_type = "TREATMENT"
		ls_object_key = dw_soap_display.object.key[ll_row]
		if len(ls_object_key) > 0 then
			CHOOSE CASE ls_soap_type
				CASE "ASSESSMENT"
					f_split_string(ls_object_key, ",", ls_problem_id, ls_diagnosis_sequence)
					ll_problem_id = long(ls_problem_id)
					li_sts = current_patient.assessments.assessment(lstr_assessment, ll_problem_id)
					if li_sts > 0 then
						if isnull(lstr_assessment.assessment_status) or lower(lstr_assessment.assessment_status) = "open" then
							li_sts = f_set_patient_object_progress(current_patient.cpr_id, &
																			"Assessment", &
																			ll_problem_id, &
																			"CLOSED", &
																			ls_null, &
																			ls_null, &
																			datetime(today(), now()), &
																			ll_null, &
																			ll_null, &
																			current_service.patient_workplan_item_id, &
																			li_null, &
																			ls_null, &
																			current_user.user_id, &
																			false)
							
							current_patient.assessments.set_assessment_changed(ll_problem_id)
						end if
					end if
				CASE "TREATMENT"
					ll_treatment_id = long(ls_object_key)
					li_sts = current_patient.treatments.treatment(lstr_treatment, ll_treatment_id)
					if li_sts > 0 then
						if isnull(lstr_treatment.treatment_status) or lower(lstr_treatment.treatment_status) = "open" then
							li_sts = f_set_patient_object_progress(current_patient.cpr_id, &
																			"Treatment", &
																			ll_treatment_id, &
																			"CLOSED", &
																			ls_null, &
																			ls_null, &
																			datetime(today(), now()), &
																			ll_null, &
																			ll_null, &
																			current_service.patient_workplan_item_id, &
																			li_null, &
																			ls_null, &
																			current_user.user_id, &
																			false)
							
							current_patient.treatments.set_treatment_changed(ll_treatment_id)
						end if
					end if
			END CHOOSE
		end if
		ll_closed_count += 1
		f_please_wait_progress_bar(li_index, ll_closed_count, ll_count)

		ll_row = dw_soap_display.get_selected_row(ll_row)
	LOOP
	
	f_please_wait_close(li_index)
end if

visible = false

refresh()
parent.postevent("refresh")

return

end event

type dw_soap_display from u_soap_display within u_soap_page_problem_list
integer x = 1143
integer y = 140
integer width = 1989
integer height = 1848
integer taborder = 10
boolean bringtotop = true
boolean vscrollbar = true
boolean multiselect = true
end type

event selected;call super::selected;string ls_soap_type
long ll_attachment_id
str_attributes lstr_attributes
long ll_count_selected

ls_soap_type = object.soap_type[selected_row]
if ls_soap_type = "TREATCHILD" then ls_soap_type = "TREATMENT"

if keydown(KeyControl!) then
	ll_count_selected = count_selected( )
	if ll_count_selected > 0 then
	else
		cb_close_multi.visible = false
	end if

	ll_attachment_id = object.attachment_id[selected_row]
	
	if ls_soap_type <> multi_soap_type then
		clear_selected( )
		object.selected_flag[selected_row] = 1
		multi_soap_type = ls_soap_type
	end if
	
	CHOOSE CASE ls_soap_type
		CASE "SINCELAST"
			cb_close_multi.visible = false
		CASE "PATIENT"
			cb_close_multi.visible = false
		CASE "ENCOUNTER"
			cb_close_multi.visible = false
		CASE "ASSESSMENT"
			cb_close_multi.visible = true
		CASE "TREATMENT"
			cb_close_multi.visible = true
		CASE "TREATCHILD"
			cb_close_multi.visible = true
		CASE "NOASSESSMENT"
			cb_close_multi.visible = false
		CASE "TREATHEADER"
			cb_close_multi.visible = false
		CASE ELSE
			cb_close_multi.visible = false
	END CHOOSE

	return
end if

multi_soap_type = ""
cb_close_multi.visible = false
refresh()
parent.postevent("refresh")

end event

event computed_clicked;call super::computed_clicked;refresh()
parent.postevent("refresh")
end event

event getfocus;call super::getfocus;dw_soap_display.setfocus()
end event

event key_down;call super::key_down;key_down(key, keyflags)

end event

type u_rtf from u_rich_text_edit within u_soap_page_problem_list
boolean visible = false
integer x = 1143
integer y = 144
integer width = 1989
integer height = 1848
borderstyle borderstyle = stylebox!
end type

type st_encounter_id from u_soap_page_base`st_encounter_id within u_soap_page_problem_list
end type

type cb_prev from u_soap_page_base`cb_prev within u_soap_page_problem_list
end type

type cb_next from u_soap_page_base`cb_next within u_soap_page_problem_list
end type

type pb_summary from u_soap_page_base`pb_summary within u_soap_page_problem_list
end type

type st_encounter from u_soap_page_base`st_encounter within u_soap_page_problem_list
end type

type st_encounter_background from u_soap_page_base`st_encounter_background within u_soap_page_problem_list
end type

type st_encounter_status from u_soap_page_base`st_encounter_status within u_soap_page_problem_list
end type


Start of PowerBuilder Binary Data Section : Do NOT Edit
05u_soap_page_problem_list.bin 
2B00001600e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd00000008fffffffe0000000400000005000000060000000700000009fffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff00000003000000000000000000000000000000000000000000000000000000005d2ced1001ca361c0000000300000bc00000000000500003004c004200430049004e0045004500530045004b000000590000000000000000000000000000000000000000000000000000000000000000000000000002001cffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000001a0000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000002001affffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000001000007d900000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000101001a000000020000000100000004ab949ac111d9ec9740002b9ed2aba905000000005d2ced1001ca361c5d2ced1001ca361c000000000000000000000000fffffffe00000002000000030000000400000005000000060000000700000008000000090000000a0000000b0000000c0000000d0000000e0000000f000000100000001100000012000000130000001400000015000000160000001700000018000000190000001a0000001b0000001c0000001d0000001e0000001f00000020fffffffe00000022000000230000002400000025000000260000002700000028000000290000002a0000002b0000002c0000002d0000002efffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
27ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff005000540039002d0034003400320037003800340039003500640034004200000064006f006e006f002000690054004d005000200073006f00650074002000720000fffe00020205ab949ac111d9ec9740002b9ed2aba90500000001fb8f0821101b01640008ed8413c72e2b00000030000007a90000003600000100000001b800000101000001c000000102000001c800000103000001d000000104000001d800000105000001e000000106000001e800000107000001f000000108000001f800000109000002000000010a000002080000010b000002100000010c000002180000010d000002200000010e000002280000010f000002300000011000000238000001110000024000000112000002480000011300000250000001140000028c0000011500000294000001160000029c00000117000002a400000118000002ac00000119000002b40000011a000002bc0000011b000002c40000011c000002cc0000011d000002d40000011e000002dc0000011f000002ec00000120000002f400000121000002fc0000012200000304000001230000030c0000012400000314000001250000031c0000012600000324000001270000032c0000012800000334000001290000033c0000012a000003440000012b0000034c0000012c000003540000012d0000035c0000012e000003640000012f0000036c0000013000000374000001310000037c00000132000003880000013300000390000001340000039800000000000003a000000003000100070000000300002cf50000000300002fc000000003000000490000000200000001000000020000000100000002000000010000000b0000000000000002000000000000000b0000ffff0000000b0000ffff0000000200000000000000020000006400000002000000030000000b000000000000000b0000ffff00000002000000000000000b0000ffff0000000b000000000000000800000031505c3a4352474f525c317e4149454854317e414d5458545c7e5458455c302e335c6e694252454d414e4143494454562e0000000000000002000000030000000300002fd00000000300003de000000003000005a000000003000005a000000003000005a000000003000005a000000002000000640000000b000000000000000b0000ffff0000000800000006616972410000006c000000020000000c0000000b000000000000000b000000000000000b000000000000000b0000000000000002000000000000000300ffffff0000000200000000000000020000006400000002000000000000000200000020000000020000000000000002000000140000000200000000000000020000000000000002000000000000000200000000000000020000000000000008000000010000000000000002000000010000000b0000ffff0000000b0000ffff0000003600000000000000010001330000000a006c6c61006e75776f32006f640d000001770000007764726f6d7061720065646f00000112000000106d726f66657374617463656c006e6f69000001090000000e65646968656c65736f6974630108006e00090000646500006f6d7469280065640d0000016c00000073656e69696361700074676e000001190000000c656761706772616d00726e69000001070000000d746e6f63636c6f727372616800012d0000000800646e690072746e6500011e00000009006e6f66006d616e74011a0065000c000061700000616d65676e696772010e0062000d00006c6300006863706972646c6930006e6508000001690000006e65646e180062740c000001700000006d656761696772611500746e0a00000170000000776567616874646900010b0000000d00756f6d006f70657365746e6901060072000a00006162000074736b6300656c790000013400000015747865746d61726672616d656c72656b73656e6900012f0000000800646e690074746e650001270000000c006e696c0061707365676e696300010c0000000b006f6f7a006361666d00726f740000010a0000000e65736e696f697472646f6d6e012a0065000e00007266000064656d61617473690065636e000001130000001270737476646c6c656974636972616e6f01030079000c0000735f00006b636f74706f727001210073000b00006f6600007469746e63696c6100011000000009007a697300646f6d6501050065000c00006f620000726564726c79747301260065000a00006c6100006d6e676900746e65000001240000000965736162656e696c0001160000000b00676170006965686500746867000001250000000c747865746f636b6200726f6c000001230000000e746e6f6665646e756e696c7201220065000f00006f6600007473746e656b69727572687400011f00000009006e6f66007a69737401110065000700006174000079656b6200012b0000000f0061726600696c656d6977656e00687464000001290000000b6d617266797473650100656c090000015f000000657478650078746e0000012000000009746e6f66646c6f62000102000000090078655f00746e6574011d0079000c00007270000063746e69726f6c6f01170073000c000061700000616d65676e696772010d006c00090000697600006f6d77652c00656408000001690000006e65646e2e006c740900000169000000
2A6e65646e006c667400000131000000057478657400011c0000000c0069727000666f746e7465736600011b0000000a00697270006f7a746e14006d6f0b000001730000006c6f72637261626c0104007300090000616c00006175676e00006567090000015f00000073726576006e6f690000010f0000000d70696c636c62697373676e69000000000000000000000000000000000000000000000000000000000000000000000000000000000001000700002cf500002fc0000000490000000000ffffff0100010100000100010100000064000001000003000100005c3a4330474f5250317e41524548545c7e414d4958545c3154584554302e337e6e69425c454d415c4143495254562e4e03000044002fd000003de0000005a0000005a0000005a0000005a00000006400724105010c6c616900000000ff0000000000ffff00006400000020000000140000000000000000000100000001010001000002ba000104b10000000e00000000000000000000000200000144000100010001000100000000000000000001001f00000001000000000000000000000000ff10500000000000019000000000000022020000616972410000006c0000000000000000000000000000000000000000000000000001000100000001000000000000000000640000001400206e01000008dc0104010d4a01260111b81a940116011f0201de0123702c4c01270130ba01960135283e0401390000000000000000000000000000000000720041006100690000006c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000210000036e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004e400010001010002092e000000ffffb70000000000000000000000000000000000000000010000000000000000000000000001000000000000000000000000000000000000000000000000015400000030000000000000000005a0000005a0000000ffffff0000000000000000000000010000000000000000000000000000012400000001ff10000000000000019000000000000022020000616972410000006c0000000000000000000000000000000000000000000000000000000000000000000000000000000000720041006100690000006c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000005000000000000000000000640000001400206e01000008dc0104010d4a01260111b81a940116011f0201de0123702c4c01270130ba01960135283e04013900010001010002092e000000ffffb7000000000000000000000000000000000000120000000000000000000000000000000000000000000000000000005b0000006f004e006d0072006c00610000005d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
15u_soap_page_problem_list.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
