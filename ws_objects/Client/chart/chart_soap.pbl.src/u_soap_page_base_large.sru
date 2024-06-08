$PBExportHeader$u_soap_page_base_large.sru
$PBExportComments$show button bar for doing test from observation & treatment types..
forward
global type u_soap_page_base_large from u_cpr_page_base
end type
type st_coding_title from statictext within u_soap_page_base_large
end type
type st_all from statictext within u_soap_page_base_large
end type
type st_indirect from statictext within u_soap_page_base_large
end type
type st_direct from statictext within u_soap_page_base_large
end type
type st_button_12 from statictext within u_soap_page_base_large
end type
type st_button_9 from statictext within u_soap_page_base_large
end type
type st_button_7 from statictext within u_soap_page_base_large
end type
type st_button_11 from statictext within u_soap_page_base_large
end type
type st_button_10 from statictext within u_soap_page_base_large
end type
type st_button_8 from statictext within u_soap_page_base_large
end type
type pb_12 from u_picture_button within u_soap_page_base_large
end type
type pb_11 from u_picture_button within u_soap_page_base_large
end type
type pb_10 from u_picture_button within u_soap_page_base_large
end type
type pb_9 from u_picture_button within u_soap_page_base_large
end type
type pb_8 from u_picture_button within u_soap_page_base_large
end type
type pb_7 from u_picture_button within u_soap_page_base_large
end type
type dw_encounters from u_dw_pick_list within u_soap_page_base_large
end type
type cb_coding from commandbutton within u_soap_page_base_large
end type
type pb_4 from u_picture_button within u_soap_page_base_large
end type
type cb_current from commandbutton within u_soap_page_base_large
end type
type pb_1 from u_picture_button within u_soap_page_base_large
end type
type pb_5 from u_picture_button within u_soap_page_base_large
end type
type pb_2 from u_picture_button within u_soap_page_base_large
end type
type pb_3 from u_picture_button within u_soap_page_base_large
end type
type pb_6 from u_picture_button within u_soap_page_base_large
end type
type st_button_1 from statictext within u_soap_page_base_large
end type
type st_button_2 from statictext within u_soap_page_base_large
end type
type st_button_3 from statictext within u_soap_page_base_large
end type
type st_button_4 from statictext within u_soap_page_base_large
end type
type st_button_5 from statictext within u_soap_page_base_large
end type
type st_button_6 from statictext within u_soap_page_base_large
end type
type st_config_mode_menu from statictext within u_soap_page_base_large
end type
type st_encounter_count from statictext within u_soap_page_base_large
end type
type st_7 from statictext within u_soap_page_base_large
end type
type st_no_encounters from statictext within u_soap_page_base_large
end type
type str_button from structure within u_soap_page_base_large
end type
end forward

type str_button from structure
	u_picture_button		button
	statictext		button_title
	string		button_type
	string		button_key
end type

global type u_soap_page_base_large from u_cpr_page_base
integer width = 3698
integer height = 2140
st_coding_title st_coding_title
st_all st_all
st_indirect st_indirect
st_direct st_direct
st_button_12 st_button_12
st_button_9 st_button_9
st_button_7 st_button_7
st_button_11 st_button_11
st_button_10 st_button_10
st_button_8 st_button_8
pb_12 pb_12
pb_11 pb_11
pb_10 pb_10
pb_9 pb_9
pb_8 pb_8
pb_7 pb_7
dw_encounters dw_encounters
cb_coding cb_coding
pb_4 pb_4
cb_current cb_current
pb_1 pb_1
pb_5 pb_5
pb_2 pb_2
pb_3 pb_3
pb_6 pb_6
st_button_1 st_button_1
st_button_2 st_button_2
st_button_3 st_button_3
st_button_4 st_button_4
st_button_5 st_button_5
st_button_6 st_button_6
st_config_mode_menu st_config_mode_menu
st_encounter_count st_encounter_count
st_7 st_7
st_no_encounters st_no_encounters
end type
global u_soap_page_base_large u_soap_page_base_large

type variables
boolean showing_complaint

string button_type[]
string button_key[]

u_picture_button button[]
statictext button_title[]

private str_menu menu
private integer button_count
private str_button buttons[]

// Button Painting Constants
integer max_button_count = 12
integer max_button_column_count = 6

// Content Boundaries for descendent classes
long content_top_edge
long content_bottom_edge
long content_left_edge
long content_right_edge
long content_width
long content_height
long button_x

