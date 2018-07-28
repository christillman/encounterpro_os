$PBExportHeader$w_component_manage_upgrades.srw
forward
global type w_component_manage_upgrades from w_window_base
end type
type cb_ok from commandbutton within w_component_manage_upgrades
end type
type st_title from statictext within w_component_manage_upgrades
end type
type dw_components from u_dw_pick_list within w_component_manage_upgrades
end type
type st_info from statictext within w_component_manage_upgrades
end type
type cbx_show_beta from checkbox within w_component_manage_upgrades
end type
type cbx_show_testing from checkbox within w_component_manage_upgrades
end type
type st_just_in_time_title from statictext within w_component_manage_upgrades
end type
type st_just_in_time_install from statictext within w_component_manage_upgrades
end type
end forward

global type w_component_manage_upgrades from w_window_base
integer width = 2935
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
cbx_show_beta cbx_show_beta
cbx_show_testing cbx_show_testing
st_just_in_time_title st_just_in_time_title
st_just_in_time_install st_just_in_time_install
end type
global w_component_manage_upgrades w_component_manage_upgrades

type variables
boolean allow_editing

end variables

forward prototypes
public function integer refresh ()
public function integer upgrade_component (string ps_component_id, string ps_version_name, string ps_show_beta, string ps_show_testing)
end prototypes

public function integer refresh ();string ls_show_beta
string ls_show_testing
string ls_allow_editing
long ll_count
boolean lb_just_in_time_installing

lb_just_in_time_installing = datalist.get_preference_boolean("SYSTEM", "Just In Time Installation", false)
if lb_just_in_time_installing then
	st_just_in_time_install.text = "On"
else
	st_just_in_time_install.text = "Off"
end if


if cbx_show_beta.checked then
	ls_show_beta = "Y"
else
	ls_show_beta = "N"
end if

if cbx_show_testing.checked then
	ls_show_testing = "Y"
else
	ls_show_testing = "N"
end if

if allow_editing then
	ls_allow_editing = "Y"
else
	ls_allow_editing = "N"
end if


ll_count = dw_components.retrieve(ls_show_beta, ls_show_testing, ls_allow_editing)

return 1

end function

public function integer upgrade_component (string ps_component_id, string ps_version_name, string ps_show_beta, string ps_show_testing);u_ds_data luo_data
long ll_normal_version
long ll_count
long ll_upgrade_to_version
string ls_upgrade_to_version_name
str_popup popup
str_popup_return popup_return
integer li_sts
long ll_row
string ls_find
string ls_component_description
string ls_message

SELECT normal_version, description
INTO :ll_normal_version, :ls_component_description
FROM c_Component_Definition
WHERE component_id = :ps_component_id;
if not tf_check() then return -1
if sqlca.sqlnrows = 0 then
	log.log(this, "upgrade_component()", "Component not found (" + ps_component_id + ")", 4)
	return -1
end if

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_c_component_version_upgrade_pick")
ll_count = luo_data.retrieve(ll_normal_version, ps_component_id, ps_show_beta, ps_show_testing)

ls_find = "version_name='" + ps_version_name + "'"
ll_row = luo_data.find(ls_find, 1, luo_data.rowcount())

