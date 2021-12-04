$PBExportHeader$w_component_client_install.srw
forward
global type w_component_client_install from w_window_base
end type
type cb_ok from commandbutton within w_component_client_install
end type
type st_title from statictext within w_component_client_install
end type
type dw_components from u_dw_pick_list within w_component_client_install
end type
type st_info from statictext within w_component_client_install
end type
type st_client_title from statictext within w_component_client_install
end type
type st_client from statictext within w_component_client_install
end type
type st_just_in_time_title from statictext within w_component_client_install
end type
type st_just_in_time_install from statictext within w_component_client_install
end type
type st_trial_mode_title from statictext within w_component_client_install
end type
type st_component_trial_mode from statictext within w_component_client_install
end type
end forward

global type w_component_client_install from w_window_base
integer width = 3607
integer height = 1848
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
cb_ok cb_ok
st_title st_title
dw_components dw_components
st_info st_info
st_client_title st_client_title
st_client st_client
st_just_in_time_title st_just_in_time_title
st_just_in_time_install st_just_in_time_install
st_trial_mode_title st_trial_mode_title
st_component_trial_mode st_component_trial_mode
end type
global w_component_client_install w_component_client_install

type variables
boolean allow_editing

end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();string ls_allow_editing
long ll_count
long i
string ls_component_id
string ls_version_name
boolean lb_is_installed
boolean lb_component_trial_mode
boolean lb_just_in_time_installing

if allow_editing then
	ls_allow_editing = "Y"
else
	ls_allow_editing = "N"
end if

st_client.text = gnv_app.computername + "/" + gnv_app.windows_logon_id

if gnv_app.computer_id > 0 then
	st_client.text += "  (" + string(gnv_app.computer_id) + ")"
end if

ll_count = dw_components.retrieve(gnv_app.computer_id)

for i = 1 to ll_count
	ls_component_id = dw_components.object.component_id[i]
	ls_version_name = dw_components.object.version_name[i]
	
	lb_is_installed = component_manager.is_version_installed(ls_component_id, ls_version_name)
	if isnull(lb_is_installed) then
		dw_components.object.install_status[i] = "Unknown"
	elseif lb_is_installed then
		dw_components.object.install_status[i] = "Installed"
	else
		dw_components.object.install_status[i] = "Not Installed"
	end if
next

lb_component_trial_mode = datalist.get_preference_boolean("SYSTEM", "Component Trial Mode", false)
if lb_component_trial_mode then
	st_component_trial_mode.text = "On"
else
	st_component_trial_mode.text = "Off"
end if

lb_just_in_time_installing = datalist.get_preference_boolean("SYSTEM", "Just In Time Installation", false)
if lb_just_in_time_installing then
	st_just_in_time_install.text = "On"
else
	st_just_in_time_install.text = "Off"
end if

return 1

end function

event open;call super::open;str_popup popup
integer li_sts

st_title.width = width

st_info.width = width

st_client.x = (width - st_client.width) / 2
st_client_title.x = st_client.x - st_client_title.width - 20

cb_ok.x = width - cb_ok.width - 50
cb_ok.y = height - cb_ok.height - 50


dw_components.x = (width - dw_components.width) / 2
dw_components.height = cb_ok.y - dw_components.y - 50

st_component_trial_mode.y = dw_components.y + dw_components.height + 30
st_trial_mode_title.y = st_component_trial_mode.y + 4

st_just_in_time_install.y = st_component_trial_mode.y
st_just_in_time_title.y = st_trial_mode_title.y

st_component_trial_mode.x = dw_components.x + dw_components.width - st_component_trial_mode.width - 100
st_trial_mode_title.x = st_component_trial_mode.x - st_trial_mode_title.width - 20

st_just_in_time_title.x = dw_components.x + 100
st_just_in_time_install.x = st_just_in_time_title.x + st_just_in_time_title.width + 20

if user_list.is_user_privileged(current_user.user_id, "Edit System Config") then
	allow_editing = true
else
	allow_editing = false
end if


dw_components.settransobject(sqlca)

refresh()


end event

