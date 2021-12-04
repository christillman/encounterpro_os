$PBExportHeader$w_pick_drug_compound.srw
forward
global type w_pick_drug_compound from w_window_base
end type
type st_specialty from statictext within w_pick_drug_compound
end type
type st_specialty_title from statictext within w_pick_drug_compound
end type
type pb_done from u_picture_button within w_pick_drug_compound
end type
type st_title from statictext within w_pick_drug_compound
end type
type pb_cancel from u_picture_button within w_pick_drug_compound
end type
type dw_drugs from u_dw_drug_list within w_pick_drug_compound
end type
type st_search_title from statictext within w_pick_drug_compound
end type
type st_category from statictext within w_pick_drug_compound
end type
type st_top_20 from statictext within w_pick_drug_compound
end type
type st_cpt_code from statictext within w_pick_drug_compound
end type
type st_search_status from statictext within w_pick_drug_compound
end type
type st_description from statictext within w_pick_drug_compound
end type
type st_common_flag from statictext within w_pick_drug_compound
end type
type pb_up from u_picture_button within w_pick_drug_compound
end type
type pb_down from u_picture_button within w_pick_drug_compound
end type
type st_page from statictext within w_pick_drug_compound
end type
type pb_down_sel from u_picture_button within w_pick_drug_compound
end type
type pb_up_sel from u_picture_button within w_pick_drug_compound
end type
type dw_selected_items from u_dw_pick_list within w_pick_drug_compound
end type
type st_selected_items from statictext within w_pick_drug_compound
end type
type st_page_sel from statictext within w_pick_drug_compound
end type
type cb_new_drug from commandbutton within w_pick_drug_compound
end type
end forward

global type w_pick_drug_compound from w_window_base
integer height = 1836
windowtype windowtype = response!
st_specialty st_specialty
st_specialty_title st_specialty_title
pb_done pb_done
st_title st_title
pb_cancel pb_cancel
dw_drugs dw_drugs
st_search_title st_search_title
st_category st_category
st_top_20 st_top_20
st_cpt_code st_cpt_code
st_search_status st_search_status
st_description st_description
st_common_flag st_common_flag
pb_up pb_up
pb_down pb_down
st_page st_page
pb_down_sel pb_down_sel
pb_up_sel pb_up_sel
dw_selected_items dw_selected_items
st_selected_items st_selected_items
st_page_sel st_page_sel
cb_new_drug cb_new_drug
end type
global w_pick_drug_compound w_pick_drug_compound

type variables
String top_20_code
string specialty_id
String search_type
String common_flag = "Y"
Boolean allow_null_amount = false
end variables

forward prototypes
public subroutine select_drug (string ps_drug_id, string ps_description)
end prototypes

public subroutine select_drug (string ps_drug_id, string ps_description);Datetime ldt_begin_date
Date		ld_begin_date
Long		ll_row
Integer	li_count
integer i
String	ls_temp
String	ls_description,ls_drug_id,ls_dosage_form,ls_package_id
u_unit luo_unit
string ls_specific_code
string ls_generic_code
string ls_value
string lsa_unit_id[]
string lsa_description[]

str_popup	popup
str_popup_return popup_return
str_drug_administration lstra_admin[]

ls_drug_id = ps_drug_id
ls_description = ps_description

ls_generic_code = top_20_code
ls_specific_code = top_20_code + "|" + ps_drug_id

luo_unit = unit_list.find_unit("%")
if isnull(luo_unit) then
	log.log(this, "w_pick_drug_compound.select_drug:0027", "Unit not found (%)", 4)
	return
end if

ls_value = luo_unit.get_value("", ls_specific_code, ls_generic_code)
if trim(ls_value) = "" then setnull(ls_value)
if isnull(ls_value) and not allow_null_amount then return

ls_temp = luo_unit.pretty_amount_unit(ls_value)
if not isnull(ls_temp) and trim(ls_temp) <> "" then
	ls_description += " " + ls_temp
end if

ll_row = dw_selected_items.insertrow(0)
dw_selected_items.object.drug_id[ll_row] = ls_drug_id
dw_selected_items.object.description[ll_row] = ls_description
dw_selected_items.object.percentage[ll_row] = dec(ls_value)

dw_drugs.clear_selected()

pb_done.enabled = true

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
	top_20_code = popup.items[1]