string report_service
string summary_report_id
string coding_service


long button_top_gap = 16
long button_gap = 120
long button_bottom_gap = 50
long button_height = 216
long button_side_gap = 20

string indirect_flag


end variables

forward prototypes
public subroutine refresh_subjective ()
public subroutine xx_initialize ()
public subroutine xx_refresh ()
public subroutine xx_refresh_tab ()
public subroutine refresh_tab ()
public subroutine refresh_coding ()
public function integer button_pressed (integer pi_button)
public subroutine refresh ()
public subroutine initialize (u_cpr_section puo_section, integer pi_page)
public subroutine paint_buttons ()
public function integer load_encounters ()
end prototypes

public subroutine refresh_subjective ();
end subroutine

public subroutine xx_initialize ();
end subroutine

public subroutine xx_refresh ();
end subroutine

public subroutine xx_refresh_tab ();
end subroutine

public subroutine refresh_tab ();xx_refresh_tab()

end subroutine

public subroutine refresh_coding ();integer li_encounter_level

if isnull(current_display_encounter) then
	cb_coding.visible = false
	return
end if

cb_coding.visible = true

li_encounter_level = f_current_visit_level(current_patient.cpr_id, current_display_encounter.encounter_id)

if isnull(li_encounter_level) then
	cb_coding.text = "0"
else
	cb_coding.text = string(li_encounter_level)
end if


end subroutine

public function integer button_pressed (integer pi_button);integer li_index
integer li_sts
str_attributes lstr_attributes

lstr_attributes.attribute_count = 0

if not isnull(current_display_encounter) then
	f_attribute_add_attribute(lstr_attributes, "encounter_id", string(current_display_encounter.encounter_id))
end if

if pi_button = 0 then
	li_sts = f_display_menu_remainder(menu.menu_id, false, button_count, lstr_attributes)
else
	li_sts = f_do_menu_item_with_attributes(menu.menu_id, menu.menu_item[pi_button].menu_item_id, lstr_attributes)
end if

refresh()

postevent("refresh")

return li_sts



end function

public subroutine refresh ();integer i
string ls_sts
u_user luo_attending_doctor
string ls_text
string ls_description
long ll_backcolor
long ll_count
string ls_find
long ll_row
integer li_sts
long ll_firstrowonpage
long ll_lastrowonpage
long ll_current_display_encounter_id

if dw_encounters.visible then 
	load_encounters() // to refresh the list after a new one is added
end if
if isnull(current_display_encounter) then
	ll_current_display_encounter_id = 0
else
	ll_current_display_encounter_id = current_display_encounter.encounter_id
end if

ll_count = dw_encounters.rowcount()
if ll_count > 0 then
	// Set the encounter counter
	ls_find = "encounter_id=" + string(ll_current_display_encounter_id)
	ll_row = dw_encounters.find(ls_find, 1, ll_count)
	if isnull(ll_row) or ll_row <= 0 then ll_row = 1
	
	ll_firstrowonpage = long(dw_encounters.Object.DataWindow.FirstRowOnPage)
	ll_lastrowonpage = long(dw_encounters.Object.DataWindow.LastRowOnPage)
	if ll_row < ll_firstrowonpage or ll_row > ll_lastrowonpage then
		dw_encounters.scrolltorow(ll_row)
	end if
	
	dw_encounters.clear_selected()
	dw_encounters.object.selected_flag[ll_row] = 1
else
	dw_encounters.visible = false
	st_encounter_count.visible = false
	st_no_encounters.visible = true
end if

if ll_row > 0 then
	st_encounter_count.text = string(ll_count - ll_row + 1) + " of " + string(ll_count)
end if

// If we're not displaying the service encounter then display the "current" button
cb_current.visible = true
if Not IsNull(current_service) then
	if Not IsNull(current_service.encounter_id) then
		if ll_current_display_encounter_id = current_service.encounter_id then
			cb_current.visible = false
		end if
	end if
end if

refresh_coding()


xx_refresh()

this_section.refresh_other_tabs(this_page)

st_config_mode_menu.setposition(ToTop!)


end subroutine

public subroutine initialize (u_cpr_section puo_section, integer pi_page);integer i
string ls_temp

this_section = puo_section
this_page = pi_page

