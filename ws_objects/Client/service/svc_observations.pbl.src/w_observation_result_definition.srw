$PBExportHeader$w_observation_result_definition.srw
forward
global type w_observation_result_definition from w_window_base
end type
type st_other_data from statictext within w_observation_result_definition
end type
type st_other_title from statictext within w_observation_result_definition
end type
type sle_result from singlelineedit within w_observation_result_definition
end type
type st_result from statictext within w_observation_result_definition
end type
type st_numeric_result_title from statictext within w_observation_result_definition
end type
type st_unit from statictext within w_observation_result_definition
end type
type st_unit_title from statictext within w_observation_result_definition
end type
type st_type_title from statictext within w_observation_result_definition
end type
type st_severity from statictext within w_observation_result_definition
end type
type p_result_severity from picture within w_observation_result_definition
end type
type cb_get_phrase from commandbutton within w_observation_result_definition
end type
type st_severity_title from statictext within w_observation_result_definition
end type
type st_result_amount_flag from statictext within w_observation_result_definition
end type
type st_print_result_title from statictext within w_observation_result_definition
end type
type st_print_result_flag from statictext within w_observation_result_definition
end type
type st_unit_preference_title from statictext within w_observation_result_definition
end type
type st_unit_preference from statictext within w_observation_result_definition
end type
type st_normal_range_title from statictext within w_observation_result_definition
end type
type st_normal_range from statictext within w_observation_result_definition
end type
type st_observation from statictext within w_observation_result_definition
end type
type cb_ok from commandbutton within w_observation_result_definition
end type
type cb_cancel from commandbutton within w_observation_result_definition
end type
type st_result_unit_date from statictext within w_observation_result_definition
end type
type st_result_unit_text from statictext within w_observation_result_definition
end type
type st_result_unit_number from statictext within w_observation_result_definition
end type
type st_abnormal_flag from statictext within w_observation_result_definition
end type
type cb_advanced_options from commandbutton within w_observation_result_definition
end type
end forward

global type w_observation_result_definition from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_other_data st_other_data
st_other_title st_other_title
sle_result sle_result
st_result st_result
st_numeric_result_title st_numeric_result_title
st_unit st_unit
st_unit_title st_unit_title
st_type_title st_type_title
st_severity st_severity
p_result_severity p_result_severity
cb_get_phrase cb_get_phrase
st_severity_title st_severity_title
st_result_amount_flag st_result_amount_flag
st_print_result_title st_print_result_title
st_print_result_flag st_print_result_flag
st_unit_preference_title st_unit_preference_title
st_unit_preference st_unit_preference
st_normal_range_title st_normal_range_title
st_normal_range st_normal_range
st_observation st_observation
cb_ok cb_ok
cb_cancel cb_cancel
st_result_unit_date st_result_unit_date
st_result_unit_text st_result_unit_text
st_result_unit_number st_result_unit_number
st_abnormal_flag st_abnormal_flag
cb_advanced_options cb_advanced_options
end type
global w_observation_result_definition w_observation_result_definition

type variables
string observation_id
integer result_sequence

string abnormal_flag
string result_amount_flag
string result_unit
integer severity
string specimen_type
string external_source
long property_id
string print_result_flag
string service
string result_unit_preference

string result_type

string normal_range


end variables

forward prototypes
public subroutine set_severity (integer pi_severity)
public function integer new_result ()
public function integer load_result ()
public subroutine get_specimen_type ()
public subroutine get_external_source ()
public subroutine get_property ()
public function integer save_changes ()
public subroutine set_screen ()
end prototypes

public subroutine set_severity (integer pi_severity);string ls_bitmap

severity = pi_severity
st_severity.text = datalist.domain_item_description("RESULTSEVERITY", string(severity))
ls_bitmap = datalist.domain_item_bitmap("RESULTSEVERITY", string(severity))
p_result_severity.picturename = ls_bitmap

end subroutine

public function integer new_result ();
if isnull(observation_id) or observation_id = "" then
	log.log(this, "w_observation_result_definition.new_result:0003", "Invalid observation id", 4)
	return -1
end if

sle_result.text = ""

abnormal_flag = datalist.get_preference("PREFERENCES", "default_abnormal_flag", "N")
if abnormal_flag = "N" then
	severity = 0
else
	abnormal_flag = "Y"
	severity = 3
end if

result_amount_flag = "N"
IF upper(result_type) = "COLLECT" then
	print_result_flag = "N"
