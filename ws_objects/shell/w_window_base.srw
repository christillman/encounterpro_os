HA$PBExportHeader$w_window_base.srw
forward
global type w_window_base from window
end type
type pb_epro_help from u_pb_help_button within w_window_base
end type
type st_config_mode_menu from statictext within w_window_base
end type
type str_point from structure within w_window_base
end type
type str_rect from structure within w_window_base
end type
type str_windowplacement from structure within w_window_base
end type
end forward

type str_point from structure
	long		x
	long		y
end type

type str_rect from structure
	long		left
	long		top
	long		right
	long		bottom
end type

type str_windowplacement from structure
	unsignedlong		length
	unsignedlong		flags
	unsignedlong		showcmd
	str_point		ptminposition
	str_point		ptmaxposition
	str_rect		rcnormalposition
end type

shared variables

end variables

global type w_window_base from window
integer width = 2926
integer height = 1832
boolean titlebar = true
string title = "EncounterPRO"
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 33538240
string icon = "epman.ico"
event post_open pbm_custom01
event button_pressed ( integer button_index )
event results_posted ( u_component_observation puo_observation )
event source_connected ( u_component_observation puo_observation )
event source_disconnected ( u_component_observation puo_observation )
event ole_updated ( u_ole_control puo_ole_control )
pb_epro_help pb_epro_help
st_config_mode_menu st_config_mode_menu
end type
global w_window_base w_window_base

type prototypes
FUNCTION integer GetWindowPlacement(unsignedlong hwnd, ref str_windowplacement wplcmnt) LIBRARY "USER32.DLL" alias for "GetWindowPlacement;Ansi"
FUNCTION unsignedinteger GetLastError() LIBRARY "kernel32.DLL"

Function long CreateCompatibleDC( uint hDC ) Library 'gdi32'
Function long GetWindowDC( ulong lhWnd ) Library "user32"
Function long ReleaseDC( ulong lhWnd, uint hDC ) Library "user32"
Function long CreateCompatibleBitmap( uint hDC, integer iWidth, integer iHeight ) Library "gdi32"
Function long SelectObject( uint hDC, uint hObj ) Library 'gdi32'
Function boolean DeleteObject( ulong hDC ) Library 'gdi32'
Function boolean DeleteDC( ulong hDC ) Library 'gdi32'
Function boolean BitBlt( uint hDestDC, int ix, int iy, int iw, int ih, uint hSourceDC, int idx, int idy, long oper ) Library 'gdi32'
Function boolean OpenClipboard( ulong lhWnd ) Library 'user32'
Function long SetClipboardData( uint uiFormat, ulong hBmp ) Library 'user32'
Subroutine CloseClipboard() Library 'user32'
Subroutine EmptyClipboard() Library 'user32'


end prototypes

type variables
integer button_count
u_cb_menu_item cbuttons[]
u_picture_button pbuttons[]
u_button_title titles[]

string button_type = "PICTURE"

str_menu menu

str_buttons buttons

integer button_pressed

integer button_width
integer button_height
integer spacing
integer border_size
integer button_top
integer title_gap
integer title_height

integer max_buttons

boolean buttons_set = false

boolean show_more_buttons = true
boolean more_buttons = false

str_attributes state_attributes

// Auto Resize Control
boolean auto_resize_window = true
boolean auto_resize_objects = true
boolean zoom_dw_on_resize = false
boolean nested_user_object_resize = true

real x_factor = 1
real y_factor = 1

long service_window_width = 2926
long service_window_height = 1832



end variables

forward prototypes
public function integer get_windowstate ()
public subroutine remove_buttons ()
public function integer button_pressed (integer pi_button_index)
public subroutine set_button_defaults ()
public function integer add_button (string ps_picture, string ps_title, string ps_help, string ps_action, string ps_argument)
public function integer paint_menu (long pl_menu_id)
public subroutine enable_window ()
public function integer refresh ()
public subroutine click_button (string ps_auto_close_flag)
public function integer window_to_clipboard ()
public subroutine resize_and_move ()
public subroutine center_popup ()
end prototypes

