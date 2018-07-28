$PBExportHeader$w_pick_list_sort.srw
forward
global type w_pick_list_sort from w_window_base
end type
type pb_up from u_picture_button within w_pick_list_sort
end type
type pb_down from u_picture_button within w_pick_list_sort
end type
type pb_done from u_picture_button within w_pick_list_sort
end type
type pb_bottom from u_picture_button within w_pick_list_sort
end type
type pb_top from u_picture_button within w_pick_list_sort
end type
end forward

global type w_pick_list_sort from w_window_base
integer x = 1275
integer y = 576
integer width = 366
integer height = 1224
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_up pb_up
pb_down pb_down
pb_done pb_done
pb_bottom pb_bottom
pb_top pb_top
end type
global w_pick_list_sort w_pick_list_sort

type variables
u_dw_pick_list pick_list
CommandButton page_button
statictext textbox

boolean autosave = false

long list_count


end variables

on w_pick_list_sort.create
int iCurrent
call super::create
this.pb_up=create pb_up
this.pb_down=create pb_down
this.pb_done=create pb_done
this.pb_bottom=create pb_bottom
this.pb_top=create pb_top
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_up
this.Control[iCurrent+2]=this.pb_down
this.Control[iCurrent+3]=this.pb_done
this.Control[iCurrent+4]=this.pb_bottom
this.Control[iCurrent+5]=this.pb_top
end on

on w_pick_list_sort.destroy
call super::destroy
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.pb_done)
destroy(this.pb_bottom)
destroy(this.pb_top)
end on

event open;call super::open;str_popup popup
long ll_row
long i

popup = message.powerobjectparm

// The pick_list instance variable is an u_dw_pick_list object and must
// have a datawindow object which contains both a "selected_flag" field
// and a "sort_sequence" field.
pick_list = popup.objectparm

// Optionally, a page_button may be passed in as the second
// object parameter.  If so then it will be updated automatically
// using the u_dw_pick_list.set_page() method.
setnull(page_button)
setnull(textbox)
if isvalid(popup.objectparm2) and not isnull(popup.objectparm2) then
	if lower(popup.objectparm2.classname()) = "commandbutton" then
		page_button = popup.objectparm2
	elseif lower(popup.objectparm2.classname()) = "statictext" then
		textbox = popup.objectparm2
	end if
end if

if popup.item = "SAVE" then
	autosave = true
end if

list_count = pick_list.rowcount()
if list_count <= 0 then
	log.log(this, "open", "pick list empty", 4)
	close(this)
	return
end if

ll_row = pick_list.get_selected_row()
if ll_row <= 0 then
	log.log(this, "open", "no selected row", 4)
	close(this)
	return
end if

for i = 1 to list_count
	pick_list.object.sort_sequence[i] = i
next

if autosave then pick_list.update()

if ll_row > 1 then
	pb_up.enabled = true
	pb_top.enabled = true
else
	pb_up.enabled = false
	pb_top.enabled = false
end if

if ll_row < list_count then
	pb_down.enabled = true
	pb_bottom.enabled = true
else
	pb_down.enabled = false
	pb_bottom.enabled = false
end if

end event

type pb_epro_help from w_window_base`pb_epro_help within w_pick_list_sort
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pick_list_sort
end type

type pb_up from u_picture_button within w_pick_list_sort
integer x = 41
integer y = 268
integer taborder = 10
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

if not isnull(page_button) then
	pick_list.recalc_page(page_button.text)
elseif not isnull(textbox) then
	pick_list.recalc_page(textbox.text)
else
	pick_list.recalc_page(ls_text)
end if

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

type pb_down from u_picture_button within w_pick_list_sort
integer x = 41
integer y = 500
integer taborder = 10
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

if not isnull(page_button) then
	pick_list.recalc_page(page_button.text)
elseif not isnull(textbox) then
	pick_list.recalc_page(textbox.text)
else
	pick_list.recalc_page(ls_text)
end if

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

type pb_done from u_picture_button within w_pick_list_sort
integer x = 41
integer y = 968
integer taborder = 10
boolean bringtotop = true
boolean originalsize = false
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;close(parent)

end event

type pb_bottom from u_picture_button within w_pick_list_sort
integer x = 41
integer y = 732
integer taborder = 20
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

if not isnull(page_button) then
	pick_list.recalc_page(page_button.text)
elseif not isnull(textbox) then
	pick_list.recalc_page(textbox.text)
else
	pick_list.recalc_page(ls_text)
end if

if autosave then pick_list.update()

pick_list.setredraw(true)

pb_up.enabled = true
pb_down.enabled = false
pb_top.enabled = true
enabled = false
end event

type pb_top from u_picture_button within w_pick_list_sort
integer x = 41
integer y = 32
integer taborder = 20
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

if not isnull(page_button) then
	pick_list.recalc_page(page_button.text)
elseif not isnull(textbox) then
	pick_list.recalc_page(textbox.text)
else
	pick_list.recalc_page(ls_text)
end if

if autosave then pick_list.update()

pick_list.setredraw(true)

pb_up.enabled = false
pb_down.enabled = true
pb_bottom.enabled = true
enabled = false
end event

