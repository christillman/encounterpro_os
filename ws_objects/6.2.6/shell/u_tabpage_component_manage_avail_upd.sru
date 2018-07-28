HA$PBExportHeader$u_tabpage_component_manage_avail_upd.sru
forward
global type u_tabpage_component_manage_avail_upd from u_tabpage_component_manage_base
end type
type dw_components from u_dw_pick_list within u_tabpage_component_manage_avail_upd
end type
type st_info from statictext within u_tabpage_component_manage_avail_upd
end type
type st_title from statictext within u_tabpage_component_manage_avail_upd
end type
end forward

global type u_tabpage_component_manage_avail_upd from u_tabpage_component_manage_base
integer width = 3127
string text = "Available Updates"
dw_components dw_components
st_info st_info
st_title st_title
end type
global u_tabpage_component_manage_avail_upd u_tabpage_component_manage_avail_upd

event resize_tabpage;call super::resize_tabpage;
st_title.width = width

st_info.x = (width - st_info.width) / 2

dw_components.x = (width - dw_components.width) / 2
dw_components.height = height - dw_components.y - 50

end event

on u_tabpage_component_manage_avail_upd.create
int iCurrent
call super::create
this.dw_components=create dw_components
this.st_info=create st_info
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_components
this.Control[iCurrent+2]=this.st_info
this.Control[iCurrent+3]=this.st_title
end on

on u_tabpage_component_manage_avail_upd.destroy
call super::destroy
destroy(this.dw_components)
destroy(this.st_info)
destroy(this.st_title)
end on

type dw_components from u_dw_pick_list within u_tabpage_component_manage_avail_upd
integer x = 55
integer y = 300
integer width = 3026
integer height = 676
integer taborder = 10
string dataobject = "dw_components_available_upgrades"
end type

type st_info from statictext within u_tabpage_component_manage_avail_upd
integer x = 421
integer y = 92
integer width = 2295
integer height = 188
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "These are the components that have a production version available that is later than the version currently designated as the normal version."
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title from statictext within u_tabpage_component_manage_avail_upd
integer width = 3141
integer height = 112
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Available Updates"
alignment alignment = center!
boolean focusrectangle = false
end type

