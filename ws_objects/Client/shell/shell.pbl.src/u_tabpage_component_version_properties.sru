$PBExportHeader$u_tabpage_component_version_properties.sru
forward
global type u_tabpage_component_version_properties from u_tabpage_component_base
end type
type cb_try_this_version from commandbutton within u_tabpage_component_version_properties
end type
type cb_use_this_version from commandbutton within u_tabpage_component_version_properties
end type
type st_status from statictext within u_tabpage_component_version_properties
end type
type st_component_data from statictext within u_tabpage_component_version_properties
end type
type st_component_location from statictext within u_tabpage_component_version_properties
end type
type st_installer from statictext within u_tabpage_component_version_properties
end type
type st_independence from statictext within u_tabpage_component_version_properties
end type
type st_owner from statictext within u_tabpage_component_version_properties
end type
type st_release_status_date_time from statictext within u_tabpage_component_version_properties
end type
type st_release_status from statictext within u_tabpage_component_version_properties
end type
type mle_notes from multilineedit within u_tabpage_component_version_properties
end type
type mle_version_description from multilineedit within u_tabpage_component_version_properties
end type
type st_version from statictext within u_tabpage_component_version_properties
end type
type st_version_description_title from statictext within u_tabpage_component_version_properties
end type
type st_notes_title from statictext within u_tabpage_component_version_properties
end type
type st_installer_title from statictext within u_tabpage_component_version_properties
end type
type st_independence_title from statictext within u_tabpage_component_version_properties
end type
type st_owner_title from statictext within u_tabpage_component_version_properties
end type
type st_status_title from statictext within u_tabpage_component_version_properties
end type
type st_release_date_title from statictext within u_tabpage_component_version_properties
end type
type st_release_status_title from statictext within u_tabpage_component_version_properties
end type
type st_component_data_title from statictext within u_tabpage_component_version_properties
end type
type st_component_location_title from statictext within u_tabpage_component_version_properties
end type
end forward

global type u_tabpage_component_version_properties from u_tabpage_component_base
integer width = 3008
integer height = 1508
cb_try_this_version cb_try_this_version
cb_use_this_version cb_use_this_version
st_status st_status
st_component_data st_component_data
st_component_location st_component_location
st_installer st_installer
st_independence st_independence
st_owner st_owner
st_release_status_date_time st_release_status_date_time
st_release_status st_release_status
mle_notes mle_notes
mle_version_description mle_version_description
st_version st_version
st_version_description_title st_version_description_title
st_notes_title st_notes_title
st_installer_title st_installer_title
st_independence_title st_independence_title
st_owner_title st_owner_title
st_status_title st_status_title
st_release_date_title st_release_date_title
st_release_status_title st_release_status_title
st_component_data_title st_component_data_title
st_component_location_title st_component_location_title
end type
global u_tabpage_component_version_properties u_tabpage_component_version_properties

type variables
str_component_version component_version
end variables

forward prototypes
public function integer initialize ()
public subroutine refresh ()
end prototypes

public function integer initialize ();
refresh()


this.event TRIGGER resize_tabpage()

return 1

end function

public subroutine refresh ();long ll_normal_version

component = f_get_component_definition(component.component_id)
component_version = f_get_component_version(component.component_id, component_version.version_name, false)

text = component_version.version_name

SELECT normal_version
INTO :ll_normal_version
FROM c_Component_Definition
WHERE component_id = :component_version.component_id;
if not tf_check() then return
if sqlca.sqlnrows = 0 then
	ll_normal_version = 0
end if

st_status.text = component_version.status
st_component_location.text = component_version.component_location
st_component_data.text = component_version.component_data
st_installer.text = component_version.installer
st_independence.text = component_version.independence
st_owner.text = component_version.owner_description
st_release_status_date_time.text = string(date(component_version.release_status_date_time))
st_release_status.text = component_version.release_status
mle_notes.text = component_version.notes
mle_version_description.text = component_version.version_description

