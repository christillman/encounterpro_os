$PBExportHeader$u_immunization.sru
forward
global type u_immunization from u_cpr_page_base
end type
type cb_reference from commandbutton within u_immunization
end type
type cb_order from commandbutton within u_immunization
end type
type st_title from statictext within u_immunization
end type
type cb_1 from commandbutton within u_immunization
end type
type dw_immunizations from u_dw_pick_list within u_immunization
end type
type st_config from statictext within u_immunization
end type
end forward

global type u_immunization from u_cpr_page_base
long backcolor = 12632256
cb_reference cb_reference
cb_order cb_order
st_title st_title
cb_1 cb_1
dw_immunizations dw_immunizations
st_config st_config
end type
global u_immunization u_immunization

type variables
string vaccine_history_service
long reference_material_id

end variables

forward prototypes
public subroutine initialize (u_cpr_section puo_section, integer pi_page)
public subroutine refresh ()
public subroutine losefocus ()
public subroutine refresh_tab ()
end prototypes

public subroutine initialize (u_cpr_section puo_section, integer pi_page);this_section = puo_section
this_page = pi_page

this_section.load_params(this_page)
vaccine_history_service = this_section.get_attribute(this_section.page[this_page].page_id, "vaccine_history_service")
if isnull(vaccine_history_service) then vaccine_history_service = "VACCINEHISTORY"

reference_material_id = long(this_section.get_attribute(this_section.page[this_page].page_id, "reference_material_id"))
if reference_material_id > 0 then
	cb_reference.visible = true
else
	cb_reference.visible = false
end if

real lr_x_factor
real lr_y_factor

lr_x_factor = width / 2875
lr_y_factor = height / 1272

f_resize_objects(control, lr_x_factor, lr_y_factor, false, true)

dw_immunizations.width = 2153
dw_immunizations.x = (width / 2) - (dw_immunizations.width / 2)

dw_immunizations.settransobject(sqlca)

refresh()

end subroutine

public subroutine refresh ();long i, ll_count
string ls_status
integer li_max_status
long ll_color


ll_count = dw_immunizations.retrieve(current_patient.cpr_id, datetime(today(), now()))

li_max_status = 1

ll_color = COLOR_TEXT_NORMAL
for i = 1 to ll_count
	ls_status = dw_immunizations.object.dose_status[i]
	if lower(ls_status) = "give now" then
		ll_color = COLOR_TEXT_ERROR
		exit
	end if
next

tabtextcolor = ll_color

if config_mode then
	st_config.visible = true
else
	st_config.visible = false
end if

end subroutine

public subroutine losefocus ();refresh_tab()

end subroutine

public subroutine refresh_tab ();refresh()

end subroutine

on u_immunization.create
int iCurrent
call super::create
this.cb_reference=create cb_reference
this.cb_order=create cb_order
this.st_title=create st_title
this.cb_1=create cb_1
this.dw_immunizations=create dw_immunizations
this.st_config=create st_config
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_reference
this.Control[iCurrent+2]=this.cb_order
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.dw_immunizations
this.Control[iCurrent+6]=this.st_config
end on

on u_immunization.destroy
call super::destroy
destroy(this.cb_reference)
destroy(this.cb_order)
destroy(this.st_title)
destroy(this.cb_1)
destroy(this.dw_immunizations)
destroy(this.st_config)
end on

