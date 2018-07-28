$PBExportHeader$u_tabpage_report_config.sru
forward
global type u_tabpage_report_config from u_tabpage
end type
type cb_printers from commandbutton within u_tabpage_report_config
end type
type cb_template from commandbutton within u_tabpage_report_config
end type
type cb_configure_office from commandbutton within u_tabpage_report_config
end type
type st_configure_title from statictext within u_tabpage_report_config
end type
type st_1 from statictext within u_tabpage_report_config
end type
type cb_configure_default from commandbutton within u_tabpage_report_config
end type
type cb_change_status from commandbutton within u_tabpage_report_config
end type
type st_status from statictext within u_tabpage_report_config
end type
type st_report_id from statictext within u_tabpage_report_config
end type
type st_report_id_title from statictext within u_tabpage_report_config
end type
type pb_down from u_picture_button within u_tabpage_report_config
end type
type pb_up from u_picture_button within u_tabpage_report_config
end type
type st_page from statictext within u_tabpage_report_config
end type
type dw_reports from u_dw_pick_list within u_tabpage_report_config
end type
end forward

global type u_tabpage_report_config from u_tabpage
integer width = 2875
integer height = 1268
string text = "none"
cb_printers cb_printers
cb_template cb_template
cb_configure_office cb_configure_office
st_configure_title st_configure_title
st_1 st_1
cb_configure_default cb_configure_default
cb_change_status cb_change_status
st_status st_status
st_report_id st_report_id
st_report_id_title st_report_id_title
pb_down pb_down
pb_up pb_up
st_page st_page
dw_reports dw_reports
end type
global u_tabpage_report_config u_tabpage_report_config

type variables

string status = "OK"

end variables

forward prototypes
public function integer initialize ()
public subroutine refresh ()
private function integer configure_report (string ps_office_id)
end prototypes

public function integer initialize ();dw_reports.height = height

st_status.y = height - st_status.height - 16

return 1


end function

public subroutine refresh ();
dw_reports.settransobject(sqlca)
dw_reports.retrieve(tag, status)
dw_reports.set_page(1, pb_up, pb_down, st_page)

st_report_id.text = ""

if status = "OK" then
	st_status.text = "Active"
	cb_change_status.text = "Make Inactive"
else
	st_status.text = "Inactive"
	cb_change_status.text = "Make Active"
end if

cb_configure_default.enabled = false
cb_configure_office.enabled = false
cb_change_status.enabled = false
cb_printers.enabled = false

end subroutine

private function integer configure_report (string ps_office_id);string ls_component_id
u_component_report luo_report
str_attributes lstr_attributes
integer li_sts
u_ds_data luo_data
integer li_count
integer i
integer li_attribute_sequence

SELECT component_id
INTO :ls_component_id
FROM c_Report_Definition
WHERE report_id = :st_report_id.text;
If Not tf_check() Then Return -1

// If any component defined for selected report then
If Isnull(ls_component_id) Then
	log.log(this, "clicked", "Null component_id (" + st_report_id.text + ")", 4)
	Return -1
Else
	luo_report = component_manager.get_component(ls_component_id)
	If Isnull(luo_report) Then
		log.log(this, "clicked", "Error getting component (" + ls_component_id + ")", 4)
		Return -1
	End If
End If

// Get the existing attributes
luo_data = CREATE u_ds_data
if isnull(ps_office_id) then
	luo_data.set_dataobject("dw_c_report_attribute")
	li_count = luo_data.retrieve(st_report_id.text)
else
	luo_data.set_dataobject("dw_o_report_attribute")
	li_count = luo_data.retrieve(st_report_id.text, ps_office_id)
end if

if li_count < 0 then
	log.log(this, "configure_report()", "Error getting attributes", 4)
	return -1
end if

f_attribute_ds_to_str(luo_data, lstr_attributes)

