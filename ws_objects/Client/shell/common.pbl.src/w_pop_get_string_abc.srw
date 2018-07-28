$PBExportHeader$w_pop_get_string_abc.srw
forward
global type w_pop_get_string_abc from w_window_base
end type
type st_contains from statictext within w_pop_get_string_abc
end type
type st_begins_with from statictext within w_pop_get_string_abc
end type
type sle_string from singlelineedit within w_pop_get_string_abc
end type
type cb_ok from commandbutton within w_pop_get_string_abc
end type
type cb_n from commandbutton within w_pop_get_string_abc
end type
type cb_o from commandbutton within w_pop_get_string_abc
end type
type cb_p from commandbutton within w_pop_get_string_abc
end type
type cb_q from commandbutton within w_pop_get_string_abc
end type
type cb_r from commandbutton within w_pop_get_string_abc
end type
type cb_s from commandbutton within w_pop_get_string_abc
end type
type cb_t from commandbutton within w_pop_get_string_abc
end type
type cb_u from commandbutton within w_pop_get_string_abc
end type
type cb_v from commandbutton within w_pop_get_string_abc
end type
type cb_w from commandbutton within w_pop_get_string_abc
end type
type cb_x from commandbutton within w_pop_get_string_abc
end type
type cb_y from commandbutton within w_pop_get_string_abc
end type
type cb_z from commandbutton within w_pop_get_string_abc
end type
type cb_cancel from commandbutton within w_pop_get_string_abc
end type
type cb_m from commandbutton within w_pop_get_string_abc
end type
type cb_l from commandbutton within w_pop_get_string_abc
end type
type cb_k from commandbutton within w_pop_get_string_abc
end type
type cb_j from commandbutton within w_pop_get_string_abc
end type
type cb_i from commandbutton within w_pop_get_string_abc
end type
type cb_h from commandbutton within w_pop_get_string_abc
end type
type cb_g from commandbutton within w_pop_get_string_abc
end type
type cb_f from commandbutton within w_pop_get_string_abc
end type
type cb_e from commandbutton within w_pop_get_string_abc
end type
type cb_d from commandbutton within w_pop_get_string_abc
end type
type cb_c from commandbutton within w_pop_get_string_abc
end type
type cb_b from commandbutton within w_pop_get_string_abc
end type
type cb_a from commandbutton within w_pop_get_string_abc
end type
end forward

global type w_pop_get_string_abc from w_window_base
integer y = 448
integer height = 692
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
st_contains st_contains
st_begins_with st_begins_with
sle_string sle_string
cb_ok cb_ok
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
global w_pop_get_string_abc w_pop_get_string_abc

type variables
boolean starts_with

end variables

forward prototypes
public subroutine add_letter (string ps_character)
end prototypes

public subroutine add_letter (string ps_character);
sle_string.text += ps_character
sle_string.selecttext(len(sle_string.text) + 1, 0)


end subroutine

on w_pop_get_string_abc.create
int iCurrent
call super::create
this.st_contains=create st_contains
this.st_begins_with=create st_begins_with
this.sle_string=create sle_string
this.cb_ok=create cb_ok
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
this.Control[iCurrent+1]=this.st_contains
this.Control[iCurrent+2]=this.st_begins_with
this.Control[iCurrent+3]=this.sle_string
this.Control[iCurrent+4]=this.cb_ok
this.Control[iCurrent+5]=this.cb_n
this.Control[iCurrent+6]=this.cb_o
this.Control[iCurrent+7]=this.cb_p
this.Control[iCurrent+8]=this.cb_q
this.Control[iCurrent+9]=this.cb_r
this.Control[iCurrent+10]=this.cb_s
this.Control[iCurrent+11]=this.cb_t
this.Control[iCurrent+12]=this.cb_u
this.Control[iCurrent+13]=this.cb_v
this.Control[iCurrent+14]=this.cb_w
this.Control[iCurrent+15]=this.cb_x
this.Control[iCurrent+16]=this.cb_y
this.Control[iCurrent+17]=this.cb_z
this.Control[iCurrent+18]=this.cb_cancel
this.Control[iCurrent+19]=this.cb_m
this.Control[iCurrent+20]=this.cb_l
this.Control[iCurrent+21]=this.cb_k
this.Control[iCurrent+22]=this.cb_j
this.Control[iCurrent+23]=this.cb_i
this.Control[iCurrent+24]=this.cb_h
this.Control[iCurrent+25]=this.cb_g
this.Control[iCurrent+26]=this.cb_f
this.Control[iCurrent+27]=this.cb_e
this.Control[iCurrent+28]=this.cb_d
this.Control[iCurrent+29]=this.cb_c
this.Control[iCurrent+30]=this.cb_b
this.Control[iCurrent+31]=this.cb_a
end on

