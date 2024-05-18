$PBExportHeader$u_soap_page_base.sru
$PBExportComments$show button bar for doing test from observation & treatment types..
forward
global type u_soap_page_base from u_cpr_page_base
end type
type st_encounter_id from statictext within u_soap_page_base
end type
type cb_coding from commandbutton within u_soap_page_base
end type
type st_no_encounters from statictext within u_soap_page_base
end type
type pb_4 from u_picture_button within u_soap_page_base
end type
type cb_current from commandbutton within u_soap_page_base
end type
type cb_prev from commandbutton within u_soap_page_base
end type
type cb_next from commandbutton within u_soap_page_base
end type
type pb_1 from u_picture_button within u_soap_page_base
end type
type pb_5 from u_picture_button within u_soap_page_base
end type
type pb_2 from u_picture_button within u_soap_page_base
end type
type pb_3 from u_picture_button within u_soap_page_base
end type
type pb_6 from u_picture_button within u_soap_page_base
end type
type pb_summary from u_picture_button within u_soap_page_base
end type
type st_button_1 from statictext within u_soap_page_base
end type
type st_button_2 from statictext within u_soap_page_base
end type
type st_button_3 from statictext within u_soap_page_base
end type
type st_button_4 from statictext within u_soap_page_base
end type
type st_button_5 from statictext within u_soap_page_base
end type
type st_button_6 from statictext within u_soap_page_base
end type
type st_encounter from statictext within u_soap_page_base
end type
type st_encounter_background from statictext within u_soap_page_base
end type
type st_config_mode_menu from statictext within u_soap_page_base
end type
type st_encounter_status from statictext within u_soap_page_base
end type
type st_encounter_count from statictext within u_soap_page_base
end type
end forward

global type u_soap_page_base from u_cpr_page_base
st_encounter_id st_encounter_id
cb_coding cb_coding
st_no_encounters st_no_encounters
pb_4 pb_4
cb_current cb_current
cb_prev cb_prev
cb_next cb_next
pb_1 pb_1
pb_5 pb_5
pb_2 pb_2
pb_3 pb_3
pb_6 pb_6
pb_summary pb_summary
st_button_1 st_button_1
st_button_2 st_button_2
st_button_3 st_button_3
st_button_4 st_button_4
st_button_5 st_button_5
st_button_6 st_button_6
st_encounter st_encounter
st_encounter_background st_encounter_background
st_config_mode_menu st_config_mode_menu
st_encounter_status st_encounter_status
st_encounter_count st_encounter_count
end type
global u_soap_page_base u_soap_page_base

type variables
boolean first_time = true
boolean showing_complaint

string button_type[]
string button_key[]
u_picture_button button[]
statictext button_title[]

str_menu menu
integer menu_button_count
integer max_button_count = 6
long button_x

string report_service
string summary_report_id
long summary_display_script_id
string coding_service

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

if pi_button <= menu_button_count then
	li_sts = f_do_menu_item(menu.menu_id, menu.menu_item[pi_button].menu_item_id)
else
	li_sts = f_display_menu_remainder(menu.menu_id, false, menu_button_count + 1, lstr_attributes)
end if

refresh()

postevent("refresh")

return li_sts



end function

public subroutine refresh ();integer i
string ls_sts
u_user luo_attending_doctor
integer li_index
string ls_text
long ll_encounter_count
string ls_description
long ll_backcolor


if isnull(current_display_encounter) then
	st_encounter.visible = false
	st_encounter_count.visible = false
	st_no_encounters.visible = true
	return
end if

st_encounter.visible = true
st_encounter_count.visible = true
st_no_encounters.visible = false

// Set the encounter description
ls_description = string(current_display_encounter.encounter_date, date_format_string)

luo_attending_doctor = user_list.find_user(current_display_encounter.attending_doctor)
if isnull(luo_attending_doctor) then
	ls_description += "  <Unknown>"
	ll_backcolor = rgb(192,192,192)
else
	ls_description += "  " + luo_attending_doctor.user_short_name
	ll_backcolor = luo_attending_doctor.color
end if

if not isnull(current_display_encounter.encounter_description) then
	ls_description += "  " + current_display_encounter.encounter_description
end if

st_encounter_status.text = wordcap(lower(current_display_encounter.encounter_status))

st_encounter.text = ls_description
st_encounter.backcolor = ll_backcolor
st_encounter_id.backcolor = ll_backcolor
st_encounter_count.backcolor = ll_backcolor
st_encounter_status.backcolor = ll_backcolor
st_encounter_background.backcolor = ll_backcolor

