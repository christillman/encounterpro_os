$PBExportHeader$u_tabpage_consultant_info_general.sru
forward
global type u_tabpage_consultant_info_general from u_tabpage
end type
type st_owner_id_title from statictext within u_tabpage_consultant_info_general
end type
type sle_owner_id from singlelineedit within u_tabpage_consultant_info_general
end type
type sle_name_suffix from singlelineedit within u_tabpage_consultant_info_general
end type
type st_9 from statictext within u_tabpage_consultant_info_general
end type
type st_8 from statictext within u_tabpage_consultant_info_general
end type
type sle_first_name from singlelineedit within u_tabpage_consultant_info_general
end type
type st_7 from statictext within u_tabpage_consultant_info_general
end type
type sle_last_name from singlelineedit within u_tabpage_consultant_info_general
end type
type sle_middle_name from singlelineedit within u_tabpage_consultant_info_general
end type
type st_6 from statictext within u_tabpage_consultant_info_general
end type
type sle_degree from singlelineedit within u_tabpage_consultant_info_general
end type
type st_5 from statictext within u_tabpage_consultant_info_general
end type
type st_4 from statictext within u_tabpage_consultant_info_general
end type
type sle_name_prefix from singlelineedit within u_tabpage_consultant_info_general
end type
type sle_contact from singlelineedit within u_tabpage_consultant_info_general
end type
type st_contact from statictext within u_tabpage_consultant_info_general
end type
type st_email from statictext within u_tabpage_consultant_info_general
end type
type sle_email from singlelineedit within u_tabpage_consultant_info_general
end type
type st_ph2 from statictext within u_tabpage_consultant_info_general
end type
type sle_phone2 from singlelineedit within u_tabpage_consultant_info_general
end type
type sle_fax from singlelineedit within u_tabpage_consultant_info_general
end type
type st_phone1 from statictext within u_tabpage_consultant_info_general
end type
type sle_phone from singlelineedit within u_tabpage_consultant_info_general
end type
type st_phone from statictext within u_tabpage_consultant_info_general
end type
type st_3 from statictext within u_tabpage_consultant_info_general
end type
end forward

global type u_tabpage_consultant_info_general from u_tabpage
integer width = 2953
integer height = 1496
st_owner_id_title st_owner_id_title
sle_owner_id sle_owner_id
sle_name_suffix sle_name_suffix
st_9 st_9
st_8 st_8
sle_first_name sle_first_name
st_7 st_7
sle_last_name sle_last_name
sle_middle_name sle_middle_name
st_6 st_6
sle_degree sle_degree
st_5 st_5
st_4 st_4
sle_name_prefix sle_name_prefix
sle_contact sle_contact
st_contact st_contact
st_email st_email
sle_email sle_email
st_ph2 st_ph2
sle_phone2 sle_phone2
sle_fax sle_fax
st_phone1 st_phone1
sle_phone sle_phone
st_phone st_phone
st_3 st_3
end type
global u_tabpage_consultant_info_general u_tabpage_consultant_info_general

on u_tabpage_consultant_info_general.create
int iCurrent
call super::create
this.st_owner_id_title=create st_owner_id_title
this.sle_owner_id=create sle_owner_id
this.sle_name_suffix=create sle_name_suffix
this.st_9=create st_9
this.st_8=create st_8
this.sle_first_name=create sle_first_name
this.st_7=create st_7
this.sle_last_name=create sle_last_name
this.sle_middle_name=create sle_middle_name
this.st_6=create st_6
this.sle_degree=create sle_degree
this.st_5=create st_5
this.st_4=create st_4
this.sle_name_prefix=create sle_name_prefix
this.sle_contact=create sle_contact
this.st_contact=create st_contact
this.st_email=create st_email
this.sle_email=create sle_email
this.st_ph2=create st_ph2
this.sle_phone2=create sle_phone2
this.sle_fax=create sle_fax
this.st_phone1=create st_phone1
this.sle_phone=create sle_phone
this.st_phone=create st_phone
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_owner_id_title
this.Control[iCurrent+2]=this.sle_owner_id
this.Control[iCurrent+3]=this.sle_name_suffix
this.Control[iCurrent+4]=this.st_9
this.Control[iCurrent+5]=this.st_8
this.Control[iCurrent+6]=this.sle_first_name
this.Control[iCurrent+7]=this.st_7
this.Control[iCurrent+8]=this.sle_last_name
this.Control[iCurrent+9]=this.sle_middle_name
this.Control[iCurrent+10]=this.st_6
this.Control[iCurrent+11]=this.sle_degree
this.Control[iCurrent+12]=this.st_5
this.Control[iCurrent+13]=this.st_4
this.Control[iCurrent+14]=this.sle_name_prefix
this.Control[iCurrent+15]=this.sle_contact
this.Control[iCurrent+16]=this.st_contact
this.Control[iCurrent+17]=this.st_email
this.Control[iCurrent+18]=this.sle_email
this.Control[iCurrent+19]=this.st_ph2
this.Control[iCurrent+20]=this.sle_phone2
this.Control[iCurrent+21]=this.sle_fax
this.Control[iCurrent+22]=this.st_phone1
this.Control[iCurrent+23]=this.sle_phone
this.Control[iCurrent+24]=this.st_phone
this.Control[iCurrent+25]=this.st_3
end on

