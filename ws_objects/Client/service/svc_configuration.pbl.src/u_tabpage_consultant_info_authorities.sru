$PBExportHeader$u_tabpage_consultant_info_authorities.sru
forward
global type u_tabpage_consultant_info_authorities from u_tabpage
end type
type st_5 from statictext within u_tabpage_consultant_info_authorities
end type
type st_4 from statictext within u_tabpage_consultant_info_authorities
end type
type dw_authorities from u_dw_pick_list within u_tabpage_consultant_info_authorities
end type
end forward

global type u_tabpage_consultant_info_authorities from u_tabpage
integer width = 3205
integer height = 1300
st_5 st_5
st_4 st_4
dw_authorities dw_authorities
end type
global u_tabpage_consultant_info_authorities u_tabpage_consultant_info_authorities

type variables
string consultant_id


end variables

forward prototypes
public function integer initialize (string ps_key)
public subroutine refresh ()
end prototypes

public function integer initialize (string ps_key);consultant_id = ps_key


return 1

end function

public subroutine refresh ();
dw_authorities.settransobject(sqlca)
dw_authorities.retrieve(consultant_id)

end subroutine

on u_tabpage_consultant_info_authorities.create
int iCurrent
call super::create
this.st_5=create st_5
this.st_4=create st_4
this.dw_authorities=create dw_authorities
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_5
this.Control[iCurrent+2]=this.st_4
this.Control[iCurrent+3]=this.dw_authorities
end on

on u_tabpage_consultant_info_authorities.destroy
call super::destroy
destroy(this.st_5)
destroy(this.st_4)
destroy(this.dw_authorities)
end on

event refresh;call super::refresh;dw_authorities.settransobject(sqlca)
dw_authorities.retrieve(consultant_id)

end event

type st_5 from statictext within u_tabpage_consultant_info_authorities
integer x = 2158
integer y = 844
integer width = 183
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "..."
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup	popup

popup.data_row_count = 1
popup.items[1] = consultant_id
openwithparm(w_authority_consultant,popup)

refresh()



end event

type st_4 from statictext within u_tabpage_consultant_info_authorities
integer x = 690
integer y = 32
integer width = 1435
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Authorities"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_authorities from u_dw_pick_list within u_tabpage_consultant_info_authorities
integer x = 690
integer y = 112
integer width = 1435
integer height = 848
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_pref_prov_by_consultant"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

