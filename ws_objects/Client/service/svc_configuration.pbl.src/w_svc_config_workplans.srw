$PBExportHeader$w_svc_config_workplans.srw
forward
global type w_svc_config_workplans from w_window_base
end type
type st_search_title from statictext within w_svc_config_workplans
end type
type st_workplan_type_title from statictext within w_svc_config_workplans
end type
type st_workplan_type from statictext within w_svc_config_workplans
end type
type pb_up from u_picture_button within w_svc_config_workplans
end type
type pb_down from u_picture_button within w_svc_config_workplans
end type
type st_page from statictext within w_svc_config_workplans
end type
type st_category from statictext within w_svc_config_workplans
end type
type st_top_20 from statictext within w_svc_config_workplans
end type
type st_search_status from statictext within w_svc_config_workplans
end type
type st_specialty from statictext within w_svc_config_workplans
end type
type st_specialty_title from statictext within w_svc_config_workplans
end type
type pb_done from u_picture_button within w_svc_config_workplans
end type
type st_title from statictext within w_svc_config_workplans
end type
type st_description from statictext within w_svc_config_workplans
end type
type st_common_flag from statictext within w_svc_config_workplans
end type
type cb_new_observation from commandbutton within w_svc_config_workplans
end type
type st_in_out from statictext within w_svc_config_workplans
end type
type st_treatment_type from statictext within w_svc_config_workplans
end type
type st_treatment_type_title from statictext within w_svc_config_workplans
end type
type dw_workplans from u_dw_workplan_list within w_svc_config_workplans
end type
end forward

global type w_svc_config_workplans from w_window_base
integer height = 1836
windowtype windowtype = response!
st_search_title st_search_title
st_workplan_type_title st_workplan_type_title
st_workplan_type st_workplan_type
pb_up pb_up
pb_down pb_down
st_page st_page
st_category st_category
st_top_20 st_top_20
st_search_status st_search_status
st_specialty st_specialty
st_specialty_title st_specialty_title
pb_done pb_done
st_title st_title
st_description st_description
st_common_flag st_common_flag
cb_new_observation cb_new_observation
st_in_out st_in_out
st_treatment_type st_treatment_type
st_treatment_type_title st_treatment_type_title
dw_workplans dw_workplans
end type
global w_svc_config_workplans w_svc_config_workplans

type variables
boolean top_20_list

string top_20_code
string top_20_user_id
string top_20_bitmap
string common_flag = 'Y'

string top_20_dataobject
string alpha_dataobject
string cat_dataobject
string cat_pick_dataobject

string specialty_id

string description

string search_type



end variables

event open;call super::open;//////////////////////////////////////////////////////////////////////////////////////
//
// Description: workplan search screen, helps user to search the long list of workplans
//              by giving more options(desc,shortlist,catgory) like any other search scr
//
//
// Created By:Sumathi Asokumar												Creation dt: 01/09/2003
//
//
/////////////////////////////////////////////////////////////////////////////////////

str_popup			popup

specialty_id = current_user.specialty_id
dw_workplans.specialty_id = current_user.common_list_id()

if isnull(current_patient) then
	title = st_title.text
else
	title = current_patient.id_line()
end if

dw_workplans.object.description.width = dw_workplans.width - 225

If Isnull(specialty_id) or len(specialty_id) = 0 Then
	st_specialty.text = "<None>"
Else
	st_specialty.text = datalist.specialty_description(specialty_id)
End if


dw_workplans.in_office_flag = "Y"
st_in_out.text = "In Office"

postevent("post_open")


end event

on w_svc_config_workplans.create
int iCurrent
call super::create
this.st_search_title=create st_search_title
this.st_workplan_type_title=create st_workplan_type_title
this.st_workplan_type=create st_workplan_type
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
this.st_category=create st_category
this.st_top_20=create st_top_20
this.st_search_status=create st_search_status
this.st_specialty=create st_specialty
this.st_specialty_title=create st_specialty_title
this.pb_done=create pb_done
this.st_title=create st_title
this.st_description=create st_description
this.st_common_flag=create st_common_flag
this.cb_new_observation=create cb_new_observation
this.st_in_out=create st_in_out
this.st_treatment_type=create st_treatment_type
this.st_treatment_type_title=create st_treatment_type_title
this.dw_workplans=create dw_workplans
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_search_title
this.Control[iCurrent+2]=this.st_workplan_type_title
this.Control[iCurrent+3]=this.st_workplan_type
this.Control[iCurrent+4]=this.pb_up
this.Control[iCurrent+5]=this.pb_down
this.Control[iCurrent+6]=this.st_page
this.Control[iCurrent+7]=this.st_category
this.Control[iCurrent+8]=this.st_top_20
this.Control[iCurrent+9]=this.st_search_status
this.Control[iCurrent+10]=this.st_specialty
this.Control[iCurrent+11]=this.st_specialty_title
this.Control[iCurrent+12]=this.pb_done
this.Control[iCurrent+13]=this.st_title
this.Control[iCurrent+14]=this.st_description
this.Control[iCurrent+15]=this.st_common_flag
this.Control[iCurrent+16]=this.cb_new_observation
this.Control[iCurrent+17]=this.st_in_out
this.Control[iCurrent+18]=this.st_treatment_type
this.Control[iCurrent+19]=this.st_treatment_type_title
this.Control[iCurrent+20]=this.dw_workplans
end on

