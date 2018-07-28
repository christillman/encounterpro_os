$PBExportHeader$u_component_nomenclature_medcin.sru
forward
global type u_component_nomenclature_medcin from u_component_nomenclature
end type
end forward

global type u_component_nomenclature_medcin from u_component_nomenclature
end type
global u_component_nomenclature_medcin u_component_nomenclature_medcin

forward prototypes
public function string xx_get_phrase (string ps_context)
end prototypes

public function string xx_get_phrase (string ps_context);//messagebox("Inside", "u_component_nomenclature_medcin.xx_get_phrase()")

str_popup popup

string sPhrase

popup.items[1] = "" //some context of where Medcin browser was invoked will be passed here
popup.data_row_count = 1
openwithparm(w_medcin, popup)

sPhrase = Message.stringparm

//messagebox("From Medcin", sPhrase)

//open(w_medcin)

return sPhrase

/*
str_popup popup
popup.items[1] = get_attribute("CPR_ID")
popup.items[2] = get_attribute("ENCOUNTER_ID")
popup.items[3] = get_attribute("ALERT_MODE")
popup.data_row_count = 3

//call window and pass it popup
openwithparm(w_chart_alert, popup)
// Open window(s) to show user alert
return 1
*/
end function

on u_component_nomenclature_medcin.create
TriggerEvent( this, "constructor" )
end on

on u_component_nomenclature_medcin.destroy
TriggerEvent( this, "destructor" )
end on

