HA$PBExportHeader$w_trt_pick_drugs.srw
forward
global type w_trt_pick_drugs from w_window_base
end type
type st_search_title from statictext within w_trt_pick_drugs
end type
type pb_down_sel from u_picture_button within w_trt_pick_drugs
end type
type pb_up_sel from u_picture_button within w_trt_pick_drugs
end type
type pb_up from u_picture_button within w_trt_pick_drugs
end type
type pb_down from u_picture_button within w_trt_pick_drugs
end type
type st_page from statictext within w_trt_pick_drugs
end type
type st_category from statictext within w_trt_pick_drugs
end type
type st_top_20 from statictext within w_trt_pick_drugs
end type
type st_cpt_code from statictext within w_trt_pick_drugs
end type
type st_search_status from statictext within w_trt_pick_drugs
end type
type st_specialty from statictext within w_trt_pick_drugs
end type
type st_specialty_title from statictext within w_trt_pick_drugs
end type
type dw_selected_items from u_dw_pick_list within w_trt_pick_drugs
end type
type st_title from statictext within w_trt_pick_drugs
end type
type st_selected_items from statictext within w_trt_pick_drugs
end type
type st_description from statictext within w_trt_pick_drugs
end type
type st_common_flag from statictext within w_trt_pick_drugs
end type
type dw_drugs from u_dw_drug_list within w_trt_pick_drugs
end type
type st_page_sel from statictext within w_trt_pick_drugs
end type
type cb_new_drug from commandbutton within w_trt_pick_drugs
end type
type cb_cancel from commandbutton within w_trt_pick_drugs
end type
type cb_finished from commandbutton within w_trt_pick_drugs
end type
end forward

global type w_trt_pick_drugs from w_window_base
integer height = 1836
boolean controlmenu = false
windowtype windowtype = response!
st_search_title st_search_title
pb_down_sel pb_down_sel
pb_up_sel pb_up_sel
pb_up pb_up
pb_down pb_down
st_page st_page
st_category st_category
st_top_20 st_top_20
st_cpt_code st_cpt_code
st_search_status st_search_status
st_specialty st_specialty
st_specialty_title st_specialty_title
dw_selected_items dw_selected_items
st_title st_title
st_selected_items st_selected_items
st_description st_description
st_common_flag st_common_flag
dw_drugs dw_drugs
st_page_sel st_page_sel
cb_new_drug cb_new_drug
cb_cancel cb_cancel
cb_finished cb_finished
end type
global w_trt_pick_drugs w_trt_pick_drugs

type variables
str_attributes_list selected_attributes_list


String treatment_type,specialty_id
String search_type
String common_flag = "Y"
Boolean past_treatment = false
end variables

forward prototypes
public subroutine select_drug (string ps_drug_id, string ps_description)
end prototypes

public subroutine select_drug (string ps_drug_id, string ps_description);Datetime ldt_begin_date
Date		ld_begin_date
Long		ll_row
Integer	li_count,li_administration_sequence,i
String	ls_temp,ls_treatment_mode
String	ls_admin_description,ls_administer_unit
String	ls_description,ls_drug_id,ls_dosage_form,ls_package_id
str_attributes lstr_attributes
str_pick_users lstr_pick_users
boolean lb_past_med_who_ordered
string ls_ordered_by

str_popup	popup
str_popup_return popup_return
str_drug_administration lstra_admin[]

ls_drug_id = ps_drug_id
ls_description = ps_description

// Add the drug to the attributes
f_attribute_add_attribute(lstr_attributes, "drug_id", ls_drug_id)

Setnull(li_administration_sequence)
Setnull(ls_admin_description)
Setnull(ls_administer_unit)
Setnull(ls_package_id)
Setnull(ld_begin_date)
		
// Get the duration & Package if it's past treatment
If past_treatment Then
	openwithparm(w_drug_admin_edit, lstr_attributes)
	lstr_attributes = message.powerobjectparm
	if lstr_attributes.attribute_count <= 0 then return

	// Let the user select a begin date
	ls_temp = f_select_date_interval(ld_begin_date, "For How Long?", today(), "ONSET")
	If isnull(ls_temp) OR trim(ls_temp) = "" Then
		setnull(ldt_begin_date)
	Else
		ls_description += " " + ls_temp
		f_attribute_add_attribute(lstr_attributes, "begin_date", string(ld_begin_date))
	End If
	
	ls_ordered_by = "#Unknown"
	lb_past_med_who_ordered = datalist.get_preference_boolean( "PREFERENCES", "Past Med Prompt Who Ordered", true)
	if lb_past_med_who_ordered then
		lstr_pick_users.pick_screen_title = "Who Ordered This Medication?"
		lstr_pick_users.cpr_id = current_patient.cpr_id
		lstr_pick_users.actor_class = "Consultant"
		user_list.pick_users(lstr_pick_users)
		if lstr_pick_users.selected_users.user_count > 0 then
			ls_ordered_by = lstr_pick_users.selected_users.user[1].user_id
		end if
	end if
	f_attribute_add_attribute(lstr_attributes, "ordered_by", ls_ordered_by)
