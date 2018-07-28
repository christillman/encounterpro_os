$PBExportHeader$w_pop_pick.srw
forward
global type w_pop_pick from w_window_base
end type
type pb_down from u_picture_button within w_pop_pick
end type
type pb_up from u_picture_button within w_pop_pick
end type
type st_page from statictext within w_pop_pick
end type
type dw_pick from u_dw_pick_list within w_pop_pick
end type
type st_title from statictext within w_pop_pick
end type
type cb_ok from commandbutton within w_pop_pick
end type
type cb_cancel from commandbutton within w_pop_pick
end type
type str_point from structure within w_pop_pick
end type
end forward

type str_point from structure
	long		x
	long		y
end type

global type w_pop_pick from w_window_base
integer x = 64
integer y = 408
integer width = 2030
integer height = 1716
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
pb_down pb_down
pb_up pb_up
st_page st_page
dw_pick dw_pick
st_title st_title
cb_ok cb_ok
cb_cancel cb_cancel
end type
global w_pop_pick w_pop_pick

type prototypes
SUBROUTINE GetCursorPos( ref str_point lppt ) LIBRARY "USER32.DLL" alias for "GetCursorPos;Ansi"

end prototypes

type variables
str_popup popup

long blank_row

boolean display_list = false

end variables

forward prototypes
public subroutine picked (long pl_row)
public subroutine sizeandmove ()
end prototypes

public subroutine picked (long pl_row);str_popup_return popup_return
string ls_col
string ls_coltype

if pl_row = blank_row then
	popup_return.item = ""
	popup_return.descriptions[1] = String(dw_pick.object.data[pl_row,popup.displaycolumn])
else
	if popup.data_row_count > 0 then
		popup_return.item_index = pl_row
		popup_return.item = popup.items[pl_row]
		popup_return.descriptions[1] = popup.items[pl_row]
	elseif popup.dataobject <> "" then
		ls_col = "#" + string(popup.datacolumn)
		ls_coltype = UPPER(left(dw_pick.Describe(ls_col + ".ColType"), 4))
		if ls_coltype = "NUMB" then
			popup_return.item = string(dw_pick.object.data[pl_row, popup.datacolumn])
		elseif ls_coltype = "LONG" then
			popup_return.item = string(dw_pick.object.data[pl_row, popup.datacolumn])
		elseif ls_coltype = "CHAR" then
			popup_return.item = dw_pick.object.data[pl_row, popup.datacolumn]
		end if
		// By Sumathi Chinnasamy On 09/08/99 
		// Convert any data type to string
		popup_return.descriptions[1] = String(dw_pick.object.data[pl_row,popup.displaycolumn])
	else
		ls_col = "#" + string(popup.datacolumn)
		ls_coltype = UPPER(left(dw_pick.Describe(ls_col + ".ColType"), 4))
		if ls_coltype = "NUMB" then
			popup_return.item = string(dw_pick.object.data[pl_row, 1])
		elseif ls_coltype = "LONG" then
			popup_return.item = string(dw_pick.object.data[pl_row, 1])
		elseif ls_coltype = "CHAR" then
			popup_return.item = dw_pick.object.data[pl_row, 1]
		end if
		popup_return.descriptions[1] = dw_pick.object.data[pl_row,2]
	end if
end if

popup_return.item_count = 1
popup_return.items[1] = popup_return.item
popup_return.item_indexes[1] = pl_row
popup_return.choices_count = dw_pick.rowcount()
closewithreturn(this, popup_return)

end subroutine

public subroutine sizeandmove ();long ll_rowcount, ll_dwheight, ll_dwwidth, i
integer li_col1width, li_col1x, li_detail_height, li_lastrow
integer li_scrollbar, li_itemrow, li_x, li_y, li_width, li_height, li_dw_y, li_dw_x
integer li_pointerx, li_pointery, li_titlewidth
integer li_header_height
string ls_temp, ls_col
environment luo_env
integer ll_screenheight
integer ll_screenwidth
long ll_buttonwidth
integer li_len

