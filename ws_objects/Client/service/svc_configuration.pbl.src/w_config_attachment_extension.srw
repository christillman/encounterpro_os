$PBExportHeader$w_config_attachment_extension.srw
forward
global type w_config_attachment_extension from w_window_base
end type
type st_title from statictext within w_config_attachment_extension
end type
type dw_attachment_extension from u_dw_pick_list within w_config_attachment_extension
end type
type cb_finished from commandbutton within w_config_attachment_extension
end type
type cb_cancel from commandbutton within w_config_attachment_extension
end type
type cb_config from commandbutton within w_config_attachment_extension
end type
end forward

global type w_config_attachment_extension from w_window_base
integer width = 2322
integer height = 1292
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_title st_title
dw_attachment_extension dw_attachment_extension
cb_finished cb_finished
cb_cancel cb_cancel
cb_config cb_config
end type
global w_config_attachment_extension w_config_attachment_extension

type variables
datawindowchild dwc_type
datawindowchild dwc_component

string extension

end variables

on w_config_attachment_extension.create
int iCurrent
call super::create
this.st_title=create st_title
this.dw_attachment_extension=create dw_attachment_extension
this.cb_finished=create cb_finished
this.cb_cancel=create cb_cancel
this.cb_config=create cb_config
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.dw_attachment_extension
this.Control[iCurrent+3]=this.cb_finished
this.Control[iCurrent+4]=this.cb_cancel
this.Control[iCurrent+5]=this.cb_config
end on

on w_config_attachment_extension.destroy
call super::destroy
destroy(this.st_title)
destroy(this.dw_attachment_extension)
destroy(this.cb_finished)
destroy(this.cb_cancel)
destroy(this.cb_config)
end on

event open;call super::open;long ll_count

extension = message.stringparm


dw_attachment_extension.GetChild("default_attachment_type", dwc_type)
dw_attachment_extension.GetChild("component_id", dwc_component)

dwc_type.settransobject(sqlca)
ll_count = dwc_type.retrieve()

dwc_component.settransobject(sqlca)
ll_count = dwc_component.retrieve()

dw_attachment_extension.settransobject(sqlca)
ll_count = dw_attachment_extension.retrieve(extension)
if ll_count <> 1 then
	log.log(this, "w_config_attachment_extension:open", "attachment extension not found (" + extension + ")", 4)
	close(this)
	return
end if




end event

type pb_epro_help from w_window_base`pb_epro_help within w_config_attachment_extension
integer x = 2857
integer y = 8
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_config_attachment_extension
end type

type st_title from statictext within w_config_attachment_extension
integer width = 2322
integer height = 100
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Attachment File Type Configuration"
alignment alignment = center!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_attachment_extension from u_dw_pick_list within w_config_attachment_extension
integer y = 120
integer width = 2286
integer height = 864
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_attachment_extension_edit"
boolean border = false
end type

type cb_finished from commandbutton within w_config_attachment_extension
integer x = 1851
integer y = 1156
integer width = 421
integer height = 100
integer taborder = 21
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
boolean default = true
end type

event clicked;integer li_sts

li_sts = dw_attachment_extension.update()
if li_sts <= 0 then
	openwithparm(w_pop_message, "Updating file type failed")
	return
end if

close(parent)

end event

type cb_cancel from commandbutton within w_config_attachment_extension
integer x = 46
integer y = 1156
integer width = 421
integer height = 100
integer taborder = 31
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;close(parent)

end event

type cb_config from commandbutton within w_config_attachment_extension
integer x = 960
integer y = 1024
integer width = 402
integer height = 112
integer taborder = 31
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Configure"
end type

event clicked;string ls_component_id
u_ds_data luo_data
str_attributes lstr_attributes
integer li_sts
integer li_count
integer i
integer li_attribute_sequence
string ls_temp
string ls_id
str_attributes lstr_state_attributes
string ls_param_mode

ls_param_mode = "Config"
ls_component_id = dw_attachment_extension.object.component_id[1]

SELECT CAST(id AS varchar(40))
INTO :ls_id
FROM dbo.fn_components()
WHERE component_id = :ls_component_id;
if not tf_check() then return

if not config_mode and not f_any_params(ls_id, ls_param_mode) then
	openwithparm(w_pop_message, "The attachment component (" +  ls_component_id + ") has no ~"" + ls_param_mode + "~" parameters")
	return 0
end if

// Get the existing attributes
luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_c_attachment_extension_attribute")
li_count = luo_data.retrieve(extension)

if li_count < 0 then
	log.log(this, "w_config_attachment_extension.cb_config.clicked:0033", "Error getting attributes", 4)
	return -1
end if

f_attribute_ds_to_str(luo_data, lstr_attributes)

li_sts = f_get_params_with_state(ls_id, ls_param_mode, lstr_attributes, lstr_state_attributes)
if li_sts < 0 then return -1

// Transfer the attributes back into the datawindow
f_attribute_str_to_ds_with_removal(lstr_attributes, luo_data)

// Make sure each row has the extension
for i = 1 to luo_data.rowcount()
	luo_data.object.extension[i] = extension
next

li_sts = luo_data.update()
if li_sts < 0 then return -1

DESTROY luo_data			

end event

