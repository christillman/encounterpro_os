$PBExportHeader$u_tabpage_patient_user_defined.sru
forward
global type u_tabpage_patient_user_defined from u_tabpage
end type
type st_property_title from statictext within u_tabpage_patient_user_defined
end type
type st_property_title_title from statictext within u_tabpage_patient_user_defined
end type
type sle_progress from singlelineedit within u_tabpage_patient_user_defined
end type
type cb_new_property from commandbutton within u_tabpage_patient_user_defined
end type
type st_value_title from statictext within u_tabpage_patient_user_defined
end type
type pb_up from u_picture_button within u_tabpage_patient_user_defined
end type
type pb_down from u_picture_button within u_tabpage_patient_user_defined
end type
type st_page from statictext within u_tabpage_patient_user_defined
end type
type st_title from statictext within u_tabpage_patient_user_defined
end type
type dw_domain from u_dw_pick_list within u_tabpage_patient_user_defined
end type
type st_none from statictext within u_tabpage_patient_user_defined
end type
end forward

global type u_tabpage_patient_user_defined from u_tabpage
integer width = 2779
integer height = 1268
string text = "none"
st_property_title st_property_title
st_property_title_title st_property_title_title
sle_progress sle_progress
cb_new_property cb_new_property
st_value_title st_value_title
pb_up pb_up
pb_down pb_down
st_page st_page
st_title st_title
dw_domain dw_domain
st_none st_none
end type
global u_tabpage_patient_user_defined u_tabpage_patient_user_defined

type variables

end variables

forward prototypes
public subroutine new_property ()
public function integer display_properties ()
public subroutine refresh ()
public function integer initialize ()
end prototypes

public subroutine new_property ();str_popup popup
str_popup_return popup_return
string ls_function_name
string ls_description
integer li_count
string ls_temp

popup.title = "Please enter description for the new property"
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_description = trim(popup_return.items[1])
ls_function_name = left(ls_description, 35)
li_count = 1

// Make sure the function_name is unique among user defined properties
DO
	if li_count > 1 then
		ls_function_name = left(ls_description, 35) + " (" + string(li_count) + ")"
	end if
	
	SELECT CAST(id AS varchar(38))
	INTO :ls_temp
	FROM c_Property
	WHERE property_type = 'User Defined'
	AND property_object = 'Patient'
	AND function_name = :ls_function_name;
	if not tf_check() then return
	if sqlca.sqlcode = 100 then exit
	
	li_count += 1
	// Quit after 100 tries
	if li_count >= 100 then
		openwithparm(w_pop_message, "Unable to generate unique property name")
		return
	end if
LOOP WHILE true


// Create the new property
INSERT INTO c_Property (
	property_type,
	property_object,
	description,
	function_name,
	status)
VALUES (
	'User Defined',
	'Patient',
	:ls_description,
	:ls_function_name,
	'OK');
if not tf_check() then return

display_properties()

end subroutine

public function integer display_properties ();long ll_count
string ls_progress_key
long i
str_property_value lstr_property
str_attributes lstr_attributes
long ll_null

setnull(ll_null)

dw_domain.object.compute_display.width = dw_domain.width - 110
dw_domain.settransobject(sqlca)
ll_count = dw_domain.retrieve()
if ll_count < 0 then return -1
if ll_count = 0 then
	dw_domain.visible = false
	st_title.visible = false
	pb_up.visible = false
	pb_down.visible = false
	st_page.visible = false
	st_none.visible = true
	return 0
else
	dw_domain.visible = true
	st_title.visible = true
	pb_up.visible = true
	pb_down.visible = true
	st_page.visible = true
	st_none.visible = false
end if


for i = 1 to ll_count
	ls_progress_key = dw_domain.object.function_name[i]
	lstr_property = f_get_property("Patient", ls_progress_key, ll_null, lstr_attributes)
	dw_domain.object.original_progress[i] = lstr_property.value
	dw_domain.object.progress[i] = lstr_property.value
next


dw_domain.set_page(1, pb_up, pb_down, st_page)

if ll_count <= 0 then
	text = "User Defined"
else
	text = "User Defined (" + string(ll_count) + ")"
end if

return 1


end function

public subroutine refresh ();display_properties()


end subroutine

public function integer initialize ();long ll_count
string ls_progress_key
string ls_progress_value
long i

if current_user.check_privilege("Super User") then
	cb_new_property.visible = true
else
	cb_new_property.visible = false
end if

dw_domain.settransobject(sqlca)


return 1


end function