///////////////////////////////////////
long xborder = 20
long yborder = 18
long dwlineheight = 85
long dwscrollbarwidth = 66
long dwborder = 8
long maxdwheight = 1350
long maxdwchars = 32
long dwcharwidth = 50
long buttongap = 16
long buttonheight = 125
long titleheight = 96
long titlecharwidth = 14
long titlegap = 32
long topgap = 46
long sidegap = 49
//////////////////////////////////////

// Set the title size base on how many characters are in the title
li_len = len(st_title.text)
if li_len < 40 then
	titleheight = 73
	st_title.textsize = -12
else
	titleheight = 116
	st_title.textsize = -10
end if

getenvironment(luo_env)
ll_screenheight = pixelstounits(luo_env.screenheight, YPixelsToUnits!)
ll_screenwidth = pixelstounits(luo_env.screenwidth, XPixelsToUnits!)

maxdwheight = ll_screenheight - 400

ll_rowcount = dw_pick.rowcount()

// Check to see if this is a display list
if popup.display_only then
	display_list = true
end if

// Calculate the Title Width
li_titlewidth = len(popup.title) * titlecharwidth 

// Calculate the datawindow position
if st_title.visible then
	li_dw_y = topgap + titleheight + titlegap
else
	li_dw_y = topgap
end if	
li_dw_x = sidegap

// Calculate the datawindow width
ls_col = "#" + string(popup.displaycolumn)
ls_temp = dw_pick.describe(ls_col + ".width")
li_col1width = integer(ls_temp)
ls_temp = dw_pick.describe(ls_col + ".x")
li_col1x = integer(ls_temp)
ll_dwwidth = li_col1x + li_col1width + (2 * dwborder)

// Calculate the datawindow header height
ls_temp = dw_pick.describe("datawindow.header.height")
li_header_height = integer(ls_temp)

// Calculate the datawindow height
ls_temp = dw_pick.describe("datawindow.detail.height")
li_detail_height = integer(ls_temp)
ll_dwheight = (ll_rowcount * li_detail_height) + (2 * dwborder) + li_header_height

// if the datawindow appears to be too tall, then set it to the max height
if ll_dwheight > maxdwheight then
	ll_dwheight = maxdwheight
end if

// Adjust the title width or datawindow position as necessary
if st_title.visible then
	if li_titlewidth > ll_dwwidth then
		li_dw_x = sidegap + ((li_titlewidth - ll_dwwidth) / 2)
	else
		li_titlewidth = ll_dwwidth
	end if
end if

// Size and move the title
if st_title.visible then
	st_title.resize(li_titlewidth, titleheight)
	st_title.move(sidegap, topgap)
end if

// size and move the datawindow and the page buttons
dw_pick.resize(ll_dwwidth, ll_dwheight)
dw_pick.move(li_dw_x, li_dw_y)
pb_up.move(li_dw_x + ll_dwwidth + 12 + dwscrollbarwidth, li_dw_y)
pb_down.move(pb_up.x, pb_up.y + pb_up.height + 20)
st_page.move(pb_down.x, pb_down.y + pb_down.height + 20)

// Check to see if it fit (if any rows wrapped..)
ls_temp = dw_pick.describe("datawindow.lastrowonpage")
li_lastrow = integer(ls_temp)
if li_lastrow < ll_rowcount and ll_dwheight < maxdwheight - li_detail_height then
	DO
		ll_dwheight = ll_dwheight + li_detail_height
		dw_pick.resize(ll_dwwidth, ll_dwheight)
		ls_temp = dw_pick.describe("datawindow.lastrowonpage")
		li_lastrow = integer(ls_temp)
	LOOP UNTIL li_lastrow >= ll_rowcount or ll_dwheight > maxdwheight - li_detail_height
end if

// Set the page buttons
dw_pick.set_page(1, pb_up, pb_down, st_page)