else
	print_result_flag = "Y"
end if

setnull(result_unit)
setnull(specimen_type)
setnull(external_source)
setnull(normal_range)

set_screen()

sle_result.setfocus()

return 1

end function

public function integer load_result ();
if isnull(observation_id) or observation_id = "" then
	log.log(this, "w_observation_result_definition.load_result:0003", "Invalid observation id", 4)
	return -1
end if

if isnull(result_sequence) then
	log.log(this, "w_observation_result_definition.load_result:0008", "Invalid result sequence", 4)
	return -1
end if

SELECT result,
		 result_type,
		 specimen_type,
		 abnormal_flag,
		 severity,
		 result_amount_flag,
		 print_result_flag,
		 result_unit,
		 external_source,
		 property_id,
		 service,
		 unit_preference,
		 normal_range
INTO :sle_result.text,
	  :result_type,
	  :specimen_type,
	  :abnormal_flag,
	  :severity,
	  :result_amount_flag,
	  :print_result_flag,
	  :result_unit,
	  :external_source,
	  :property_id,
	  :service,
	  :result_unit_preference,
	  :normal_range
FROM c_Observation_Result
WHERE observation_id = :observation_id
AND result_sequence = :result_sequence;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	log.log(this, "w_observation_result_definition.load_result:0043", "Result not found", 4)
	return -1
end if

set_screen()

return 1

end function

public subroutine get_specimen_type ();string ls_bitmap
str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_specimen_type_pick_list"
popup.datacolumn = 1
popup.displaycolumn = 1
popup.add_blank_row = true
popup.blank_text = "<None>"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

st_other_data.text = popup_return.descriptions[1]

ls_bitmap = datalist.domain_item_bitmap("RESULTSEVERITY", string(severity))
p_result_severity.picturename = ls_bitmap


end subroutine

public subroutine get_external_source ();string ls_bitmap
str_popup popup
str_popup_return popup_return
string ls_external_source_type

popup.dataobject = "dw_external_source_type_pick"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.add_blank_row = true
popup.blank_text = "<None>"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	st_other_data.text = popup_return.descriptions[1]
	setnull(external_source)
	return
else
	ls_external_source_type = popup_return.items[1]
end if


popup.dataobject = "dw_external_source_of_type_pick"
popup.datacolumn = 1
popup.displaycolumn = 3
popup.argument_count = 1
popup.argument[1] = ls_external_source_type
popup.add_blank_row = true
popup.blank_text = "<Any>"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	external_source = ls_external_source_type
	st_other_data.text = ls_external_source_type
else
	external_source = popup_return.items[1]
	st_other_data.text = popup_return.descriptions[1]
end if



end subroutine

public subroutine get_property ();string ls_bitmap
str_popup popup
str_popup_return popup_return
string ls_property_type

popup.dataobject = "dw_property_type_pick"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.add_blank_row = true
popup.blank_text = "<None>"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	st_other_data.text = popup_return.descriptions[1]
	sle_result.text = ""
	setnull(property_id)
	return
else
	ls_property_type = popup_return.items[1]
end if


popup.dataobject = "dw_property_of_type_pick"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = ls_property_type
popup.add_blank_row = true
popup.blank_text = "<None>"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

st_other_data.text = popup_return.descriptions[1]

if popup_return.items[1] = "" then
	sle_result.text = ""
	setnull(property_id)
else
	sle_result.text = st_other_data.text
	property_id = long(popup_return.items[1])
end if

end subroutine

public function integer save_changes ();str_popup_return popup_return
string ls_status

 DECLARE lsp_new_observation_result PROCEDURE FOR dbo.sp_new_observation_result  
         @ps_observation_id = :observation_id,
         @ps_result_type = :result_type,
         @ps_result_unit = :result_unit,
         @ps_result = :sle_result.text,
         @ps_result_amount_flag = :result_amount_flag,
         @ps_print_result_flag = :print_result_flag,
         @ps_specimen_type = :specimen_type,
         @ps_abnormal_flag = :abnormal_flag,
			@pi_severity = :severity,
			@ps_external_source = :external_source,
			@pl_property_id = :property_id,
			@ps_service = :service,
         @ps_unit_preference = :result_unit_preference,
         @ps_status = :ls_status,
			@pi_result_sequence = :result_sequence OUT;


ls_status = "OK"

