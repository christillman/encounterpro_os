$PBExportHeader$u_dw_pick_list.sru
forward
global type u_dw_pick_list from datawindow
end type
end forward

global type u_dw_pick_list from datawindow
integer width = 558
integer height = 1212
integer taborder = 1
boolean livescroll = true
event post_click ( long clicked_row )
event unselected ( long unselected_row )
event selected ( long selected_row )
event computed_clicked ( long clicked_row )
end type
global u_dw_pick_list u_dw_pick_list

type variables
boolean multiselect = false
boolean active_header = false
boolean select_computed = true
boolean suppress_scroll_event = false

string mousebutton

integer lastrow
integer lastcolumn
string lastcolumnname
string lasttype
boolean lastselected
boolean lastheader
boolean lastcomputed

integer current_page
integer last_page

picturebutton button_up
picturebutton button_down
statictext page_display

boolean multiselect_ctrl = false

end variables

forward prototypes
public subroutine set_title (string ps_title)
public subroutine set_no_title ()
public function boolean toggle_last ()
public subroutine delete_selected ()
public function long get_selected_row ()
public function long get_selected_row (long pl_row)
public subroutine set_page (integer pi_newpage, ref string ps_page_text)
public subroutine set_page_old (integer pi_newpage, ref string ps_page_text)
public function integer count_selected ()
public subroutine set_last ()
public subroutine set_row ()
public subroutine set_row (long pl_row)
public subroutine clear_selected (boolean pb_trigger)
public subroutine clear_selected ()
public subroutine clear_last ()
public subroutine set_buttons (ref picturebutton po_button_up, ref picturebutton po_button_down, ref statictext pst_page_display)
public subroutine set_page (integer pi_new_page, ref picturebutton po_button_up, ref picturebutton po_button_down, ref statictext pst_page_display)
public function integer recalc_page (ref string ps_page_text)
public function integer recalc_page (ref picturebutton po_button_up, ref picturebutton po_button_down, ref statictext pst_page_display)
public subroutine set_page_to_row (integer pl_row, ref picturebutton po_button_up, ref picturebutton po_button_down, ref statictext pst_page_display)
public function long get_last_selected_row ()
public subroutine scroll_to_row (long pl_row)
public function boolean is_column (string ps_column)
end prototypes

event post_click;modify("datawindow.selected=''")

end event

public subroutine set_title (string ps_title);titlebar = true
title = ps_title
end subroutine

public subroutine set_no_title ();titlebar = false
end subroutine

public function boolean toggle_last ();Integer	li_selected_flag
String	ls_column

ls_column = Describe("selected_flag.name")
IF ls_column = "selected_flag" AND lastrow > 0 THEN
	li_selected_flag = object.selected_flag[lastrow]
	
	IF li_selected_flag = 0 THEN
		Setitem(lastrow, "selected_flag", 1)
		This.event POST selected(lastrow)
		Return True
	ELSE
		Setitem(lastrow, "selected_flag", 0)
		This.Event POST unselected(lastrow)
		Return False
	END IF
END IF


end function

public subroutine delete_selected ();long ll_row, ll_end
integer li_selected_flag
string ls_column, ls_find

ls_column = describe("selected_flag.name")
if ls_column = "selected_flag" then
	ll_end = rowcount()
	ls_find = "selected_flag=1"
	ll_row = Find(ls_find, 1, ll_end)
	DO WHILE ll_row > 0
		deleterow(ll_row)
		// increment to next row to start next search - By Sumathi 12/13/99
		ll_row++
		If ll_row > ll_end Then Exit
		ll_row = Find(ls_find, ll_row, ll_end)
	LOOP
end if

end subroutine

public function long get_selected_row ();long ll_row, ll_end
integer li_selected_flag
string ls_column, ls_find

ls_column = describe("selected_flag.name")
if ls_column = "selected_flag" then
	ll_end = rowcount()
	ls_find = "selected_flag=1"
	return Find(ls_find, 1, ll_end)
