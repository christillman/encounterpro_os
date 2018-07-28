HA$PBExportHeader$u_tabpage_user_document_routes.sru
forward
global type u_tabpage_user_document_routes from u_tabpage_user_base
end type
type st_allow_title from statictext within u_tabpage_user_document_routes
end type
type st_purpose_title from statictext within u_tabpage_user_document_routes
end type
type dw_document_route from u_dw_pick_list within u_tabpage_user_document_routes
end type
type dw_document_purpose from u_dw_pick_list within u_tabpage_user_document_routes
end type
type st_route_title from statictext within u_tabpage_user_document_routes
end type
end forward

global type u_tabpage_user_document_routes from u_tabpage_user_base
string tag = "All"
integer width = 2912
st_allow_title st_allow_title
st_purpose_title st_purpose_title
dw_document_route dw_document_route
dw_document_purpose dw_document_purpose
st_route_title st_route_title
end type
global u_tabpage_user_document_routes u_tabpage_user_document_routes

type variables
string erx_component_id = "E-Prescribing"

end variables

forward prototypes
public subroutine refresh ()
public function integer initialize ()
end prototypes

public subroutine refresh ();long ll_row
long ll_rowcount
string ls_document_route

ll_row = dw_document_route.get_selected_row( )
if isnull(ll_row) or ll_row <= 0 then ll_row = 1

dw_document_route.settransobject(sqlca)
ll_rowcount = dw_document_route.retrieve()
if ll_rowcount <= 0 then
	dw_document_purpose.reset()
	return
end if

ls_document_route = dw_document_route.object.document_route[ll_row]
dw_document_route.object.selected_flag[ll_row] = 1

dw_document_purpose.settransobject(sqlca)
dw_document_purpose.retrieve(user.user_id, ls_document_route)

end subroutine

public function integer initialize ();long ll_left_margin
long ll_gap
long ll_count

st_route_title.width = 1138
st_route_title.height = 88

dw_document_route.x = 23
dw_document_route.width = st_route_title.width
dw_document_route.y = st_route_title.height
dw_document_route.height = height - dw_document_route.y

dw_document_purpose.width = 1595

ll_left_margin = dw_document_route.x + dw_document_route.width
ll_gap = (width - dw_document_purpose.width - ll_left_margin) / 2

dw_document_purpose.x = ll_left_margin + ll_gap
dw_document_purpose.y = dw_document_route.y
dw_document_purpose.height = height - dw_document_purpose.y

st_purpose_title.x = dw_document_purpose.x + 59
st_purpose_title.height = st_route_title.height
st_purpose_title.width = 1207

st_allow_title.x = st_purpose_title.x + 1207
st_allow_title.height = st_route_title.height
st_allow_title.width = 251

SELECT count(*)
INTO :ll_count
FROM sysobjects 
WHERE type = 'U' 
AND name = 'c_Actor_Route_Purpose';
if not tf_check() then return -1

if ll_count = 0 then
	visible = false
end if


return 1

end function

on u_tabpage_user_document_routes.create
int iCurrent
call super::create
this.st_allow_title=create st_allow_title
this.st_purpose_title=create st_purpose_title
this.dw_document_route=create dw_document_route
this.dw_document_purpose=create dw_document_purpose
this.st_route_title=create st_route_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_allow_title
this.Control[iCurrent+2]=this.st_purpose_title
this.Control[iCurrent+3]=this.dw_document_route
this.Control[iCurrent+4]=this.dw_document_purpose
this.Control[iCurrent+5]=this.st_route_title
end on

on u_tabpage_user_document_routes.destroy
call super::destroy
destroy(this.st_allow_title)
destroy(this.st_purpose_title)
destroy(this.dw_document_route)
destroy(this.dw_document_purpose)
destroy(this.st_route_title)
end on

type st_allow_title from statictext within u_tabpage_user_document_routes
integer x = 2464
integer width = 251
integer height = 88
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 33538240
string text = "Allow"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_purpose_title from statictext within u_tabpage_user_document_routes
integer x = 1257
integer width = 1207
integer height = 88
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 33538240
string text = "Document Purpose"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_document_route from u_dw_pick_list within u_tabpage_user_document_routes
integer x = 23
integer y = 88
integer width = 1138
integer height = 1356
integer taborder = 20
string dataobject = "dw_c_document_route"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;string ls_document_route

ls_document_route = object.document_route[selected_row]

dw_document_purpose.retrieve(user.user_id, ls_document_route)

end event

type dw_document_purpose from u_dw_pick_list within u_tabpage_user_document_routes
integer x = 1198
integer y = 88
integer width = 1595
integer height = 1420
integer taborder = 10
string dataobject = "dw_jmj_get_actor_route_purposes"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;integer li_sts


//li_sts = set_id_number(selected_row)
if li_sts > 0 then
	refresh()
else
	clear_selected()
end if



end event

type st_route_title from statictext within u_tabpage_user_document_routes
integer width = 1138
integer height = 88
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 33538240
string text = "Document Route"
alignment alignment = center!
boolean focusrectangle = false
end type

