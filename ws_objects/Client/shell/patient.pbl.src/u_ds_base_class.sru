$PBExportHeader$u_ds_base_class.sru
forward
global type u_ds_base_class from u_ds_data
end type
end forward

global type u_ds_base_class from u_ds_data
end type
global u_ds_base_class u_ds_base_class

type variables
u_patient parent_patient
string context_object

end variables

forward prototypes
public function boolean is_column (string ps_column)
public function integer column_id (string ps_column)
public function long find_object_row (long pl_object_key)
public function boolean if_condition (long pl_object_key, string ps_condition)
public function str_property_value get_property (long pl_object_key, string ps_property)
public function string get_property_value (long pl_object_key, string ps_property)
end prototypes

public function boolean is_column (string ps_column);string ls_column

if isnull(ps_column) then return false

ps_column = trim(lower(ps_column))
ls_column = describe(ps_column + ".name")
if lower(ls_column) = ps_column then return true

return false


end function

public function integer column_id (string ps_column);integer li_id

if isnull(ps_column) then return 0
ps_column = trim(lower(ps_column))

li_id = integer(describe(ps_column + ".id"))
if isnull(li_id) or li_id <= 0 then return 0

return li_id


end function

public function long find_object_row (long pl_object_key);// This method is replaced in the descendent classes

return 0


end function

public function boolean if_condition (long pl_object_key, string ps_condition);string ls_find
long ll_row

if isnull(pl_object_key) then return false

CHOOSE CASE lower(context_object)
	CASE "encounter"
		ls_find = "encounter_id=" + string(pl_object_key)
	CASE "assessment"
		ls_find = "problem_id=" + string(pl_object_key)
	CASE "treatment"
		ls_find = "treatment_id=" + string(pl_object_key)
	CASE "attachment"
		ls_find = "attachment_id=" + string(pl_object_key)
	CASE ELSE
		return false
END CHOOSE

if not isnull(ps_condition) then
	ls_find += " and (" + ps_condition + ")"
end if

ll_row = find(ls_find, 1, rowcount())
if ll_row > 0 then return true

return false




end function

public function str_property_value get_property (long pl_object_key, string ps_property);string ls_null
long ll_row
integer li_column_id
long ll_property_id
string ls_coltype
integer li_length
integer li_pos
str_property_value lstr_property_value
str_property lstr_property
str_attributes lstr_attributes
string ls_progress_type
string ls_progress_key

setnull(ls_null)
setnull(lstr_property_value.value)
setnull(lstr_property_value.display_value)
setnull(lstr_property_value.textcolor)
setnull(lstr_property_value.backcolor)
setnull(lstr_property_value.weight)

ll_row = find_object_row(pl_object_key)
if isnull(ll_row) or ll_row <= 0 then return lstr_property_value

// First see if the property is a column
li_column_id = column_id(ps_property)

if li_column_id > 0 then
	// Get the column type
	ls_coltype = trim(upper(Describe(ps_property + ".ColType")))
	
	// strip off the size
	li_pos = pos(ls_coltype, "(")
	if li_pos > 0 then
		li_length = integer(mid(ls_coltype, li_pos + 1, len(ls_coltype) - li_pos - 1))
		ls_coltype = left(ls_coltype, li_pos - 1)
	end if
	
	CHOOSE CASE ls_coltype
		CASE "CHAR"
			lstr_property_value.value = object.data[ll_row, li_column_id]
			// To handle the description-lengthening, see if the length is 80 and all 80 bytes are used
			if li_length = 80 and len(lstr_property_value.value) = 80 then
				// If so, then get the value from the database
				lstr_property_value.value = f_get_progress_value(current_patient.cpr_id, &
																context_object, &
																pl_object_key, &
																"Modify", &
																ps_property)
			end if
		CASE "DATE"
			lstr_property_value.value = string(date(object.data[ll_row, li_column_id]))
		CASE "DATETIME"
			lstr_property_value.value = string(datetime(object.data[ll_row, li_column_id]))
		CASE "DECIMAL"
			lstr_property_value.value = string(dec(object.data[ll_row, li_column_id]))
		CASE "INT"
			lstr_property_value.value = string(integer(object.data[ll_row, li_column_id]))
		CASE "LONG"
			lstr_property_value.value = string(long(object.data[ll_row, li_column_id]))
		CASE "NUMBER"
			lstr_property_value.value = string(object.data[ll_row, li_column_id])
		CASE "REAL"
			lstr_property_value.value = string(real(object.data[ll_row, li_column_id]))
		CASE "TIME"
			lstr_property_value.value = string(time(object.data[ll_row, li_column_id]))
		CASE "TIMESTAMP"
			lstr_property_value.value = string(object.data[ll_row, li_column_id])
		CASE "ULONG"
			lstr_property_value.value = string(object.data[ll_row, li_column_id])
		CASE ELSE
			lstr_property_value.value = string(object.data[ll_row, li_column_id])
	END CHOOSE
	
else
	// If we don't recognize the property as a column, then look for it as an extended property
	f_split_string(ps_property, ".", ls_progress_type, ls_progress_key)
	if ls_progress_key = "" then
		ls_progress_key = ls_progress_type
		ls_progress_type = "Property"
	end if
	
	// If we don't recognize the property as a column, then look for it as an extended property
	lstr_property_value.value = f_get_progress_value(current_patient.cpr_id, context_object, pl_object_key, ls_progress_type, ls_progress_key)
end if

lstr_property_value.display_value = f_property_value_display(ps_property, lstr_property_value.value)

return lstr_property_value

end function

public function string get_property_value (long pl_object_key, string ps_property);str_property_value lstr_property_value
str_attributes lstr_attributes

lstr_property_value = f_get_property(context_object, ps_property, pl_object_key, lstr_attributes)

return lstr_property_value.value

end function

on u_ds_base_class.create
call super::create
end on

on u_ds_base_class.destroy
call super::destroy
end on

event dberror;string ls_message

sqlca.check()

ls_message = "DATAWINDOW SQL ERROR = (" + string(sqldbcode) + ") " + sqlerrtext

log.log(this, "u_ds_base_class.dberror.0007", ls_message, 3)

return 1

end event

