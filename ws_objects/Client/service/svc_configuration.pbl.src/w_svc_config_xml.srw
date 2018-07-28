$PBExportHeader$w_svc_config_xml.srw
forward
global type w_svc_config_xml from w_window_base
end type
type dw_xml_class from u_dw_pick_list within w_svc_config_xml
end type
type pb_up from picturebutton within w_svc_config_xml
end type
type st_page from statictext within w_svc_config_xml
end type
type pb_down from picturebutton within w_svc_config_xml
end type
type st_title from statictext within w_svc_config_xml
end type
type cb_ok from commandbutton within w_svc_config_xml
end type
type cb_new_xml_class from commandbutton within w_svc_config_xml
end type
end forward

global type w_svc_config_xml from w_window_base
integer width = 2935
integer height = 1840
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string button_type = "COMMAND"
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
dw_xml_class dw_xml_class
pb_up pb_up
st_page st_page
pb_down pb_down
st_title st_title
cb_ok cb_ok
cb_new_xml_class cb_new_xml_class
end type
global w_svc_config_xml w_svc_config_xml

type variables

end variables

forward prototypes
public subroutine xml_class_menu (long pl_row)
end prototypes

public subroutine xml_class_menu (long pl_row);String		buttons[]
String 		ls_drug_id,ls_temp
string		ls_null
String		ls_top_20_code
Integer		button_pressed, li_sts, li_service_count
long ll_null
string ls_status
long ll_creator_display_script_id
long ll_handler_display_script_id
string ls_creator_id
string ls_handler_id
string ls_description
string ls_xml_class_id

w_window_base lw_display_script_config
w_window_base lw_display_script_edit

window 				lw_pop_buttons
w_window_base lw_edit_window
str_popup 			popup
str_popup_return 	popup_return
w_window_base		lw_report_display

Setnull(ls_null)
Setnull(ll_null)

ls_description = dw_xml_class.object.description[pl_row]
ls_xml_class_id = dw_xml_class.object.id[pl_row]

ll_creator_display_script_id = dw_xml_class.object.creator_display_script_id[pl_row]
if ll_creator_display_script_id > 0 then
	SELECT CAST(id AS varchar(38))
	INTO :ls_creator_id
	FROM c_display_script
	WHERE display_script_id = :ll_creator_display_script_id;
	if not tf_check() then return
	if sqlca.sqlcode = 100 then
		setnull(ll_creator_display_script_id)
		setnull(ls_creator_id)
	end if
end if

ll_handler_display_script_id = dw_xml_class.object.handler_display_script_id[pl_row]
if ll_handler_display_script_id > 0 then
	SELECT CAST(id AS varchar(38))
	INTO :ls_handler_id
	FROM c_display_script
	WHERE display_script_id = :ll_handler_display_script_id;
	if not tf_check() then return
	if sqlca.sqlcode = 100 then
		setnull(ll_handler_display_script_id)
		setnull(ls_handler_id)
	end if
end if


if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "View/Edit XML Class Properties"
	popup.button_titles[popup.button_count] = "Properties"
	buttons[popup.button_count] = "PROPERTIES"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "View/Edit Creator Script"
	popup.button_titles[popup.button_count] = "Creator Script"
	buttons[popup.button_count] = "Creator"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "View/Edit Handler Script"
	popup.button_titles[popup.button_count] = "Handler Script"
	buttons[popup.button_count] = "Handler"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons", this)
	button_pressed = message.doubleparm
	if button_pressed < 1 or button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if

CHOOSE CASE buttons[button_pressed]
	CASE "PROPERTIES"
	CASE "Creator"
		if isnull(ll_creator_display_script_id) then
			ll_creator_display_script_id = sqlca.sp_new_display_script("General", &
																				ls_description, &
																				ls_description, &
																				current_user.user_id, &
																				"XML Creator", &
																				ls_xml_class_id)
			if not tf_check() then return
			if isnull(ll_creator_display_script_id) or ll_creator_display_script_id = 0 then return
			
			dw_xml_class.object.creator_display_script_id[pl_row] = ll_creator_display_script_id
			dw_xml_class.update()
			
			openwithparm(lw_display_script_edit, ll_creator_display_script_id, "w_display_script_edit", this)
		else
			popup.items[1] = string(ll_creator_display_script_id)
			popup.items[2] = "TRUE"
			popup.items[3] = dw_xml_class.object.id[pl_row]
			popup.data_row_count = 3
			openwithparm(lw_display_script_config, popup, "w_display_script_config", this)
		end if
	CASE "Handler"
		if isnull(ll_handler_display_script_id) then
			ll_handler_display_script_id = sqlca.sp_new_display_script("General", &
																				ls_description, &
																				ls_description, &
																				current_user.user_id, &
																				"XML Handler", &
																				ls_xml_class_id)
			if not tf_check() then return
			if isnull(ll_handler_display_script_id) or ll_handler_display_script_id = 0 then return
			
			dw_xml_class.object.handler_display_script_id[pl_row] = ll_handler_display_script_id
			dw_xml_class.update()
			
			openwithparm(lw_display_script_edit, ll_handler_display_script_id, "w_display_script_edit", this)
		else
			popup.items[1] = string(ll_handler_display_script_id)
			popup.items[2] = "TRUE"
			popup.items[3] = dw_xml_class.object.id[pl_row]
			popup.data_row_count = 3
			openwithparm(lw_display_script_config, popup, "w_display_script_config", this)
		end if
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