else
	return 0
end if


end function

public function long get_selected_row (long pl_row);long ll_row, ll_end
integer li_selected_flag
string ls_column, ls_find

// Only find selected rows after the specified row

ls_column = describe("selected_flag.name")
if ls_column = "selected_flag" then
	ll_end = rowcount()
	ls_find = "selected_flag=1"
	ll_row = find(ls_find, pl_row + 1, ll_end + 1)
	if ll_row <= 0 or ll_row > ll_end then
		return 0
	else
		return ll_row
	end if
else
	return 0
end if


end function

public subroutine set_page (integer pi_newpage, ref string ps_page_text);integer i
long ll_rowcount
long ll_lastrowonpage
long ll_lastlastrowonpage

setredraw(false)
suppress_scroll_event = true

if last_page > 0 and current_page > 0 then
	if pi_newpage > last_page then pi_newpage = 1
	if pi_newpage < 1 then pi_newpage = last_page
	
	if pi_newpage > current_page then
		for i = current_page + 1 to pi_newpage
			scrollnextpage()
		next
	else
		for i = current_page - 1 to pi_newpage step -1
			scrollpriorpage()
		next
	end if
else
	ll_rowcount =  rowcount()
	scrolltorow(1)
	last_page = 1
	ll_lastlastrowonpage = 0
	
	DO WHILE true
		ll_lastrowonpage = Integer(Describe("DataWindow.LastRowOnPage"))
		// Occasionally, the lastrowonpage never gets to the rowcount(), so stop looping
		// when the lastrowonpage doesn't change
		if ll_rowcount <= ll_lastrowonpage  or ll_lastrowonpage = ll_lastlastrowonpage then exit
		ll_lastlastrowonpage = ll_lastrowonpage
		ScrollNextPage()
		last_page++
	LOOP
	
	scrolltorow(1)
	for i = 2 to pi_newpage
		scrollnextpage()
	next
end if

suppress_scroll_event = true

setredraw(true)

current_page = pi_newpage

ps_page_text = "Page " + string(current_page) + "/" + string(last_page)

end subroutine

public subroutine set_page_old (integer pi_newpage, ref string ps_page_text);long ll_toprow, ll_newpos, ll_rowcount, ll_of, ll_m, ll_rows_per_page, ll_detail_height

ll_rowcount =  rowcount()
ll_m = long(describe("datawindow.verticalscrollmaximum"))
ll_detail_height = long(describe("datawindow.detail.height"))

if ll_detail_height > 0 then
	ll_rows_per_page = height / ll_detail_height
	if ll_rows_per_page < 1 then ll_rows_per_page = 1
else
	ll_rows_per_page = 10
end if

ll_of = ((ll_rowcount - 1) / ll_rows_per_page) + 1

if pi_newpage < 1 then pi_newpage = ll_of
if pi_newpage > ll_of then pi_newpage = 1

ll_toprow = ((pi_newpage - 1) * ll_rows_per_page)
if ll_rowcount > ll_rows_per_page then
	ll_newpos = ll_toprow * ll_m / (ll_rowcount - ll_rows_per_page)
else
	ll_newpos = 1
end if

if ll_newpos < 1 then ll_newpos = 1
if ll_newpos > ll_m then ll_newpos = ll_m

modify("datawindow.verticalscrollposition=" + string(ll_newpos))

current_page = pi_newpage

ps_page_text = "Page " + string(current_page) + "/" + string(ll_of)

end subroutine

public function integer count_selected ();integer i, li_count, li_selected_flag
string ls_column

li_count = 0

ls_column = describe("selected_flag.name")
if ls_column = "selected_flag" then
	for i = 1 to rowcount()
		li_selected_flag = object.selected_flag[i]
		if li_selected_flag = 1 then li_count += 1
	next
else
	li_count = 0
end if


return li_count

end function

public subroutine set_last ();setitem(lastrow, "selected_flag", 1)
This.event POST selected(lastrow)

