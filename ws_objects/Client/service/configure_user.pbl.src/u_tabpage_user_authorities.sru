$PBExportHeader$u_tabpage_user_authorities.sru
forward
global type u_tabpage_user_authorities from u_tabpage_user_base
end type
type st_edit from statictext within u_tabpage_user_authorities
end type
type st_authority_title from statictext within u_tabpage_user_authorities
end type
type dw_authorities from u_dw_pick_list within u_tabpage_user_authorities
end type
end forward

global type u_tabpage_user_authorities from u_tabpage_user_base
string tag = "Consultant"
integer width = 3205
integer height = 1300
st_edit st_edit
st_authority_title st_authority_title
dw_authorities dw_authorities
end type
global u_tabpage_user_authorities u_tabpage_user_authorities

type variables
string authority_type
string authority_type_description
end variables

forward prototypes
public subroutine refresh ()
public function integer initialize ()
end prototypes

public subroutine refresh ();
st_authority_title.text = authority_type_description + " Association"

dw_authorities.settransobject(sqlca)
dw_authorities.retrieve(user.user_id)

end subroutine

public function integer initialize ();if isnull(authority_type) or trim(authority_type) = "" then
	authority_type = "Payor"
end if
authority_type_description = datalist.authority_type_description(authority_type)

return 1

end function

on u_tabpage_user_authorities.create
int iCurrent
call super::create
this.st_edit=create st_edit
this.st_authority_title=create st_authority_title
this.dw_authorities=create dw_authorities
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_edit
this.Control[iCurrent+2]=this.st_authority_title
this.Control[iCurrent+3]=this.dw_authorities
end on

on u_tabpage_user_authorities.destroy
call super::destroy
destroy(this.st_edit)
destroy(this.st_authority_title)
destroy(this.dw_authorities)
end on

event refresh;call super::refresh;dw_authorities.x = (width - dw_authorities.width) / 2
st_authority_title.x = dw_authorities.x
dw_authorities.height = height - st_authority_title.y - 30

st_edit.x = dw_authorities.x + dw_authorities.width + 30
st_edit.y = dw_authorities.y + dw_authorities.height - st_edit.height

dw_authorities.settransobject(sqlca)
dw_authorities.retrieve(user.user_id)

end event

type st_edit from statictext within u_tabpage_user_authorities
integer x = 2144
integer y = 1108
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

popup.data_row_count = 2
popup.items[1] = user.user_id
popup.items[2] = authority_type
openwithparm(w_authority_consultant,popup)

refresh()



end event

type st_authority_title from statictext within u_tabpage_user_authorities
integer x = 151
integer width = 2514
integer height = 84
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Authorities"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_authorities from u_dw_pick_list within u_tabpage_user_authorities
integer x = 690
integer y = 112
integer width = 1435
integer height = 1108
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_pref_prov_by_consultant"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