type cb_configure_tab from u_cpr_page_base`cb_configure_tab within u_immunization
end type

type cb_reference from commandbutton within u_immunization
integer x = 1280
integer y = 1144
integer width = 471
integer height = 108
integer taborder = 21
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reference"
end type

event clicked;f_open_patient_material(reference_material_id, "Open", false)

end event

type cb_order from commandbutton within u_immunization
integer x = 635
integer y = 1144
integer width = 471
integer height = 108
integer taborder = 11
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Order Vaccine"
end type

event clicked;long ll_menu_id
string ls_menu_key

setnull(ls_menu_key)

ll_menu_id = f_get_context_menu("OrderVaccine", ls_menu_key)
if ll_menu_id <= 0 then return

f_display_menu(ll_menu_id, true)

refresh()


end event

type st_title from statictext within u_immunization
integer x = 407
integer y = 8
integer width = 2153
integer height = 120
boolean bringtotop = true
integer textsize = -16
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
string text = "Immunization Status"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within u_immunization
integer x = 1925
integer y = 1144
integer width = 471
integer height = 108
integer taborder = 2
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "View Detail"
end type

event clicked;str_attributes lstr_attributes

lstr_attributes.attribute_count = 0

service_list.do_service(vaccine_history_service, lstr_attributes)

refresh()


end event

type dw_immunizations from u_dw_pick_list within u_immunization
integer x = 407
integer y = 124
integer width = 2153
integer height = 996
integer taborder = 11
string dataobject = "dw_jmj_patient_immunization_status"
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;str_popup popup
long ll_rowcount
long ll_row
string ls_disease_group
long ll_disease_id
string ls_description
str_disease_group lstr_disease_group
string ls_name
string ls_dose_status
string ls_dose_text

ll_rowcount = rowcount()
ls_name = dwo.name

// The reporting of the row number when the user clicks a calculated field is inconsistent
// So massage the row number so it always refers to the left immunization and then check the
// clicked column name to determine if the user clicked the right immunization
ll_row = ((row - 1) / 2)
ll_row = ( ll_row * 2 ) + 1

if ll_row > ll_rowcount then
	ll_row = ll_rowcount
end if

if right(ls_name, 1) <> "1" then
	if ll_row = ll_rowcount then return
	ll_row += 1
end if

// Get the info about the immunization clicked
lstr_disease_group.disease_group = object.disease_group[ll_row]
lstr_disease_group.disease_id = object.disease_id[ll_row]
lstr_disease_group.description = object.description[ll_row]

ls_dose_status = object.dose_status[ll_row]
ls_dose_text = object.dose_status[ll_row]
if lower(ls_dose_status) = "ineligible" and isnull(ls_dose_text) then
	openwithparm(w_immunization_rules, lstr_disease_group)
else
	openwithparm(w_immunization_schedule, lstr_disease_group)
end if

end event

type st_config from statictext within u_immunization
integer x = 23
integer y = 1044
integer width = 315
integer height = 208
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Configure Vaccine Schedule"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_config_object_info lstr_config_object_info
integer li_sts
str_popup_return popup_return

lstr_config_object_info = common_thread.vaccine_schedule()
if isnull(lstr_config_object_info.installed_version) or isnull(lstr_config_object_info.config_object_id) then 
	// If there is no vaccine schedule component installed and the user wants to edit the config then
	// fabricate a locally owned vaccine schedule from the current configuration
	sqlca.jmj_create_local_vaccine_schedule(lstr_config_object_info.config_object_id)
	if not tf_check() then return 1
	if len(lstr_config_object_info.config_object_id) > 0 then
		li_sts = f_get_config_object_info(lstr_config_object_info.config_object_id, lstr_config_object_info)
		if li_sts <= 0 then return 1
	else
		openwithparm(w_pop_message, "There is no installed vaccine schedule and the attempt to create one failed")
		return 1
	end if
end if

if lstr_config_object_info.installed_version >= 0 and not sqlca.customer_id = lstr_config_object_info.owner_id then
	openwithparm(w_pop_message, "The currently installed vaccine schedule is not locally owned and is not editable.  Please install a locally owned schedule or make a copy of a schedule for local editing.")
	return 1
end if
if lower(lstr_config_object_info.installed_version_status) = "checkedin" then
	openwithparm(w_pop_yes_no, "The Vaccine Schedule is not currently checked out for editing.  Do you wish to check it out now?")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return 1
	
	li_sts = f_check_out_config_object(lstr_config_object_info)
end if
		
f_configure_config_object(lstr_config_object_info.config_object_id)

refresh()

end event

