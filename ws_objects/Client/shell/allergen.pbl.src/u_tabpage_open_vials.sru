$PBExportHeader$u_tabpage_open_vials.sru
forward
global type u_tabpage_open_vials from u_tabpage
end type
type dw_vials from u_dw_pick_list within u_tabpage_open_vials
end type
type pb_down from picturebutton within u_tabpage_open_vials
end type
type pb_up from picturebutton within u_tabpage_open_vials
end type
type st_page from statictext within u_tabpage_open_vials
end type
end forward

global type u_tabpage_open_vials from u_tabpage
integer width = 1801
integer height = 756
dw_vials dw_vials
pb_down pb_down
pb_up pb_up
st_page st_page
end type
global u_tabpage_open_vials u_tabpage_open_vials

type variables
string 									vial_treatment_type = 'AllergyVialInstance'

u_component_service 					service
end variables

forward prototypes
public subroutine refresh ()
public subroutine close_vial (long pl_row)
end prototypes

public subroutine refresh ();integer li_sts

dw_vials.height = height

// pulls all the open vials for the allergy root treatment
li_sts = dw_vials.retrieve(service.treatment.treatment_id)
dw_vials.set_page(1,pb_up,pb_down,st_page)


end subroutine

public subroutine close_vial (long pl_row);integer					li_sts
string					ls_progress,ls_null
long						ll_null,ll_treatment_id
datetime 				ldt_progress_date_time

str_popup				popup
str_popup_return 		popup_return


setnull(ls_null)
setnull(ll_null)
setnull(ldt_progress_date_time)

// enter the reason for closing
popup.argument_count = 1
popup.argument[1] = "CLOSE_VIAL"
popup.title = "Enter the reason:"
Openwithparm(w_pop_prompt_string, popup)
popup_return = Message.powerobjectparm
If popup_return.item_count = 1 then
	ls_progress = popup_return.items[1]
else
	return
End if

ll_treatment_id = dw_vials.object.treatment_id[pl_row]

// set the reason for closing a vial
li_sts = f_set_progress(current_patient.cpr_id, &
								"Treatment", &
								ll_treatment_id, &
								'PROPERTY', &
								'Closed', &
								ls_progress, &
								ldt_progress_date_time, &
								ll_null, &
								ll_null, &
								ll_null)
// close the vial						
li_sts = f_set_progress(current_patient.cpr_id, &
								"Treatment", &
								ll_treatment_id, &
								'CLOSED', &
								ls_null, &
								ls_progress, &
								ldt_progress_date_time, &
								ll_null, &
								ll_null, &
								ll_null)

end subroutine

on u_tabpage_open_vials.create
int iCurrent
call super::create
this.dw_vials=create dw_vials
this.pb_down=create pb_down
this.pb_up=create pb_up
this.st_page=create st_page
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_vials
this.Control[iCurrent+2]=this.pb_down
this.Control[iCurrent+3]=this.pb_up
this.Control[iCurrent+4]=this.st_page
end on

on u_tabpage_open_vials.destroy
call super::destroy
destroy(this.dw_vials)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.st_page)
end on

type dw_vials from u_dw_pick_list within u_tabpage_open_vials
integer width = 1609
integer height = 728
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_allergy_open_vials"
boolean vscrollbar = true
boolean border = false
end type

event constructor;call super::constructor;settransobject(sqlca)
end event

event selected;call super::selected;str_popup popup
str_popup_return popup_return

long							ll_treatment_id
long							ll_encounter_id
string						ls_desc
string						ls_cpr_id
string						ls_allergy_admin_service
datetime						ld_expiration_date

long ll_menu_id

str_attributes				lstra_attributes

ls_cpr_id = current_patient.cpr_id
ll_encounter_id = current_patient.open_encounter_id
ll_treatment_id = object.treatment_id[selected_row]

service.get_attribute("vial_menu_id", ll_menu_id)
if isnull(ll_menu_id) then
	ll_menu_id = datalist.get_preference_int( "PREFERENCES", "Allergy Vial Management menu_id")
end if

if isnull(ll_menu_id) then
	popup.data_row_count = 1
	popup.items[1] = "Close Vial"
	//popup.items[2] = "Administer Shot"
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return
	
	CHOOSE CASE popup_return.item_indexes[1]
		CASE 1
			close_vial(selected_row)
		CASE 2
			ls_allergy_admin_service = service.get_attribute("allergy_admin_service")
			if isnull(ls_allergy_admin_service) then ls_allergy_admin_service = "ALLERGY ADMIN"
			
			ll_treatment_id = object.treatment_id[selected_row]
			ls_desc = object.treatment_description[selected_row]
			ld_expiration_date = object.expiration_date[selected_row]
	
			// add allergy vial instance attributes and call admin service
			lstra_attributes.attribute_count = 2
			lstra_attributes.attribute[1].attribute = "vial_treatment_id"
			lstra_attributes.attribute[1].value = string(ll_treatment_id)
			lstra_attributes.attribute[2].attribute = "vial_treatment_desc"
			lstra_attributes.attribute[2].value = ls_desc
	
			// Call the admin service
			service_list.do_service(ls_cpr_id,ll_encounter_id,ls_allergy_admin_service,lstra_attributes)
		CASE ELSE
			return
	END CHOOSE
else
	f_attribute_add_attribute(lstra_attributes, "treatment_id", string(ll_treatment_id))
	f_display_menu_with_attributes(ll_menu_id, false, lstra_attributes)
end if

refresh()

end event

type pb_down from picturebutton within u_tabpage_open_vials
integer x = 1605
integer y = 136
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
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_vials.current_page
li_last_page = dw_vials.last_page

dw_vials.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type pb_up from picturebutton within u_tabpage_open_vials
integer x = 1605
integer y = 12
integer width = 137
integer height = 116
integer taborder = 20
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

li_page = dw_vials.current_page

dw_vials.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type st_page from statictext within u_tabpage_open_vials
integer x = 1614
integer y = 260
integer width = 128
integer height = 96
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "99 of 99"
boolean focusrectangle = false
end type