if lower(text) = "default" then
	text = "Default Version"
	if isnull(component.normal_version) then
		cb_use_this_version.visible = false
	else
		cb_use_this_version.visible = true
	end if
	cb_try_this_version.visible = false
elseif ll_normal_version = component_version.version then
	cb_use_this_version.visible = false
	cb_try_this_version.visible = false
else
	cb_use_this_version.visible = true
	cb_try_this_version.visible = true
end if

end subroutine

on u_tabpage_component_version_properties.create
int iCurrent
call super::create
this.cb_try_this_version=create cb_try_this_version
this.cb_use_this_version=create cb_use_this_version
this.st_status=create st_status
this.st_component_data=create st_component_data
this.st_component_location=create st_component_location
this.st_installer=create st_installer
this.st_independence=create st_independence
this.st_owner=create st_owner
this.st_release_status_date_time=create st_release_status_date_time
this.st_release_status=create st_release_status
this.mle_notes=create mle_notes
this.mle_version_description=create mle_version_description
this.st_version=create st_version
this.st_version_description_title=create st_version_description_title
this.st_notes_title=create st_notes_title
this.st_installer_title=create st_installer_title
this.st_independence_title=create st_independence_title
this.st_owner_title=create st_owner_title
this.st_status_title=create st_status_title
this.st_release_date_title=create st_release_date_title
this.st_release_status_title=create st_release_status_title
this.st_component_data_title=create st_component_data_title
this.st_component_location_title=create st_component_location_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_try_this_version
this.Control[iCurrent+2]=this.cb_use_this_version
this.Control[iCurrent+3]=this.st_status
this.Control[iCurrent+4]=this.st_component_data
this.Control[iCurrent+5]=this.st_component_location
this.Control[iCurrent+6]=this.st_installer
this.Control[iCurrent+7]=this.st_independence
this.Control[iCurrent+8]=this.st_owner
this.Control[iCurrent+9]=this.st_release_status_date_time
this.Control[iCurrent+10]=this.st_release_status
this.Control[iCurrent+11]=this.mle_notes
this.Control[iCurrent+12]=this.mle_version_description
this.Control[iCurrent+13]=this.st_version
this.Control[iCurrent+14]=this.st_version_description_title
this.Control[iCurrent+15]=this.st_notes_title
this.Control[iCurrent+16]=this.st_installer_title
this.Control[iCurrent+17]=this.st_independence_title
this.Control[iCurrent+18]=this.st_owner_title
this.Control[iCurrent+19]=this.st_status_title
this.Control[iCurrent+20]=this.st_release_date_title
this.Control[iCurrent+21]=this.st_release_status_title
this.Control[iCurrent+22]=this.st_component_data_title
this.Control[iCurrent+23]=this.st_component_location_title
end on

on u_tabpage_component_version_properties.destroy
call super::destroy
destroy(this.cb_try_this_version)
destroy(this.cb_use_this_version)
destroy(this.st_status)
destroy(this.st_component_data)
destroy(this.st_component_location)
destroy(this.st_installer)
destroy(this.st_independence)
destroy(this.st_owner)
destroy(this.st_release_status_date_time)
destroy(this.st_release_status)
destroy(this.mle_notes)
destroy(this.mle_version_description)
destroy(this.st_version)
destroy(this.st_version_description_title)
destroy(this.st_notes_title)
destroy(this.st_installer_title)
destroy(this.st_independence_title)
destroy(this.st_owner_title)
destroy(this.st_status_title)
destroy(this.st_release_date_title)
destroy(this.st_release_status_title)
destroy(this.st_component_data_title)
destroy(this.st_component_location_title)
end on

event resize_tabpage;call super::resize_tabpage;
mle_version_description.width = width - mle_version_description.x - 200
st_component_location.width = width - st_component_location.x - 200
st_component_data.width = width - st_component_data.x - 200
mle_notes.width = width - mle_notes.x - 200
mle_notes.height = height - mle_notes.y - 100