// Set the window width
li_width = (2 * li_dw_x) + ll_dwwidth + (2 * xborder)
if pb_up.visible then
	dw_pick.width += dwscrollbarwidth
	dw_pick.VScrollBar = true
	li_width += pb_up.width + dwscrollbarwidth
	ll_buttonwidth = pb_up.x + pb_up.width
else
	ll_buttonwidth = ll_dwwidth
end if

// Set the bottom buttons and the window height
if display_list then
	// No cancel button for display lists
	cb_cancel.visible = false
	
	// Then move the OK button
	cb_ok.resize(ll_buttonwidth, buttonheight)
	cb_ok.move(li_dw_x, li_dw_y + ll_dwheight + buttongap)
	li_height = cb_ok.y + buttonheight
else
	// Then the cancel button
	cb_cancel.resize(ll_buttonwidth, buttonheight)
	cb_cancel.move(li_dw_x, li_dw_y + ll_dwheight + buttongap)
	li_height = cb_cancel.y + buttonheight
	
	// Then the OK button (if this is a multiselect popup)
	if popup.multiselect then
		cb_ok.visible = true
		cb_ok.resize(ll_buttonwidth, buttonheight)
		cb_ok.move(li_dw_x, cb_cancel.y + buttonheight + buttongap)
		li_height = cb_ok.y + buttonheight
	else
		cb_ok.visible = false
	end if
end if
li_height += buttongap + yborder

// Finally, size and move the window
this.resize(li_width, li_height)

if popup.pointerx = 0 then
	li_pointerx = main_window.x + (main_window.width / 2)
else
	li_pointerx = popup.pointerx
end if

if popup.pointery = 0 then
	li_pointery = main_window.y + (main_window.height / 2)
else
	li_pointery = popup.pointery
end if

li_x = li_pointerx - (li_width/2)
//if li_x < 1 then li_x = 1
//if li_x + li_width > ll_screenwidth then li_x = ll_screenwidth - li_width

li_y = li_pointery - (li_height/2)
if li_y < 1 then li_y = 1
if li_y + li_height > ll_screenheight then li_y = (ll_screenheight - li_height) / 2

this.move(li_x, li_y)
end subroutine

event open;call super::open;// This window expects the datawindow object to be passed in the "popup" structure
// The datawindow is expected to display column #1.
// If no data array is passed, then the datawindow is expected to have an SQL select
// and the data to be returned will be in column #2.

integer i
long ll_rows
str_point pt

popup = message.powerobjectparm

GetCursorPos( pt )		// get screen coords of cursor
popup.pointerx = PixelsToUnits( pt.x, XPixelsToUnits! )
popup.pointery = PixelsToUnits( pt.y, YPixelsToUnits! )

if popup.displaycolumn <= 0 then popup.displaycolumn = 1
if popup.datacolumn <= 0 then popup.datacolumn = 2

if isnull(popup.dataobject) or popup.dataobject = "" then
	dw_pick.dataobject = "dw_pick_generic"
else
	dw_pick.dataobject = popup.dataobject
end if

dw_pick.multiselect = popup.multiselect

