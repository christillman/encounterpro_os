$PBExportHeader$u_tabpage_component_properties.sru
forward
global type u_tabpage_component_properties from u_tabpage_component_base
end type
type cb_new_version from commandbutton within u_tabpage_component_properties
end type
type cb_configure from commandbutton within u_tabpage_component_properties
end type
type st_debug_mode from statictext within u_tabpage_component_properties
end type
type st_debug_mode_title from statictext within u_tabpage_component_properties
end type
type dw_installation_history from u_dw_pick_list within u_tabpage_component_properties
end type
type st_install_history_title from statictext within u_tabpage_component_properties
end type
type st_license_expiration from statictext within u_tabpage_component_properties
end type
type st_license_status from statictext within u_tabpage_component_properties
end type
type st_testing_version from statictext within u_tabpage_component_properties
end type
type st_normal_version from statictext within u_tabpage_component_properties
end type
type st_component_install_type from statictext within u_tabpage_component_properties
end type
type st_description from statictext within u_tabpage_component_properties
end type
type st_component_id from statictext within u_tabpage_component_properties
end type
type st_component_type from statictext within u_tabpage_component_properties
end type
type st_license_expiration_title from statictext within u_tabpage_component_properties
end type
type st_license_status_title from statictext within u_tabpage_component_properties
end type
type st_testing_version_title from statictext within u_tabpage_component_properties
end type
type st_normal_version_title from statictext within u_tabpage_component_properties
end type
type st_component_install_type_title from statictext within u_tabpage_component_properties
end type
type st_description_title from statictext within u_tabpage_component_properties
end type
type st_component_id_title from statictext within u_tabpage_component_properties
end type
type st_component_type_title from statictext within u_tabpage_component_properties
end type
end forward

global type u_tabpage_component_properties from u_tabpage_component_base
integer width = 3163
string text = "Properties"
cb_new_version cb_new_version
cb_configure cb_configure
st_debug_mode st_debug_mode
st_debug_mode_title st_debug_mode_title
dw_installation_history dw_installation_history
st_install_history_title st_install_history_title
st_license_expiration st_license_expiration
st_license_status st_license_status
st_testing_version st_testing_version
st_normal_version st_normal_version
st_component_install_type st_component_install_type
st_description st_description
st_component_id st_component_id
st_component_type st_component_type
st_license_expiration_title st_license_expiration_title
st_license_status_title st_license_status_title
st_testing_version_title st_testing_version_title
st_normal_version_title st_normal_version_title
st_component_install_type_title st_component_install_type_title
st_description_title st_description_title
st_component_id_title st_component_id_title
st_component_type_title st_component_type_title
end type
global u_tabpage_component_properties u_tabpage_component_properties

type variables
str_attributes component_attributes
end variables

forward prototypes
public function integer initialize ()
public subroutine refresh ()
end prototypes

public function integer initialize ();
this.event TRIGGER resize_tabpage()

refresh()


return 1


end function

public subroutine refresh ();u_ds_data luo_data
long ll_count
string ls_debug_mode

component = f_get_component_definition(component.component_id)

st_component_id.text = component.component_id
st_component_install_type.text = component.component_install_type
st_component_type.text = component.component_type
st_description.text = component.description
st_license_expiration.text = string(date(component.license_expiration_date))
st_license_status.text = component.license_status

if component.normal_version > 0 then
	st_normal_version.text = component.normal_version_name
else
	st_normal_version.text = "NA"
end if

if component.testing_version > 0 then
	st_testing_version.text = component.testing_version_name
else
	st_testing_version.text = "NA"
end if

dw_installation_history.settransobject(sqlca)
dw_installation_history.retrieve(component.component_id)


luo_data = CREATE u_ds_data

luo_data.set_dataobject("dw_sp_get_component_attributes")
ll_count = luo_data.retrieve(component.component_id, gnv_app.office_id, gnv_app.computer_id)
if ll_count > 0 then f_attribute_ds_to_str(luo_data, component_attributes)

DESTROY luo_data

