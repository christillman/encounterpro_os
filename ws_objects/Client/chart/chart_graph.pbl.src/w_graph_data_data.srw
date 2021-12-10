$PBExportHeader$w_graph_data_data.srw
forward
global type w_graph_data_data from w_window_base
end type
type pb_done from u_picture_button within w_graph_data_data
end type
type pb_cancel from u_picture_button within w_graph_data_data
end type
type st_date_range_title from statictext within w_graph_data_data
end type
type st_date_range from statictext within w_graph_data_data
end type
type sle_series_description from singlelineedit within w_graph_data_data
end type
type st_series_description_title from statictext within w_graph_data_data
end type
type dw_restrictions from u_dw_pick_list within w_graph_data_data
end type
type st_restriction_title from statictext within w_graph_data_data
end type
type st_data_item from statictext within w_graph_data_data
end type
type st_data_item_title from statictext within w_graph_data_data
end type
type dw_series_data from u_dw_pick_list within w_graph_data_data
end type
type st_1 from statictext within w_graph_data_data
end type
type st_add_restriction from statictext within w_graph_data_data
end type
type cb_all_dates from commandbutton within w_graph_data_data
end type
end forward

global type w_graph_data_data from w_window_base
int X=0
int Y=0
int Width=2926
int Height=1832
WindowType WindowType=response!
boolean TitleBar=false
long backcolor = 7191717
boolean ControlMenu=false
boolean MinBox=false
boolean MaxBox=false
boolean Resizable=false
pb_done pb_done
pb_cancel pb_cancel
st_date_range_title st_date_range_title
st_date_range st_date_range
sle_series_description sle_series_description
st_series_description_title st_series_description_title
dw_restrictions dw_restrictions
st_restriction_title st_restriction_title
st_data_item st_data_item
st_data_item_title st_data_item_title
dw_series_data dw_series_data
st_1 st_1
st_add_restriction st_add_restriction
cb_all_dates cb_all_dates
end type
global w_graph_data_data w_graph_data_data

type variables
u_graph_properties graph_properties

long which_series
long data_id
long series_sequence

end variables

forward prototypes
public subroutine negate_restriction (long pl_row)
public subroutine remove_restriction (long pl_row)
public function integer edit_restriction (long pl_row)
public function long display_restrictions ()
public function integer get_enumerated_restriction (long pl_restriction_row, ref string ps_description)
public function integer get_agerange_restriction (long pl_restriction_row, ref string ps_description)
public function integer get_daterange_restriction (long pl_restriction_row, ref string ps_description)
public subroutine display_date_range ()
end prototypes

public subroutine negate_restriction (long pl_row);
end subroutine

public subroutine remove_restriction (long pl_row);
graph_properties.delete_restriction(pl_row)

display_restrictions()

end subroutine

public function integer edit_restriction (long pl_row);str_popup popup
str_popup_return popup_return
long ll_restriction_id
u_ds_data luo_data
string ls_query
string ls_restriction_description
integer i
string ls_description
long ll_rows
string ls_item
integer li_sts

// Initialize local variables
ll_restriction_id = dw_restrictions.object.restriction_id[pl_row]
ls_restriction_description = graph_properties.get_restriction_description(data_id, ll_restriction_id)

// Ask the user for inclusion/exclusion choice
popup.data_row_count = 2
popup.items[1] = "Include"
popup.items[2] = "Exclude"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

if popup_return.item_indexes[1] = 1 then
	graph_properties.restrictions.object.restrict_in[pl_row] = "IN"
else
	graph_properties.restrictions.object.restrict_in[pl_row] = "NOT IN"
end if

CHOOSE CASE graph_properties.get_restriction_type(data_id, ll_restriction_id)
	CASE "ENUMERATED"
		li_sts = get_enumerated_restriction(pl_row, ls_description)
	CASE "DATERANGE"
		li_sts = get_daterange_restriction(pl_row, ls_description)
	CASE "AGERANGE"
		li_sts = get_agerange_restriction(pl_row, ls_description)
	CASE ELSE
		return 0
