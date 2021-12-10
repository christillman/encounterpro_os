$PBExportHeader$w_svc_imm_record.srw
forward
global type w_svc_imm_record from w_window_base
end type
type cb_be_back from commandbutton within w_svc_imm_record
end type
type cb_finished from commandbutton within w_svc_imm_record
end type
type pb_down from u_picture_button within w_svc_imm_record
end type
type pb_up from u_picture_button within w_svc_imm_record
end type
type dw_vaccine_history from u_dw_pick_list within w_svc_imm_record
end type
type cb_delete from commandbutton within w_svc_imm_record
end type
type cb_new from commandbutton within w_svc_imm_record
end type
type st_page from statictext within w_svc_imm_record
end type
type st_title from statictext within w_svc_imm_record
end type
type st_legend from statictext within w_svc_imm_record
end type
type st_legend2 from statictext within w_svc_imm_record
end type
end forward

global type w_svc_imm_record from w_window_base
boolean controlmenu = false
windowtype windowtype = response!
string button_type = "COMMAND"
integer max_buttons = 3
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
cb_be_back cb_be_back
cb_finished cb_finished
pb_down pb_down
pb_up pb_up
dw_vaccine_history dw_vaccine_history
cb_delete cb_delete
cb_new cb_new
st_page st_page
st_title st_title
st_legend st_legend
st_legend2 st_legend2
end type
global w_svc_imm_record w_svc_imm_record

type variables
u_component_service service

end variables

forward prototypes
public function integer refresh ()
public function integer modify_treatment (long pl_row, string ps_property, string ps_value)
end prototypes

public function integer refresh ();integer li_current_page
long ll_rowcount
long i
long ll_editable

li_current_page = dw_vaccine_history.current_page
if isnull(li_current_page) or li_current_page <= 0 then li_current_page = 1

dw_vaccine_history.setredraw(false)

dw_vaccine_history.settransobject(sqlca)
ll_rowcount = dw_vaccine_history.retrieve(current_patient.cpr_id)
if ll_rowcount < 0 then return -1

cb_delete.enabled = false

st_legend.visible = false
st_legend2.visible = false
for i = 1 to ll_rowcount
	dw_vaccine_history.object.vaccine_number[i] = i
	ll_editable = dw_vaccine_history.object.editable[i]
	if ll_editable > 0 then
		st_legend.visible = true
		st_legend2.visible = true
	end if
next

dw_vaccine_history.set_page(li_current_page, pb_up, pb_down, st_page)

dw_vaccine_history.setredraw(true)

return 1


end function

public function integer modify_treatment (long pl_row, string ps_property, string ps_value);long ll_treatment_id
datetime ldt_now
long ll_null
string ls_progress_key

setnull(ll_null)

ll_treatment_id = dw_vaccine_history.object.treatment_id[pl_row]
ldt_now = datetime(today(), now())

if pos(ps_property, " ") > 0 then
	ls_progress_key = "Property"
else
	ls_progress_key = "Modify"
end if

sqlca.sp_set_treatment_progress(service.cpr_id, &
										ll_treatment_id, &
										service.encounter_id, &
										ls_progress_key, &
										ps_property, &
										ps_value, &
										ldt_now, &
										ll_null, & 
										ll_null, &
										ll_null, &
										current_user.user_id, &
										current_scribe.user_id)
if not tf_check() then return -1

return 1


end function

event open;call super::open;long ll_menu_id
integer li_sts
datawindowchild ldw_makers, ldw_locations, ldw_sites

service = message.powerobjectparm

title = current_patient.id_line()

cb_delete.enabled = false

if not isnull(current_patient.open_encounter) and not current_patient.display_only then
	cb_new.enabled = true
else
	cb_new.enabled = false
end if

// Don't offer the "I'll Be Back" option for manual services
max_buttons = 3
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 4
end if


ll_menu_id = long(service.get_attribute("menu_id"))
paint_menu(ll_menu_id)

/////////////////////////////////////////////////////////
// Resize
//

st_title.width = width
dw_vaccine_history.width = width
dw_vaccine_history.height = height - dw_vaccine_history.y - 450

st_legend.y = dw_vaccine_history.y + dw_vaccine_history.height + 20
st_legend2.y = st_legend.y

cb_new.x = (width / 2) - cb_new.width - 20
cb_new.y = st_legend.y
cb_delete.x = (width / 2) + 20
cb_delete.y = st_legend.y

pb_up.x = width - 600
pb_up.y = st_legend.y
pb_down.x = pb_up.x + pb_up.width + 20
pb_down.y = st_legend.y
st_page.x = pb_down.x + pb_down.width + 20
st_page.y = st_legend.y



cb_finished.x = width - cb_finished.width - 50
cb_finished.y = height - cb_finished.height - 125
cb_be_back.x = cb_finished.x - cb_be_back.width - 50
cb_be_back.y = cb_finished.y

