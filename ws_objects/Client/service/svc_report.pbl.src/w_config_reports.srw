$PBExportHeader$w_config_reports.srw
forward
global type w_config_reports from w_window_base
end type
type cb_finished from commandbutton within w_config_reports
end type
type st_title from statictext within w_config_reports
end type
type st_2 from statictext within w_config_reports
end type
type st_report_description from statictext within w_config_reports
end type
type cb_change_name from commandbutton within w_config_reports
end type
type cb_printers from commandbutton within w_config_reports
end type
type cb_change_status from commandbutton within w_config_reports
end type
type st_config_object_id from statictext within w_config_reports
end type
type st_config_object_id_title from statictext within w_config_reports
end type
type cb_template from commandbutton within w_config_reports
end type
type dw_report_attributes from u_dw_pick_list within w_config_reports
end type
type st_report_attributes_title from statictext within w_config_reports
end type
type st_attributes_office from statictext within w_config_reports
end type
type st_5 from statictext within w_config_reports
end type
type st_status from statictext within w_config_reports
end type
type st_status_title from statictext within w_config_reports
end type
type st_context_object from statictext within w_config_reports
end type
type st_context_object_title from statictext within w_config_reports
end type
type st_component from statictext within w_config_reports
end type
type st_component_title from statictext within w_config_reports
end type
type cb_change_component from commandbutton within w_config_reports
end type
type cb_change_context from commandbutton within w_config_reports
end type
type st_no_attributes_defined from statictext within w_config_reports
end type
type cb_define_params from commandbutton within w_config_reports
end type
type st_report_category from statictext within w_config_reports
end type
type st_report_category_title from statictext within w_config_reports
end type
type cb_change_report_category from commandbutton within w_config_reports
end type
type dw_component_attributes from u_dw_pick_list within w_config_reports
end type
type st_component_attributes_title from statictext within w_config_reports
end type
type st_no_component_attributes_defined from statictext within w_config_reports
end type
type cb_clear_component_attributes from commandbutton within w_config_reports
end type
type cb_copy_report from commandbutton within w_config_reports
end type
type st_not_copyable from statictext within w_config_reports
end type
type st_owner from statictext within w_config_reports
end type
type st_owner_title from statictext within w_config_reports
end type
type cb_checkout from commandbutton within w_config_reports
end type
type st_checkout from statictext within w_config_reports
end type
type st_checkout_title from statictext within w_config_reports
end type
type st_version from statictext within w_config_reports
end type
type st_version_title from statictext within w_config_reports
end type
end forward

global type w_config_reports from w_window_base
string title = "Report Configuration"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_finished cb_finished
st_title st_title
st_2 st_2
st_report_description st_report_description
cb_change_name cb_change_name
cb_printers cb_printers
cb_change_status cb_change_status
st_config_object_id st_config_object_id
st_config_object_id_title st_config_object_id_title
cb_template cb_template
dw_report_attributes dw_report_attributes
st_report_attributes_title st_report_attributes_title
st_attributes_office st_attributes_office
st_5 st_5
st_status st_status
st_status_title st_status_title
st_context_object st_context_object
st_context_object_title st_context_object_title
st_component st_component
st_component_title st_component_title
cb_change_component cb_change_component
cb_change_context cb_change_context
st_no_attributes_defined st_no_attributes_defined
cb_define_params cb_define_params
st_report_category st_report_category
st_report_category_title st_report_category_title
cb_change_report_category cb_change_report_category
dw_component_attributes dw_component_attributes
st_component_attributes_title st_component_attributes_title
st_no_component_attributes_defined st_no_component_attributes_defined
cb_clear_component_attributes cb_clear_component_attributes
cb_copy_report cb_copy_report
st_not_copyable st_not_copyable
st_owner st_owner
st_owner_title st_owner_title
cb_checkout cb_checkout
st_checkout st_checkout
st_checkout_title st_checkout_title
st_version st_version
st_version_title st_version_title
end type
global w_config_reports w_config_reports

type variables
u_component_service service
str_config_object_info config_object_info

string config_object_id

string displayed_office_id

boolean editable

end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();long ll_count
string ls_component_id
integer li_sts
//u_ds_data luo_data

li_sts = f_get_config_object_info(config_object_id, config_object_info)
if li_sts <= 0 then
	log.log(this, "w_config_reports.refresh:0008", "Error getting config object info (" + config_object_id + ")", 4)
	return -1
end if

st_config_object_id.text = config_object_id

