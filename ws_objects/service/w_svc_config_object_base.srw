HA$PBExportHeader$w_svc_config_object_base.srw
forward
global type w_svc_config_object_base from w_window_base
end type
type cb_finished from commandbutton within w_svc_config_object_base
end type
type st_title from statictext within w_svc_config_object_base
end type
type st_2 from statictext within w_svc_config_object_base
end type
type st_report_description from statictext within w_svc_config_object_base
end type
type cb_change_name from commandbutton within w_svc_config_object_base
end type
type cb_change_status from commandbutton within w_svc_config_object_base
end type
type st_config_object_id from statictext within w_svc_config_object_base
end type
type st_config_object_id_title from statictext within w_svc_config_object_base
end type
type st_status from statictext within w_svc_config_object_base
end type
type st_status_title from statictext within w_svc_config_object_base
end type
type st_context_object from statictext within w_svc_config_object_base
end type
type st_context_object_title from statictext within w_svc_config_object_base
end type
type cb_change_context from commandbutton within w_svc_config_object_base
end type
type st_report_category from statictext within w_svc_config_object_base
end type
type st_report_category_title from statictext within w_svc_config_object_base
end type
type cb_change_report_category from commandbutton within w_svc_config_object_base
end type
type cb_copy_report from commandbutton within w_svc_config_object_base
end type
type st_not_copyable from statictext within w_svc_config_object_base
end type
type st_owner from statictext within w_svc_config_object_base
end type
type st_owner_title from statictext within w_svc_config_object_base
end type
type cb_checkout from commandbutton within w_svc_config_object_base
end type
type st_checkout from statictext within w_svc_config_object_base
end type
type st_checkout_title from statictext within w_svc_config_object_base
end type
type st_version from statictext within w_svc_config_object_base
end type
type st_version_title from statictext within w_svc_config_object_base
end type
type cb_save_to_file from commandbutton within w_svc_config_object_base
end type
end forward

global type w_svc_config_object_base from w_window_base
integer width = 4046
string title = "Report Configuration"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
cb_finished cb_finished
st_title st_title
st_2 st_2
st_report_description st_report_description
cb_change_name cb_change_name
cb_change_status cb_change_status
st_config_object_id st_config_object_id
st_config_object_id_title st_config_object_id_title
st_status st_status
st_status_title st_status_title
st_context_object st_context_object
st_context_object_title st_context_object_title
cb_change_context cb_change_context
st_report_category st_report_category
st_report_category_title st_report_category_title
cb_change_report_category cb_change_report_category
cb_copy_report cb_copy_report
st_not_copyable st_not_copyable
st_owner st_owner
st_owner_title st_owner_title
cb_checkout cb_checkout
st_checkout st_checkout
st_checkout_title st_checkout_title
st_version st_version
st_version_title st_version_title
cb_save_to_file cb_save_to_file
end type
global w_svc_config_object_base w_svc_config_object_base

type variables
u_component_service service
str_config_object_info config_object_info

string config_object_id

boolean editable


end variables

forward prototypes
public function integer refresh ()
public function integer save_to_file ()
end prototypes

public function integer refresh ();long ll_count
integer li_sts
string ls_error
blob lbl_objectdata
string ls_script
string ls_left
string ls_right
string ls_component_id
string ls_dataobject 

li_sts = f_get_config_object_info(config_object_id, config_object_info)
if li_sts <= 0 then
	log.log(this, "post_open", "Error getting config object info (" + config_object_id + ")", 4)
	return -1
end if

st_config_object_id.text = config_object_id

st_owner.text = config_object_info.owner_description
st_title.text = wordcap(config_object_info.config_object_type) + " Configuration"

if isnull(config_object_id) or trim(config_object_id) = "" then
	log.log(this, "refresh()", "Invalid config_object_id", 4)
	return -1
end if

st_report_description.text = config_object_info.description
st_report_category.text = config_object_info.config_object_category
st_context_object.text = config_object_info.context_object

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


if config_object_info.status = "OK" then
	st_status.text = "Active"
	cb_change_status.text = "Make Inactive"
else
	st_status.text = "Inactive"
	cb_change_status.text = "Make Active"
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
else
	cb_change_name.visible = false
	cb_change_report_category.visible = false
	cb_change_context.visible = false
end if


return 1

end function

public function integer save_to_file ();string ls_path
string ls_filter
string ls_file
integer li_sts
blob lbl_objectdata
long ll_version
str_popup_return popup_return

ll_version = config_object_info.installed_version