Else
	// Make user select administration
	
	// This is a hack.  Use some sort of treatment attribute later to determine
	// the filter for picking the admin sequence
	if upper(treatment_type) = "OFFICEMED" then
		li_count = f_get_drug_administration_dose(ls_drug_id, lstra_admin)
	else
		li_count = f_get_drug_administration(ls_drug_id, lstra_admin)
	end if
	if li_count > 0 then
		popup.data_row_count = li_count
		for i = 1 to li_count
			popup.items[i] = lstra_admin[i].description
		next
		popup.auto_singleton = true
		openwithparm(w_pop_pick, popup, this)
		popup_return = message.powerobjectparm
		if popup_return.item_count = 1 then
			li_administration_sequence = lstra_admin[popup_return.item_indexes[1]].administration_sequence
			ls_admin_description = lstra_admin[popup_return.item_indexes[1]].description
			ls_administer_unit = lstra_admin[popup_return.item_indexes[1]].administer_unit
			f_attribute_add_attribute(lstr_attributes, "administration_sequence", string(li_administration_sequence))
		end if
	end if
	
	// The make user select dosage form
	popup.dataobject = "dw_dosage_form"
	popup.data_row_count = 0
	popup.displaycolumn = 2
	popup.datacolumn = 1
	popup.argument_count = 2
	popup.argument[1] = ls_drug_id
	popup.argument[2] = ls_administer_unit
	popup.auto_singleton = true
	openwithparm(w_pop_pick, popup, this)
	popup_return = message.powerobjectparm
	If popup_return.item_count = 1 Then
		f_attribute_add_attribute(lstr_attributes, "dosage_form", popup_return.items[1])
		ls_dosage_form = popup_return.items[1]
		ls_description += " " + popup_return.descriptions[1]
	End if

	If Not isnull(ls_admin_description) Then
		ls_description += " " + ls_admin_description
	End If
End If

ls_treatment_mode = f_get_default_treatment_mode(treatment_type, ps_drug_id)
f_attribute_add_attribute(lstr_attributes, "treatment_mode", ls_treatment_mode)

// Calculate the description and it to the attributes
ls_description = f_attribute_find_attribute(lstr_attributes, "treatment_description")
if isnull(ls_description) then
	ls_description = f_drug_treatment_sig(lstr_attributes)
	f_attribute_add_attribute(lstr_attributes, "treatment_description", ls_description)
end if

// Add to the attributes list
selected_attributes_list.attributes_count += 1
selected_attributes_list.attributes[selected_attributes_list.attributes_count] = lstr_attributes

// Display in the "Selected" window
ll_row = dw_selected_items.insertrow(0)
dw_selected_items.object.description[ll_row] = ls_description
dw_selected_items.object.attributes_index[ll_row] = selected_attributes_list.attributes_count
dw_selected_items.object.treatment_mode[ll_row] = ls_treatment_mode

dw_drugs.clear_selected()

cb_finished.enabled = true

dw_selected_items.scrolltorow(ll_row)
dw_selected_items.recalc_page( pb_up_sel, pb_down_sel, st_page_sel)

end subroutine

event open;call super::open;//////////////////////////////////////////////////////////////////////////////////////
//
// Description:Based on treatment type, set the datawindow object names for category
// alpha and top20. [ need to be generalized in future by replacing this case state
// -ment with treatmet component ]
//
// Created By:Mark														Creation dt: 
//
// Modified By:Sumathi Chinnasamy									Creation dt: 02/02/2000
/////////////////////////////////////////////////////////////////////////////////////

str_popup  			popup

popup = message.powerobjectparm
If popup.data_row_count = 1 Then
	treatment_type = popup.items[1]
Elseif popup.data_row_count = 2 Then
	treatment_type = popup.items[1]
	past_treatment = f_string_to_boolean(popup.items[2])
Else
	log.log(this,"open","Invalid parameters",4)
	cb_cancel.event clicked()
	Return
End If