on u_tabpage_consultant_info_general.destroy
call super::destroy
destroy(this.st_owner_id_title)
destroy(this.sle_owner_id)
destroy(this.sle_name_suffix)
destroy(this.st_9)
destroy(this.st_8)
destroy(this.sle_first_name)
destroy(this.st_7)
destroy(this.sle_last_name)
destroy(this.sle_middle_name)
destroy(this.st_6)
destroy(this.sle_degree)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.sle_name_prefix)
destroy(this.sle_contact)
destroy(this.st_contact)
destroy(this.st_email)
destroy(this.sle_email)
destroy(this.st_ph2)
destroy(this.sle_phone2)
destroy(this.sle_fax)
destroy(this.st_phone1)
destroy(this.sle_phone)
destroy(this.st_phone)
destroy(this.st_3)
end on

type st_owner_id_title from statictext within u_tabpage_consultant_info_general
integer x = 1705
integer y = 856
integer width = 283
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Owner ID"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_owner_id from singlelineedit within u_tabpage_consultant_info_general
integer x = 2011
integer y = 840
integer width = 759
integer height = 104
integer taborder = 60
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

type sle_name_suffix from singlelineedit within u_tabpage_consultant_info_general
integer x = 517
integer y = 832
integer width = 905
integer height = 104
integer taborder = 50
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

type st_9 from statictext within u_tabpage_consultant_info_general
integer x = 119
integer y = 848
integer width = 375
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Name Suffix"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_8 from statictext within u_tabpage_consultant_info_general
integer x = 123
integer y = 88
integer width = 370
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "First Name"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_first_name from singlelineedit within u_tabpage_consultant_info_general
integer x = 517
integer y = 72
integer width = 905
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
integer limit = 32
borderstyle borderstyle = stylelowered!
end type

type st_7 from statictext within u_tabpage_consultant_info_general
integer x = 123
integer y = 392
integer width = 370
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Last Name"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_last_name from singlelineedit within u_tabpage_consultant_info_general
integer x = 517
integer y = 376
integer width = 905
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

type sle_middle_name from singlelineedit within u_tabpage_consultant_info_general
integer x = 517
integer y = 224
integer width = 905
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

type st_6 from statictext within u_tabpage_consultant_info_general
integer x = 73
integer y = 240
integer width = 421
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Middle Name"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_degree from singlelineedit within u_tabpage_consultant_info_general
integer x = 517
integer y = 528
integer width = 905
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
integer limit = 64
borderstyle borderstyle = stylelowered!
end type

type st_5 from statictext within u_tabpage_consultant_info_general
integer x = 123
integer y = 544
integer width = 370
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Degree"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within u_tabpage_consultant_info_general
integer x = 119
integer y = 696
integer width = 375
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Name Prefix"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_name_prefix from singlelineedit within u_tabpage_consultant_info_general
integer x = 517
integer y = 680
integer width = 905
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
integer limit = 40
borderstyle borderstyle = stylelowered!
end type

type sle_contact from singlelineedit within u_tabpage_consultant_info_general
integer x = 2011
integer y = 688
integer width = 759
integer height = 104
integer taborder = 40
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

type st_contact from statictext within u_tabpage_consultant_info_general
integer x = 1742
integer y = 704
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Contact"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_email from statictext within u_tabpage_consultant_info_general
integer x = 1787
integer y = 552
integer width = 201
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "E-mail"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_email from singlelineedit within u_tabpage_consultant_info_general
integer x = 2011
integer y = 536
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
integer limit = 64
borderstyle borderstyle = stylelowered!
end type

type st_ph2 from statictext within u_tabpage_consultant_info_general
integer x = 1746
integer y = 248
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
long backcolor = 33538240
string text = "Phone 2"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_phone2 from singlelineedit within u_tabpage_consultant_info_general
integer x = 2011
integer y = 232
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
integer limit = 40
borderstyle borderstyle = stylelowered!
end type

type sle_fax from singlelineedit within u_tabpage_consultant_info_general
integer x = 2011
integer y = 384
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

type st_phone1 from statictext within u_tabpage_consultant_info_general
integer x = 1792
integer y = 400
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
long backcolor = 33538240
string text = "Fax"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_phone from singlelineedit within u_tabpage_consultant_info_general
integer x = 2011
integer y = 80
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

type st_phone from statictext within u_tabpage_consultant_info_general
integer x = 1769
integer y = 96
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
long backcolor = 33538240
string text = "Phone"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within u_tabpage_consultant_info_general
integer x = 1705
integer y = 52
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

