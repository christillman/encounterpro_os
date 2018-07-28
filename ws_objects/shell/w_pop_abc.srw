HA$PBExportHeader$w_pop_abc.srw
forward
global type w_pop_abc from w_window_base
end type
type cb_n from commandbutton within w_pop_abc
end type
type cb_o from commandbutton within w_pop_abc
end type
type cb_p from commandbutton within w_pop_abc
end type
type cb_q from commandbutton within w_pop_abc
end type
type cb_r from commandbutton within w_pop_abc
end type
type cb_s from commandbutton within w_pop_abc
end type
type cb_t from commandbutton within w_pop_abc
end type
type cb_u from commandbutton within w_pop_abc
end type
type cb_v from commandbutton within w_pop_abc
end type
type cb_w from commandbutton within w_pop_abc
end type
type cb_x from commandbutton within w_pop_abc
end type
type cb_y from commandbutton within w_pop_abc
end type
type cb_z from commandbutton within w_pop_abc
end type
type cb_cancel from commandbutton within w_pop_abc
end type
type cb_m from commandbutton within w_pop_abc
end type
type cb_l from commandbutton within w_pop_abc
end type
type cb_k from commandbutton within w_pop_abc
end type
type cb_j from commandbutton within w_pop_abc
end type
type cb_i from commandbutton within w_pop_abc
end type
type cb_h from commandbutton within w_pop_abc
end type
type cb_g from commandbutton within w_pop_abc
end type
type cb_f from commandbutton within w_pop_abc
end type
type cb_e from commandbutton within w_pop_abc
end type
type cb_d from commandbutton within w_pop_abc
end type
type cb_c from commandbutton within w_pop_abc
end type
type cb_b from commandbutton within w_pop_abc
end type
type cb_a from commandbutton within w_pop_abc
end type
end forward

global type w_pop_abc from w_window_base
integer y = 448
integer height = 696
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
cb_n cb_n
cb_o cb_o
cb_p cb_p
cb_q cb_q
cb_r cb_r
cb_s cb_s
cb_t cb_t
cb_u cb_u
cb_v cb_v
cb_w cb_w
cb_x cb_x
cb_y cb_y
cb_z cb_z
cb_cancel cb_cancel
cb_m cb_m
cb_l cb_l
cb_k cb_k
cb_j cb_j
cb_i cb_i
cb_h cb_h
cb_g cb_g
cb_f cb_f
cb_e cb_e
cb_d cb_d
cb_c cb_c
cb_b cb_b
cb_a cb_a
end type
global w_pop_abc w_pop_abc

on w_pop_abc.create
int iCurrent
call super::create
this.cb_n=create cb_n
this.cb_o=create cb_o
this.cb_p=create cb_p
this.cb_q=create cb_q
this.cb_r=create cb_r
this.cb_s=create cb_s
this.cb_t=create cb_t
this.cb_u=create cb_u
this.cb_v=create cb_v
this.cb_w=create cb_w
this.cb_x=create cb_x
this.cb_y=create cb_y
this.cb_z=create cb_z
this.cb_cancel=create cb_cancel
this.cb_m=create cb_m
this.cb_l=create cb_l
this.cb_k=create cb_k
this.cb_j=create cb_j
this.cb_i=create cb_i
this.cb_h=create cb_h
this.cb_g=create cb_g
this.cb_f=create cb_f
this.cb_e=create cb_e
this.cb_d=create cb_d
this.cb_c=create cb_c
this.cb_b=create cb_b
this.cb_a=create cb_a
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_n
this.Control[iCurrent+2]=this.cb_o
this.Control[iCurrent+3]=this.cb_p
this.Control[iCurrent+4]=this.cb_q
this.Control[iCurrent+5]=this.cb_r
this.Control[iCurrent+6]=this.cb_s
this.Control[iCurrent+7]=this.cb_t
this.Control[iCurrent+8]=this.cb_u
this.Control[iCurrent+9]=this.cb_v
this.Control[iCurrent+10]=this.cb_w
this.Control[iCurrent+11]=this.cb_x
this.Control[iCurrent+12]=this.cb_y
this.Control[iCurrent+13]=this.cb_z
this.Control[iCurrent+14]=this.cb_cancel
this.Control[iCurrent+15]=this.cb_m
this.Control[iCurrent+16]=this.cb_l
this.Control[iCurrent+17]=this.cb_k
this.Control[iCurrent+18]=this.cb_j
this.Control[iCurrent+19]=this.cb_i
this.Control[iCurrent+20]=this.cb_h
this.Control[iCurrent+21]=this.cb_g
this.Control[iCurrent+22]=this.cb_f
this.Control[iCurrent+23]=this.cb_e
this.Control[iCurrent+24]=this.cb_d
this.Control[iCurrent+25]=this.cb_c
this.Control[iCurrent+26]=this.cb_b
this.Control[iCurrent+27]=this.cb_a
end on

