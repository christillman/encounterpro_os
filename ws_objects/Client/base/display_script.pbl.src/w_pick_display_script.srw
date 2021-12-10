$PBExportHeader$w_pick_display_script.srw
forward
global type w_pick_display_script from w_window_base
end type
type st_search_title from statictext within w_pick_display_script
end type
type pb_up from u_picture_button within w_pick_display_script
end type
type pb_down from u_picture_button within w_pick_display_script
end type
type st_page from statictext within w_pick_display_script
end type
type st_top_20 from statictext within w_pick_display_script
end type
type st_search_status from statictext within w_pick_display_script
end type
type st_context_general from statictext within w_pick_display_script
end type
type st_context_object_title from statictext within w_pick_display_script
end type
type st_title from statictext within w_pick_display_script
end type
type st_display_script from statictext within w_pick_display_script
end type
type dw_display_script_list from u_dw_display_script_list within w_pick_display_script
end type
type cb_new_script from commandbutton within w_pick_display_script
end type
type st_context_patient from statictext within w_pick_display_script
end type
type st_context_encounter from statictext within w_pick_display_script
end type
type st_context_assessment from statictext within w_pick_display_script
end type
type st_context_treatment from statictext within w_pick_display_script
end type
type st_context_observation from statictext within w_pick_display_script
end type
type st_context_attachment from statictext within w_pick_display_script
end type
type cb_ok from commandbutton within w_pick_display_script
end type
type cb_cancel from commandbutton within w_pick_display_script
end type
type st_parent_config_object from statictext within w_pick_display_script
end type
type st_parent_config_object_title from statictext within w_pick_display_script
end type
type st_show_parent_title from statictext within w_pick_display_script
end type
type st_show_parent from statictext within w_pick_display_script
end type
end forward

global type w_pick_display_script from w_window_base
integer height = 1836
boolean controlmenu = false
windowtype windowtype = response!
st_search_title st_search_title
pb_up pb_up
pb_down pb_down
st_page st_page
st_top_20 st_top_20
st_search_status st_search_status
st_context_general st_context_general
st_context_object_title st_context_object_title
st_title st_title
st_display_script st_display_script
dw_display_script_list dw_display_script_list
cb_new_script cb_new_script
st_context_patient st_context_patient
st_context_encounter st_context_encounter
st_context_assessment st_context_assessment
st_context_treatment st_context_treatment
st_context_observation st_context_observation
st_context_attachment st_context_attachment
cb_ok cb_ok
cb_cancel cb_cancel
st_parent_config_object st_parent_config_object
st_parent_config_object_title st_parent_config_object_title
st_show_parent_title st_show_parent_title
st_show_parent st_show_parent
end type
global w_pick_display_script w_pick_display_script

type variables
String search_type


end variables

forward prototypes
public function long check_parent_config_object (long pl_display_script_id)
public function boolean context_warning (long pl_textcolor, string ps_text)
end prototypes

public function long check_parent_config_object (long pl_display_script_id);string ls_parent_config_object_id
str_popup_return popup_return
string ls_message
string ls_new_id
string ls_description
long ll_new_display_script_id

// If we don't have a config object then don't worry about checking it
if isnull(dw_display_script_list.parent_config_object_id) then return pl_display_script_id

SELECT CAST(parent_config_object_id AS varchar(38))
INTO :ls_parent_config_object_id
FROM c_Display_Script
WHERE display_script_id = :pl_display_script_id;
if not tf_check() then return -1

if f_guid_equal(ls_parent_config_object_id, dw_display_script_list.parent_config_object_id) then return pl_display_script_id

// Prompt the user that we're going to make a deep copy
ls_message = "The display script you have selected does not belong to the config object that you're working with ("
ls_message += st_parent_config_object.text + ")."
ls_message += "  A deep copy of the selected display script will now be made and associated with the config object.  Do you wish to continue?"
openwithparm(w_pop_yes_no, ls_message)
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return 0

// Set the new ID to null so the copy will generate another one
setnull(ls_new_id)

// Set the new description to null so the copy will preserve the original description
setnull(ls_description)

ll_new_display_script_id = sqlca.sp_local_copy_display_script(pl_display_script_id, ls_new_id, ls_description, dw_display_script_list.parent_config_object_id)
if not tf_check() then return -1

return ll_new_display_script_id

end function