if isnull(sle_result.text) or sle_result.text = "" then
	openwithparm(w_pop_message, "You must provide a result")
	sle_result.setfocus()
	return 0
end if

if result_amount_flag = "Y" then
	if isnull(result_unit) then
		openwithparm(w_pop_message, "You must provide a result unit")
		sle_result.setfocus()
		return 0
	end if
else
	setnull(result_unit)
end if

if isnull(result_sequence) then
	EXECUTE lsp_new_observation_result;
	if not tf_check() then return -1
	
	FETCH lsp_new_observation_result INTO :result_sequence;
	if not tf_check() then return -1
	
	CLOSE lsp_new_observation_result;
end if


UPDATE c_Observation_Result
SET result_unit = :result_unit,
		result_amount_flag = :result_amount_flag,
		print_result_flag = :print_result_flag,
		specimen_type = :specimen_type,
		abnormal_flag = :abnormal_flag,
		severity = :severity,
		external_source = :external_source,
		property_id = :property_id,
		service = :service,
		unit_preference = :result_unit_preference,
		status = :ls_status,
		normal_range = :normal_range
WHERE observation_id = :observation_id
AND result_sequence = :result_sequence;
if not tf_check() then return -1

return 1

end function

public subroutine set_screen ();integer li_sts
str_property lstr_property
u_unit luo_unit

st_unit_title.visible = false
st_unit.visible = false

CHOOSE CASE result_type
	CASE "PERFORM"
		st_result.text = "Result:"
		st_type_title.visible = True
		st_abnormal_flag.visible = True
		st_numeric_result_title.visible = True
		st_result_amount_flag.visible = True
		st_print_result_title.visible = True
		st_print_result_flag.visible = True
		st_other_data.visible = false
		st_other_title.visible = false
		st_severity_title.text = "Severity"
		st_severity_title.visible = True
		st_severity.visible = True
		p_result_severity.visible = True
		set_severity(severity)
		st_normal_range.visible = True
		st_normal_range_title.visible = True
	CASE "COLLECT"
		st_result.text = "Specimen:"
		st_type_title.visible = false
		st_abnormal_flag.visible = false
		st_numeric_result_title.visible = True
		st_result_amount_flag.visible = True
		st_print_result_title.visible = True
		st_print_result_flag.visible = True
		st_other_data.visible = True
		st_other_title.visible = True
		st_other_title.text = "Specimen Type:"
		st_severity_title.visible = false
		st_severity.visible = false
		p_result_severity.visible = false
		if isnull(specimen_type) then
			st_other_data.text = "<None>"
		else
			st_other_data.text = specimen_type
		end if		
		st_normal_range.visible = false
		st_normal_range_title.visible = false
	CASE "COMMENT"
		st_result.text = "Comment Title:"
		st_type_title.visible = false
		st_abnormal_flag.visible = false
		st_numeric_result_title.visible = false
		st_result_amount_flag.visible = false
		st_print_result_title.visible = false
		st_print_result_flag.visible = false
		st_other_data.visible = false
		st_other_title.visible = false
		st_severity_title.visible = false
		st_severity.visible = false
		p_result_severity.visible = false
		st_normal_range.visible = false
		st_normal_range_title.visible = false
	CASE "ATTACHMENT"
		st_result.text = "Result from External Source:"
		st_type_title.visible = false
		st_abnormal_flag.visible = false
		st_numeric_result_title.visible = false
		st_result_amount_flag.visible = false
		st_print_result_title.visible = false
		st_print_result_flag.visible = false
		st_other_data.visible = True
		st_other_title.visible = True
		st_other_title.text = "External Source:"
		st_severity_title.visible = false
		st_severity.visible = false
		p_result_severity.visible = false
		if isnull(external_source) then
			st_other_data.text = "<None>"
		elseif pos(external_source, "_") > 0 then
			// If the external_source contains an underscore ("_") then it must be
			// from [c_external_source].[external_source]
			// Otherwise it must be from [c_External_Source_Type].[external_source_type]
			st_other_data.text = datalist.external_source_description(external_source)
		else
			st_other_data.text = external_source
		end if
		st_normal_range.visible = false
		st_normal_range_title.visible = false
	CASE "PROPERTY"
		st_result.text = "Calculated Result:"
		st_type_title.visible = false
		st_abnormal_flag.visible = false
		st_numeric_result_title.visible = false
		st_result_amount_flag.visible = false
		st_print_result_title.visible = false
		st_print_result_flag.visible = false
		st_other_data.visible = True
		st_other_title.visible = True
		st_other_title.text = "EncounterPRO Property"
		st_severity_title.text = "Service"
		st_severity_title.visible = true
		st_severity.visible = true
		p_result_severity.visible = false
		st_severity.text = datalist.service_description(service)
		if isnull(st_severity.text) or trim(st_severity.text) = "" then
			st_severity.text = "<None>"
		end if
		
		cb_get_phrase.visible = false
		sle_result.enabled = false
		if isnull(property_id) then
			st_other_data.text = "<None>"
		else
			lstr_property = datalist.find_property(property_id)
			if isnull(lstr_property.property_id)then
				st_other_data.text = "<None>"
			else
				st_other_data.text = lstr_property.description
			end if
		end if		
		st_normal_range.visible = false
		st_normal_range_title.visible = false
