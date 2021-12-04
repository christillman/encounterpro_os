$PBExportHeader$w_graph_load_graph.srw
forward
global type w_graph_load_graph from w_window_base
end type
type pb_done from u_picture_button within w_graph_load_graph
end type
type dw_graph_select from u_dw_pick_list within w_graph_load_graph
end type
type st_1 from statictext within w_graph_load_graph
end type
type st_2 from statictext within w_graph_load_graph
end type
type st_which_list from statictext within w_graph_load_graph
end type
type pb_cancel from u_picture_button within w_graph_load_graph
end type
type st_folder_title from statictext within w_graph_load_graph
end type
type st_graph_folder from statictext within w_graph_load_graph
end type
type cb_delete from commandbutton within w_graph_load_graph
end type
type cb_change_folder from commandbutton within w_graph_load_graph
end type
end forward

global type w_graph_load_graph from w_window_base
integer x = 0
integer y = 0
integer height = 1832
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_done pb_done
dw_graph_select dw_graph_select
st_1 st_1
st_2 st_2
st_which_list st_which_list
pb_cancel pb_cancel
st_folder_title st_folder_title
st_graph_folder st_graph_folder
cb_delete cb_delete
cb_change_folder cb_change_folder
end type
global w_graph_load_graph w_graph_load_graph

type variables
string user_id
long graph_id

string graph_folder
end variables

forward prototypes
public function integer load_list ()
end prototypes

public function integer load_list ();integer li_sts

if graph_folder = "All Folders" then
	li_sts = dw_graph_select.retrieve(user_id, "%")
else
	li_sts = dw_graph_select.retrieve(user_id, graph_folder)
end if

pb_done.enabled = false

return li_sts


end function

on w_graph_load_graph.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.dw_graph_select=create dw_graph_select
this.st_1=create st_1
this.st_2=create st_2
this.st_which_list=create st_which_list
this.pb_cancel=create pb_cancel
this.st_folder_title=create st_folder_title
this.st_graph_folder=create st_graph_folder
this.cb_delete=create cb_delete
this.cb_change_folder=create cb_change_folder
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.dw_graph_select
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_which_list
this.Control[iCurrent+6]=this.pb_cancel
this.Control[iCurrent+7]=this.st_folder_title
this.Control[iCurrent+8]=this.st_graph_folder
this.Control[iCurrent+9]=this.cb_delete
this.Control[iCurrent+10]=this.cb_change_folder
end on

on w_graph_load_graph.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.dw_graph_select)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_which_list)
destroy(this.pb_cancel)
destroy(this.st_folder_title)
destroy(this.st_graph_folder)
destroy(this.cb_delete)
destroy(this.cb_change_folder)
end on

event open;call super::open;integer li_sts
str_popup_return popup_return

popup_return.item_count = 0

graph_folder = "All Folders"
st_graph_folder.text = graph_folder
dw_graph_select.settransobject(sqlca)

user_id = current_user.user_id
st_which_list.text = "Personal List"
li_sts = load_list()
if li_sts < 0 then
	log.log(this, "w_graph_load_graph:open", "Error loading graph list", 4)
	closewithreturn(this, popup_return)
	return
elseif li_sts = 0 then
	user_id = current_user.common_list_id()
	st_which_list.text = "Common List"
	li_sts = load_list()
	if li_sts < 0 then
		log.log(this, "w_graph_load_graph:open", "Error loading graph list", 4)
		closewithreturn(this, popup_return)
		return
	elseif li_sts = 0 then
		openwithparm(w_pop_message, "There are no personal or common graphs defined")
		closewithreturn(this, popup_return)
		return
	end if
end if



end event

type pb_epro_help from w_window_base`pb_epro_help within w_graph_load_graph
end type

type pb_done from u_picture_button within w_graph_load_graph
integer x = 2551
integer y = 1564
integer taborder = 10
boolean enabled = false
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 2
popup_return.items[1] = user_id
popup_return.items[2] = string(graph_id)

closewithreturn(parent, popup_return)

end event

type dw_graph_select from u_dw_pick_list within w_graph_load_graph
integer y = 120
integer width = 1911
integer height = 1632
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_graph_definition_select"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;graph_id = object.graph_id[selected_row]
pb_done.enabled = true
cb_delete.enabled = true
cb_change_folder.enabled = true


end event

event unselected;call super::unselected;pb_done.enabled = false
cb_change_folder.enabled = false
cb_delete.enabled = false


end event

type st_1 from statictext within w_graph_load_graph
integer width = 1783
integer height = 124
boolean bringtotop = true
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Load Graph"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_graph_load_graph
integer x = 2171
integer y = 140
integer width = 494
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Load Graph From"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_which_list from statictext within w_graph_load_graph
integer x = 2121
integer y = 220
integer width = 599
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Personal List"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if user_id <> current_user.user_id then
	text = "Personal List"
	user_id = current_user.user_id
else
	text = "Common List"
	user_id = current_user.common_list_id()
end if

load_list()

end event

type pb_cancel from u_picture_button within w_graph_load_graph
integer x = 1998
integer y = 1564
integer taborder = 30
boolean bringtotop = true
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)


end event

type st_folder_title from statictext within w_graph_load_graph
integer x = 2171
integer y = 420
integer width = 494
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Which Folder"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_graph_folder from statictext within w_graph_load_graph
integer x = 1979
integer y = 500
integer width = 882
integer height = 184
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "All Folders"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_top_20_user_list_pick"
popup.datacolumn = 2
popup.displaycolumn = 4
popup.argument_count = 2
popup.argument[1] = user_id
popup.argument[2] = "GRAPH_FOLDER"
popup.add_blank_row = true
popup.blank_text = "All Folders"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

graph_folder = popup_return.descriptions[1]
text = graph_folder

load_list()

end event

type cb_delete from commandbutton within w_graph_load_graph
integer x = 2171
integer y = 940
integer width = 498
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Delete Graph"
end type

event clicked;string ls_description
str_popup_return popup_return

ls_description = dw_graph_select.object.description[dw_graph_select.lastrow]

openwithparm(w_pop_yes_no, "Are you sure you wish to delete the graph '" + ls_description + "'?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return


DELETE FROM u_Graph_Definition_Value
WHERE user_id = :user_id
AND graph_id = :graph_id;
if not tf_check() then return

DELETE FROM u_Graph_Definition_Restriction
WHERE user_id = :user_id
AND graph_id = :graph_id;
if not tf_check() then return

DELETE FROM u_Graph_Definition_Series
WHERE user_id = :user_id
AND graph_id = :graph_id;
if not tf_check() then return

DELETE FROM u_Graph_Definition
WHERE user_id = :user_id
AND graph_id = :graph_id;
if not tf_check() then return

load_list()

end event

type cb_change_folder from commandbutton within w_graph_load_graph
integer x = 2171
integer y = 1164
integer width = 498
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Change Folder"
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_top_20_user_list_pick"
popup.datacolumn = 2
popup.displaycolumn = 4
popup.argument_count = 2
popup.argument[1] = user_id
popup.argument[2] = "GRAPH_FOLDER"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

UPDATE u_Graph_Definition
SET graph_folder = :popup_return.descriptions[1]
WHERE user_id = :user_id
AND graph_id = :graph_id;
if not tf_check() then return


load_list()

end event

