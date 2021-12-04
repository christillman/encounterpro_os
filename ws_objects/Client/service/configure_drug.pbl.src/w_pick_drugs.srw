$PBExportHeader$w_pick_drugs.srw
forward
global type w_pick_drugs from w_window_base
end type
type st_search_title from statictext within w_pick_drugs
end type
type pb_down_sel from u_picture_button within w_pick_drugs
end type
type pb_up_sel from u_picture_button within w_pick_drugs
end type
type st_page_sel from statictext within w_pick_drugs
end type
type pb_up from u_picture_button within w_pick_drugs
end type
type pb_down from u_picture_button within w_pick_drugs
end type
type st_page from statictext within w_pick_drugs
end type
type st_category from statictext within w_pick_drugs
end type
type st_top_20 from statictext within w_pick_drugs
end type
type st_cpt_code from statictext within w_pick_drugs
end type
type st_search_status from statictext within w_pick_drugs
end type
type st_specialty from statictext within w_pick_drugs
end type
type st_specialty_title from statictext within w_pick_drugs
end type
type dw_selected_items from u_dw_pick_list within w_pick_drugs
end type
type pb_done from u_picture_button within w_pick_drugs
end type
type st_title from statictext within w_pick_drugs
end type
type pb_cancel from u_picture_button within w_pick_drugs
end type
type st_selected_items from statictext within w_pick_drugs
end type
type st_description from statictext within w_pick_drugs
end type
type st_common_flag from statictext within w_pick_drugs
end type
type dw_drugs from u_dw_drug_list within w_pick_drugs
end type
type cb_new_drug from commandbutton within w_pick_drugs
end type
type st_drug_type from statictext within w_pick_drugs
end type
type st_2 from statictext within w_pick_drugs
end type
end forward

global type w_pick_drugs from w_window_base
integer height = 1836
windowtype windowtype = response!
st_search_title st_search_title
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
pb_done pb_done
st_title st_title
pb_cancel pb_cancel
st_selected_items st_selected_items
st_description st_description
st_common_flag st_common_flag
dw_drugs dw_drugs
cb_new_drug cb_new_drug
st_drug_type st_drug_type
st_2 st_2
end type
global w_pick_drugs w_pick_drugs

type variables
String specialty_id
String search_type
String common_flag = "Y"

end variables

forward prototypes
public subroutine select_drug (string ps_drug_id, string ps_description)
end prototypes

public subroutine select_drug (string ps_drug_id, string ps_description);long ll_row

ll_row = dw_selected_items.insertrow(0)
dw_selected_items.object.drug_id[ll_row] = ps_drug_id
dw_selected_items.object.description[ll_row] = ps_description

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

string ls_drug_type

specialty_id = current_user.specialty_id
dw_drugs.specialty_id = current_user.common_list_id()

dw_drugs.mode = "PICK"

pb_down_sel.visible = false
pb_up_sel.visible = false
st_page_sel.visible = false

dw_drugs.object.description.width = dw_drugs.width - 150

ls_drug_type = message.stringparm
if len(ls_drug_type) > 0 then
	st_drug_type.text = ls_drug_type
	st_drug_type.borderstyle = stylebox!
	st_drug_type.enabled = false
else
	st_drug_type.text = "All Drugs"
	st_drug_type.borderstyle = styleraised!
	st_drug_type.enabled = true
	ls_drug_type = "Drug"
end if


dw_drugs.initialize("MEDICATION", ls_drug_type)

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

on w_pick_drugs.create
int iCurrent
call super::create
this.st_search_title=create st_search_title
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
this.pb_done=create pb_done
this.st_title=create st_title
this.pb_cancel=create pb_cancel
this.st_selected_items=create st_selected_items
this.st_description=create st_description
this.st_common_flag=create st_common_flag
this.dw_drugs=create dw_drugs
this.cb_new_drug=create cb_new_drug
this.st_drug_type=create st_drug_type
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_search_title
this.Control[iCurrent+2]=this.pb_down_sel
this.Control[iCurrent+3]=this.pb_up_sel
this.Control[iCurrent+4]=this.st_page_sel
this.Control[iCurrent+5]=this.pb_up
this.Control[iCurrent+6]=this.pb_down
this.Control[iCurrent+7]=this.st_page
this.Control[iCurrent+8]=this.st_category
this.Control[iCurrent+9]=this.st_top_20
this.Control[iCurrent+10]=this.st_cpt_code
this.Control[iCurrent+11]=this.st_search_status
this.Control[iCurrent+12]=this.st_specialty
this.Control[iCurrent+13]=this.st_specialty_title
this.Control[iCurrent+14]=this.dw_selected_items
this.Control[iCurrent+15]=this.pb_done
this.Control[iCurrent+16]=this.st_title
this.Control[iCurrent+17]=this.pb_cancel
this.Control[iCurrent+18]=this.st_selected_items
this.Control[iCurrent+19]=this.st_description
this.Control[iCurrent+20]=this.st_common_flag
this.Control[iCurrent+21]=this.dw_drugs
this.Control[iCurrent+22]=this.cb_new_drug
this.Control[iCurrent+23]=this.st_drug_type
this.Control[iCurrent+24]=this.st_2
end on

