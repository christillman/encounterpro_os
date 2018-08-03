$PBExportHeader$u_tabpage_assessment_long_description.sru
forward
global type u_tabpage_assessment_long_description from u_tabpage
end type
type st_1 from statictext within u_tabpage_assessment_long_description
end type
type mle_long_description from multilineedit within u_tabpage_assessment_long_description
end type
end forward

global type u_tabpage_assessment_long_description from u_tabpage
integer width = 2848
integer height = 1088
st_1 st_1
mle_long_description mle_long_description
end type
global u_tabpage_assessment_long_description u_tabpage_assessment_long_description

type variables
boolean allow_editing

string assessment_id

// Fields managed on this tab
string long_description

end variables

forward prototypes
public function integer initialize ()
end prototypes

public function integer initialize ();
mle_long_description.width = width - (2 * mle_long_description.x)
mle_long_description.height = height - (2 * mle_long_description.y)

mle_long_description.text = long_description

if NOT allow_editing then
	mle_long_description.enabled = false
end if

return 1

end function

on u_tabpage_assessment_long_description.create
int iCurrent
call super::create
this.st_1=create st_1
this.mle_long_description=create mle_long_description
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.mle_long_description
end on

on u_tabpage_assessment_long_description.destroy
call super::destroy
destroy(this.st_1)
destroy(this.mle_long_description)
end on

type st_1 from statictext within u_tabpage_assessment_long_description
integer x = 133
integer y = 48
integer width = 503
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Long Description"
boolean focusrectangle = false
end type

type mle_long_description from multilineedit within u_tabpage_assessment_long_description
integer x = 133
integer y = 120
integer width = 2587
integer height = 736
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;long_description = text

end event

