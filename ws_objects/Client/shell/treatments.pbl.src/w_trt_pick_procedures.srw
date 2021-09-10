$PBExportHeader$w_trt_pick_procedures.srw
forward
global type w_trt_pick_procedures from w_window_base
end type
type st_search_title from statictext within w_trt_pick_procedures
end type
type st_procedure_type_title from statictext within w_trt_pick_procedures
end type
type st_procedure_type from statictext within w_trt_pick_procedures
end type
type pb_down_sel from u_picture_button within w_trt_pick_procedures
end type
type pb_up_sel from u_picture_button within w_trt_pick_procedures
end type
type st_page_sel from statictext within w_trt_pick_procedures
end type
type pb_up from u_picture_button within w_trt_pick_procedures
end type
type pb_down from u_picture_button within w_trt_pick_procedures
end type
type st_page from statictext within w_trt_pick_procedures
end type
type st_category from statictext within w_trt_pick_procedures
end type
type st_top_20 from statictext within w_trt_pick_procedures
end type
type st_cpt_code from statictext within w_trt_pick_procedures
end type
type st_search_status from statictext within w_trt_pick_procedures
end type
type st_specialty from statictext within w_trt_pick_procedures
end type
type st_specialty_title from statictext within w_trt_pick_procedures
end type
type dw_selected_items from u_dw_pick_list within w_trt_pick_procedures
end type
type st_title from statictext within w_trt_pick_procedures
end type
type st_selected_items from statictext within w_trt_pick_procedures
end type
type st_description from statictext within w_trt_pick_procedures
end type
type st_common_flag from statictext within w_trt_pick_procedures
end type
type dw_procedures from u_dw_procedure_list within w_trt_pick_procedures
end type
type cb_finished from commandbutton within w_trt_pick_procedures
end type
type cb_cancel from commandbutton within w_trt_pick_procedures
end type
type cb_new from commandbutton within w_trt_pick_procedures
end type
end forward

global type w_trt_pick_procedures from w_window_base
integer height = 1836
windowtype windowtype = response!
st_search_title st_search_title
st_procedure_type_title st_procedure_type_title
st_procedure_type st_procedure_type
pb_down_sel pb_down_sel
pb_up_sel pb_up_sel
st_page_sel st_page_sel
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
dw_procedures dw_procedures
cb_finished cb_finished
cb_cancel cb_cancel
cb_new cb_new
end type
global w_trt_pick_procedures w_trt_pick_procedures

type variables
boolean top_20_list

string top_20_code
string top_20_user_id
string top_20_bitmap

string top_20_dataobject
string alpha_dataobject
string cat_dataobject
string cat_pick_dataobject

string procedure_type,treatment_type
string procedure_type_description
string specialty_id

string search_type

string common_flag = "Y"
end variables

forward prototypes
public subroutine select_procedure (string ps_procedure_type, string ps_procedure_id, string ps_description)
end prototypes

public subroutine select_procedure (string ps_procedure_type, string ps_procedure_id, string ps_description);long ll_row
string ls_preference_id,ls_treatment_mode, ls_drug_id, ls_ingr_rxcui, ls_form_rxcui
string ls_form_description
integer li_vaccine_index

ll_row = dw_selected_items.insertrow(0)
dw_selected_items.object.procedure_id[ll_row] = ps_procedure_id
dw_selected_items.object.description[ll_row] = ps_description

ls_treatment_mode = f_get_default_treatment_mode(treatment_type, ps_procedure_id)

dw_selected_items.object.treatment_mode[ll_row] = ls_treatment_mode

li_vaccine_index = vaccine_list.get_vaccine_from_proc(ps_procedure_id)
If li_vaccine_index > 0 Then
	// We are working with a vaccine, need to define the formulation
	ls_drug_id = vaccine_list.vaccine[li_vaccine_index].drug_id
	
	ls_form_description = f_choose_vaccine(ls_drug_id, ls_form_rxcui, ls_ingr_rxcui)
	dw_selected_items.object.drug_id[ll_row] = ls_drug_id
	dw_selected_items.object.form_rxcui[ll_row] = ls_form_rxcui
