$PBExportHeader$u_graph_properties.sru
forward
global type u_graph_properties from nonvisualobject
end type
end forward

type str_graph_category from structure
	string		category_field
	string		category_type
	string		description
	boolean		data_compatible[]
end type

type str_graph_data from structure
	string		description
	string		tablename
end type

type str_graph_type from structure
	string		description
	grGraphType		graph_type
end type

type str_sort_type from structure
	string		description
	grSortType		sort_type
end type

type str_legend_loc from structure
	string		description
	grLegendType		legend_loc
end type

global type u_graph_properties from nonvisualobject
end type
global u_graph_properties u_graph_properties

type variables
// Properties
string user_id
long graph_id
string description
string graph_folder
long category_id
string axis_title
integer graph_type
integer series_sort
integer category_sort
integer legend_loc

u_ds_data data_series
u_ds_data restrictions
u_ds_data restriction_values


// Property translations
private integer graph_type_count
private str_graph_type graph_types[]

private integer sort_type_count
private str_sort_type sort_types[]

private integer legend_loc_count
private str_legend_loc legend_locs[]

integer max_categories = 8
integer max_series_count = 6

u_ds_data categories
u_ds_data data_items
u_ds_data data_restrictions
u_ds_data category_data


// Selected items
//integer series_count
//str_selected_data_item series[]


end variables

forward prototypes
public function string category_type ()
public function integer get_categories (ref u_dw_pick_list puo_categories)
public subroutine select_category (long pl_category_id)
public function boolean is_compatible (long pl_category_id, long pl_data_id)
public function integer get_data_items (ref u_dw_pick_list puo_data_items)
public function string get_restriction_query (long pl_data_id, long pl_restriction_id)
public function string get_restriction_column (long pl_data_id, long pl_restriction_id)
public function string get_restriction_description (long pl_data_id, long pl_restriction_id)
public function string get_restriction_type (long pl_data_id, long pl_restriction_id)
public function integer load_graph (string ps_user_id, long pl_graph_id)
public function string pick_graph_type ()
public function string pick_series_sort ()
public function string pick_category_sort ()
public function integer pick_sort_type ()
public function string pick_legend_loc ()
public function string get_category_description ()
public function string get_query (long pl_series_row)
public function string series_description (long pl_series_row)
public function string get_data_item_description (long pl_data_series_row)
public function string get_graph_type_description ()
public function grGraphType get_graph_type ()
public function string get_category_sort_description ()
public function grSortType get_category_sort ()
public function string get_series_sort_description ()
public function grSortType get_series_sort ()
public function string get_legend_loc_description ()
public function grLegendType get_legend_loc ()
public function integer save_graph ()
public function integer save_graph_as ()
public function integer delete_series (long pl_series_row)
public function integer delete_restriction (long pl_restriction_row)
public function long clone_series (long pl_series_row)
end prototypes

public function string category_type ();string ls_null
long ll_row
string ls_find
string ls_category_type


setnull(ls_null)

if isnull(category_id) then
	log.log(this, "u_graph_properties.category_type.0010", "category_id is null", 4)
	return ls_null
end if

ls_find = "category_id=" + string(category_id)
ll_row = categories.find(ls_find, 1, categories.rowcount())
if ll_row <= 0 then
	log.log(this, "u_graph_properties.category_type.0010", "category_id not found (" + string(category_id) + ")", 4)
	return ls_null
end if

ls_category_type = categories.object.category_type[ll_row]

return ls_category_type

end function

public function integer get_categories (ref u_dw_pick_list puo_categories);integer i
long ll_rows

ll_rows = categories.rowcount()

categories.rowscopy(1, ll_rows, Primary!, puo_categories, puo_categories.rowcount() + 1,Primary!)

return ll_rows

end function

public subroutine select_category (long pl_category_id);integer i, j
long ll_data_id
long ll_series_count

// Set the selected category
category_id = pl_category_id

ll_series_count = data_series.rowcount()

// Remove any data series which are not compatible with the new category
for i = ll_series_count to 1 step -1
	ll_data_id = data_series.object.data_id[i]
	if not is_compatible(category_id, ll_data_id) then
		data_series.deleterow(i)
	end if