// Get the menu id
this_section.load_params(this_page)
ls_temp = this_section.get_attribute(this_section.page[this_page].page_id, "menu_id")
if isnull(ls_temp) then
	setnull(menu.menu_id)
else
	menu = datalist.get_menu(long(ls_temp))
end if

summary_report_id = this_section.get_attribute(this_section.page[this_page].page_id, "summary_report_id")
if isnull(summary_report_id) then
	summary_report_id = datalist.get_preference("PREFERENCES", "summary_report_id")
end if
if isnull(summary_report_id) then summary_report_id = "{330C8DB2-A65C-46C1-A58B-72CE6C5B7DC9}"  // Encounter SOAP Note

report_service = this_section.get_attribute(this_section.page[this_page].page_id, "report_service")
if isnull(report_service) then report_service = "REPORT"

coding_service = this_section.get_attribute(this_section.page[this_page].page_id, "coding_service")
if isnull(coding_service) then coding_service = "EMCODING"


// Initialize indirect flag
st_indirect.backcolor = color_object
st_direct.backcolor = color_object
st_all.backcolor = color_object
ls_temp = this_section.get_attribute(this_section.page[this_page].page_id, "default_indirect_flag_filter")
CHOOSE CASE lower(ls_temp)
	CASE "direct"
		indirect_flag = "D"
		st_direct.backcolor = color_object_selected
	CASE "indirect"
		indirect_flag = "I"
		st_indirect.backcolor = color_object_selected
	CASE ELSE
		indirect_flag = "%"
		st_all.backcolor = color_object_selected
END CHOOSE
		

paint_buttons()


// Position objects
content_top_edge = dw_encounters.y
content_bottom_edge = height - 20
content_left_edge = dw_encounters.x + dw_encounters.width + 20
if button_x > 0 then
	content_right_edge = button_x - 20
else
	content_right_edge = width - 20
end if
content_width = content_right_edge - content_left_edge
content_height = content_bottom_edge - content_top_edge

st_direct.y = content_bottom_edge - st_direct.height
st_indirect.y = st_direct.y
st_all.y = st_direct.y

st_encounter_count.y = st_direct.y - st_encounter_count.height - 8

dw_encounters.height = st_encounter_count.y - dw_encounters.y - 20

cb_coding.x = content_right_edge - cb_coding.width
st_coding_title.x = cb_coding.x - st_coding_title.width - 8

if config_mode then
	st_config_mode_menu.visible = true
	st_config_mode_menu.setposition(ToTop!)
	st_config_mode_menu.text = menu.description
	st_config_mode_menu.text += " (" + string(menu.menu_id) + ")"
	st_config_mode_menu.x =	width - st_config_mode_menu.width - 4
	st_config_mode_menu.y =	height - st_config_mode_menu.height - 4
else
	st_config_mode_menu.visible = false
end if

load_encounters()

if dw_encounters.rowcount() = 0 and indirect_flag <> "%" then
	indirect_flag = "%"
	st_indirect.backcolor = color_object
	st_direct.backcolor = color_object
	st_all.backcolor = color_object_selected
	load_encounters()
end if

xx_initialize()


end subroutine

public subroutine paint_buttons ();str_button lstra_buttons[]
integer li_button_fit
integer i
integer li_count
string ls_temp
long ll_left_column
long ll_right_column

// Put the buttons in an array so we can reference them by an index
lstra_buttons[1].button = pb_1
lstra_buttons[2].button = pb_2
lstra_buttons[3].button = pb_3
lstra_buttons[4].button = pb_4
lstra_buttons[5].button = pb_5
lstra_buttons[6].button = pb_6
lstra_buttons[7].button = pb_7
lstra_buttons[8].button = pb_8
lstra_buttons[9].button = pb_9
lstra_buttons[10].button = pb_10
lstra_buttons[11].button = pb_11
lstra_buttons[12].button = pb_12

lstra_buttons[1].button_title = st_button_1
lstra_buttons[2].button_title = st_button_2
lstra_buttons[3].button_title = st_button_3
lstra_buttons[4].button_title = st_button_4
lstra_buttons[5].button_title = st_button_5
lstra_buttons[6].button_title = st_button_6
lstra_buttons[7].button_title = st_button_7
lstra_buttons[8].button_title = st_button_8
lstra_buttons[9].button_title = st_button_9
lstra_buttons[10].button_title = st_button_10
lstra_buttons[11].button_title = st_button_11
lstra_buttons[12].button_title = st_button_12