public function boolean context_warning (long pl_textcolor, string ps_text);string ls_context_warning
str_popup_return popup_return

if pl_textcolor = color_text_error then
	ls_context_warning = "This context is not compatible with the context of the config object you are working with.  Are you sure you wish to select a script from this context?"
	openwithparm(w_pop_yes_no, ls_context_warning)
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return false
end if

return true

end function

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
string ls_null
str_popup popup
u_ds_data luo_data
long ll_count
long i
string ls_compatible_context_object
boolean lb_same

setnull(ls_null)

popup = message.powerobjectparm

if popup.data_row_count >= 1 then
	dw_display_script_list.context_object = popup.items[1]
else
	dw_display_script_list.context_object = "Patient"
end if

if popup.data_row_count >= 2 then
	dw_display_script_list.mode = popup.items[2]
else
	dw_display_script_list.mode = "PICK"
end if

if popup.data_row_count >= 3 then
	dw_display_script_list.script_type = popup.items[3]
else
	dw_display_script_list.script_type = "RTF"
end if

if popup.data_row_count >= 4 then
	dw_display_script_list.parent_config_object_id = popup.items[4]
else
	setnull(dw_display_script_list.parent_config_object_id)
end if


if isnull(dw_display_script_list.context_object) or trim(dw_display_script_list.context_object) = "" then
	dw_display_script_list.context_object = "Patient"
	st_context_patient.backcolor = color_object_selected
else
	st_context_general.textcolor = color_text_error
	st_context_patient.textcolor = color_text_error
	st_context_encounter.textcolor = color_text_error
	st_context_assessment.textcolor = color_text_error
	st_context_treatment.textcolor = color_text_error
	st_context_observation.textcolor = color_text_error
	st_context_attachment.textcolor = color_text_error

	luo_data = CREATE u_ds_data
	luo_data.set_dataobject("dw_v_Compatible_Context_Object")
	ll_count = luo_data.retrieve(dw_display_script_list.context_object)
	
	for i = 1 to ll_count
		ls_compatible_context_object = luo_data.object.compatible_context_object[i]
		if ls_compatible_context_object = dw_display_script_list.context_object then
			lb_same = true
		else
			lb_same = false
		end if
		CHOOSE CASE wordcap(lower(ls_compatible_context_object))
			CASE "General"
				if lb_same then st_context_general.backcolor = color_object_selected
				st_context_general.textcolor = color_text_normal
			CASE "Patient"
				if lb_same then st_context_patient.backcolor = color_object_selected
				st_context_patient.textcolor = color_text_normal
			CASE "Encounter"
				if lb_same then st_context_encounter.backcolor = color_object_selected
				st_context_encounter.textcolor = color_text_normal
			CASE "Assessment"
				if lb_same then st_context_assessment.backcolor = color_object_selected
				st_context_assessment.textcolor = color_text_normal
			CASE "Treatment"
				if lb_same then st_context_treatment.backcolor = color_object_selected
				st_context_treatment.textcolor = color_text_normal
			CASE "Observation"
				if lb_same then st_context_observation.backcolor = color_object_selected
				st_context_observation.textcolor = color_text_normal
			CASE "Attachment"
				if lb_same then st_context_attachment.backcolor = color_object_selected
				st_context_attachment.textcolor = color_text_normal
		END CHOOSE
	next
	
	
	DESTROY luo_data
end if


dw_display_script_list.initialize("DISPLAY_SCRIPT")

if isnull(current_patient) then
	title = st_title.text
else
	title = current_patient.id_line()
end if

if dw_display_script_list.mode = "PICK" then
	cb_ok.enabled = false
	cb_cancel.visible = true
else
	cb_ok.enabled = true
	cb_cancel.visible = false
end if

dw_display_script_list.search_top_20()
if dw_display_script_list.rowcount() = 0 then
	dw_display_script_list.search_description(ls_null)
end if


end event