on w_svc_config_workplans.destroy
call super::destroy
destroy(this.st_search_title)
destroy(this.st_workplan_type_title)
destroy(this.st_workplan_type)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
destroy(this.st_category)
destroy(this.st_top_20)
destroy(this.st_search_status)
destroy(this.st_specialty)
destroy(this.st_specialty_title)
destroy(this.pb_done)
destroy(this.st_title)
destroy(this.st_description)
destroy(this.st_common_flag)
destroy(this.cb_new_observation)
destroy(this.st_in_out)
destroy(this.st_treatment_type)
destroy(this.st_treatment_type_title)
destroy(this.dw_workplans)
end on

event post_open;call super::post_open;string ls_null

setnull(ls_null)
dw_workplans.initialize(ls_null)
dw_workplans.search_top_20()


end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_config_workplans
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_config_workplans
end type

type st_search_title from statictext within w_svc_config_workplans
integer x = 1851
integer y = 588
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

type st_workplan_type_title from statictext within w_svc_config_workplans
integer x = 1417
integer y = 412
integer width = 489
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
string text = "Workplan Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_workplan_type from statictext within w_svc_config_workplans
integer x = 1925
integer y = 400
integer width = 494
integer height = 96
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Patient"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
integer li_sts
string ls_button

popup.dataobject = "dw_domain_notranslate_list"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = "WORKPLAN_TYPE"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

dw_workplans.workplan_type = popup_return.items[1]
text = popup_return.items[1]

setnull(dw_workplans.treatment_type)

dw_workplans.initialize(dw_workplans.treatment_type)
dw_workplans.search()

if dw_workplans.workplan_type = "Treatment" then
	st_treatment_type.visible = true
	st_treatment_type_title.visible = true
	st_treatment_type.text = "<All Treatment Types>"
else
	st_treatment_type.visible = false
	st_treatment_type_title.visible = false
end if


end event

type pb_up from u_picture_button within w_svc_config_workplans
integer x = 1435
integer y = 136
integer width = 137
integer height = 116
integer taborder = 20
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_workplans.current_page

dw_workplans.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_svc_config_workplans
integer x = 1435
integer y = 260
integer width = 137
integer height = 116
integer taborder = 10
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_workplans.current_page
li_last_page = dw_workplans.last_page

dw_workplans.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type st_page from statictext within w_svc_config_workplans
integer x = 1573
integer y = 136
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

type st_category from statictext within w_svc_config_workplans
integer x = 2501
integer y = 700
integer width = 343
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
boolean enabled = false
string text = "Category"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
boolean disabledlook = true
end type

event clicked;//dw_workplans.search_category()

end event

type st_top_20 from statictext within w_svc_config_workplans
integer x = 1472
integer y = 700
integer width = 434
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

event clicked;dw_workplans.search_top_20()

end event

type st_search_status from statictext within w_svc_config_workplans
integer x = 1463
integer y = 836
integer width = 1381
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

event clicked;if dw_workplans.current_search = "TOP20" then
	if dw_workplans.search_description = "Personal List" then
		dw_workplans.search_top_20(false)
	else
		dw_workplans.search_top_20(true)
	end if
end if

end event

type st_specialty from statictext within w_svc_config_workplans
integer x = 1943
integer y = 212
integer width = 901
integer height = 96
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_specialty_id

ls_specialty_id = f_pick_specialty("<None>")
if isnull(ls_specialty_id) then return

common_flag = "Y"

if ls_specialty_id = "<None>" then
	text = "<None>"
	setnull(specialty_id)
	setnull(dw_workplans.specialty_id)
	st_common_flag.text = 'All'
else
	text = datalist.specialty_description(ls_specialty_id)
	specialty_id = ls_specialty_id
	dw_workplans.specialty_id = ls_specialty_id
	st_common_flag.text = 'Specialty'
end if

if isnull(dw_workplans.treatment_type) then
	st_top_20.visible = false
	st_category.visible = false
	st_common_flag.visible = false
else
	st_top_20.visible = true
	if isnull(dw_workplans.specialty_id) then
		st_category.visible = false
		st_common_flag.visible = false
	else
		st_category.visible = true
		st_common_flag.visible = true
	end if
end if

dw_workplans.search()


end event

type st_specialty_title from statictext within w_svc_config_workplans
integer x = 1623
integer y = 224
integer width = 297
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
string text = "Specialty:"
alignment alignment = right!
boolean focusrectangle = false
end type

type pb_done from u_picture_button within w_svc_config_workplans
event clicked pbm_bnclicked
integer x = 2569
integer y = 1496
integer taborder = 80
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;close(parent)


end event