ll_right_column = width - pb_1.width - button_side_gap
ll_left_column = ll_right_column - pb_7.width - button_side_gap

// Move them
for i = 1 to 6
	lstra_buttons[i].button.x = ll_left_column
	lstra_buttons[i].button_title.x = ll_left_column
next
for i = 7 to 12
	lstra_buttons[i].button.x = ll_right_column
	lstra_buttons[i].button_title.x = ll_right_column
next

// Determine how many buttons high will fit
li_button_fit = (height - button_top_gap - button_bottom_gap) / (button_height + button_gap)
if li_button_fit > 6 then li_button_fit = 6

if isnull(menu.menu_id) then
	button_count = 0
elseif menu.menu_item_count <= li_button_fit then
	// All the menu items will fit in a single button column
	for i = 1 to menu.menu_item_count
		// Make the right column the menu items
		buttons[i] = lstra_buttons[i + max_button_column_count]
	next
	button_count = menu.menu_item_count
	
	// The button left edge is the right column of buttons
	button_x = lstra_buttons[max_button_column_count + 1].button.x
else
	if menu.menu_item_count > li_button_fit and menu.menu_item_count <= (2 * li_button_fit) then
		// All the menu items will fit in a two button columns
		button_count = menu.menu_item_count
	else
		// Not all buttons will fit
		button_count = 2 * li_button_fit
	end if

	// Make the left column the odd menu items
	for i = 1 to button_count step 2
		buttons[i] = lstra_buttons[(i / 2) + 1]
	next

	// Make the right column the even menu items
	for i = 2 to button_count step 2
		buttons[i] = lstra_buttons[(i / 2) + 6]
	next

	// The button left edge is the left column of buttons
	button_x = lstra_buttons[1].button.x
end if

for i = 1 to button_count
	buttons[i].button.picturename = menu.menu_item[i].button
	buttons[i].button.visible = true
	buttons[i].button_title.text = menu.menu_item[i].button_title
	buttons[i].button_title.visible = true
	buttons[i].button.button_index = i
next

// If there are more menu items than buttons then redefine the last button to be "Other Items"
if menu.menu_item_count > button_count then
	i = button_count
	ls_temp = datalist.get_preference("PREFERENCES", "menu_remainder_button", "button21.bmp")
	buttons[i].button.picturename = ls_temp
	buttons[i].button_title.text = "Other Items"
	buttons[i].button.button_index = 0
end if


end subroutine

public function integer load_encounters ();long ll_count
dw_encounters.settransobject(sqlca)
ll_count = dw_encounters.retrieve(current_patient.cpr_id, indirect_flag)
if ll_count <= 0 then
	dw_encounters.visible = false
	st_encounter_count.visible = false
	st_no_encounters.visible = true
	if ll_count < 0 then
		return -1
	else
		return 0
	end if
end if


dw_encounters.visible = true
st_encounter_count.visible = true
st_no_encounters.visible = false

return 1

end function