st_owner.text = config_object_info.owner_description
st_title.text = wordcap(config_object_info.config_object_type) + " Configuration"

if isnull(config_object_id) or trim(config_object_id) = "" then
	log.log(this, "w_config_reports.refresh:0018", "Invalid config_object_id", 4)
	return -1
end if

//luo_data = CREATE u_ds_data
//luo_data.set_dataobject("dw_report_data")
//ll_sts = luo_data.retrieve(config_object_id)
//if ll_sts < 0 then
//	log.log(this, "w_config_reports.refresh:0026", "Error retrieving report data (" + config_object_id + ")", 4)
//	return -1
//end if
//if ll_sts = 0 then
//	log.log(this, "w_config_reports.refresh:0030", "report not found (" + config_object_id + ")", 4)
//	return -1
//end if

st_report_description.text = config_object_info.description
st_report_category.text = config_object_info.config_object_category
st_context_object.text = config_object_info.context_object
//installed_version = luo_data.object.installed_version[1]
//installed_version_status = luo_data.object.installed_version_status[1]

// Get the report component
SELECT component_id
INTO :ls_component_id
FROM c_Report_Definition
WHERE report_id = :config_object_id;
if not tf_check() then return -1

st_version.text = string(config_object_info.installed_version)
if len(config_object_info.installed_version_release_sts) > 0 then st_version.text += " - " + wordcap(config_object_info.installed_version_release_sts)

if config_object_info.owner_id = sqlca.customer_id then
	st_checkout.visible = true
	cb_checkout.visible = true
	st_checkout_title.visible = true
	if lower(config_object_info.installed_version_status) = "checkedout" then
		editable = true
		st_checkout.text = "Checked Out"
		cb_checkout.text = "Check In"
	else
		editable = false
		st_checkout.text = "Checked In"
		cb_checkout.text = "Check Out"
	end if
else
	st_checkout.visible = false
	cb_checkout.visible = false
	st_checkout_title.visible = false
	editable = false
end if

// Component logic
SELECT description
INTO :st_component.text
FROM dbo.fn_components()
WHERE component_id = :ls_component_id;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then st_component.text = "NA"

//ls_status = luo_data.object.status[1]

if config_object_info.status = "OK" then
	st_status.text = "Active"
	cb_change_status.text = "Make Inactive"
else
	st_status.text = "Inactive"
	cb_change_status.text = "Make Active"
end if

if len(displayed_office_id) > 0 and displayed_office_id <> "<Default>" then
	SELECT description
	INTO :st_attributes_office.text
	FROM c_Office
	WHERE office_id = :displayed_office_id;
	if not tf_check() then return -1
else
	displayed_office_id = "<Default>"
	st_attributes_office.text = "<Default>"
end if

dw_report_attributes.settransobject(sqlca)
ll_count = dw_report_attributes.retrieve(config_object_id, displayed_office_id, "Config")
if ll_count <= 0 then
	st_no_attributes_defined.visible = true
else
	st_no_attributes_defined.visible = false
end if

dw_component_attributes.settransobject(sqlca)
ll_count = dw_component_attributes.retrieve(config_object_id, "Config")
if ll_count <= 0 then
	st_no_component_attributes_defined.visible = true
else
	st_no_component_attributes_defined.visible = false
end if


if config_object_info.copyable or config_object_info.owner_id = sqlca.customer_id then
	cb_copy_report.visible = true
	st_not_copyable.visible = false
else
	cb_copy_report.visible = false
	st_not_copyable.visible = true
end if



if editable then
	cb_change_name.visible = true
	cb_change_report_category.visible = true
	cb_change_context.visible = true
	cb_change_component.visible = true
	st_no_component_attributes_defined.enabled = true
	dw_component_attributes.enabled = true
	if lower(ls_component_id) = "rpt_rtf" then
		cb_template.visible = true
	else
		cb_template.visible = false
	end if
	cb_clear_component_attributes.visible = true
	cb_define_params.visible = true
else
	cb_change_name.visible = false
	cb_change_report_category.visible = false
	cb_change_context.visible = false
	cb_change_component.visible = false
	st_no_component_attributes_defined.enabled = false
	dw_component_attributes.enabled = false
	cb_template.visible = false
	cb_clear_component_attributes.visible = false
	cb_define_params.visible = false
end if


return 1

end function

