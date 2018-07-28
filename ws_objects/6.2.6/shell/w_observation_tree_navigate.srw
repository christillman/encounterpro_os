HA$PBExportHeader$w_observation_tree_navigate.srw
forward
global type w_observation_tree_navigate from w_window_base
end type
type cb_collapse_all from commandbutton within w_observation_tree_navigate
end type
type cb_expand_all from commandbutton within w_observation_tree_navigate
end type
type tv_observation_tree from u_composite_observation within w_observation_tree_navigate
end type
type pb_cancel from u_picture_button within w_observation_tree_navigate
end type
type st_title from statictext within w_observation_tree_navigate
end type
end forward

global type w_observation_tree_navigate from w_window_base
integer x = 0
integer y = 0
integer height = 1832
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_collapse_all cb_collapse_all
cb_expand_all cb_expand_all
tv_observation_tree tv_observation_tree
pb_cancel pb_cancel
st_title st_title
end type
global w_observation_tree_navigate w_observation_tree_navigate

type variables
string root_observation_id
boolean allow_editing

end variables

on w_observation_tree_navigate.create
int iCurrent
call super::create
this.cb_collapse_all=create cb_collapse_all
this.cb_expand_all=create cb_expand_all
this.tv_observation_tree=create tv_observation_tree
this.pb_cancel=create pb_cancel
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_collapse_all
this.Control[iCurrent+2]=this.cb_expand_all
this.Control[iCurrent+3]=this.tv_observation_tree
this.Control[iCurrent+4]=this.pb_cancel
this.Control[iCurrent+5]=this.st_title
end on

on w_observation_tree_navigate.destroy
call super::destroy
destroy(this.cb_collapse_all)
destroy(this.cb_expand_all)
destroy(this.tv_observation_tree)
destroy(this.pb_cancel)
destroy(this.st_title)
end on

event open;call super::open;str_popup popup
str_popup_return popup_return
integer li_sts

popup = message.powerobjectparm

if popup.data_row_count <> 2 then
	log.log(this, "open", "Invalid Parameters", 4)
	popup_return.item_count = 0
	closewithreturn(this, popup_return)
	return
end if

root_observation_id = popup.items[1]
allow_editing = f_string_to_boolean(popup.items[2])

tv_observation_tree.display_root(root_observation_id, allow_editing)

st_title.text = datalist.observation_description(root_observation_id)


end event

type pb_epro_help from w_window_base`pb_epro_help within w_observation_tree_navigate
boolean visible = true
end type

type cb_collapse_all from commandbutton within w_observation_tree_navigate
integer x = 2478
integer y = 424
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Collapse All"
end type

event clicked;//long ll_root_handle
//long ll_child_handle
//treeviewitem ltvi_item
//integer li_sts
//string ls_data
//boolean lb_expanded
//
//ll_root_handle = tv_observation_tree.finditem(RootTreeItem!, 0)
//if ll_root_handle <= 0 then return
//
//setredraw(false)
//
//// Collapse the children
//ll_child_handle = tv_observation_tree.finditem(ChildTreeItem!, ll_root_handle)
//DO
//	tv_observation_tree.collapseitem(ll_child_handle)
//	ll_child_handle = tv_observation_tree.finditem(ChildTreeItem!, ll_root_handle)
//LOOP WHILE ll_child_handle > 0
//
//setredraw(true)
//
tv_observation_tree.display_root(root_observation_id, allow_editing)

end event

type cb_expand_all from commandbutton within w_observation_tree_navigate
integer x = 2478
integer y = 260
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Expand All"
end type

event clicked;long ll_root_handle

ll_root_handle = tv_observation_tree.finditem(RootTreeItem!, 0)
if ll_root_handle > 0 then tv_observation_tree.expandall(ll_root_handle)

end event

type tv_observation_tree from u_composite_observation within w_observation_tree_navigate
integer x = 14
integer y = 136
integer width = 2414
integer height = 1640
long backcolor = 12632256
end type

event selectionchanged;str_observation_stack lstr_stack

if oldhandle = 0 then return

lstr_stack = get_observation_stack(newhandle)

closewithreturn(parent, lstr_stack)

end event

type pb_cancel from u_picture_button within w_observation_tree_navigate
integer x = 2633
integer y = 1556
integer taborder = 40
boolean cancel = true
boolean originalsize = false
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_observation_stack lstr_stack

setnull(lstr_stack.root_observation_id)

closewithreturn(parent, lstr_stack)

end event

type st_title from statictext within w_observation_tree_navigate
integer y = 8
integer width = 2907
integer height = 112
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Composite Observation"
alignment alignment = center!
boolean focusrectangle = false
end type