on u_soap_page_base_large.create
int iCurrent
call super::create
this.st_coding_title=create st_coding_title
this.st_all=create st_all
this.st_indirect=create st_indirect
this.st_direct=create st_direct
this.st_button_12=create st_button_12
this.st_button_9=create st_button_9
this.st_button_7=create st_button_7
this.st_button_11=create st_button_11
this.st_button_10=create st_button_10
this.st_button_8=create st_button_8
this.pb_12=create pb_12
this.pb_11=create pb_11
this.pb_10=create pb_10
this.pb_9=create pb_9
this.pb_8=create pb_8
this.pb_7=create pb_7
this.dw_encounters=create dw_encounters
this.cb_coding=create cb_coding
this.pb_4=create pb_4
this.cb_current=create cb_current
this.pb_1=create pb_1
this.pb_5=create pb_5
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_6=create pb_6
this.st_button_1=create st_button_1
this.st_button_2=create st_button_2
this.st_button_3=create st_button_3
this.st_button_4=create st_button_4
this.st_button_5=create st_button_5
this.st_button_6=create st_button_6
this.st_config_mode_menu=create st_config_mode_menu
this.st_encounter_count=create st_encounter_count
this.st_7=create st_7
this.st_no_encounters=create st_no_encounters
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_coding_title
this.Control[iCurrent+2]=this.st_all
this.Control[iCurrent+3]=this.st_indirect
this.Control[iCurrent+4]=this.st_direct
this.Control[iCurrent+5]=this.st_button_12
this.Control[iCurrent+6]=this.st_button_9
this.Control[iCurrent+7]=this.st_button_7
this.Control[iCurrent+8]=this.st_button_11
this.Control[iCurrent+9]=this.st_button_10
this.Control[iCurrent+10]=this.st_button_8
this.Control[iCurrent+11]=this.pb_12
this.Control[iCurrent+12]=this.pb_11
this.Control[iCurrent+13]=this.pb_10
this.Control[iCurrent+14]=this.pb_9
this.Control[iCurrent+15]=this.pb_8
this.Control[iCurrent+16]=this.pb_7
this.Control[iCurrent+17]=this.dw_encounters
this.Control[iCurrent+18]=this.cb_coding
this.Control[iCurrent+19]=this.pb_4
this.Control[iCurrent+20]=this.cb_current
this.Control[iCurrent+21]=this.pb_1
this.Control[iCurrent+22]=this.pb_5
this.Control[iCurrent+23]=this.pb_2
this.Control[iCurrent+24]=this.pb_3
this.Control[iCurrent+25]=this.pb_6
this.Control[iCurrent+26]=this.st_button_1
this.Control[iCurrent+27]=this.st_button_2
this.Control[iCurrent+28]=this.st_button_3
this.Control[iCurrent+29]=this.st_button_4
this.Control[iCurrent+30]=this.st_button_5
this.Control[iCurrent+31]=this.st_button_6
this.Control[iCurrent+32]=this.st_config_mode_menu
this.Control[iCurrent+33]=this.st_encounter_count
this.Control[iCurrent+34]=this.st_7
this.Control[iCurrent+35]=this.st_no_encounters
end on

on u_soap_page_base_large.destroy
call super::destroy
destroy(this.st_coding_title)
destroy(this.st_all)
destroy(this.st_indirect)
destroy(this.st_direct)
destroy(this.st_button_12)
destroy(this.st_button_9)
destroy(this.st_button_7)
destroy(this.st_button_11)
destroy(this.st_button_10)
destroy(this.st_button_8)
destroy(this.pb_12)
destroy(this.pb_11)
destroy(this.pb_10)
destroy(this.pb_9)
destroy(this.pb_8)
destroy(this.pb_7)
destroy(this.dw_encounters)
destroy(this.cb_coding)
destroy(this.pb_4)
destroy(this.cb_current)
destroy(this.pb_1)
destroy(this.pb_5)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_6)
destroy(this.st_button_1)
destroy(this.st_button_2)
destroy(this.st_button_3)
destroy(this.st_button_4)
destroy(this.st_button_5)
destroy(this.st_button_6)
destroy(this.st_config_mode_menu)
destroy(this.st_encounter_count)
destroy(this.st_7)
destroy(this.st_no_encounters)
end on

