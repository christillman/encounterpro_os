HA$PBExportHeader$u_component_alert_standard.sru
forward
global type u_component_alert_standard from u_component_alert
end type
end forward

global type u_component_alert_standard from u_component_alert
end type
global u_component_alert_standard u_component_alert_standard

forward prototypes
protected function integer xx_alert ()
protected function integer xx_has_alert ()
end prototypes

protected function integer xx_alert ();//Chuck Webster, 07-28-99

//this method overrides xx_alert of u_component_alert_standard

//instances of this class will use EncounterPRO's own w_chart_alert
//object

//popup is a structure used to pass arguments and values to a window
str_popup popup
popup.items[1] = get_attribute("CPR_ID")
popup.items[2] = get_attribute("ENCOUNTER_ID")
popup.items[3] = get_attribute("ALERT_MODE")
popup.data_row_count = 3

//call window and pass it popup
openwithparm(w_chart_alert, popup)
// Open window(s) to show user alert
return 1

end function

protected function integer xx_has_alert ();string ls_cpr_id
string ls_alert_category_id
integer li_alert_count

 DECLARE lsp_has_alert PROCEDURE FOR dbo.sp_has_alert  
         @ps_cpr_id = :ls_cpr_id,
			@ps_alert_category_id = :ls_alert_category_id,
         @pi_alert_count = :li_alert_count OUT
 USING cprdb;

ls_cpr_id = get_attribute("CPR_ID")
ls_alert_category_id = get_attribute("ALERT_CATEGORY_ID")
 
EXECUTE lsp_has_alert;
if not cprdb.check() then return -1

FETCH lsp_has_alert INTO :li_alert_count;
if not cprdb.check() then return -1

CLOSE lsp_has_alert;

return li_alert_count


end function

on u_component_alert_standard.create
call super::create
end on

on u_component_alert_standard.destroy
call super::destroy
end on

