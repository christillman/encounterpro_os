$PBExportHeader$u_tv_epro_objects.sru
forward
global type u_tv_epro_objects from treeview
end type
type str_itemdata from structure within u_tv_epro_objects
end type
end forward

type str_itemdata from structure
	str_epro_object_definition		parent_epro_object
	str_property_specification		property
end type

global type u_tv_epro_objects from treeview
integer width = 1522
integer height = 1360
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string picturename[] = {"CheckStatus5!","EditMask!","GroupBox!","DatePicker!","StaticText!","Compute!","Custom070!","Custom039!","Start!"}
long picturemaskcolor = 536870912
long statepicturemaskcolor = 536870912
event new_address ( string ps_new_address,  str_property_value pstr_new_value,  string ps_new_help )
end type
global u_tv_epro_objects u_tv_epro_objects

type variables
str_complete_context current_context
str_attributes current_attributes

// 0 = don't include user defined, 1 = do include user defined
public integer display_user_defined

boolean objects_only

string root_property
string collection_object
string example_key


end variables

forward prototypes
public function integer item_selected (long pl_handle)
public function str_edas_which_object get_which_object (long pl_handle)
public function integer load_children (long handle)
public function integer display_properties (string ps_root_property, str_complete_context pstr_current_context, str_attributes pstr_attributes)
end prototypes

public function integer item_selected (long pl_handle);treeviewitem ltvi_node
long ll_handle
u_ds_data luo_data
long ll_rowcount
long ll_property_id
str_property lstr_property
treeviewitem ltvi_parent_item
treeviewitem ltvi_item
integer li_sts
string ls_epro_object
string ls_parent_property
string ls_property
long i
long ll_property_count
str_property_specification lstr_property_specification[]
string ls_property_address
string ls_which_object
str_property_value lstr_property_value
string ls_property_help


li_sts = getitem(pl_handle, ltvi_item)
if li_sts <= 0 then
	log.log(this, "selectionchanged", "Error getting treeview item (" + string(pl_handle) + ")", 4)
	return -1
end if


ll_property_count = 1
lstr_property_specification[1] = ltvi_item.data
ls_property_help = lstr_property_specification[1].property.property_help

if isnull(lstr_property_specification[1].property.property_name) or lstr_property_specification[1].property.property_name = "" then
	// If this isn't a property (e.g. the root node) then just return
	return 1
end if

lstr_property_specification[1].which_object = get_which_object(pl_handle)

ll_handle = pl_handle
DO
	ll_handle = finditem(ParentTreeItem!, ll_handle)
	if ll_handle > 0 then
		li_sts = getitem(ll_handle, ltvi_item)
		if li_sts <= 0 then
			log.log(this, "selectionchanged", "Error getting treeview item (" + string(pl_handle) + ")", 4)
			return -1
		end if
		
		ll_property_count += 1
		lstr_property_specification[ll_property_count] = ltvi_item.data
	end if
LOOP WHILE ll_handle > 0

ls_property_address = ""
for i = ll_property_count to 1 step -1
	if len(ls_property_address) > 0 then ls_property_address += "."
	ls_property_address += lstr_property_specification[i].property.property_name
	
	if len(lstr_property_specification[i].which_object.which_object_string) > 0 then
		ls_property_address += "(" + lstr_property_specification[i].which_object.which_object_string + ")"
	end if
next

if lower(root_property) <> "root" then
	ls_property_address = "." + ls_property_address
end if

lstr_property_value = f_edas_interpret_nested_address(collection_object, example_key, ls_property_address, current_context, current_attributes)

this.event POST new_address(ls_property_address, lstr_property_value, ls_property_help)

return 1

end function

public function str_edas_which_object get_which_object (long pl_handle);treeviewitem ltvi_item
str_property_specification lstr_property_specification
string ls_label
integer li_sts
str_edas_which_object lstr_which_object

li_sts = getitem(pl_handle, ltvi_item)
if li_sts <= 0 then
	log.log(this, "itempopulate", "Error getting new treeview item (" + string(pl_handle) + ")", 4)
	return lstr_property_specification.which_object