next


end subroutine

public function boolean is_compatible (long pl_category_id, long pl_data_id);long ll_row
string ls_find


ls_find = "category_id=" + string(pl_category_id) + " and data_id=" + string(pl_data_id)
ll_row = category_data.find(ls_find, 1, category_data.rowcount())
if ll_row <= 0 then return false

return true

end function

public function integer get_data_items (ref u_dw_pick_list puo_data_items);integer i
long ll_rows
long ll_row
long ll_2row
string ls_filter
string ls_find
long ll_data_id

if isnull(category_id) then return 0

ls_filter = "category_id=" + string(category_id)
category_data.setfilter(ls_filter)
category_data.filter()
ll_rows = category_data.rowcount()

for i = 1 to ll_rows
	ll_data_id = category_data.object.data_id[i]
	ls_find = "data_id=" + string(ll_data_id)
	ll_row = data_items.find(ls_find, 1, data_items.rowcount())
	if ll_row <= 0 then continue
	ll_2row = puo_data_items.insertrow(0)
	puo_data_items.object.data[ll_2row] = data_items.object.data[ll_row]
next

return ll_rows

end function

public function string get_restriction_query (long pl_data_id, long pl_restriction_id);string ls_find
long ll_row
string ls_query

setnull(ls_query)

ls_find = "data_id=" + string(pl_data_id)
ls_find += " and restriction_id=" + string(pl_restriction_id)
ll_row = data_restrictions.find(ls_find, 1, data_restrictions.rowcount())
if ll_row <= 0 then return ls_query

ls_query = data_restrictions.object.restriction_query[ll_row]

return ls_query


end function

public function string get_restriction_column (long pl_data_id, long pl_restriction_id);string ls_find
long ll_row
string ls_column

setnull(ls_column)

ls_find = "data_id=" + string(pl_data_id)
ls_find += " and restriction_id=" + string(pl_restriction_id)
ll_row = data_restrictions.find(ls_find, 1, data_restrictions.rowcount())
if ll_row <= 0 then return ls_column

ls_column = data_restrictions.object.restriction_column[ll_row]

return ls_column


end function

public function string get_restriction_description (long pl_data_id, long pl_restriction_id);string ls_find
long ll_row
string ls_description

setnull(ls_description)

ls_find = "data_id=" + string(pl_data_id)
ls_find += " and restriction_id=" + string(pl_restriction_id)
ll_row = data_restrictions.find(ls_find, 1, data_restrictions.rowcount())
if ll_row <= 0 then return ls_description

ls_description = data_restrictions.object.description[ll_row]

return ls_description


end function

public function string get_restriction_type (long pl_data_id, long pl_restriction_id);string ls_find
long ll_row
string ls_type

setnull(ls_type)

ls_find = "data_id=" + string(pl_data_id)
ls_find += " and restriction_id=" + string(pl_restriction_id)
ll_row = data_restrictions.find(ls_find, 1, data_restrictions.rowcount())
if ll_row <= 0 then return ls_type

ls_type = data_restrictions.object.restriction_type[ll_row]

return ls_type


end function

public function integer load_graph (string ps_user_id, long pl_graph_id);string ls_graph_type
string ls_series_sort
string ls_category_sort
string ls_legend_location
integer i
long ll_rows

user_id = ps_user_id
graph_id = pl_graph_id

graph_type = 0
series_sort = 0
category_sort = 0
legend_loc = 0

SELECT description,
		 graph_folder,
		 category_id,
		 axis_title,
		 graph_type,
		 series_sort,
		 category_sort,
		 legend_location
INTO	 :description,
		 :graph_folder,
		 :category_id,
		 :axis_title,
		 :ls_graph_type,
		 :ls_series_sort,
		 :ls_category_sort,
		 :ls_legend_location
FROM u_Graph_Definition
WHERE user_id = :user_id
AND graph_id = :graph_id;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	log.log(this, "u_graph_properties.load_graph.0037", "Graph not found (" + user_id + ", " + string(graph_id) + ")", 4)
	return -1
end if

// Get the graph type
for i = 1 to graph_type_count
	if graph_types[i].description = ls_graph_type then
		graph_type = i
		exit
	end if
