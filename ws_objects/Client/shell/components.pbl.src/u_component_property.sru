$PBExportHeader$u_component_property.sru
forward
global type u_component_property from u_component_base_class
end type
end forward

global type u_component_property from u_component_base_class
end type
global u_component_property u_component_property

type variables
str_property property

end variables

forward prototypes
public function string xx_get_property ()
public function string get_property (long pl_property_id, str_attributes pstr_attributes)
end prototypes

public function string xx_get_property ();string lsa_attributes[]
string lsa_values[]
integer li_count
integer li_sts
string ls_property

li_count = get_attributes(lsa_attributes, lsa_values)

if ole_class then
	ls_property = ole.get_property(property.property_id, li_count, lsa_attributes, lsa_values)
else
	setnull(ls_property)
end if


return ls_property

end function

public function string get_property (long pl_property_id, str_attributes pstr_attributes);long ll_return
integer li_sts
string ls_return
decimal ldc_return
string ls_property

setnull(ls_property)

if isnull(pl_property_id) then
	mylog.log(this, "u_component_property.get_property.0010", "Null Property_id", 4)
	return ls_property
end if

property = datalist.find_property(pl_property_id)
if isnull(property.property_id) then
	mylog.log(this, "u_component_property.get_property.0010", "Property not found (" + string(pl_property_id) + ")", 4)
	return ls_property
end if

if isnull(property.status) or property.status <> "OK" then
	mylog.log(this, "u_component_property.get_property.0010", "Property Status not OK", 4)
	return ls_property
end if

li_sts = common_thread.get_adodb(adodb)
if li_sts <= 0 then
	mylog.log(this, "u_component_property.get_property.0010", "Unable to establish ADO Connection", 4)
	return ls_property
end if

add_attributes(pstr_attributes)

ls_property = xx_get_property()

return ls_property


end function

on u_component_property.create
call super::create
end on

on u_component_property.destroy
call super::destroy
end on

