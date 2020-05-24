$PBExportHeader$u_unit_list.sru
forward
global type u_unit_list from nonvisualobject
end type
end forward

global type u_unit_list from nonvisualobject
end type
global u_unit_list u_unit_list

type variables
integer unit_count
u_unit unit[]

u_ds_data units

end variables

forward prototypes
public function integer load_units ()
public function u_unit find_unit (string ps_unit_id)
public function string unit_description (string ps_unit_id)
public function string unit_display_mask (string ps_unit_id)
private function u_unit get_unit (string ps_unit_id)
private function long find_unit_record (string ps_unit_id)
public function boolean is_unit (string ps_unit_id)
end prototypes

public function integer load_units ();long ll_rows

units = CREATE u_ds_data
units.set_dataobject("dw_unit_list_load_units")
ll_rows = units.retrieve()

return ll_rows


end function

public function u_unit find_unit (string ps_unit_id);integer i
u_unit luo_unit

// See if the unit object is already in our cache
for i = 1 to unit_count
	if lower(unit[i].unit_id) = lower(ps_unit_id) then return unit[i]
next

// If we get here then we didn't find the unit in the list
luo_unit = get_unit(ps_unit_id)
if not isnull(luo_unit) then
	unit_count += 1
	unit[unit_count] = luo_unit
end if

return luo_unit

end function

public function string unit_description (string ps_unit_id);long ll_row
u_unit luo_unit
string ls_description

ll_row = find_unit_record(ps_unit_id)
if ll_row > 0 then
	ls_description = units.object.description[ll_row]
else
	setnull(ls_description)
end if

return ls_description

end function

public function string unit_display_mask (string ps_unit_id);long ll_row
u_unit luo_unit
string ls_display_mask

ll_row = find_unit_record(ps_unit_id)
if ll_row > 0 then
	ls_display_mask = units.object.display_mask[ll_row]
else
	setnull(ls_display_mask)
end if

return ls_display_mask

end function

private function u_unit get_unit (string ps_unit_id);long ll_row
u_unit luo_unit
string ls_temp

ll_row = find_unit_record(ps_unit_id)
if ll_row > 0 then
	luo_unit = CREATE u_unit
	
	luo_unit.unit_id = units.object.unit_id[ll_row]
	luo_unit.description = units.object.description[ll_row]
	luo_unit.unit_type = units.object.unit_type[ll_row]
	luo_unit.plural_flag = units.object.plural_flag[ll_row]
	luo_unit.print_unit = units.object.print_unit[ll_row]
	luo_unit.abbreviation = units.object.abbreviation[ll_row]
	luo_unit.display_mask = units.object.display_mask[ll_row]
	luo_unit.prefix = units.object.prefix[ll_row]
	luo_unit.major_unit_display_suffix = units.object.major_unit_display_suffix[ll_row]
	luo_unit.minor_unit_display_suffix = units.object.minor_unit_display_suffix[ll_row]
	luo_unit.major_unit_input_suffixes = units.object.major_unit_input_suffixes[ll_row]
	luo_unit.minor_unit_input_suffixes = units.object.minor_unit_input_suffixes[ll_row]
	luo_unit.multiplier = units.object.multiplier[ll_row]
	
	ls_temp = units.object.display_minor_units[ll_row]
	luo_unit.display_minor_units = f_string_to_boolean(ls_temp)
	
	luo_unit.load_metric_conversion()
	
else
	setnull(luo_unit)
end if

return luo_unit




end function

private function long find_unit_record (string ps_unit_id);long ll_rowcount
long ll_row
u_ds_data ds_data
string ls_find
u_unit luo_unit

ls_find = "lower(unit_id)='" + lower(ps_unit_id) + "'"

ll_rowcount = units.rowcount()

ll_row = units.find(ls_find, 1, ll_rowcount)
if ll_row <= 0 then
	ll_rowcount = load_units()
	ll_row = units.find(ls_find, 1, ll_rowcount)
end if

return ll_row




end function

public function boolean is_unit (string ps_unit_id);long ll_row
u_unit luo_unit
string ls_description

ll_row = find_unit_record(ps_unit_id)
if ll_row > 0 then
	return true
end if

return false

end function

on u_unit_list.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_unit_list.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

