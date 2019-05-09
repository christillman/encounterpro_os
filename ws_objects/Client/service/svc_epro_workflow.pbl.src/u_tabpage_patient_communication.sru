$PBExportHeader$u_tabpage_patient_communication.sru
forward
global type u_tabpage_patient_communication from u_tabpage
end type
type sle_locality_6 from singlelineedit within u_tabpage_patient_communication
end type
type st_locality_6_t from statictext within u_tabpage_patient_communication
end type
type sle_locality_5 from singlelineedit within u_tabpage_patient_communication
end type
type st_locality_5_t from statictext within u_tabpage_patient_communication
end type
type sle_locality_4 from singlelineedit within u_tabpage_patient_communication
end type
type st_locality_4_t from statictext within u_tabpage_patient_communication
end type
type sle_locality_3 from singlelineedit within u_tabpage_patient_communication
end type
type st_locality_3_t from statictext within u_tabpage_patient_communication
end type
type sle_locality_2 from singlelineedit within u_tabpage_patient_communication
end type
type st_locality_2_t from statictext within u_tabpage_patient_communication
end type
type sle_locality_1 from singlelineedit within u_tabpage_patient_communication
end type
type st_locality_1_t from statictext within u_tabpage_patient_communication
end type
type st_city_t from statictext within u_tabpage_patient_communication
end type
type sle_address_1 from singlelineedit within u_tabpage_patient_communication
end type
type st_address1_t from statictext within u_tabpage_patient_communication
end type
type st_address_2_title from statictext within u_tabpage_patient_communication
end type
type sle_address_2 from singlelineedit within u_tabpage_patient_communication
end type
type sle_state from singlelineedit within u_tabpage_patient_communication
end type
type sle_zip from singlelineedit within u_tabpage_patient_communication
end type
type sle_city from singlelineedit within u_tabpage_patient_communication
end type
type st_zip_t from statictext within u_tabpage_patient_communication
end type
type st_state_t from statictext within u_tabpage_patient_communication
end type
type st_title from statictext within u_tabpage_patient_communication
end type
type dw_communication from u_dw_pick_list within u_tabpage_patient_communication
end type
type st_cpr_id from statictext within u_tabpage_patient_communication
end type
end forward

global type u_tabpage_patient_communication from u_tabpage
integer width = 2875
integer height = 1272
string text = "none"
sle_locality_6 sle_locality_6
st_locality_6_t st_locality_6_t
sle_locality_5 sle_locality_5
st_locality_5_t st_locality_5_t
sle_locality_4 sle_locality_4
st_locality_4_t st_locality_4_t
sle_locality_3 sle_locality_3
st_locality_3_t st_locality_3_t
sle_locality_2 sle_locality_2
st_locality_2_t st_locality_2_t
sle_locality_1 sle_locality_1
st_locality_1_t st_locality_1_t
st_city_t st_city_t
sle_address_1 sle_address_1
st_address1_t st_address1_t
st_address_2_title st_address_2_title
sle_address_2 sle_address_2
sle_state sle_state
sle_zip sle_zip
sle_city sle_city
st_zip_t st_zip_t
st_state_t st_state_t
st_title st_title
dw_communication dw_communication
st_cpr_id st_cpr_id
end type
global u_tabpage_patient_communication u_tabpage_patient_communication

type variables

boolean dw_has_focus

w_patient_data w_container
end variables

forward prototypes
public function integer initialize ()
public subroutine update_value (long pl_row, string ps_new_value)
public subroutine set_all_locality_visibility (boolean pb_visible)
public subroutine highlight_sle (singlelineedit pwo_control, boolean pb_on)
public subroutine get_localities ()
public subroutine refresh ()
end prototypes

public function integer initialize ();integer li_sts
string ls_temp
u_ds_data luo_data 
long ll_count
long i

if isnull(current_patient) then
	log.log(this, "u_tabpage_patient_communication.initialize:0008", "No current patient", 4)
	return -1
else
	st_cpr_id.text = current_patient.cpr_id
end if

// Avoid Americanisms 
if NOT IsNull(gnv_app.locale) AND gnv_app.locale = "en_us" then
	set_all_locality_visibility(false)

