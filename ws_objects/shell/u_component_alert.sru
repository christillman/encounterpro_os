HA$PBExportHeader$u_component_alert.sru
forward
global type u_component_alert from u_component_base_class
end type
end forward

global type u_component_alert from u_component_base_class
end type
global u_component_alert u_component_alert

forward prototypes
protected function integer xx_alert ()
public function integer alert (string ps_cpr_id, long pl_encounter_id, string ps_alert_mode)
public function integer has_alert (string ps_cpr_id, string ps_alert_category_id)
public function integer xx_has_alert ()
end prototypes

protected function integer xx_alert ();//Chuck Webster, 07-28-99

//an external developer will create instances of this class
//so as to get a reference to his/her COM passed into EncounterPRO
//so his/her (instead of our) alert method is executed

integer i
string lsa_attributes[]
string lsa_values[]
integer li_count

//Pass references to two empty arrays to get_attributes(..) and get them back
//full of properties and values, which can then be passed to the methods of
//external objects. Two parallel arrays makes fewer assumptions about external objects
//than an array of structures. Documentation will make clear what is being passed,
//and the developer of the external objects will be responsible for mapping contents
//of parallel arrays to his/her own internal representation

li_count = get_attributes(lsa_attributes, lsa_values)

if ole_class then
	return ole.alert(li_count, lsa_attributes, lsa_values)
else
	return 100
end if

end function

public function integer alert (string ps_cpr_id, long pl_encounter_id, string ps_alert_mode);//Chuck Webster, 07-28-99

//This is a method of u_component_alert, which inherits from u_component_base_class.
//u_component_base_class has methods add_attribute and get_attribute, which are used
//to store attribute/value pairs. "CPR_ID", "ENCOUNTER_ID", "ALERT_MODE" and their values are
//stored in, and retrieved from, attributes[], a private array of structures. Each structure
//has a attribute and a value property.

add_attribute("CPR_ID", ps_cpr_id)

//a user can look at existing alerts without necessarily being in the midst of an encounter
if not isnull(pl_encounter_id) then add_attribute("ENCOUNTER_ID", string(pl_encounter_id))

add_attribute("ALERT_MODE", ps_alert_mode)

//return a reference to an external (COM) alert object, if it exists
return xx_alert()


end function

public function integer has_alert (string ps_cpr_id, string ps_alert_category_id);
// Push the params onto the attribute list
add_attribute("CPR_ID", ps_cpr_id)
add_attribute("ALERT_CATEGORY_ID", ps_alert_category_id)

return xx_has_alert()


end function

public function integer xx_has_alert ();//Chuck Webster, 07-28-99

//an external developer will create instances of this class
//so as to get a reference to his/her COM passed into EncounterPRO
//so his/her (instead of our) alert method is executed

integer i
string lsa_attributes[]
string lsa_values[]
integer li_count

//Pass references to two empty arrays to get_attributes(..) and get them back
//full of properties and values, which can then be passed to the methods of
//external objects. Two parallel arrays makes fewer assumptions about external objects
//than an array of structures. Documentation will make clear what is being passed,
//and the developer of the external objects will be responsible for mapping contents
//of parallel arrays to his/her own internal representation

li_count = get_attributes(lsa_attributes, lsa_values)

if ole_class then
	return ole.has_alert(li_count, lsa_attributes, lsa_values)
else
	return 100
end if

end function

on u_component_alert.create
TriggerEvent( this, "constructor" )
end on

on u_component_alert.destroy
TriggerEvent( this, "destructor" )
end on

