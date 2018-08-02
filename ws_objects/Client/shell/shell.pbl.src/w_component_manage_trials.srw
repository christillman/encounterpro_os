$PBExportHeader$w_component_manage_trials.srw
forward
global type w_component_manage_trials from w_window_base
end type
type cb_ok from commandbutton within w_component_manage_trials
end type
type st_title from statictext within w_component_manage_trials
end type
type dw_components from u_dw_pick_list within w_component_manage_trials
end type
type st_info from statictext within w_component_manage_trials
end type
type st_just_in_time_title from statictext within w_component_manage_trials
end type
type st_just_in_time_install from statictext within w_component_manage_trials
end type
end forward

global type w_component_manage_trials from w_window_base
integer width = 2953
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
st_just_in_time_title st_just_in_time_title
st_just_in_time_install st_just_in_time_install
end type
global w_component_manage_trials w_component_manage_trials

type variables
boolean allow_editing

end variables

forward prototypes
public function integer refresh ()
public function integer upgrade_component (string ps_component_id, string ps_version_name)
public function integer stop_trial (string ps_component_id, string ps_version_name)
end prototypes

public function integer refresh ();long ll_count
boolean lb_just_in_time_installing

lb_just_in_time_installing = datalist.get_preference_boolean("SYSTEM", "Just In Time Installation", false)
if lb_just_in_time_installing then
	st_just_in_time_install.text = "On"
else
	st_just_in_time_install.text = "Off"
end if

ll_count = dw_components.retrieve()

return 1

end function

public function integer upgrade_component (string ps_component_id, string ps_version_name);long ll_count
str_popup popup
str_popup_return popup_return
integer li_sts
string ls_component_description
string ls_message
long ll_version

SELECT description
INTO :ls_component_description
FROM c_Component_Definition
WHERE component_id = :ps_component_id;
if not tf_check() then return -1
if sqlca.sqlnrows = 0 then
	log.log(this, "w_component_manage_trials.upgrade_component.0015", "Component not found (" + ps_component_id + ")", 4)
	return -1
end if

SELECT max(version)
INTO :ll_version
FROM c_Component_Version
WHERE component_id = :ps_component_id
AND compile_name = :ps_version_name;
if not tf_check() then return -1
if isnull(ll_version) then
	log.log(this, "w_component_manage_trials.upgrade_component.0015", "Component Version not found (" + ps_component_id + ", " + ps_version_name + ")", 4)
	return -1
end if