on w_pick_drugs.destroy
call super::destroy
destroy(this.st_search_title)
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
destroy(this.pb_done)
destroy(this.st_title)
destroy(this.pb_cancel)
destroy(this.st_selected_items)
destroy(this.st_description)
destroy(this.st_common_flag)
destroy(this.dw_drugs)
destroy(this.cb_new_drug)
destroy(this.st_drug_type)
destroy(this.st_2)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_pick_drugs
integer x = 2821
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pick_drugs
end type

type st_search_title from statictext within w_pick_drugs
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
long backcolor = COLOR_BACKGROUND
string text = "Search Options"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_down_sel from u_picture_button within w_pick_drugs
integer x = 2679
integer y = 988
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

type pb_up_sel from u_picture_button within w_pick_drugs
integer x = 2679
integer y = 860
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

type st_page_sel from statictext within w_pick_drugs
integer x = 2542
integer y = 792
integer width = 274
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Page 99/99"
alignment alignment = right!
boolean focusrectangle = false
end type

type pb_up from u_picture_button within w_pick_drugs
integer x = 1440
integer y = 124
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

type pb_down from u_picture_button within w_pick_drugs
integer x = 1440
integer y = 248
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

type st_page from statictext within w_pick_drugs
integer x = 1426
integer y = 368
integer width = 151
integer height = 116
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

type st_category from statictext within w_pick_drugs
integer x = 2519
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

type st_top_20 from statictext within w_pick_drugs
integer x = 1463
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

type st_cpt_code from statictext within w_pick_drugs
integer x = 2167
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

type st_search_status from statictext within w_pick_drugs
integer x = 1454
integer y = 628
integer width = 1399
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

type st_specialty from statictext within w_pick_drugs
integer x = 2002
integer y = 276
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

type st_specialty_title from statictext within w_pick_drugs
integer x = 1701
integer y = 276
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

type dw_selected_items from u_dw_pick_list within w_pick_drugs
integer x = 1509
integer y = 856
integer width = 1157
integer height = 596
integer taborder = 20
string dataobject = "dw_selected_drugs"
end type

event post_click;

deleterow(clicked_row)

If rowcount() = 0 Then pb_done.enabled = False


end event

type pb_done from u_picture_button within w_pick_drugs
event clicked pbm_bnclicked
integer x = 2569
integer y = 1496
integer width = 256
integer height = 224
integer taborder = 80
boolean enabled = false
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;str_picked_drugs lstr_drugs
long i

lstr_drugs.drug_count = dw_selected_items.rowcount()

for i = 1 to lstr_drugs.drug_count
	lstr_drugs.drugs[i].drug_id = dw_selected_items.object.drug_id[i]
	lstr_drugs.drugs[i].description = dw_selected_items.object.description[i]
	lstr_drugs.drugs[i].treatment_mode = dw_selected_items.object.treatment_mode[i]
	lstr_drugs.drugs[i].dosage_form = dw_selected_items.object.dosage_form[i]
	lstr_drugs.drugs[i].administration_sequence = dw_selected_items.object.administration_sequence[i]
	lstr_drugs.drugs[i].package_id = dw_selected_items.object.package_id[i]
	lstr_drugs.drugs[i].begin_date = dw_selected_items.object.begin_date[i]
next

Closewithreturn(parent, lstr_drugs)


end event

type st_title from statictext within w_pick_drugs
integer width = 2926
integer height = 108
integer textsize = -14
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Select prescription drug(s)"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_cancel from u_picture_button within w_pick_drugs
integer x = 1509
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

type st_selected_items from statictext within w_pick_drugs
integer x = 1509
integer y = 760
integer width = 1157
integer height = 92
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

type st_description from statictext within w_pick_drugs
integer x = 1815
integer y = 492
integer width = 343
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

type st_common_flag from statictext within w_pick_drugs
integer x = 2592
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

type dw_drugs from u_dw_drug_list within w_pick_drugs
integer x = 14
integer y = 108
integer width = 1413
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

type cb_new_drug from commandbutton within w_pick_drugs
integer x = 1957
integer y = 1548
integer width = 402
integer height = 112
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

type st_drug_type from statictext within w_pick_drugs
integer x = 2002
integer y = 148
integer width = 695
integer height = 104
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
boolean border = true
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_drug_type_pick"
popup.displaycolumn = 1
popup.datacolumn = 1
popup.add_blank_row = true
popup.blank_text = "All Drugs"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	dw_drugs.drug_type = "Drug"
	text = "All Drugs"
else
	dw_drugs.drug_type = popup_return.items[1]
	text = popup_return.items[1]
end if

dw_drugs.search()

end event

type st_2 from statictext within w_pick_drugs
integer x = 1669
integer y = 164
integer width = 329
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Drug Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

