$PBExportHeader$w_edit_consultant.srw
forward
global type w_edit_consultant from w_window_base
end type
type tab_consultant from u_tab_consultant_info within w_edit_consultant
end type
type tab_consultant from u_tab_consultant_info within w_edit_consultant
end type
type cb_ok from commandbutton within w_edit_consultant
end type
type cb_cancel from commandbutton within w_edit_consultant
end type
type sle_description from singlelineedit within w_edit_consultant
end type
type st_10 from statictext within w_edit_consultant
end type
type st_specialty from statictext within w_edit_consultant
end type
type st_12 from statictext within w_edit_consultant
end type
type st_13 from statictext within w_edit_consultant
end type
end forward

global type w_edit_consultant from w_window_base
string title = "Consultant Information"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
tab_consultant tab_consultant
cb_ok cb_ok
cb_cancel cb_cancel
sle_description sle_description
st_10 st_10
st_specialty st_specialty
st_12 st_12
st_13 st_13
end type
global w_edit_consultant w_edit_consultant

type variables
string consultant_id
string specialty_id

end variables

forward prototypes
public function integer show_consultant ()
end prototypes

public function integer show_consultant ();long ll_owner_id

SELECT c.specialty_id,
		s.description,
		c.description,
		c.first_name,
		c.middle_name,
		c.last_name,
		c.degree,
		c.name_prefix,
		c.name_suffix,
		c.address1,
		c.address2,
		c.city,
		c.state,
		c.zip,
		c.phone,
		c.fax,
		c.email,
		c.phone2,
		c.contact,
		c.owner_id
INTO :specialty_id,
		:st_specialty.text,
		:sle_description.text,
		:tab_consultant.tabpage_general.sle_first_name.text,
		:tab_consultant.tabpage_general.sle_middle_name.text,
		:tab_consultant.tabpage_general.sle_last_name.text,
		:tab_consultant.tabpage_general.sle_degree.text,
		:tab_consultant.tabpage_general.sle_name_prefix.text,
		:tab_consultant.tabpage_general.sle_name_suffix.text,
		:tab_consultant.tabpage_address.sle_address1.text,
		:tab_consultant.tabpage_address.sle_address2.text,
		:tab_consultant.tabpage_address.sle_city.text,
		:tab_consultant.tabpage_address.sle_state.text,
		:tab_consultant.tabpage_address.sle_zip.text,
		:tab_consultant.tabpage_general.sle_phone.text,
		:tab_consultant.tabpage_general.sle_fax.text,
		:tab_consultant.tabpage_general.sle_email.text,
		:tab_consultant.tabpage_general.sle_phone2.text,
		:tab_consultant.tabpage_general.sle_contact.text,
		:ll_owner_id
FROM c_Consultant c, c_Specialty s
WHERE c.specialty_id = s.specialty_id
AND c.consultant_id = :consultant_id;
If not tf_check() then return -1
if sqlca.sqlcode = 100 then return 0

tab_consultant.tabpage_general.sle_owner_id.text = string(ll_owner_id)

return 1


end function

on w_edit_consultant.create
int iCurrent
call super::create
this.tab_consultant=create tab_consultant
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.sle_description=create sle_description
this.st_10=create st_10
this.st_specialty=create st_specialty
this.st_12=create st_12
this.st_13=create st_13
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_consultant
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.sle_description
this.Control[iCurrent+5]=this.st_10
this.Control[iCurrent+6]=this.st_specialty
this.Control[iCurrent+7]=this.st_12
this.Control[iCurrent+8]=this.st_13
end on

on w_edit_consultant.destroy
call super::destroy
destroy(this.tab_consultant)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.sle_description)
destroy(this.st_10)
destroy(this.st_specialty)
destroy(this.st_12)
destroy(this.st_13)
end on

event open;call super::open;str_c_consultant lstr_consultant
integer li_sts

consultant_id = message.stringparm

setnull(lstr_consultant.consultant_id)

If isnull(consultant_id) or len(consultant_id) <= 0 Then
	log.log(this,"w_edit_consultant.open.0009","Invalid Parameter",4)
	closewithreturn(this, lstr_consultant)
	Return
End If

li_sts = show_consultant()
if li_sts < 0 then
	log.log(this,"w_edit_consultant.open.0009","Error loading consultant (" + consultant_id + ")", 4)
	closewithreturn(this, lstr_consultant)
	Return
