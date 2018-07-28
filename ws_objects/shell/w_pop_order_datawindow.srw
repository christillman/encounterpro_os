HA$PBExportHeader$w_pop_order_datawindow.srw
forward
global type w_pop_order_datawindow from w_window_base
end type
type dw_pick from u_dw_pick_list within w_pop_order_datawindow
end type
type st_title from statictext within w_pop_order_datawindow
end type
type cb_ok from commandbutton within w_pop_order_datawindow
end type
type pb_up from u_picture_button within w_pop_order_datawindow
end type
type pb_down from u_picture_button within w_pop_order_datawindow
end type
type pb_bottom from u_picture_button within w_pop_order_datawindow
end type
type pb_top from u_picture_button within w_pop_order_datawindow
end type
type str_point from structure within w_pop_order_datawindow
end type
end forward

type str_point from structure
	long		x
	long		y
end type

global type w_pop_order_datawindow from w_window_base
integer width = 1915
integer height = 1864
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
dw_pick dw_pick
st_title st_title
cb_ok cb_ok
pb_up pb_up
pb_down pb_down
pb_bottom pb_bottom
pb_top pb_top
end type
global w_pop_order_datawindow w_pop_order_datawindow

type prototypes
SUBROUTINE GetCursorPos( ref str_point lppt ) LIBRARY "USER32.DLL" alias for "GetCursorPos;Ansi"

end prototypes

type variables
str_popup popup

long blank_row

boolean display_list = false

u_dw_pick_list pick_list
CommandButton page_button
statictext textbox

boolean autosave = false

long list_count


end variables

forward prototypes
public function integer initialize ()
end prototypes

public function integer initialize ();long ll_row
long i

pick_list = dw_pick

setnull(page_button)
setnull(textbox)

autosave = true

list_count = pick_list.rowcount()
if list_count <= 0 then
	log.log(this, "open", "pick list empty", 4)
	close(this)
	return -1
end if

for i = 1 to list_count
	pick_list.object.sort_sequence[i] = i
next

if autosave then pick_list.update()

pb_up.enabled = false
pb_top.enabled = false
pb_down.enabled = false
pb_bottom.enabled = false

end function

event open;call super::open;integer li_sts
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
			ll_rows = dw_pick.retrieve(popup.argument[1], &
									popup.argument[2], &
									popup.argument[3], &
									popup.argument[4])
		CASE 5
			ll_rows = dw_pick.retrieve(popup.argument[1], &
									popup.argument[2], &
									popup.argument[3], &
									popup.argument[4], &
									popup.argument[5])
		CASE 6
			ll_rows = dw_pick.retrieve(popup.argument[1], &
									popup.argument[2], &
									popup.argument[3], &
									popup.argument[4], &
									popup.argument[5], &
									popup.argument[6])
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

//// Check for singleton
//if popup.auto_singleton and dw_pick.rowcount() = 1 then
//	picked(1)
//	return
//end if
//
//// Check for rows.  If no rows, treat as if cancel were pressed
//if dw_pick.rowcount() = 0 then
//	cb_cancel.triggerevent("clicked")
//	return
//end if

// If we get here in server mode then cancel
if cpr_mode = "SERVER" then
	cb_ok.event trigger clicked()
	return
end if

li_sts = initialize()

setfocus()

end event

on w_pop_order_datawindow.create
int iCurrent
call super::create
this.dw_pick=create dw_pick
this.st_title=create st_title
this.cb_ok=create cb_ok
this.pb_up=create pb_up
this.pb_down=create pb_down
this.pb_bottom=create pb_bottom
this.pb_top=create pb_top
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_pick
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.cb_ok
this.Control[iCurrent+4]=this.pb_up
this.Control[iCurrent+5]=this.pb_down
this.Control[iCurrent+6]=this.pb_bottom
this.Control[iCurrent+7]=this.pb_top
end on

on w_pop_order_datawindow.destroy
call super::destroy
destroy(this.dw_pick)
destroy(this.st_title)
destroy(this.cb_ok)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.pb_bottom)
destroy(this.pb_top)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_pop_order_datawindow
integer x = 2866
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pop_order_datawindow
end type

type dw_pick from u_dw_pick_list within w_pop_order_datawindow
integer x = 18
integer y = 120
integer width = 1358
integer height = 1688
integer taborder = 10
string dataobject = "dw_pick_generic"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event selected;call super::selected;if selected_row > 1 then
	pb_up.enabled = true
	pb_top.enabled = true
else
	pb_up.enabled = false
	pb_top.enabled = false
end if

if selected_row < list_count then
	pb_down.enabled = true
	pb_bottom.enabled = true
else
	pb_down.enabled = false
	pb_bottom.enabled = false
end if

end event

event unselected;call super::unselected;pb_up.enabled = false
pb_top.enabled = false
pb_down.enabled = false
pb_bottom.enabled = false

end event

type st_title from statictext within w_pop_order_datawindow
integer width = 1879
integer height = 100
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_pop_order_datawindow
integer x = 1463
integer y = 1692
integer width = 375
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;
close(parent)

end event

type pb_up from u_picture_button within w_pop_order_datawindow
integer x = 1527
integer y = 560
integer taborder = 20
boolean bringtotop = true
boolean originalsize = false
string picturename = "buttonup.bmp"
string disabledname = "buttonupx.bmp"
end type