on w_component_client_install.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.st_title=create st_title
this.dw_components=create dw_components
this.st_info=create st_info
this.st_client_title=create st_client_title
this.st_client=create st_client
this.st_just_in_time_title=create st_just_in_time_title
this.st_just_in_time_install=create st_just_in_time_install
this.st_trial_mode_title=create st_trial_mode_title
this.st_component_trial_mode=create st_component_trial_mode
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.dw_components
this.Control[iCurrent+4]=this.st_info
this.Control[iCurrent+5]=this.st_client_title
this.Control[iCurrent+6]=this.st_client
this.Control[iCurrent+7]=this.st_just_in_time_title
this.Control[iCurrent+8]=this.st_just_in_time_install
this.Control[iCurrent+9]=this.st_trial_mode_title
this.Control[iCurrent+10]=this.st_component_trial_mode
end on

on w_component_client_install.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.st_title)
destroy(this.dw_components)
destroy(this.st_info)
destroy(this.st_client_title)
destroy(this.st_client)
destroy(this.st_just_in_time_title)
destroy(this.st_just_in_time_install)
destroy(this.st_trial_mode_title)
destroy(this.st_component_trial_mode)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_component_client_install
integer x = 2875
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_component_client_install
end type

type cb_ok from commandbutton within w_component_client_install
integer x = 2414
integer y = 1712
integer width = 489
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;
close(parent)

end event

type st_title from statictext within w_component_client_install
integer width = 2944
integer height = 108
boolean bringtotop = true
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Client Component Installation Status"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_components from u_dw_pick_list within w_component_client_install
integer x = 37
integer y = 372
integer width = 3346
integer height = 676
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_components_installable_status"
boolean vscrollbar = true
end type

event buttonclicked;call super::buttonclicked;string ls_component_id
string ls_version_name
integer li_sts

if isnull(row) or row <= 0 then return

ls_component_id = object.component_id[row]
if isnull(ls_component_id) or trim(ls_component_id) = "" then return

ls_version_name = object.version_name[row]

CHOOSE CASE lower(dwo.name)
	CASE "b_install"
		li_sts = component_manager.install_component_version(ls_component_id, ls_version_name)
		if li_sts <= 0 then
			openwithparm(w_pop_message, "Component Installation Failed")
		else
			openwithparm(w_pop_message, "Component Installation Succeeded")
		end if
END CHOOSE

refresh()

end event

event clicked;call super::clicked;string ls_version_name
string ls_component_id
string ls_arg
w_component_manage lw_window

if not row > 0 then return

CHOOSE CASE lower(lastcolumnname)
	CASE "version_name"
		ls_component_id = object.component_id[row]
		ls_version_name = object.version_name[row]
		ls_arg = ls_component_id + "|" + ls_version_name
		openwithparm(lw_window, ls_arg, "w_component_manage")
END CHOOSE


end event

type st_info from statictext within w_component_client_install
integer y = 132
integer width = 2944
integer height = 88
boolean bringtotop = true
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "These are the installable components and their installation status on this computer."
alignment alignment = center!
boolean focusrectangle = false
end type

type st_client_title from statictext within w_component_client_install
integer x = 411
integer y = 256
integer width = 425
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
string text = "Client:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_client from statictext within w_component_client_install
integer x = 873
integer y = 256
integer width = 1477
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "none"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_just_in_time_title from statictext within w_component_client_install
integer x = 119
integer y = 1068
integer width = 608
integer height = 72
boolean bringtotop = true
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Just In Time Install:"
boolean focusrectangle = false
end type

type st_just_in_time_install from statictext within w_component_client_install
integer x = 720
integer y = 1064
integer width = 201
integer height = 84
boolean bringtotop = true
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Off"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_trial_mode_title from statictext within w_component_client_install
integer x = 1006
integer y = 1068
integer width = 759
integer height = 72
boolean bringtotop = true
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Component Trial Mode:"
boolean focusrectangle = false
end type

type st_component_trial_mode from statictext within w_component_client_install
integer x = 1765
integer y = 1064
integer width = 201
integer height = 84
boolean bringtotop = true
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Off"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