ls_path = f_string_to_filename(config_object_info.description) + "-" + string(ll_version) + ".eprocfg"
ls_filter = "Epro Config File (*.eprocfg), *.eprocfg, All Files (*.*), *.*"

li_sts = GetFileSaveName("Select File", ls_path, ls_file, "srd", ls_filter)
if li_sts <= 0 then return 0

if fileexists(ls_path) then
	openwithparm(w_pop_yes_no, "The selected filename already exists.  Do you wish to overwrite it?")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return 0
	
	if not filedelete(ls_path) then
		openwithparm(w_pop_message, "Deleting the existing file failed")
		return 0
	end if
end if

li_sts = f_get_config_object_objectdata(config_object_info.config_object_id, lbl_objectdata)
if li_sts <= 0 then
	openwithparm(w_pop_message, "Error getting config object data")
	return -1
end if

li_sts = log.file_write(lbl_objectdata, ls_path)
if li_sts <= 0 then
	log.log(this, "save_to_file()", "Saving config object failed", 4)
	openwithparm(w_pop_message, "Saving config object failed")
	return -1
end if

openwithparm(w_pop_message, wordcap(config_object_info.config_object_type) + " has been successfully saved to " + ls_path)

return 1

end function

on w_svc_config_object_base.create
int iCurrent
call super::create
this.cb_finished=create cb_finished
this.st_title=create st_title
this.st_2=create st_2
this.st_report_description=create st_report_description
this.cb_change_name=create cb_change_name
this.cb_change_status=create cb_change_status
this.st_config_object_id=create st_config_object_id
this.st_config_object_id_title=create st_config_object_id_title
this.st_status=create st_status
this.st_status_title=create st_status_title
this.st_context_object=create st_context_object
this.st_context_object_title=create st_context_object_title
this.cb_change_context=create cb_change_context
this.st_report_category=create st_report_category
this.st_report_category_title=create st_report_category_title
this.cb_change_report_category=create cb_change_report_category
this.cb_copy_report=create cb_copy_report
this.st_not_copyable=create st_not_copyable
this.st_owner=create st_owner
this.st_owner_title=create st_owner_title
this.cb_checkout=create cb_checkout
this.st_checkout=create st_checkout
this.st_checkout_title=create st_checkout_title
this.st_version=create st_version
this.st_version_title=create st_version_title
this.cb_save_to_file=create cb_save_to_file
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_finished
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_report_description
this.Control[iCurrent+5]=this.cb_change_name
this.Control[iCurrent+6]=this.cb_change_status
this.Control[iCurrent+7]=this.st_config_object_id
this.Control[iCurrent+8]=this.st_config_object_id_title
this.Control[iCurrent+9]=this.st_status
this.Control[iCurrent+10]=this.st_status_title
this.Control[iCurrent+11]=this.st_context_object
this.Control[iCurrent+12]=this.st_context_object_title
this.Control[iCurrent+13]=this.cb_change_context
this.Control[iCurrent+14]=this.st_report_category
this.Control[iCurrent+15]=this.st_report_category_title
this.Control[iCurrent+16]=this.cb_change_report_category
this.Control[iCurrent+17]=this.cb_copy_report
this.Control[iCurrent+18]=this.st_not_copyable
this.Control[iCurrent+19]=this.st_owner
this.Control[iCurrent+20]=this.st_owner_title
this.Control[iCurrent+21]=this.cb_checkout
this.Control[iCurrent+22]=this.st_checkout
this.Control[iCurrent+23]=this.st_checkout_title
this.Control[iCurrent+24]=this.st_version
this.Control[iCurrent+25]=this.st_version_title
this.Control[iCurrent+26]=this.cb_save_to_file
end on

on w_svc_config_object_base.destroy
call super::destroy
destroy(this.cb_finished)
destroy(this.st_title)
destroy(this.st_2)
destroy(this.st_report_description)
destroy(this.cb_change_name)
destroy(this.cb_change_status)
destroy(this.st_config_object_id)
destroy(this.st_config_object_id_title)
destroy(this.st_status)
destroy(this.st_status_title)
destroy(this.st_context_object)
destroy(this.st_context_object_title)
destroy(this.cb_change_context)
destroy(this.st_report_category)
destroy(this.st_report_category_title)
destroy(this.cb_change_report_category)
destroy(this.cb_copy_report)
destroy(this.st_not_copyable)
destroy(this.st_owner)
destroy(this.st_owner_title)
destroy(this.cb_checkout)
destroy(this.st_checkout)
destroy(this.st_checkout_title)
destroy(this.st_version)
destroy(this.st_version_title)
destroy(this.cb_save_to_file)
end on