END CHOOSE

if abnormal_flag = "Y" then
	st_abnormal_flag.text = "Abnormal"
else
	st_abnormal_flag.text = "Normal"
end if

if st_result_amount_flag.visible then
	if result_amount_flag = "N" then
		st_result_amount_flag.text = "No"
		
		st_result_unit_date.visible = false
		st_result_unit_text.visible = false
		st_result_unit_number.visible = false
		st_unit.visible = false
		st_unit_title.visible = false
		st_unit_preference_title.visible = false
		st_unit_preference.visible = false
		st_print_result_title.visible = false
		st_print_result_flag.visible = false
	else
		st_print_result_title.visible = true
		st_print_result_flag.visible = true
		st_result_unit_date.visible = true
		st_result_unit_text.visible = true
		st_result_unit_number.visible = true
		st_result_unit_date.backcolor = color_object
		st_result_unit_text.backcolor = color_object
		st_result_unit_number.backcolor = color_object
		
		result_amount_flag = "Y"
		st_result_amount_flag.text = "Yes"
		luo_unit = unit_list.find_unit(result_unit)
		if isnull(luo_unit) then
			st_unit.text = ""
			st_unit_preference_title.visible = false
			st_unit_preference.visible = false
		elseif luo_unit.unit_type = "STRING" then
			st_result_unit_text.backcolor = color_object_selected
			st_unit.visible = false
			st_unit_title.visible = false
		elseif luo_unit.unit_type = "DATE" then
			st_result_unit_date.backcolor = color_object_selected
			st_unit.visible = false
			st_unit_title.visible = false
		else
			st_result_unit_number.backcolor = color_object_selected
			st_unit.visible = true
			st_unit_title.visible = true
			st_unit.text = luo_unit.description
			// See if this unit has a metric/english conversion
			if isnull(luo_unit.this_unit_preference) then
				// If not, then make the preference invisible
				st_unit_preference_title.visible = false
				st_unit_preference.visible = false
			else
				// If there is a metric/english conversion, then enable the
				// preference selection
				st_unit_preference_title.visible = true
				st_unit_preference.visible = true
				if isnull(result_unit_preference) then
					st_unit_preference.text = "N/A"
				else
					st_unit_preference.text = wordcap(result_unit_preference)
				end if
			end if
		end if
	end if
else
	st_result_unit_date.visible = false
	st_result_unit_text.visible = false
	st_result_unit_number.visible = false
	st_unit.visible = false
	st_unit_title.visible = false
	st_unit_preference_title.visible = false
	st_unit_preference.visible = false
	st_print_result_title.visible = false
	st_print_result_flag.visible = false
end if

if st_print_result_flag.visible then
	if print_result_flag = "N" then
		st_print_result_flag.text = "No"
	else
		print_result_flag = "Y"
		st_print_result_flag.text = "Yes"
	end if
end if

if isnull(result_sequence) then
	sle_result.enabled = true
else
	sle_result.enabled = false
end if

if len(normal_range) > 0 then
	st_normal_range.text = normal_range
else
	st_normal_range.text = ""
end if


	

end subroutine

event open;call super::open;string ls_bitmap
str_popup popup
integer li_sts

popup = message.powerobjectparm

if (popup.data_row_count >= 2) and (popup.data_row_count <= 3) then
	observation_id = popup.items[1]
	result_type = popup.items[2]
	if popup.data_row_count = 3 then
		result_sequence = integer(popup.items[3])
	else
		setnull(result_sequence)
	end if