Elseif popup.data_row_count = 2 Then
	top_20_code = popup.items[1]
	allow_null_amount = f_string_to_boolean(popup.items[2])
Else
	log.log(this,"w_pick_drug_compound:open","Invalid parameters",4)
	pb_cancel.event clicked()
	Return
End If

If isnull(top_20_code) or trim(top_20_code) = "" Then
	top_20_code = "DrugCompound"
End If

specialty_id = current_user.specialty_id
dw_drugs.specialty_id = current_user.common_list_id()

dw_drugs.mode = "PICK"

pb_down_sel.visible = false
pb_up_sel.visible = false
st_page_sel.visible = false

dw_drugs.object.description.width = dw_drugs.width - 150

dw_drugs.initialize(top_20_code)

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

dw_drugs.search_top_20()


end event

on w_pick_drug_compound.create
int iCurrent
call super::create
this.st_specialty=create st_specialty
this.st_specialty_title=create st_specialty_title
this.pb_done=create pb_done
this.st_title=create st_title
this.pb_cancel=create pb_cancel
this.dw_drugs=create dw_drugs
this.st_search_title=create st_search_title
this.st_category=create st_category
this.st_top_20=create st_top_20
this.st_cpt_code=create st_cpt_code
this.st_search_status=create st_search_status
this.st_description=create st_description
this.st_common_flag=create st_common_flag
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
this.pb_down_sel=create pb_down_sel
this.pb_up_sel=create pb_up_sel
this.dw_selected_items=create dw_selected_items
this.st_selected_items=create st_selected_items
this.st_page_sel=create st_page_sel
this.cb_new_drug=create cb_new_drug
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_specialty
this.Control[iCurrent+2]=this.st_specialty_title
this.Control[iCurrent+3]=this.pb_done
this.Control[iCurrent+4]=this.st_title
this.Control[iCurrent+5]=this.pb_cancel
this.Control[iCurrent+6]=this.dw_drugs
this.Control[iCurrent+7]=this.st_search_title
this.Control[iCurrent+8]=this.st_category
this.Control[iCurrent+9]=this.st_top_20
this.Control[iCurrent+10]=this.st_cpt_code
this.Control[iCurrent+11]=this.st_search_status
this.Control[iCurrent+12]=this.st_description
this.Control[iCurrent+13]=this.st_common_flag
this.Control[iCurrent+14]=this.pb_up
this.Control[iCurrent+15]=this.pb_down
this.Control[iCurrent+16]=this.st_page
this.Control[iCurrent+17]=this.pb_down_sel
this.Control[iCurrent+18]=this.pb_up_sel
this.Control[iCurrent+19]=this.dw_selected_items
this.Control[iCurrent+20]=this.st_selected_items
this.Control[iCurrent+21]=this.st_page_sel
this.Control[iCurrent+22]=this.cb_new_drug
end on

on w_pick_drug_compound.destroy
call super::destroy
destroy(this.st_specialty)
destroy(this.st_specialty_title)
destroy(this.pb_done)
destroy(this.st_title)
destroy(this.pb_cancel)
destroy(this.dw_drugs)
destroy(this.st_search_title)
destroy(this.st_category)
destroy(this.st_top_20)
destroy(this.st_cpt_code)
destroy(this.st_search_status)
destroy(this.st_description)
destroy(this.st_common_flag)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
destroy(this.pb_down_sel)
destroy(this.pb_up_sel)
destroy(this.dw_selected_items)
destroy(this.st_selected_items)
destroy(this.st_page_sel)
destroy(this.cb_new_drug)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_pick_drug_compound
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pick_drug_compound
end type

type st_specialty from statictext within w_pick_drug_compound
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

type st_specialty_title from statictext within w_pick_drug_compound
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
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Specialty:"
alignment alignment = right!
boolean focusrectangle = false
end type

type pb_done from u_picture_button within w_pick_drug_compound
event clicked pbm_bnclicked
integer x = 2569
integer y = 1496
integer taborder = 80
boolean enabled = false
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;str_picked_drugs lstr_drugs
str_popup_return popup_return
long i

lstr_drugs.drug_count = dw_selected_items.rowcount()

for i = 1 to lstr_drugs.drug_count
	lstr_drugs.drugs[i].drug_id = dw_selected_items.object.drug_id[i]
	lstr_drugs.drugs[i].description = dw_selected_items.object.description[i]
	lstr_drugs.drugs[i].percentage = dw_selected_items.object.percentage[i]