on w_config_reports.create
int iCurrent
call super::create
this.cb_finished=create cb_finished
this.st_title=create st_title
this.st_2=create st_2
this.st_report_description=create st_report_description
this.cb_change_name=create cb_change_name
this.cb_printers=create cb_printers
this.cb_change_status=create cb_change_status
this.st_config_object_id=create st_config_object_id
this.st_config_object_id_title=create st_config_object_id_title
this.cb_template=create cb_template
this.dw_report_attributes=create dw_report_attributes
this.st_report_attributes_title=create st_report_attributes_title
this.st_attributes_office=create st_attributes_office
this.st_5=create st_5
this.st_status=create st_status
this.st_status_title=create st_status_title
this.st_context_object=create st_context_object
this.st_context_object_title=create st_context_object_title
this.st_component=create st_component
this.st_component_title=create st_component_title
this.cb_change_component=create cb_change_component
this.cb_change_context=create cb_change_context
this.st_no_attributes_defined=create st_no_attributes_defined
this.cb_define_params=create cb_define_params
this.st_report_category=create st_report_category
this.st_report_category_title=create st_report_category_title
this.cb_change_report_category=create cb_change_report_category
this.dw_component_attributes=create dw_component_attributes
this.st_component_attributes_title=create st_component_attributes_title
this.st_no_component_attributes_defined=create st_no_component_attributes_defined
this.cb_clear_component_attributes=create cb_clear_component_attributes
this.cb_copy_report=create cb_copy_report
this.st_not_copyable=create st_not_copyable
this.st_owner=create st_owner
this.st_owner_title=create st_owner_title
this.cb_checkout=create cb_checkout
this.st_checkout=create st_checkout
this.st_checkout_title=create st_checkout_title
this.st_version=create st_version
this.st_version_title=create st_version_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_finished
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_report_description
this.Control[iCurrent+5]=this.cb_change_name
this.Control[iCurrent+6]=this.cb_printers
this.Control[iCurrent+7]=this.cb_change_status
this.Control[iCurrent+8]=this.st_config_object_id
this.Control[iCurrent+9]=this.st_config_object_id_title
this.Control[iCurrent+10]=this.cb_template
this.Control[iCurrent+11]=this.dw_report_attributes
this.Control[iCurrent+12]=this.st_report_attributes_title
this.Control[iCurrent+13]=this.st_attributes_office
this.Control[iCurrent+14]=this.st_5
this.Control[iCurrent+15]=this.st_status
this.Control[iCurrent+16]=this.st_status_title
this.Control[iCurrent+17]=this.st_context_object
this.Control[iCurrent+18]=this.st_context_object_title
this.Control[iCurrent+19]=this.st_component
this.Control[iCurrent+20]=this.st_component_title
this.Control[iCurrent+21]=this.cb_change_component
this.Control[iCurrent+22]=this.cb_change_context
this.Control[iCurrent+23]=this.st_no_attributes_defined
this.Control[iCurrent+24]=this.cb_define_params
this.Control[iCurrent+25]=this.st_report_category
this.Control[iCurrent+26]=this.st_report_category_title
this.Control[iCurrent+27]=this.cb_change_report_category
this.Control[iCurrent+28]=this.dw_component_attributes
this.Control[iCurrent+29]=this.st_component_attributes_title
this.Control[iCurrent+30]=this.st_no_component_attributes_defined
this.Control[iCurrent+31]=this.cb_clear_component_attributes
this.Control[iCurrent+32]=this.cb_copy_report
this.Control[iCurrent+33]=this.st_not_copyable
this.Control[iCurrent+34]=this.st_owner
this.Control[iCurrent+35]=this.st_owner_title
this.Control[iCurrent+36]=this.cb_checkout
this.Control[iCurrent+37]=this.st_checkout
this.Control[iCurrent+38]=this.st_checkout_title
this.Control[iCurrent+39]=this.st_version
this.Control[iCurrent+40]=this.st_version_title
end on