End if

dw_procedures.clear_selected()

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
If popup.data_row_count <> 2 Then
	log.log(this,"w_trt_pick_procedures:open","Invalid parameters",4)
	cb_cancel.event clicked()
	Return
End If
treatment_type = popup.items[1]
procedure_type = popup.items[2]

if trim(procedure_type) = "" then setnull(procedure_type)
if trim(treatment_type) = "" then setnull(treatment_type)

specialty_id = current_user.specialty_id
dw_procedures.specialty_id = current_user.common_list_id()

dw_procedures.mode = "PICK"

pb_down_sel.visible = false
pb_up_sel.visible = false
st_page_sel.visible = false

dw_procedures.object.description.width = dw_procedures.width - 150

dw_procedures.initialize(procedure_type)

if isnull(procedure_type) then
	procedure_type_description = "<All>"
else
	procedure_type_description = datalist.procedure_type_description(procedure_type)
	if isnull(procedure_type_description) then
		setnull(procedure_type)
		procedure_type_description = "<All>"
	end if
end if

st_procedure_type.text = procedure_type_description

st_title.text = "Select " + procedure_type_description + " Procedure(s)"

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

dw_procedures.search_top_20()


end event

on w_trt_pick_procedures.create
int iCurrent
call super::create
this.st_search_title=create st_search_title
this.st_procedure_type_title=create st_procedure_type_title
this.st_procedure_type=create st_procedure_type
this.pb_down_sel=create pb_down_sel
this.pb_up_sel=create pb_up_sel
this.st_page_sel=create st_page_sel
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
this.dw_procedures=create dw_procedures
this.cb_finished=create cb_finished
this.cb_cancel=create cb_cancel
this.cb_new=create cb_new
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_search_title
this.Control[iCurrent+2]=this.st_procedure_type_title
this.Control[iCurrent+3]=this.st_procedure_type
this.Control[iCurrent+4]=this.pb_down_sel
this.Control[iCurrent+5]=this.pb_up_sel
this.Control[iCurrent+6]=this.st_page_sel
this.Control[iCurrent+7]=this.pb_up
this.Control[iCurrent+8]=this.pb_down
this.Control[iCurrent+9]=this.st_page
this.Control[iCurrent+10]=this.st_category
this.Control[iCurrent+11]=this.st_top_20
this.Control[iCurrent+12]=this.st_cpt_code
this.Control[iCurrent+13]=this.st_search_status
this.Control[iCurrent+14]=this.st_specialty
this.Control[iCurrent+15]=this.st_specialty_title
this.Control[iCurrent+16]=this.dw_selected_items
this.Control[iCurrent+17]=this.st_title
this.Control[iCurrent+18]=this.st_selected_items
this.Control[iCurrent+19]=this.st_description
this.Control[iCurrent+20]=this.st_common_flag
this.Control[iCurrent+21]=this.dw_procedures
this.Control[iCurrent+22]=this.cb_finished
this.Control[iCurrent+23]=this.cb_cancel
this.Control[iCurrent+24]=this.cb_new
end on

on w_trt_pick_procedures.destroy
call super::destroy
destroy(this.st_search_title)
destroy(this.st_procedure_type_title)
destroy(this.st_procedure_type)
destroy(this.pb_down_sel)
destroy(this.pb_up_sel)
destroy(this.st_page_sel)
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
destroy(this.dw_procedures)
destroy(this.cb_finished)
destroy(this.cb_cancel)
destroy(this.cb_new)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_trt_pick_procedures
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_trt_pick_procedures
end type

type st_search_title from statictext within w_trt_pick_procedures
integer x = 1883
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

type st_procedure_type_title from statictext within w_trt_pick_procedures
integer x = 1577
integer y = 252
integer width = 594
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
string text = "Procedure Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_procedure_type from statictext within w_trt_pick_procedures
integer x = 2176
integer y = 252
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
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_procedure_type_list"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.add_blank_row = true
popup.blank_text = "<All>"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	st_category.visible = false
	text = "<All>"
	setnull(procedure_type)