Return

end subroutine

on w_svc_config_xml.create
int iCurrent
call super::create
this.dw_xml_class=create dw_xml_class
this.pb_up=create pb_up
this.st_page=create st_page
this.pb_down=create pb_down
this.st_title=create st_title
this.cb_ok=create cb_ok
this.cb_new_xml_class=create cb_new_xml_class
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_xml_class
this.Control[iCurrent+2]=this.pb_up
this.Control[iCurrent+3]=this.st_page
this.Control[iCurrent+4]=this.pb_down
this.Control[iCurrent+5]=this.st_title
this.Control[iCurrent+6]=this.cb_ok
this.Control[iCurrent+7]=this.cb_new_xml_class
end on

on w_svc_config_xml.destroy
call super::destroy
destroy(this.dw_xml_class)
destroy(this.pb_up)
destroy(this.st_page)
destroy(this.pb_down)
destroy(this.st_title)
destroy(this.cb_ok)
destroy(this.cb_new_xml_class)
end on

event open;call super::open;String 	ls_age_range_category
Long		li_rows,ll_find

str_popup_return popup_return

if not isnull(current_patient) then title = current_patient.id_line()

dw_xml_class.x = (width - dw_xml_class.width) / 2
dw_xml_class.height = height - 500

pb_up.x = dw_xml_class.x + dw_xml_class.width + 20
pb_down.x = pb_up.x
pb_up.y = dw_xml_class.y
pb_down.y = pb_up.y + pb_up.height + 20
st_page.x = pb_up.x + pb_up.width - st_page.width
st_page.y = dw_xml_class.y - st_page.height - 4

cb_ok.x = width - cb_ok.width - 50
cb_ok.y = height - cb_ok.height - 50

pb_epro_help.x = width - pb_epro_help.width - 50
st_title.width = width

dw_xml_class.retrieve()
dw_xml_class.set_page(1, pb_up, pb_down, st_page)

cb_new_xml_class.x = (width - cb_new_xml_class.width) / 2
cb_new_xml_class.y = cb_ok.y
end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_config_xml
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_config_xml
integer x = 41
integer y = 1616
end type

type dw_xml_class from u_dw_pick_list within w_svc_config_xml
integer x = 201
integer y = 196
integer width = 2459
integer height = 1396
integer taborder = 21
boolean bringtotop = true
string dataobject = "dw_xml_class_list"
boolean vscrollbar = true
boolean border = false
end type

event constructor;call super::constructor;Settransobject(SQLCA)
end event

event selected;call super::selected;
xml_class_menu(selected_row)

clear_selected()

end event

type pb_up from picturebutton within w_svc_config_xml
integer x = 2679
integer y = 204
integer width = 137
integer height = 116
integer taborder = 41
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;integer li_page

li_page = dw_xml_class.current_page

dw_xml_class.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type st_page from statictext within w_svc_config_xml
integer x = 2537
integer y = 140
integer width = 279
integer height = 56
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99/99"
alignment alignment = right!
boolean focusrectangle = false
end type

type pb_down from picturebutton within w_svc_config_xml
integer x = 2679
integer y = 328
integer width = 137
integer height = 116
integer taborder = 51
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_xml_class.current_page
li_last_page = dw_xml_class.last_page

dw_xml_class.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type st_title from statictext within w_svc_config_xml
integer width = 2921
integer height = 120
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Select XML Class"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_svc_config_xml
integer x = 2487
integer y = 1684
integer width = 402
integer height = 112
integer taborder = 11
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;close(parent)

end event

type cb_new_xml_class from commandbutton within w_svc_config_xml
integer x = 1115
integer y = 1680
integer width = 768
integer height = 112
integer taborder = 61
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New XML Class"
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_xml_class
string ls_description
string ls_config_object
long ll_row
		
popup.title = "Enter the classname of the new XML class"
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_xml_class = popup_return.items[1]

popup.title = "Enter the description of the new XML class"
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_description = popup_return.items[1]

popup.title = "Enter the configuration object imported/exported with the new XML class"
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then
	setnull(ls_config_object)
else
	ls_config_object = popup_return.items[1]
end if

ll_row = dw_xml_class.insertrow(0)
dw_xml_class.object.xml_class[ll_row] = ls_xml_class
dw_xml_class.object.description[ll_row] = ls_description
dw_xml_class.object.created_by[ll_row] = current_scribe.user_id
dw_xml_class.object.handler_component_id[ll_row] = "XMLHandler_Script"

if len(ls_config_object) > 0 then
	dw_xml_class.object.config_object[ll_row] = ls_config_object
	dw_xml_class.object.root_element[ll_row] = "JMJ" + ls_config_object
	dw_xml_class.object.file_extension[ll_row] = "JMJ" + ls_config_object
end if

dw_xml_class.update()
dw_xml_class.reselectrow(ll_row)


end event

