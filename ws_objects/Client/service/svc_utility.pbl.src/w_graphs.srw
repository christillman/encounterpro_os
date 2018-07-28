$PBExportHeader$w_graphs.srw
forward
global type w_graphs from w_window_base
end type
end forward

global type w_graphs from w_window_base
boolean visible = false
string title = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
end type
global w_graphs w_graphs

forward prototypes
public function integer new_graph (ref string ps_user_id, ref long pl_graph_id)
public function integer load_graph (ref string ps_user_id, ref long pl_graph_id)
end prototypes

public function integer new_graph (ref string ps_user_id, ref long pl_graph_id);str_popup_return popup_return


open(w_graph_new_graph)
popup_return = message.powerobjectparm
if popup_return.item_count <> 3 then return 0

ps_user_id = popup_return.items[1]
pl_graph_id = long(popup_return.items[2])

return 1
end function

public function integer load_graph (ref string ps_user_id, ref long pl_graph_id);str_popup_return popup_return


open(w_graph_load_graph)
popup_return = message.powerobjectparm
if popup_return.item_count <> 2 then return 0

ps_user_id = popup_return.items[1]
pl_graph_id = long(popup_return.items[2])

return 1
end function

event open;call super::open;postevent("post_open")
end event

event post_open;str_popup popup
str_popup_return popup_return
string ls_buttons[]
integer ll_button_pressed, i
string ls_null
integer li_sts
string ls_user_id
long ll_graph_id

setnull(ls_null)

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonnewgraph.bmp"
	popup.button_helps[popup.button_count] = "Create New Graph"
	popup.button_titles[popup.button_count] = "New Graph"
	ls_buttons[popup.button_count] = "NEW"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttongraph.bmp"
	popup.button_helps[popup.button_count] = "Load Existing Graph Definition"
	popup.button_titles[popup.button_count] = "Load Graph"
	ls_buttons[popup.button_count] = "LOAD"
end if

if popup.button_count > 1 then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	ls_buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(w_pop_buttons, popup)
	ll_button_pressed = message.doubleparm
elseif popup.button_count = 1 then
	ll_button_pressed = 1
else
	return
end if

if ll_button_pressed <= 0 then return

CHOOSE CASE ls_buttons[ll_button_pressed]
	CASE "NEW"
		li_sts = new_graph(ls_user_id, ll_graph_id)
		if li_sts <= 0 then return
	CASE "LOAD"
		li_sts = load_graph(ls_user_id, ll_graph_id)
		if li_sts <= 0 then return
	CASE "CANCEL"
		return
END CHOOSE

popup.data_row_count = 2
popup.items[1] = ls_user_id
popup.items[2] = string(ll_graph_id)

openwithparm(w_graph_data_graph, popup)

end event

on w_graphs.create
call super::create
end on

on w_graphs.destroy
call super::destroy
end on

type pb_epro_help from w_window_base`pb_epro_help within w_graphs
end type