next
if graph_type <= 0 then graph_type = 9

// Get the series sort
for i = 1 to sort_type_count
	if sort_types[i].description = ls_series_sort then
		series_sort = i
		exit
	end if
next
if series_sort <= 0 then series_sort = 1

// Get the category sort
for i = 1 to sort_type_count
	if sort_types[i].description = ls_category_sort then
		category_sort = i
		exit
	end if
next
if category_sort <= 0 then category_sort = 1

// Get the legend location
for i = 1 to legend_loc_count
	if legend_locs[i].description = ls_legend_location then
		legend_loc = i
		exit
	end if
next
if legend_loc <= 0 then legend_loc = 1

// Now load the series'
ll_rows = data_series.retrieve(user_id, graph_id)
ll_rows = restrictions.retrieve(user_id, graph_id)
ll_rows = restriction_values.retrieve(user_id, graph_id)


return 1

end function

public function string pick_graph_type ();str_popup popup
str_popup_return popup_return
integer i
string ls_null

setnull(ls_null)

popup.data_row_count = graph_type_count

for i = 1 to popup.data_row_count
	popup.items[i] = graph_types[i].description
next

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 1 then
	graph_type = popup_return.item_indexes[1]
end if

return graph_types[graph_type].description


end function

public function string pick_series_sort ();grSortType le_sort_type
string ls_description
integer li_sort_type


li_sort_type = pick_sort_type()
if li_sort_type > 0 then
	series_sort = li_sort_type
end if

return sort_types[series_sort].description



end function

public function string pick_category_sort ();grSortType le_sort_type
string ls_description
integer li_sort_type


li_sort_type = pick_sort_type()
if li_sort_type > 0 then
	category_sort = li_sort_type
end if

return sort_types[category_sort].description



end function

public function integer pick_sort_type ();str_popup popup
str_popup_return popup_return
string ls_null
integer i

setnull(ls_null)

popup.data_row_count = sort_type_count

for i = 1 to sort_type_count
	popup.items[i] = sort_types[i].description
next

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

return popup_return.item_indexes[1]


end function

public function string pick_legend_loc ();str_popup popup
str_popup_return popup_return
integer i
string ls_null

setnull(ls_null)

popup.data_row_count = legend_loc_count

for i = 1 to popup.data_row_count
	popup.items[i] = legend_locs[i].description
next

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 1 then
	legend_loc = popup_return.item_indexes[1]
end if

return legend_locs[legend_loc].description


end function

public function string get_category_description ();string ls_find
long ll_row
string ls_description

setnull(ls_description)

if isnull(category_id) then return ls_description

ls_find = "category_id=" + string(category_id)
ll_row = categories.find(ls_find, 1, categories.rowcount())
if ll_row <= 0 then return ls_description

ls_description = categories.object.description[ll_row]

return ls_description

end function

public function string get_query (long pl_series_row);string ls_query
long ll_data_id
string ls_null
long ll_row
string ls_find
string ls_tablename
string ls_category_field
integer i, j
string ls_column
string ls_where
datetime ldt_from_date
datetime ldt_to_date
long ll_restriction_count
string ls_series_filter
string ls_restriction_filter
long ll_series_sequence
long ll_restriction_id
long ll_restriction_sequence
string ls_restrict_in
integer li_sts
long ll_restriction_value_count
string ls_value
boolean lb_date_range


setnull(ls_null)

// First get the data fields
ll_data_id = data_series.object.data_id[pl_series_row]
ldt_from_date = data_series.object.from_date[pl_series_row]
ldt_to_date = data_series.object.to_date[pl_series_row]


if isnull(ll_data_id) then
	log.log(this, "u_graph_properties.category_type.0010", "data_id is null", 4)
	return ls_null
end if

ls_find = "data_id=" + string(ll_data_id)
ll_row = data_items.find(ls_find, 1, data_items.rowcount())
if ll_row <= 0 then
	log.log(this, "u_graph_properties.category_type.0010", "data item not found (" + string(ll_data_id) + ")", 4)
	return ls_null
end if

ls_tablename = data_items.object.tablename[ll_row]