if not luo_report.is_params(st_report_id.text, "Config") then
	openwithparm(w_pop_message, "This report has no configuration parameters")
	component_manager.destroy_component(luo_report)
	return 0
end if

li_sts = f_get_params(st_report_id.text, "Config", lstr_attributes)
if li_sts < 0 then return -1

// If the office_id is null then store the params in the c_Report_Definition table
if isnull(ps_office_id) then
	for i = 1 to lstr_attributes.attribute_count
		UPDATE c_Report_Attribute
		SET value = :lstr_attributes.attribute[i].value
		WHERE report_id = :st_report_id.text
		AND attribute = :lstr_attributes.attribute[i].attribute;
		if not tf_check() then return -1
		if sqlca.sqlnrows = 0 then
			INSERT INTO c_Report_Attribute (
				report_id,
				attribute,
				value)
			VALUES (
				:st_report_id.text,
				:lstr_attributes.attribute[i].attribute,
				:lstr_attributes.attribute[i].value);
			if not tf_check() then return -1
		end if
	next
else
	for i = 1 to lstr_attributes.attribute_count
		UPDATE o_Report_Attribute
		SET value = :lstr_attributes.attribute[i].value
		WHERE report_id = :st_report_id.text
		AND office_id = :ps_office_id
		AND attribute = :lstr_attributes.attribute[i].attribute;
		if not tf_check() then return -1
		if sqlca.sqlnrows = 0 then
			INSERT INTO o_Report_Attribute (
				report_id,
				office_id,
				attribute,
				value)
			VALUES (
				:st_report_id.text,
				:ps_office_id,
				:lstr_attributes.attribute[i].attribute,
				:lstr_attributes.attribute[i].value);
			if not tf_check() then return -1
		end if
	next
end if

DESTROY luo_data			
component_manager.destroy_component(luo_report)


return 1


end function

on u_tabpage_report_config.create
int iCurrent
call super::create
this.cb_printers=create cb_printers
this.cb_template=create cb_template
this.cb_configure_office=create cb_configure_office
this.st_configure_title=create st_configure_title
this.st_1=create st_1
this.cb_configure_default=create cb_configure_default
this.cb_change_status=create cb_change_status
this.st_status=create st_status
this.st_report_id=create st_report_id
this.st_report_id_title=create st_report_id_title
this.pb_down=create pb_down
this.pb_up=create pb_up
this.st_page=create st_page
this.dw_reports=create dw_reports
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_printers
this.Control[iCurrent+2]=this.cb_template
this.Control[iCurrent+3]=this.cb_configure_office
this.Control[iCurrent+4]=this.st_configure_title
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.cb_configure_default
this.Control[iCurrent+7]=this.cb_change_status
this.Control[iCurrent+8]=this.st_status
this.Control[iCurrent+9]=this.st_report_id
this.Control[iCurrent+10]=this.st_report_id_title
this.Control[iCurrent+11]=this.pb_down
this.Control[iCurrent+12]=this.pb_up
this.Control[iCurrent+13]=this.st_page
this.Control[iCurrent+14]=this.dw_reports
end on

on u_tabpage_report_config.destroy
call super::destroy
destroy(this.cb_printers)
destroy(this.cb_template)
destroy(this.cb_configure_office)
destroy(this.st_configure_title)
destroy(this.st_1)
destroy(this.cb_configure_default)
destroy(this.cb_change_status)
destroy(this.st_status)
destroy(this.st_report_id)
destroy(this.st_report_id_title)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.st_page)
destroy(this.dw_reports)
end on

type cb_printers from commandbutton within u_tabpage_report_config
integer x = 2386
integer y = 480
integer width = 347
integer height = 112
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Printers"
end type

event clicked;
openwithparm(w_report_printer, st_report_id.text)

end event

type cb_template from commandbutton within u_tabpage_report_config
boolean visible = false
integer x = 2299
integer y = 1084
integer width = 421
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Template"
end type

event clicked;

