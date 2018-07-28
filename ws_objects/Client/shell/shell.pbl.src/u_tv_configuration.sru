$PBExportHeader$u_tv_configuration.sru
forward
global type u_tv_configuration from treeview
end type
end forward

global type u_tv_configuration from treeview
integer width = 480
integer height = 400
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
integer picturewidth = 16
integer pictureheight = 16
long picturemaskcolor = 536870912
long statepicturemaskcolor = 536870912
end type
global u_tv_configuration u_tv_configuration

type variables
boolean allow_editing
boolean initializing
boolean changes_made


end variables

forward prototypes
public function integer display_root (boolean pb_allow_editing)
public function u_configuration_node_base get_node_object (str_configuration_node pstr_node)
public function integer picture_index (string ps_picturename)
public subroutine activate (long pl_handle)
public subroutine redisplay_parent (long pl_handle)
public subroutine redisplay (long pl_handle)
public subroutine delete_children (long pl_handle)
end prototypes

public function integer display_root (boolean pb_allow_editing);treeviewitem ltvi_node
long ll_handle
integer li_sts
long ll_rows
long ll_index
u_user luo_practice
str_configuration_node lstr_node
u_configuration_node_base luo_node

allow_editing = pb_allow_editing

if isnull(common_thread.practice_user_id) then
	log.log(this, "display_practice()", "NULL practice_user_id", 4)
	return -1
end if

luo_practice = user_list.find_user(common_thread.practice_user_id)
if isnull(luo_practice) then
	log.log(this, "display_practice()", "practice_user_id not found (" + common_thread.practice_user_id + ")", 4)
	return -1
end if

initializing = true
changes_made = false

setredraw(false)

// Delete existing treeview items
DO
	ll_handle = finditem(RootTreeItem!, 0)
	if ll_handle > 0 then deleteitem(ll_handle)
LOOP WHILE ll_handle > 0

lstr_node.class = "u_configuration_node_root"
lstr_node.label = "EncounterPRO Configuration"
lstr_node.button = "button_epie.bmp"

luo_node = get_node_object(lstr_node)

ltvi_node.data = luo_node

ltvi_node.label = luo_node.node.label
ltvi_node.children = luo_node.has_children()
ltvi_node.PictureIndex = picture_index(luo_node.node.button)
ltvi_node.SelectedPictureIndex = ltvi_node.PictureIndex
ll_handle = insertitemlast(0, ltvi_node)

expanditem(ll_handle)

setredraw(true)

initializing = false

return 1

end function

public function u_configuration_node_base get_node_object (str_configuration_node pstr_node);u_configuration_node_base luo_node

if len(pstr_node.class) > 0 then
	TRY
		luo_node = CREATE USING pstr_node.class
	CATCH (throwable lt_error)
		log.log(this, "get_node_object()", "Error instantiating class (" + pstr_node.class + ")~r~n" + lt_error.text, 4)
		setnull(luo_node)
	END TRY
else
	setnull(luo_node)
end if

if not isnull(luo_node) then
	luo_node.node = pstr_node
end if

return luo_node



end function

public function integer picture_index (string ps_picturename);integer i
integer li_index

li_index = 0
for i = 1 to upperbound(picturename)
	if lower(picturename[i]) = lower(ps_picturename) then
		li_index = i
		exit
	end if
next

if li_index = 0 then
	li_index = addpicture(ps_picturename)
end if

return li_index

end function

public subroutine activate (long pl_handle);treeviewitem ltvi_node
long ll_handle
integer li_sts
long ll_rows
long ll_index
long i
u_configuration_node_base luo_node
string ls_message

li_sts = getitem(pl_handle, ltvi_node)
if li_sts < 0 then return

luo_node = ltvi_node.data

// If the node is display only then it cannot be activated
if NOT luo_node.is_authorized() then
	if upper(luo_node.required_privilege) = "!SERVICE" then
		ls_message = "You must be authorized to perform the " + datalist.service_description(luo_node.node.key) + " service to configure this option"
	elseif len(luo_node.required_privilege) > 0 then
		ls_message = "You must be granted the ~"" + luo_node.required_privilege + "~" privilege in order to configure this option"
	else
		ls_message = "You are not authorized to configure this option"
	end if
	openwithparm(w_pop_message, ls_message)
	return
end if
	
