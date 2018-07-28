HA$PBExportHeader$w_graph_new_graph.srw
forward
global type w_graph_new_graph from w_window_base
end type
type pb_done from u_picture_button within w_graph_new_graph
end type
type st_2 from statictext within w_graph_new_graph
end type
type st_which_list from statictext within w_graph_new_graph
end type
type pb_cancel from u_picture_button within w_graph_new_graph
end type
type st_description_title from statictext within w_graph_new_graph
end type
type sle_graph_description from singlelineedit within w_graph_new_graph
end type
type st_folder_title from statictext within w_graph_new_graph
end type
type st_graph_folder from statictext within w_graph_new_graph
end type
type st_title from statictext within w_graph_new_graph
end type
type cb_edit_list from commandbutton within w_graph_new_graph
end type
end forward

global type w_graph_new_graph from w_window_base
integer x = 315
integer y = 272
integer width = 2213
integer height = 1264
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_done pb_done
st_2 st_2
st_which_list st_which_list
pb_cancel pb_cancel
st_description_title st_description_title
sle_graph_description sle_graph_description
st_folder_title st_folder_title
st_graph_folder st_graph_folder
st_title st_title
cb_edit_list cb_edit_list
end type
global w_graph_new_graph w_graph_new_graph

type variables
string user_id
long graph_id

string graph_folder

end variables

on w_graph_new_graph.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.st_2=create st_2
this.st_which_list=create st_which_list
this.pb_cancel=create pb_cancel
this.st_description_title=create st_description_title
this.sle_graph_description=create sle_graph_description
this.st_folder_title=create st_folder_title
this.st_graph_folder=create st_graph_folder
this.st_title=create st_title
this.cb_edit_list=create cb_edit_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_which_list
this.Control[iCurrent+4]=this.pb_cancel
this.Control[iCurrent+5]=this.st_description_title
this.Control[iCurrent+6]=this.sle_graph_description
this.Control[iCurrent+7]=this.st_folder_title
this.Control[iCurrent+8]=this.st_graph_folder
this.Control[iCurrent+9]=this.st_title
this.Control[iCurrent+10]=this.cb_edit_list
end on

on w_graph_new_graph.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.st_2)
destroy(this.st_which_list)
destroy(this.pb_cancel)
destroy(this.st_description_title)
destroy(this.sle_graph_description)
destroy(this.st_folder_title)
destroy(this.st_graph_folder)
destroy(this.st_title)
destroy(this.cb_edit_list)
end on

event open;call super::open;integer li_sts

user_id = current_user.user_id
st_which_list.text = "Personal List"
setnull(graph_folder)

if not isnull(message.stringparm) and trim(message.stringparm) <> "" then
	st_title.text = message.stringparm
end if

end event

type pb_epro_help from w_window_base`pb_epro_help within w_graph_new_graph
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_graph_new_graph
end type

type pb_done from u_picture_button within w_graph_new_graph
integer x = 1888
integer y = 980
integer taborder = 20
boolean enabled = false
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return
long ll_graph_id

 DECLARE lsp_new_graph PROCEDURE FOR dbo.sp_new_graph  
         @ps_user_id = :user_id,   
         @ps_graph_folder = :st_graph_folder.text,   
         @ps_description = :sle_graph_description.text,   
         @pl_graph_id = :ll_graph_id OUT ;


if isnull(sle_graph_description.text) or trim(sle_graph_description.text) = "" then
	openwithparm(w_pop_message, "You must enter a description")
	return
end if

if isnull(graph_folder) or trim(graph_folder) = "" then
	openwithparm(w_pop_message, "You must select a folder")
	return
end if


EXECUTE lsp_new_graph;
if not tf_check() then return

FETCH lsp_new_graph INTO :ll_graph_id;
if not tf_check() then return

CLOSE lsp_new_graph;

popup_return.item_count = 3
popup_return.items[1] = user_id
popup_return.items[2] = string(ll_graph_id)
popup_return.items[3] = sle_graph_description.text

closewithreturn(parent, popup_return)

end event

type st_2 from statictext within w_graph_new_graph
integer x = 855
integer y = 436
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
long backcolor = 33538240
boolean enabled = false
string text = "Create Graph In:"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_which_list from statictext within w_graph_new_graph
integer x = 805
integer y = 516
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


end event

type pb_cancel from u_picture_button within w_graph_new_graph
integer x = 69
integer y = 980
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

type st_description_title from statictext within w_graph_new_graph
integer x = 73
integer y = 196
integer width = 535
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Graph Description"
boolean focusrectangle = false
end type

type sle_graph_description from singlelineedit within w_graph_new_graph
integer x = 69
integer y = 276
integer width = 2066
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;if len(text) > 50 then
	openwithparm(w_pop_message, "Maximum description length is 50 characters.  Description has been truncated.")
	text = left(text, 50)
end if

if len(text) > 0 then pb_done.enabled = true

end event

type st_folder_title from statictext within w_graph_new_graph
integer x = 855
integer y = 744
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
long backcolor = 33538240
boolean enabled = false
string text = "Which Folder"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_graph_folder from statictext within w_graph_new_graph
integer x = 663
integer y = 824
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
string text = "<Select Folder>"
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
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

graph_folder = popup_return.descriptions[1]
text = graph_folder


end event

type st_title from statictext within w_graph_new_graph
integer width = 2208
integer height = 132
boolean bringtotop = true
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "New Graph Definition"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_edit_list from commandbutton within w_graph_new_graph
integer x = 864
integer y = 1084
integer width = 480
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Edit Folder List"
end type

event clicked;str_popup popup

popup.item = "GRAPH_FOLDER"

//openwithparm(w_top_20_list_edit, popup)


end event