end subroutine

public subroutine set_row ();string ls_column
integer li_selected_flag

// We assume that lastrow holds the row to select, but check it to make sure
if lastrow <= 0 then return

// Go ahead and post the post_click event
This.event POST post_click(lastrow)

// Make sure there is a "selected_flag" column before setting it
ls_column = describe("selected_flag.name")
if ls_column = "selected_flag" then
	// If the datawindow object contains a selected_flag field, then set or clear it
	if multiselect and ((not multiselect_ctrl) or keydown(KeyControl!)) then
		lastselected = toggle_last()
	else
		// Record whether this row was already selected
		li_selected_flag = object.selected_flag[lastrow]
		
		// Clear the selected row
		clear_selected()
		
		// If this row wasn't already selected then set it
		if li_selected_flag <> 1 then
			set_last()
			lastselected = true
		end if
	end if
end if

end subroutine

public subroutine set_row (long pl_row);lastrow = pl_row
set_row()

end subroutine

public subroutine clear_selected (boolean pb_trigger);long ll_row, ll_end
integer li_selected_flag
string ls_column, ls_find

ls_column = describe("selected_flag.name")
if ls_column = "selected_flag" then
	ll_end = rowcount()
	ls_find = "selected_flag=1"
	ll_row = Find(ls_find, 1, ll_end)
	DO WHILE ll_row > 0 AND ll_row <= ll_end
		setitem(ll_row, "selected_flag", 0)
		if pb_trigger then this.event POST unselected(ll_row)
		ll_row = Find(ls_find, ll_row + 1, ll_end + 1)
	LOOP
end if

end subroutine

public subroutine clear_selected ();clear_selected(true)

end subroutine

public subroutine clear_last ();setitem(lastrow, "selected_flag", 0)
This.event POST unselected(lastrow)

end subroutine

public subroutine set_buttons (ref picturebutton po_button_up, ref picturebutton po_button_down, ref statictext pst_page_display);button_up = po_button_up
button_down = po_button_down
page_display = pst_page_display

if not isvalid(button_up) or not isvalid(button_down) or not isvalid(page_display) then return

if last_page <= 1 then
	po_button_up.visible = false
	po_button_down.visible = false
	pst_page_display.visible = false
	return
end if

po_button_up.visible = true
po_button_down.visible = true
pst_page_display.visible = true

if current_page > 1 then
	po_button_up.enabled = true
else
	po_button_up.enabled = false
end if

if current_page < last_page then
	po_button_down.enabled = true
else
	po_button_down.enabled = false
end if

pst_page_display.text = "Page " + string(current_page) + "/" + string(last_page)


end subroutine

public subroutine set_page (integer pi_new_page, ref picturebutton po_button_up, ref picturebutton po_button_down, ref statictext pst_page_display);
set_page(pi_new_page, pst_page_display.text)
set_buttons(po_button_up, po_button_down, pst_page_display)

end subroutine

public function integer recalc_page (ref string ps_page_text);integer i
long ll_rowcount
long ll_firstrowoncurrentpage
long ll_Firstrowonpage
long ll_lastrowonpage
long ll_lastlastrowonpage

setredraw(false)

ll_firstrowoncurrentpage = Integer(Describe("DataWindow.FirstRowOnPage"))

ll_rowcount =  rowcount()
scrolltorow(1)
last_page = 1
ll_lastlastrowonpage = 0
//current_page = 1

DO WHILE true
	ll_Firstrowonpage = Integer(Describe("DataWindow.FirstRowOnPage"))
	ll_lastrowonpage = Integer(Describe("DataWindow.LastRowOnPage"))
	// Occasionally, the lastrowonpage never gets to the rowcount(), so stop looping
	// when the lastrowonpage doesn't change
	if ll_rowcount <= ll_lastrowonpage  or ll_lastrowonpage = ll_lastlastrowonpage then exit
	ll_lastlastrowonpage = ll_lastrowonpage
	if (ll_Firstrowonpage <= ll_firstrowoncurrentpage) &
		and (ll_lastrowonpage >= ll_firstrowoncurrentpage) then current_page = last_page
	//if ll_Firstrowonpage < ll_firstrowoncurrentpage then current_page++
	last_page++
	ScrollNextPage()