end event

type cb_try_this_version from commandbutton within u_tabpage_component_version_properties
integer x = 2254
integer y = 1020
integer width = 599
integer height = 84
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Try This Version"
end type

event clicked;string ls_message
long ll_normal_version
long ll_testing_version
long ll_new_testing_version
string ls_component_description
str_popup_return popup_return

SELECT normal_version, testing_version, description
INTO :ll_normal_version, :ll_testing_version, :ls_component_description
FROM c_Component_Definition
WHERE component_id = :component_version.component_id;
if not tf_check() then return -1
if sqlca.sqlnrows = 0 then
	log.log(this, "u_tabpage_component_version_properties.cb_try_this_version.clicked:0014", "Component not found (" + component_version.component_id + ")", 4)
	return -1
end if

ll_new_testing_version = component_version.version
if isnull(ll_new_testing_version) or ll_new_testing_version <= 0 then
	openwithparm(w_pop_message, "You cannot trial the default version")
	return
end if

if ll_new_testing_version = ll_normal_version then
	openwithparm(w_pop_message, "You cannot trial the version that is already set as the normal version")
	return
end if

if ll_new_testing_version = ll_testing_version then
	openwithparm(w_pop_message, "This version is already the trial version")
	return
end if

if ll_testing_version > 0 then
	ls_message = "Are you sure you want to change the trial version of the " + ls_component_description + " component to " + component_version.version_name + "?"
else
	ls_message = "Are you sure you want to set the trial version of the " + ls_component_description + " component to " + component_version.version_name + "?"
end if

openwithparm(w_pop_yes_no, ls_message)
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return 0

UPDATE c_Component_Definition
SET testing_version = :ll_new_testing_version
WHERE component_id = :component_version.component_id;
if not tf_check() then return -1

setnull(ls_message)
sqlca.jmj_component_log(component.component_id , &
						component_version.version,  &
						"Trial Started", & 
						datetime(today(), now()) ,  &
						computer_id ,  &
						windows_logon_id ,  &
						"OK" ,  &
						ls_message ,  &
						current_scribe.user_id  ) 
if not tf_check() then return -1

openwithparm(w_pop_message, "The trial version of the " + ls_component_description + " component has successfully been set to " + component_version.version_name + ".  Client computers with the Component Trial Mode preference turned on will automatically install this component as needed.")

refresh()

end event

type cb_use_this_version from commandbutton within u_tabpage_component_version_properties
integer x = 1568
integer y = 1020
integer width = 599
integer height = 84
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Use This Version"
end type

event clicked;string ls_message
long ll_normal_version
long ll_new_normal_version
string ls_component_description
str_popup_return popup_return
string ls_operation

SELECT normal_version, description
INTO :ll_normal_version, :ls_component_description
FROM c_Component_Definition
WHERE component_id = :component_version.component_id;
if not tf_check() then return -1
if sqlca.sqlnrows = 0 then
	log.log(this, "u_tabpage_component_version_properties.cb_use_this_version.clicked:0014", "Component not found (" + component_version.component_id + ")", 4)
	return -1
end if

ll_new_normal_version = component_version.version
if isnull(ll_new_normal_version) or ll_new_normal_version <= 0 then
	ls_message = "Are you sure you want to use the default version for the component " + ls_component_description + "?  This is not reccomended."
	setnull(ll_new_normal_version)
	ls_operation = "Version Downgraded"
elseif ll_new_normal_version = ll_normal_version then
	openwithparm(w_pop_message, "This version is already set as the normal version for this component")
	return 0
elseif ll_new_normal_version < ll_normal_version then
	ls_message = "Are you sure you want to downgrade the " + ls_component_description + " component to version " + component_version.version_name + "?"
	ls_operation = "Version Downgraded"
else
	ls_message = "Are you sure you want to upgrade the " + ls_component_description + " component to version " + component_version.version_name + "?"
	ls_operation = "Version Upgraded"