if trim(treatment_type) = "" then setnull(treatment_type)
If isnull(treatment_type) Then
	log.log(this,"open","treatment type can not be null",4)
	cb_cancel.event clicked()
	Return
End If

specialty_id = current_user.specialty_id
dw_drugs.specialty_id = current_user.common_list_id()

dw_drugs.mode = "PICK"

pb_down_sel.visible = false
pb_up_sel.visible = false
st_page_sel.visible = false

dw_drugs.object.description.width = dw_drugs.width - 150

dw_drugs.initialize(treatment_type)

if isnull(current_patient) then
	title = st_title.text
else
	title = current_patient.id_line()
end if

If trim(specialty_id) = "" Then Setnull(specialty_id)
If Isnull(specialty_id) Then
	st_specialty.visible = False
	st_specialty_title.visible = False
	st_category.visible = false
Else
	st_specialty.text = datalist.specialty_description(specialty_id)
End if

dw_selected_items.object.description.width = dw_selected_items.width - 55

dw_drugs.search_top_20()


end event

on w_trt_pick_drugs.create
int iCurrent
call super::create
this.st_search_title=create st_search_title
this.pb_down_sel=create pb_down_sel
this.pb_up_sel=create pb_up_sel
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
this.st_category=create st_category
this.st_top_20=create st_top_20
this.st_cpt_code=create st_cpt_code
this.st_search_status=create st_search_status
this.st_specialty=create st_specialty
this.st_specialty_title=create st_specialty_title
this.dw_selected_items=create dw_selected_items
this.st_title=create st_title
this.st_selected_items=create st_selected_items
this.st_description=create st_description
this.st_common_flag=create st_common_flag
this.dw_drugs=create dw_drugs
this.st_page_sel=create st_page_sel
this.cb_new_drug=create cb_new_drug
this.cb_cancel=create cb_cancel
this.cb_finished=create cb_finished
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_search_title
this.Control[iCurrent+2]=this.pb_down_sel
this.Control[iCurrent+3]=this.pb_up_sel
this.Control[iCurrent+4]=this.pb_up
this.Control[iCurrent+5]=this.pb_down
this.Control[iCurrent+6]=this.st_page
this.Control[iCurrent+7]=this.st_category
this.Control[iCurrent+8]=this.st_top_20
this.Control[iCurrent+9]=this.st_cpt_code
this.Control[iCurrent+10]=this.st_search_status
this.Control[iCurrent+11]=this.st_specialty
this.Control[iCurrent+12]=this.st_specialty_title
this.Control[iCurrent+13]=this.dw_selected_items
this.Control[iCurrent+14]=this.st_title
this.Control[iCurrent+15]=this.st_selected_items
this.Control[iCurrent+16]=this.st_description
this.Control[iCurrent+17]=this.st_common_flag
this.Control[iCurrent+18]=this.dw_drugs
this.Control[iCurrent+19]=this.st_page_sel
this.Control[iCurrent+20]=this.cb_new_drug
this.Control[iCurrent+21]=this.cb_cancel
this.Control[iCurrent+22]=this.cb_finished
end on

on w_trt_pick_drugs.destroy
call super::destroy
destroy(this.st_search_title)
destroy(this.pb_down_sel)
destroy(this.pb_up_sel)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
destroy(this.st_category)
destroy(this.st_top_20)
destroy(this.st_cpt_code)
destroy(this.st_search_status)
destroy(this.st_specialty)
destroy(this.st_specialty_title)
destroy(this.dw_selected_items)
destroy(this.st_title)
destroy(this.st_selected_items)
destroy(this.st_description)
destroy(this.st_common_flag)
destroy(this.dw_drugs)
destroy(this.st_page_sel)
destroy(this.cb_new_drug)
destroy(this.cb_cancel)
destroy(this.cb_finished)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_trt_pick_drugs
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_trt_pick_drugs
end type

type st_search_title from statictext within w_trt_pick_drugs
integer x = 1824
integer y = 380
integer width = 558
integer height = 88
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 33538240
string text = "Search Options"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_down_sel from u_picture_button within w_trt_pick_drugs
integer x = 2674
integer y = 996
integer width = 137
integer height = 116
integer taborder = 10
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_selected_items.current_page
li_last_page = dw_selected_items.last_page