// Now, if no rows are passed in, then it is assumed that the dataobject
// contains an SQL select.
if popup.data_row_count <= 0 then
	if isnull(popup.dbconnection) or not isvalid(popup.dbconnection) then
		dw_pick.settransobject(sqlca)
	else
		dw_pick.settransobject(popup.dbconnection)
	end if
	// furthermore, if there are arguments, then pass them into the
	//	retrieve function
	CHOOSE CASE popup.argument_count
		CASE 0
			ll_rows = dw_pick.retrieve()
		CASE 1
			if popup.numeric_argument then
				ll_rows = dw_pick.retrieve(long(popup.argument[1]))
			else
				ll_rows = dw_pick.retrieve(popup.argument[1])
			end if
		CASE 2
			if popup.numeric_argument then
				ll_rows = dw_pick.retrieve(long(popup.argument[1]), &
										popup.argument[2])
			else
				ll_rows = dw_pick.retrieve(popup.argument[1], &
										popup.argument[2])
			end if
		CASE 3
			if popup.numeric_argument then
				ll_rows = dw_pick.retrieve(long(popup.argument[1]), &
										popup.argument[2], &
										popup.argument[3])
			else
				ll_rows = dw_pick.retrieve(popup.argument[1], &
										popup.argument[2], &
										popup.argument[3])
			end if
		CASE 4
			if popup.numeric_argument then
				ll_rows = dw_pick.retrieve(long(popup.argument[1]), &
										popup.argument[2], &
										popup.argument[3], &
										popup.argument[4])
			else
				ll_rows = dw_pick.retrieve(popup.argument[1], &
										popup.argument[2], &
										popup.argument[3], &
										popup.argument[4])
			end if
		CASE 5
			if popup.numeric_argument then
				ll_rows = dw_pick.retrieve(long(popup.argument[1]), &
										popup.argument[2], &
										popup.argument[3], &
										popup.argument[4], &
										popup.argument[5])
			else
				ll_rows = dw_pick.retrieve(popup.argument[1], &
										popup.argument[2], &
										popup.argument[3], &
										popup.argument[4], &
										popup.argument[5])
			end if
		CASE 6
			if popup.numeric_argument then
				ll_rows = dw_pick.retrieve(long(popup.argument[1]), &
										popup.argument[2], &
										popup.argument[3], &
										popup.argument[4], &
										popup.argument[5], &
										popup.argument[6])
			else
				ll_rows = dw_pick.retrieve(popup.argument[1], &
										popup.argument[2], &
										popup.argument[3], &
										popup.argument[4], &
										popup.argument[5], &
										popup.argument[6])
			end if
		CASE ELSE
			ll_rows = dw_pick.retrieve()
	END CHOOSE
else
	for i = 1 to popup.data_row_count
		dw_pick.insertrow(0)
		dw_pick.setitem(i,1,popup.items[i])
		if popup.use_background_color then dw_pick.setitem(i,"color",popup.background_color[i])
		// By Sumathi Chinnasamy On 10/18/99
		If Upperbound(popup.preselected_items) >= i Then
			// set the selected_flag to select the row
			If popup.preselected_items[i] Then dw_pick.object.selected_flag[i] = 1
		End If
	next
end if

// Set the title
if isnull(popup.title) or popup.title = "" then
	st_title.visible = false
else
	st_title.visible = true
	st_title.text = popup.title
end if

// Add a blank row if requested (only for non-multi-select with dataobject)
if popup.add_blank_row and not isnull(popup.dataobject) and not popup.multiselect then
	if popup.blank_at_bottom then
		blank_row = dw_pick.insertrow(0)
	else
		blank_row = dw_pick.insertrow(1)
	end if
	if popup.blank_text = "" or isnull(popup.blank_text) then
		popup.blank_text =  "<< Blank >>"
	end if
	CHOOSE CASE lower(popup.blank_text_column)
		CASE "data"
			dw_pick.setitem(blank_row, popup.datacolumn, popup.blank_text)
		CASE ELSE
			dw_pick.setitem(blank_row, popup.displaycolumn, popup.blank_text)
	END CHOOSE
else
	setnull(blank_row)
end if

// Check for singleton
if popup.auto_singleton and dw_pick.rowcount() = 1 then
	picked(1)
	return
end if

// Check for rows.  If no rows, treat as if cancel were pressed
if dw_pick.rowcount() = 0 then
	cb_cancel.triggerevent("clicked")
	return
end if

// If we get here in server mode then cancel
if cpr_mode = "SERVER" then
	cb_cancel.event trigger clicked()
	return
end if

// Finally, resize the window to fit the displayed data
sizeandmove()

setfocus()
end event

