$PBExportHeader$w_pick_patient_materials.srw
forward
global type w_pick_patient_materials from w_window_base
end type
type st_search_title from statictext within w_pick_patient_materials
end type
type pb_down_sel from u_picture_button within w_pick_patient_materials
end type
type pb_up_sel from u_picture_button within w_pick_patient_materials
end type
type st_page_sel from statictext within w_pick_patient_materials
end type
type pb_up from u_picture_button within w_pick_patient_materials
end type
type pb_down from u_picture_button within w_pick_patient_materials
end type
type st_page from statictext within w_pick_patient_materials
end type
type st_category from statictext within w_pick_patient_materials
end type
type st_top_20 from statictext within w_pick_patient_materials
end type
type st_search_status from statictext within w_pick_patient_materials
end type
type st_specialty from statictext within w_pick_patient_materials
end type
type st_specialty_title from statictext within w_pick_patient_materials
end type
type dw_selected_items from u_dw_pick_list within w_pick_patient_materials
end type
type pb_done from u_picture_button within w_pick_patient_materials
end type
type st_title from statictext within w_pick_patient_materials
end type
type pb_cancel from u_picture_button within w_pick_patient_materials
end type
type st_selected_items from statictext within w_pick_patient_materials
end type
type st_description from statictext within w_pick_patient_materials
end type
type st_common_flag from statictext within w_pick_patient_materials
end type
type pb_new_drug from u_picture_button within w_pick_patient_materials
end type
type dw_materials from u_dw_patient_materials_list within w_pick_patient_materials
end type
end forward

global type w_pick_patient_materials from w_window_base
integer height = 1836
boolean controlmenu = false
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
pb_new_drug pb_new_drug
dw_materials dw_materials
end type
global w_pick_patient_materials w_pick_patient_materials

type variables
String treatment_type,specialty_id
String search_type
String common_flag = "Y"
Boolean past_treatment = false
end variables

forward prototypes
public subroutine select_material (string ps_material_id, string ps_description)
end prototypes

public subroutine select_material (string ps_material_id, string ps_description);long ll_row
string ls_treatment_mode

ll_row = dw_selected_items.insertrow(0)
dw_selected_items.object.material_id[ll_row] = ps_material_id
dw_selected_items.object.description[ll_row] = ps_description

ls_treatment_mode = f_get_default_treatment_mode(treatment_type, ps_material_id)

dw_selected_items.object.treatment_mode[ll_row] = ls_treatment_mode

dw_materials.clear_selected()

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
	treatment_type = popup.items[1]
Else
	log.log(this,"w_pick_patient_materials:open","Invalid parameters",4)
	pb_cancel.event clicked()
	Return
End If

if trim(treatment_type) = "" then setnull(treatment_type)
If isnull(treatment_type) Then
	log.log(this,"w_pick_patient_materials:open","treatment type can not be null",4)
	pb_cancel.event clicked()
	Return
End If

specialty_id = current_user.specialty_id
dw_materials.specialty_id = current_user.common_list_id()

dw_materials.mode = "PICK"

pb_down_sel.visible = false
pb_up_sel.visible = false
st_page_sel.visible = false

dw_materials.object.description.width = dw_materials.width - 150

dw_materials.initialize(treatment_type)

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

dw_materials.search_top_20()


end event

on w_pick_patient_materials.create
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
this.pb_new_drug=create pb_new_drug
this.dw_materials=create dw_materials
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
this.Control[iCurrent+10]=this.st_search_status
this.Control[iCurrent+11]=this.st_specialty
this.Control[iCurrent+12]=this.st_specialty_title
this.Control[iCurrent+13]=this.dw_selected_items
this.Control[iCurrent+14]=this.pb_done
this.Control[iCurrent+15]=this.st_title
this.Control[iCurrent+16]=this.pb_cancel
this.Control[iCurrent+17]=this.st_selected_items
this.Control[iCurrent+18]=this.st_description
this.Control[iCurrent+19]=this.st_common_flag
this.Control[iCurrent+20]=this.pb_new_drug
this.Control[iCurrent+21]=this.dw_materials
end on