dw_vaccine_history.object.treatment_description.width = long((dw_vaccine_history.width - 1050) * 0.3226 )
dw_vaccine_history.object.location_description.width = long((dw_vaccine_history.width - 1050) * 0.2258 )
dw_vaccine_history.object.maker_name.width = long((dw_vaccine_history.width - 1050) * 0.2258 )
dw_vaccine_history.object.compute_where.width = long((dw_vaccine_history.width - 1050) * 0.2258 )

/////////////////////////////////////////////////////////


refresh()

dw_vaccine_history.set_page(1, pb_up, pb_down, st_page)

cb_finished.setfocus()


end event

on w_svc_imm_record.create
int iCurrent
call super::create
this.cb_be_back=create cb_be_back
this.cb_finished=create cb_finished
this.pb_down=create pb_down
this.pb_up=create pb_up
this.dw_vaccine_history=create dw_vaccine_history
this.cb_delete=create cb_delete
this.cb_new=create cb_new
this.st_page=create st_page
this.st_title=create st_title
this.st_legend=create st_legend
this.st_legend2=create st_legend2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_be_back
this.Control[iCurrent+2]=this.cb_finished
this.Control[iCurrent+3]=this.pb_down
this.Control[iCurrent+4]=this.pb_up
this.Control[iCurrent+5]=this.dw_vaccine_history
this.Control[iCurrent+6]=this.cb_delete
this.Control[iCurrent+7]=this.cb_new
this.Control[iCurrent+8]=this.st_page
this.Control[iCurrent+9]=this.st_title
this.Control[iCurrent+10]=this.st_legend
this.Control[iCurrent+11]=this.st_legend2
end on

on w_svc_imm_record.destroy
call super::destroy
destroy(this.cb_be_back)
destroy(this.cb_finished)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.dw_vaccine_history)
destroy(this.cb_delete)
destroy(this.cb_new)
destroy(this.st_page)
destroy(this.st_title)
destroy(this.st_legend)
destroy(this.st_legend2)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_svc_imm_record
integer x = 2830
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_imm_record
integer width = 942
end type

type cb_be_back from commandbutton within w_svc_imm_record
integer x = 1961
integer y = 1608
integer width = 443
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type cb_finished from commandbutton within w_svc_imm_record
integer x = 2427
integer y = 1608
integer width = 443
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;str_popup_return popup_return
integer li_sts

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type pb_down from u_picture_button within w_svc_imm_record
integer x = 2112
integer y = 1480
integer width = 137
integer height = 116
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_vaccine_history.current_page
li_last_page = dw_vaccine_history.last_page

dw_vaccine_history.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true


end event

type pb_up from u_picture_button within w_svc_imm_record
integer x = 1961
integer y = 1480
integer width = 137
integer height = 116
integer taborder = 20
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_vaccine_history.current_page

dw_vaccine_history.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type dw_vaccine_history from u_dw_pick_list within w_svc_imm_record
integer y = 148
integer width = 2889
integer height = 1320
integer taborder = 10
string dataobject = "dw_vaccine_history_grid"
boolean vscrollbar = true
boolean livescroll = false
borderstyle borderstyle = stylelowered!
end type

event selected;call super::selected;
if not isnull(current_patient.open_encounter) then cb_delete.enabled = true

end event

event unselected;call super::unselected;cb_delete.enabled = false

end event

event post_click;call super::post_click;str_popup popup
str_popup_return popup_return
string ls_vaccine_id
integer li_sts
integer li_editable
string ls_vaccine_office_id
string ls_place_administered
string ls_description
//integer i
//str_popup popup
//str_popup_return popup_return
//string lsa_user_id[]

if clicked_row <= 0 then return

li_editable = object.editable[clicked_row]
if li_editable = 0 then return

if lastcolumnname = "maker_name" then
	ls_vaccine_id = object.drug_id[clicked_row]
	
	popup.dataobject = "dw_maker_pick"
	popup.datacolumn = 2
	popup.displaycolumn = 1
	popup.argument_count = 1
	popup.argument[1] = ls_vaccine_id
	popup.add_blank_row = true
	popup.blank_text = "<None>"
	
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	
	if popup_return.item_count <> 1 then return
	
	li_sts = modify_treatment(clicked_row, "maker_id", popup_return.items[1])
	if li_sts <= 0 then return
	
	object.maker_id[clicked_row] = popup_return.items[1]
	object.maker_name[clicked_row] = popup_return.descriptions[1]
	object.selected_flag[clicked_row] = 1
end if