// Then get the category fields
if isnull(category_id) then
	log.log(this, "u_graph_properties.category_type.0010", "category_id is null", 4)
	return ls_null
end if

ls_find = "category_id=" + string(category_id)
ll_row = categories.find(ls_find, 1, categories.rowcount())
if ll_row <= 0 then
	log.log(this, "u_graph_properties.category_type.0010", "category_id not found (" + string(category_id) + ")", 4)
	return ls_null
end if

ls_category_field = categories.object.category_field[ll_row]


// Now, build the first part of the query
ls_query = "SELECT " + ls_category_field + ", count(*) as item_count"
ls_query += " FROM " + ls_tablename
if not isnull(ldt_from_date) and not isnull(ldt_to_date) then
	ls_query += " WHERE item_date >= '" + string(ldt_from_date, "[shortdate]") + "'"
	ls_query += " AND item_date <= '" + string(ldt_to_date, "[shortdate]") + "'"
	lb_date_range = true
else
	lb_date_range = false
end if

// Add the restrictions
ll_series_sequence = data_series.object.series_sequence[pl_series_row]
ls_series_filter = "series_sequence=" + string(ll_series_sequence)
restrictions.setfilter(ls_series_filter)
li_sts = restrictions.filter()
if li_sts <= 0 then
	log.log(this, "u_graph_properties.category_type.0010()", "Error filtering restrictions", 4)
	return ls_null
end if
ll_restriction_count = restrictions.rowcount()

for i = 1 to ll_restriction_count
	ll_restriction_id = restrictions.object.restriction_id[i]
	ll_restriction_sequence = restrictions.object.restriction_sequence[i]
	ls_restrict_in = restrictions.object.restrict_in[i]

	// Filter the value datastore to this restriction
	ls_restriction_filter = ls_series_filter + " and restriction_sequence=" + string(ll_restriction_sequence)
	restriction_values.setfilter(ls_restriction_filter)
	li_sts = restriction_values.filter()
	if li_sts <= 0 then
		log.log(this, "u_graph_properties.category_type.0010()", "Error filtering restriction values", 4)
		return ls_null
	end if
	ll_restriction_value_count = restriction_values.rowcount()
			
	ls_where = ""
	ls_column = get_restriction_column(ll_data_id, ll_restriction_id)
	if isnull(ls_column) then continue
	CHOOSE CASE get_restriction_type(ll_data_id, ll_restriction_id)
		CASE "ENUMERATED"
			if ls_restrict_in = "IN" then
				ls_column += " IN ("
			else
				ls_column += " NOT IN ("
			end if
			
			for j = 1 to ll_restriction_value_count
				ls_value = restriction_values.object.value[j]
				ls_where += ", '" + ls_value + "'"
			next
			ls_where = replace(ls_where, 1, 2, " AND " + ls_column)
			ls_where += ")"
		CASE "DATERANGE"
			if ll_restriction_value_count >= 2 then
				ls_where = " AND " + ls_column + " BETWEEN '"

				ls_value = restriction_values.object.value[1]
				ls_where +=  ls_value + "' AND '"
				
				ls_value = restriction_values.object.value[2]
				ls_where +=  ls_value + "'"
			else
				continue
			end if
		CASE "AGERANGE"
			if ll_restriction_value_count >= 2 then
				ls_where = " AND DATEDIFF(YEAR, " + ls_column + ", getdate()) BETWEEN "

				ls_value = restriction_values.object.value[1]
				ls_where +=  ls_value + " AND "
				
				ls_value = restriction_values.object.value[2]
				ls_where +=  ls_value
			else
				continue
			end if
		CASE ELSE
			continue
	END CHOOSE
	
	if i = 1 and not lb_date_range then ls_where = replace(ls_where, 1, 4, " WHERE")
	ls_query += ls_where
next


// Add the grouping
ls_query += " GROUP BY " + ls_category_field
ls_query += " ORDER BY item_count desc"

restrictions.setfilter("")
restrictions.filter()
restriction_values.setfilter("")
restriction_values.rowcount()


return ls_query

end function

public function string series_description (long pl_series_row);string ls_description

ls_description = data_series.object.description[pl_series_row]