type cb_configure_tab from u_cpr_page_base`cb_configure_tab within u_soap_page_base_large
end type

type st_coding_title from statictext within u_soap_page_base_large
integer x = 2350
integer y = 28
integer width = 640
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "E && M Coding Level:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_all from statictext within u_soap_page_base_large
integer x = 873
integer y = 2040
integer width = 325
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "All"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_direct.backcolor = color_object
st_indirect.backcolor = color_object

indirect_flag = "%"

load_encounters()

refresh()

end event

type st_indirect from statictext within u_soap_page_base_large
integer x = 457
integer y = 2040
integer width = 325
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Indirect"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_direct.backcolor = color_object
st_all.backcolor = color_object

indirect_flag = "I"

load_encounters()

refresh()

end event

type st_direct from statictext within u_soap_page_base_large
integer x = 41
integer y = 2040
integer width = 325
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Direct"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_indirect.backcolor = color_object
st_all.backcolor = color_object

indirect_flag = "D"

load_encounters()

refresh()

end event

type st_button_12 from statictext within u_soap_page_base_large
boolean visible = false
integer x = 3433
integer y = 1912
integer width = 247
integer height = 112
integer textsize = -8
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

type st_button_9 from statictext within u_soap_page_base_large
boolean visible = false
integer x = 3433
integer y = 904
integer width = 247
integer height = 112
integer textsize = -8
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

type st_button_7 from statictext within u_soap_page_base_large
boolean visible = false
integer x = 3433
integer y = 232
integer width = 247
integer height = 112
integer textsize = -8
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

type st_button_11 from statictext within u_soap_page_base_large
boolean visible = false
integer x = 3433
integer y = 1576
integer width = 247
integer height = 112
integer textsize = -8
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

type st_button_10 from statictext within u_soap_page_base_large
boolean visible = false
integer x = 3433
integer y = 1240
integer width = 247
integer height = 112
integer textsize = -8
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

type st_button_8 from statictext within u_soap_page_base_large
boolean visible = false
integer x = 3433
integer y = 568
integer width = 247
integer height = 112
integer textsize = -8
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

type pb_12 from u_picture_button within u_soap_page_base_large
boolean visible = false
integer x = 3433
integer y = 1696
integer taborder = 30
boolean originalsize = false
string picturename = ""
string disabledname = ""
end type

event clicked;button_pressed(button_index)
end event

type pb_11 from u_picture_button within u_soap_page_base_large
boolean visible = false
integer x = 3433
integer y = 1360
integer taborder = 30
boolean originalsize = false
string picturename = ""
string disabledname = ""
end type

event clicked;button_pressed(button_index)
end event

type pb_10 from u_picture_button within u_soap_page_base_large
boolean visible = false
integer x = 3433
integer y = 1024
integer taborder = 30
boolean originalsize = false
string picturename = ""
string disabledname = ""
end type

event clicked;button_pressed(button_index)
end event

type pb_9 from u_picture_button within u_soap_page_base_large
boolean visible = false
integer x = 3433
integer y = 688
integer taborder = 40
boolean originalsize = false
string picturename = ""
string disabledname = ""
end type

event clicked;button_pressed(button_index)
end event

type pb_8 from u_picture_button within u_soap_page_base_large
boolean visible = false
integer x = 3433
integer y = 352
integer taborder = 30
string picturename = ""
string disabledname = ""
end type

event clicked;button_pressed(button_index)
end event

type pb_7 from u_picture_button within u_soap_page_base_large
boolean visible = false
integer x = 3433
integer y = 16
integer taborder = 40
boolean originalsize = false
string picturename = ""
string disabledname = ""
end type

event clicked;button_pressed(button_index)
end event

type dw_encounters from u_dw_pick_list within u_soap_page_base_large
integer x = 18
integer y = 132
integer width = 1216
integer height = 1836
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_sp_get_encounter_list_small"
boolean border = false
boolean select_computed = false
end type

event selected;call super::selected;integer li_sts
long ll_encounter_id
string ls_encounter_status
string ls_context
string ls_key1
string ls_key2

ll_encounter_id = object.encounter_id[selected_row]
ls_encounter_status = object.encounter_status[selected_row]

li_sts = f_set_current_encounter(ll_encounter_id)

refresh()


end event

event computed_clicked;call super::computed_clicked;str_service_info lstr_service
long ll_encounter_id
string ls_cpr_id
long ll_menu_id

ls_cpr_id = object.cpr_id[clicked_row]
ll_encounter_id = object.encounter_id[clicked_row]
if isnull(ll_encounter_id) or ll_encounter_id <= 0 then return

f_attribute_add_attribute(lstr_service.attributes, "context_object", "Encounter")
f_attribute_add_attribute(lstr_service.attributes, "cpr_id", ls_cpr_id)
f_attribute_add_attribute(lstr_service.attributes, "encounter_id", string(ll_encounter_id))

if lastcolumnname = "compute_menu" then
	lstr_service.service = "Encounter Review"
	service_list.do_service(lstr_service)
elseif lastcolumnname = "compute_document_status" then
	f_manage_documents("Encounter", ls_cpr_id, ll_encounter_id)
elseif lastcolumnname = "compute_summary" then
	chart_page_attribute("summary_menu_id", ll_menu_id)
	if ll_menu_id > 0 then
		f_display_menu_with_attributes(ll_menu_id, true, lstr_service.attributes)
	else
		f_attribute_add_attribute(lstr_service.attributes, "report_id", summary_report_id)
		f_attribute_add_attribute(lstr_service.attributes, "destination", "SCREEN")
		lstr_service.service = report_service
		service_list.do_service(lstr_service)
	end if
end if


end event

type cb_coding from commandbutton within u_soap_page_base_large
integer x = 2994
integer y = 20
integer width = 133
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "1"
end type

event clicked;str_attributes lstr_attributes

if isnull(current_display_encounter) then return

service_list.do_service(coding_service)


refresh_coding()

end event

type pb_4 from u_picture_button within u_soap_page_base_large
boolean visible = false
integer x = 3163
integer y = 1024
integer taborder = 30
boolean originalsize = false
string picturename = ""
string disabledname = ""
end type

event clicked;button_pressed(button_index)
end event

type cb_current from commandbutton within u_soap_page_base_large
integer x = 9
integer y = 8
integer width = 133
integer height = 88
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cur"
end type

event clicked;integer li_sts

if Not IsNull(current_service) then
	if Not IsNull(current_service.encounter_id) then
		li_sts = f_set_current_encounter(current_service.encounter_id)
	end if
end if

refresh()

end event

type pb_1 from u_picture_button within u_soap_page_base_large
boolean visible = false
integer x = 3163
integer y = 16
integer taborder = 20
string picturename = ""
string disabledname = ""
end type

event clicked;button_pressed(button_index)

end event

type pb_5 from u_picture_button within u_soap_page_base_large
boolean visible = false
integer x = 3163
integer y = 1360
integer taborder = 30
boolean originalsize = false
string picturename = ""
string disabledname = ""
end type

event clicked;button_pressed(button_index)
end event

type pb_2 from u_picture_button within u_soap_page_base_large
boolean visible = false
integer x = 3163
integer y = 352
integer taborder = 20
boolean originalsize = false
string picturename = ""
string disabledname = ""
end type

event clicked;button_pressed(button_index)
end event

type pb_3 from u_picture_button within u_soap_page_base_large
boolean visible = false
integer x = 3163
integer y = 688
integer taborder = 20
boolean originalsize = false
string picturename = ""
string disabledname = ""
end type

event clicked;button_pressed(button_index)
end event

type pb_6 from u_picture_button within u_soap_page_base_large
boolean visible = false
integer x = 3163
integer y = 1696
integer taborder = 20
boolean originalsize = false
string picturename = ""
string disabledname = ""
end type

event clicked;button_pressed(button_index)
end event

type st_button_1 from statictext within u_soap_page_base_large
boolean visible = false
integer x = 3163
integer y = 232
integer width = 247
integer height = 112
integer textsize = -8
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

type st_button_2 from statictext within u_soap_page_base_large
boolean visible = false
integer x = 3163
integer y = 568
integer width = 247
integer height = 112
integer textsize = -8
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

type st_button_3 from statictext within u_soap_page_base_large
boolean visible = false
integer x = 3163
integer y = 904
integer width = 247
integer height = 112
integer textsize = -8
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

type st_button_4 from statictext within u_soap_page_base_large
boolean visible = false
integer x = 3163
integer y = 1240
integer width = 247
integer height = 112
integer textsize = -8
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

type st_button_5 from statictext within u_soap_page_base_large
boolean visible = false
integer x = 3163
integer y = 1576
integer width = 247
integer height = 112
integer textsize = -8
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

type st_button_6 from statictext within u_soap_page_base_large
boolean visible = false
integer x = 3163
integer y = 1912
integer width = 247
integer height = 112
integer textsize = -8
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

type st_config_mode_menu from statictext within u_soap_page_base_large
boolean visible = false
integer x = 2706
integer y = 2088
integer width = 997
integer height = 48
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
alignment alignment = right!
boolean focusrectangle = false
end type

event clicked;str_popup popup
w_menu_display lw_menu_display

SELECT CAST(id AS varchar(38))
INTO :popup.items[1]
FROM c_menu
WHERE menu_id = :menu.menu_id;
if not tf_check() then return
popup.items[2] = f_boolean_to_string(true)
popup.data_row_count = 2
openwithparm(lw_menu_display, popup, "w_menu_display")

end event

type st_encounter_count from statictext within u_soap_page_base_large
integer x = 37
integer y = 1980
integer width = 247
integer height = 40
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "100 of 100"
boolean focusrectangle = false
end type

type st_7 from statictext within u_soap_page_base_large
integer x = 146
integer y = 52
integer width = 901
integer height = 72
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "Appointments"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_no_encounters from statictext within u_soap_page_base_large
integer x = 46
integer y = 636
integer width = 965
integer height = 344
integer textsize = -22
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "No Appointments"
alignment alignment = center!
boolean focusrectangle = false
end type