event open;call super::open;str_popup_return popup_return
integer li_sts
str_pick_config_object lstr_pick_config_object
w_window_base lw_window

config_object_id = message.stringparm
service = message.powerobjectparm

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

this.function POST refresh()

end event

event resize;call super::resize;long ll_version_width

st_title.width = width

st_report_description.width = width - st_report_description.x - cb_change_name.width - 100
cb_change_name.x = st_report_description.x + st_report_description.width + 50
cb_copy_report.x = cb_change_name.x

st_owner.x = width - st_owner.width - 100
st_owner_title.x = st_owner.x - st_owner_title.width - 30

st_status.x = st_owner.x
st_status_title.x = st_owner_title.x
cb_change_status.x = st_status.x + st_status.width + 50

st_checkout.x = st_owner.x
st_checkout_title.x = st_owner_title.x
cb_checkout.x = cb_change_status.x

ll_version_width =  st_version.width + st_version_title.width + 30
st_version_title.x = (width / 2) - (ll_version_width / 2)
st_version.x = st_version_title.x + st_version_title.width + 30

cb_finished.x = width - cb_finished.width - 50
cb_finished.y = height - cb_finished.height - 150

cb_save_to_file.y = cb_finished.y + cb_finished.height - cb_save_to_file.height
end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_config_object_base
integer x = 3909
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_config_object_base
integer x = 64
integer y = 1512
end type

type cb_finished from commandbutton within w_svc_config_object_base
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

type st_title from statictext within w_svc_config_object_base
integer width = 4046
integer height = 108
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Controller Configuration"
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;
st_title.width = width
st_report_description.width = width - st_report_description.x - cb_change_name.width - 100
//cb_change_name.x = 
end event

type st_2 from statictext within w_svc_config_object_base
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
long backcolor = 33538240
string text = "Description:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_report_description from statictext within w_svc_config_object_base
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

type cb_change_name from commandbutton within w_svc_config_object_base
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

type cb_change_status from commandbutton within w_svc_config_object_base
integer x = 3406
integer y = 476
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

type st_config_object_id from statictext within w_svc_config_object_base
integer x = 434
integer y = 364
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

type st_config_object_id_title from statictext within w_svc_config_object_base
integer x = 73
integer y = 368
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
long backcolor = 33538240
string text = "ID: "
alignment alignment = right!
boolean focusrectangle = false
end type

type st_status from statictext within w_svc_config_object_base
integer x = 2949
integer y = 476
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

type st_status_title from statictext within w_svc_config_object_base
integer x = 2523
integer y = 480
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
long backcolor = 33538240
string text = "Pick Status: "
alignment alignment = right!
boolean focusrectangle = false
end type

type st_context_object from statictext within w_svc_config_object_base
integer x = 434
integer y = 476
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

type st_context_object_title from statictext within w_svc_config_object_base
integer x = 14
integer y = 480
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
long backcolor = 33538240
string text = "Context: "
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_change_context from commandbutton within w_svc_config_object_base
integer x = 1038
integer y = 476
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

type st_report_category from statictext within w_svc_config_object_base
integer x = 434
integer y = 588
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

type st_report_category_title from statictext within w_svc_config_object_base
integer x = 14
integer y = 592
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
long backcolor = 33538240
string text = "Category: "
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_change_report_category from commandbutton within w_svc_config_object_base
integer x = 1038
integer y = 588
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

type cb_copy_report from commandbutton within w_svc_config_object_base
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

type st_not_copyable from statictext within w_svc_config_object_base
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

type st_owner from statictext within w_svc_config_object_base
integer x = 2949
integer y = 364
integer width = 1006
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

type st_owner_title from statictext within w_svc_config_object_base
integer x = 2523
integer y = 368
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
long backcolor = 33538240
string text = "Owner: "
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_checkout from commandbutton within w_svc_config_object_base
integer x = 3406
integer y = 588
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

type st_checkout from statictext within w_svc_config_object_base
integer x = 2949
integer y = 588
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

type st_checkout_title from statictext within w_svc_config_object_base
integer x = 2523
integer y = 592
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
long backcolor = 33538240
string text = "Edit Status: "
alignment alignment = right!
boolean focusrectangle = false
end type

type st_version from statictext within w_svc_config_object_base
integer x = 1911
integer y = 592
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

type st_version_title from statictext within w_svc_config_object_base
integer x = 1609
integer y = 596
integer width = 279
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Version:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_save_to_file from commandbutton within w_svc_config_object_base
integer x = 46
integer y = 1652
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
string text = "Save to File"
end type

event clicked;integer li_sts

li_sts = save_to_file()


end event