next

Closewithreturn(parent, lstr_drugs)



end event

type st_title from statictext within w_pick_drug_compound
integer width = 2926
integer height = 108
integer textsize = -14
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Select drug(s)"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_cancel from u_picture_button within w_pick_drug_compound
integer x = 1499
integer y = 1496
integer taborder = 100
boolean originalsize = false
string picturename = "button11.bmp"
string disabledname = "button11.bmp"
end type

event clicked;str_picked_drugs lstr_drugs

lstr_drugs.drug_count = 0

closewithreturn(parent, lstr_drugs)
end event

type dw_drugs from u_dw_drug_list within w_pick_drug_compound
integer x = 14
integer y = 108
integer width = 1413
integer height = 1592
integer taborder = 11
boolean bringtotop = true
boolean vscrollbar = true
end type

event selected;call super::selected;string ls_drug_id
string ls_description

if lasttype <> 'compute' then
	ls_drug_id = object.drug_id[selected_row]
	ls_description = object.description[selected_row]
	select_drug(ls_drug_id, ls_description)
end if
end event

event drugs_loaded;search_type = current_search

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

set_page(1, pb_up, pb_down, st_page)


end event

type st_search_title from statictext within w_pick_drug_compound
integer x = 1874
integer y = 380
integer width = 558
integer height = 88
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Search Options"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_category from statictext within w_pick_drug_compound
integer x = 2510
integer y = 492
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
string text = "Category"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_drugs.search_category()

end event

type st_top_20 from statictext within w_pick_drug_compound
integer x = 1454
integer y = 492
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

type st_cpt_code from statictext within w_pick_drug_compound
integer x = 2158
integer y = 492
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
string text = "Generic"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_drugs.search_generic()

end event

type st_search_status from statictext within w_pick_drug_compound
integer x = 1449
integer y = 628
integer width = 1403
integer height = 88
boolean bringtotop = true
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

type st_description from statictext within w_pick_drug_compound
integer x = 1806
integer y = 492
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
string text = "Trade Name"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_drugs.search_description()

end event

type st_common_flag from statictext within w_pick_drug_compound
integer x = 2583
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

type pb_up from u_picture_button within w_pick_drug_compound
integer x = 1440
integer y = 116
integer width = 137
integer height = 116
integer taborder = 30
boolean bringtotop = true
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

type pb_down from u_picture_button within w_pick_drug_compound
integer x = 1440
integer y = 240
integer width = 137
integer height = 116
integer taborder = 20
boolean bringtotop = true
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

type st_page from statictext within w_pick_drug_compound
integer x = 1577
integer y = 116
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
long backcolor = COLOR_BACKGROUND
string text = "Page 99/99"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_down_sel from u_picture_button within w_pick_drug_compound
integer x = 2670
integer y = 996
integer width = 137
integer height = 116
integer taborder = 20
boolean bringtotop = true
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

type pb_up_sel from u_picture_button within w_pick_drug_compound
integer x = 2670
integer y = 868
integer width = 137
integer height = 116
integer taborder = 20
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_selected_items.current_page

dw_selected_items.set_page(li_page - 1, st_page_sel.text)

if li_page <= 2 then enabled = false
pb_down_sel.enabled = true

end event

type dw_selected_items from u_dw_pick_list within w_pick_drug_compound
integer x = 1499
integer y = 864
integer width = 1157
integer height = 596
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_selected_compound_drugs"
end type

event selected;call super::selected;//////////////////////////////////////////////////////////////////////////////////////
//
// Description: Ask the user to choose an option based on treatment.
//
// Created By:Sumathi Chinnasamy										Creation dt:12/17/01
//
/////////////////////////////////////////////////////////////////////////////////////

deleterow(selected_row)

recalc_page(pb_up_sel, pb_down_sel, st_page_sel)

If rowcount() = 0 Then pb_done.enabled = False

end event

type st_selected_items from statictext within w_pick_drug_compound
integer x = 1499
integer y = 768
integer width = 1157
integer height = 92
boolean bringtotop = true
integer textsize = -14
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Selected Items"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_page_sel from statictext within w_pick_drug_compound
integer x = 2533
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
long backcolor = COLOR_BACKGROUND
string text = "Page 99/99"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_new_drug from commandbutton within w_pick_drug_compound
integer x = 1957
integer y = 1548
integer width = 402
integer height = 112
integer taborder = 31
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