if len(ls_description) < 50 then
	st_encounter.textsize = -12
	st_encounter.weight = 700
elseif len(ls_description) < 58 then
	st_encounter.textsize = -10
	st_encounter.weight = 700
else
	st_encounter.textsize = -9
	st_encounter.weight = 400
end if
	
st_encounter_id.text = string(current_display_encounter.encounter_id)

// Set the encounter counter
li_index = current_patient.encounters.encounter_number(current_display_encounter.encounter_id)

ll_encounter_count = current_patient.encounters.encounter_count()

if li_index > 0 then
	st_encounter_count.visible = true
	st_encounter_count.text = string(li_index) + " of " + string(ll_encounter_count)
else
	st_encounter_count.visible = false
end if

if li_index > 1 then
	cb_prev.enabled = true
else
	cb_prev.enabled = false
end if

if li_index < ll_encounter_count then
	cb_next.enabled = true
else
	cb_next.enabled = false
end if

// If we're not displaying the service encounter then enable the "current" button
if current_display_encounter.encounter_id = current_service.encounter_id then
	cb_current.enabled = false
else
	cb_current.enabled = true
end if


refresh_coding()


xx_refresh()

this_section.refresh_other_tabs(this_page)

st_config_mode_menu.setposition(ToTop!)


end subroutine

public subroutine initialize (u_cpr_section puo_section, integer pi_page);integer i
string ls_temp
string ls_picturename
long ll_x

this_section = puo_section
this_page = pi_page

// Move objects
button_x = width - 510

pb_1.x = button_x
pb_2.x = button_x
pb_3.x = button_x
pb_4.x = button_x + 260
pb_5.x = button_x + 260
pb_6.x = button_x + 260

st_button_1.x = pb_1.x
st_button_2.x = pb_2.x
st_button_3.x = pb_3.x
st_button_4.x = pb_4.x
st_button_5.x = pb_5.x
st_button_6.x = pb_6.x

pb_summary.x = pb_4.x + pb_4.width - pb_summary.width
cb_coding.x = pb_summary.x - cb_coding.width - 12
cb_next.x = cb_coding.x - cb_next.width - 24
cb_prev.x = cb_next.x - cb_prev.width - 12
cb_current.x = cb_prev.x - cb_current.width - 12

if isnull(current_service.encounter_id) then
	ll_x = cb_prev.x - 16
	cb_current.visible = false
else
	ll_x = cb_current.x
	cb_current.visible = true
end if

st_encounter_background.width = ll_x - st_encounter.x - 12
st_encounter_id.x = ll_x - st_encounter_id.width - 32
st_encounter_count.x = ll_x - st_encounter_count.width - 32
st_encounter_status.x = ll_x - st_encounter_status.width - 32
st_encounter.width = st_encounter_status.x - 12

// Put the buttons in an array so we can reference them by an index
button[1] = pb_1
button[2] = pb_2
button[3] = pb_3
button[4] = pb_4
button[5] = pb_5
button[6] = pb_6

button_title[1] = st_button_1
button_title[2] = st_button_2
button_title[3] = st_button_3
button_title[4] = st_button_4
button_title[5] = st_button_5
button_title[6] = st_button_6

// Get the menu id
this_section.load_params(this_page)
ls_temp = this_section.get_attribute(this_section.page[this_page].page_id, "menu_id")
if isnull(ls_temp) then
	setnull(menu.menu_id)
else
	menu = datalist.get_menu(long(ls_temp))
end if

summary_report_id = this_section.get_attribute(this_section.page[this_page].page_id, "summary_report_id")
if isnull(summary_report_id) then summary_report_id = "{4B657EFA-AB67-482B-9FAB-1764440DF116}"

summary_display_script_id = long(this_section.get_attribute(this_section.page[this_page].page_id, "summary_display_script_id"))
if isnull(summary_display_script_id) then summary_display_script_id = long(datalist.get_preference("PREFERENCES", "default_encounter_display_script_id"))

report_service = this_section.get_attribute(this_section.page[this_page].page_id, "report_service")
if isnull(report_service) then report_service = "REPORT"

coding_service = this_section.get_attribute(this_section.page[this_page].page_id, "coding_service")
if isnull(coding_service) then coding_service = "EMCODING"

paint_buttons()

if menu_button_count <= 0 then
	button_x = width
elseif menu_button_count <= 3 then
	button_x = pb_4.x
	pb_1.x = button_x
	pb_2.x = button_x
	pb_3.x = button_x
	st_button_1.x = pb_1.x
	st_button_2.x = pb_2.x
	st_button_3.x = pb_3.x