ls_debug_mode = f_attribute_find_attribute(component_attributes, "debug_mode")
if f_string_to_boolean(ls_debug_mode) then
	st_debug_mode.text = "On"
else
	st_debug_mode.text = "Off"
end if

if allow_editing then
	st_debug_mode.borderstyle = StyleRaised!
	cb_configure.visible = true
	if component.owner_id = sqlca.customer_id then
		cb_new_version.visible = true
	else
		cb_new_version.visible = false
	end if
else
	st_debug_mode.borderstyle = StyleBox!
	cb_configure.visible = false
	cb_new_version.visible = false
end if


end subroutine

on u_tabpage_component_properties.create
int iCurrent
call super::create
this.cb_new_version=create cb_new_version
this.cb_configure=create cb_configure
this.st_debug_mode=create st_debug_mode
this.st_debug_mode_title=create st_debug_mode_title
this.dw_installation_history=create dw_installation_history
this.st_install_history_title=create st_install_history_title
this.st_license_expiration=create st_license_expiration
this.st_license_status=create st_license_status
this.st_testing_version=create st_testing_version
this.st_normal_version=create st_normal_version
this.st_component_install_type=create st_component_install_type
this.st_description=create st_description
this.st_component_id=create st_component_id
this.st_component_type=create st_component_type
this.st_license_expiration_title=create st_license_expiration_title
this.st_license_status_title=create st_license_status_title
this.st_testing_version_title=create st_testing_version_title
this.st_normal_version_title=create st_normal_version_title
this.st_component_install_type_title=create st_component_install_type_title
this.st_description_title=create st_description_title
this.st_component_id_title=create st_component_id_title
this.st_component_type_title=create st_component_type_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_new_version
this.Control[iCurrent+2]=this.cb_configure
this.Control[iCurrent+3]=this.st_debug_mode
this.Control[iCurrent+4]=this.st_debug_mode_title
this.Control[iCurrent+5]=this.dw_installation_history
this.Control[iCurrent+6]=this.st_install_history_title
this.Control[iCurrent+7]=this.st_license_expiration
this.Control[iCurrent+8]=this.st_license_status
this.Control[iCurrent+9]=this.st_testing_version
this.Control[iCurrent+10]=this.st_normal_version
this.Control[iCurrent+11]=this.st_component_install_type
this.Control[iCurrent+12]=this.st_description
this.Control[iCurrent+13]=this.st_component_id
this.Control[iCurrent+14]=this.st_component_type
this.Control[iCurrent+15]=this.st_license_expiration_title
this.Control[iCurrent+16]=this.st_license_status_title
this.Control[iCurrent+17]=this.st_testing_version_title
this.Control[iCurrent+18]=this.st_normal_version_title
this.Control[iCurrent+19]=this.st_component_install_type_title
this.Control[iCurrent+20]=this.st_description_title
this.Control[iCurrent+21]=this.st_component_id_title
this.Control[iCurrent+22]=this.st_component_type_title
end on

on u_tabpage_component_properties.destroy
call super::destroy
destroy(this.cb_new_version)
destroy(this.cb_configure)
destroy(this.st_debug_mode)
destroy(this.st_debug_mode_title)
destroy(this.dw_installation_history)
destroy(this.st_install_history_title)
destroy(this.st_license_expiration)
destroy(this.st_license_status)
destroy(this.st_testing_version)
destroy(this.st_normal_version)
destroy(this.st_component_install_type)
destroy(this.st_description)
destroy(this.st_component_id)
destroy(this.st_component_type)
destroy(this.st_license_expiration_title)
destroy(this.st_license_status_title)
destroy(this.st_testing_version_title)
destroy(this.st_normal_version_title)
destroy(this.st_component_install_type_title)
destroy(this.st_description_title)
destroy(this.st_component_id_title)
destroy(this.st_component_type_title)
end on

event resize_tabpage;call super::resize_tabpage;

dw_installation_history.height = height - dw_installation_history.y - 100


cb_new_version .y = height - cb_new_version.height - 50

end event