openwithparm(w_pop_yes_no, "Are you sure you want to upgrade the " + ls_component_description + " component to version " + ps_version_name + "?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return 0

UPDATE c_Component_Definition
SET normal_version = testing_version,
	testing_version = NULL
WHERE component_id = :ps_component_id;
if not tf_check() then return -1

setnull(ls_message)
sqlca.jmj_component_log(ps_component_id , &
						ll_version,  &
						"Trial Stopped", & 
						datetime(today(), now()) ,  &
						computer_id ,  &
						windows_logon_id ,  &
						"OK" ,  &
						ls_message ,  &
						current_scribe.user_id  ) 
if not tf_check() then return -1

setnull(ls_message)
sqlca.jmj_component_log(ps_component_id , &
						ll_version,  &
						"Version Upgraded", & 
						datetime(today(), now()) ,  &
						computer_id ,  &
						windows_logon_id ,  &
						"OK" ,  &
						ls_message ,  &
						current_scribe.user_id  ) 
if not tf_check() then return -1

openwithparm(w_pop_message, "The " + ls_component_description + " component has successfully been upgraded to version " + ps_version_name + ".  Client computers will automatically install this component as needed.")

refresh()

return 1


end function

public function integer stop_trial (string ps_component_id, string ps_version_name);long ll_count
str_popup popup
str_popup_return popup_return
integer li_sts
string ls_component_description
string ls_message
long ll_version

SELECT description
INTO :ls_component_description
FROM c_Component_Definition
WHERE component_id = :ps_component_id;
if not tf_check() then return -1
if sqlca.sqlnrows = 0 then
	log.log(this, "w_component_manage_trials.stop_trial.0015", "Component not found (" + ps_component_id + ")", 4)
	return -1
end if

SELECT max(version)
INTO :ll_version
FROM c_Component_Version
WHERE component_id = :ps_component_id
AND compile_name = :ps_version_name;
if not tf_check() then return -1
if isnull(ll_version) then
	log.log(this, "w_component_manage_trials.stop_trial.0015", "Component Version not found (" + ps_component_id + ", " + ps_version_name + ")", 4)
	return -1
end if

openwithparm(w_pop_yes_no, "Are you sure you want to stop the trial of version " + ps_version_name + " of the " + ls_component_description + " component?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return 0

UPDATE c_Component_Definition
SET testing_version = NULL
WHERE component_id = :ps_component_id;
if not tf_check() then return -1

setnull(ls_message)
sqlca.jmj_component_log(ps_component_id , &
						ll_version,  &
						"Trial Stopped", & 
						datetime(today(), now()) ,  &
						computer_id ,  &
						windows_logon_id ,  &
						"OK" ,  &
						ls_message ,  &
						current_scribe.user_id  ) 
if not tf_check() then return -1

openwithparm(w_pop_message, "The trial of version " + ps_version_name + " of the " + ls_component_description + " component has been stopped.")

refresh()

return 1


end function

event open;call super::open;str_popup popup
integer li_sts

st_title.width = width

st_info.x = (width - st_info.width) / 2

cb_ok.x = width - cb_ok.width - 50
cb_ok.y = height - cb_ok.height - 50

dw_components.x = (width - dw_components.width) / 2
dw_components.height = cb_ok.y - dw_components.y - 50

st_just_in_time_install.y = dw_components.y + dw_components.height + 30
st_just_in_time_title.y = st_just_in_time_install.y + 4

st_just_in_time_title.x = dw_components.x + (dw_components.width - st_just_in_time_title.width - st_just_in_time_install.width - 20) / 2
st_just_in_time_install.x = st_just_in_time_title.x + st_just_in_time_title.width + 20

if user_list.is_user_privileged(current_user.user_id, "Edit System Config") then
	allow_editing = true
else
	allow_editing = false
end if


dw_components.settransobject(sqlca)

refresh()


end event

on w_component_manage_trials.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.st_title=create st_title
this.dw_components=create dw_components
this.st_info=create st_info
this.st_just_in_time_title=create st_just_in_time_title
this.st_just_in_time_install=create st_just_in_time_install
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.dw_components
this.Control[iCurrent+4]=this.st_info
this.Control[iCurrent+5]=this.st_just_in_time_title
this.Control[iCurrent+6]=this.st_just_in_time_install
end on

on w_component_manage_trials.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.st_title)
destroy(this.dw_components)
destroy(this.st_info)
destroy(this.st_just_in_time_title)
destroy(this.st_just_in_time_install)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_component_manage_trials
integer x = 2875
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_component_manage_trials
end type

type cb_ok from commandbutton within w_component_manage_trials
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

type st_title from statictext within w_component_manage_trials
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
string text = "Component Trial Manager"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_components from u_dw_pick_list within w_component_manage_trials
integer x = 9
integer y = 372
integer width = 3543
integer height = 676
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_component_trials"
boolean vscrollbar = true
end type

event buttonclicked;call super::buttonclicked;string ls_component_id
string ls_version_name

if isnull(row) or row <= 0 then return

ls_component_id = object.component_id[row]
if isnull(ls_component_id) or trim(ls_component_id) = "" then return

ls_version_name = object.testing_version_name[row]

CHOOSE CASE lower(dwo.name)
	CASE "b_stop_trial"
		stop_trial(ls_component_id, ls_version_name)
	CASE "b_upgrade_site"
		upgrade_component(ls_component_id, ls_version_name)
END CHOOSE


end event

event clicked;call super::clicked;string ls_version_name
string ls_component_id
string ls_arg
w_component_manage lw_window

if not row > 0 then return

CHOOSE CASE lower(lastcolumnname)
	CASE "testing_version_name"
		ls_component_id = object.component_id[row]
		ls_version_name = object.testing_version_name[row]
		ls_arg = ls_component_id + "|" + ls_version_name
		openwithparm(lw_window, ls_arg, "w_component_manage")
END CHOOSE


end event

type st_info from statictext within w_component_manage_trials
integer x = 91
integer y = 128
integer width = 2775
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
string text = "These are the components and versions that are currently in trial.  These versions will be used at every computer for which the Component Trial Mode preference is set to ~"Yes~"."
alignment alignment = center!
boolean focusrectangle = false
end type

type st_just_in_time_title from statictext within w_component_manage_trials
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

type st_just_in_time_install from statictext within w_component_manage_trials
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