END CHOOSE

if li_sts <= 0 then return li_sts

dw_restrictions.object.description[pl_row] = ls_description

return 1



end function

public function long display_restrictions ();integer i
long ll_rows
string ls_filter
long ll_series_sequence

dw_restrictions.reset()

ll_series_sequence = graph_properties.data_series.object.series_sequence[which_series]
ls_filter = "series_sequence=" + string(ll_series_sequence)
graph_properties.restrictions.setfilter(ls_filter)
graph_properties.restrictions.filter()
ll_rows = graph_properties.restrictions.rowcount()

graph_properties.restrictions.rowscopy(1, ll_rows, Primary!, dw_restrictions, 1,Primary!)

graph_properties.restrictions.setfilter("")
graph_properties.restrictions.filter()

return ll_rows

end function

public function integer get_enumerated_restriction (long pl_restriction_row, ref string ps_description);str_popup popup
str_popup_return popup_return
long ll_restriction_id
u_ds_data luo_data
string ls_query
string ls_description
string ls_restriction_description
integer i
long ll_rows
string ls_item
long ll_restriction_value_count
long ll_restriction_sequence
string ls_filter
string ls_restrict_in
string ls_find
long ll_row

// Initialize local variables
ll_restriction_id = dw_restrictions.object.restriction_id[pl_restriction_row]
ll_restriction_sequence = dw_restrictions.object.restriction_sequence[pl_restriction_row]
ls_restriction_description = graph_properties.get_restriction_description(data_id, ll_restriction_id)
ls_restrict_in = dw_restrictions.object.restrict_in[pl_restriction_row]

// Add the restrictions
ls_filter = "series_sequence=" + string(series_sequence)
ls_filter += " and restriction_sequence=" + string(ll_restriction_sequence)
graph_properties.restriction_values.setfilter(ls_filter)
graph_properties.restriction_values.filter()
ll_restriction_value_count = graph_properties.restriction_values.rowcount()


// Display list of choices to user
ls_query = graph_properties.get_restriction_query(data_id, ll_restriction_id)

luo_data = CREATE u_ds_data
luo_data.set_database(sqlca)

ll_rows = luo_data.load_query(ls_query)
if ll_rows <= 0 then
	openwithparm(w_pop_message, "This restriction has no items to select")
	DESTROY luo_data
	graph_properties.restriction_values.setfilter("")
	graph_properties.restriction_values.filter()
	return 0
end if

popup.dataobject = ""
popup.datacolumn = 0
popup.displaycolumn = 0
popup.data_row_count = ll_rows
for i = 1 to ll_rows
	popup.items[i] = luo_data.getitemstring(i, 1)
next
popup.multiselect = true
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <= 0 then
	DESTROY luo_data
	graph_properties.restriction_values.setfilter("")
	graph_properties.restriction_values.filter()
	return 0
end if

for i = 1 to popup_return.item_count
	// Get the value from the popup
	ls_item = luo_data.getitemstring(popup_return.item_indexes[i], 1)
	
	// If there are more values in the popup than in the datastore, then add records to the datastore
	if i > ll_restriction_value_count then
		graph_properties.restriction_values.insertrow(0)
		graph_properties.restriction_values.object.user_id[i] = graph_properties.user_id
		graph_properties.restriction_values.object.graph_id[i] = graph_properties.graph_id
		graph_properties.restriction_values.object.series_sequence[i] = series_sequence
		graph_properties.restriction_values.object.restriction_sequence[i] = ll_restriction_sequence
		ll_restriction_value_count += 1
	end if
	graph_properties.restriction_values.object.value[i] = ls_item
	graph_properties.restriction_values.object.sort_sequence[i] = i
	
	// Construct the description
	ls_description += ", " + ls_item
next

// If there were less values in the popup than in the datastore, then delete the extra datastore rows
for i = ll_restriction_value_count to popup_return.item_count + 1 step -1
	graph_properties.restriction_values.deleterow(i)
	ll_restriction_value_count -= 1