on w_pop_get_string_abc.destroy
call super::destroy
destroy(this.st_contains)
destroy(this.st_begins_with)
destroy(this.sle_string)
destroy(this.cb_ok)
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

event open;call super::open;string ls_mode

ls_mode = message.stringparm

if isnull(ls_mode) or trim(ls_mode) = "" then
	ls_mode = datalist.get_preference( "PREFERENCES", 	"Default String Search Mode", "Begins With")
end if

sle_string.text = ""
sle_string.setfocus()

CHOOSE CASE upper(left(ls_mode, 1))
	CASE "C"
		// "Contains"
		st_contains.backcolor = color_object_selected
		starts_with = false
	CASE "X"
		// "X" = disable search mode
		st_contains.visible = false
		st_begins_with.visible = false
		setnull(starts_with)
	CASE ELSE
		// assume "B" for "Begins With"
		st_begins_with.backcolor = color_object_selected
		starts_with = true
END CHOOSE


end event

type st_contains from statictext within w_pop_get_string_abc
integer x = 535
integer y = 508
integer width = 416
integer height = 104
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Contains"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_begins_with.backcolor = color_object
starts_with = false

sle_string.setfocus()

end event

type st_begins_with from statictext within w_pop_get_string_abc
integer x = 91
integer y = 508
integer width = 416
integer height = 104
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Begins With"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_contains.backcolor = color_object
starts_with = true

sle_string.setfocus()

end event

type sle_string from singlelineedit within w_pop_get_string_abc
integer x = 1001
integer y = 520
integer width = 773
integer height = 84
integer taborder = 290
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_ok from commandbutton within w_pop_get_string_abc
integer x = 2391
integer y = 496
integer width = 434
integer height = 120
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 1

if sle_string.text = "" then
	if isnull(starts_with) then
		popup_return.items[1] = ""
		popup_return.descriptions[1] = ""
	else
		popup_return.items[1] = "%"
		popup_return.descriptions[1] = "<All>"
	end if
else
	if isnull(starts_with) then
		popup_return.descriptions[1] = sle_string.text
		popup_return.items[1] = sle_string.text
	elseif starts_with then
		popup_return.descriptions[1] = 'Begins with "' + sle_string.text + '"'
		popup_return.items[1] = sle_string.text + "%"
	else
		popup_return.descriptions[1] = 'Contains "' + sle_string.text + '"'
		popup_return.items[1] = "%" + sle_string.text + "%"
	end if
end if

closewithreturn(parent,popup_return)

end event

type cb_n from commandbutton within w_pop_get_string_abc
integer x = 73
integer y = 280
integer width = 174
integer height = 164
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&N"
end type

event clicked;add_letter("n")
end event

type cb_o from commandbutton within w_pop_get_string_abc
integer x = 288
integer y = 280
integer width = 174
integer height = 164
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&O"
end type

event clicked;add_letter("o")
end event

type cb_p from commandbutton within w_pop_get_string_abc
integer x = 503
integer y = 280
integer width = 174
integer height = 164
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&P"
end type

event clicked;add_letter("p")
end event

type cb_q from commandbutton within w_pop_get_string_abc
integer x = 718
integer y = 280
integer width = 174
integer height = 164
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Q"
end type

event clicked;add_letter("q")
end event

type cb_r from commandbutton within w_pop_get_string_abc
integer x = 933
integer y = 280
integer width = 174
integer height = 164
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&R"
end type

event clicked;add_letter("r")
end event