openwithparm(w_pop_message, "This feature is not currently supported")
//openwithparm(w_encounterpro_report_template_edit, st_report_id.text)

end event

type cb_configure_office from commandbutton within u_tabpage_report_config
integer x = 1979
integer y = 480
integer width = 347
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Per Office"
end type

event clicked;string ls_office_id
str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_office_pick"
popup.datacolumn = 1
popup.displaycolumn = 2
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_office_id = popup_return.items[1]

configure_report(ls_office_id)

end event

type st_configure_title from statictext within u_tabpage_report_config
integer x = 1842
integer y = 372
integer width = 617
integer height = 84
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 33538240
string text = "Configure"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within u_tabpage_report_config
integer x = 1390
integer y = 1012
integer width = 434
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Show"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_configure_default from commandbutton within u_tabpage_report_config
integer x = 1573
integer y = 480
integer width = 347
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Default"
end type

event clicked;string ls_office_id

setnull(ls_office_id)

configure_report(ls_office_id)

end event

type cb_change_status from commandbutton within u_tabpage_report_config
integer x = 1829
integer y = 788
integer width = 608
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Make Inactive"
end type

event clicked;string ls_status
string ls_state
str_popup_return popup_return

if status = "OK" then
	ls_status = "NA"
	ls_state = "inactive"
else
	ls_status = "OK"
	ls_state = "active"
end if

openwithparm(w_pop_yes_no, "Are you sure you wish to make this report " + ls_state + "?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return


UPDATE c_Report_Definition
SET status = :ls_status
WHERE report_id = :st_report_id.text;
if not tf_check() then return

refresh()

end event

type st_status from statictext within u_tabpage_report_config
integer x = 1390
integer y = 1084
integer width = 434
integer height = 112
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Active"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if status = "OK" then
	status = "NA"
	text = "Inactive"
else
	status = "OK"
	text = "Active"
end if

refresh()

end event

type st_report_id from statictext within u_tabpage_report_config
integer x = 1559
integer y = 188
integer width = 1239
integer height = 72
integer textsize = -9
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

type st_report_id_title from statictext within u_tabpage_report_config
integer x = 1586
integer y = 120
integer width = 325
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Report ID: "
boolean focusrectangle = false
end type

type pb_down from u_picture_button within u_tabpage_report_config
integer x = 1390
integer y = 140
integer width = 137
integer height = 116
integer taborder = 30
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;string ls_temp
integer li_page
integer li_last_page

li_page = dw_reports.current_page
li_last_page = dw_reports.last_page

dw_reports.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type pb_up from u_picture_button within u_tabpage_report_config
integer x = 1390
integer y = 12
integer width = 137
integer height = 116
integer taborder = 20
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;string ls_temp
integer li_page

li_page = dw_reports.current_page

dw_reports.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type st_page from statictext within u_tabpage_report_config
integer x = 1536
integer y = 12
integer width = 338
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99/99"
boolean focusrectangle = false
end type

type dw_reports from u_dw_pick_list within u_tabpage_report_config
integer width = 1408
integer height = 1208
integer taborder = 10
string dataobject = "dw_report_by_type_list"
boolean border = false
end type

event selected;call super::selected;string ls_report_id
u_component_report luo_report
string ls_template
string ls_component_id

st_report_id.text = object.report_id[selected_row]
ls_component_id = object.component_id[selected_row]
ls_template = object.template[selected_row]

cb_configure_default.enabled = true
cb_configure_office.enabled = true
cb_change_status.enabled = true
cb_printers.enabled = true

if upper(ls_component_id) = "RPT_RTF" then
	cb_template.visible = true
	if isnull(ls_template) then
		cb_template.weight = 400
	else
		cb_template.weight = 700
	end if
else
	cb_template.visible = false
end if

end event

event unselected;call super::unselected;cb_configure_default.enabled = false
cb_configure_office.enabled = false
cb_change_status.enabled = false
cb_printers.enabled = false

cb_template.visible = false

end event

