HA$PBExportHeader$w_carrier_definition.srw
forward
global type w_carrier_definition from w_window_base
end type
type pb_done from u_picture_button within w_carrier_definition
end type
type pb_cancel from u_picture_button within w_carrier_definition
end type
type sle_name from singlelineedit within w_carrier_definition
end type
type st_name_title from statictext within w_carrier_definition
end type
type st_title from statictext within w_carrier_definition
end type
type st_authority_type from statictext within w_carrier_definition
end type
type st_title_assessment_type from statictext within w_carrier_definition
end type
type st_coding_component from statictext within w_carrier_definition
end type
type st_coding_title from statictext within w_carrier_definition
end type
type st_alt_icd9 from statictext within w_carrier_definition
end type
type st_alternate_title from statictext within w_carrier_definition
end type
type st_alt_cpt from statictext within w_carrier_definition
end type
type dw_alternate_icd_codes from u_dw_pick_list within w_carrier_definition
end type
type cb_page from commandbutton within w_carrier_definition
end type
type cb_new_alternate_code from commandbutton within w_carrier_definition
end type
type st_alternate_desc_title from statictext within w_carrier_definition
end type
type st_alternate_std_title from statictext within w_carrier_definition
end type
type st_alternate_alt_title from statictext within w_carrier_definition
end type
type st_no_alternate_codes from statictext within w_carrier_definition
end type
type dw_alternate_cpt_codes from u_dw_pick_list within w_carrier_definition
end type
type st_authority_category from statictext within w_carrier_definition
end type
type st_category from statictext within w_carrier_definition
end type
end forward

global type w_carrier_definition from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_done pb_done
pb_cancel pb_cancel
sle_name sle_name
st_name_title st_name_title
st_title st_title
st_authority_type st_authority_type
st_title_assessment_type st_title_assessment_type
st_coding_component st_coding_component
st_coding_title st_coding_title
st_alt_icd9 st_alt_icd9
st_alternate_title st_alternate_title
st_alt_cpt st_alt_cpt
dw_alternate_icd_codes dw_alternate_icd_codes
cb_page cb_page
cb_new_alternate_code cb_new_alternate_code
st_alternate_desc_title st_alternate_desc_title
st_alternate_std_title st_alternate_std_title
st_alternate_alt_title st_alternate_alt_title
st_no_alternate_codes st_no_alternate_codes
dw_alternate_cpt_codes dw_alternate_cpt_codes
st_authority_category st_authority_category
st_category st_category
end type
global w_carrier_definition w_carrier_definition

type variables
string authority_id
string authority_type,authority_category

string component_id

string alt_code_mode

end variables

forward prototypes
public subroutine cpt_menu (long pl_row)
public subroutine icd_menu (long pl_row)
public function integer load_carrier ()
public function integer new_assessment ()
public function integer new_procedure ()
end prototypes

public subroutine cpt_menu (long pl_row);str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Alternate CPT Code"
	popup.button_titles[popup.button_count] = "Edit"
	buttons[popup.button_count] = "EDIT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Delete Alternate CPT Code"
	popup.button_titles[popup.button_count] = "Delete"
	buttons[popup.button_count] = "DELETE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	button_pressed = message.doubleparm
	if button_pressed < 1 or button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if