return ls_description

end function

public function string get_data_item_description (long pl_data_series_row);string ls_find
long ll_row
long ll_data_id
string ls_description

setnull(ls_description)

ll_data_id = data_series.object.data_id[pl_data_series_row]

if isnull(ll_data_id) then return ls_description

ls_find = "data_id=" + string(ll_data_id)
ll_row = data_items.find(ls_find, 1, data_items.rowcount())
if ll_row <= 0 then return ls_description

ls_description = data_items.object.description[ll_row]

return ls_description

end function

public function string get_graph_type_description ();return graph_types[graph_type].description

end function

public function grGraphType get_graph_type ();return graph_types[graph_type].graph_type

end function

public function string get_category_sort_description ();return sort_types[category_sort].description

end function

public function grSortType get_category_sort ();return sort_types[category_sort].sort_type

end function

public function string get_series_sort_description ();return sort_types[series_sort].description

end function

public function grSortType get_series_sort ();return sort_types[series_sort].sort_type

end function

public function string get_legend_loc_description ();return legend_locs[legend_loc].description

end function

public function grLegendType get_legend_loc ();return legend_locs[legend_loc].legend_loc

end function

public function integer save_graph ();integer li_sts
long ll_restriction_sequence
long ll_series_sequence
integer li_series_count
integer li_restriction_count
integer li_restriction_values_count
long i
long ll_row
string ls_find
long ll_temp

// First save the main record
UPDATE u_Graph_Definition
SET	 description = :description,
		 graph_folder = :graph_folder,
		 category_id = :category_id,
		 axis_title = :axis_title,
		 graph_type = :graph_types[graph_type].description,
		 series_sort = :sort_types[series_sort].description,
		 category_sort = :sort_types[category_sort].description,
		 legend_location = :legend_locs[legend_loc].description
WHERE user_id = :user_id
AND graph_id = :graph_id;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	log.log(this, "u_graph_properties.load_graph.0037", "Graph not found (" + user_id + ", " + string(graph_id) + ")", 4)
	return -1
end if

li_series_count = data_series.rowcount()
li_restriction_count = restrictions.rowcount()
li_restriction_values_count = restriction_values.rowcount()

// The update the data series
li_sts = data_series.update()
if li_sts <= 0 then
	log.log(this, "u_graph_properties.load_graph.0037", "Error saving data series (" + user_id + ", " + string(graph_id) + ")", 4)
	return -1
end if

// Save the restrictions
li_sts = restrictions.update()
if li_sts <= 0 then
	log.log(this, "u_graph_properties.load_graph.0037", "Error saving restrictions (" + user_id + ", " + string(graph_id) + ")", 4)
	return -1
end if

// Save the restriction values
li_sts = restriction_values.update()
if li_sts <= 0 then
	log.log(this, "u_graph_properties.load_graph.0037", "Error saving restriction values (" + user_id + ", " + string(graph_id) + ")", 4)
	return -1
end if


return 1

end function

public function integer save_graph_as ();integer li_sts
integer li_series_count
integer li_restriction_count
integer li_restriction_values_count
long i
str_popup_return popup_return

openwithparm(w_graph_new_graph, "Save As...")
popup_return = message.powerobjectparm
if popup_return.item_count <> 3 then return 0

user_id = popup_return.items[1]
graph_id = long(popup_return.items[2])
description = popup_return.items[3]

li_series_count = data_series.rowcount()
li_restriction_count = restrictions.rowcount()
li_restriction_values_count = restriction_values.rowcount()

// Update the data_series with the new user_id,graph_id
for i = 1 to li_series_count
	data_series.object.user_id[i] = user_id
	data_series.object.graph_id[i] = graph_id
	data_series.SetItemStatus ( i, 0, Primary!, New! )
next

// Update the restrictions with the new user_id,graph_id
for i = 1 to li_restriction_count
	restrictions.object.user_id[i] = user_id
	restrictions.object.graph_id[i] = graph_id
	restrictions.SetItemStatus ( i, 0, Primary!, New! )
next


