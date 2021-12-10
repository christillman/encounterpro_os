$PBExportHeader$w_pop_buttons.srw
forward
global type w_pop_buttons from w_window_base
end type
type cb_cancel from commandbutton within w_pop_buttons
end type
type cb_more from commandbutton within w_pop_buttons
end type
type st_title from statictext within w_pop_buttons
end type
end forward

global type w_pop_buttons from w_window_base
integer x = 270
integer y = 1092
integer width = 1513
integer height = 344
boolean titlebar = false
string title = ""
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
integer button_width = 247
integer button_height = 205
integer spacing = 30
integer border_size = 24
integer button_top = 45
integer title_gap = 16
integer title_height = 113
event close_window pbm_custom02
cb_cancel cb_cancel
cb_more cb_more
st_title st_title
end type
global w_pop_buttons w_pop_buttons

type variables
str_popup button_popup

integer starting_button
integer row_count

string button_icons[]
string button_helps[]

integer used_button_count
u_picture_button picture_buttons[]

integer border_x1
integer border_x2
integer border_y1
integer border_y2

boolean titles_used = false

integer max_buttons_on_row = 10
integer max_rows = 4
integer row_x_increment = 400

integer button_object_count
integer button_pressed

string menu_key
string menu_type
end variables

forward prototypes
public subroutine display_buttons ()
public subroutine close_buttons ()
public function integer create_buttons ()
end prototypes

event close_window;
close_buttons()

closewithreturn(this, button_pressed)


end event

public subroutine display_buttons ();integer i, j, r, li_x, li_y, c
window w
integer first_button[], last_button[]
integer li_button_count
boolean lb_display

// Calculate how many buttons to display
li_button_count = button_count - starting_button + 1
if li_button_count > (max_buttons_on_row * max_rows) then
	li_button_count = (max_buttons_on_row * max_rows)
end if

row_count = ((li_button_count - 1) / max_buttons_on_row) + 1

if row_count = 1 then
	first_button[1] = starting_button
	last_button[1] = li_button_count + starting_button - 1
elseif row_count = 2 then
	first_button[1] = starting_button
	last_button[1] = ((li_button_count - 1) / 2) + starting_button
	first_button[2] = last_button[1] + 1
	last_button[2] = li_button_count + starting_button - 1
else
	for i = 1 to row_count
		first_button[i] = ((i - 1) * max_buttons_on_row) + starting_button
		last_button[i] = (i * max_buttons_on_row) + starting_button - 1
	next
	if last_button[row_count] > button_count then
		last_button[row_count] = button_count
	end if
end if

// save the number of buttons actually instantiated
used_button_count = li_button_count

j = starting_button - 1
for r = 1 to max_rows
	for c = 1 to max_buttons_on_row
		// Calculate with button object to use here
		i = ((r - 1) * max_buttons_on_row) + c
		
		lb_display = false
		if r <= row_count then
			if c <= (last_button[r] - first_button[r] + 1) then
				lb_display = true
			end if
		end if


		if lb_display then
			// Calculate which button to display there
			j = first_button[r] + c - 1
			
			// If this button is to be displayed, then transfer the picture and title from the passed in buttons
			picture_buttons[i].picturename = button_icons[j]
			picture_buttons[i].button_index = j
			picture_buttons[i].button_help = button_helps[j]
			picture_buttons[i].visible = true
			if button_popup.button_titles_used then
				titles[i].text = button_popup.button_titles[j]
				titles[i].visible = true
				titles_used = true
			end if
		else
			// If the button is not to be displayed then make it invisible
			picture_buttons[i].visible = false
			if button_popup.button_titles_used then
				titles[i].visible = false
			end if
		end if
	next
next


width = ((last_button[1] - first_button[1] + 1) * (button_width + spacing)) + spacing + (2 * border_size)

border_x1 = border_size + spacing
border_x2 = width - border_size - spacing
border_y1 = button_top
border_y2 = button_top + button_height

if titles_used then
	this.height = this.height + title_gap + title_height
end if

this.height = row_count * row_x_increment + button_top
if cb_more.visible then
	cb_more.y = this.height
	cb_cancel.y = this.height
	this.height += cb_more.height + 50
	cb_cancel.x = this.width - cb_cancel.width - 50
	cb_more.x = cb_cancel.x - cb_more.width - 50
end if


if isnull(button_popup.pointerx) or button_popup.pointerx = 0 then
	li_x = (main_window.width - this.width) / 2
else
	li_x = button_popup.pointerx - spacing - (button_width/2)
	if li_x + this.width > main_window.width then li_x = main_window.width - this.width
end if

if isnull(button_popup.pointery) or button_popup.pointery = 0 then
	li_y = (main_window.height - this.height) / 2