end if

lstr_property_specification = ltvi_item.data

// See if we should prompt the user for "which object" data
if len(lstr_property_specification.property.property_value_object) > 0 then
	if not lstr_property_specification.property.property_value_object_unique then
		openwithparm(w_data_address_which_object, lstr_property_specification)
		lstr_property_specification = message.powerobjectparm
	end if
end if


ls_label = lstr_property_specification.property.property_name

if len(lstr_property_specification.which_object.which_object_string) > 0 then
	ls_label += " (" + lstr_property_specification.which_object.which_object_string + ")"
end if

ltvi_item.data = lstr_property_specification
ltvi_item.label = ls_label

setitem(pl_handle, ltvi_item)

return lstr_property_specification.which_object

end function

public function integer load_children (long handle);treeviewitem ltvi_node
long ll_handle
u_ds_data luo_data
long ll_rowcount
long ll_property_id
treeviewitem ltvi_parent_item
treeviewitem ltvi_new_item
integer li_sts
string ls_parent_property
string ls_property
long i
long ll_new_handle
str_property_specification lstr_parent_property_specification
str_property_specification lstr_property_specification
str_epro_object_definition lstr_epro_object_definition
string ls_property_value_object

setnull(ls_property_value_object)

li_sts = getitem(handle, ltvi_parent_item)
if li_sts <= 0 then
	log.log(this, "itempopulate", "Error getting new treeview item (" + string(handle) + ")", 4)
	return 1
end if

lstr_parent_property_specification = ltvi_parent_item.data

// Delete existing treeview items
DO
	ll_handle = finditem(ChildTreeItem!, handle)
	if ll_handle > 0 then deleteitem(ll_handle)
LOOP WHILE ll_handle > 0


if lower(lstr_parent_property_specification.property.property_value_object) = "treatmenttypeselect" then
	if len(lstr_parent_property_specification.which_object.object_identifier) > 0 then
		SELECT epro_object
		INTO :ls_property_value_object
		FROM c_Treatment_Type
		WHERE treatment_type = :lstr_parent_property_specification.which_object.object_identifier;
		if not tf_check() then return -1
	end if
end if

if isnull(lstr_parent_property_specification.property.property_value_object) or lstr_parent_property_specification.property.property_value_object = "" then return 0

lstr_epro_object_definition = datalist.epro_object_definition(lstr_parent_property_specification.property.property_object)

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_fn_epro_object_property_pick")
ll_rowcount = luo_data.retrieve(lstr_parent_property_specification.property.property_value_object, display_user_defined, ls_property_value_object)