else
	// some day may have a case statement for locale?
	// Hide the U.S. fields
	sle_address_2.visible = false
	sle_city.visible = false
	sle_state.visible = false
	sle_zip.visible = false
	
	st_address_2_title.visible = false
	st_city_t.visible = false
	st_state_t.visible = false
	st_zip_t.visible = false
	
	set_all_locality_visibility(true)
	
	get_localities()
end if

return 1

end function

public subroutine update_value (long pl_row, string ps_new_value);

dw_communication.object.communication_value[pl_row] = ps_new_value

end subroutine

public subroutine set_all_locality_visibility (boolean pb_visible);
st_locality_1_t.visible = pb_visible
sle_locality_1.visible = pb_visible
st_locality_2_t.visible = pb_visible
sle_locality_2.visible = pb_visible
st_locality_3_t.visible = pb_visible
sle_locality_3.visible = pb_visible
st_locality_4_t.visible = pb_visible
sle_locality_4.visible = pb_visible
st_locality_5_t.visible = pb_visible
sle_locality_5.visible = pb_visible
st_locality_6_t.visible = pb_visible
sle_locality_6.visible = pb_visible


end subroutine

public subroutine highlight_sle (singlelineedit pwo_control, boolean pb_on);
IF pb_on THEN
	pwo_control.backcolor = COLOR_LIGHT_YELLOW
ELSE
	IF NOT f_is_empty_string(pwo_control.text) THEN
		pwo_control.backcolor = COLOR_WHITE
	END IF
END IF
end subroutine

public subroutine get_localities ();
integer li_item_count, li_item, li_locality_count
integer li_locality_index
u_ds_data lds_selected_localities

lds_selected_localities = CREATE u_ds_data
lds_selected_localities.set_dataobject("dw_list_items_active")
li_locality_count = lds_selected_localities.retrieve("Locality")

// List items are ordered by sort_sequence, list_item
// The sort_sequence determines which one becomes Locality 1, etc.
// or, if sort_sequence hasn't been set, they appear alphabetically
// BTW the sort sequence is set in w_pick_list_members, WYSIWYG

li_item_count = UpperBound(current_patient.list_item)

FOR li_locality_index = 1 TO li_locality_count	
	CHOOSE CASE li_locality_index
		CASE 1
			st_locality_1_t.visible = true
			st_locality_1_t.text = lds_selected_localities.object.list_item[li_locality_index]
			sle_locality_1.visible = true
		CASE 2
			st_locality_2_t.visible = true
			st_locality_2_t.text = lds_selected_localities.object.list_item[li_locality_index]
			sle_locality_2.visible = true
		CASE 3
			st_locality_3_t.visible = true
			st_locality_3_t.text = lds_selected_localities.object.list_item[li_locality_index]
			sle_locality_3.visible = true
		CASE 4
			st_locality_4_t.visible = true
			st_locality_4_t.text = lds_selected_localities.object.list_item[li_locality_index]
			sle_locality_4.visible = true
		CASE 5
			st_locality_5_t.visible = true
			st_locality_5_t.text = lds_selected_localities.object.list_item[li_locality_index]
			sle_locality_5.visible = true
		CASE 6
			st_locality_6_t.visible = true
			st_locality_6_t.text = lds_selected_localities.object.list_item[li_locality_index]
			sle_locality_6.visible = true
		CASE ELSE
			log.log(this, "w_edit_patient_data.get_localities:0044", "Too many locality types", 4)
	END CHOOSE

	FOR li_item = 1 TO li_item_count
		IF current_patient.list_item[li_item].list_id = "Locality" &
				AND current_patient.list_item[li_item].list_item = lds_selected_localities.object.list_item[li_locality_index] THEN
			CHOOSE CASE li_locality_index
				CASE 1
					sle_locality_1.text = current_patient.list_item[li_item].list_item_patient_data
				CASE 2
					sle_locality_2.text = current_patient.list_item[li_item].list_item_patient_data
				CASE 3
					sle_locality_3.text = current_patient.list_item[li_item].list_item_patient_data
				CASE 4
					sle_locality_4.text = current_patient.list_item[li_item].list_item_patient_data
				CASE 5
					sle_locality_5.text = current_patient.list_item[li_item].list_item_patient_data
				CASE 6
					sle_locality_6.text = current_patient.list_item[li_item].list_item_patient_data
			END CHOOSE
		END IF
	NEXT
NEXT


end subroutine