CHOOSE CASE buttons[button_pressed]
	CASE "EDIT"
	CASE "DELETE"
		openwithparm(w_pop_yes_no, "Are you sure you wish to delete this code?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		dw_alternate_cpt_codes.deleterow(pl_row)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end subroutine

public subroutine icd_menu (long pl_row);str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Alternate ICD-9 Code"
	popup.button_titles[popup.button_count] = "Edit"
	buttons[popup.button_count] = "EDIT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Delete Alternate ICD-9 Code"
	popup.button_titles[popup.button_count] = "Delete"
	buttons[popup.button_count] = "DELETE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	button_pressed = message.doubleparm
	if button_pressed < 1 or button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if

CHOOSE CASE buttons[button_pressed]
	CASE "EDIT"
	CASE "DELETE"
		openwithparm(w_pop_yes_no, "Are you sure you wish to delete this code?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		dw_alternate_icd_codes.deleterow(pl_row)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end subroutine

public function integer load_carrier ();

return 1

end function

public function integer new_assessment ();string ls_assessment_id
string ls_description
string ls_icd_9_code
string ls_standard_icd_9_code
str_popup_return popup_return
long ll_row
str_popup popup

popup.data_row_count = 2
setnull(popup.items[1])
setnull(popup.items[2])
openwithparm(w_find_assessment, popup)
ls_assessment_id = message.stringparm
if isnull(ls_assessment_id) or trim(ls_assessment_id) = "" then return 0

ls_description = datalist.assessment_description(ls_assessment_id)
ls_standard_icd_9_code = datalist.assessment_icd_9_code(ls_assessment_id)

popup.title = "Please enter alternate ICD code"
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

ls_icd_9_code = popup_return.items[1]

ll_row = dw_alternate_icd_codes.insertrow(0)
dw_alternate_icd_codes.object.authority_id[ll_row] = authority_id
dw_alternate_icd_codes.object.assessment_id[ll_row] = ls_assessment_id
dw_alternate_icd_codes.object.icd_9_code[ll_row] = ls_icd_9_code
dw_alternate_icd_codes.object.standard_icd_9_code[ll_row] = ls_standard_icd_9_code
dw_alternate_icd_codes.object.description[ll_row] = ls_description

dw_alternate_icd_codes.update()

return 1


end function

public function integer new_procedure ();str_popup popup
string ls_cpt_code
decimal ldc_charge
string ls_description
string ls_procedure_id
integer li_sts
str_picked_procedures lstr_procedures

popup.data_row_count = 1
setnull(popup.items[1])
openwithparm(w_pick_procedures, popup)
lstr_procedures = message.powerobjectparm
if lstr_procedures.procedure_count <> 1 then return 0
ls_description = lstr_procedures.procedures[1].description
ls_procedure_id = lstr_procedures.procedures[1].procedure_id
li_sts = tf_get_procedure_charge(ls_procedure_id, ls_cpt_code, ldc_charge)
if li_sts <= 0 then return -1


return 1


end function

event open;call super::open;str_popup popup
str_popup_return popup_return
integer li_sts
string ls_title

popup_return.item_count = 0

popup = message.powerobjectparm
dw_alternate_cpt_codes.settransobject(sqlca)
dw_alternate_icd_codes.settransobject(sqlca)

If popup.data_row_count = 2 Then
	authority_type = popup.items[1]
	authority_category = popup.items[2]
	setnull(component_id)
	setnull(authority_id)
	st_title.text = "Authority Definition"
	st_coding_component.text = "<Default>"
	dw_alternate_icd_codes.visible = false
	dw_alternate_cpt_codes.visible = false
	cb_page.visible = false
	st_alt_cpt.visible = false
	st_alt_icd9.visible = false
	cb_new_alternate_code.visible = false
	st_alternate_desc_title.visible = false
	st_alternate_std_title.visible = false
	st_alternate_alt_title.visible = false
	st_alternate_title.visible = false
ElseIf popup.data_row_count = 1 Then
	authority_id = popup.items[1]
	SELECT authority_type,authority_category,name
	INTO :authority_type,:authority_category,:ls_title
	FROM c_Authority
	WHERE authority_id = :authority_id;
	
	st_title.text = ls_title
	st_name_title.visible = false
	sle_name.visible = false
	
	// Get the coding component
	SELECT a.coding_component_id, b.description
	INTO :component_id, :st_coding_component.text
	FROM c_authority a
		INNER JOIN (SELECT component_id, description FROM dbo.fn_components()) b
		ON a.coding_component_id = b.component_id
	WHERE a.authority_id = :authority_id;
	if not tf_check() then
		log.log(this, "open", "Error getting coding component", 4)
		closewithreturn(this, popup_return)
		return
	end if
	if sqlca.sqlcode = 100 then
		setnull(component_id)
		st_coding_component.text = "<Default>"
	end if
	dw_alternate_icd_codes.retrieve(authority_id)
	dw_alternate_cpt_codes.retrieve(authority_id)
	st_alt_icd9.event POST clicked()
else
	log.log(this, "open", "Invalid Parameters", 4)
	closewithreturn(this, popup_return)
	return
end if

If Not isnull(authority_type) Then
	SELECT description
	INTO :st_authority_type.text
	FROM c_authority_Type
	WHERE authority_type = :authority_type;
	If not tf_check() then
		log.log(this, "open", "Error getting authority type", 4)
		closewithreturn(this, popup_return)
		return
	End If

	If not isnull(authority_category) then
		SELECT description
		INTO :st_authority_category.text
		FROM c_authority_category
		WHERE authority_type = :authority_type
		And authority_category = :authority_category;
		if not tf_check() then
			log.log(this, "open", "Error getting authority type", 4)
			closewithreturn(this, popup_return)
			return
		end if
	end if
End If
end event

on w_carrier_definition.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.sle_name=create sle_name
this.st_name_title=create st_name_title
this.st_title=create st_title
this.st_authority_type=create st_authority_type
this.st_title_assessment_type=create st_title_assessment_type
this.st_coding_component=create st_coding_component
this.st_coding_title=create st_coding_title
this.st_alt_icd9=create st_alt_icd9
this.st_alternate_title=create st_alternate_title
this.st_alt_cpt=create st_alt_cpt
this.dw_alternate_icd_codes=create dw_alternate_icd_codes
this.cb_page=create cb_page
this.cb_new_alternate_code=create cb_new_alternate_code
this.st_alternate_desc_title=create st_alternate_desc_title
this.st_alternate_std_title=create st_alternate_std_title
this.st_alternate_alt_title=create st_alternate_alt_title
this.st_no_alternate_codes=create st_no_alternate_codes
this.dw_alternate_cpt_codes=create dw_alternate_cpt_codes
this.st_authority_category=create st_authority_category
this.st_category=create st_category
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.sle_name
this.Control[iCurrent+4]=this.st_name_title
this.Control[iCurrent+5]=this.st_title
this.Control[iCurrent+6]=this.st_authority_type
this.Control[iCurrent+7]=this.st_title_assessment_type
this.Control[iCurrent+8]=this.st_coding_component
this.Control[iCurrent+9]=this.st_coding_title
this.Control[iCurrent+10]=this.st_alt_icd9
this.Control[iCurrent+11]=this.st_alternate_title
this.Control[iCurrent+12]=this.st_alt_cpt
this.Control[iCurrent+13]=this.dw_alternate_icd_codes
this.Control[iCurrent+14]=this.cb_page
this.Control[iCurrent+15]=this.cb_new_alternate_code
this.Control[iCurrent+16]=this.st_alternate_desc_title
this.Control[iCurrent+17]=this.st_alternate_std_title
this.Control[iCurrent+18]=this.st_alternate_alt_title
this.Control[iCurrent+19]=this.st_no_alternate_codes
this.Control[iCurrent+20]=this.dw_alternate_cpt_codes
this.Control[iCurrent+21]=this.st_authority_category
this.Control[iCurrent+22]=this.st_category
end on

on w_carrier_definition.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.sle_name)
destroy(this.st_name_title)
destroy(this.st_title)
destroy(this.st_authority_type)
destroy(this.st_title_assessment_type)
destroy(this.st_coding_component)
destroy(this.st_coding_title)
destroy(this.st_alt_icd9)
destroy(this.st_alternate_title)
destroy(this.st_alt_cpt)
destroy(this.dw_alternate_icd_codes)
destroy(this.cb_page)
destroy(this.cb_new_alternate_code)
destroy(this.st_alternate_desc_title)
destroy(this.st_alternate_std_title)
destroy(this.st_alternate_alt_title)
destroy(this.st_no_alternate_codes)
destroy(this.dw_alternate_cpt_codes)
destroy(this.st_authority_category)
destroy(this.st_category)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_carrier_definition
integer x = 2642
integer y = 180
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_carrier_definition
end type

type pb_done from u_picture_button within w_carrier_definition
integer x = 2569
integer y = 1532
integer taborder = 0
boolean default = true
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return
integer li_sts
string ls_description
string ls_authority_id
integer i
integer li_count

if isnull(authority_id) then
	ls_description = sle_name.text
	if isnull(authority_type) then
		openwithparm(w_pop_message, "You must select an authority type")
		return
	end if
	if isnull(authority_category) then
		openwithparm(w_pop_message, "You must select an authority category")
		return
	end if
	if trim(ls_description) = "" or isnull(ls_description) then
		openwithparm(w_pop_message, "You must enter a carrier name")
		return
	end if
	ls_authority_id = f_gen_key_string(ls_description, 22)
	authority_id = ls_authority_id
	for i = 0 to 99
		SELECT count(*)
		INTO :li_count
		FROM c_authority
		WHERE authority_id = :authority_id;
		if not tf_check() then return
		if li_count = 0 then exit
		authority_id = ls_authority_id + string(i)
	next
	if i >= 99 then
		log.log(this, "clicked", "Error generating new authority id (" + ls_description + ")", 4)
		return
	end if
	
	INSERT INTO c_Authority (
		authority_id,
		authority_type,
		authority_category,
		name,
		coding_component_id,
		status)
	VALUES (
		:authority_id,
		:authority_type,
		:authority_category,
		:ls_description,
		:component_id,
		'OK');
	if not tf_check() then return
else
	li_sts = dw_alternate_icd_codes.update()
	if li_sts < 0 then
		log.log(this, "clicked", "Error saving icd codes", 4)
		return
	end if
	
	li_sts = dw_alternate_cpt_codes.update()
	if li_sts < 0 then
		log.log(this, "clicked", "Error saving cpt codes", 4)
		return
	end if
	
	ls_description = st_title.text
	Update c_Authority
	SET authority_type = :authority_type,
		authority_category = :authority_category,
		coding_component_id = :component_id
	WHERE authority_id = :authority_id;
	if not tf_check() then return
end if

popup_return.item_count = 1
popup_return.items[1] = authority_id
popup_return.descriptions[1] = ls_description
closewithreturn(parent, popup_return)


end event

type pb_cancel from u_picture_button within w_carrier_definition
integer x = 119
integer y = 1532
integer taborder = 0
boolean bringtotop = true
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

setnull(popup_return.item)
popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type sle_name from singlelineedit within w_carrier_definition
integer x = 974
integer y = 472
integer width = 1550
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_name_title from statictext within w_carrier_definition
integer x = 535
integer y = 480
integer width = 398
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Name:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_title from statictext within w_carrier_definition
integer x = 5
integer y = 12
integer width = 2926
integer height = 136
boolean bringtotop = true
integer textsize = -22
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Authority Definition"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_authority_type from statictext within w_carrier_definition
integer x = 992
integer y = 184
integer width = 946
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
string ls_prev_authority_type,ls_prev_type_text
str_popup_return popup_return

ls_prev_authority_type = authority_type
ls_prev_type_text = text

popup.dataobject = "dw_authority_type_pick_list"
popup.datacolumn = 1
popup.displaycolumn = 2
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

authority_type = popup_return.items[1]
text = popup_return.descriptions[1]
if st_authority_category.event clicked() = 0 Then
	// no associated category, so can't change authority type
	openwithparm(w_pop_message,"No authority categories for selected type")
	authority_type = ls_prev_authority_type
	text = ls_prev_type_text
end if
end event

type st_title_assessment_type from statictext within w_carrier_definition
integer x = 215
integer y = 196
integer width = 736
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Authority Type"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_coding_component from statictext within w_carrier_definition
integer x = 978
integer y = 604
integer width = 946
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_components_of_type_pick_list"
popup.datacolumn = 1
popup.displaycolumn = 4
popup.argument_count = 2
popup.argument[1] = "CODING"
popup.argument[2] = "ENCOUNTER"
popup.add_blank_row = true
popup.blank_text = "<Default>"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	setnull(component_id)
	text = "<Default>"
else
	component_id = popup_return.items[1]
	text = popup_return.descriptions[1]
end if


end event

type st_coding_title from statictext within w_carrier_definition
integer x = 201
integer y = 616
integer width = 736
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Coding Algorithm:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_alt_icd9 from statictext within w_carrier_definition
integer x = 137
integer y = 1056
integer width = 325
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "ICD-9"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;integer li_count

dw_alternate_cpt_codes.visible = false
st_alt_cpt.backcolor = color_object
backcolor = color_object_selected

alt_code_mode = "ICD"

li_count = dw_alternate_icd_codes.rowcount()
if li_count <= 0 then
	cb_page.visible = false
	dw_alternate_icd_codes.visible = false
	st_no_alternate_codes.visible = true
else
	cb_page.visible = true
	dw_alternate_icd_codes.visible = true
	st_no_alternate_codes.visible = false
	dw_alternate_icd_codes.set_page(1, cb_page.text)
end if


end event

type st_alternate_title from statictext within w_carrier_definition
integer x = 27
integer y = 936
integer width = 549
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Alternate Codes"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_alt_cpt from statictext within w_carrier_definition
integer x = 133
integer y = 1224
integer width = 325
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "CPT"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;integer li_count

dw_alternate_icd_codes.visible = false
st_alt_icd9.backcolor = color_object
backcolor = color_object_selected

alt_code_mode = "CPT"

li_count = dw_alternate_cpt_codes.rowcount()
if li_count <= 0 then
	cb_page.visible = false
	dw_alternate_cpt_codes.visible = false
	st_no_alternate_codes.visible = true
else
	cb_page.visible = true
	dw_alternate_cpt_codes.visible = true
	st_no_alternate_codes.visible = false
	dw_alternate_cpt_codes.set_page(1, cb_page.text)
end if


end event

type dw_alternate_icd_codes from u_dw_pick_list within w_carrier_definition
integer x = 581
integer y = 836
integer width = 1774
integer height = 968
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_alternate_icd9_codes"
boolean border = false
end type

event selected;call super::selected;icd_menu(selected_row)

end event

type cb_page from commandbutton within w_carrier_definition
integer x = 2368
integer y = 844
integer width = 370
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Page 99/99"
end type

type cb_new_alternate_code from commandbutton within w_carrier_definition
integer x = 2450
integer y = 1152
integer width = 384
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Code"
end type

event clicked;integer li_sts

if alt_code_mode = "ICD" then
	li_sts = new_assessment()
else
	li_sts = new_procedure()
end if


end event

type st_alternate_desc_title from statictext within w_carrier_definition
integer x = 594
integer y = 768
integer width = 549
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Description"
boolean focusrectangle = false
end type

type st_alternate_std_title from statictext within w_carrier_definition
integer x = 1911
integer y = 704
integer width = 183
integer height = 128
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Std Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_alternate_alt_title from statictext within w_carrier_definition
integer x = 2135
integer y = 704
integer width = 183
integer height = 128
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Alt Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_no_alternate_codes from statictext within w_carrier_definition
boolean visible = false
integer x = 741
integer y = 1132
integer width = 1504
integer height = 156
boolean bringtotop = true
integer textsize = -24
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "No Alternate Codes"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_alternate_cpt_codes from u_dw_pick_list within w_carrier_definition
integer x = 581
integer y = 836
integer width = 1774
integer height = 968
integer taborder = 11
string dataobject = "dw_alternate_cpt_codes"
boolean border = false
end type

event selected;call super::selected;cpt_menu(selected_row)

end event

type st_authority_category from statictext within w_carrier_definition
integer x = 992
integer y = 324
integer width = 946
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_authority_category_pick_list"
popup.datacolumn = 2
popup.displaycolumn = 3
popup.argument_count = 1
popup.argument[1] = authority_type
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

authority_category = popup_return.items[1]
text = popup_return.descriptions[1]

Return 1

end event

type st_category from statictext within w_carrier_definition
integer x = 215
integer y = 336
integer width = 736
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Authority Category"
alignment alignment = right!
boolean focusrectangle = false
end type