LOOP

scrolltorow(1)
for i = 2 to current_page
	scrollnextpage()
next

setredraw(true)

ps_page_text = "Page " + string(current_page) + "/" + string(last_page)

return current_page

end function

public function integer recalc_page (ref picturebutton po_button_up, ref picturebutton po_button_down, ref statictext pst_page_display);recalc_page(pst_page_display.text)
set_buttons(po_button_up, po_button_down, pst_page_display)

return current_page


end function

public subroutine set_page_to_row (integer pl_row, ref picturebutton po_button_up, ref picturebutton po_button_down, ref statictext pst_page_display);integer li_page
long ll_rowcount
long ll_lastlastrowonpage
long ll_lastrowonpage
long i

ll_rowcount =  rowcount()
scrolltorow(1)
li_page = 1
ll_lastlastrowonpage = 0

DO WHILE true
	ll_lastrowonpage = Integer(Describe("DataWindow.LastRowOnPage"))
	if ll_lastrowonpage >= pl_row then exit
	// Occasionally, the lastrowonpage never gets to the rowcount(), so stop looping
	// when the lastrowonpage doesn't change
	if ll_rowcount <= ll_lastrowonpage  or ll_lastrowonpage = ll_lastlastrowonpage then exit
	ll_lastlastrowonpage = ll_lastrowonpage
	ScrollNextPage()
	li_page++
LOOP

set_page(li_page, pst_page_display.text)
set_buttons(po_button_up, po_button_down, pst_page_display)

end subroutine

public function long get_last_selected_row ();long ll_row, ll_end
integer li_selected_flag
string ls_column, ls_find

ls_column = describe("selected_flag.name")
if ls_column = "selected_flag" then
	ll_end = rowcount()
	ls_find = "selected_flag=1"
	return Find(ls_find, ll_end, 1)
else
	return 0
end if


end function

public subroutine scroll_to_row (long pl_row);long ll_lastrowonpage
long ll_last_lastrowonpage
long ll_firstrowonpage
long ll_last_firstrowonpage
long i

// This method scrolls the datawindow up or down one row at a time until the
// desired row is just visible.

ll_firstrowonpage = long(object.DataWindow.FirstRowOnPage)
ll_lastrowonpage = long(object.DataWindow.LastRowOnPage)

if pl_row >= ll_firstrowonpage and pl_row <= ll_lastrowonpage then return

i = rowcount()

if pl_row > ll_lastrowonpage then
	DO WHILE true
		if pl_row <= ll_lastrowonpage then exit
		i -= 1
		scrolltorow(ll_lastrowonpage + 1)
		ll_last_lastrowonpage = ll_lastrowonpage
		ll_lastrowonpage = long(object.DataWindow.LastRowOnPage)
		if ll_last_lastrowonpage = ll_lastrowonpage then exit
		if i <= 0 then exit
	LOOP
else
	DO WHILE true
		if pl_row >= ll_firstrowonpage then exit
		i -= 1
		scrolltorow(ll_firstrowonpage - 1)
		ll_last_firstrowonpage = ll_firstrowonpage
		ll_firstrowonpage = long(object.DataWindow.FirstRowOnPage)
		if ll_last_firstrowonpage = ll_firstrowonpage then exit
		if i <= 0 then exit
	LOOP
end if



end subroutine

public function boolean is_column (string ps_column);string ls_column

if isnull(ps_column) then return false

ps_column = trim(lower(ps_column))
ls_column = describe(ps_column + ".name")
if lower(ls_column) = ps_column then return true

return false


end function