on u_tabpage_patient_user_defined.create
int iCurrent
call super::create
this.st_property_title=create st_property_title
this.st_property_title_title=create st_property_title_title
this.sle_progress=create sle_progress
this.cb_new_property=create cb_new_property
this.st_value_title=create st_value_title
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
this.st_title=create st_title
this.dw_domain=create dw_domain
this.st_none=create st_none
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_property_title
this.Control[iCurrent+2]=this.st_property_title_title
this.Control[iCurrent+3]=this.sle_progress
this.Control[iCurrent+4]=this.cb_new_property
this.Control[iCurrent+5]=this.st_value_title
this.Control[iCurrent+6]=this.pb_up
this.Control[iCurrent+7]=this.pb_down
this.Control[iCurrent+8]=this.st_page
this.Control[iCurrent+9]=this.st_title
this.Control[iCurrent+10]=this.dw_domain
this.Control[iCurrent+11]=this.st_none
end on

on u_tabpage_patient_user_defined.destroy
call super::destroy
destroy(this.st_property_title)
destroy(this.st_property_title_title)
destroy(this.sle_progress)
destroy(this.cb_new_property)
destroy(this.st_value_title)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
destroy(this.st_title)
destroy(this.dw_domain)
destroy(this.st_none)
end on

type st_property_title from statictext within u_tabpage_patient_user_defined
boolean visible = false
integer x = 1742
integer y = 272
integer width = 672
integer height = 96
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
long ll_row
long ll_property_id
integer li_sts

ll_row = dw_domain.get_selected_row()
if ll_row <= 0 then return

ll_property_id = dw_domain.object.property_id[ll_row]
if isnull(ll_property_id) or ll_property_id <= 0 then return

popup.title = "Enter a short title for this patient property"
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

UPDATE c_Property
SET title = :popup_return.items[1]
WHERE property_id = :ll_property_id;
if not tf_check() then return

dw_domain.object.title[ll_row] = popup_return.items[1]
text = popup_return.items[1]

datalist.clear_cache("properties")


end event

type st_property_title_title from statictext within u_tabpage_patient_user_defined
boolean visible = false
integer x = 1911
integer y = 192
integer width = 334
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Short Title"
boolean focusrectangle = false
end type

type sle_progress from singlelineedit within u_tabpage_patient_user_defined
boolean visible = false
integer x = 1573
integer y = 628
integer width = 1019
integer height = 96
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;long ll_row
string ls_progress
string ls_progress_key
integer li_sts

ll_row = dw_domain.get_selected_row()
if ll_row <= 0 then return

ls_progress_key = dw_domain.object.function_name[ll_row]
ls_progress = dw_domain.object.progress[ll_row]
if f_string_modified(ls_progress, text) then
	li_sts = current_patient.set_property(ls_progress_key, text)
	if li_sts > 0 then dw_domain.object.progress[ll_row] = text
end if

dw_domain.clear_selected()


end event

type cb_new_property from commandbutton within u_tabpage_patient_user_defined
integer x = 1746
integer y = 936
integer width = 622
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Define New Property"
end type

event clicked;new_property()

end event

type st_value_title from statictext within u_tabpage_patient_user_defined
boolean visible = false
integer x = 1573
integer y = 556
integer width = 265
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Value:"
boolean focusrectangle = false
end type

type pb_up from u_picture_button within u_tabpage_patient_user_defined
integer x = 1445
integer y = 116
integer width = 137
integer height = 116
integer taborder = 20
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;string ls_temp

dw_domain.set_page(dw_domain.current_page - 1, st_page.text)
if dw_domain.current_page < 2 then
	enabled = false
end if

pb_down.enabled = true

end event

type pb_down from u_picture_button within u_tabpage_patient_user_defined
integer x = 1445
integer y = 248
integer width = 137
integer height = 116
integer taborder = 20
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;string ls_temp

dw_domain.set_page(dw_domain.current_page + 1, st_page.text)
if dw_domain.current_page >= dw_domain.last_page then
	enabled = false
end if

pb_up.enabled = true

end event

type st_page from statictext within u_tabpage_patient_user_defined
integer x = 1440
integer y = 376
integer width = 146
integer height = 100
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Page 99 of 99"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title from statictext within u_tabpage_patient_user_defined
integer x = 96
integer y = 12
integer width = 1339
integer height = 84
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "User Defined Patient Properties"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_domain from u_dw_pick_list within u_tabpage_patient_user_defined
integer x = 23
integer y = 104
integer width = 1408
integer height = 1080
integer taborder = 10
string dataobject = "dw_user_defined_patient_properties"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;st_value_title.visible = true
sle_progress.visible = true
st_property_title_title.visible = true
st_property_title.visible = true

st_property_title.text = object.title[selected_row]
sle_progress.text = object.progress[selected_row]

sle_progress.selecttext(1, len(sle_progress.text))
sle_progress.setfocus()

end event

event unselected;call super::unselected;st_value_title.visible = false
sle_progress.visible = false
st_property_title_title.visible = false
st_property_title.visible = false


end event

type st_none from statictext within u_tabpage_patient_user_defined
boolean visible = false
integer x = 361
integer y = 536
integer width = 2048
integer height = 140
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "No User Defined Properties Defined"
alignment alignment = center!
boolean focusrectangle = false
end type

