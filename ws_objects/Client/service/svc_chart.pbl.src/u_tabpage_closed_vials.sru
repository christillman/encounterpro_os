$PBExportHeader$u_tabpage_closed_vials.sru
forward
global type u_tabpage_closed_vials from u_tabpage
end type
type dw_closed_vials from u_dw_pick_list within u_tabpage_closed_vials
end type
type pb_down from picturebutton within u_tabpage_closed_vials
end type
type pb_up from picturebutton within u_tabpage_closed_vials
end type
type st_page from statictext within u_tabpage_closed_vials
end type
end forward

global type u_tabpage_closed_vials from u_tabpage
integer width = 1801
integer height = 756
dw_closed_vials dw_closed_vials
pb_down pb_down
pb_up pb_up
st_page st_page
end type
global u_tabpage_closed_vials u_tabpage_closed_vials

type variables
string vial_treatment_type = 'AllergyVialInstance'
u_component_service   service
end variables

forward prototypes
public subroutine refresh ()
end prototypes

public subroutine refresh ();long ll_parent_treatment_id
integer li_sts

dw_closed_vials.height = height

// pulls all the closed vials for the allergy root treatment
ll_parent_treatment_id = service.treatment.treatment_id
dw_closed_vials.settransobject(sqlca)
dw_closed_vials.reset()
li_sts = dw_closed_vials.retrieve(ll_parent_treatment_id, vial_treatment_type)
dw_closed_vials.set_page(1,pb_up,pb_down,st_page)

end subroutine

on u_tabpage_closed_vials.create
int iCurrent
call super::create
this.dw_closed_vials=create dw_closed_vials
this.pb_down=create pb_down
this.pb_up=create pb_up
this.st_page=create st_page
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_closed_vials
this.Control[iCurrent+2]=this.pb_down
this.Control[iCurrent+3]=this.pb_up
this.Control[iCurrent+4]=this.st_page
end on

on u_tabpage_closed_vials.destroy
call super::destroy
destroy(this.dw_closed_vials)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.st_page)
end on

type dw_closed_vials from u_dw_pick_list within u_tabpage_closed_vials
integer width = 1609
integer height = 736
integer taborder = 30
string dataobject = "dw_allergy_closed_vials"
boolean border = false
end type

event constructor;call super::constructor;settransobject(sqlca)
end event

type pb_down from picturebutton within u_tabpage_closed_vials
integer x = 1609
integer y = 140
integer width = 137
integer height = 116
integer taborder = 30
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_closed_vials.current_page
li_last_page = dw_closed_vials.last_page

dw_closed_vials.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type pb_up from picturebutton within u_tabpage_closed_vials
integer x = 1609
integer y = 16
integer width = 137
integer height = 116
integer taborder = 20
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;integer li_page

li_page = dw_closed_vials.current_page

dw_closed_vials.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type st_page from statictext within u_tabpage_closed_vials
integer x = 1609
integer y = 264
integer width = 133
integer height = 96
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "99 of 99"
boolean focusrectangle = false
end type