event button_pressed;integer li_menu_index
integer li_sts
integer li_button_pressed

li_button_pressed = 0

if button_index < 0 then
	return
elseif button_index = 0 then
	if more_buttons then
		// If the user clicked the "Other Options" button, then display the remaining choices in a popup
		li_button_pressed = f_display_buttons(buttons, max_buttons, 0)
	end if
else
	li_button_pressed = button_index
end if
	
if li_button_pressed > 0 and li_button_pressed <= buttons.button_count then
	li_sts = button_pressed(li_button_pressed)
end if

return

end event

public function integer get_windowstate ();str_windowplacement lstr_wpl
integer li_return
unsignedlong ll_handle
unsignedinteger li_sts

ll_handle = handle(this)

li_return = getwindowplacement(ll_handle, lstr_wpl)
if li_return = 0 then li_sts = getlasterror()

//if windowstate = Maximized! then
//	messagebox("Football", "Maximized")
//elseif windowstate = Minimized! then
//	messagebox("Football", "Minimized")
//elseif windowstate = Normal! then
//	messagebox("Football", "Normal")
//end if
return 1

end function

public subroutine remove_buttons ();integer i

if button_type = "PICTURE" then
	for i = 1 to button_count
		closeuserobject(pbuttons[i])
		closeuserobject(titles[i])
	next
else
	for i = 1 to button_count
		closeuserobject(cbuttons[i])
	next
end if

button_count = 0

end subroutine

public function integer button_pressed (integer pi_button_index);integer li_menu_index
integer li_sts
string ls_auto_close_flag

li_sts = 0

CHOOSE CASE upper(buttons.button[pi_button_index].action)
	CASE "MENU"
		// Check for a valid menu
		if isnull(menu.menu_id) or menu.menu_id <= 0 then return 0
		
		// Get the menu index from the button argument
		li_menu_index = integer(buttons.button[pi_button_index].argument)
		if isnull(li_menu_index) or li_menu_index <= 0 or li_menu_index > menu.menu_item_count then return 0

		// Perform the menu item
		li_sts = f_do_menu_item_with_attributes(menu.menu_id, menu.menu_item[li_menu_index].menu_item_id, state_attributes)
		
		ls_auto_close_flag = menu.menu_item[li_menu_index].auto_close_flag
		
		// If the auto_close_flag is not "N" then see if we need to click a button
		// on this window
		if upper(ls_auto_close_flag) = "N" then
			refresh()
		else
			click_button(ls_auto_close_flag)
		end if
	CASE ELSE
		return 0
END CHOOSE

return li_sts


end function

public subroutine set_button_defaults ();// Set the default button placement values
if button_type = "PICTURE" then
	button_width = 247
	button_height = 205
	spacing = 30
	border_size = 24
	title_gap = 16
	title_height = 113
else
	button_type = "COMMAND"
	button_width = 571
	button_height = 112
	spacing = 30
	border_size = 24
	title_gap = 0
	title_height = 0
end if

button_top = height - button_height - title_gap - title_height - 125

if isnull(max_buttons) or max_buttons <= 0 then
	max_buttons = int((width - spacing)/(button_width + spacing))
	if button_type = "PICTURE" then
		max_buttons -= int(4 * x_factor)
	else
		max_buttons -= int(2 * x_factor)
	end if
end if

buttons_set = true

end subroutine

public function integer add_button (string ps_picture, string ps_title, string ps_help, string ps_action, string ps_argument);integer li_sts

// We must have at least a title
If isnull(ps_title) or trim(ps_title) = "" Then return 0

if not buttons_set then set_button_defaults()

buttons.button_count += 1
buttons.button[buttons.button_count].title = ps_title
buttons.button[buttons.button_count].help = ps_help
buttons.button[buttons.button_count].picture = ps_picture
buttons.button[buttons.button_count].action = ps_action
buttons.button[buttons.button_count].argument = ps_argument