on w_pick_patient_materials.destroy
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
destroy(this.pb_new_drug)
destroy(this.dw_materials)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_pick_patient_materials
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pick_patient_materials
end type

type st_search_title from statictext within w_pick_patient_materials
integer x = 1851
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

type pb_down_sel from u_picture_button within w_pick_patient_materials
integer x = 2702
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

type pb_up_sel from u_picture_button within w_pick_patient_materials
integer x = 2702
integer y = 860
integer width = 137
integer height = 116
integer taborder = 10
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

type st_page_sel from statictext within w_pick_patient_materials
integer x = 2565
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

type pb_up from u_picture_button within w_pick_patient_materials
integer x = 1435
integer y = 120
integer width = 137
integer height = 116
integer taborder = 20
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_materials.current_page

dw_materials.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_pick_patient_materials
integer x = 1435
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

li_page = dw_materials.current_page
li_last_page = dw_materials.last_page

dw_materials.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type st_page from statictext within w_pick_patient_materials
integer x = 1573
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
long backcolor = COLOR_BACKGROUND
string text = "Page 99/99"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_category from statictext within w_pick_patient_materials
integer x = 2363
integer y = 492
integer width = 357
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

event clicked;dw_materials.search_category()

end event

type st_top_20 from statictext within w_pick_patient_materials
integer x = 1609
integer y = 492
integer width = 357
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
	if dw_materials.search_description = "Personal List" then
		dw_materials.search_top_20(false)
	else
		dw_materials.search_top_20(true)
	end if
else
	if dw_materials.search_description = "Personal List" then
		dw_materials.search_top_20(true)
	else
		dw_materials.search_top_20(false)
	end if
end if


end event

type st_search_status from statictext within w_pick_patient_materials
integer x = 1495
integer y = 628
integer width = 1339
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

type st_specialty from statictext within w_pick_patient_materials
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

type st_specialty_title from statictext within w_pick_patient_materials
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

type dw_selected_items from u_dw_pick_list within w_pick_patient_materials
integer x = 1531
integer y = 856
integer width = 1157
integer height = 596
integer taborder = 20
string dataobject = "dw_selected_materials"
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
String					ls_material_id
String					ls_treatment_mode,default_workplan
integer					i,j
long						ll_rows
datastore				lds_datastore


If clicked_row <= 0 Then Return

ls_treatment_mode = object.treatment_mode[clicked_row]
ls_material_id = object.material_id[clicked_row]

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
		openwithparm(w_pop_pick, popup)
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
					f_set_default_treatment_mode(treatment_type, ls_material_id, ls_treatment_mode)
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

If rowcount() = 0 Then pb_done.enabled = False
end event

type pb_done from u_picture_button within w_pick_patient_materials
event clicked pbm_bnclicked
integer x = 2569
integer y = 1496
integer taborder = 80
boolean enabled = false
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;str_picked_patient_materials lstr_materials
long i

lstr_materials.material_count = dw_selected_items.rowcount()

for i = 1 to lstr_materials.material_count
	lstr_materials.materials[i].material_id = dw_selected_items.object.material_id[i]
	lstr_materials.materials[i].description = dw_selected_items.object.description[i]
	lstr_materials.materials[i].treatment_mode = dw_selected_items.object.treatment_mode[i]
next

Closewithreturn(parent, lstr_materials)


end event

type st_title from statictext within w_pick_patient_materials
integer width = 2926
integer height = 108
integer textsize = -14
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Select patient education material(s)"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_cancel from u_picture_button within w_pick_patient_materials
integer x = 1824
integer y = 1496
integer taborder = 100
boolean originalsize = false
string picturename = "button11.bmp"
string disabledname = "button11.bmp"
end type