// Update the restriction_values with the new user_id,graph_id
for i = 1 to li_restriction_values_count
	restriction_values.object.user_id[i] = user_id
	restriction_values.object.graph_id[i] = graph_id
	restriction_values.SetItemStatus ( i, 0, Primary!, New! )
next

li_sts = save_graph()

return li_sts


end function

public function integer delete_series (long pl_series_row);long ll_this_series_sequence
long ll_series_sequence
integer li_restriction_count
integer li_restriction_values_count
long i

li_restriction_count = restrictions.rowcount()
li_restriction_values_count = restriction_values.rowcount()

ll_this_series_sequence = data_series.object.series_sequence[pl_series_row]

// Delete the associated records from restriction_values
for i = li_restriction_values_count to 1 step -1
	ll_series_sequence = restriction_values.object.series_sequence[i]
	if ll_series_sequence  = ll_this_series_sequence then
		restriction_values.deleterow(i)
	end if
next

// Delete the associated records from restrictions
for i = li_restriction_count to 1 step -1
	ll_series_sequence = restrictions.object.series_sequence[i]
	if ll_series_sequence  = ll_this_series_sequence then
		restrictions.deleterow(i)
	end if
next

// Finally, delete the row from data_series
data_series.deleterow(pl_series_row)

return 1

end function

public function integer delete_restriction (long pl_restriction_row);long ll_this_series_sequence
long ll_series_sequence
long ll_this_restriction_sequence
long ll_restriction_sequence
integer li_restriction_values_count
long i

li_restriction_values_count = restriction_values.rowcount()

ll_this_series_sequence = restrictions.object.series_sequence[pl_restriction_row]
ll_this_restriction_sequence = restrictions.object.restriction_sequence[pl_restriction_row]

// Delete the associated records from restriction_values
for i = li_restriction_values_count to 1 step -1
	ll_series_sequence = restriction_values.object.series_sequence[i]
	ll_restriction_sequence = restriction_values.object.restriction_sequence[i]
	if ll_series_sequence  = ll_this_series_sequence &
	 AND ll_restriction_sequence = ll_this_restriction_sequence then
		restriction_values.deleterow(i)
	end if
next

// Finally, delete the row from data_series
restrictions.deleterow(pl_restriction_row)

return 1

end function

public function long clone_series (long pl_series_row);long ll_from_series_sequence
long ll_new_series_sequence
integer li_series_count
integer li_restriction_count
integer li_restriction_values_count
str_popup popup
long ll_new_row
long i
string ls_filter
long ll_temp
string ls_null
u_ds_data luo_data

setnull(ls_null)

// Count the current number of series
li_series_count = data_series.rowcount()

// Filter the restriction datastores and count the records
ll_from_series_sequence = data_series.object.series_sequence[pl_series_row]
ls_filter = "series_sequence=" + string(ll_from_series_sequence)

restrictions.setfilter(ls_filter)
restrictions.filter()
li_restriction_count = restrictions.rowcount()

restriction_values.setfilter(ls_filter)
restriction_values.filter()
li_restriction_values_count = restriction_values.rowcount()

// Determine the new series_sequence
ll_new_series_sequence = 0
for i = 1 to li_series_count
	ll_temp = data_series.object.series_sequence[i]
	if ll_temp > ll_new_series_sequence then
		ll_new_series_sequence = ll_temp
	end if
next
ll_new_series_sequence += 1

// Now copy data_series record and update the fields which are different
data_series.rowscopy(pl_series_row, pl_series_row, Primary!, data_series, li_series_count + 1, Primary!)
ll_new_row = data_series.rowcount()
data_series.object.series_sequence[ll_new_row] = ll_new_series_sequence
data_series.object.description[ll_new_row] = ls_null
data_series.object.sort_sequence[ll_new_row] = ll_new_row

// Now copy restriction records and update the fields which are different
restrictions.rowscopy(1, li_restriction_count, Primary!, restrictions, li_restriction_count + 1, Primary!)
for i = li_restriction_count + 1 to restrictions.rowcount()
	restrictions.object.series_sequence[i] = ll_new_series_sequence
next

// Now copy restriction_values records and update the fields which are different
restriction_values.rowscopy(1, li_restriction_values_count, Primary!, restriction_values, li_restriction_values_count + 1, Primary!)
for i = li_restriction_values_count + 1 to restriction_values.rowcount()
	restriction_values.object.series_sequence[i] = ll_new_series_sequence