else
	log.log(this, "w_observation_result_definition:open", "Invalid Parameters", 4)
	close(this)
	return
end if

if isnull(result_sequence) then
	li_sts = new_result()
	if li_sts < 0 then
		log.log(this, "w_observation_result_definition:open", "Error initializing new result", 4)
		close(this)
		return
	end if
else
	li_sts = load_result()
	if li_sts < 0 then
		log.log(this, "w_observation_result_definition:open", "Error loading result", 4)
		close(this)
		return
	end if
end if

if not isnull(popup.title) and popup.title <> "" then
	st_observation.text = popup.title
else
	st_observation.text = datalist.observation_description(observation_id)
end if


end event

on w_observation_result_definition.create
int iCurrent
call super::create
this.st_other_data=create st_other_data
this.st_other_title=create st_other_title
this.sle_result=create sle_result
this.st_result=create st_result
this.st_numeric_result_title=create st_numeric_result_title
this.st_unit=create st_unit
this.st_unit_title=create st_unit_title
this.st_type_title=create st_type_title
this.st_severity=create st_severity
this.p_result_severity=create p_result_severity
this.cb_get_phrase=create cb_get_phrase
this.st_severity_title=create st_severity_title
this.st_result_amount_flag=create st_result_amount_flag
this.st_print_result_title=create st_print_result_title
this.st_print_result_flag=create st_print_result_flag
this.st_unit_preference_title=create st_unit_preference_title
this.st_unit_preference=create st_unit_preference
this.st_normal_range_title=create st_normal_range_title
this.st_normal_range=create st_normal_range
this.st_observation=create st_observation
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.st_result_unit_date=create st_result_unit_date
this.st_result_unit_text=create st_result_unit_text
this.st_result_unit_number=create st_result_unit_number
this.st_abnormal_flag=create st_abnormal_flag
this.cb_advanced_options=create cb_advanced_options
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_other_data
this.Control[iCurrent+2]=this.st_other_title
this.Control[iCurrent+3]=this.sle_result
this.Control[iCurrent+4]=this.st_result
this.Control[iCurrent+5]=this.st_numeric_result_title
this.Control[iCurrent+6]=this.st_unit
this.Control[iCurrent+7]=this.st_unit_title
this.Control[iCurrent+8]=this.st_type_title
this.Control[iCurrent+9]=this.st_severity
this.Control[iCurrent+10]=this.p_result_severity
this.Control[iCurrent+11]=this.cb_get_phrase
this.Control[iCurrent+12]=this.st_severity_title
this.Control[iCurrent+13]=this.st_result_amount_flag
this.Control[iCurrent+14]=this.st_print_result_title
this.Control[iCurrent+15]=this.st_print_result_flag
this.Control[iCurrent+16]=this.st_unit_preference_title
this.Control[iCurrent+17]=this.st_unit_preference
this.Control[iCurrent+18]=this.st_normal_range_title
this.Control[iCurrent+19]=this.st_normal_range
this.Control[iCurrent+20]=this.st_observation
this.Control[iCurrent+21]=this.cb_ok
this.Control[iCurrent+22]=this.cb_cancel
this.Control[iCurrent+23]=this.st_result_unit_date
this.Control[iCurrent+24]=this.st_result_unit_text
this.Control[iCurrent+25]=this.st_result_unit_number
this.Control[iCurrent+26]=this.st_abnormal_flag
this.Control[iCurrent+27]=this.cb_advanced_options
end on

on w_observation_result_definition.destroy
call super::destroy
destroy(this.st_other_data)
destroy(this.st_other_title)
destroy(this.sle_result)
destroy(this.st_result)
destroy(this.st_numeric_result_title)
destroy(this.st_unit)
destroy(this.st_unit_title)
destroy(this.st_type_title)
destroy(this.st_severity)
destroy(this.p_result_severity)
destroy(this.cb_get_phrase)
destroy(this.st_severity_title)
destroy(this.st_result_amount_flag)
destroy(this.st_print_result_title)
destroy(this.st_print_result_flag)
destroy(this.st_unit_preference_title)
destroy(this.st_unit_preference)
destroy(this.st_normal_range_title)
destroy(this.st_normal_range)
destroy(this.st_observation)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.st_result_unit_date)
destroy(this.st_result_unit_text)
destroy(this.st_result_unit_number)
destroy(this.st_abnormal_flag)
destroy(this.cb_advanced_options)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_observation_result_definition
integer x = 2857
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_observation_result_definition
end type