// If we're already at the maximum displayable buttons then change the last
// button to be and "Other Options" button
if button_count = max_buttons then
	// If we're not supposed to show the "Other Options" button then just return
	if not show_more_buttons then return 0
	
	more_buttons = true
	if button_type = "PICTURE" then
		pbuttons[button_count].picturename = "button21.bmp"
		pbuttons[button_count].button_index = 0
		pbuttons[button_count].button_help = "Other Options"
		titles[button_count].text = "Other Options"
	else
		cbuttons[button_count].button_index = 0
		cbuttons[button_count].text = "Other Options"
	end if
else
	if button_type = "PICTURE" then
		button_count += 1
		li_sts = openuserobject(pbuttons[button_count], ((button_count - 1) * (button_width + spacing)) + spacing, button_top )
		if li_sts = 1 then
			if len(ps_picture) > 0 then pbuttons[button_count].picturename = ps_picture
			pbuttons[button_count].button_index = buttons.button_count
			pbuttons[button_count].button_help = ps_help
			openuserobject(titles[button_count], ((button_count - 1) * (button_width + spacing)) + spacing, button_top + button_height + title_gap )
			titles[button_count].text = ps_title
			titles[button_count].backcolor = color_background
		else
			log.log(this, "add_button()", "Error opening object for button (" + ps_title + ")", 4)
		end if
	else
		button_count += 1
		openuserobject(cbuttons[button_count], ((button_count - 1) * (button_width + spacing)) + spacing, button_top )
		cbuttons[button_count].button_index = button_count
		cbuttons[button_count].text = ps_title
	end if
end if

return 1


end function

public function integer paint_menu (long pl_menu_id);long i
integer li_sts

menu = datalist.get_menu(pl_menu_id)
buttons.button_count = 0

for i = 1 to menu.menu_item_count
	li_sts = add_button(menu.menu_item[i].button, &
								menu.menu_item[i].button_title, &
								menu.menu_item[i].button_help, &
								"MENU", &
								string(i))
next

st_config_mode_menu.text = menu.description
st_config_mode_menu.text += " (" + string(menu.menu_id) + ")"

if len(st_config_mode_menu.text) > 0 then
	st_config_mode_menu.visible = config_mode
end if

return 1

end function

public subroutine enable_window ();ulong ll_whandle

ll_whandle = handle(this)
if not iswindowenabled(ll_whandle) then
	EnableWindow(ll_whandle, true)
end if

end subroutine

public function integer refresh ();// Override in descendant class to refresh window

if len(st_config_mode_menu.text) > 0 then
	st_config_mode_menu.visible = config_mode
end if

return 1

end function

public subroutine click_button (string ps_auto_close_flag);integer i
boolean lb_found
string ls_name

for i = 1 to upperbound(control)
	ls_name = lower(control[i].classname())
	CHOOSE CASE upper(ps_auto_close_flag)
		CASE "Y"
			if ls_name = "cb_finished" &
				or ls_name = "cb_ok" &
				or ls_name = "cb_close" &
				or ls_name = "cb_done" then
				control[i].postevent("clicked")
				return
			end if
		CASE "C"
			if ls_name = "cb_cancel" &
				or ls_name = "cb_cancel_procedure" &
				or ls_name = "cb_cancelled" then
				control[i].postevent("clicked")
				return
			end if
		CASE "B"
			if ls_name = "cb_beback" &
				or ls_name = "cb_be_back" &
				or ls_name = "cb_not_done" &
				or ls_name = "cb_continue" &
				or ls_name = "cb_ill_be_back" then
				control[i].postevent("clicked")
				return
			end if
	END CHOOSE
next

end subroutine

public function integer window_to_clipboard ();Integer li_W, li_H
ULong ll_DC, ll_BMP, ll_DestDC, ll_RC
Boolean lb_RC
String ls_Type = 'DISPLAY'
OLEObject lole_Word
w_window_base lw_this

lw_this = this

//The routines you are using from the Windows API capture a rectangular area of the current screen, so to capture the current window you need to convert the window's width and height into pixels so they're ready for the routines. Add the following code to achieve this:

li_W = UnitsToPixels( this.Width, XUnitsToPixels! )
li_H = UnitsToPixels( this.Height, YUnitsToPixels! )

//Start to call the API. Ask the API for a handle to the device context of the current window:

