HA$PBExportHeader$u_tabpage_patient_communication.sru
forward
global type u_tabpage_patient_communication from u_tabpage
end type
type st_6 from statictext within u_tabpage_patient_communication
end type
type sle_address_1 from singlelineedit within u_tabpage_patient_communication
end type
type st_1 from statictext within u_tabpage_patient_communication
end type
type st_2 from statictext within u_tabpage_patient_communication
end type
type sle_address_2 from singlelineedit within u_tabpage_patient_communication
end type
type sle_state from singlelineedit within u_tabpage_patient_communication
end type
type sle_zip from singlelineedit within u_tabpage_patient_communication
end type
type sle_city from singlelineedit within u_tabpage_patient_communication
end type
type st_7 from statictext within u_tabpage_patient_communication
end type
type st_9 from statictext within u_tabpage_patient_communication
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
st_6 st_6
sle_address_1 sle_address_1
st_1 st_1
st_2 st_2
sle_address_2 sle_address_2
sle_state sle_state
sle_zip sle_zip
sle_city sle_city
st_7 st_7
st_9 st_9
st_title st_title
dw_communication dw_communication
st_cpr_id st_cpr_id
end type
global u_tabpage_patient_communication u_tabpage_patient_communication

type variables
boolean dw_has_focus
end variables

forward prototypes
public function integer initialize ()
public subroutine refresh ()
public subroutine update_value (long pl_row, string ps_new_value)
end prototypes

public function integer initialize ();integer li_sts
string ls_temp
u_ds_data luo_data 
long ll_count
long i

if isnull(current_patient) then
	log.log(this, "initialize()", "No current patient", 4)
	return -1
else
	st_cpr_id.text = current_patient.cpr_id
end if


return 1

end function

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

public subroutine update_value (long pl_row, string ps_new_value);

dw_communication.object.communication_value[pl_row] = ps_new_value

end subroutine

on u_tabpage_patient_communication.create
int iCurrent
call super::create
this.st_6=create st_6
this.sle_address_1=create sle_address_1
this.st_1=create st_1
this.st_2=create st_2
this.sle_address_2=create sle_address_2
this.sle_state=create sle_state
this.sle_zip=create sle_zip
this.sle_city=create sle_city
this.st_7=create st_7
this.st_9=create st_9
this.st_title=create st_title
this.dw_communication=create dw_communication
this.st_cpr_id=create st_cpr_id
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_6
this.Control[iCurrent+2]=this.sle_address_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.sle_address_2
this.Control[iCurrent+6]=this.sle_state
this.Control[iCurrent+7]=this.sle_zip
this.Control[iCurrent+8]=this.sle_city
this.Control[iCurrent+9]=this.st_7
this.Control[iCurrent+10]=this.st_9
this.Control[iCurrent+11]=this.st_title
this.Control[iCurrent+12]=this.dw_communication
this.Control[iCurrent+13]=this.st_cpr_id
end on

on u_tabpage_patient_communication.destroy
call super::destroy
destroy(this.st_6)
destroy(this.sle_address_1)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_address_2)
destroy(this.sle_state)
destroy(this.sle_zip)
destroy(this.sle_city)
destroy(this.st_7)
destroy(this.st_9)
destroy(this.st_title)
destroy(this.dw_communication)
destroy(this.st_cpr_id)
end on

type st_6 from statictext within u_tabpage_patient_communication
integer x = 1678
integer y = 184
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
integer y = 168
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

event modified;if f_string_modified(current_patient.address_line_1, text) then
	current_patient.modify_patient("address_line_1", text)
	text = current_patient.address_line_1
end if

end event

type st_1 from statictext within u_tabpage_patient_communication
integer x = 242
integer y = 184
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

type st_2 from statictext within u_tabpage_patient_communication
integer x = 242
integer y = 324
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
integer y = 308
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
integer x = 1870
integer y = 308
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
integer x = 2267
integer y = 308
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
integer x = 1870
integer y = 168
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

type st_7 from statictext within u_tabpage_patient_communication
integer x = 2117
integer y = 324
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

type st_9 from statictext within u_tabpage_patient_communication
integer x = 1678
integer y = 324
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
integer y = 508
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

