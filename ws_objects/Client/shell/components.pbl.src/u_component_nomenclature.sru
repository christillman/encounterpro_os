$PBExportHeader$u_component_nomenclature.sru
forward
global type u_component_nomenclature from u_component_base_class
end type
end forward

global type u_component_nomenclature from u_component_base_class
end type
global u_component_nomenclature u_component_nomenclature

forward prototypes
public function string get_phrase (string ps_context)
public function string xx_get_phrase (string ps_context)
end prototypes

public function string get_phrase (string ps_context);return xx_get_phrase(ps_context)


end function

public function string xx_get_phrase (string ps_context);string lsa_attributes[]
string lsa_values[]
integer li_count
string ls_null

setnull(ls_null)

if ole_class then
	li_count = get_attributes(lsa_attributes, lsa_values)
	return ole.do_encounter_service(ps_context, li_count, lsa_attributes, lsa_values)
else
	return ls_null
end if

end function

on u_component_nomenclature.create
TriggerEvent( this, "constructor" )
end on

on u_component_nomenclature.destroy
TriggerEvent( this, "destructor" )
end on

