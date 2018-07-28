$PBExportHeader$w_svc_allergy_vial_management.srw
forward
global type w_svc_allergy_vial_management from w_window_base
end type
type st_title from statictext within w_svc_allergy_vial_management
end type
type cb_finished from commandbutton within w_svc_allergy_vial_management
end type
type cb_be_back from commandbutton within w_svc_allergy_vial_management
end type
type st_allergen_title from statictext within w_svc_allergy_vial_management
end type
type dw_allergens from u_dw_pick_list within w_svc_allergy_vial_management
end type
type st_details_title from statictext within w_svc_allergy_vial_management
end type
type tab_vials from u_tab_vial_list within w_svc_allergy_vial_management
end type
type tab_vials from u_tab_vial_list within w_svc_allergy_vial_management
end type
type cb_vial_history from commandbutton within w_svc_allergy_vial_management
end type
type cb_create_new_vial from commandbutton within w_svc_allergy_vial_management
end type
type st_page from statictext within w_svc_allergy_vial_management
end type
type pb_up from picturebutton within w_svc_allergy_vial_management
end type
type pb_down from picturebutton within w_svc_allergy_vial_management
end type
type st_vol_title from statictext within w_svc_allergy_vial_management
end type
end forward

global type w_svc_allergy_vial_management from w_window_base
integer height = 1840
boolean controlmenu = false
windowtype windowtype = response!
string button_type = "COMMAND"
integer max_buttons = 3
st_title st_title
cb_finished cb_finished
cb_be_back cb_be_back
st_allergen_title st_allergen_title
dw_allergens dw_allergens
st_details_title st_details_title
tab_vials tab_vials
cb_vial_history cb_vial_history
cb_create_new_vial cb_create_new_vial
st_page st_page
pb_up pb_up
pb_down pb_down
st_vol_title st_vol_title
end type
global w_svc_allergy_vial_management w_svc_allergy_vial_management

type variables
decimal							total_volume
long 								vial_history_display_script_id
string 							report_id

u_component_service			 service


end variables

forward prototypes
public function integer refresh ()
public function integer load_allergens ()
end prototypes

public function integer refresh ();tab_vials.refresh()

return 1

end function

public function integer load_allergens ();long ll_count
long i
u_unit luo_unit
string ls_dose_unit
real lr_dose_amount
string ls_pretty_dose
setnull(luo_unit)

// Set the title
luo_unit = unit_list.find_unit(service.treatment.dose_unit)
if isnull(luo_unit) then
	luo_unit = unit_list.find_unit("ML")
end if

if isnull(luo_unit) then
	log.log(this, "load_allergens()", "Error finding unit", 4)
	return -1
end if

st_vol_title.text = "Vol. (" + luo_unit.description + ")"

// retrieve all the allergens
dw_allergens.settransobject(sqlca)
ll_count = dw_allergens.retrieve(current_patient.cpr_id, service.treatment.treatment_id, 'AllergyVialDefinition')
for i = 1 to ll_count
	dw_allergens.object.item_number[i] = i
	lr_dose_amount = dw_allergens.object.dose_amount[i]
	dw_allergens.object.pretty_dose[i] = luo_unit.pretty_amount(lr_dose_amount)
next

dw_allergens.set_page(1, pb_up, pb_down, st_page)


return 1

end function

event open;call super::open;long ll_menu_id
long ll_rows
str_popup_return popup_return
string ls_null
long ll_property_id
string ls_temp

setnull(ls_null)

popup_return.item_count = 1
popup_return.items[1] = "ERROR"

service = message.powerobjectparm
if isnull(service.treatment) then
	log.log(this, "open", "No treatment object", 4)
	closewithreturn(this, popup_return)
	return
end if


// Set the title and sizes
title = current_patient.id_line()

st_title.text = "Vial Management for ~"" + service.treatment.treatment_description + "~""

if len(st_title.text) > 42 then
	if len(st_title.text) > 60 then
		if len(st_title.text) > 70 then
			st_title.textsize = -10
		else
			st_title.textsize = -12
		end if
	else
		st_title.textsize = -14
	end if
else
	st_title.textsize = -18
end if

// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 4
end if

ll_menu_id = long(service.get_attribute("menu_id"))
if not isnull(ll_menu_id) then paint_menu(ll_menu_id)

vial_history_display_script_id = long(service.get_attribute("allergy_vial_display_script_id"))
report_id = service.get_attribute("report_id")

postevent("post_open")

end event