on w_config_reports.destroy
call super::destroy
destroy(this.cb_finished)
destroy(this.st_title)
destroy(this.st_2)
destroy(this.st_report_description)
destroy(this.cb_change_name)
destroy(this.cb_printers)
destroy(this.cb_change_status)
destroy(this.st_config_object_id)
destroy(this.st_config_object_id_title)
destroy(this.cb_template)
destroy(this.dw_report_attributes)
destroy(this.st_report_attributes_title)
destroy(this.st_attributes_office)
destroy(this.st_5)
destroy(this.st_status)
destroy(this.st_status_title)
destroy(this.st_context_object)
destroy(this.st_context_object_title)
destroy(this.st_component)
destroy(this.st_component_title)
destroy(this.cb_change_component)
destroy(this.cb_change_context)
destroy(this.st_no_attributes_defined)
destroy(this.cb_define_params)
destroy(this.st_report_category)
destroy(this.st_report_category_title)
destroy(this.cb_change_report_category)
destroy(this.dw_component_attributes)
destroy(this.st_component_attributes_title)
destroy(this.st_no_component_attributes_defined)
destroy(this.cb_clear_component_attributes)
destroy(this.cb_copy_report)
destroy(this.st_not_copyable)
destroy(this.st_owner)
destroy(this.st_owner_title)
destroy(this.cb_checkout)
destroy(this.st_checkout)
destroy(this.st_checkout_title)
destroy(this.st_version)
destroy(this.st_version_title)
end on

event open;call super::open;str_popup_return popup_return
integer li_sts
str_pick_config_object lstr_pick_config_object
w_window_base lw_window

config_object_id = message.stringparm
service = message.powerobjectparm

dw_component_attributes.object.compute_attribute.width = dw_component_attributes.width - 100
dw_report_attributes.object.compute_attribute.width = dw_report_attributes.width - 100

if isnull(config_object_id) or trim(config_object_id) = "" then
	service.get_attribute( "config_object_id", config_object_id)
	if isnull(config_object_id) then
		service.get_attribute( "report_id", config_object_id)
	end if
end if

if isnull(config_object_id) or trim(config_object_id) = "" then
	// If there is no config_object_id then we don't really want this window, we want the pick-config-object window
	// in edit mode, but for historical reasons we need to call this window first.
	

	// Get needed info into local variables
	lstr_pick_config_object.config_object_type = service.get_attribute("config_object_type")
	lstr_pick_config_object.mode = "EDIT"
	if isnull(lstr_pick_config_object.config_object_type) then
		lstr_pick_config_object.config_object_type = "Report"
	end if
	setnull(lstr_pick_config_object.context_object)
	
	// Close this window
	popup_return.item_count = 1
	popup_return.items[1] = "OK"
	closewithreturn(this, popup_return)
	
	// Open the window we really wanted in the first place
	openwithparm(lw_window, lstr_pick_config_object, "w_pick_config_object")

	// End this script
	return
end if

refresh()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_config_reports
boolean visible = true
integer x = 2094
integer y = 1604
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_config_reports
integer x = 64
integer y = 1512
end type

type cb_finished from commandbutton within w_config_reports
integer x = 2414
integer y = 1600
integer width = 443
integer height = 108
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type st_title from statictext within w_config_reports
integer width = 2917
integer height = 108
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Report Configuration"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_config_reports
integer x = 18
integer y = 136
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Description:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_report_description from statictext within w_config_reports
integer x = 434
integer y = 136
integer width = 1906
integer height = 188
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type cb_change_name from commandbutton within w_config_reports
integer x = 2382
integer y = 140
integer width = 521
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Change Name"
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_description
long ll_count