for i = 1 to ll_rowcount
	setnull(lstr_property_specification.which_object.which_object_string)
	setnull(lstr_property_specification.which_object.object_identifier)
	setnull(lstr_property_specification.which_object.filter_statement)
	setnull(lstr_property_specification.which_object.ordinal)
	
	ll_property_id = luo_data.object.property_id[i]
	lstr_property_specification.property = datalist.find_property(ll_property_id)
	lstr_property_specification.referenced_epro_object = datalist.epro_object_definition(lstr_parent_property_specification.property.property_value_object)
	
	if not objects_only or len(lstr_property_specification.property.property_value_object) > 0 then
		ls_property = lstr_property_specification.property.property_name
		
		ltvi_new_item.data = lstr_property_specification
		ltvi_new_item.label = ls_property
		
		CHOOSE CASE lower(lstr_property_specification.property.property_value_object)
			CASE "datetime"
				ltvi_new_item.PictureIndex = 4
				ltvi_new_item.SelectedPictureIndex = 4
				ltvi_new_item.children = true
			CASE "number"
				ltvi_new_item.PictureIndex = 6
				ltvi_new_item.SelectedPictureIndex = 6
				ltvi_new_item.children = true
			CASE "string"
				ltvi_new_item.PictureIndex = 5
				ltvi_new_item.SelectedPictureIndex = 5
				ltvi_new_item.children = true
			CASE "text"
				ltvi_new_item.PictureIndex = 7
				ltvi_new_item.SelectedPictureIndex = 7
				ltvi_new_item.children = true
			CASE "boolean"
				ltvi_new_item.PictureIndex = 9
				ltvi_new_item.SelectedPictureIndex = 9
				ltvi_new_item.children = true
			CASE "binary"
				ltvi_new_item.PictureIndex = 8
				ltvi_new_item.SelectedPictureIndex = 8
				ltvi_new_item.children = true
			CASE ELSE
				if len(lstr_property_specification.property.property_value_object) > 0 then
					if lstr_property_specification.property.property_value_object_unique then
						ltvi_new_item.PictureIndex = 1
						ltvi_new_item.SelectedPictureIndex = 1
						ltvi_new_item.children = true
					else
						ltvi_new_item.PictureIndex = 3
						ltvi_new_item.SelectedPictureIndex = 3
						ltvi_new_item.children = true
					end if
				else
					CHOOSE CASE lower(lstr_property_specification.property.return_data_type)
						CASE "datetime"
							ltvi_new_item.PictureIndex = 4
							ltvi_new_item.SelectedPictureIndex = 4
							ltvi_new_item.children = false
						CASE "number"
							ltvi_new_item.PictureIndex = 6
							ltvi_new_item.SelectedPictureIndex = 6
							ltvi_new_item.children = false
						CASE "string"
							ltvi_new_item.PictureIndex = 5
							ltvi_new_item.SelectedPictureIndex = 5
							ltvi_new_item.children = false
						CASE "text"
							ltvi_new_item.PictureIndex = 7
							ltvi_new_item.SelectedPictureIndex = 7
							ltvi_new_item.children = false
						CASE "boolean"
							ltvi_new_item.PictureIndex = 9
							ltvi_new_item.SelectedPictureIndex = 9
							ltvi_new_item.children = false
						CASE "binary"
							ltvi_new_item.PictureIndex = 8
							ltvi_new_item.SelectedPictureIndex = 8
							ltvi_new_item.children = false
						CASE ELSE
							ltvi_new_item.PictureIndex = 2
							ltvi_new_item.SelectedPictureIndex = 2
							ltvi_new_item.children = false
					END CHOOSE
				end if
		END CHOOSE
			
		ll_new_handle = insertitemlast(handle, ltvi_new_item)
	end if
next

DESTROY luo_data

return 0

end function

public function integer display_properties (string ps_root_property, str_complete_context pstr_current_context, str_attributes pstr_attributes);treeviewitem ltvi_node
long ll_handle
str_property_specification lstr_property_specification
integer li_sts

// Set the current context
current_context = pstr_current_context
current_attributes = pstr_attributes
root_property = ps_root_property

// Delete existing treeview items
DO
	ll_handle = finditem(RootTreeItem!, 0)
	if ll_handle > 0 then deleteitem(ll_handle)
LOOP WHILE ll_handle > 0


li_sts = f_edas_example_object(root_property, &
										current_context, &
										current_attributes, &
										collection_object, & 
										example_key)

lstr_property_specification.property.property_object = collection_object
lstr_property_specification.property.property_value_object = collection_object
ltvi_node.data = lstr_property_specification
ltvi_node.label = root_property
ltvi_node.children = true
ltvi_node.PictureIndex = 1
ltvi_node.SelectedPictureIndex = 1
ll_handle = insertitemlast(0, ltvi_node)

expanditem(ll_handle)

selectitem(ll_handle)


return 1

end function

on u_tv_epro_objects.create
end on

on u_tv_epro_objects.destroy
end on

event itemexpanding;integer li_sts
treeviewitem ltvi_item

li_sts = getitem(handle, ltvi_item)
if li_sts <= 0 then
	log.log(this, "itemexpanding", "Error getting treeview item (" + string(handle) + ")", 4)
	return -1
end if


if ltvi_item.PictureIndex = 3 then
	item_selected(handle)
end if

load_children(handle)

end event

event selectionchanged;integer li_sts

if newhandle <= 0 then return 0

li_sts = item_selected(newhandle)

return 0

end event