event clicked;string ls_column
string ls_temp
long ll_pos
integer li_selected_flag
integer li_column

// Set the 'last' values
lasttype = dwo.type
lastrow = row 
lastheader = false
lastcomputed = false
lastcolumnname = dwo.name

if lasttype = "column" then
	lastcolumn = integer(dwo.id)
elseif lasttype = "compute" then
	lastcolumn = 0
	ls_temp = lower(left(describe(dwo.name + ".expression"), 6))
	if ls_temp = "bitmap" or ls_temp = "~"bitma" then lastcomputed = true
else
	lastcolumn = 0
end if

// If we didn't click on a row, check to see if we clicked on a header
if lastrow <= 0 then
	if active_header then
		ls_temp = GetBandAtPointer()
		ll_pos = pos(ls_temp,"~t")
		lastrow = long(mid(ls_temp,ll_pos, 4))
		if lastrow > 0 then
			// If we clicked on a header, then set lastheader and post post_click event
			lastheader = true
			set_row()
		end if
	end if
elseif lastcomputed then
	This.event POST computed_clicked(lastrow)
	if select_computed then set_row()
else
	set_row()
end if

if lastrow <= 0 then return

mousebutton = "LEFT"


end event

event rbuttondown;integer i
integer li_selected_flag
string ls_object, ls_left, ls_right, ls_column


if config_mode and keydown(keycontrol!) then
	openwithparm(w_pop_message, dataobject)
	clipboard(dataobject)
	return
end if

ls_object = getobjectatpointer()
f_split_string(ls_object, "~t", ls_left, ls_right)

lastrow = integer(ls_right)
lastcolumn = 1
if lastrow = 0 then return

ls_column = describe("selected_flag.name")
if ls_column = "selected_flag" then
	if multiselect and ((not multiselect_ctrl) or keydown(KeyControl!)) then
		li_selected_flag = object.selected_flag[lastrow]
		setitem(lastrow, "selected_flag", 1 - li_selected_flag)
	else
		for i = 1 to rowcount()
			setitem(i, "selected_flag", 0)
		next
		setitem(lastrow, "selected_flag", 1)
	end if
end if

mousebutton = "RIGHT"

postevent("post_click")


end event

event dberror;string ls_message

ls_message = "DATAWINDOW SQL ERROR = (" + string(sqldbcode) + ") " + sqlerrtext
if not isnull(dataobject) then
	ls_message += "~r~nDataobject = " + dataobject
end if
if not isnull(sqlsyntax) then
	ls_message += "~r~nSQL Statement = " + sqlsyntax
end if

log.log(this, "u_dw_pick_list:dber", ls_message, 4)

return 1

end event

event retrieveend;last_page = 0

end event

on u_dw_pick_list.create
end on

on u_dw_pick_list.destroy
end on

event scrollvertical;long ll_Firstrowonpage
long ll_lastrowonpage
long ll_rows
long ll_rows_on_this_page
long ll_rows_on_avg_page
long ll_new_current_page

if suppress_scroll_event then return

if current_page <= 0 or last_page <= 0 then return

ll_Firstrowonpage = Integer(Describe("DataWindow.FirstRowOnPage"))
ll_lastrowonpage = Integer(Describe("DataWindow.LastRowOnPage"))
ll_rows = rowcount()
ll_rows_on_this_page = ll_lastrowonpage - ll_Firstrowonpage + 1
ll_rows_on_avg_page = ll_rows / last_page

if ll_lastrowonpage >= ll_rows then
	current_page = last_page
elseif ll_Firstrowonpage = 1 then
	current_page = 1
else
	ll_new_current_page = (ll_Firstrowonpage / ll_rows_on_avg_page) + 1
	if current_page < 2 then current_page = 2
	if current_page > (last_page - 1) then current_page = last_page - 1
end if

set_buttons(button_up, button_down, page_display)

end event

event updatestart;tf_begin_transaction(this, "updatestart")

end event

event updateend;tf_commit()


end event