next
	

if popup_return.item_count = 1 then
	if ls_restrict_in = "IN" then
		ls_description = replace(ls_description, 1, 2, ls_restriction_description + " = ")
	else
		ls_description = replace(ls_description, 1, 2, ls_restriction_description + " <> ")
	end if
else
	if ls_restrict_in = "IN" then
		ls_description = replace(ls_description, 1, 2, ls_restriction_description + " in (")
		ls_description += ")"
	else
		ls_description = replace(ls_description, 1, 2, ls_restriction_description + " not in (")
		ls_description += ")"
	end if
end if

// Update graph_properties with the new restriction description
ls_find = "series_sequence=" + string(series_sequence) + " and restriction_sequence=" + string(ll_restriction_sequence)
ll_row = graph_properties.restrictions.find(ls_find, 1, graph_properties.restrictions.rowcount())
if ll_row > 0 then
	graph_properties.restrictions.object.description[ll_row] = ls_description
end if

DESTROY luo_data

ps_description = ls_description

graph_properties.restriction_values.setfilter("")
graph_properties.restriction_values.filter()

return 1



end function

public function integer get_agerange_restriction (long pl_restriction_row, ref string ps_description);str_popup popup
str_popup_return popup_return
long ll_restriction_id
string ls_restriction_description
string ls_from_age
string ls_to_age
long ll_restriction_value_count
long ll_restriction_sequence
string ls_filter
string ls_restrict_in
string ls_find
long ll_row

// Initialize local variables
ll_restriction_id = dw_restrictions.object.restriction_id[pl_restriction_row]
ll_restriction_sequence = dw_restrictions.object.restriction_sequence[pl_restriction_row]
ls_restriction_description = graph_properties.get_restriction_description(data_id, ll_restriction_id)
ls_restrict_in = dw_restrictions.object.restrict_in[pl_restriction_row]

// Add the restrictions
ls_filter = "series_sequence=" + string(series_sequence)
ls_filter += " and restriction_sequence=" + string(ll_restriction_sequence)
graph_properties.restriction_values.setfilter(ls_filter)
ll_restriction_value_count = graph_properties.restriction_values.rowcount()

