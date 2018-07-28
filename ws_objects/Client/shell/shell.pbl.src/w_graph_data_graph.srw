$PBExportHeader$w_graph_data_graph.srw
forward
global type w_graph_data_graph from w_window_base
end type
type pb_done from u_picture_button within w_graph_data_graph
end type
type pb_cancel from u_picture_button within w_graph_data_graph
end type
type st_series_title from statictext within w_graph_data_graph
end type
type sle_axis_title from singlelineedit within w_graph_data_graph
end type
type st_axis_title_title2 from statictext within w_graph_data_graph
end type
type cb_save from commandbutton within w_graph_data_graph
end type
type cb_save_as from commandbutton within w_graph_data_graph
end type
type cb_new from commandbutton within w_graph_data_graph
end type
type cb_load from commandbutton within w_graph_data_graph
end type
type dw_data_series from u_dw_pick_list within w_graph_data_graph
end type
type cb_add_series from commandbutton within w_graph_data_graph
end type
type st_title from statictext within w_graph_data_graph
end type
type st_graph_type from statictext within w_graph_data_graph
end type
type st_gr_type_title from statictext within w_graph_data_graph
end type
type st_series_sort_title from statictext within w_graph_data_graph
end type
type st_category_sort_title from statictext within w_graph_data_graph
end type
type st_series_sort from statictext within w_graph_data_graph
end type
type st_category_sort from statictext within w_graph_data_graph
end type
type st_legend_loc_title from statictext within w_graph_data_graph
end type
type st_legend_loc from statictext within w_graph_data_graph
end type
type cb_view_graph from commandbutton within w_graph_data_graph
end type
type st_category_title from statictext within w_graph_data_graph
end type
type st_category from statictext within w_graph_data_graph
end type
type cb_exit from commandbutton within w_graph_data_graph
end type
type pb_help from u_pb_help_button within w_graph_data_graph
end type
end forward

type str_graph_type from structure
	string		description
	grgraphtype		graph_type
end type

global type w_graph_data_graph from w_window_base
int X=0
int Y=0
int Width=2926
int Height=1832
WindowType WindowType=response!
boolean TitleBar=false
long BackColor=33538240
boolean ControlMenu=false
boolean MinBox=false
boolean MaxBox=false
boolean Resizable=false
pb_done pb_done
pb_cancel pb_cancel
st_series_title st_series_title
sle_axis_title sle_axis_title
st_axis_title_title2 st_axis_title_title2
cb_save cb_save
cb_save_as cb_save_as
cb_new cb_new
cb_load cb_load
dw_data_series dw_data_series
cb_add_series cb_add_series
st_title st_title
st_graph_type st_graph_type
st_gr_type_title st_gr_type_title
st_series_sort_title st_series_sort_title
st_category_sort_title st_category_sort_title
st_series_sort st_series_sort
st_category_sort st_category_sort
st_legend_loc_title st_legend_loc_title
st_legend_loc st_legend_loc
cb_view_graph cb_view_graph
st_category_title st_category_title
st_category st_category
cb_exit cb_exit
pb_help pb_help
end type
global w_graph_data_graph w_graph_data_graph

type variables
u_graph_properties graph_properties

boolean changed

end variables

forward prototypes
public function integer load_graph (string ps_user_id, long pl_graph_id)
public function integer load_series ()
end prototypes

public function integer load_graph (string ps_user_id, long pl_graph_id);integer i
integer li_sts


li_sts = graph_properties.load_graph(ps_user_id, pl_graph_id)
if li_sts <= 0 then return -1

st_title.text = graph_properties.description
sle_axis_title.text = graph_properties.axis_title

st_category.text = graph_properties.get_category_description()

// Initialize graph properties
st_graph_type.text = graph_properties.get_graph_type_description()
st_series_sort.text = graph_properties.get_series_sort_description()
st_category_sort.text = graph_properties.get_category_sort_description()
st_legend_loc.text = graph_properties.get_legend_loc_description()


li_sts = load_series()
if li_sts < 0 then return -1

changed = false

return 1


end function

public function integer load_series ();integer i
long ll_rows

dw_data_series.reset()

ll_rows = 0

if isnull(graph_properties.category_id) then
	cb_add_series.enabled = false
else
	cb_add_series.enabled = true
	ll_rows = graph_properties.data_series.rowcount()
	graph_properties.data_series.rowscopy(1, ll_rows, Primary!, dw_data_series, 1,Primary!)
end if


return ll_rows

end function

