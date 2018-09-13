$PBExportHeader$u_st_property.sru
forward
global type u_st_property from statictext
end type
end forward

global type u_st_property from statictext
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
boolean focusrectangle = false
end type
global u_st_property u_st_property

type variables
str_property property
statictext property_title
integer original_textsize
long object_key
str_attributes property_attributes

end variables

forward prototypes
public function integer refresh ()
public subroutine set_text (string ps_text)
public function integer initialize (string ps_context_property, statictext pst_property_title, long pl_object_key, str_attributes pstr_attributes)
end prototypes

public function integer refresh ();string ls_temp
str_property_value lstr_property_value

lstr_property_value = f_get_property(property.property_object, property.function_name, object_key, property_attributes)
if isnull(lstr_property_value.value) then
	text = ""
	backcolor = color_object
	textcolor = color_black
	weight = 400
else
	set_text(lstr_property_value.value)
	
	if isnull(lstr_property_value.backcolor) then
		backcolor = color_object
	else
		backcolor = lstr_property_value.backcolor
	end if
	
	if isnull(lstr_property_value.textcolor) then
		textcolor = color_black
	else
		textcolor = lstr_property_value.textcolor
	end if
	
	if isnull(lstr_property_value.weight) then
		weight = 400
	else
		weight = lstr_property_value.weight
	end if
end if

return 1

end function

public subroutine set_text (string ps_text);integer li_len
integer li_units_per_char_10 = 26
integer li_units_per_char_9 = 25
integer li_units_per_char_8 = 23

text = ps_text

li_len = len(ps_text)
if li_len > width / li_units_per_char_10 then
	if li_len > width / li_units_per_char_9 then
		textsize = -8
	else
		textsize = -9
	end if
else
	textsize = -10
end if

if textsize < original_textsize then textsize = original_textsize

end subroutine

public function integer initialize (string ps_context_property, statictext pst_property_title, long pl_object_key, str_attributes pstr_attributes);integer li_sts
string ls_context_object
string ls_property

f_split_string(ps_context_property, " ", ls_context_object, ls_property)

object_key = pl_object_key
property_attributes = pstr_attributes

property = datalist.find_property(ls_context_object, ls_property)

if not isnull(pst_property_title) and isvalid(pst_property_title) then
	property_title = pst_property_title
	property_title.text = property.title
else
	setnull(property_title)
end if

if lower(property.property_type) = "user defined" or not isnull(property.service) then
	borderstyle = styleraised!
else
	borderstyle = stylelowered!
end if

original_textsize = textsize

return 1

end function

on u_st_property.create
end on

on u_st_property.destroy
end on

event constructor;setnull(property.property_id)

end event

event clicked;str_attributes lstr_attributes
string ls_progress
string ls_progress_key
integer li_sts
str_popup popup
str_popup_return popup_return

if not isnull(property.service) then
	lstr_attributes = f_get_context_attributes()
	
	service_list.do_service(current_patient.cpr_id, &
									current_patient.open_encounter_id, &
									property.service, &
									lstr_attributes)
	
	
	refresh()
elseif lower(property.property_type) = "user defined" then
	CHOOSE CASE lower(property.property_object)
		CASE "patient"
			popup.title = "Enter new value for " + property.description
			popup.item = text
			popup.argument_count = 1
			popup.argument[1] = "PROPERTY|" + string(property.property_id)
			openwithparm(w_pop_prompt_string, popup)
			popup_return = message.powerobjectparm
			if popup_return.item_count <> 1 then return
			
			ls_progress_key = property.function_name
			ls_progress = popup_return.items[1]
			li_sts = current_patient.set_property(ls_progress_key, ls_progress)
			if li_sts > 0 then set_text(ls_progress)

		CASE "encounter"
		CASE "assessment"
		CASE "treatment"
	END CHOOSE
end if

end event

