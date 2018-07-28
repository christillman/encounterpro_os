$PBExportHeader$u_tabpage_consultant_info_address.sru
forward
global type u_tabpage_consultant_info_address from u_tabpage
end type
type sle_zip from singlelineedit within u_tabpage_consultant_info_address
end type
type st_zip from statictext within u_tabpage_consultant_info_address
end type
type st_state from statictext within u_tabpage_consultant_info_address
end type
type sle_state from singlelineedit within u_tabpage_consultant_info_address
end type
type st_city from statictext within u_tabpage_consultant_info_address
end type
type sle_city from singlelineedit within u_tabpage_consultant_info_address
end type
type st_addr2 from statictext within u_tabpage_consultant_info_address
end type
type st_addr1 from statictext within u_tabpage_consultant_info_address
end type
type sle_address2 from singlelineedit within u_tabpage_consultant_info_address
end type
type sle_address1 from singlelineedit within u_tabpage_consultant_info_address
end type
end forward

global type u_tabpage_consultant_info_address from u_tabpage
integer width = 3205
integer height = 1300
sle_zip sle_zip
st_zip st_zip
st_state st_state
sle_state sle_state
st_city st_city
sle_city sle_city
st_addr2 st_addr2
st_addr1 st_addr1
sle_address2 sle_address2
sle_address1 sle_address1
end type
global u_tabpage_consultant_info_address u_tabpage_consultant_info_address

on u_tabpage_consultant_info_address.create
int iCurrent
call super::create
this.sle_zip=create sle_zip
this.st_zip=create st_zip
this.st_state=create st_state
this.sle_state=create sle_state
this.st_city=create st_city
this.sle_city=create sle_city
this.st_addr2=create st_addr2
this.st_addr1=create st_addr1
this.sle_address2=create sle_address2
this.sle_address1=create sle_address1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_zip
this.Control[iCurrent+2]=this.st_zip
this.Control[iCurrent+3]=this.st_state
this.Control[iCurrent+4]=this.sle_state
this.Control[iCurrent+5]=this.st_city
this.Control[iCurrent+6]=this.sle_city
this.Control[iCurrent+7]=this.st_addr2
this.Control[iCurrent+8]=this.st_addr1
this.Control[iCurrent+9]=this.sle_address2
this.Control[iCurrent+10]=this.sle_address1
end on

on u_tabpage_consultant_info_address.destroy
call super::destroy
destroy(this.sle_zip)
destroy(this.st_zip)
destroy(this.st_state)
destroy(this.sle_state)
destroy(this.st_city)
destroy(this.sle_city)
destroy(this.st_addr2)
destroy(this.st_addr1)
destroy(this.sle_address2)
destroy(this.sle_address1)
end on

type sle_zip from singlelineedit within u_tabpage_consultant_info_address
integer x = 658
integer y = 800
integer width = 494
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
integer limit = 12
borderstyle borderstyle = stylelowered!
end type

type st_zip from statictext within u_tabpage_consultant_info_address
integer x = 485
integer y = 808
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
long backcolor = 33538240
string text = "Zip"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_state from statictext within u_tabpage_consultant_info_address
integer x = 453
integer y = 656
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
long backcolor = 33538240
string text = "State"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_state from singlelineedit within u_tabpage_consultant_info_address
integer x = 658
integer y = 648
integer width = 741
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
integer limit = 20
borderstyle borderstyle = stylelowered!
end type

type st_city from statictext within u_tabpage_consultant_info_address
integer x = 503
integer y = 504
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
long backcolor = 33538240
string text = "City"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_city from singlelineedit within u_tabpage_consultant_info_address
integer x = 658
integer y = 488
integer width = 741
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

type st_addr2 from statictext within u_tabpage_consultant_info_address
integer x = 187
integer y = 352
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
long backcolor = 33538240
string text = "Address Line 2"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_addr1 from statictext within u_tabpage_consultant_info_address
integer x = 187
integer y = 200
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
long backcolor = 33538240
string text = "Address Line 1"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_address2 from singlelineedit within u_tabpage_consultant_info_address
integer x = 658
integer y = 336
integer width = 1979
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

type sle_address1 from singlelineedit within u_tabpage_consultant_info_address
integer x = 658
integer y = 184
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

