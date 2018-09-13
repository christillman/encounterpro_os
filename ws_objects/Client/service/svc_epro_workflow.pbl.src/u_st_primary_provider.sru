$PBExportHeader$u_st_primary_provider.sru
forward
global type u_st_primary_provider from statictext
end type
end forward

global type u_st_primary_provider from statictext
integer width = 553
integer height = 108
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type
global u_st_primary_provider u_st_primary_provider

type variables
u_user user


end variables

forward prototypes
public subroutine initialize (string ps_user_id)
public function integer pick_user (boolean pb_auto_pick)
end prototypes

public subroutine initialize (string ps_user_id);user = user_list.find_user(ps_user_id)
if isnull(user) then
	text = "<None>"
	backcolor = color_object
else
	text = user.user_short_name
	backcolor = user.color
end if

end subroutine

public function integer pick_user (boolean pb_auto_pick);
user = user_list.pick_user("ALL")
if isnull(user) then return 0

text = user.user_short_name
backcolor = user.color

return 1







end function

event clicked;pick_user(false)

end event

on u_st_primary_provider.create
end on

on u_st_primary_provider.destroy
end on