end if

xx_initialize()

end subroutine

public subroutine paint_buttons ();integer i
boolean lb_remainder
string ls_temp

lb_remainder = false

if isnull(menu.menu_id) then
	menu_button_count = 0
elseif menu.menu_item_count <= max_button_count then
	menu_button_count = menu.menu_item_count
else
	menu_button_count = max_button_count - 1
	lb_remainder = true
end if

// Now initialize the six buttons
for i = 1 to menu_button_count
	button[i].picturename = menu.menu_item[i].button
	button[i].visible = true
	button_title[i].text = menu.menu_item[i].button_title
	button_title[i].visible = true
next

if lb_remainder then
	ls_temp = datalist.get_preference("PREFERENCES", "menu_remainder_button", "button21.bmp")
	button[max_button_count].picturename = ls_temp
	button[max_button_count].visible = true
	button_title[max_button_count].text = "Other Items"
	button_title[max_button_count].visible = true
else
	for i = menu_button_count + 1 to 6
		button[i].visible = false
		button_title[i].visible = false
	next
end if

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


end subroutine

on u_soap_page_base.create
int iCurrent
call super::create
this.st_encounter_id=create st_encounter_id
this.cb_coding=create cb_coding
this.st_no_encounters=create st_no_encounters
this.pb_4=create pb_4
this.cb_current=create cb_current
this.cb_prev=create cb_prev
this.cb_next=create cb_next
this.pb_1=create pb_1
this.pb_5=create pb_5
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_6=create pb_6
this.pb_summary=create pb_summary
this.st_button_1=create st_button_1
this.st_button_2=create st_button_2
this.st_button_3=create st_button_3
this.st_button_4=create st_button_4
this.st_button_5=create st_button_5
this.st_button_6=create st_button_6
this.st_encounter=create st_encounter
this.st_encounter_background=create st_encounter_background
this.st_config_mode_menu=create st_config_mode_menu
this.st_encounter_status=create st_encounter_status
this.st_encounter_count=create st_encounter_count
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_encounter_id
this.Control[iCurrent+2]=this.cb_coding
this.Control[iCurrent+3]=this.st_no_encounters
this.Control[iCurrent+4]=this.pb_4
this.Control[iCurrent+5]=this.cb_current
this.Control[iCurrent+6]=this.cb_prev
this.Control[iCurrent+7]=this.cb_next
this.Control[iCurrent+8]=this.pb_1
this.Control[iCurrent+9]=this.pb_5
this.Control[iCurrent+10]=this.pb_2
this.Control[iCurrent+11]=this.pb_3
this.Control[iCurrent+12]=this.pb_6
this.Control[iCurrent+13]=this.pb_summary
this.Control[iCurrent+14]=this.st_button_1
this.Control[iCurrent+15]=this.st_button_2
this.Control[iCurrent+16]=this.st_button_3
this.Control[iCurrent+17]=this.st_button_4
this.Control[iCurrent+18]=this.st_button_5
this.Control[iCurrent+19]=this.st_button_6
this.Control[iCurrent+20]=this.st_encounter
this.Control[iCurrent+21]=this.st_encounter_background
this.Control[iCurrent+22]=this.st_config_mode_menu
this.Control[iCurrent+23]=this.st_encounter_status
this.Control[iCurrent+24]=this.st_encounter_count
end on

on u_soap_page_base.destroy
call super::destroy
destroy(this.st_encounter_id)
destroy(this.cb_coding)
destroy(this.st_no_encounters)
destroy(this.pb_4)
destroy(this.cb_current)
destroy(this.cb_prev)
destroy(this.cb_next)
destroy(this.pb_1)
destroy(this.pb_5)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_6)
destroy(this.pb_summary)
destroy(this.st_button_1)
destroy(this.st_button_2)
destroy(this.st_button_3)
destroy(this.st_button_4)
destroy(this.st_button_5)
destroy(this.st_button_6)
destroy(this.st_encounter)
destroy(this.st_encounter_background)
destroy(this.st_config_mode_menu)
destroy(this.st_encounter_status)
destroy(this.st_encounter_count)
end on