on w_graph_data_graph.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.st_series_title=create st_series_title
this.sle_axis_title=create sle_axis_title
this.st_axis_title_title2=create st_axis_title_title2
this.cb_save=create cb_save
this.cb_save_as=create cb_save_as
this.cb_new=create cb_new
this.cb_load=create cb_load
this.dw_data_series=create dw_data_series
this.cb_add_series=create cb_add_series
this.st_title=create st_title
this.st_graph_type=create st_graph_type
this.st_gr_type_title=create st_gr_type_title
this.st_series_sort_title=create st_series_sort_title
this.st_category_sort_title=create st_category_sort_title
this.st_series_sort=create st_series_sort
this.st_category_sort=create st_category_sort
this.st_legend_loc_title=create st_legend_loc_title
this.st_legend_loc=create st_legend_loc
this.cb_view_graph=create cb_view_graph
this.st_category_title=create st_category_title
this.st_category=create st_category
this.cb_exit=create cb_exit
this.pb_help=create pb_help
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.st_series_title
this.Control[iCurrent+4]=this.sle_axis_title
this.Control[iCurrent+5]=this.st_axis_title_title2
this.Control[iCurrent+6]=this.cb_save
this.Control[iCurrent+7]=this.cb_save_as
this.Control[iCurrent+8]=this.cb_new
this.Control[iCurrent+9]=this.cb_load
this.Control[iCurrent+10]=this.dw_data_series
this.Control[iCurrent+11]=this.cb_add_series
this.Control[iCurrent+12]=this.st_title
this.Control[iCurrent+13]=this.st_graph_type
this.Control[iCurrent+14]=this.st_gr_type_title
this.Control[iCurrent+15]=this.st_series_sort_title
this.Control[iCurrent+16]=this.st_category_sort_title
this.Control[iCurrent+17]=this.st_series_sort
this.Control[iCurrent+18]=this.st_category_sort
this.Control[iCurrent+19]=this.st_legend_loc_title
this.Control[iCurrent+20]=this.st_legend_loc
this.Control[iCurrent+21]=this.cb_view_graph
this.Control[iCurrent+22]=this.st_category_title
this.Control[iCurrent+23]=this.st_category
this.Control[iCurrent+24]=this.cb_exit
this.Control[iCurrent+25]=this.pb_help
end on

on w_graph_data_graph.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.st_series_title)
destroy(this.sle_axis_title)
destroy(this.st_axis_title_title2)
destroy(this.cb_save)
destroy(this.cb_save_as)
destroy(this.cb_new)
destroy(this.cb_load)
destroy(this.dw_data_series)
destroy(this.cb_add_series)
destroy(this.st_title)
destroy(this.st_graph_type)
destroy(this.st_gr_type_title)
destroy(this.st_series_sort_title)
destroy(this.st_category_sort_title)
destroy(this.st_series_sort)
destroy(this.st_category_sort)
destroy(this.st_legend_loc_title)
destroy(this.st_legend_loc)
destroy(this.cb_view_graph)
destroy(this.st_category_title)
destroy(this.st_category)
destroy(this.cb_exit)
destroy(this.pb_help)
end on

event open;call super::open;str_popup popup
integer i
integer li_sts

popup = message.powerobjectparm
if popup.data_row_count <> 2 then
	log.log(this, "open", "Invalid Parameters", 4)
	close(this)
	return
end if

graph_properties = CREATE u_graph_properties

li_sts = load_graph(popup.items[1], long(popup.items[2]))
if li_sts <= 0 then
	log.log(this, "open", "Error loading graph (" + popup.items[1] + ", " + popup.items[2] + ")", 4)
	close(this)
	return
end if


end event

type pb_done from u_picture_button within w_graph_data_graph
int X=1842
int Y=1044
int TabOrder=20
boolean Visible=false
string PictureName="button26.bmp"
string DisabledName="b_push26.bmp"
end type

event clicked;call super::clicked;close(parent)

end event

type pb_cancel from u_picture_button within w_graph_data_graph
int X=82
int Y=1552
int TabOrder=110
boolean Visible=false
boolean BringToTop=true
string PictureName="button11.bmp"
string DisabledName="b_push11.bmp"
boolean Cancel=true
end type

type st_series_title from statictext within w_graph_data_graph
int X=133
int Y=796
int Width=398
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="Data Series"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=33538240
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_axis_title from singlelineedit within w_graph_data_graph
int X=137
int Y=284
int Width=1691
int Height=100
int TabOrder=10
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

event modified;graph_properties.axis_title = text

changed = true

end event