ll_DC = GetWindowDC( Handle( lw_this ) )
if ll_DC = 0 or isnull(ll_DC) then
	log.log(this, "window_to_clipboard()", "Error creating window device context", 4 )
	RETURN -1
end if

//This returns a pointer to an object that has details about the current screen setup$$HEX1$$1420$$ENDHEX$$such as the number of colors$$HEX1$$1420$$ENDHEX$$but this isn't really important to know because the next function call is used to create your own device context. It just makes a new one that is the same as the current one:

ll_DestDC = CreateCompatibleDC( ll_DC )
if ll_DestDC = 0 or isnull(ll_DestDC) then
	log.log(this, "window_to_clipboard()", "Error creating compatible device context", 4 )
	ReleaseDC( Handle(lw_this), ll_DC )
	RETURN -1
end if

//Create a new bitmap object based on the screen Device Context. You will use a later API call to make a copy of the rectangle you want into this bitmap, so make sure the new bitmap is the same size as the area you are going to copy. 
//After creating the bitmap, associate it with your newly created Device Context:


ll_BMP = CreateCompatibleBitmap( ll_DC, li_W, li_H )
if ll_BMP = 0 or isnull(ll_BMP) then
	log.log(this, "window_to_clipboard()", "Error creating bitmap", 4 )
	DeleteDC( ll_DestDC )
	ReleaseDC( Handle(lw_this), ll_DC )
	RETURN -1
end if

SelectObject( ll_DestDC, ll_BMP )

//Finally, copy the rectangle that you want to capture into the bitmap object using the BitBlt API call:

BitBlt( ll_DestDC, 0, 0, li_W, li_H, ll_DC, 0, 0, 13369376 )

//Now you have a bitmap object in memory that is a copy of the current window. (You can copy any rectangular area this way, if you want.) 
//The next section of code takes this bitmap and puts it on the Clipboard ready to be pasted into Word. To do this you must ask for a handle to the Clipboard, empty any current Clipboard contents, and set your bitmap as the new Clipboard contents. You cannot use the built-in PowerBuilder function because it does not know about bitmap objects. 

lb_RC = OpenClipBoard( Handle(lw_this) )
IF lb_rc THEN
	EmptyClipBoard()
	SetClipBoardData( 2, ll_BMP )
	CloseClipBoard()
ELSE
	log.log(this, "window_to_clipboard()", "Error Opening ClipBoard", 4 )
	DeleteObject( ll_BMP )
	DeleteDC( ll_DestDC )
	ReleaseDC( Handle(lw_this), ll_DC )
	RETURN -1
END IF

//If the OpenClipboard function fails and will not let you add your bitmap object, you must clean up the bitmap in memory using the DeleteObject call. If you are successful, Windows will clean it up for you so you can forget about it. 
//Finally, clean up the two Device Contexts you used: 

DeleteDC( ll_DestDC )
ReleaseDC( Handle(lw_this), ll_DC )


return 1

end function

public subroutine resize_and_move ();long i
dragobject dobj
line ln
rectangle rect
datawindow dw
picturebutton pb
u_user_resizable rr
classdefinition cd
boolean lb_user_resizable
string ls_classname

if isnull(main_window) or not isvalid(main_window) then return

if this.windowstate = maximized! then return

// Move this window relative to the main window
x += main_window.x
y += main_window.y


// If we're not close to the 640x480 size, then don't resize the window
if width < 2800 or height < 1700 then
	// Small windows are popups, so center them on the main window
	if isvalid(main_window) then
		x = main_window.x + ((main_window.width - width) / 2)
		y = main_window.y + ((main_window.height - height) / 2)
	end if
	return
end if

x_factor = main_window.service_window_width / width
y_factor = main_window.service_window_height / height

// If the main_window isn't significantly bigger than its original size, then
// don't resize the window
if x_factor <= 1.01 and y_factor <= 1.01 then return


width = main_window.service_window_width
height = main_window.service_window_height

if auto_resize_objects then f_resize_objects(control, x_factor, y_factor, zoom_dw_on_resize, nested_user_object_resize)