else
	if isnull(specialty_id) then
		st_category.visible = false
	else
		st_category.visible = true
	end if
	procedure_type = popup_return.items[1]
	text = popup_return.descriptions[1]
end if

dw_procedures.initialize(procedure_type)

dw_procedures.search_top_20()
end event

type pb_down_sel from u_picture_button within w_trt_pick_procedures
integer x = 2702
integer y = 992
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

type pb_up_sel from u_picture_button within w_trt_pick_procedures
integer x = 2702
integer y = 864
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

type st_page_sel from statictext within w_trt_pick_procedures
integer x = 2565
integer y = 796
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
alignment alignment = right!
boolean focusrectangle = false
end type

type pb_up from u_picture_button within w_trt_pick_procedures
integer x = 1440
integer y = 120
integer width = 137
integer height = 116
integer taborder = 20
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_procedures.current_page

dw_procedures.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_trt_pick_procedures
integer x = 1440
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

li_page = dw_procedures.current_page
li_last_page = dw_procedures.last_page

dw_procedures.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type st_page from statictext within w_trt_pick_procedures
integer x = 1577
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
long backcolor = 33538240
string text = "Page 99/99"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_category from statictext within w_trt_pick_procedures
integer x = 2542
integer y = 492
integer width = 329
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

event clicked;dw_procedures.search_category()

end event

type st_top_20 from statictext within w_trt_pick_procedures
integer x = 1499
integer y = 492
integer width = 329
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
	if dw_procedures.search_description = "Personal List" then
		dw_procedures.search_top_20(false)
	else
		dw_procedures.search_top_20(true)
	end if
else
	if dw_procedures.search_description = "Personal List" then
		dw_procedures.search_top_20(true)
	else
		dw_procedures.search_top_20(false)
	end if
end if


end event

type st_cpt_code from statictext within w_trt_pick_procedures
integer x = 2194
integer y = 492
integer width = 329
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
string text = "CPT Code"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_procedures.search_cpt()

end event

type st_search_status from statictext within w_trt_pick_procedures
integer x = 1490
integer y = 628
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

type st_specialty from statictext within w_trt_pick_procedures
integer x = 2176
integer y = 140
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

type st_specialty_title from statictext within w_trt_pick_procedures
integer x = 1874
integer y = 140
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

type dw_selected_items from u_dw_pick_list within w_trt_pick_procedures
integer x = 1531
integer y = 860
integer width = 1157
integer height = 596
integer taborder = 20
string dataobject = "dw_selected_procedures"
end type

event post_click;call super::post_click;//////////////////////////////////////////////////////////////////////////////////////
//
// Description: Ask the user to choose an option based on treatment.
//
// Created By:Mark														Creation dt:
//
// Modified By:Sumathi Chinnasamy									Modified On:02/02/2000
/////////////////////////////////////////////////////////////////////////////////////

str_popup				popup
str_popup_return		popup_return
String					ls_procedure_id
String					ls_treatment_mode,default_workplan
integer					i,j
long						ll_rows
datastore				lds_datastore


If clicked_row <= 0 Then Return

ls_treatment_mode = object.treatment_mode[clicked_row]
ls_procedure_id = object.procedure_id[clicked_row]

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
			object.treatment_mode[clicked_row] = ls_treatment_mode
			if current_user.check_privilege("Edit Common Short Lists") then
				openwithparm(w_pop_yes_no, "Do you wish to make this treatment mode the default for this treatment?")
				popup_return = message.powerobjectparm
				if popup_return.item = "YES" then
					f_set_default_treatment_mode(treatment_type, ls_procedure_id, ls_treatment_mode)
				end if
			end if
		End If
	Else
		deleterow(lastrow)
	End If
	Destroy lds_datastore
End If

last_page = 0
recalc_page(st_page_sel.text)
if last_page < 2 then
	pb_down_sel.visible = false
	pb_up_sel.visible = false
	st_page_sel.visible = false