public subroutine refresh ();u_ds_data luo_types
u_ds_data luo_names
u_ds_data luo_progress
long ll_name_count
long ll_type_count
long i, j
long ll_null
string ls_communication_type
string ls_communication_name
string ls_progress_type
long ll_row
long ll_progress_count
string ls_communication_value
string ls_find


setnull(ll_null)

st_title.width = width

dw_communication.x = (width - dw_communication.width) / 2
dw_communication.height = height - dw_communication.y - 100


sle_address_1.text = current_patient.address_line_1
sle_address_2.text = current_patient.address_line_2
sle_city.text = current_patient.city
sle_zip.text = current_patient.zip
sle_state.text = current_patient.state


luo_types = CREATE u_ds_data
luo_names = CREATE u_ds_data
luo_progress = CREATE u_ds_data
luo_types.set_dataobject("dw_domain_notranslate_list")
luo_names.set_dataobject("dw_domain_notranslate_list")
luo_progress.set_dataobject("dw_p_Patient_Progress")

ll_type_count = luo_types.retrieve("Communication Type")

dw_communication.reset()

for i = 1 to ll_type_count
	ls_communication_type = luo_types.object.domain_item[i]
	ls_progress_type = wordcap("Communication " + ls_communication_type)
	ll_name_count = luo_names.retrieve(ls_progress_type)
	for j = 1 to ll_name_count
		ls_communication_name = luo_names.object.domain_item[j]
		ll_row = dw_communication.insertrow(0)
		dw_communication.object.communication_type[ll_row] = wordcap(ls_communication_type)
		dw_communication.object.progress_type[ll_row] = ls_progress_type
		dw_communication.object.communication_name[ll_row] = wordcap(ls_communication_name)
	next
	ll_progress_count = luo_progress.retrieve(current_patient.cpr_id, ls_progress_type)
	for j = 1 to ll_progress_count
		ls_communication_name = luo_progress.object.progress_key[j]
		ls_communication_value = luo_progress.object.progress[j]
		ls_find = "progress_type='" + ls_progress_type + "' and communication_name='" + ls_communication_name + "'"
		ll_row = dw_communication.find(ls_find, 1, dw_communication.rowcount())
		if ll_row > 0 then
			dw_communication.object.communication_value[ll_row] = ls_communication_value
		else
			ll_row = dw_communication.insertrow(0)
			dw_communication.object.communication_type[ll_row] = wordcap(ls_communication_type)
			dw_communication.object.progress_type[ll_row] = ls_progress_type
			dw_communication.object.communication_name[ll_row] = wordcap(ls_communication_name)
			dw_communication.object.communication_value[ll_row] = ls_communication_value
		end if
	next
next


DESTROY luo_types
DESTROY luo_names

dw_communication.setfocus()


end subroutine

on u_tabpage_patient_communication.create
int iCurrent
call super::create
this.sle_locality_6=create sle_locality_6
this.st_locality_6_t=create st_locality_6_t
this.sle_locality_5=create sle_locality_5
this.st_locality_5_t=create st_locality_5_t
this.sle_locality_4=create sle_locality_4
this.st_locality_4_t=create st_locality_4_t
this.sle_locality_3=create sle_locality_3
this.st_locality_3_t=create st_locality_3_t
this.sle_locality_2=create sle_locality_2
this.st_locality_2_t=create st_locality_2_t
this.sle_locality_1=create sle_locality_1
this.st_locality_1_t=create st_locality_1_t
this.st_city_t=create st_city_t
this.sle_address_1=create sle_address_1
this.st_address1_t=create st_address1_t
this.st_address_2_title=create st_address_2_title
this.sle_address_2=create sle_address_2
this.sle_state=create sle_state
this.sle_zip=create sle_zip
this.sle_city=create sle_city
this.st_zip_t=create st_zip_t
this.st_state_t=create st_state_t
this.st_title=create st_title
this.dw_communication=create dw_communication
this.st_cpr_id=create st_cpr_id
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_locality_6
this.Control[iCurrent+2]=this.st_locality_6_t
this.Control[iCurrent+3]=this.sle_locality_5
this.Control[iCurrent+4]=this.st_locality_5_t
this.Control[iCurrent+5]=this.sle_locality_4
this.Control[iCurrent+6]=this.st_locality_4_t
this.Control[iCurrent+7]=this.sle_locality_3
this.Control[iCurrent+8]=this.st_locality_3_t
this.Control[iCurrent+9]=this.sle_locality_2
this.Control[iCurrent+10]=this.st_locality_2_t
this.Control[iCurrent+11]=this.sle_locality_1
this.Control[iCurrent+12]=this.st_locality_1_t
this.Control[iCurrent+13]=this.st_city_t
this.Control[iCurrent+14]=this.sle_address_1
this.Control[iCurrent+15]=this.st_address1_t
this.Control[iCurrent+16]=this.st_address_2_title
this.Control[iCurrent+17]=this.sle_address_2
this.Control[iCurrent+18]=this.sle_state
this.Control[iCurrent+19]=this.sle_zip
this.Control[iCurrent+20]=this.sle_city
this.Control[iCurrent+21]=this.st_zip_t
this.Control[iCurrent+22]=this.st_state_t
this.Control[iCurrent+23]=this.st_title
this.Control[iCurrent+24]=this.dw_communication
this.Control[iCurrent+25]=this.st_cpr_id
end on