type st_axis_title_title2 from statictext within w_graph_data_graph
int X=137
int Y=212
int Width=389
int Height=72
boolean Enabled=false
boolean BringToTop=true
string Text="Axis Label"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=33538240
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_save from commandbutton within w_graph_data_graph
int X=695
int Y=1612
int Width=549
int Height=108
int TabOrder=60
boolean BringToTop=true
string Text="Save Graph"
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;
graph_properties.save_graph()

changed = false

end event

type cb_save_as from commandbutton within w_graph_data_graph
int X=1271
int Y=1612
int Width=549
int Height=108
int TabOrder=80
boolean BringToTop=true
string Text="Save Graph As"
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;
graph_properties.save_graph_as()

st_title.text = graph_properties.description

changed = false

end event

type cb_new from commandbutton within w_graph_data_graph
int X=119
int Y=1612
int Width=549
int Height=108
int TabOrder=100
boolean BringToTop=true
string Text="New Graph"
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;str_popup_return popup_return


open(w_graph_new_graph)
popup_return = message.powerobjectparm
if popup_return.item_count <> 2 then return 0

load_graph(popup_return.items[1], long(popup_return.items[2]))


end event

type cb_load from commandbutton within w_graph_data_graph
int X=1847
int Y=1612
int Width=549
int Height=108
int TabOrder=70
boolean BringToTop=true
string Text="Load Graph"
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;str_popup_return popup_return

if changed then
	openwithparm(w_pop_yes_no, "Do you wish to save before loading another graph?")
	popup_return = message.powerobjectparm
	if popup_return.item = "YES" then
		graph_properties.save_graph()
		changed = false
	end if
end if


open(w_graph_load_graph)
popup_return = message.powerobjectparm
if popup_return.item_count <> 2 then return 0

load_graph(popup_return.items[1], long(popup_return.items[2]))


end event

type dw_data_series from u_dw_pick_list within w_graph_data_graph
int X=133
int Y=880
int Width=1367
int Height=640
int TabOrder=30
boolean BringToTop=true
string DataObject="dw_graph_definition_series_list"
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
integer li_sort_sequence
long ll_new_row


if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Series"
	popup.button_titles[popup.button_count] = "Edit"
	buttons[popup.button_count] = "EDIT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonclone.bmp"
	popup.button_helps[popup.button_count] = "Clone Series"
	popup.button_titles[popup.button_count] = "Clone"
	buttons[popup.button_count] = "CLONE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Remove Series"
	popup.button_titles[popup.button_count] = "Remove"
	buttons[popup.button_count] = "REMOVE"
end if

if selected_row > 1 then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Move Series Up"
	popup.button_titles[popup.button_count] = "Move Up"
	buttons[popup.button_count] = "UP"
end if

if selected_row < rowcount() then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Move Series Down"
	popup.button_titles[popup.button_count] = "Move Down"
	buttons[popup.button_count] = "DOWN"
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
		popup.objectparm = graph_properties
		popup.item = string(selected_row)
		openwithparm(w_graph_data_data, popup)
		load_series()
		changed = true
	CASE "REMOVE"
		graph_properties.delete_series(selected_row)
		load_series()
		changed = true
	CASE "CLONE"
		ll_new_row = graph_properties.clone_series(selected_row)
		if ll_new_row <= 0 then return
		popup.objectparm = graph_properties
		popup.item = string(ll_new_row)
		openwithparm(w_graph_data_data, popup)
		load_series()
		changed = true
	CASE "UP"
		li_sort_sequence = graph_properties.data_series.object.sort_sequence[selected_row]
		graph_properties.data_series.object.sort_sequence[selected_row] = graph_properties.data_series.object.sort_sequence[selected_row - 1]
		graph_properties.data_series.object.sort_sequence[selected_row - 1] = li_sort_sequence
		graph_properties.data_series.sort()
		load_series()
		changed = true
	CASE "DOWN"
		li_sort_sequence = graph_properties.data_series.object.sort_sequence[selected_row]
		graph_properties.data_series.object.sort_sequence[selected_row] = graph_properties.data_series.object.sort_sequence[selected_row + 1]
		graph_properties.data_series.object.sort_sequence[selected_row + 1] = li_sort_sequence
		graph_properties.data_series.sort()
		load_series()
		changed = true
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE


return






end event

type cb_add_series from commandbutton within w_graph_data_graph
int X=1015
int Y=764
int Width=480
int Height=108
int TabOrder=40
boolean BringToTop=true
string Text="Add Series"
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;str_popup popup
long ll_row
long ll_max
long ll_series_sequence
long i