on w_pop_abc.destroy
call super::destroy
destroy(this.cb_n)
destroy(this.cb_o)
destroy(this.cb_p)
destroy(this.cb_q)
destroy(this.cb_r)
destroy(this.cb_s)
destroy(this.cb_t)
destroy(this.cb_u)
destroy(this.cb_v)
destroy(this.cb_w)
destroy(this.cb_x)
destroy(this.cb_y)
destroy(this.cb_z)
destroy(this.cb_cancel)
destroy(this.cb_m)
destroy(this.cb_l)
destroy(this.cb_k)
destroy(this.cb_j)
destroy(this.cb_i)
destroy(this.cb_h)
destroy(this.cb_g)
destroy(this.cb_f)
destroy(this.cb_e)
destroy(this.cb_d)
destroy(this.cb_c)
destroy(this.cb_b)
destroy(this.cb_a)
end on

type cb_n from commandbutton within w_pop_abc
integer x = 73
integer y = 280
integer width = 174
integer height = 164
integer taborder = 10
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&N"
end type

on clicked;closewithreturn(parent,"N")
end on

type cb_o from commandbutton within w_pop_abc
integer x = 288
integer y = 280
integer width = 174
integer height = 164
integer taborder = 40
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&O"
end type

on clicked;closewithreturn(parent,"O")
end on

type cb_p from commandbutton within w_pop_abc
integer x = 503
integer y = 280
integer width = 174
integer height = 164
integer taborder = 60
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&P"
end type

on clicked;closewithreturn(parent,"P")
end on

type cb_q from commandbutton within w_pop_abc
integer x = 718
integer y = 280
integer width = 174
integer height = 164
integer taborder = 80
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Q"
end type

on clicked;closewithreturn(parent,"Q")
end on

type cb_r from commandbutton within w_pop_abc
integer x = 933
integer y = 280
integer width = 174
integer height = 164
integer taborder = 100
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&R"
end type

on clicked;closewithreturn(parent,"R")
end on

type cb_s from commandbutton within w_pop_abc
integer x = 1147
integer y = 280
integer width = 174
integer height = 164
integer taborder = 120
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&S"
end type

on clicked;closewithreturn(parent,"S")
end on

type cb_t from commandbutton within w_pop_abc
integer x = 1362
integer y = 280
integer width = 174
integer height = 164
integer taborder = 140
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&T"
end type

on clicked;closewithreturn(parent,"T")
end on

type cb_u from commandbutton within w_pop_abc
integer x = 1577
integer y = 280
integer width = 174
integer height = 164
integer taborder = 160
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&U"
end type

on clicked;closewithreturn(parent,"U")
end on

type cb_v from commandbutton within w_pop_abc
integer x = 1792
integer y = 280
integer width = 174
integer height = 164
integer taborder = 180
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&V"
end type

on clicked;closewithreturn(parent,"V")
end on