event clicked;long ll_row
integer li_temp
string ls_text

ll_row = pick_list.get_selected_row()
if ll_row <= 1 then
	pb_top.enabled = false
	return
end if
pb_top.enabled = true
pick_list.setredraw(false)

li_temp = pick_list.object.sort_sequence[ll_row - 1]

pick_list.object.sort_sequence[ll_row - 1] = pick_list.object.sort_sequence[ll_row]

pick_list.object.sort_sequence[ll_row] = li_temp

pick_list.sort()

ll_row = pick_list.get_selected_row()

pick_list.scrolltorow(ll_row)

//if not isnull(page_button) then
//	pick_list.recalc_page(page_button.text)
//elseif not isnull(textbox) then
//	pick_list.recalc_page(textbox.text)
//else
//	pick_list.recalc_page(ls_text)
//end if

if autosave then pick_list.update()

pick_list.setredraw(true)

pb_down.enabled = true
pb_bottom.enabled = true

if ll_row > 1 then
	pb_up.enabled = true
	pb_top.enabled = true
else
	pb_up.enabled = false
	pb_top.enabled = false
end if

end event

type pb_down from u_picture_button within w_pop_order_datawindow
integer x = 1527
integer y = 792
integer taborder = 20
boolean bringtotop = true
boolean originalsize = false
string picturename = "buttondn.bmp"
string disabledname = "buttondnx.bmp"
end type

event clicked;call super::clicked;long ll_row
integer li_temp
string ls_text

ll_row = pick_list.get_selected_row()
if ll_row <= 0 then return
if ll_row >= pick_list.rowcount() then
	pb_bottom.enabled = false
	return
end if
pb_bottom.enabled = true
pick_list.setredraw(false)

li_temp = pick_list.object.sort_sequence[ll_row + 1]

pick_list.object.sort_sequence[ll_row + 1] = pick_list.object.sort_sequence[ll_row]

pick_list.object.sort_sequence[ll_row] = li_temp

pick_list.sort()

ll_row = pick_list.get_selected_row()

pick_list.scrolltorow(ll_row)

//if not isnull(page_button) then
//	pick_list.recalc_page(page_button.text)
//elseif not isnull(textbox) then
//	pick_list.recalc_page(textbox.text)
//else
//	pick_list.recalc_page(ls_text)
//end if

if autosave then pick_list.update()

pick_list.setredraw(true)

pb_up.enabled = true
pb_top.enabled = true

if ll_row < pick_list.rowcount() then
	pb_down.enabled = true
	pb_bottom.enabled = true
else
	pb_down.enabled = false
	pb_bottom.enabled = false
end if

end event

type pb_bottom from u_picture_button within w_pop_order_datawindow
integer x = 1527
integer y = 1024
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
string picturename = "buttonlast.bmp"
string disabledname = "buttonlastx.bmp"
end type

event clicked;call super::clicked;long ll_row,ll_rowcount
integer li_temp
string ls_text
long i

ll_row = pick_list.get_selected_row()
if ll_row <= 0 then return
ll_rowcount = pick_list.rowcount()
if ll_row >= ll_rowcount then return

pick_list.setredraw(false)

for i = 1 to pick_list.rowcount()
	if i < ll_row then
		pick_list.object.sort_sequence[i] = i
	elseif i = ll_row then
		pick_list.object.sort_sequence[i] = pick_list.rowcount()
	else
		pick_list.object.sort_sequence[i] = i - 1
	end if
next

li_temp = pick_list.object.sort_sequence[ll_rowcount]

pick_list.object.sort_sequence[ll_row] = pick_list.object.sort_sequence[ll_rowcount] + 1

pick_list.sort()

ll_row = pick_list.get_selected_row()

pick_list.scrolltorow(ll_row)

//if not isnull(page_button) then
//	pick_list.recalc_page(page_button.text)
//elseif not isnull(textbox) then
//	pick_list.recalc_page(textbox.text)
//else
//	pick_list.recalc_page(ls_text)
//end if

if autosave then pick_list.update()

pick_list.setredraw(true)

pb_up.enabled = true
pb_down.enabled = false
pb_top.enabled = true
enabled = false
end event

type pb_top from u_picture_button within w_pop_order_datawindow
integer x = 1527
integer y = 324
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
string picturename = "buttontop.bmp"
string disabledname = "buttontopx.bmp"
end type

event clicked;long ll_row,ll_rowcount
integer li_temp
string ls_text
long i

ll_row = pick_list.get_selected_row()
if ll_row <= 1 then return

pick_list.setredraw(false)

for i = 1 to pick_list.rowcount()
	if i < ll_row then
		pick_list.object.sort_sequence[i] = i + 1
	elseif i = ll_row then
		pick_list.object.sort_sequence[i] = 1
	else
		pick_list.object.sort_sequence[i] = i
	end if
next
	
pick_list.sort()

ll_row = pick_list.get_selected_row()

pick_list.scrolltorow(ll_row)

//if not isnull(page_button) then
//	pick_list.recalc_page(page_button.text)
//elseif not isnull(textbox) then
//	pick_list.recalc_page(textbox.text)
//else
//	pick_list.recalc_page(ls_text)
//end if

if autosave then pick_list.update()

pick_list.setredraw(true)

pb_up.enabled = false
pb_down.enabled = true
pb_bottom.enabled = true
enabled = false
end event