ll_row = graph_properties.data_series.insertrow(0)
graph_properties.data_series.object.user_id[ll_row] = graph_properties.user_id
graph_properties.data_series.object.graph_id[ll_row] = graph_properties.graph_id
graph_properties.data_series.object.sort_sequence[ll_row] = ll_row

// Find the lowest negative series_sequence
ll_max = 0
for i = 1 to ll_row - 1
	ll_series_sequence = graph_properties.data_series.object.series_sequence[i]
	if ll_series_sequence > ll_max then
		ll_max = ll_series_sequence
	end if
next

// Set the temporary series_sequence of the new series to a unique negative number
graph_properties.data_series.object.series_sequence[ll_row] = ll_max + 1

// Finally, edit the new series
popup.objectparm = graph_properties
popup.item = string(ll_row)

openwithparm(w_graph_data_data, popup)

load_series()

changed = true

end event

type st_title from statictext within w_graph_data_graph
int Width=2921
int Height=116
boolean Enabled=false
boolean BringToTop=true
string Text="Graph Title"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=33538240
int TextSize=-18
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_graph_type from statictext within w_graph_data_graph
int X=1915
int Y=288
int Width=878
int Height=100
boolean BringToTop=true
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="Column"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;text = graph_properties.pick_graph_type()

changed = true

end event

type st_gr_type_title from statictext within w_graph_data_graph
int X=1915
int Y=212
int Width=878
int Height=72
boolean Enabled=false
boolean BringToTop=true
string Text="Graph Type"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=33538240
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_series_sort_title from statictext within w_graph_data_graph
int X=2286
int Y=452
int Width=507
int Height=64
boolean Enabled=false
boolean BringToTop=true
string Text="Series Sort:"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=33538240
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_category_sort_title from statictext within w_graph_data_graph
int X=2286
int Y=640
int Width=507
int Height=64
boolean Enabled=false
boolean BringToTop=true
string Text="Category Sort:"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=33538240
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_series_sort from statictext within w_graph_data_graph
int X=2286
int Y=516
int Width=507
int Height=92
boolean BringToTop=true
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="Column"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;text = graph_properties.pick_series_sort()

changed = true

end event

type st_category_sort from statictext within w_graph_data_graph
int X=2286
int Y=704
int Width=507
int Height=92
boolean BringToTop=true
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="Column"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;text = graph_properties.pick_category_sort()

changed = true

end event

type st_legend_loc_title from statictext within w_graph_data_graph
int X=2286
int Y=828
int Width=507
int Height=64
boolean Enabled=false
boolean BringToTop=true
string Text="Legend Location:"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=33538240
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_legend_loc from statictext within w_graph_data_graph
int X=2286
int Y=892
int Width=507
int Height=92
boolean BringToTop=true
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="Column"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;text = graph_properties.pick_legend_loc()

changed = true

end event

type cb_view_graph from commandbutton within w_graph_data_graph
int X=2423
int Y=1468
int Width=421
int Height=252
int TabOrder=50
boolean BringToTop=true
string Text="View Graph"
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;openwithparm(w_graph_data_display, graph_properties)

end event

type st_category_title from statictext within w_graph_data_graph
int X=137
int Y=404
int Width=389
int Height=72
boolean Enabled=false
boolean BringToTop=true
string Text="Graph Object"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=33538240
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_category from statictext within w_graph_data_graph
int X=137
int Y=480
int Width=1019
int Height=100
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;str_popup popup
str_popup_return popup_return
long ll_category_id
integer li_sts

popup.dataobject = "dw_graph_category_select"
popup.datacolumn = 1
popup.displaycolumn = 4
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ll_category_id = long(popup_return.items[1])
text = popup_return.descriptions[1]

graph_properties.select_category(ll_category_id)

li_sts = load_series()

changed = true




end event

type cb_exit from commandbutton within w_graph_data_graph
int X=2546
int Y=1240
int Width=247
int Height=120
int TabOrder=90
boolean BringToTop=true
string Text="Exit"
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;str_popup_return popup_return

if changed then
	openwithparm(w_pop_yes_no, "Do you wish to save before exiting?")
	popup_return = message.powerobjectparm
	if popup_return.item = "YES" then graph_properties.save_graph()
end if


close(parent)

end event

type pb_help from u_pb_help_button within w_graph_data_graph
int X=2546
int Y=1080
int Width=247
int Height=120
int TabOrder=20
boolean BringToTop=true
end type