type cb_new_version from commandbutton within u_tabpage_component_properties
integer x = 32
integer y = 1416
integer width = 562
integer height = 76
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Version"
end type

event clicked;string ls_compile_name
long ll_count

ls_compile_name = f_new_component_version(component.component_id)
if isnull(ls_compile_name) then return

u_tab_component luo_parent

luo_parent = parent_tab

luo_parent.initialize(component.component_id, ls_compile_name)


end event

type cb_configure from commandbutton within u_tabpage_component_properties
integer x = 2190
integer y = 76
integer width = 704
integer height = 76
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Configure"
end type

event clicked;f_configure_component(component.component_id)

end event

type st_debug_mode from statictext within u_tabpage_component_properties
integer x = 2190
integer y = 700
integer width = 704
integer height = 76
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

event clicked;string ls_debug_mode

if not allow_editing then return

ls_debug_mode = f_attribute_find_attribute(component_attributes, "debug_mode")
if f_string_to_boolean(ls_debug_mode) then
	component_manager.set_component_debug_mode(component.component_id, false)
else
	component_manager.set_component_debug_mode(component.component_id, true)
end if

refresh()

end event

type st_debug_mode_title from statictext within u_tabpage_component_properties
integer x = 1595
integer y = 700
integer width = 571
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Debug Mode:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_installation_history from u_dw_pick_list within u_tabpage_component_properties
integer x = 763
integer y = 856
integer width = 2432
integer height = 416
integer taborder = 10
string dataobject = "dw_component_log"
boolean vscrollbar = true
end type

event clicked;call super::clicked;string ls_error_message

if not row > 0 then return

ls_error_message = object.error_message[row]
if len(ls_error_message) > 0 then
	openwithparm(w_pop_message, ls_error_message)
	return 
end if

end event

type st_install_history_title from statictext within u_tabpage_component_properties
integer x = 142
integer y = 856
integer width = 594
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Component History"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_license_expiration from statictext within u_tabpage_component_properties
integer x = 2190
integer y = 592
integer width = 704
integer height = 76
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

type st_license_status from statictext within u_tabpage_component_properties
integer x = 2190
integer y = 484
integer width = 704
integer height = 76
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

type st_testing_version from statictext within u_tabpage_component_properties
integer x = 759
integer y = 700
integer width = 704
integer height = 76
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

type st_normal_version from statictext within u_tabpage_component_properties
integer x = 759
integer y = 592
integer width = 704
integer height = 76
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

type st_component_install_type from statictext within u_tabpage_component_properties
integer x = 759
integer y = 484
integer width = 704
integer height = 76
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

type st_description from statictext within u_tabpage_component_properties
integer x = 759
integer y = 268
integer width = 1810
integer height = 76
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

type st_component_id from statictext within u_tabpage_component_properties
integer x = 759
integer y = 160
integer width = 969
integer height = 76
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

type st_component_type from statictext within u_tabpage_component_properties
integer x = 759
integer y = 52
integer width = 969
integer height = 76
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

type st_license_expiration_title from statictext within u_tabpage_component_properties
integer x = 1595
integer y = 592
integer width = 571
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "License Expiration:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_license_status_title from statictext within u_tabpage_component_properties
integer x = 1682
integer y = 484
integer width = 485
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "License Status:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_testing_version_title from statictext within u_tabpage_component_properties
integer x = 251
integer y = 700
integer width = 485
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Trial Version"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_normal_version_title from statictext within u_tabpage_component_properties
integer x = 251
integer y = 592
integer width = 485
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Normal Version"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_component_install_type_title from statictext within u_tabpage_component_properties
integer y = 484
integer width = 736
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Component Install Type"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_description_title from statictext within u_tabpage_component_properties
integer x = 251
integer y = 268
integer width = 485
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Description"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_component_id_title from statictext within u_tabpage_component_properties
integer x = 251
integer y = 160
integer width = 485
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Component ID"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_component_type_title from statictext within u_tabpage_component_properties
integer x = 210
integer y = 52
integer width = 526
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Component Type"
alignment alignment = right!
boolean focusrectangle = false
end type