// Now activate the node
// Return Status
//		<0 = Error
//		0 = No activation script
//		1 = OK, no refresh needed
//		2 = OK, refresh node needed
//		3 = OK, refresh parent needed
li_sts = luo_node.activate()
CHOOSE CASE li_sts
	CASE 2
		redisplay(pl_handle)
	CASE 3
		redisplay_parent(pl_handle)
END CHOOSE



return

end subroutine

public subroutine redisplay_parent (long pl_handle);long ll_parent_handle

ll_parent_handle = finditem(ParentTreeItem!, pl_handle)

if ll_parent_handle > 0 then
	redisplay(ll_parent_handle)
end if

end subroutine

public subroutine redisplay (long pl_handle);treeviewitem ltvi_node
integer li_sts
u_configuration_node_base luo_node
boolean lb_already_expanded

li_sts = getitem(pl_handle, ltvi_node)
if li_sts < 0 then return

setredraw(false)

lb_already_expanded = ltvi_node.expandedonce

delete_children(pl_handle)

luo_node = ltvi_node.data
luo_node.refresh_label()
ltvi_node.label = luo_node.node.label
ltvi_node.PictureIndex = picture_index(luo_node.node.button)
ltvi_node.children = luo_node.has_children()

if lb_already_expanded then
	this.event trigger itempopulate(pl_handle)
end if

setitem(pl_handle, ltvi_node)

setredraw(true)

end subroutine

public subroutine delete_children (long pl_handle);long ll_next_child_handle
long ll_temp_handle

// First delete the existing children
ll_next_child_handle = FindItem(ChildTreeItem!, pl_handle)
do while ll_next_child_handle > 0
	ll_temp_handle = ll_next_child_handle
	ll_next_child_handle = FindItem(NextTreeItem!, ll_temp_handle)
	deleteitem(ll_temp_handle)
loop

end subroutine

on u_tv_configuration.create
end on

on u_tv_configuration.destroy
end on

event itempopulate;treeviewitem ltvi_node
treeviewitem ltvi_parent
long ll_handle
integer li_sts
long ll_rows
long ll_index
long i
u_configuration_node_base luo_parent_node
u_configuration_node_base luo_child_node
str_configuration_nodes lstr_child_nodes

li_sts = getitem(handle, ltvi_parent)
if li_sts < 0 then return -1

luo_parent_node = ltvi_parent.data

lstr_child_nodes = luo_parent_node.get_children()

for i = 1 to lstr_child_nodes.node_count
	luo_child_node = get_node_object(lstr_child_nodes.node[i])
	luo_child_node.parent_configuration_node = luo_parent_node
	
	luo_child_node.set_required_privilege()
	
	ltvi_node.data = luo_child_node
	
	ltvi_node.label = luo_child_node.node.label
	ltvi_node.children = luo_child_node.has_children()
	
	ltvi_node.PictureIndex = picture_index(luo_child_node.node.button)
	ltvi_node.SelectedPictureIndex = ltvi_node.PictureIndex
	ll_handle = insertitemlast(handle, ltvi_node)
next


return 1

end event

event rightclicked;activate(handle)

end event

event doubleclicked;activate(handle)

end event

event constructor;pictureheight = 24
picturewidth = 24


end event

event itemcollapsed;treeviewitem ltvi_node
integer li_sts
u_configuration_node_base luo_node
boolean lb_already_expanded

li_sts = getitem(handle, ltvi_node)
if li_sts < 0 then return

setredraw(false)

luo_node = ltvi_node.data
luo_node.refresh_label()
ltvi_node.label = luo_node.node.label
ltvi_node.PictureIndex = picture_index(luo_node.node.button)
ltvi_node.children = luo_node.has_children()

setitem(handle, ltvi_node)

setredraw(true)

end event

event itemexpanded;treeviewitem ltvi_node
integer li_sts
u_configuration_node_base luo_node
boolean lb_already_expanded

li_sts = getitem(handle, ltvi_node)
if li_sts < 0 then return

setredraw(false)

luo_node = ltvi_node.data
luo_node.refresh_label()
ltvi_node.label = luo_node.node.label
ltvi_node.PictureIndex = picture_index(luo_node.node.button)
ltvi_node.children = luo_node.has_children()

setitem(handle, ltvi_node)

setredraw(true)

end event