if ll_count > 1 then
	if ll_row > 0 then
		popup.title = "There are more than one available versions.  Version " + ps_version_name + " is recommended.  Do you wish to..."
		popup.data_row_count = 2
		popup.items[1] = "Upgrade to Version " + ps_version_name
		popup.items[2] = "Upgrade to a Different Version"
		openwithparm(w_pop_choices_2, popup)
		li_sts = message.doubleparm
	else
		li_sts = 2
	end if
	
	if li_sts = 1 then
		ll_upgrade_to_version = luo_data.object.version[ll_row]
		ls_upgrade_to_version_name = luo_data.object.version_name[ll_row]
	else
		popup.data_row_count = 0
		popup.title = "Select Upgrade Version"
		popup.dataobject = "dw_c_component_version_upgrade_pick"
		popup.argument_count = 4
		popup.argument[1] = string(ll_normal_version)
		popup.argument[2] = ps_component_id
		popup.argument[3] = ps_show_beta
		popup.argument[4] = ps_show_testing
		popup.numeric_argument = true
		popup.datacolumn = 1
		popup.displaycolumn = 2
		popup.auto_singleton = true
		
		openwithparm(w_pop_pick, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return 0
		
		ll_upgrade_to_version = long(popup_return.items[1])
		ls_upgrade_to_version_name = popup_return.descriptions[1]
	end if
elseif ll_count = 1 then
	if ll_row > 0 then
		ll_upgrade_to_version = luo_data.object.version[1]
		ls_upgrade_to_version_name = luo_data.object.version_name[1]
	else
		openwithparm(w_pop_message, "The specified version (" + ps_version_name + ") is not available for upgrade")
		return 0
	end if
else
	openwithparm(w_pop_message, "No available upgrade versions found")
	return 0
end if

DESTROY luo_data

// one final check to make sure we have chosen a version to upgrade to
if isnull(ll_upgrade_to_version) or ll_upgrade_to_version <= 0 then return 0

openwithparm(w_pop_yes_no, "Are you sure you want to upgrade the " + ls_component_description + " component to version " + ls_upgrade_to_version_name + "?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return 0

UPDATE c_Component_Definition
SET normal_version = :ll_upgrade_to_version,
	testing_version = NULL
WHERE component_id = :ps_component_id;
if not tf_check() then return -1

setnull(ls_message)
sqlca.jmj_component_log(ps_component_id , &
						ll_upgrade_to_version,  &
						"Version Upgraded", & 
						datetime(today(), now()) ,  &
						computer_id ,  &
						windows_logon_id ,  &
						"OK" ,  &
						ls_message ,  &
						current_scribe.user_id  ) 
if not tf_check() then return -1

openwithparm(w_pop_message, "The " + ls_component_description + " component has successfully been upgraded to version " + ls_upgrade_to_version_name + ".  Client computers will automatically install this component as needed.")

refresh()

return 1


end function

event open;call super::open;str_popup popup
integer li_sts

st_title.width = width

st_info.x = (width - st_info.width) / 2

cb_ok.x = width - cb_ok.width - 50
cb_ok.y = height - cb_ok.height - 50

cbx_show_beta.y = height - cbx_show_beta.height - 20
cbx_show_testing.y = cbx_show_beta.y - cbx_show_testing.height

dw_components.x = (width - dw_components.width) / 2
dw_components.height = cbx_show_testing.y - dw_components.y - 50

st_just_in_time_install.y = dw_components.y + dw_components.height + 30
st_just_in_time_title.y = st_just_in_time_install.y + 4

st_just_in_time_title.x = dw_components.x + (dw_components.width - st_just_in_time_title.width - st_just_in_time_install.width - 20) / 2
st_just_in_time_install.x = st_just_in_time_title.x + st_just_in_time_title.width + 20

if user_list.is_user_privileged(current_user.user_id, "Edit System Config") then
	allow_editing = true
else
	allow_editing = false
end if

if lower(sqlca.database_mode) = "testing" then
	cbx_show_testing.checked = true
	cbx_show_beta.checked = true
else
	cbx_show_testing.checked = false
	cbx_show_testing.visible = false
	cbx_show_beta.checked = sqlca.beta_flag
end if



dw_components.settransobject(sqlca)

refresh()


end event

on w_component_manage_upgrades.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.st_title=create st_title
this.dw_components=create dw_components
this.st_info=create st_info
this.cbx_show_beta=create cbx_show_beta
this.cbx_show_testing=create cbx_show_testing
this.st_just_in_time_title=create st_just_in_time_title
this.st_just_in_time_install=create st_just_in_time_install
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.dw_components
this.Control[iCurrent+4]=this.st_info
this.Control[iCurrent+5]=this.cbx_show_beta
this.Control[iCurrent+6]=this.cbx_show_testing
this.Control[iCurrent+7]=this.st_just_in_time_title
this.Control[iCurrent+8]=this.st_just_in_time_install
end on

on w_component_manage_upgrades.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.st_title)
destroy(this.dw_components)
destroy(this.st_info)
destroy(this.cbx_show_beta)
destroy(this.cbx_show_testing)
destroy(this.st_just_in_time_title)
destroy(this.st_just_in_time_install)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_component_manage_upgrades
integer x = 2875
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_component_manage_upgrades
end type

type cb_ok from commandbutton within w_component_manage_upgrades
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

type st_title from statictext within w_component_manage_upgrades
integer width = 2944
integer height = 108
boolean bringtotop = true
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Component Upgrade Manager"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_components from u_dw_pick_list within w_component_manage_upgrades
integer x = 37
integer y = 372
integer width = 3026
integer height = 676
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_components_available_upgrades"
boolean vscrollbar = true
end type

event buttonclicked;call super::buttonclicked;string ls_component_id
string ls_version_name
string ls_show_beta
string ls_show_testing

if cbx_show_beta.checked then
	ls_show_beta = "Y"
else
	ls_show_beta = "N"
end if

if cbx_show_testing.checked then
	ls_show_testing = "Y"
else
	ls_show_testing = "N"
end if

if isnull(row) or row <= 0 then return

ls_component_id = object.component_id[row]
if isnull(ls_component_id) or trim(ls_component_id) = "" then return

ls_version_name = object.available_version_name[row]

CHOOSE CASE lower(dwo.name)
	CASE "b_upgrade"
		upgrade_component(ls_component_id, ls_version_name, ls_show_beta, ls_show_testing)
END CHOOSE


end event

event clicked;call super::clicked;string ls_version_name
string ls_component_id
string ls_arg
w_component_manage lw_window

if not row > 0 then return

CHOOSE CASE lower(lastcolumnname)
	CASE "compute_available_version"
		ls_component_id = object.component_id[row]
		ls_version_name = object.available_version_name[row]
		ls_arg = ls_component_id + "|" + ls_version_name
		openwithparm(lw_window, ls_arg, "w_component_manage")
	CASE "compute_normal_version"
		ls_component_id = object.component_id[row]
		ls_version_name = object.compute_normal_version[row]
		ls_arg = ls_component_id + "|" + ls_version_name
		openwithparm(lw_window, ls_arg, "w_component_manage")
END CHOOSE


end event

type st_info from statictext within w_component_manage_upgrades
integer x = 421
integer y = 128
integer width = 2199
integer height = 188
boolean bringtotop = true
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "These are the components that have a version available that is later than the version currently designated as the normal version."
alignment alignment = center!
boolean focusrectangle = false
end type

type cbx_show_beta from checkbox within w_component_manage_upgrades
integer x = 27
integer y = 1736
integer width = 485
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Show Beta"
end type

event clicked;refresh()

end event

type cbx_show_testing from checkbox within w_component_manage_upgrades
integer x = 27
integer y = 1656
integer width = 485
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Show Testing"
end type

event clicked;refresh()

end event

type st_just_in_time_title from statictext within w_component_manage_upgrades
integer x = 251
integer y = 1124
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
long backcolor = 33538240
string text = "Just In Time Install:"
boolean focusrectangle = false
end type

type st_just_in_time_install from statictext within w_component_manage_upgrades
integer x = 855
integer y = 1120
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