type st_other_data from statictext within w_observation_result_definition
integer x = 1138
integer y = 1144
integer width = 1253
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "none"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;

CHOOSE CASE result_type
	CASE "COLLECT"
		get_specimen_type()
	CASE "ATTACHMENT"
		get_external_source()
	CASE "PROPERTY"
		get_property()
END CHOOSE


end event

type st_other_title from statictext within w_observation_result_definition
integer x = 119
integer y = 1148
integer width = 978
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Specimen Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_result from singlelineedit within w_observation_result_definition
integer x = 133
integer y = 264
integer width = 2478
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;if len(text) > 80 then
	openwithparm(w_pop_message, "Result is being truncated to 80 characters")
	text = left(text, 80)
end if

end event

type st_result from statictext within w_observation_result_definition
integer x = 137
integer y = 192
integer width = 1394
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Result:"
boolean focusrectangle = false
end type

type st_numeric_result_title from statictext within w_observation_result_definition
integer x = 137
integer y = 684
integer width = 960
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Result has Value:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_unit from statictext within w_observation_result_definition
boolean visible = false
integer x = 2162
integer y = 828
integer width = 521
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
u_unit luo_unit

popup.dataobject = "dw_unit_list"
popup.displaycolumn = 1
popup.datacolumn = 2

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

luo_unit = unit_list.find_unit(popup_return.items[1])
if isnull(luo_unit) then return

result_unit = luo_unit.unit_id
text = luo_unit.description

set_screen()

end event

type st_unit_title from statictext within w_observation_result_definition
boolean visible = false
integer x = 1970
integer y = 840
integer width = 174
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Unit:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_type_title from statictext within w_observation_result_definition
integer x = 498
integer y = 432
integer width = 599
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Result Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_severity from statictext within w_observation_result_definition
integer x = 1138
integer y = 1300
integer width = 695
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "none"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_bitmap
str_popup popup
str_popup_return popup_return