on w_svc_allergy_vial_management.create
int iCurrent
call super::create
this.st_title=create st_title
this.cb_finished=create cb_finished
this.cb_be_back=create cb_be_back
this.st_allergen_title=create st_allergen_title
this.dw_allergens=create dw_allergens
this.st_details_title=create st_details_title
this.tab_vials=create tab_vials
this.cb_vial_history=create cb_vial_history
this.cb_create_new_vial=create cb_create_new_vial
this.st_page=create st_page
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_vol_title=create st_vol_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.cb_finished
this.Control[iCurrent+3]=this.cb_be_back
this.Control[iCurrent+4]=this.st_allergen_title
this.Control[iCurrent+5]=this.dw_allergens
this.Control[iCurrent+6]=this.st_details_title
this.Control[iCurrent+7]=this.tab_vials
this.Control[iCurrent+8]=this.cb_vial_history
this.Control[iCurrent+9]=this.cb_create_new_vial
this.Control[iCurrent+10]=this.st_page
this.Control[iCurrent+11]=this.pb_up
this.Control[iCurrent+12]=this.pb_down
this.Control[iCurrent+13]=this.st_vol_title
end on

on w_svc_allergy_vial_management.destroy
call super::destroy
destroy(this.st_title)
destroy(this.cb_finished)
destroy(this.cb_be_back)
destroy(this.st_allergen_title)
destroy(this.dw_allergens)
destroy(this.st_details_title)
destroy(this.tab_vials)
destroy(this.cb_vial_history)
destroy(this.cb_create_new_vial)
destroy(this.st_page)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_vol_title)
end on

event post_open;call super::post_open;long ll_count

// set the service object reference to tab pages

tab_vials.tabpage_open_vials.service = service
tab_vials.tabpage_closed_vials.service = service

tab_vials.initialize()

load_allergens()


refresh()


end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_allergy_vial_management
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_allergy_vial_management
integer x = 46
integer y = 1576
end type

type st_title from statictext within w_svc_allergy_vial_management
integer width = 2898
integer height = 132
integer textsize = -22
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Vial Management"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_finished from commandbutton within w_svc_allergy_vial_management
integer x = 2427
integer y = 1616
integer width = 443
integer height = 108
integer taborder = 150
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

type cb_be_back from commandbutton within w_svc_allergy_vial_management
integer x = 1957
integer y = 1616
integer width = 443
integer height = 108
integer taborder = 160
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type st_allergen_title from statictext within w_svc_allergy_vial_management
integer x = 27
integer y = 212
integer width = 398
integer height = 72
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Allergens"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_allergens from u_dw_pick_list within w_svc_allergy_vial_management
integer x = 9
integer y = 292
integer width = 1042
integer height = 1100
integer taborder = 21
boolean bringtotop = true
string dataobject = "dw_vial_def_allergens"
boolean livescroll = false
borderstyle borderstyle = stylelowered!
end type

event constructor;call super::constructor;settransobject(sqlca)
end event

type st_details_title from statictext within w_svc_allergy_vial_management
integer x = 1106
integer y = 196
integer width = 1723
integer height = 88
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Vials"
alignment alignment = center!
boolean focusrectangle = false
end type

type tab_vials from u_tab_vial_list within w_svc_allergy_vial_management
integer x = 1074
integer y = 292
integer width = 1801
integer height = 1104
integer taborder = 20
boolean bringtotop = true
end type

type cb_vial_history from commandbutton within w_svc_allergy_vial_management
integer x = 1774
integer y = 1456
integer width = 535
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Vial History"
end type

event clicked;string ls_report_id

str_attributes lstra_attributes

if isnull(report_id) then
	ls_report_id = '{4B657EFA-AB67-482B-9FAB-1764440DF116}' // RTF report
else
	ls_report_id = report_id
end if
lstra_attributes.attribute_count = 2
lstra_attributes.attribute[1].attribute = "report_id"
lstra_attributes.attribute[1].value = ls_report_id
lstra_attributes.attribute[2].attribute = "display_script_id"
lstra_attributes.attribute[2].value = string(vial_history_display_script_id)

service_list.do_service("REPORT",lstra_attributes)
end event

type cb_create_new_vial from commandbutton within w_svc_allergy_vial_management
integer x = 2359
integer y = 1456
integer width = 512
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Create New Vial"
end type

event clicked;Openwithparm(w_svc_allergy_vial_creation,service)
refresh()
end event

type st_page from statictext within w_svc_allergy_vial_management
integer x = 626
integer y = 1408
integer width = 128
integer height = 108
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean focusrectangle = false
end type

type pb_up from picturebutton within w_svc_allergy_vial_management
integer x = 919
integer y = 1408
integer width = 137
integer height = 116
integer taborder = 30
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

li_page = dw_allergens.current_page

dw_allergens.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from picturebutton within w_svc_allergy_vial_management
integer x = 768
integer y = 1408
integer width = 137
integer height = 116
integer taborder = 40
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

li_page = dw_allergens.current_page
li_last_page = dw_allergens.last_page

dw_allergens.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type st_vol_title from statictext within w_svc_allergy_vial_management
integer x = 562
integer y = 212
integer width = 489
integer height = 72
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Vol. (ML)"
alignment alignment = right!
boolean focusrectangle = false
end type