on w_pick_display_script.create
int iCurrent
call super::create
this.st_search_title=create st_search_title
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
this.st_top_20=create st_top_20
this.st_search_status=create st_search_status
this.st_context_general=create st_context_general
this.st_context_object_title=create st_context_object_title
this.st_title=create st_title
this.st_display_script=create st_display_script
this.dw_display_script_list=create dw_display_script_list
this.cb_new_script=create cb_new_script
this.st_context_patient=create st_context_patient
this.st_context_encounter=create st_context_encounter
this.st_context_assessment=create st_context_assessment
this.st_context_treatment=create st_context_treatment
this.st_context_observation=create st_context_observation
this.st_context_attachment=create st_context_attachment
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.st_parent_config_object=create st_parent_config_object
this.st_parent_config_object_title=create st_parent_config_object_title
this.st_show_parent_title=create st_show_parent_title
this.st_show_parent=create st_show_parent
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_search_title
this.Control[iCurrent+2]=this.pb_up
this.Control[iCurrent+3]=this.pb_down
this.Control[iCurrent+4]=this.st_page
this.Control[iCurrent+5]=this.st_top_20
this.Control[iCurrent+6]=this.st_search_status
this.Control[iCurrent+7]=this.st_context_general
this.Control[iCurrent+8]=this.st_context_object_title
this.Control[iCurrent+9]=this.st_title
this.Control[iCurrent+10]=this.st_display_script
this.Control[iCurrent+11]=this.dw_display_script_list
this.Control[iCurrent+12]=this.cb_new_script
this.Control[iCurrent+13]=this.st_context_patient
this.Control[iCurrent+14]=this.st_context_encounter
this.Control[iCurrent+15]=this.st_context_assessment
this.Control[iCurrent+16]=this.st_context_treatment
this.Control[iCurrent+17]=this.st_context_observation
this.Control[iCurrent+18]=this.st_context_attachment
this.Control[iCurrent+19]=this.cb_ok
this.Control[iCurrent+20]=this.cb_cancel
this.Control[iCurrent+21]=this.st_parent_config_object
this.Control[iCurrent+22]=this.st_parent_config_object_title
this.Control[iCurrent+23]=this.st_show_parent_title
this.Control[iCurrent+24]=this.st_show_parent
end on

on w_pick_display_script.destroy
call super::destroy
destroy(this.st_search_title)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
destroy(this.st_top_20)
destroy(this.st_search_status)
destroy(this.st_context_general)
destroy(this.st_context_object_title)
destroy(this.st_title)
destroy(this.st_display_script)
destroy(this.dw_display_script_list)
destroy(this.cb_new_script)
destroy(this.st_context_patient)
destroy(this.st_context_encounter)
destroy(this.st_context_assessment)
destroy(this.st_context_treatment)
destroy(this.st_context_observation)
destroy(this.st_context_attachment)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.st_parent_config_object)
destroy(this.st_parent_config_object_title)
destroy(this.st_show_parent_title)
destroy(this.st_show_parent)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_pick_display_script
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pick_display_script
end type

type st_search_title from statictext within w_pick_display_script
integer x = 1888
integer y = 788
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
long backcolor = 7191717
string text = "Search Options"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_up from u_picture_button within w_pick_display_script
integer x = 1463
integer y = 120
integer width = 137
integer height = 116
integer taborder = 20
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_display_script_list.current_page

dw_display_script_list.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_pick_display_script
integer x = 1463
integer y = 244
integer width = 137
integer height = 116
integer taborder = 10
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_display_script_list.current_page
li_last_page = dw_display_script_list.last_page

dw_display_script_list.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type st_page from statictext within w_pick_display_script
integer x = 1600
integer y = 120
integer width = 274
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Page 99/99"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_top_20 from statictext within w_pick_display_script
integer x = 1499
integer y = 900
integer width = 645
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
	if dw_display_script_list.search_description = "Personal List" then
		dw_display_script_list.search_top_20(false)
	else
		dw_display_script_list.search_top_20(true)
	end if
else
	if dw_display_script_list.search_description = "Personal List" then
		dw_display_script_list.search_top_20(true)
	else
		dw_display_script_list.search_top_20(false)
	end if
end if


end event

type st_search_status from statictext within w_pick_display_script
integer x = 1495
integer y = 1036
integer width = 1349
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

type st_context_general from statictext within w_pick_display_script
integer x = 1929
integer y = 284
integer width = 475
integer height = 108
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "General"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if not context_warning(textcolor, text) then return

st_context_assessment.backcolor = color_object
st_context_attachment.backcolor = color_object
st_context_encounter.backcolor = color_object
st_context_general.backcolor = color_object
st_context_observation.backcolor = color_object
st_context_patient.backcolor = color_object
st_context_treatment.backcolor = color_object

dw_display_script_list.context_object = "General"
backcolor = color_object_selected