next


restrictions.setfilter("")
restrictions.filter()
restriction_values.setfilter("")
restriction_values.filter()

return ll_new_row

end function

on u_graph_properties.create
TriggerEvent( this, "constructor" )
end on

on u_graph_properties.destroy
TriggerEvent( this, "destructor" )
end on

event constructor;str_selected_data_item lstr_data
integer i

categories = CREATE u_ds_data
data_items = CREATE u_ds_data
data_restrictions = CREATE u_ds_data
category_data = CREATE u_ds_data
data_series = CREATE u_ds_data
restrictions = CREATE u_ds_data
restriction_values = CREATE u_ds_data

categories.set_dataobject("dw_graph_category_select")
data_items.set_dataobject("dw_graph_data_select")
data_restrictions.set_dataobject("dw_graph_data_restriction_select")
category_data.set_dataobject("dw_graph_category_data_list")
data_series.set_dataobject("dw_graph_definition_series_list")
restrictions.set_dataobject("dw_graph_definition_restriction_list")
restriction_values.set_dataobject("dw_graph_definition_value_list")


categories.retrieve()
data_items.retrieve()
data_restrictions.retrieve()
category_data.retrieve()

// Initialize instance variables
setnull(category_id)

setnull(lstr_data.begin_date)
setnull(lstr_data.end_date)
setnull(lstr_data.data_id)

//for i = 1 to max_series_count
//	series[i] = lstr_data
//next

graph_type_count = 16
graph_types[1].description = "Area 3D"
graph_types[1].graph_type = Area3D!
graph_types[2].description = "Area"
graph_types[2].graph_type = AreaGraph!
graph_types[3].description = "Bar 3D"
graph_types[3].graph_type = Bar3DGraph!
graph_types[4].description = "Bar 3D Solid"
graph_types[4].graph_type = Bar3DObjGraph!
graph_types[5].description = "Bar"
graph_types[5].graph_type = BarGraph!
graph_types[6].description = "Bar Stacked 3D Solid"
graph_types[6].graph_type = BarStack3DObjGraph!
graph_types[7].description = "Bar Stacked"
graph_types[7].graph_type = BarStackGraph!
graph_types[8].description = "Column 3D"
graph_types[8].graph_type = Col3DGraph!
graph_types[9].description = "Column 3D Solid"
graph_types[9].graph_type = Col3DObjGraph!
graph_types[10].description = "Column"
graph_types[10].graph_type = ColGraph!
graph_types[11].description = "Column Stacked 3D Solid"
graph_types[11].graph_type = ColStack3DObjGraph!
graph_types[12].description = "Column Stacked"
graph_types[12].graph_type = ColStackGraph!
graph_types[13].description = "Line 3D"
graph_types[13].graph_type = Line3D!
graph_types[14].description = "Line "
graph_types[14].graph_type = LineGraph!
graph_types[15].description = "Pie 3D"
graph_types[15].graph_type = Pie3D!
graph_types[16].description = "Pie"
graph_types[16].graph_type = PieGraph!

sort_type_count = 3
sort_types[1].description = "Ascending"
sort_types[1].sort_type = Ascending!
sort_types[2].description = "Descending"
sort_types[2].sort_type = Descending!
sort_types[3].description = "Unsorted"
sort_types[3].sort_type = Unsorted!

legend_loc_count = 5
legend_locs[1].description = "Bottom"
legend_locs[1].legend_loc = AtBottom!
legend_locs[2].description = "Left Side"
legend_locs[2].legend_loc = AtLeft!
legend_locs[3].description = "Right Side"
legend_locs[3].legend_loc = AtRight!
legend_locs[4].description = "Top"
legend_locs[4].legend_loc = AtTop!
legend_locs[5].description = "No Legend"
legend_locs[5].legend_loc = NoLegend!



end event

event destructor;DESTROY categories
DESTROY category_data
DESTROY data_items
DESTROY data_restrictions
DESTROY restriction_values
DESTROY restrictions
DESTROY data_series

 
 
end event

