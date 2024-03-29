HA$PBExportHeader$w_svc_config_patient_materials.srw
forward
global type w_svc_config_patient_materials from w_window_base
end type
type st_search_title from statictext within w_svc_config_patient_materials
end type
type st_category from statictext within w_svc_config_patient_materials
end type
type st_top_20 from statictext within w_svc_config_patient_materials
end type
type st_search_status from statictext within w_svc_config_patient_materials
end type
type st_specialty from statictext within w_svc_config_patient_materials
end type
type st_specialty_title from statictext within w_svc_config_patient_materials
end type
type st_title from statictext within w_svc_config_patient_materials
end type
type st_description from statictext within w_svc_config_patient_materials
end type
type st_common_flag from statictext within w_svc_config_patient_materials
end type
type dw_materials from u_dw_patient_materials_list within w_svc_config_patient_materials
end type
type cb_new_material from commandbutton within w_svc_config_patient_materials
end type
type cb_new_material_url from commandbutton within w_svc_config_patient_materials
end type
type cb_ok from commandbutton within w_svc_config_patient_materials
end type
end forward

global type w_svc_config_patient_materials from w_window_base
integer height = 1836
windowtype windowtype = response!
st_search_title st_search_title
st_category st_category
st_top_20 st_top_20
st_search_status st_search_status
st_specialty st_specialty
st_specialty_title st_specialty_title
st_title st_title
st_description st_description
st_common_flag st_common_flag
dw_materials dw_materials
cb_new_material cb_new_material
cb_new_material_url cb_new_material_url
cb_ok cb_ok
end type
global w_svc_config_patient_materials w_svc_config_patient_materials

type variables
String procedure_type
string procedure_type_description
string specialty_id

string search_type

string common_flag = "Y"
end variables

event open;call super::open;specialty_id = current_user.specialty_id
dw_materials.specialty_id = current_user.common_list_id()

dw_materials.mode = "EDIT"

dw_materials.object.description.width = dw_materials.width - 150

dw_materials.initialize("PATIENTMTRL")

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

on w_svc_config_patient_materials.create
int iCurrent
call super::create
this.st_search_title=create st_search_title
this.st_category=create st_category
this.st_top_20=create st_top_20
this.st_search_status=create st_search_status
this.st_specialty=create st_specialty
this.st_specialty_title=create st_specialty_title
this.st_title=create st_title
this.st_description=create st_description
this.st_common_flag=create st_common_flag
this.dw_materials=create dw_materials
this.cb_new_material=create cb_new_material
this.cb_new_material_url=create cb_new_material_url
this.cb_ok=create cb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_search_title
this.Control[iCurrent+2]=this.st_category
this.Control[iCurrent+3]=this.st_top_20
this.Control[iCurrent+4]=this.st_search_status
this.Control[iCurrent+5]=this.st_specialty
this.Control[iCurrent+6]=this.st_specialty_title
this.Control[iCurrent+7]=this.st_title
this.Control[iCurrent+8]=this.st_description
this.Control[iCurrent+9]=this.st_common_flag
this.Control[iCurrent+10]=this.dw_materials
this.Control[iCurrent+11]=this.cb_new_material
this.Control[iCurrent+12]=this.cb_new_material_url
this.Control[iCurrent+13]=this.cb_ok
end on

on w_svc_config_patient_materials.destroy
call super::destroy
destroy(this.st_search_title)
destroy(this.st_category)
destroy(this.st_top_20)
destroy(this.st_search_status)
destroy(this.st_specialty)
destroy(this.st_specialty_title)
destroy(this.st_title)
destroy(this.st_description)
destroy(this.st_common_flag)
destroy(this.dw_materials)
destroy(this.cb_new_material)
destroy(this.cb_new_material_url)
destroy(this.cb_ok)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_svc_config_patient_materials
integer x = 2821
integer y = 128
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_config_patient_materials
end type

type st_search_title from statictext within w_svc_config_patient_materials
integer x = 1842
integer y = 544
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

type st_category from statictext within w_svc_config_patient_materials
integer x = 2331
integer y = 656
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

type st_top_20 from statictext within w_svc_config_patient_materials
integer x = 1573
integer y = 656
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

type st_search_status from statictext within w_svc_config_patient_materials
integer x = 1477
integer y = 792
integer width = 1312
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

type st_specialty from statictext within w_svc_config_patient_materials
integer x = 2030
integer y = 360
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

type st_specialty_title from statictext within w_svc_config_patient_materials
integer x = 1728
integer y = 360
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

type st_title from statictext within w_svc_config_patient_materials
integer width = 2926
integer height = 108
integer textsize = -14
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Patient Education Material Configuration"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_description from statictext within w_svc_config_patient_materials
integer x = 1952
integer y = 656
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

type st_common_flag from statictext within w_svc_config_patient_materials
integer x = 2592
integer y = 552
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

type dw_materials from u_dw_patient_materials_list within w_svc_config_patient_materials
integer x = 14
integer y = 108
integer width = 1413
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


end event

event selected;call super::selected;if lasttype <> 'compute' then
	material_menu(selected_row)
end if
clear_selected()

end event

type cb_new_material from commandbutton within w_svc_config_patient_materials
integer x = 1765
integer y = 1060
integer width = 736
integer height = 112
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Material From File(s)"
end type

event clicked;//////////////////////////////////////////////////////////////////////////////////////
//
// Description: Open common dialog box to select one or more files
//
// Created By:Sumathi Chinnasamy										Creation dt: 01/31/2000
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

type cb_new_material_url from commandbutton within w_svc_config_patient_materials
integer x = 1765
integer y = 1236
integer width = 736
integer height = 112
integer taborder = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Material From URL"
end type

event clicked;
Open(w_new_material_url)

dw_materials.search()


end event

type cb_ok from commandbutton within w_svc_config_patient_materials
integer x = 2432
integer y = 1584
integer width = 402
integer height = 112
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;Close(Parent)
end event