on u_tabpage_patient_communication.destroy
call super::destroy
destroy(this.sle_locality_6)
destroy(this.st_locality_6_t)
destroy(this.sle_locality_5)
destroy(this.st_locality_5_t)
destroy(this.sle_locality_4)
destroy(this.st_locality_4_t)
destroy(this.sle_locality_3)
destroy(this.st_locality_3_t)
destroy(this.sle_locality_2)
destroy(this.st_locality_2_t)
destroy(this.sle_locality_1)
destroy(this.st_locality_1_t)
destroy(this.st_city_t)
destroy(this.sle_address_1)
destroy(this.st_address1_t)
destroy(this.st_address_2_title)
destroy(this.sle_address_2)
destroy(this.sle_state)
destroy(this.sle_zip)
destroy(this.sle_city)
destroy(this.st_zip_t)
destroy(this.st_state_t)
destroy(this.st_title)
destroy(this.dw_communication)
destroy(this.st_cpr_id)
end on

type sle_locality_6 from singlelineedit within u_tabpage_patient_communication
integer x = 1682
integer y = 468
integer width = 768
integer height = 104
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;
w_container.set_patient_list_item("Locality", st_locality_6_t.text, text)
highlight_sle(this, false)

end event

type st_locality_6_t from statictext within u_tabpage_patient_communication
integer x = 1339
integer y = 484
integer width = 325
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Locality 6"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_locality_5 from singlelineedit within u_tabpage_patient_communication
integer x = 544
integer y = 468
integer width = 768
integer height = 104
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;
w_container.set_patient_list_item("Locality", st_locality_5_t.text, text)
highlight_sle(this, false)

end event

type st_locality_5_t from statictext within u_tabpage_patient_communication
integer x = 201
integer y = 484
integer width = 320
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Locality 5"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_locality_4 from singlelineedit within u_tabpage_patient_communication
integer x = 1682
integer y = 348
integer width = 768
integer height = 104
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;
w_container.set_patient_list_item("Locality", st_locality_4_t.text, text)
highlight_sle(this, false)

end event

type st_locality_4_t from statictext within u_tabpage_patient_communication
integer x = 1339
integer y = 364
integer width = 325
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Locality 4"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_locality_3 from singlelineedit within u_tabpage_patient_communication
integer x = 544
integer y = 348
integer width = 768
integer height = 104
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;
w_container.set_patient_list_item("Locality", st_locality_3_t.text, text)
highlight_sle(this, false)

end event

type st_locality_3_t from statictext within u_tabpage_patient_communication
integer x = 201
integer y = 364
integer width = 320
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Locality 3"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_locality_2 from singlelineedit within u_tabpage_patient_communication
integer x = 1682
integer y = 228
integer width = 768
integer height = 104
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;
w_container.set_patient_list_item("Locality", st_locality_2_t.text, text)
highlight_sle(this, false)

end event

type st_locality_2_t from statictext within u_tabpage_patient_communication
integer x = 1339
integer y = 244
integer width = 325
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Locality 2"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_locality_1 from singlelineedit within u_tabpage_patient_communication
integer x = 544
integer y = 228
integer width = 768
integer height = 104
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;
w_container.set_patient_list_item("Locality", st_locality_1_t.text, text)
highlight_sle(this, false)