openwithparm(w_pick_age, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 2 then
	graph_properties.restriction_values.setfilter("")
	graph_properties.restriction_values.filter()
	return 0
end if

ls_from_age = popup_return.items[1]
ls_to_age = popup_return.items[2]

ps_description = ls_restriction_description
if ls_restrict_in = "IN" then
	ps_description += " is between "
else
	ps_description += " is not between "
end if
ps_description += ls_from_age + " and " + ls_to_age

if ll_restriction_value_count < 1 then
	graph_properties.restriction_values.insertrow(0)
	graph_properties.restriction_values.object.user_id[1] = graph_properties.user_id
	graph_properties.restriction_values.object.graph_id[1] = graph_properties.graph_id
	graph_properties.restriction_values.object.series_sequence[1] = series_sequence
	graph_properties.restriction_values.object.restriction_sequence[1] = ll_restriction_sequence
	ll_restriction_value_count += 1
end if

graph_properties.restriction_values.object.value[1] = ls_from_age
graph_properties.restriction_values.object.sort_sequence[1] = 1

if ll_restriction_value_count < 2 then
	graph_properties.restriction_values.insertrow(0)
	graph_properties.restriction_values.object.user_id[2] = graph_properties.user_id
	graph_properties.restriction_values.object.graph_id[2] = graph_properties.graph_id
	graph_properties.restriction_values.object.series_sequence[2] = series_sequence
	graph_properties.restriction_values.object.restriction_sequence[2] = ll_restriction_sequence
	ll_restriction_value_count += 1
end if

graph_properties.restriction_values.object.value[2] = ls_to_age
graph_properties.restriction_values.object.sort_sequence[2] = 2

// Update graph_properties with the new restriction description
ls_find = "series_sequence=" + string(series_sequence) + " and restriction_sequence=" + string(ll_restriction_sequence)
ll_row = graph_properties.restrictions.find(ls_find, 1, graph_properties.restrictions.rowcount())
if ll_row > 0 then
	graph_properties.restrictions.object.description[ll_row] = ps_description
end if

graph_properties.restriction_values.setfilter("")
graph_properties.restriction_values.filter()

return 1



end function

public function integer get_daterange_restriction (long pl_restriction_row, ref string ps_description);str_popup popup
str_popup_return popup_return
long ll_restriction_id
string ls_restriction_description
string ls_from_date
string ls_to_date
long ll_restriction_value_count
long ll_restriction_sequence
string ls_filter
string ls_restrict_in
string ls_find
long ll_row

// Initialize local variables
ll_restriction_id = dw_restrictions.object.restriction_id[pl_restriction_row]
ll_restriction_sequence = dw_restrictions.object.restriction_sequence[pl_restriction_row]
ls_restriction_description = graph_properties.get_restriction_description(data_id, ll_restriction_id)
ls_restrict_in = dw_restrictions.object.restrict_in[pl_restriction_row]

// Add the restrictions
ls_filter = "series_sequence=" + string(series_sequence)
ls_filter += " and restriction_sequence=" + string(ll_restriction_sequence)
graph_properties.restriction_values.setfilter(ls_filter)
ll_restriction_value_count = graph_properties.restriction_values.rowcount()

if ll_restriction_value_count >= 1 then
	ls_from_date = graph_properties.restriction_values.object.value[1]
else
	ls_from_date = string(f_add_years(today(), -1), "[shortdate]")
end if

if ll_restriction_value_count >= 2 then
	ls_to_date = graph_properties.restriction_values.object.value[1]
else
	ls_to_date = string(today(), "[shortdate]")
end if

popup.title = "From Date"
popup.data_row_count = 1
popup.items[1] = ls_from_date
openwithparm(w_pick_date, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then
	graph_properties.restriction_values.setfilter("")
	graph_properties.restriction_values.filter()
	return 0
end if

ls_from_date = popup_return.items[1]

popup.title = "To Date"
popup.data_row_count = 1
popup.items[1] = ls_to_date
openwithparm(w_pick_date, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

ls_to_date = popup_return.items[1]

ps_description = ls_restriction_description
if ls_restrict_in = "IN" then
	ps_description += " is between "
else
	ps_description += " is not between "
end if
ps_description += ls_from_date + " and " + ls_to_date

if ll_restriction_value_count < 1 then
	graph_properties.restriction_values.insertrow(0)
	graph_properties.restriction_values.object.user_id[1] = graph_properties.user_id
	graph_properties.restriction_values.object.graph_id[1] = graph_properties.graph_id
	graph_properties.restriction_values.object.series_sequence[1] = series_sequence
	graph_properties.restriction_values.object.restriction_sequence[1] = ll_restriction_sequence
	ll_restriction_value_count += 1
end if

graph_properties.restriction_values.object.value[1] = ls_from_date
graph_properties.restriction_values.object.sort_sequence[1] = 1

if ll_restriction_value_count < 2 then
	graph_properties.restriction_values.insertrow(0)
	graph_properties.restriction_values.object.user_id[2] = graph_properties.user_id
	graph_properties.restriction_values.object.graph_id[2] = graph_properties.graph_id
	graph_properties.restriction_values.object.series_sequence[2] = series_sequence
	graph_properties.restriction_values.object.restriction_sequence[2] = ll_restriction_sequence
	ll_restriction_value_count += 1
end if

graph_properties.restriction_values.object.value[2] = ls_to_date
graph_properties.restriction_values.object.sort_sequence[2] = 2

// Update graph_properties with the new restriction description
ls_find = "series_sequence=" + string(series_sequence) + " and restriction_sequence=" + string(ll_restriction_sequence)
ll_row = graph_properties.restrictions.find(ls_find, 1, graph_properties.restrictions.rowcount())
if ll_row > 0 then
	graph_properties.restrictions.object.description[ll_row] = ps_description
end if

graph_properties.restriction_values.setfilter("")
graph_properties.restriction_values.filter()

return 1


end function

public subroutine display_date_range ();string ls_from_date
string ls_to_date
datetime ldt_from_date
datetime ldt_to_date

ldt_from_date = graph_properties.data_series.object.from_date[which_series]
ls_from_date = string(ldt_from_date, date_format_string)

ldt_to_date = graph_properties.data_series.object.to_date[which_series]
ls_to_date = string(ldt_to_date, date_format_string)

if isnull(ls_from_date) or not isdate(ls_from_date) or isnull(ls_to_date) or not isdate(ls_to_date) then
	st_date_range.text = "< All Dates >"
	cb_all_dates.visible = false
else
	st_date_range.text = ls_from_date + " - " + ls_to_date
	cb_all_dates.visible = true
end if

end subroutine

on w_graph_data_data.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.st_date_range_title=create st_date_range_title
this.st_date_range=create st_date_range
this.sle_series_description=create sle_series_description
this.st_series_description_title=create st_series_description_title
this.dw_restrictions=create dw_restrictions
this.st_restriction_title=create st_restriction_title
this.st_data_item=create st_data_item
this.st_data_item_title=create st_data_item_title
this.dw_series_data=create dw_series_data
this.st_1=create st_1
this.st_add_restriction=create st_add_restriction
this.cb_all_dates=create cb_all_dates
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.st_date_range_title
this.Control[iCurrent+4]=this.st_date_range
this.Control[iCurrent+5]=this.sle_series_description
this.Control[iCurrent+6]=this.st_series_description_title
this.Control[iCurrent+7]=this.dw_restrictions
this.Control[iCurrent+8]=this.st_restriction_title
this.Control[iCurrent+9]=this.st_data_item
this.Control[iCurrent+10]=this.st_data_item_title
this.Control[iCurrent+11]=this.dw_series_data
this.Control[iCurrent+12]=this.st_1
this.Control[iCurrent+13]=this.st_add_restriction
this.Control[iCurrent+14]=this.cb_all_dates
end on

on w_graph_data_data.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.st_date_range_title)
destroy(this.st_date_range)
destroy(this.sle_series_description)
destroy(this.st_series_description_title)
destroy(this.dw_restrictions)
destroy(this.st_restriction_title)
destroy(this.st_data_item)
destroy(this.st_data_item_title)
destroy(this.dw_series_data)
destroy(this.st_1)
destroy(this.st_add_restriction)
destroy(this.cb_all_dates)
end on

event open;call super::open;str_popup popup
string lsa_categories[]
long ll_count
integer i
long ll_row

popup = message.powerobjectparm

graph_properties = popup.objectparm
which_series = long(popup.item)
if which_series <= 0 then
	log.log(this, "w_graph_data_data:open", "Invalid parameters", 4)
	close(this)
	return
end if

data_id = graph_properties.data_series.object.data_id[which_series]
series_sequence = graph_properties.data_series.object.series_sequence[which_series]
st_data_item.text = graph_properties.get_data_item_description(which_series)
sle_series_description.text = graph_properties.data_series.object.description[which_series]

display_date_range()

ll_count = graph_properties.get_data_items(dw_series_data)
if ll_count <= 0 then
	log.log(this, "w_graph_data_data:open", "No compatible data items found", 4)
	close(this)
	return
end if


display_restrictions()

end event

type pb_done from u_picture_button within w_graph_data_data
int X=2574
int Y=1568
int TabOrder=10
string PictureName="button26.bmp"
string DisabledName="b_push26.bmp"
end type

event clicked;call super::clicked;
if isnull(data_id) then
	// If no data_id is selected, then just delete this series
	graph_properties.data_series.deleterow(which_series)
elseif trim(sle_series_description.text) = "" or isnull(sle_series_description.text) then
	// If we have a data_id, then require a description
	messagebox("Incomplete", "You must enter a Data Series Description")
	return
end if
	

close(parent)

end event

type pb_cancel from u_picture_button within w_graph_data_data
int X=82
int Y=1552
int TabOrder=50
boolean Visible=false
boolean BringToTop=true
string PictureName="button11.bmp"
string DisabledName="b_push11.bmp"
boolean Cancel=true
end type

type st_date_range_title from statictext within w_graph_data_data
int X=1422
int Y=376
int Width=448
int Height=64
boolean Enabled=false
boolean BringToTop=true
string Text="Date Range:"
Alignment Alignment=Right!
boolean FocusRectangle=false
long TextColor=33554432
long backcolor = 7191717
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_date_range from statictext within w_graph_data_data
int X=1897
int Y=356
int Width=768
int Height=108
boolean BringToTop=true
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="99/99/9999 - 99/99/9999"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_from_date
string ls_to_date
datetime ldt_from_date
datetime ldt_to_date

ldt_from_date = graph_properties.data_series.object.from_date[which_series]
if isnull(ldt_from_date) then
	ldt_from_date = datetime(f_add_years(today(), -1), time(""))
end if

ls_from_date = string(ldt_from_date, "[shortdate]")

ldt_to_date = graph_properties.data_series.object.to_date[which_series]
if isnull(ldt_to_date) then
	ldt_to_date = datetime(today(), time(""))
end if

ls_to_date = string(ldt_to_date, "[shortdate]")

popup.title = "From Date"
popup.data_row_count = 1
popup.items[1] = ls_from_date
openwithparm(w_pick_date, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_from_date = popup_return.items[1]

popup.title = "To Date"
popup.data_row_count = 1
popup.items[1] = ls_to_date
openwithparm(w_pick_date, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_to_date = popup_return.items[1]

graph_properties.data_series.object.from_date[which_series] = datetime(date(ls_from_date), time(""))
graph_properties.data_series.object.to_date[which_series] = datetime(date(ls_to_date), time(""))

display_date_range()

end event

type sle_series_description from singlelineedit within w_graph_data_data
int X=1065
int Y=184
int Width=1211
int Height=100
int TabOrder=40
boolean BringToTop=true
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long TextColor=33554432
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event modified;graph_properties.data_series.object.description[which_series] = text

end event

type st_series_description_title from statictext within w_graph_data_data
int X=338
int Y=196
int Width=709
int Height=68
boolean Enabled=false
boolean BringToTop=true
string Text="Data Series Description:"
Alignment Alignment=Right!
boolean FocusRectangle=false
long TextColor=33554432
long backcolor = 7191717
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type dw_restrictions from u_dw_pick_list within w_graph_data_data
int X=105
int Y=608
int Width=2386
int Height=1176
int TabOrder=30
boolean BringToTop=true
string DataObject="dw_graph_definition_restriction_list"
boolean VScrollBar=true
end type

event selected;call super::selected;str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
long ll_total_days
long ll_zoom
date ld_begin_date
date ld_end_date


if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit"
	popup.button_titles[popup.button_count] = "Edit Restriction List"
	buttons[popup.button_count] = "EDIT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Remove"
	popup.button_titles[popup.button_count] = "Remove Restriction"
	buttons[popup.button_count] = "REMOVE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	button_pressed = message.doubleparm
	if button_pressed < 1 or button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if

CHOOSE CASE buttons[button_pressed]
	CASE "EDIT"
		edit_restriction(selected_row)
	CASE "REMOVE"
		remove_restriction(selected_row)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE


return






end event

type st_restriction_title from statictext within w_graph_data_data
int X=105
int Y=536
int Width=375
int Height=64
boolean Enabled=false
boolean BringToTop=true
string Text="Restrictions"
boolean FocusRectangle=false
long TextColor=33554432
long backcolor = 7191717
int TextSize=-8
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_data_item from statictext within w_graph_data_data
int X=521
int Y=356
int Width=823
int Height=108
boolean BringToTop=true
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_from_date
string ls_to_date
long ll_row
long ll_data_id
integer i

popup.data_row_count = dw_series_data.rowcount()
for i = 1 to popup.data_row_count
	popup.items[i] = dw_series_data.object.description[i]
next

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return


ll_row = popup_return.item_indexes[1]
ll_data_id = dw_series_data.object.data_id[ll_row]

// If the data item changes...
if ll_data_id <> data_id or isnull(data_id) then
	data_id = ll_data_id
	graph_properties.data_series.object.data_id[which_series] = ll_data_id
	text = popup_return.descriptions[1]
	if trim(sle_series_description.text) = "" or isnull(sle_series_description.text) then
		sle_series_description.text = popup_return.descriptions[1]
		graph_properties.data_series.object.description[which_series] = popup_return.descriptions[1]
	end if
end if


end event

type st_data_item_title from statictext within w_graph_data_data
int X=101
int Y=376
int Width=389
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="Data Item:"
Alignment Alignment=Right!
boolean FocusRectangle=false
long TextColor=33554432
long backcolor = 7191717
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type dw_series_data from u_dw_pick_list within w_graph_data_data
int X=55
int Y=816
int Width=1335
int Height=1092
int TabOrder=20
boolean Visible=false
string DataObject="dw_graph_data_select"
boolean Border=false
BorderStyle BorderStyle=StyleBox!
end type

event selected;call super::selected;//
//graph_properties.series[which_series].data_id = object.data_id[selected_row]
//
//if isnull(sle_series_description.text) or trim(sle_series_description.text) = "" then
//	sle_series_description.text = object.description[selected_row]
//end if
//
//
end event

type st_1 from statictext within w_graph_data_data
int Width=2926
int Height=120
boolean Enabled=false
boolean BringToTop=true
string Text="Edit Data Series"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long backcolor = 7191717
int TextSize=-16
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_add_restriction from statictext within w_graph_data_data
int X=2519
int Y=608
int Width=315
int Height=156
boolean BringToTop=true
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="Add Restriction"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;integer li_sts
str_popup popup
str_popup_return popup_return
long ll_restriction_id
u_ds_data luo_data
string ls_query
string ls_restriction_description
long i
string ls_description
long ll_rows
long ll_row
long ll_restriction_sequence
long ll_max
string ls_item

popup.dataobject = "dw_graph_data_restriction_pick"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = string(data_id)
popup.numeric_argument = true
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ll_restriction_id = long(popup_return.items[1])
ll_row = graph_properties.restrictions.insertrow(0)
graph_properties.restrictions.object.user_id[ll_row] = graph_properties.user_id
graph_properties.restrictions.object.graph_id[ll_row] = graph_properties.graph_id
graph_properties.restrictions.object.series_sequence[ll_row] = series_sequence
graph_properties.restrictions.object.restriction_id[ll_row] = ll_restriction_id
graph_properties.restrictions.object.sort_sequence[ll_row] = ll_row

// Find the lowest negative restriction_sequence
ll_max = 0
for i = 1 to ll_row - 1
	ll_restriction_sequence = graph_properties.restrictions.object.restriction_sequence[i]
	if ll_restriction_sequence > ll_max then
		ll_max = ll_restriction_sequence
	end if
next

// Set the temporary restriction_sequence of the new restriction to a unique negative number
graph_properties.restrictions.object.restriction_sequence[ll_row] = ll_max + 1

li_sts = edit_restriction(ll_row)

// If the user cancelled the restriction edit, then delete the restriction
if li_sts <= 0 then graph_properties.restrictions.deleterow(ll_row)

display_restrictions()


end event

type cb_all_dates from commandbutton within w_graph_data_data
int X=2683
int Y=356
int Width=151
int Height=108
int TabOrder=50
boolean BringToTop=true
string Text="All"
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;datetime ldt_null

setnull(ldt_null)

graph_properties.data_series.object.from_date[which_series] = ldt_null
graph_properties.data_series.object.to_date[which_series] = ldt_null

display_date_range()

end event

