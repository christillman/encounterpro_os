$PBExportHeader$w_pop_display_datawindow.srw
forward
global type w_pop_display_datawindow from w_window_base
end type
type dw_pick from u_dw_pick_list within w_pop_display_datawindow
end type
type st_title from statictext within w_pop_display_datawindow
end type
type cb_ok from commandbutton within w_pop_display_datawindow
end type
type str_point from structure within w_pop_display_datawindow
end type
end forward

type str_point from structure
	long		x
	long		y
end type

global type w_pop_display_datawindow from w_window_base
integer width = 2962
integer height = 1864
boolean titlebar = false
string title = ""
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
dw_pick dw_pick
st_title st_title
cb_ok cb_ok
end type
global w_pop_display_datawindow w_pop_display_datawindow

type prototypes
SUBROUTINE GetCursorPos( ref str_point lppt ) LIBRARY "USER32.DLL" alias for "GetCursorPos;Ansi"

end prototypes

type variables
str_popup popup

long blank_row

boolean display_list = false

end variables

event open;call super::open;// This window expects the datawindow object to be passed in the "popup" structure
// The datawindow is expected to display column #1.
// If no data array is passed, then the datawindow is expected to have an SQL select
// and the data to be returned will be in column #2.

integer i
long ll_rows
str_point pt

popup = message.powerobjectparm

// If we get here in server mode then cancel
if gnv_app.cpr_mode = "SERVER" then
	cb_ok.event trigger clicked()
	return
end if

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


setfocus()

end event

on w_pop_display_datawindow.create
int iCurrent
call super::create
this.dw_pick=create dw_pick
this.st_title=create st_title
this.cb_ok=create cb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_pick
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.cb_ok
end on

on w_pop_display_datawindow.destroy
call super::destroy
destroy(this.dw_pick)
destroy(this.st_title)
destroy(this.cb_ok)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_pop_display_datawindow
integer x = 2866
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pop_display_datawindow
end type

type dw_pick from u_dw_pick_list within w_pop_display_datawindow
integer x = 18
integer y = 120
integer width = 2894
integer height = 1536
integer taborder = 10
string dataobject = "dw_pick_generic"
boolean vscrollbar = true
boolean livescroll = false
borderstyle borderstyle = stylelowered!
end type

type st_title from statictext within w_pop_display_datawindow
integer width = 2926
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

type cb_ok from commandbutton within w_pop_display_datawindow
integer x = 2318
integer y = 1688
integer width = 558
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