dw_display_script_list.search()

end event

type st_context_object_title from statictext within w_pick_display_script
integer x = 1819
integer y = 180
integer width = 695
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
string text = "Context Object"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title from statictext within w_pick_display_script
integer width = 2926
integer height = 108
integer textsize = -14
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Select Display Script"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_display_script from statictext within w_pick_display_script
integer x = 2203
integer y = 900
integer width = 640
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
string text = "Display Script Name"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_display_script_list.search_description()

end event

type dw_display_script_list from u_dw_display_script_list within w_pick_display_script
integer x = 14
integer y = 108
integer width = 1440
integer height = 1592
integer taborder = 90
boolean vscrollbar = true
end type

event display_scripts_loaded;call super::display_scripts_loaded;search_type = current_search

st_top_20.backcolor = color_object
st_display_script.backcolor = color_object

st_search_status.text = ps_description

CHOOSE CASE current_search
	CASE "TOP20"
		st_top_20.backcolor = color_object_selected
	CASE "DISPLAY_SCRIPT"
		st_display_script.backcolor = color_object_selected
END CHOOSE

if isnull(parent_config_object_id) then
	st_parent_config_object.visible = false
	st_parent_config_object_title.visible = false
	st_show_parent.visible = false
	st_show_parent_title.visible = false
else
	st_parent_config_object.text = sqlca.fn_config_object_description(parent_config_object_id)
	st_parent_config_object.visible = true
	st_parent_config_object_title.visible = true
	st_show_parent.visible = true
	st_show_parent_title.visible = true
end if

if show_all then
	st_show_parent.text = "All Display Scripts"
else
	st_show_parent.text = "Parent Scripts Only"
end if

last_page = 0
set_page(1, pb_up, pb_down, st_page)


end event

event selected;call super::selected;if dw_display_script_list.mode = "PICK" then
	cb_ok.enabled = true
end if

end event

event unselected;call super::unselected;if dw_display_script_list.mode = "PICK" then
	cb_ok.enabled = false
end if

end event

type cb_new_script from commandbutton within w_pick_display_script
integer x = 1490
integer y = 1580
integer width = 526
integer height = 112
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Display Script"
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_top_20_code
string ls_null
long ll_display_script_id
integer li_sts
w_display_script_edit lw_display_script_edit

popup.title = "Enter the title of the new display script"
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ll_display_script_id = sqlca.sp_new_display_script(dw_display_script_list.context_object, &
																	popup_return.items[1], &
																	popup_return.items[1], &
																	current_user.user_id, &
																	dw_display_script_list.script_type, &
																	dw_display_script_list.parent_config_object_id)
if not tf_check() then return -1
if isnull(ll_display_script_id) or ll_display_script_id = 0 then return

openwithparm(lw_display_script_edit, ll_display_script_id, "w_display_script_edit", parent)

if dw_display_script_list.current_search = "TOP20" then
	openwithparm(w_pop_yes_no, "Do you want to add the new display script to your short list?")
	popup_return = message.powerobjectparm
	if popup_return.item = "YES" then
		ls_top_20_code = dw_display_script_list.pick_top_20_code()
		if not isnull(ls_top_20_code) then
			li_sts = tf_add_common_top_20(ls_top_20_code, ls_null, ls_null, ls_null, ll_display_script_id)
			dw_display_script_list.search()
		end if
	end if
end if


if dw_display_script_list.mode = "PICK" then
	Closewithreturn(parent, ll_display_script_id)
end if


end event

type st_context_patient from statictext within w_pick_display_script
integer x = 1669
integer y = 404
integer width = 475
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Patient"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if not context_warning(textcolor, text) then return

st_context_assessment.backcolor = color_object
st_context_attachment.backcolor = color_object
st_context_encounter.backcolor = color_object
st_context_general.backcolor = color_object
st_context_observation.backcolor = color_object
st_context_patient.backcolor = color_object
st_context_treatment.backcolor = color_object

dw_display_script_list.context_object = "Patient"
backcolor = color_object_selected

dw_display_script_list.search()

end event

type st_context_encounter from statictext within w_pick_display_script
integer x = 1669
integer y = 520
integer width = 475
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Encounter"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if not context_warning(textcolor, text) then return