CHOOSE CASE result_type
	CASE "PERFORM"
		popup.dataobject = "dw_domain_pick_list"
		popup.datacolumn = 2
		popup.displaycolumn = 3
		popup.argument_count = 1
		popup.argument[1] = "RESULTSEVERITY"
		openwithparm(w_pop_pick, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count = 0 then return
		
		severity = integer(popup_return.items[1])
		text = popup_return.descriptions[1]
		
		ls_bitmap = datalist.domain_item_bitmap("RESULTSEVERITY", string(severity))
		p_result_severity.picturename = ls_bitmap
	CASE "PROPERTY"
		popup.dataobject = "dw_service_for_treatment_workplan"
		popup.datacolumn = 1
		popup.displaycolumn = 2
		popup.add_blank_row = true
		popup.blank_text = "<None>"
		openwithparm(w_pop_pick, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		
		if popup_return.items[1] = "" then
			setnull(service)
		else
			service = popup_return.items[1]
		end if
		
		text = popup_return.descriptions[1]
END CHOOSE




end event

type p_result_severity from picture within w_observation_result_definition
integer x = 1861
integer y = 1300
integer width = 133
integer height = 100
boolean bringtotop = true
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type cb_get_phrase from commandbutton within w_observation_result_definition
boolean visible = false
integer x = 2633
integer y = 264
integer width = 146
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ". . ."
end type

event clicked;u_component_nomenclature luo_nomenclature
string ls_phrase

//luo_nomenclature = component_manager.get_component("NOMENCLATURE","PHRASE")
setnull(luo_nomenclature)
if isnull(luo_nomenclature) then
	openwithparm(w_pop_message, "A nomenclature component has not been installed")
	return
end if

ls_phrase = luo_nomenclature.get_phrase("RESULT")
if not (isnull(ls_phrase) or trim(ls_phrase) = "") then
	sle_result.text = ls_phrase
end if

component_manager.destroy_component(luo_nomenclature)


end event

type st_severity_title from statictext within w_observation_result_definition
integer x = 507
integer y = 1304
integer width = 590
integer height = 92
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Severity:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_result_amount_flag from statictext within w_observation_result_definition
boolean visible = false
integer x = 1138
integer y = 680
integer width = 274
integer height = 100
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if result_amount_flag = "Y" then
	result_amount_flag = "N"
else
	result_amount_flag = "Y"
end if

set_screen()

end event

type st_print_result_title from statictext within w_observation_result_definition
integer x = 201
integer y = 836
integer width = 896
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Print Result Title:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_print_result_flag from statictext within w_observation_result_definition
boolean visible = false
integer x = 1138
integer y = 832
integer width = 274
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if print_result_flag = "Y" then
	print_result_flag = "N"
	text = "No"
else
	print_result_flag = "Y"
	text = "Yes"
end if


end event

type st_unit_preference_title from statictext within w_observation_result_definition
boolean visible = false
integer x = 1760
integer y = 956
integer width = 379
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Preference:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_unit_preference from statictext within w_observation_result_definition
boolean visible = false
integer x = 2162
integer y = 952
integer width = 521
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
integer li_sts
string ls_button

popup.title = "Unit Preference"
popup.data_row_count = 3
popup.items[1] = "N/A"
popup.items[2] = "English"
popup.items[3] = "Metric"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

text = popup_return.descriptions[1]

CHOOSE CASE popup_return.item_indexes[1]
	CASE 1
		setnull(result_unit_preference)
	CASE 2
		result_unit_preference = "ENGLISH"
	CASE 3
		result_unit_preference = "METRIC"
END CHOOSE


end event

type st_normal_range_title from statictext within w_observation_result_definition
integer x = 507
integer y = 1460
integer width = 590
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Normal Range:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_normal_range from statictext within w_observation_result_definition
integer x = 1138
integer y = 1456
integer width = 1074
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

// Parameters (popup.):
// title					Screen title/user instructions
// item					Default string value
//	data_row_count		Number of items in the canned selections list
// items[]				list of canned selections
// argument_count		Number of top_20 arguments supplied
// argument[]			List of top_20 arguments
//							argument[1] = specific top_20_code
//							argument[2] = generic top_20_code
// multiselect			True = Allow empty string
//							False = Don't allow empty string
// displaycolumn		Max Length

popup.title = "Enter normal range for result"
popup.item = normal_range
popup.displaycolumn = 40
popup.multiselect = true
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 0 then return

if trim(popup_return.items[1]) = "" then
	setnull(normal_range)
	text = ""
else
	normal_range = trim(popup_return.items[1])
	text = normal_range
end if


end event

type st_observation from statictext within w_observation_result_definition
integer width = 2921
integer height = 136
boolean bringtotop = true
integer textsize = -20
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_observation_result_definition
integer x = 2418
integer y = 1656
integer width = 402
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;str_popup_return popup_return
integer li_sts

li_sts = save_changes()
if li_sts <= 0 then return

popup_return.item_count = 1
popup_return.items[1] = string(result_sequence)

closewithreturn(parent, popup_return)


end event

type cb_cancel from commandbutton within w_observation_result_definition
integer x = 73
integer y = 1656
integer width = 402
integer height = 112
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;str_popup_return popup_return

setnull(popup_return.item)
popup_return.item_count = 0

closewithreturn(parent, popup_return)


end event

type st_result_unit_date from statictext within w_observation_result_definition
boolean visible = false
integer x = 1559
integer y = 680
integer width = 274
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Date"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;result_unit = "DATE"

set_screen()

end event

type st_result_unit_text from statictext within w_observation_result_definition
boolean visible = false
integer x = 1861
integer y = 680
integer width = 274
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Text"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;result_unit = "TEXT"

set_screen()

end event

type st_result_unit_number from statictext within w_observation_result_definition
boolean visible = false
integer x = 2162
integer y = 680
integer width = 274
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Number"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;result_unit = "INTEGER"

set_screen()

end event

type st_abnormal_flag from statictext within w_observation_result_definition
boolean visible = false
integer x = 1138
integer y = 428
integer width = 613
integer height = 100
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Normal"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if abnormal_flag = "Y" then
	abnormal_flag = "N"
	set_severity(0)
	text = "Normal"
else
	abnormal_flag = "Y"
	set_severity(3)
	text = "Abnormal"
end if

end event

type cb_advanced_options from commandbutton within w_observation_result_definition
integer x = 1211
integer y = 1680
integer width = 494
integer height = 88
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Advanced Options"
end type

event clicked;str_c_observation_result lstr_result
integer li_sts

li_sts = save_changes()
if li_sts <= 0 then return

lstr_result = datalist.observation_result(observation_id, result_sequence)

openwithparm(w_observation_result_definition_advanced, lstr_result)


return

end event