end event

type st_locality_1_t from statictext within u_tabpage_patient_communication
integer x = 201
integer y = 244
integer width = 320
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Locality 1"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_city_t from statictext within u_tabpage_patient_communication
integer x = 357
integer y = 360
integer width = 174
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "City"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_address_1 from singlelineedit within u_tabpage_patient_communication
integer x = 549
integer y = 104
integer width = 1902
integer height = 108
integer taborder = 10
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;
if f_string_modified(current_patient.address_line_1, text) then
	current_patient.modify_patient("address_line_1", text)
	text = current_patient.address_line_1
end if

end event

type st_address1_t from statictext within u_tabpage_patient_communication
integer x = 242
integer y = 120
integer width = 297
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Address 1"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_address_2_title from statictext within u_tabpage_patient_communication
integer x = 242
integer y = 240
integer width = 297
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Address 2"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_address_2 from singlelineedit within u_tabpage_patient_communication
integer x = 549
integer y = 224
integer width = 955
integer height = 108
integer taborder = 10
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;if f_string_modified(current_patient.address_line_2, text) then
	current_patient.modify_patient("address_line_2", text)
	text = current_patient.address_line_2
end if

end event

type sle_state from singlelineedit within u_tabpage_patient_communication
integer x = 1161
integer y = 344
integer width = 169
integer height = 104
integer taborder = 20
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;text = left(text,2)

if f_string_modified(current_patient.state, text) then
	current_patient.modify_patient("state", text)
	text = current_patient.state
end if

end event

type sle_zip from singlelineedit within u_tabpage_patient_communication
integer x = 1559
integer y = 344
integer width = 352
integer height = 104
integer taborder = 20
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;text = left(text,10)

if f_string_modified(current_patient.zip, text) then
	current_patient.modify_patient("zip", text)
	text = current_patient.zip
end if

end event

type sle_city from singlelineedit within u_tabpage_patient_communication
integer x = 549
integer y = 344
integer width = 352
integer height = 104
integer taborder = 10
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;text = left(text,40)
if f_string_modified(current_patient.city, text) then
	current_patient.modify_patient("city", text)
	text = current_patient.city
end if

end event

type st_zip_t from statictext within u_tabpage_patient_communication
integer x = 1408
integer y = 360
integer width = 137
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Zip"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_state_t from statictext within u_tabpage_patient_communication
integer x = 969
integer y = 360
integer width = 174
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "State"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_title from statictext within u_tabpage_patient_communication
integer width = 2871
integer height = 116
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Patient Communication"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_communication from u_dw_pick_list within u_tabpage_patient_communication
event ue_accepttext ( )
integer x = 261
integer y = 592
integer width = 2414
integer height = 660
integer taborder = 10
string dataobject = "dw_patient_communication_data"
boolean vscrollbar = true
end type

event ue_accepttext();IF dw_has_focus = FALSE THEN
	dw_communication.accepttext( )
END IF


end event

event itemchanged;call super::itemchanged;integer li_sts
long ll_null
string ls_communication_type
string ls_communication_name
string ls_progress_type
string ls_communication_value

setnull(ll_null)

ls_communication_type = object.communication_type[row]
ls_communication_name = object.communication_name[row]
ls_communication_value = data
ls_progress_type = object.progress_type[row]

CHOOSE CASE lower(ls_communication_type)
	CASE "phone"
		ls_communication_value = sqlca.fn_pretty_phone(ls_communication_value)
END CHOOSE

li_sts = f_set_progress(current_patient.cpr_id, &
							"Patient", &
							ll_null, &
							ls_progress_type, &
							ls_communication_name, &
							ls_communication_value, &
							datetime(today(), now()), &
							ll_null, &
							ll_null, &
							ll_null)


dwo.primary[row] = ls_communication_value
This.SetText(ls_communication_value)

function POST update_value(row, ls_communication_value)
end event

event getfocus;call super::getfocus;dw_has_focus = TRUE

end event

event losefocus;call super::losefocus;dw_has_focus = FALSE
dw_communication.event  post ue_acceptText( )

end event

type st_cpr_id from statictext within u_tabpage_patient_communication
integer x = 9
integer y = 1188
integer width = 375
integer height = 72
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