DO WHILE true
	popup.title = "Enter title of new report"
	openwithparm(w_pop_prompt_string, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return
	
	ls_description = popup_return.items[1]
	
	SELECT count(*)
	INTO :ll_count
	FROM c_Report_Definition
	WHERE description = :ls_description;
	if not tf_check() then return
	if ll_count > 0 then
		openwithparm(w_pop_message, "There is already a report with that title.  Please enter a different title for the new report.")
	else
		exit
	end if
LOOP

openwithparm(w_pop_yes_no, "Are you sure you wish to update the name of this report to " + ls_description + "?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return


UPDATE c_Config_Object
SET description = :ls_description
WHERE config_object_id = :config_object_id;
if not tf_check() then return

refresh()

end event

type cb_printers from commandbutton within w_config_reports
integer x = 50
integer y = 1596
integer width = 608
integer height = 112
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Configure Printers"
end type

event clicked;
openwithparm(w_report_printer, st_config_object_id.text)

end event

type cb_change_status from commandbutton within w_config_reports
integer x = 910
integer y = 960
integer width = 434
integer height = 72
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Make Inactive"
end type

event clicked;str_popup_return popup_return

if config_object_info.status = "OK" then
	openwithparm(w_pop_yes_no, "Are you sure you want to make this " + lower(config_object_info.config_object_type) + " inactive?")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return
	
	UPDATE c_config_object
	SET status = 'NA'
	WHERE config_object_id =:config_object_info.config_object_id;
	if not tf_check() then return

	openwithparm(w_pop_yes_no, "Do you want to remove this " + lower(config_object_info.config_object_type) + " from all short-lists?")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return
	
	DELETE FROM u_top_20
	WHERE top_20_code LIKE 'config_object%'
	AND item_id = :config_object_info.config_object_id;
	if not tf_check() then return
else
	openwithparm(w_pop_yes_no, "Are you sure you want to make this " + lower(config_object_info.config_object_type) + " active?")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return
	
	UPDATE c_config_object
	SET status = 'OK'
	WHERE config_object_id =:config_object_info.config_object_id;
	if not tf_check() then return
end if

refresh()

end event

type st_config_object_id from statictext within w_config_reports
integer x = 439
integer y = 460
integer width = 1239
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

event clicked;clipboard(text)

end event

type st_config_object_id_title from statictext within w_config_reports
integer x = 73
integer y = 464
integer width = 343
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "ID: "
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_template from commandbutton within w_config_reports
integer x = 1157
integer y = 1596
integer width = 608
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Set Template"
end type

event clicked;

openwithparm(w_pop_message, "This feature is not currently supported")
//openwithparm(w_encounterpro_report_template_edit, st_config_object_id.text)

end event

type dw_report_attributes from u_dw_pick_list within w_config_reports
integer x = 1774
integer y = 688
integer width = 1029
integer height = 592
integer taborder = 21
boolean bringtotop = true
string dataobject = "dw_report_att_small"
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;
f_configure_report(config_object_id, displayed_office_id)

refresh()

end event

type st_report_attributes_title from statictext within w_config_reports
integer x = 1911
integer y = 428
integer width = 754
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Show Attributes for Office"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_attributes_office from statictext within w_config_reports
integer x = 1856
integer y = 492
integer width = 864
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "<Default>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_office_pick"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.add_blank_row = true
popup.blank_text = "<Default>"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

displayed_office_id = popup_return.items[1]

if displayed_office_id = "" then setnull(displayed_office_id)

refresh()

end event

type st_5 from statictext within w_config_reports
integer x = 1774
integer y = 620
integer width = 1029
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Config Attributes"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_status from statictext within w_config_reports
integer x = 439
integer y = 960
integer width = 416
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_status_title from statictext within w_config_reports
integer x = 14
integer y = 964
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Pick Status: "
alignment alignment = right!
boolean focusrectangle = false
end type

type st_context_object from statictext within w_config_reports
integer x = 439
integer y = 660
integer width = 558
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_context_object_title from statictext within w_config_reports
integer x = 14
integer y = 664
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Context: "
alignment alignment = right!
boolean focusrectangle = false
end type

type st_component from statictext within w_config_reports
integer x = 439
integer y = 760
integer width = 558
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_component_title from statictext within w_config_reports
integer x = 14
integer y = 764
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Component: "
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_change_component from commandbutton within w_config_reports
integer x = 1051
integer y = 760
integer width = 434
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Change"
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_component_id

popup.dataobject = "dw_component_pick"
popup.datacolumn = 1
popup.displaycolumn = 4
popup.argument_count = 1
popup.argument[1] = "REPORT"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_component_id = popup_return.items[1]

openwithparm(w_pop_yes_no, "Are you sure you wish to update the report component for this report to " + popup_return.descriptions[1] + "?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return


UPDATE c_Report_Definition
SET component_id = :ls_component_id
WHERE report_id = :config_object_id;
if not tf_check() then return

refresh()

end event

type cb_change_context from commandbutton within w_config_reports
integer x = 1051
integer y = 660
integer width = 434
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Change"
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_context_object

popup.dataobject = "dw_domain_notranslate_list"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = "CONTEXT_OBJECT"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_context_object = popup_return.items[1]

openwithparm(w_pop_yes_no, "Are you sure you wish to update the context for this report to " + popup_return.descriptions[1] + "?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return


UPDATE c_Report_Definition
SET report_type = :ls_context_object
WHERE report_id = :config_object_id;
if not tf_check() then return

refresh()

end event

type st_no_attributes_defined from statictext within w_config_reports
integer x = 1870
integer y = 928
integer width = 832
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "No Config Attributes Defined"
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;
f_configure_report(config_object_id, displayed_office_id)

refresh()

end event

type cb_define_params from commandbutton within w_config_reports
integer x = 1925
integer y = 1340
integer width = 727
integer height = 112
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Define Report Atributes"
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.data_row_count = 2
popup.items[1] = "Define Config Attributes"
popup.items[2] = "Define Runtime Attributes"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

popup.data_row_count = 2
popup.items[1] = config_object_id
if popup_return.item_indexes[1] = 1 then
	popup.items[2] = "Config"
else
	popup.items[2] = "Runtime"
end if

openwithparm(w_component_params_edit, popup)

refresh()

end event

type st_report_category from statictext within w_config_reports
integer x = 439
integer y = 860
integer width = 558
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_report_category_title from statictext within w_config_reports
integer x = 14
integer y = 864
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Category: "
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_change_report_category from commandbutton within w_config_reports
integer x = 1051
integer y = 860
integer width = 434
integer height = 72
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Change"
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_report_category

popup.dataobject = "dw_report_category_pick"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = st_context_object.text
openwithparm(w_pop_pick, popup, parent)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

ls_report_category = popup_return.items[1]

openwithparm(w_pop_yes_no, "Are you sure you wish to update the report category for this report to " + ls_report_category + "?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return


UPDATE c_Report_Definition
SET report_category = :ls_report_category
WHERE report_id = :config_object_id;
if not tf_check() then return

refresh()

end event

type dw_component_attributes from u_dw_pick_list within w_config_reports
integer x = 370
integer y = 1220
integer width = 1029
integer height = 300
integer taborder = 31
boolean bringtotop = true
string dataobject = "dw_report_component_att_small"
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;
f_configure_report_component(config_object_id)

refresh()

end event

type st_component_attributes_title from statictext within w_config_reports
integer x = 370
integer y = 1152
integer width = 1029
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Component Attributes"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_no_component_attributes_defined from statictext within w_config_reports
integer x = 393
integer y = 1312
integer width = 978
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "No Component Attributes Defined"
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;
f_configure_report_component(config_object_id)

refresh()

end event

type cb_clear_component_attributes from commandbutton within w_config_reports
integer x = 695
integer y = 1532
integer width = 375
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear All"
end type

event clicked;str_popup_return popup_return

openwithparm(w_pop_yes_no, "Are you sure you wish to remove all config setting from this " + lower(config_object_info.config_object_type) + "?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

DELETE c_Report_Attribute
WHERE report_id = :config_object_id
AND component_attribute = 'Y';
if not tf_check() then return

refresh()

end event

type cb_copy_report from commandbutton within w_config_reports
integer x = 2382
integer y = 256
integer width = 521
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Create Copy"
end type

event clicked;string ls_config_object_id
str_popup_return popup_return

openwithparm(w_pop_yes_no, "This will create a new " + lower(config_object_info.config_object_type) + " which is a copy of the ~"" + st_report_description.text + "~" " + lower(config_object_info.config_object_type) + ".  Are you sure you wish to do this?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

ls_config_object_id = f_copy_config_object(config_object_id)
if len(ls_config_object_id) > 0 then
	config_object_id = ls_config_object_id
	refresh()
	return
end if

end event

type st_not_copyable from statictext within w_config_reports
integer x = 2382
integer y = 256
integer width = 521
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33536444
string text = "Not Copyable"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_owner from statictext within w_config_reports
integer x = 439
integer y = 560
integer width = 1239
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_owner_title from statictext within w_config_reports
integer x = 14
integer y = 564
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Owner: "
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_checkout from commandbutton within w_config_reports
integer x = 910
integer y = 1060
integer width = 434
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Checkout"
end type

event clicked;str_popup_return popup_return
integer li_sts

if lower(config_object_info.installed_version_status) = "checkedout" then
	openwithparm(w_pop_yes_no, "Are you sure you wish to check in this " + lower(config_object_info.config_object_type) + "?")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return
	li_sts = f_check_in_config_object(config_object_info)
else
	openwithparm(w_pop_yes_no, "Are you sure you wish to check out this " + lower(config_object_info.config_object_type) + "?")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return
	li_sts = f_check_out_config_object(config_object_info)
end if


refresh()

end event

type st_checkout from statictext within w_config_reports
integer x = 439
integer y = 1060
integer width = 416
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_checkout_title from statictext within w_config_reports
integer x = 14
integer y = 1064
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Edit Status: "
alignment alignment = right!
boolean focusrectangle = false
end type

type st_version from statictext within w_config_reports
integer x = 439
integer y = 360
integer width = 558
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

event clicked;clipboard(text)

end event

type st_version_title from statictext within w_config_reports
integer x = 78
integer y = 364
integer width = 338
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Version:"
alignment alignment = right!
boolean focusrectangle = false
end type