end subroutine

public subroutine center_popup ();
if isnull(main_window) then return

x = main_window.x + (main_window.width - width) / 2
y = main_window.y + (main_window.height - height) / 2

end subroutine

on w_window_base.create
this.pb_epro_help=create pb_epro_help
this.st_config_mode_menu=create st_config_mode_menu
this.Control[]={this.pb_epro_help,&
this.st_config_mode_menu}
end on

on w_window_base.destroy
destroy(this.pb_epro_help)
destroy(this.st_config_mode_menu)
end on

event open;integer i
powerobject lo_x
statictext lo_statictext
long ll_windowbackcolor
tab lo_tab
datawindow lo_dw
long ll_dw_backcolor
boolean lb_full_screen
u_component_service luo_service
string ls_temp

pb_epro_help.visible = false

if not isnull(current_patient) then title = current_patient.id_line()
state_attributes.attribute_count = 0

if auto_resize_window then resize_and_move()

set_button_defaults()

st_config_mode_menu.height = 48
st_config_mode_menu.y =	button_top - st_config_mode_menu.height - 4


if backcolor <> color_background then
	ll_windowbackcolor = backcolor
	backcolor = color_background
	
	for i = 1 to upperbound(control)
	
	
		CHOOSE CASE control[i].typeof()
			CASE statictext!
				lo_statictext = control[i]
				if lo_statictext.backcolor = ll_windowbackcolor then
					lo_statictext.backcolor = color_background
				end if
			CASE tab!
				lo_tab = control[i]
				if lo_tab.backcolor = ll_windowbackcolor then
					lo_tab.backcolor = color_background
				end if
			CASE datawindow!
				lo_dw = control[i]
				if len(lo_dw.dataobject) > 0 then
					ll_dw_backcolor = long(lo_dw.object.datawindow.header.color)
					if ll_dw_backcolor = ll_windowbackcolor then
						lo_dw.object.datawindow.header.color = color_background
					end if
					ll_dw_backcolor = long(lo_dw.object.datawindow.detail.color)
					if ll_dw_backcolor = ll_windowbackcolor then
						lo_dw.object.datawindow.detail.color = color_background
					end if
					ll_dw_backcolor = long(lo_dw.object.datawindow.footer.color)
					if ll_dw_backcolor = ll_windowbackcolor then
						lo_dw.object.datawindow.footer.color = color_background
					end if
					ll_dw_backcolor = long(lo_dw.object.datawindow.color)
					if ll_dw_backcolor = ll_windowbackcolor then
						lo_dw.object.datawindow.color = color_background
					end if
				end if
		END CHOOSE
	next
end if

lo_x = message.powerobjectparm
if isvalid(lo_x) and not isnull(lo_x) then
	ls_temp = lo_x.classname()
	if lower(left(ls_temp, 19)) = "u_component_service" then
		luo_service = lo_x
		luo_service.get_attribute("full_screen", lb_full_screen)
		if lb_full_screen then
			windowstate = maximized!
		end if
	end if
end if


end event

event key;if f_fkey_handler2(key, keyflags, this.classname()) then refresh()

end event

event close;remove_buttons()

end event

type pb_epro_help from u_pb_help_button within w_window_base
boolean visible = false
integer x = 2651
integer y = 20
integer width = 256
integer height = 128
end type

type st_config_mode_menu from statictext within w_window_base
boolean visible = false
integer x = 55
integer y = 1468
integer width = 997
integer height = 48
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean focusrectangle = false
end type

event clicked;w_menu_edit lw_window
str_popup popup
w_menu_display lw_menu_display

//if menu.menu_id > 0 then
//	openwithparm(lw_window, menu.menu_id, "w_menu_edit")
//end if

SELECT CAST(id AS varchar(38))
INTO :popup.items[1]
FROM c_menu
WHERE menu_id = :menu.menu_id;
if not tf_check() then return
popup.items[2] = f_boolean_to_string(true)
popup.data_row_count = 2
openwithparm(lw_menu_display, popup, "w_menu_display")

remove_buttons()
paint_menu(menu.menu_id)

end event