type cb_s from commandbutton within w_pop_get_string_abc
integer x = 1147
integer y = 280
integer width = 174
integer height = 164
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&S"
end type

event clicked;add_letter("s")
end event

type cb_t from commandbutton within w_pop_get_string_abc
integer x = 1362
integer y = 280
integer width = 174
integer height = 164
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&T"
end type

event clicked;add_letter("t")
end event

type cb_u from commandbutton within w_pop_get_string_abc
integer x = 1577
integer y = 280
integer width = 174
integer height = 164
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&U"
end type

event clicked;add_letter("u")
end event

type cb_v from commandbutton within w_pop_get_string_abc
integer x = 1792
integer y = 280
integer width = 174
integer height = 164
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&V"
end type

event clicked;add_letter("v")
end event

type cb_w from commandbutton within w_pop_get_string_abc
integer x = 2007
integer y = 280
integer width = 174
integer height = 164
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&W"
end type

event clicked;add_letter("w")
end event

type cb_x from commandbutton within w_pop_get_string_abc
integer x = 2222
integer y = 280
integer width = 174
integer height = 164
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&X"
end type

event clicked;add_letter("x")
end event

type cb_y from commandbutton within w_pop_get_string_abc
integer x = 2437
integer y = 280
integer width = 174
integer height = 164
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Y"
end type

event clicked;add_letter("y")
end event

type cb_z from commandbutton within w_pop_get_string_abc
integer x = 2651
integer y = 280
integer width = 174
integer height = 164
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Z"
end type

event clicked;add_letter("z")
end event

type cb_cancel from commandbutton within w_pop_get_string_abc
integer x = 1906
integer y = 500
integer width = 434
integer height = 120
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent,popup_return)

end event

type cb_m from commandbutton within w_pop_get_string_abc
integer x = 2651
integer y = 68
integer width = 174
integer height = 164
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&M"
end type

event clicked;add_letter("m")
end event

type cb_l from commandbutton within w_pop_get_string_abc
integer x = 2437
integer y = 68
integer width = 174
integer height = 164
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&L"
end type

event clicked;add_letter("l")
end event

type cb_k from commandbutton within w_pop_get_string_abc
integer x = 2222
integer y = 68
integer width = 174
integer height = 164
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&K"
end type

event clicked;add_letter("k")
end event

type cb_j from commandbutton within w_pop_get_string_abc
integer x = 2007
integer y = 68
integer width = 174
integer height = 164
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&J"
end type

event clicked;add_letter("j")
end event

type cb_i from commandbutton within w_pop_get_string_abc
integer x = 1792
integer y = 68
integer width = 174
integer height = 164
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&I"
end type

event clicked;add_letter("i")
end event

type cb_h from commandbutton within w_pop_get_string_abc
integer x = 1577
integer y = 68
integer width = 174
integer height = 164
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&H"
end type

event clicked;add_letter("h")
end event

type cb_g from commandbutton within w_pop_get_string_abc
integer x = 1362
integer y = 68
integer width = 174
integer height = 164
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&G"
end type

event clicked;add_letter("g")
end event

type cb_f from commandbutton within w_pop_get_string_abc
integer x = 1147
integer y = 68
integer width = 174
integer height = 164
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&F"
end type

event clicked;add_letter("f")
end event

type cb_e from commandbutton within w_pop_get_string_abc
integer x = 933
integer y = 68
integer width = 174
integer height = 164
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&E"
end type

event clicked;add_letter("e")
end event

type cb_d from commandbutton within w_pop_get_string_abc
integer x = 718
integer y = 68
integer width = 174
integer height = 164
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&D"
end type

event clicked;add_letter("d")
end event

type cb_c from commandbutton within w_pop_get_string_abc
integer x = 503
integer y = 68
integer width = 174
integer height = 164
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&C"
end type

event clicked;add_letter("c")
end event

type cb_b from commandbutton within w_pop_get_string_abc
integer x = 288
integer y = 68
integer width = 174
integer height = 164
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&B"
end type

event clicked;add_letter("b")
end event

type cb_a from commandbutton within w_pop_get_string_abc
integer x = 73
integer y = 68
integer width = 174
integer height = 164
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&A"
end type

event clicked;add_letter("a")

end event

