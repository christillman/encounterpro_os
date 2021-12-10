$PBExportHeader$u_tabpage_user_contact_info.sru
forward
global type u_tabpage_user_contact_info from u_tabpage_user_base
end type
type st_phone from statictext within u_tabpage_user_contact_info
end type
type sle_phone from singlelineedit within u_tabpage_user_contact_info
end type
type st_phone1 from statictext within u_tabpage_user_contact_info
end type
type sle_fax from singlelineedit within u_tabpage_user_contact_info
end type
type sle_phone2 from singlelineedit within u_tabpage_user_contact_info
end type
type st_ph2 from statictext within u_tabpage_user_contact_info
end type
type sle_address1 from singlelineedit within u_tabpage_user_contact_info
end type
type sle_address2 from singlelineedit within u_tabpage_user_contact_info
end type
type st_addr1 from statictext within u_tabpage_user_contact_info
end type
type st_addr2 from statictext within u_tabpage_user_contact_info
end type
type sle_city from singlelineedit within u_tabpage_user_contact_info
end type
type st_city from statictext within u_tabpage_user_contact_info
end type
type sle_state from singlelineedit within u_tabpage_user_contact_info
end type
type st_state from statictext within u_tabpage_user_contact_info
end type
type st_zip from statictext within u_tabpage_user_contact_info
end type
type sle_zip from singlelineedit within u_tabpage_user_contact_info
end type
type sle_email_address from singlelineedit within u_tabpage_user_contact_info
end type
type st_email_address_title from statictext within u_tabpage_user_contact_info
end type
end forward

global type u_tabpage_user_contact_info from u_tabpage_user_base
string tag = "All"
integer width = 2921
integer height = 1312
st_phone st_phone
sle_phone sle_phone
st_phone1 st_phone1
sle_fax sle_fax
sle_phone2 sle_phone2
st_ph2 st_ph2
sle_address1 sle_address1
sle_address2 sle_address2
st_addr1 st_addr1
st_addr2 st_addr2
sle_city sle_city
st_city st_city
sle_state sle_state
st_state st_state
st_zip st_zip
sle_zip sle_zip
sle_email_address sle_email_address
st_email_address_title st_email_address_title
end type
global u_tabpage_user_contact_info u_tabpage_user_contact_info

type variables
long address_index
long phone_index
long phone2_index
long fax_index
long email_index

end variables

forward prototypes
public subroutine set_fields ()
public subroutine refresh ()
public function integer initialize ()
end prototypes

public subroutine set_fields ();

return

end subroutine

public subroutine refresh ();
sle_address1.text	= user.address[address_index].address_line_1
sle_address2.text	= user.address[address_index].address_line_2
sle_city.text	= user.address[address_index].city
sle_state.text	= user.address[address_index].state
sle_zip.text	= user.address[address_index].zip

sle_phone.text	= user.communication[phone_index].communication_value
sle_phone2.text	= user.communication[phone2_index].communication_value
sle_fax.text	= user.communication[fax_index].communication_value
sle_email_address.text	= user.communication[email_index].communication_value


end subroutine

public function integer initialize ();address_index = user.get_address_index("Address")
phone_index = user.get_communication_index("Phone", "Phone")
phone2_index = user.get_communication_index("Phone", "Phone2")
fax_index = user.get_communication_index("Fax", "Fax")
email_index = user.get_communication_index("Email", "Email")

return 1

end function

on u_tabpage_user_contact_info.create
int iCurrent
call super::create
this.st_phone=create st_phone
this.sle_phone=create sle_phone
this.st_phone1=create st_phone1
this.sle_fax=create sle_fax
this.sle_phone2=create sle_phone2
this.st_ph2=create st_ph2
this.sle_address1=create sle_address1
this.sle_address2=create sle_address2
this.st_addr1=create st_addr1
this.st_addr2=create st_addr2
this.sle_city=create sle_city
this.st_city=create st_city
this.sle_state=create sle_state
this.st_state=create st_state
this.st_zip=create st_zip
this.sle_zip=create sle_zip
this.sle_email_address=create sle_email_address
this.st_email_address_title=create st_email_address_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_phone
this.Control[iCurrent+2]=this.sle_phone
this.Control[iCurrent+3]=this.st_phone1
this.Control[iCurrent+4]=this.sle_fax
this.Control[iCurrent+5]=this.sle_phone2
this.Control[iCurrent+6]=this.st_ph2
this.Control[iCurrent+7]=this.sle_address1
this.Control[iCurrent+8]=this.sle_address2
this.Control[iCurrent+9]=this.st_addr1
this.Control[iCurrent+10]=this.st_addr2
this.Control[iCurrent+11]=this.sle_city
this.Control[iCurrent+12]=this.st_city
this.Control[iCurrent+13]=this.sle_state
this.Control[iCurrent+14]=this.st_state
this.Control[iCurrent+15]=this.st_zip
this.Control[iCurrent+16]=this.sle_zip
this.Control[iCurrent+17]=this.sle_email_address
this.Control[iCurrent+18]=this.st_email_address_title
end on