on w_pop_pick.create
int iCurrent
call super::create
this.pb_down=create pb_down
this.pb_up=create pb_up
this.st_page=create st_page
this.dw_pick=create dw_pick
this.st_title=create st_title
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_down
this.Control[iCurrent+2]=this.pb_up
this.Control[iCurrent+3]=this.st_page
this.Control[iCurrent+4]=this.dw_pick
this.Control[iCurrent+5]=this.st_title
this.Control[iCurrent+6]=this.cb_ok
this.Control[iCurrent+7]=this.cb_cancel
end on

on w_pop_pick.destroy
call super::destroy
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.st_page)
destroy(this.dw_pick)
destroy(this.st_title)
destroy(this.cb_ok)
destroy(this.cb_cancel)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_pop_pick
integer width = 256
integer height = 128
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pop_pick
end type

type pb_down from u_picture_button within w_pop_pick
integer x = 677
integer y = 352
integer width = 137
integer height = 116
integer taborder = 20
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_pick.current_page
li_last_page = dw_pick.last_page

dw_pick.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true


end event

type pb_up from u_picture_button within w_pop_pick
integer x = 677
integer y = 228
integer width = 137
integer height = 116
integer taborder = 10
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_pick.current_page

dw_pick.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type st_page from statictext within w_pop_pick
integer x = 681
integer y = 484
integer width = 146
integer height = 124
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99/99"
boolean focusrectangle = false
end type

type dw_pick from u_dw_pick_list within w_pop_pick
integer x = 46
integer y = 200
integer height = 964
integer taborder = 10
string dataobject = "dw_pick_generic"
boolean border = false
boolean livescroll = false
end type

event post_click;call super::post_click;str_popup_return popup_return
string ls_col, ls_coltype

if lastrow <= 0 then return

if not multiselect then picked(lastrow)


end event

type st_title from statictext within w_pop_pick
integer x = 73
integer y = 28
integer width = 763
integer height = 72
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_pop_pick
integer x = 18
integer y = 1396
integer width = 663
integer height = 124
integer taborder = 20
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;integer li_rows, i, li_selected, li_rowcount
str_popup_return popup_return
string ls_coltype, ls_col

if display_list then
	popup_return.item_count = 0
	closewithreturn(parent, popup_return)
	return
end if

li_rows = 0
li_rowcount = dw_pick.rowcount()

for i = 1 to li_rowcount
	li_selected = dw_pick.object.selected_flag[i]
	if li_selected > 0 then
		li_rows += 1
		if i = blank_row then
			popup_return.items[li_rows] = ""
			popup_return.descriptions[li_rows] = string(dw_pick.object.data[i, popup.displaycolumn])
		else
			if popup.data_row_count = 0 then
				ls_col = "#" + string(popup.datacolumn)
				ls_coltype = UPPER(left(dw_pick.Describe(ls_col + ".ColType"), 4))
				if ls_coltype = "NUMB" then
					popup_return.items[li_rows] = string(dw_pick.object.data[i, popup.datacolumn])
				elseif ls_coltype = "LONG" then
					popup_return.items[li_rows] = string(dw_pick.object.data[i, popup.datacolumn])
				elseif ls_coltype = "CHAR" then
					popup_return.items[li_rows] = dw_pick.object.data[i, popup.datacolumn]
				end if
				popup_return.descriptions[li_rows] = string(dw_pick.object.data[i, popup.displaycolumn])
			else
				popup_return.item_indexes[li_rows] = i
			end if
		end if
	end if
next

popup_return.item_count = li_rows
popup_return.choices_count = dw_pick.rowcount()

closewithreturn(parent, popup_return)

end event

type cb_cancel from commandbutton within w_pop_pick
integer x = 14
integer y = 1260
integer width = 663
integer height = 124
integer taborder = 30
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;str_popup_return popup_return

setnull(popup_return.item)
popup_return.cancel_selected = true
popup_return.item_index = 0
popup_return.item_count = 0
popup_return.choices_count = dw_pick.rowcount()

closewithreturn(parent, popup_return)
end event