event clicked;str_picked_patient_materials lstr_picked_patient_materials

lstr_picked_patient_materials.material_count = 0

closewithreturn(parent, lstr_picked_patient_materials)
end event

type st_selected_items from statictext within w_pick_patient_materials
integer x = 1531
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

type st_description from statictext within w_pick_patient_materials
integer x = 1979
integer y = 492
integer width = 357
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

event clicked;dw_materials.search_description()

end event

type st_common_flag from statictext within w_pick_patient_materials
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
	setnull(dw_materials.specialty_id)
else
	common_flag = "Y"
	text = "Specialty"
	dw_materials.specialty_id = specialty_id
end if

dw_materials.search()

end event

type pb_new_drug from u_picture_button within w_pick_patient_materials
integer x = 2208
integer y = 1500
integer taborder = 11
boolean bringtotop = true
string picturename = "b_new18.bmp"
string disabledname = "b_push05.bmp"
end type

event clicked;call super::clicked;//////////////////////////////////////////////////////////////////////////////////////
//
// Description: Open common dialog box to select one or more files
//
// Created By:Sumathi Chinnasamy										Creation dt: 10/10/2003
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

String					ls_filenames
Integer					li_return, li_pos
Long						ll_count
string lsa_paths[]
string lsa_files[]
string ls_filter
integer li_sts
str_popup popup

// returns all the user selected files
ls_filter = current_service.get_attribute("file_filter")
if isnull(ls_filter) then
	ls_filter = "Word Documents (*.doc), *.DOC" 
	ls_filter += ",Rich Text format (*.rtf), *.RTF" 
	ls_filter += ",Browser files (*.htm), *.HTM" 
	ls_filter += ",Adobe files (*.pdf), *.PDF" 
	ls_filter += ",Excel files (*.xls), *.XLS" 
	ls_filter += ",Pictures (*.pic), *.PIC" 
	ls_filter += ",Images (*.bmp *.gif *.jpg *.jpeg), *.BMP;*.GIF;*.JPG;*.JPEG" 
	ls_filter += ",Wave files (*.wav), *.WAV" 
	ls_filter += ",Movies (*.avi), *.AVI"
	ls_filter += ",All Files (*.*), *.*"
end if

li_sts = windows_api.comdlg32.getopenfilename( handle(w_main), &
												"Select New Patient Material File(s)", &
												lsa_paths, &
												lsa_files, &
												ls_filter)
if li_sts < 0 then return 0

ll_count = upperbound(lsa_paths)

// If user cancelled the file selection
If ll_count <= 0 Then Return

popup.items = lsa_paths
popup.data_row_count = ll_count

Openwithparm(w_import_material, popup)

dw_materials.search()


end event

type dw_materials from u_dw_patient_materials_list within w_pick_patient_materials
integer x = 14
integer y = 108
integer width = 1408
integer height = 1592
integer taborder = 11
boolean bringtotop = true
boolean vscrollbar = true
end type

event materials_loaded;call super::materials_loaded;search_type = current_search

st_top_20.backcolor = color_object
st_category.backcolor = color_object
st_description.backcolor = color_object

st_search_status.text = ps_description

CHOOSE CASE current_search
	CASE "TOP20"
		st_top_20.backcolor = color_object_selected
		st_common_flag.visible = false
	CASE "CATEGORY"
		st_category.backcolor = color_object_selected
		st_common_flag.visible = true
	CASE "DESCRIPTION"
		st_description.backcolor = color_object_selected
		st_common_flag.visible = true
END CHOOSE

set_page(1, pb_up, pb_down, st_page)

end event

event selected;string ls_material_id
string ls_description

if lasttype <> 'compute' then
	ls_material_id = String(object.material_id[selected_row])
	ls_description = object.description[selected_row]
	select_material(ls_material_id, ls_description)
end if

end event