type st_title from statictext within w_svc_config_workplans
integer width = 2926
integer height = 108
integer textsize = -14
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Workplan Configuration"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_description from statictext within w_svc_config_workplans
integer x = 1961
integer y = 700
integer width = 494
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
string text = "Description"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_workplans.search_description()

end event

type st_common_flag from statictext within w_svc_config_workplans
integer x = 2574
integer y = 592
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

event clicked;if common_flag = 'Y' Then
	text = 'All'
	common_flag = 'N'
	setnull(dw_workplans.specialty_id)
else
	common_flag = 'Y'
	text = 'Specialty'
	dw_workplans.specialty_id = specialty_id
end if

dw_workplans.search()

end event

type cb_new_observation from commandbutton within w_svc_config_workplans
integer x = 1883
integer y = 1016
integer width = 498
integer height = 112
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Workplan"
end type

event clicked;str_popup popup
str_popup_return popup_return
integer li_selected_flag
long ll_row
long ll_workplan_id
string ls_description
string ls_treatment_type

 DECLARE lsp_new_workplan PROCEDURE FOR dbo.sp_new_workplan  
         @ps_workplan_type = :dw_workplans.workplan_type,   
			@ps_treatment_type = :ls_treatment_type,
			@ps_in_office_flag = :dw_workplans.in_office_flag,
         @ps_description = :ls_description,   
         @pl_workplan_id = :ll_workplan_id OUT ;

if isnull(dw_workplans.treatment_type) and dw_workplans.workplan_type = 'Treatment' then
	popup.dataobject = "dw_treatment_type_edit_list"
	popup.datacolumn = 2
	popup.displaycolumn = 4
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return
	
	ls_treatment_type = popup_return.items[1]
else
	ls_treatment_type = dw_workplans.treatment_type
end if

popup.title = "Enter new workplan description"
popup.displaycolumn = 80
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_description = popup_return.items[1]

EXECUTE lsp_new_workplan;
if not tf_check() then return

FETCH lsp_new_workplan INTO :ll_workplan_id;
if not tf_check() then return

CLOSE lsp_new_workplan;


popup.data_row_count = 1
popup.items[1] = string(ll_workplan_id)

openwithparm(w_workplan_definition, popup)
popup_return = message.powerobjectparm

dw_workplans.search()



end event

type st_in_out from statictext within w_svc_config_workplans
integer x = 2437
integer y = 400
integer width = 407
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "In Office"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if dw_workplans.in_office_flag = "Y" then
	dw_workplans.in_office_flag = "N"
	text = "Out Of Office"
else
	dw_workplans.in_office_flag = "Y"
	text = "In Office"
end if

dw_workplans.search()

end event

type st_treatment_type from statictext within w_svc_config_workplans
boolean visible = false
integer x = 1746
integer y = 1256
integer width = 768
integer height = 156
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
integer li_sts
string ls_button
string ls_filter
string ls_in_office_flag

if dw_workplans.in_office_flag = "Y" then
	ls_in_office_flag = "%"
else
	ls_in_office_flag = "N"
end if

popup.dataobject = "dw_workplan_treatment_type_list"
popup.datacolumn = 2
popup.displaycolumn = 4
popup.add_blank_row = true
popup.blank_text = "<All Treatment Types>"
popup.argument_count = 1
popup.argument[1] = ls_in_office_flag
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

text = popup_return.descriptions[1]

if popup_return.items[1] = "" then
	setnull(dw_workplans.treatment_type)
else
	dw_workplans.treatment_type = popup_return.items[1]
end if

dw_workplans.initialize(dw_workplans.treatment_type)
dw_workplans.search()




end event

type st_treatment_type_title from statictext within w_svc_config_workplans
boolean visible = false
integer x = 1897
integer y = 1172
integer width = 489
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Treatment Type"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_workplans from u_dw_workplan_list within w_svc_config_workplans
integer x = 14
integer y = 136
integer width = 1413
integer height = 1548
integer taborder = 11
boolean bringtotop = true
boolean vscrollbar = true
end type

event workplans_loaded;call super::workplans_loaded;search_type = current_search

st_top_20.backcolor = color_object
st_category.backcolor = color_object
st_description.backcolor = color_object

st_search_status.text = ps_description

if in_office_flag = "Y" then
	st_in_out.text = "In Office"
else
	st_in_out.text = "Out Of Office"
end if

CHOOSE CASE current_search
	CASE "TOP20"
		st_top_20.backcolor = color_object_selected
		st_common_flag.visible = false
		st_search_status.borderstyle = styleraised!
		st_search_status.enabled = true
	CASE "CATEGORY"
		st_category.backcolor = color_object_selected
		st_common_flag.visible = true
		st_search_status.borderstyle = stylebox!
		st_search_status.enabled = false
	CASE "DESCRIPTION"
		st_description.backcolor = color_object_selected
		st_common_flag.visible = true
		st_search_status.borderstyle = stylebox!
		st_search_status.enabled = false
END CHOOSE

set_page(1, pb_up, pb_down, st_page)


end event

event selected;call super::selected;if lasttype <> 'compute' then
	workplan_menu(selected_row)
	clear_selected()
end if

end event