on u_tabpage_user_contact_info.destroy
call super::destroy
destroy(this.st_phone)
destroy(this.sle_phone)
destroy(this.st_phone1)
destroy(this.sle_fax)
destroy(this.sle_phone2)
destroy(this.st_ph2)
destroy(this.sle_address1)
destroy(this.sle_address2)
destroy(this.st_addr1)
destroy(this.st_addr2)
destroy(this.sle_city)
destroy(this.st_city)
destroy(this.sle_state)
destroy(this.st_state)
destroy(this.st_zip)
destroy(this.sle_zip)
destroy(this.sle_email_address)
destroy(this.st_email_address_title)
end on

type st_phone from statictext within u_tabpage_user_contact_info
integer x = 416
integer y = 624
integer width = 219
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
string text = "Phone"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_phone from singlelineedit within u_tabpage_user_contact_info
integer x = 667
integer y = 608
integer width = 759
integer height = 104
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 32
borderstyle borderstyle = stylelowered!
end type

event modified;if len(trim(text)) > 0 then
	user.communication[phone_index].communication_value = text
else
	setnull(user.communication[phone_index].communication_value)
end if

user.update_communication(phone_index)

end event

type st_phone1 from statictext within u_tabpage_user_contact_info
integer x = 439
integer y = 928
integer width = 197
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
string text = "Fax"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_fax from singlelineedit within u_tabpage_user_contact_info
integer x = 667
integer y = 912
integer width = 759
integer height = 104
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 32
borderstyle borderstyle = stylelowered!
end type

event modified;if len(trim(text)) > 0 then
	user.communication[fax_index].communication_value = text
else
	setnull(user.communication[fax_index].communication_value)
end if

user.update_communication(fax_index)



end event

type sle_phone2 from singlelineedit within u_tabpage_user_contact_info
integer x = 667
integer y = 760
integer width = 759
integer height = 104
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 40
borderstyle borderstyle = stylelowered!
end type

event modified;if len(trim(text)) > 0 then
	user.communication[phone2_index].communication_value = text
else
	setnull(user.communication[phone2_index].communication_value)
end if

user.update_communication(phone2_index)



end event

type st_ph2 from statictext within u_tabpage_user_contact_info
integer x = 393
integer y = 776
integer width = 242
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
string text = "Phone 2"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_address1 from singlelineedit within u_tabpage_user_contact_info
integer x = 667
integer y = 152
integer width = 1979
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
integer limit = 40
borderstyle borderstyle = stylelowered!
end type

event modified;if len(trim(text)) > 0 then
	user.address[address_index].address_line_1 = text
else
	setnull(user.address[address_index].address_line_1)
end if

user.update_address(address_index)



end event

type sle_address2 from singlelineedit within u_tabpage_user_contact_info
integer x = 667
integer y = 304
integer width = 1979
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
integer limit = 40
borderstyle borderstyle = stylelowered!
end type

event modified;if len(trim(text)) > 0 then
	user.address[address_index].address_line_2 = text
else
	setnull(user.address[address_index].address_line_2)
end if

user.update_address(address_index)

end event

type st_addr1 from statictext within u_tabpage_user_contact_info
integer x = 197
integer y = 168
integer width = 439
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
string text = "Address Line 1"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_addr2 from statictext within u_tabpage_user_contact_info
integer x = 197
integer y = 320
integer width = 439
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
string text = "Address Line 2"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_city from singlelineedit within u_tabpage_user_contact_info
integer x = 667
integer y = 456
integer width = 741
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
integer limit = 40
borderstyle borderstyle = stylelowered!
end type

event modified;if len(trim(text)) > 0 then
	user.address[address_index].city = text
else
	setnull(user.address[address_index].city)
end if

user.update_address(address_index)

end event

type st_city from statictext within u_tabpage_user_contact_info
integer x = 512
integer y = 472
integer width = 123
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
string text = "City"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_state from singlelineedit within u_tabpage_user_contact_info
integer x = 1646
integer y = 456
integer width = 398
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
integer limit = 20
borderstyle borderstyle = stylelowered!
end type

event modified;if len(trim(text)) > 0 then
	user.address[address_index].state = text
else
	setnull(user.address[address_index].state)
end if

user.update_address(address_index)

end event

type st_state from statictext within u_tabpage_user_contact_info
integer x = 1440
integer y = 472
integer width = 174
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
string text = "State"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_zip from statictext within u_tabpage_user_contact_info
integer x = 2085
integer y = 472
integer width = 142
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
string text = "Zip"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_zip from singlelineedit within u_tabpage_user_contact_info
integer x = 2258
integer y = 456
integer width = 389
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
integer limit = 12
borderstyle borderstyle = stylelowered!
end type

event modified;if len(trim(text)) > 0 then
	user.address[address_index].zip = text
else
	setnull(user.address[address_index].zip)
end if

user.update_address(address_index)

end event

type sle_email_address from singlelineedit within u_tabpage_user_contact_info
integer x = 667
integer y = 1064
integer width = 1646
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;if len(trim(text)) > 0 then
	user.communication[email_index].communication_value = text
else
	setnull(user.communication[email_index].communication_value)
end if

user.update_communication(email_index)

end event

type st_email_address_title from statictext within u_tabpage_user_contact_info
integer x = 192
integer y = 1080
integer width = 443
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Email Address:"
alignment alignment = right!
boolean focusrectangle = false
end type