else
	pb_down_sel.visible = true
	pb_up_sel.visible = true
	st_page_sel.visible = true
	if current_page > 1 then
		pb_up_sel.enabled = true
	else
		pb_up_sel.enabled = false
	end if
	if current_page < last_page then
		pb_down_sel.enabled = true
	else
		pb_down_sel.enabled = false
	end if
end if

If rowcount() = 0 Then cb_finished.enabled = False
end event

type st_title from statictext within w_trt_pick_procedures
integer width = 2926
integer height = 108
integer textsize = -14
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type st_selected_items from statictext within w_trt_pick_procedures
integer x = 1531
integer y = 764
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

type st_description from statictext within w_trt_pick_procedures
integer x = 1847
integer y = 492
integer width = 329
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

event clicked;dw_procedures.search_description()

end event

type st_common_flag from statictext within w_trt_pick_procedures
integer x = 2601
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
	setnull(dw_procedures.specialty_id)
else
	common_flag = "Y"
	text = "Specialty"
	dw_procedures.specialty_id = specialty_id
end if

dw_procedures.search()

end event

type dw_procedures from u_dw_procedure_list within w_trt_pick_procedures
integer x = 14
integer y = 108
integer width = 1413
integer height = 1592
integer taborder = 11
boolean bringtotop = true
boolean vscrollbar = true
end type

event procedures_loaded;call super::procedures_loaded;
search_type = current_search

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
	CASE "CPT"
		st_cpt_code.backcolor = color_object_selected
		st_common_flag.visible = true
	CASE "DESCRIPTION"
		st_description.backcolor = color_object_selected
		st_common_flag.visible = true
END CHOOSE

set_page(1, pb_up, pb_down, st_page)

end event

event selected;string ls_procedure_type
string ls_procedure_id
string ls_description

if lasttype <> 'compute' then
	ls_procedure_type = object.procedure_type[selected_row]
	ls_procedure_id = object.procedure_id[selected_row]
	ls_description = object.description[selected_row]
	select_procedure(ls_procedure_type, ls_procedure_id, ls_description)
end if

end event

type cb_finished from commandbutton within w_trt_pick_procedures
integer x = 2505
integer y = 1608
integer width = 357
integer height = 108
integer taborder = 80
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

event clicked;str_picked_procedures lstr_procedures
long i

lstr_procedures.procedure_count = dw_selected_items.rowcount()

for i = 1 to lstr_procedures.procedure_count
	lstr_procedures.procedures[i].procedure_id = dw_selected_items.object.procedure_id[i]
	lstr_procedures.procedures[i].description = dw_selected_items.object.description[i]
	lstr_procedures.procedures[i].treatment_mode = dw_selected_items.object.treatment_mode[i]
	lstr_procedures.procedures[i].drug_id = dw_selected_items.object.drug_id[i]
next

closewithreturn(parent, lstr_procedures)


end event

type cb_cancel from commandbutton within w_trt_pick_procedures
integer x = 1499
integer y = 1608
integer width = 357
integer height = 108
integer taborder = 90
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

event clicked;str_picked_procedures lstr_procedures

lstr_procedures.procedure_count = 0

closewithreturn(parent, lstr_procedures)
end event

type cb_new from commandbutton within w_trt_pick_procedures
integer x = 1833
integer y = 1472
integer width = 549
integer height = 88
integer taborder = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Procedure"
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_procedure_type

if isnull(procedure_type) then
	popup.dataobject = "dw_procedure_type_list"
	popup.datacolumn = 1
	popup.displaycolumn = 2
	popup.add_blank_row = false
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return
	
	ls_procedure_type = popup_return.items[1]
else
	ls_procedure_type = procedure_type
end if

popup.items[1] = ls_procedure_type
setnull(popup.items[2])
popup.data_row_count = 2
openwithparm(w_procedure_definition, popup, f_active_window())
popup_return = message.powerobjectparm

if isnull(popup_return.item) then return

select_procedure(ls_procedure_type, &
						popup_return.item, &
						popup_return.items[4])
end event