if lastcolumnname = "location_description" then
	popup.dataobject = "dw_location_pick"
	popup.datacolumn = 1
	popup.displaycolumn = 2
	popup.argument_count = 1
	popup.argument[1] = "!IMMUN"
	popup.add_blank_row = true
	popup.blank_text = "<None>"
	
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	
	if popup_return.item_count <> 1 then return
	
	li_sts = modify_treatment(clicked_row, "location", popup_return.items[1])
	if li_sts <= 0 then return
	
	object.location[clicked_row] = popup_return.items[1]
	object.location_description[clicked_row] = popup_return.descriptions[1]
	object.selected_flag[clicked_row] = 1
end if


if lastcolumnname = "compute_where" then
	popup.dataobject = "dw_pick_office_location"
	popup.datacolumn = 1
	popup.displaycolumn = 2
	popup.add_blank_row = true
	popup.blank_text = "<Other Location>"
	
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	
	if popup_return.item_count <> 1 then return
	
	if popup_return.items[1] = "" then
		setnull(ls_vaccine_office_id)
		popup.displaycolumn = 0
		popup.argument_count = 1
		popup.argument[1] = "New Vaccine Other Location"
		popup.title = "Enter location where vaccine was administered"
		popup.item = ""
		popup.multiselect = true
		openwithparm(w_pop_prompt_string, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then
			ls_description = "<Other Location>"
		elseif isnull(popup_return.items[1]) or trim(popup_return.items[1]) = "" then
			ls_description = "<Other Location>"
		else
			ls_place_administered = popup_return.items[1]
			ls_description = ls_place_administered
		end if
	else
		ls_vaccine_office_id = popup_return.items[1]
		ls_place_administered = popup_return.descriptions[1]
		ls_description = ls_place_administered
	end if
	
	li_sts = modify_treatment(clicked_row, "office_id", ls_vaccine_office_id)
	if li_sts <= 0 then return

	li_sts = modify_treatment(clicked_row, "Place Administered", ls_place_administered)
	if li_sts <= 0 then return
	
	object.office_id[clicked_row] = ls_vaccine_office_id
	object.place_administered[clicked_row] = ls_place_administered
	object.c_office_description[clicked_row] = datalist.office_description(ls_vaccine_office_id)
	object.selected_flag[clicked_row] = 1
end if

if lastcolumnname = "lot_number" then
	popup.displaycolumn = 0
	popup.argument_count = 1
	popup.argument[1] = "Past Vaccine Lot Number"
	popup.title = "Enter vaccine lot number"
	popup.item = ""
	popup.multiselect = true
	openwithparm(w_pop_prompt_string, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return


	li_sts = modify_treatment(clicked_row, "lot_number", popup_return.items[1])
	if li_sts <= 0 then return
	
	object.lot_number[clicked_row] = popup_return.items[1]
	object.selected_flag[clicked_row] = 1
end if










end event

type cb_delete from commandbutton within w_svc_imm_record
integer x = 1481
integer y = 1480
integer width = 443
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Delete"
end type

event clicked;Long	 	ll_row,ll_treatment_id
Integer 	li_sts
String 	ls_text,ls_treatment_type
datetime ldt_begin_date
integer li_current_page

u_component_treatment 	luo_treatment
str_popup_return 			popup_return

ll_row = dw_vaccine_history.get_selected_row()
if ll_row <= 0 then return

ll_treatment_id = dw_vaccine_history.object.treatment_id[ll_row]
ls_treatment_type = dw_vaccine_history.object.treatment_type[ll_row]
ldt_begin_date = dw_vaccine_history.object.begin_date[ll_row]

// If we are cancelling the treatment, then check for an associated workplan and cancel it
luo_treatment = f_get_treatment_component(ls_treatment_type)
If Not Isnull(luo_treatment) Then 
	luo_treatment.treatment_type = ls_treatment_type
	luo_treatment.treatment_id = ll_treatment_id
	luo_treatment.begin_date = ldt_begin_date
	luo_treatment.close("CANCELLED")
End If

component_manager.destroy_component(luo_treatment)

refresh()


end event

type cb_new from commandbutton within w_svc_imm_record
integer x = 1001
integer y = 1480
integer width = 443
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "New"
end type

event clicked;integer li_current_page
str_popup popup
str_attributes lstr_attributes
long ll_row
integer li_sts
string ls_treatment_type
long ll_count
datetime ldt_begin_date
long i
string ls_description
long ll_null

setnull(ll_null)

openwithparm(w_new_past_immunization, service)

refresh()

end event

type st_page from statictext within w_svc_imm_record
integer x = 2254
integer y = 1480
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
boolean focusrectangle = false
end type

type st_title from statictext within w_svc_imm_record
integer width = 2921
integer height = 160
integer textsize = -22
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Immunization Record"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_legend from statictext within w_svc_imm_record
integer x = 14
integer y = 1488
integer width = 293
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 25231232
string text = "New Record"
boolean focusrectangle = false
end type

type st_legend2 from statictext within w_svc_imm_record
integer x = 315
integer y = 1488
integer width = 494
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = " = Details are editable"
boolean focusrectangle = false
end type