end if


openwithparm(w_pop_yes_no, ls_message)
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return 0

UPDATE c_Component_Definition
SET normal_version = :ll_new_normal_version
WHERE component_id = :component_version.component_id;
if not tf_check() then return -1

setnull(ls_message)
sqlca.jmj_component_log(component_version.component_id , &
						ll_new_normal_version,  &
						ls_operation, & 
						datetime(today(), now()) ,  &
						computer_id ,  &
						windows_logon_id ,  &
						"OK" ,  &
						ls_message ,  &
						current_scribe.user_id  ) 
if not tf_check() then return -1

if isnull(ll_new_normal_version) then
	openwithparm(w_pop_message, "The normal version of the " + ls_component_description + " component has successfully been set to ~"Default~".")
else
	openwithparm(w_pop_message, "The normal version of the " + ls_component_description + " component has successfully been set to " + component_version.version_name + ".  Client computers will automatically install this component as needed.")
end if

refresh()

end event

type st_status from statictext within u_tabpage_component_version_properties
integer x = 690
integer y = 1024
integer width = 613
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type st_component_data from statictext within u_tabpage_component_version_properties
integer x = 690
integer y = 888
integer width = 2231
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type st_component_location from statictext within u_tabpage_component_version_properties
integer x = 690
integer y = 752
integer width = 2231
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type st_installer from statictext within u_tabpage_component_version_properties
integer x = 690
integer y = 480
integer width = 613
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type st_independence from statictext within u_tabpage_component_version_properties
integer x = 690
integer y = 344
integer width = 613
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type st_owner from statictext within u_tabpage_component_version_properties
integer x = 690
integer y = 616
integer width = 613
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type st_release_status_date_time from statictext within u_tabpage_component_version_properties
integer x = 690
integer y = 208
integer width = 613
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type st_release_status from statictext within u_tabpage_component_version_properties
integer x = 690
integer y = 72
integer width = 613
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type mle_notes from multilineedit within u_tabpage_component_version_properties
integer x = 690
integer y = 1160
integer width = 2231
integer height = 300
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean vscrollbar = true
boolean displayonly = true
end type

type mle_version_description from multilineedit within u_tabpage_component_version_properties
integer x = 1568
integer y = 144
integer width = 1353
integer height = 400
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean vscrollbar = true
boolean displayonly = true
end type

type st_version from statictext within u_tabpage_component_version_properties
integer width = 256
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean focusrectangle = false
end type

type st_version_description_title from statictext within u_tabpage_component_version_properties
integer x = 1568
integer y = 76
integer width = 640
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Version Description"
boolean focusrectangle = false
end type

type st_notes_title from statictext within u_tabpage_component_version_properties
integer x = 96
integer y = 1164
integer width = 562
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Version Notes"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_installer_title from statictext within u_tabpage_component_version_properties
integer x = 96
integer y = 484
integer width = 562
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Installer"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_independence_title from statictext within u_tabpage_component_version_properties
integer x = 96
integer y = 348
integer width = 562
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Independence"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_owner_title from statictext within u_tabpage_component_version_properties
integer x = 96
integer y = 620
integer width = 562
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Owner"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_status_title from statictext within u_tabpage_component_version_properties
integer x = 96
integer y = 1028
integer width = 562
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Status"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_release_date_title from statictext within u_tabpage_component_version_properties
integer x = 96
integer y = 212
integer width = 562
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Release_date"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_release_status_title from statictext within u_tabpage_component_version_properties
integer x = 96
integer y = 76
integer width = 562
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Release Status"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_component_data_title from statictext within u_tabpage_component_version_properties
integer x = 96
integer y = 892
integer width = 562
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = ".NET Class"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_component_location_title from statictext within u_tabpage_component_version_properties
integer x = 96
integer y = 756
integer width = 562
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = ".NET Display Name"
alignment alignment = right!
boolean focusrectangle = false
end type