elseif li_sts = 0 then
	log.log(this,"w_edit_consultant.open.0009","Consultant not found (" + consultant_id + ")", 4)
	closewithreturn(this, lstr_consultant)
	Return
end if

tab_consultant.initialize(consultant_id)

sle_description.setfocus()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_edit_consultant
boolean visible = true
integer x = 1573
integer y = 1564
integer taborder = 140
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_edit_consultant
end type

type tab_consultant from u_tab_consultant_info within w_edit_consultant
integer y = 264
integer height = 1272
integer taborder = 20
boolean bringtotop = true
end type

type cb_ok from commandbutton within w_edit_consultant
integer x = 2409
integer y = 1564
integer width = 402
integer height = 112
integer taborder = 21
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;String ls_description,ls_consultant_id,ls_char
integer i

str_c_consultant lstr_consultant

ls_description = trim(sle_description.text)

If isnull(ls_description) Or len(ls_description) = 0 Then
	Openwithparm(w_pop_message,"Enter a valid Consultant name")
	sle_description.setfocus()
	Return
End If

If isnull(tab_consultant.tabpage_general.sle_phone.text) Or len(tab_consultant.tabpage_general.sle_phone.text) = 0 Then
	Openwithparm(w_pop_message,"Enter a valid phone number")
	tab_consultant.tabpage_general.sle_phone.setfocus()
	Return
End If

lstr_consultant.specialty_id = specialty_id
lstr_consultant.description = ls_description

lstr_consultant.first_name = tab_consultant.tabpage_general.sle_first_name.text
lstr_consultant.middle_name = tab_consultant.tabpage_general.sle_middle_name.text
lstr_consultant.last_name = tab_consultant.tabpage_general.sle_last_name.text
lstr_consultant.degree = tab_consultant.tabpage_general.sle_degree.text
lstr_consultant.name_prefix = tab_consultant.tabpage_general.sle_name_prefix.text
lstr_consultant.name_suffix = tab_consultant.tabpage_general.sle_name_suffix.text
lstr_consultant.phone = tab_consultant.tabpage_general.sle_phone.text
lstr_consultant.fax = tab_consultant.tabpage_general.sle_fax.text
lstr_consultant.email = tab_consultant.tabpage_general.sle_email.text
lstr_consultant.phone2 = tab_consultant.tabpage_general.sle_phone2.text
lstr_consultant.contact = tab_consultant.tabpage_general.sle_contact.text

if isnumber(tab_consultant.tabpage_general.sle_owner_id.text) then
	lstr_consultant.owner_id = long(tab_consultant.tabpage_general.sle_owner_id.text)
else
	setnull(lstr_consultant.owner_id)
end if

lstr_consultant.address1 = tab_consultant.tabpage_address.sle_address1.text
lstr_consultant.address2 = tab_consultant.tabpage_address.sle_address2.text
lstr_consultant.city = tab_consultant.tabpage_address.sle_city.text
lstr_consultant.state = tab_consultant.tabpage_address.sle_state.text
lstr_consultant.zip = tab_consultant.tabpage_address.sle_zip.text

Closewithreturn(parent,lstr_consultant)


end event

type cb_cancel from commandbutton within w_edit_consultant
integer x = 1911
integer y = 1564
integer width = 402
integer height = 112
integer taborder = 21
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

event clicked;str_c_consultant lstr_consultant

setnull(lstr_consultant.consultant_id)

closewithreturn(parent, lstr_consultant)

end event

type sle_description from singlelineedit within w_edit_consultant
integer x = 1376
integer y = 96
integer width = 1440
integer height = 104
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 80
borderstyle borderstyle = stylelowered!
end type

type st_10 from statictext within w_edit_consultant
integer x = 1934
integer y = 20
integer width = 384
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Description"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_specialty from statictext within w_edit_consultant
integer x = 78
integer y = 96
integer width = 1216
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_12 from statictext within w_edit_consultant
integer x = 558
integer y = 20
integer width = 315
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Specialty"
boolean focusrectangle = false
end type

type st_13 from statictext within w_edit_consultant
integer x = 1856
integer width = 91
integer height = 68
boolean bringtotop = true
integer textsize = -24
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 33538240
string text = "*"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_done from w_window_full_response`pb_done within w_edit_consultant
integer taborder = 120
end type

type pb_cancel from w_window_full_response`pb_cancel within w_edit_consultant
integer x = 2167
integer y = 1484
integer taborder = 130
end type

event pb_cancel::clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0
Closewithreturn(Parent,popup_return)
end event