else
	li_y = button_popup.pointery - button_top - (button_height/2)
	if li_y + this.height > main_window.height then li_y = main_window.height - this.height
end if

this.move(li_x, li_y)

end subroutine

public subroutine close_buttons ();integer i


for i = 1 to button_object_count
	if isvalid(picture_buttons[i]) and not isnull(picture_buttons[i]) then
		closeuserobject(picture_buttons[i])
	end if
	if isvalid(titles[i]) and not isnull(titles[i]) then
		closeuserobject(titles[i])
	end if
next


end subroutine

public function integer create_buttons ();integer i, j
integer li_sts

// Calculate how many buttons to create
button_object_count = 0

for i = 1 to max_rows
	for j = 1 to max_buttons_on_row
		button_object_count += 1
		li_sts = openuserobject(picture_buttons[button_object_count], ((j - 1) * (button_width + spacing)) + spacing, button_top + ((i - 1) * row_x_increment) )
		if li_sts < 0 then
			log.log(this, "w_pop_buttons.create_buttons:0012", "Error creating button object", 4)
			return -1
		end if
		if button_popup.button_titles_used then
			li_sts = openuserobject(titles[button_object_count], ((j - 1) * (button_width + spacing)) + spacing, button_top + button_height + title_gap + ((i - 1) * row_x_increment))
			if li_sts < 0 then
				log.log(this, "w_pop_buttons.create_buttons:0018", "Error creating button title object", 4)
				return -1
			end if
			titles_used = true
		end if
	next
next

return 1

end function

event open;integer i, j, r, li_x, li_y, c
window w
u_attachment_list luo_attachment_list
integer first_button[], last_button[]
integer li_sts

button_popup = message.powerobjectparm

// If we're in server mode, just return that the first button was pressed
if gnv_app.cpr_mode = "SERVER" then
	button_pressed = 1
	closewithreturn(this, button_pressed)
end if

st_title.text = button_popup.title

menu_type = button_popup.dataobject
if menu_type = "" and isnumber(button_popup.item) then
	menu_type = "MENU"
end if
menu_key = button_popup.item



button_count = button_popup.button_count
button_icons = button_popup.button_icons
button_helps = button_popup.button_helps

if button_count > (max_buttons_on_row * max_rows) then
	cb_more.visible = true
	cb_cancel.visible = true
else
	cb_more.visible = false
	cb_cancel.visible = false
end if

starting_button = 1

button_width = 247
button_height = 205
spacing = 30
border_size = 24
button_top = 45
title_gap = 16
title_height = 113

li_sts = create_buttons()
if li_sts <= 0 then
	close_buttons()
	closewithreturn(this, 0)
	return
end if

display_buttons()

st_title.setposition(tobottom!)

end event

on mousemove;integer li_x, li_y

li_y = pointery()
if li_y < border_y1 or li_y > border_y2 then f_cpr_set_msg("")

li_x = pointerx()
if li_x < border_x1 or li_x > border_x2 then f_cpr_set_msg("")

end on

on w_pop_buttons.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_more=create cb_more
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_more
this.Control[iCurrent+3]=this.st_title
end on

on w_pop_buttons.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_more)
destroy(this.st_title)
end on

event close;// don't call remove_buttons()


end event

event button_pressed;call super::button_pressed;button_pressed = message.wordparm

if isnull(button_pressed) or button_pressed < 1 or button_pressed > button_count then return

postevent("close_window")

end event

type pb_epro_help from w_window_base`pb_epro_help within w_pop_buttons
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pop_buttons
end type

type cb_cancel from commandbutton within w_pop_buttons
integer x = 741
integer y = 176
integer width = 293
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;button_pressed = 0
parent.postevent("close_window")

end event

type cb_more from commandbutton within w_pop_buttons
integer x = 416
integer y = 172
integer width = 247
integer height = 108
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "More"
end type

event clicked;
starting_button += (max_buttons_on_row * max_rows)
if starting_button > button_count then starting_button = 1


display_buttons()

end event

type st_title from statictext within w_pop_buttons
integer x = 9
integer width = 1440
integer height = 64
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean focusrectangle = false
end type

event clicked;str_popup popup
w_menu_display lw_menu_display
long ll_menu_id

CHOOSE CASE menu_type
	CASE "MENU"
		ll_menu_id = long(menu_key)
		
		SELECT CAST(id AS varchar(38))
		INTO :popup.items[1]
		FROM c_menu
		WHERE menu_id = :ll_menu_id;
		if not tf_check() then return
		popup.items[2] = f_boolean_to_string(true)
		popup.data_row_count = 2
		openwithparm(lw_menu_display, popup, "w_menu_display")
	CASE "TREATMENT_TYPE_LIST"
		openwithparm(w_edit_treatment_type_list, menu_key)
END CHOOSE
end event

