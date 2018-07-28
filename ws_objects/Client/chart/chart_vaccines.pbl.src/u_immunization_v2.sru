$PBExportHeader$u_immunization_v2.sru
forward
global type u_immunization_v2 from u_cpr_page_base
end type
type cb_order from commandbutton within u_immunization_v2
end type
type st_7 from statictext within u_immunization_v2
end type
type st_6 from statictext within u_immunization_v2
end type
type st_5 from statictext within u_immunization_v2
end type
type st_4 from statictext within u_immunization_v2
end type
type st_3 from statictext within u_immunization_v2
end type
type st_2 from statictext within u_immunization_v2
end type
type st_1 from statictext within u_immunization_v2
end type
type dw_immunizations from u_dw_imm_dates within u_immunization_v2
end type
type st_title from statictext within u_immunization_v2
end type
type cb_1 from commandbutton within u_immunization_v2
end type
type r_1 from rectangle within u_immunization_v2
end type
end forward

global type u_immunization_v2 from u_cpr_page_base
cb_order cb_order
st_7 st_7
st_6 st_6
st_5 st_5
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
dw_immunizations dw_immunizations
st_title st_title
cb_1 cb_1
r_1 r_1
end type
global u_immunization_v2 u_immunization_v2

type variables
string vaccine_history_service

end variables

forward prototypes
public subroutine initialize (u_cpr_section puo_section, integer pi_page)
public subroutine refresh ()
public subroutine losefocus ()
public subroutine refresh_tab ()
end prototypes

public subroutine initialize (u_cpr_section puo_section, integer pi_page);this_section = puo_section
this_page = pi_page

this_section.load_params(this_page)
vaccine_history_service = this_section.get_attribute(this_section.page[this_page].page_id, "vaccine_history_service")
if isnull(vaccine_history_service) then vaccine_history_service = "VACCINEHISTORY"

real lr_x_factor
real lr_y_factor

lr_x_factor = width / 2875
lr_y_factor = height / 1272

f_resize_objects(control, lr_x_factor, lr_y_factor, false, true)

refresh()

end subroutine

public subroutine refresh ();dw_immunizations.load_dates()
refresh_tab()

end subroutine

public subroutine losefocus ();refresh_tab()

end subroutine

public subroutine refresh_tab ();long i, ll_count
integer li_status
integer li_max_status

ll_count = dw_immunizations.rowcount()
li_max_status = 1

for i = 1 to ll_count
	li_status = dw_immunizations.object.status[i]
	if li_status >= 3 then
		li_max_status = 3
		exit
	elseif li_status = 2 then
		li_max_status = 2
	end if
next

if li_max_status = 1 then
	tabtextcolor = COLOR_TEXT_NORMAL
elseif li_max_status = 2 then
	tabtextcolor = COLOR_TEXT_WARNING
else
	tabtextcolor = COLOR_TEXT_ERROR
end if

end subroutine

on u_immunization_v2.create
int iCurrent
call super::create
this.cb_order=create cb_order
this.st_7=create st_7
this.st_6=create st_6
this.st_5=create st_5
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.dw_immunizations=create dw_immunizations
this.st_title=create st_title
this.cb_1=create cb_1
this.r_1=create r_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_order
this.Control[iCurrent+2]=this.st_7
this.Control[iCurrent+3]=this.st_6
this.Control[iCurrent+4]=this.st_5
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.dw_immunizations
this.Control[iCurrent+10]=this.st_title
this.Control[iCurrent+11]=this.cb_1
this.Control[iCurrent+12]=this.r_1
end on

on u_immunization_v2.destroy
call super::destroy
destroy(this.cb_order)
destroy(this.st_7)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_immunizations)
destroy(this.st_title)
destroy(this.cb_1)
destroy(this.r_1)
end on

type cb_order from commandbutton within u_immunization_v2
integer x = 2345
integer y = 784
integer width = 471
integer height = 108
integer taborder = 11
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Order Vaccine"
end type

event clicked;long ll_menu_id
string ls_menu_key

setnull(ls_menu_key)

ll_menu_id = f_get_context_menu("OrderVaccine", ls_menu_key)
if ll_menu_id <= 0 then return

f_display_menu(ll_menu_id, true)

refresh()


end event

type st_7 from statictext within u_immunization_v2
integer x = 2501
integer y = 492
integer width = 283
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Current"
boolean focusrectangle = false
end type

type st_6 from statictext within u_immunization_v2
integer x = 2501
integer y = 404
integer width = 315
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Almost Due"
boolean focusrectangle = false
end type

type st_5 from statictext within u_immunization_v2
integer x = 2501
integer y = 316
integer width = 283
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Overdue"
boolean focusrectangle = false
end type

type st_4 from statictext within u_immunization_v2
integer x = 2295
integer y = 492
integer width = 187
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Black"
boolean focusrectangle = false
end type

type st_3 from statictext within u_immunization_v2
integer x = 2295
integer y = 404
integer width = 187
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 65535
long backcolor = 33538240
string text = "Yellow"
boolean focusrectangle = false
end type

type st_2 from statictext within u_immunization_v2
integer x = 2295
integer y = 316
integer width = 187
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 33538240
string text = "Red"
boolean focusrectangle = false
end type

type st_1 from statictext within u_immunization_v2
integer x = 2345
integer y = 232
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 33538240
string text = "Legend"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_immunizations from u_dw_imm_dates within u_immunization_v2
integer x = 247
integer y = 168
integer width = 1998
integer height = 996
boolean enabled = false
string dataobject = "dw_immunization_dates_new"
boolean border = false
end type

type st_title from statictext within u_immunization_v2
integer x = 631
integer y = 8
integer width = 1390
integer height = 120
boolean bringtotop = true
integer textsize = -16
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Immunization Status"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within u_immunization_v2
integer x = 2345
integer y = 1076
integer width = 471
integer height = 108
integer taborder = 2
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "View Detail"
end type

event clicked;str_attributes lstr_attributes

lstr_attributes.attribute_count = 0

service_list.do_service(vaccine_history_service, lstr_attributes)

refresh()


end event

type r_1 from rectangle within u_immunization_v2
integer linethickness = 4
long fillcolor = 33538240
integer x = 2281
integer y = 304
integer width = 558
integer height = 280
end type