dw_selected_items.set_page(li_page + 1, st_page_sel.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up_sel.enabled = true

end event

type pb_up_sel from u_picture_button within w_trt_pick_drugs
integer x = 2674
integer y = 868
integer width = 137
integer height = 116
integer taborder = 10
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
alignment htextalign = right!
end type

event clicked;call super::clicked;integer li_page

li_page = dw_selected_items.current_page

dw_selected_items.set_page(li_page - 1, st_page_sel.text)

if li_page <= 2 then enabled = false
pb_down_sel.enabled = true

end event

type pb_up from u_picture_button within w_trt_pick_drugs
integer x = 1435
integer y = 116
integer width = 137
integer height = 116
integer taborder = 20
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_drugs.current_page

dw_drugs.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_trt_pick_drugs
integer x = 1435
integer y = 240
integer width = 137
integer height = 116
integer taborder = 10
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_drugs.current_page
li_last_page = dw_drugs.last_page

dw_drugs.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type st_page from statictext within w_trt_pick_drugs
integer x = 1573
integer y = 116
integer width = 274
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99/99"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_category from statictext within w_trt_pick_drugs
integer x = 2510
integer y = 492
integer width = 347
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Category"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_drugs.search_category()

end event

type st_top_20 from statictext within w_trt_pick_drugs
integer x = 1440
integer y = 492
integer width = 347
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Short List"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if search_type = "TOP20" then
	if dw_drugs.search_description = "Personal List" then
		dw_drugs.search_top_20(false)
	else
		dw_drugs.search_top_20(true)
	end if
else
	if dw_drugs.search_description = "Personal List" then
		dw_drugs.search_top_20(true)
	else
		dw_drugs.search_top_20(false)
	end if
end if


end event

type st_cpt_code from statictext within w_trt_pick_drugs
integer x = 2153
integer y = 492
integer width = 347
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Generic"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_drugs.search_generic()

end event

type st_search_status from statictext within w_trt_pick_drugs
integer x = 1435
integer y = 628
integer width = 1422
integer height = 88
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_specialty from statictext within w_trt_pick_drugs
integer x = 2030
integer y = 228
integer width = 695
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_specialty_title from statictext within w_trt_pick_drugs
integer x = 1728
integer y = 228
integer width = 297
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Specialty:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_selected_items from u_dw_pick_list within w_trt_pick_drugs
integer x = 1504
integer y = 864
integer width = 1157
integer height = 596
integer taborder = 20
string dataobject = "dw_selected_drugs"
end type

event post_click;//////////////////////////////////////////////////////////////////////////////////////
//
// Description: Ask the user to choose an option based on treatment.
//
// Created By:Mark														Creation dt:
//
// Modified By:Sumathi Chinnasamy									Modified On:02/02/2000
/////////////////////////////////////////////////////////////////////////////////////

str_popup				popup
str_popup_return		popup_return
String					ls_drug_id
String					ls_treatment_mode,default_workplan
integer					i,j
long						ll_rows
datastore				lds_datastore
long ll_index

If clicked_row <= 0 Then Return

ll_index = object.attributes_index[clicked_row]

ls_treatment_mode = object.treatment_mode[clicked_row]

ls_drug_id = f_attribute_find_attribute(selected_attributes_list.attributes[ll_index], "drug_id")

If isnull(treatment_type) Then
	deleterow(lastrow)
Else 
	lds_datastore = Create datastore
	lds_datastore.dataobject = "dw_treatment_mode_pick"
	lds_datastore.Settransobject(SQLCA)
	ll_rows = lds_datastore.retrieve(treatment_type)
	If ll_rows > 0 Then // if any treatment modes
		default_workplan = "<Default Mode>"
		
		If Not isnull(default_workplan) Then
			i++
			popup.items[i] = default_workplan
		End if
		For j = 1 To ll_rows
			i++
			popup.items[i] = lds_datastore.object.treatment_mode[j]
		Next
		i++
		popup.items[i] = "<Remove>"
		popup.data_row_count = i
		popup.auto_singleton = True
		openwithparm(w_pop_pick, popup, parent)
		popup_return = message.powerobjectparm
		If popup_return.item_count <> 1 Then Return
	
		If popup_return.items[1] = "<Remove>" Then
			deleterow(lastrow)
		Else
			ls_treatment_mode = popup_return.items[1]
			if ls_treatment_mode = "<Default Mode>" then setnull(ls_treatment_mode)
			
			// Save it back to the datawindow
			object.treatment_mode[clicked_row] = ls_treatment_mode
			
			// Save it to the attributes structure
			f_attribute_add_attribute(selected_attributes_list.attributes[ll_index], "treatment_mode", ls_treatment_mode)
			
			// Ask the user if they want to make this the default
			if current_user.check_privilege("Edit Common Short Lists") then
				openwithparm(w_pop_yes_no, "Do you wish to make this treatment mode the default for this treatment?")
				popup_return = message.powerobjectparm
				if popup_return.item = "YES" then
					f_set_default_treatment_mode(treatment_type, ls_drug_id, ls_treatment_mode)
				end if
			end if
		End If
	Else
		deleterow(lastrow)
	End If
	Destroy lds_datastore
End If

last_page = 0
recalc_page(pb_up, pb_down, st_page_sel)

If rowcount() = 0 Then cb_finished.enabled = False
end event

type st_title from statictext within w_trt_pick_drugs
integer width = 2926
integer height = 108
integer textsize = -14
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Select prescription drug(s)"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_selected_items from statictext within w_trt_pick_drugs
integer x = 1504
integer y = 768
integer width = 1157
integer height = 92
integer textsize = -14
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Selected Items"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_description from statictext within w_trt_pick_drugs
integer x = 1797
integer y = 492
integer width = 347
integer height = 108
integer taborder = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Trade Name"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_drugs.search_description()

end event

type st_common_flag from statictext within w_trt_pick_drugs
integer x = 2574
integer y = 388
integer width = 270
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Specialty"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if common_flag = "Y" then
	common_flag = "N"
	text = "All"
	setnull(dw_drugs.specialty_id)
else
	common_flag = "Y"
	text = "Specialty"
	dw_drugs.specialty_id = specialty_id
end if

dw_drugs.search()

end event

type dw_drugs from u_dw_drug_list within w_trt_pick_drugs
integer x = 14
integer y = 108
integer width = 1408
integer height = 1592
integer taborder = 11
boolean bringtotop = true
boolean vscrollbar = true
boolean select_computed = false
end type

event selected(long selected_row);call super::selected;string ls_drug_id
str_drug_definition lstr_drug
integer li_sts

ls_drug_id = object.drug_id[selected_row]
li_sts = drugdb.get_drug_definition(ls_drug_id, lstr_drug)
if li_sts <= 0 then return
select_drug(ls_drug_id, lstr_drug.common_name)

end event

event drugs_loaded(string ps_description);search_type = current_search

st_top_20.backcolor = color_object
st_category.backcolor = color_object
st_cpt_code.backcolor = color_object
st_description.backcolor = color_object

st_search_status.text = ps_description

CHOOSE CASE current_search
	CASE "TOP20"
		st_top_20.backcolor = color_object_selected
		st_common_flag.visible = false
	CASE "CATEGORY"
		st_category.backcolor = color_object_selected
		st_common_flag.visible = true
	CASE "GENERIC"
		st_cpt_code.backcolor = color_object_selected
		st_common_flag.visible = true
	CASE "DESCRIPTION"
		st_description.backcolor = color_object_selected
		st_common_flag.visible = true
END CHOOSE

last_page = 0
set_page(1, pb_up, pb_down, st_page)


end event

type st_page_sel from statictext within w_trt_pick_drugs
integer x = 2537
integer y = 800
integer width = 274
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99/99"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_new_drug from commandbutton within w_trt_pick_drugs
integer x = 1879
integer y = 1472
integer width = 402
integer height = 88
integer taborder = 41
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Drug"
end type

event clicked;str_drug_definition lstr_drug
w_config_drug lw_config_drug

lstr_drug = f_new_drug(dw_drugs.drug_type)
if isnull(lstr_drug.drug_id) then return

openwithparm(lw_config_drug, lstr_drug.drug_id, "w_config_drug")

select_drug(lstr_drug.drug_id ,lstr_drug.common_name)


end event

type cb_cancel from commandbutton within w_trt_pick_drugs
integer x = 1454
integer y = 1604
integer width = 357
integer height = 108
integer taborder = 51
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

event clicked;str_attributes_list lstr_attributes_list

lstr_attributes_list.attributes_count = 0

Closewithreturn(parent, lstr_attributes_list)


end event

type cb_finished from commandbutton within w_trt_pick_drugs
integer x = 2501
integer y = 1604
integer width = 357
integer height = 108
integer taborder = 51
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Finished"
end type

event clicked;str_attributes_list lstr_attributes_list
long ll_index
long i
long ll_rows


ll_rows = dw_selected_items.rowcount()
lstr_attributes_list.attributes_count = 0

for i = 1 to ll_rows
	ll_index = dw_selected_items.object.attributes_index[i]
	if ll_index <= 0 or ll_index > selected_attributes_list.attributes_count then continue
	
	lstr_attributes_list.attributes_count += 1
	lstr_attributes_list.attributes[lstr_attributes_list.attributes_count] = selected_attributes_list.attributes[ll_index]
next

Closewithreturn(parent, lstr_attributes_list)


end event