type cb_configure_tab from u_cpr_page_base`cb_configure_tab within u_soap_page_base
end type

type st_encounter_id from statictext within u_soap_page_base
integer x = 1838
integer y = 100
integer width = 201
integer height = 40
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "99999"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_coding from commandbutton within u_soap_page_base
integer x = 2565
integer y = 8
integer width = 146
integer height = 112
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

type st_no_encounters from statictext within u_soap_page_base
integer x = 439
integer y = 164
integer width = 1509
integer height = 304
integer textsize = -24
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

type pb_4 from u_picture_button within u_soap_page_base
integer x = 2619
integer y = 128
integer taborder = 30
boolean originalsize = false
string picturename = ""
string disabledname = ""
end type

event clicked;button_pressed(4)

end event

type cb_current from commandbutton within u_soap_page_base
integer x = 2057
integer y = 8
integer width = 146
integer height = 112
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

li_sts = f_set_current_encounter(current_service.encounter_id)

refresh()

end event

type cb_prev from commandbutton within u_soap_page_base
integer x = 2213
integer y = 8
integer width = 146
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<<"
end type

event clicked;integer li_sts

li_sts = current_patient.encounters.prev_encounter()

refresh()

end event

type cb_next from commandbutton within u_soap_page_base
integer x = 2368
integer y = 8
integer width = 146
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">>"
end type

event clicked;integer li_sts

li_sts = current_patient.encounters.next_encounter()

refresh()

end event

type pb_1 from u_picture_button within u_soap_page_base
integer x = 2359
integer y = 128
integer taborder = 20
string picturename = ""
string disabledname = ""
end type

event clicked;button_pressed(1)

end event

type pb_5 from u_picture_button within u_soap_page_base
integer x = 2619
integer y = 464
integer taborder = 30
boolean originalsize = false
string picturename = ""
string disabledname = ""
end type

event clicked;button_pressed(5)

end event

type pb_2 from u_picture_button within u_soap_page_base
integer x = 2359
integer y = 464
integer taborder = 20
boolean originalsize = false
string picturename = ""
string disabledname = ""
end type

event clicked;button_pressed(2)

end event

type pb_3 from u_picture_button within u_soap_page_base
integer x = 2359
integer y = 800
integer taborder = 20
boolean originalsize = false
string picturename = ""
string disabledname = ""
end type

event clicked;button_pressed(3)

end event

type pb_6 from u_picture_button within u_soap_page_base
integer x = 2619
integer y = 800
integer taborder = 20
boolean originalsize = false
string picturename = ""
string disabledname = ""
end type

event clicked;button_pressed(6)

end event

type pb_summary from u_picture_button within u_soap_page_base
integer x = 2720
integer y = 8
integer width = 146
integer height = 112
integer taborder = 10
boolean originalsize = false
string picturename = "icon_summary.bmp"
string disabledname = "icon_summary.bmp"
end type

event clicked;str_attributes lstr_attributes

f_attribute_add_attribute(lstr_attributes, "report_id", summary_report_id)
f_attribute_add_attribute(lstr_attributes, "display_script_id", string(summary_display_script_id))
f_attribute_add_attribute(lstr_attributes, "destination", "SCREEN")

service_list.do_service(current_patient.cpr_id, current_patient.open_encounter_id, report_service, lstr_attributes)


end event

type st_button_1 from statictext within u_soap_page_base
integer x = 2359
integer y = 344
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

type st_button_2 from statictext within u_soap_page_base
integer x = 2359
integer y = 680
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

type st_button_3 from statictext within u_soap_page_base
integer x = 2359
integer y = 1016
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

type st_button_4 from statictext within u_soap_page_base
integer x = 2619
integer y = 344
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

type st_button_5 from statictext within u_soap_page_base
integer x = 2619
integer y = 680
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

type st_button_6 from statictext within u_soap_page_base
integer x = 2619
integer y = 1016
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

type st_encounter from statictext within u_soap_page_base
integer x = 23
integer y = 16
integer width = 1774
integer height = 116
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
integer li_sts
w_window_base lw_window

popup.title = "Select Appointment"
popup.data_row_count = 2
popup.items[1] = current_patient.cpr_id
popup.items[2] = "PICK"
openwithparm(lw_window, popup, "w_encounter_list_pick")
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

li_sts = f_set_current_encounter(long(popup_return.items[1]))

refresh()

end event

type st_encounter_background from statictext within u_soap_page_base
integer x = 14
integer y = 8
integer width = 2034
integer height = 140
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = right!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_config_mode_menu from statictext within u_soap_page_base
boolean visible = false
integer x = 1874
integer y = 1188
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

type st_encounter_status from statictext within u_soap_page_base
integer x = 1838
integer y = 48
integer width = 201
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Open"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_encounter_count from statictext within u_soap_page_base
integer x = 1792
integer y = 16
integer width = 247
integer height = 40
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "100 of 100"
alignment alignment = right!
boolean focusrectangle = false
end type