st_context_assessment.backcolor = color_object
st_context_attachment.backcolor = color_object
st_context_encounter.backcolor = color_object
st_context_general.backcolor = color_object
st_context_observation.backcolor = color_object
st_context_patient.backcolor = color_object
st_context_treatment.backcolor = color_object

dw_display_script_list.context_object = "Encounter"
backcolor = color_object_selected

dw_display_script_list.search()

end event

type st_context_assessment from statictext within w_pick_display_script
integer x = 1669
integer y = 636
integer width = 475
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Assessment"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if not context_warning(textcolor, text) then return

st_context_assessment.backcolor = color_object
st_context_attachment.backcolor = color_object
st_context_encounter.backcolor = color_object
st_context_general.backcolor = color_object
st_context_observation.backcolor = color_object
st_context_patient.backcolor = color_object
st_context_treatment.backcolor = color_object

dw_display_script_list.context_object = "Assessment"
backcolor = color_object_selected

dw_display_script_list.search()

end event

type st_context_treatment from statictext within w_pick_display_script
integer x = 2203
integer y = 404
integer width = 475
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Treatment"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if not context_warning(textcolor, text) then return

st_context_assessment.backcolor = color_object
st_context_attachment.backcolor = color_object
st_context_encounter.backcolor = color_object
st_context_general.backcolor = color_object
st_context_observation.backcolor = color_object
st_context_patient.backcolor = color_object
st_context_treatment.backcolor = color_object

dw_display_script_list.context_object = "Treatment"
backcolor = color_object_selected

dw_display_script_list.search()

end event

type st_context_observation from statictext within w_pick_display_script
integer x = 2203
integer y = 520
integer width = 475
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Observation"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if not context_warning(textcolor, text) then return

st_context_assessment.backcolor = color_object
st_context_attachment.backcolor = color_object
st_context_encounter.backcolor = color_object
st_context_general.backcolor = color_object
st_context_observation.backcolor = color_object
st_context_patient.backcolor = color_object
st_context_treatment.backcolor = color_object

dw_display_script_list.context_object = "Observation"
backcolor = color_object_selected

dw_display_script_list.search()

end event

type st_context_attachment from statictext within w_pick_display_script
integer x = 2203
integer y = 636
integer width = 475
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Attachment"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if not context_warning(textcolor, text) then return

st_context_assessment.backcolor = color_object
st_context_attachment.backcolor = color_object
st_context_encounter.backcolor = color_object
st_context_general.backcolor = color_object
st_context_observation.backcolor = color_object
st_context_patient.backcolor = color_object
st_context_treatment.backcolor = color_object

dw_display_script_list.context_object = "Attachment"
backcolor = color_object_selected

dw_display_script_list.search()

end event

type cb_ok from commandbutton within w_pick_display_script
integer x = 2441
integer y = 1580
integer width = 402
integer height = 112
integer taborder = 100
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

event clicked;long ll_display_script_id
long ll_row
long ll_new_display_script_id

if dw_display_script_list.mode = "EDIT" then
	setnull(ll_display_script_id)	
	Closewithreturn(parent, ll_display_script_id)
	return
end if

ll_row = dw_display_script_list.get_selected_row()
if ll_row <= 0 then return

ll_display_script_id = dw_display_script_list.object.display_script_id[ll_row]

ll_new_display_script_id = check_parent_config_object(ll_display_script_id)
if ll_new_display_script_id > 0 then
	Closewithreturn(parent, ll_display_script_id)
end if


end event

type cb_cancel from commandbutton within w_pick_display_script
integer x = 2043
integer y = 1580
integer width = 370
integer height = 112
integer taborder = 110
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

event clicked;long ll_display_script_id

setnull(ll_display_script_id)

Closewithreturn(parent, ll_display_script_id)


end event

type st_parent_config_object from statictext within w_pick_display_script
integer x = 1733
integer y = 1204
integer width = 1061
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_parent_config_object_title from statictext within w_pick_display_script
integer x = 1490
integer y = 1212
integer width = 233
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Parent:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_show_parent_title from statictext within w_pick_display_script
integer x = 1490
integer y = 1304
integer width = 233
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Show:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_show_parent from statictext within w_pick_display_script
integer x = 1733
integer y = 1300
integer width = 571
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Parent Scripts Only"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if dw_display_script_list.show_all then
	 dw_display_script_list.show_all = false
else
	 dw_display_script_list.show_all = true
end if

dw_display_script_list.search()

end event