type cb_w from commandbutton within w_pop_abc
integer x = 2007
integer y = 280
integer width = 174
integer height = 164
integer taborder = 200
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&W"
end type

on clicked;closewithreturn(parent,"W")
end on

type cb_x from commandbutton within w_pop_abc
integer x = 2222
integer y = 280
integer width = 174
integer height = 164
integer taborder = 220
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&X"
end type

on clicked;closewithreturn(parent,"X")
end on

type cb_y from commandbutton within w_pop_abc
integer x = 2437
integer y = 280
integer width = 174
integer height = 164
integer taborder = 240
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Y"
end type

on clicked;closewithreturn(parent,"Y")
end on

type cb_z from commandbutton within w_pop_abc
integer x = 2651
integer y = 280
integer width = 174
integer height = 164
integer taborder = 260
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Z"
end type

on clicked;closewithreturn(parent,"Z")
end on

type cb_cancel from commandbutton within w_pop_abc
integer x = 2254
integer y = 504
integer width = 571
integer height = 120
integer taborder = 270
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

on clicked;closewithreturn(parent,"")
end on

type cb_m from commandbutton within w_pop_abc
integer x = 2651
integer y = 68
integer width = 174
integer height = 164
integer taborder = 250
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&M"
end type

on clicked;closewithreturn(parent,"M")
end on

type cb_l from commandbutton within w_pop_abc
integer x = 2437
integer y = 68
integer width = 174
integer height = 164
integer taborder = 230
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&L"
end type

on clicked;closewithreturn(parent,"L")
end on

type cb_k from commandbutton within w_pop_abc
integer x = 2222
integer y = 68
integer width = 174
integer height = 164
integer taborder = 210
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&K"
end type

on clicked;closewithreturn(parent,"K")
end on

type cb_j from commandbutton within w_pop_abc
integer x = 2007
integer y = 68
integer width = 174
integer height = 164
integer taborder = 190
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&J"
end type

on clicked;closewithreturn(parent,"J")
end on

type cb_i from commandbutton within w_pop_abc
integer x = 1792
integer y = 68
integer width = 174
integer height = 164
integer taborder = 170
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&I"
end type

on clicked;closewithreturn(parent,"I")
end on

type cb_h from commandbutton within w_pop_abc
integer x = 1577
integer y = 68
integer width = 174
integer height = 164
integer taborder = 150
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&H"
end type

on clicked;closewithreturn(parent,"H")
end on

type cb_g from commandbutton within w_pop_abc
integer x = 1362
integer y = 68
integer width = 174
integer height = 164
integer taborder = 130
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&G"
end type

on clicked;closewithreturn(parent,"G")
end on

type cb_f from commandbutton within w_pop_abc
integer x = 1147
integer y = 68
integer width = 174
integer height = 164
integer taborder = 110
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&F"
end type

on clicked;closewithreturn(parent,"F")
end on

type cb_e from commandbutton within w_pop_abc
integer x = 933
integer y = 68
integer width = 174
integer height = 164
integer taborder = 90
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&E"
end type

on clicked;closewithreturn(parent,"E")
end on

type cb_d from commandbutton within w_pop_abc
integer x = 718
integer y = 68
integer width = 174
integer height = 164
integer taborder = 70
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&D"
end type

on clicked;closewithreturn(parent,"D")
end on

type cb_c from commandbutton within w_pop_abc
integer x = 503
integer y = 68
integer width = 174
integer height = 164
integer taborder = 50
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&C"
end type

on clicked;closewithreturn(parent,"C")
end on

type cb_b from commandbutton within w_pop_abc
integer x = 288
integer y = 68
integer width = 174
integer height = 164
integer taborder = 30
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&B"
end type

on clicked;closewithreturn(parent,"B")
end on

type cb_a from commandbutton within w_pop_abc
integer x = 73
integer y = 68
integer width = 174
integer height = 164
integer taborder = 20
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&A"
end type

on clicked;closewithreturn(parent,"A")
end on

