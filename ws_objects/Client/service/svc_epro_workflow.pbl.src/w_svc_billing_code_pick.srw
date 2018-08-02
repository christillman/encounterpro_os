$PBExportHeader$w_svc_billing_code_pick.srw
forward
global type w_svc_billing_code_pick from w_window_base
end type
type cb_be_back from commandbutton within w_svc_billing_code_pick
end type
type st_encounter_description from statictext within w_svc_billing_code_pick
end type
type dw_codes from u_dw_pick_list within w_svc_billing_code_pick
end type
type cb_done from commandbutton within w_svc_billing_code_pick
end type
type cb_cancel from commandbutton within w_svc_billing_code_pick
end type
end forward

global type w_svc_billing_code_pick from w_window_base
integer width = 2203
string title = "Patients Waiting"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_be_back cb_be_back
st_encounter_description st_encounter_description
dw_codes dw_codes
cb_done cb_done
cb_cancel cb_cancel
end type
global w_svc_billing_code_pick w_svc_billing_code_pick

type variables
u_component_service service

string service_office_id

string services

string this_room_id


end variables

forward prototypes
public function integer post_new_codes ()
public subroutine display_codes (long pl_code_count, string psa_codes[])
end prototypes

public function integer post_new_codes ();long ll_row
string ls_procedure_id

ll_row = dw_codes.get_selected_row()
DO WHILE ll_row > 0
	ls_procedure_id = dw_codes.object.procedure_id[ll_row]
	
	sqlca.sp_add_encounter_charge(service.cpr_id, &
							service.encounter_id, &
							ls_procedure_id, &
							service.treatment_id, &
							current_scribe.user_id, &
							"N")
	if not tf_check() then return -1
	
	ll_row = dw_codes.get_selected_row(ll_row)
LOOP




return 1

end function

public subroutine display_codes (long pl_code_count, string psa_codes[]);long i
string ls_procedure_id
string ls_description
string ls_cpt_code
long ll_units
string ls_modifier
string ls_other_modifiers
long ll_row

dw_codes.reset()


for i = 1 to pl_code_count
	ls_procedure_id = trim(psa_codes[][i])
	
	SELECT description,
			cpt_code,
			CAST(units AS int),
			modifier,
			other_modifiers
	INTO :ls_description,
			:ls_cpt_code,
			:ll_units,
			:ls_modifier,
			:ls_other_modifiers
	FROM c_Procedure
	WHERE procedure_id = :ls_procedure_id;
	if not tf_check() then continue
	if sqlca.sqlnrows = 0 then continue

	ll_row = dw_codes.insertrow(0)
	dw_codes.object.procedure_id[ll_row] = ls_procedure_id
	dw_codes.object.description[ll_row] = ls_description
	dw_codes.object.cpt_code[ll_row] = ls_cpt_code
	dw_codes.object.units[ll_row] = ll_units
	dw_codes.object.modifier[ll_row] = ls_modifier
	dw_codes.object.other_modifiers[ll_row] = ls_other_modifiers
next


dw_codes.sort()




end subroutine

on w_svc_billing_code_pick.create
int iCurrent
call super::create
this.cb_be_back=create cb_be_back
this.st_encounter_description=create st_encounter_description
this.dw_codes=create dw_codes
this.cb_done=create cb_done
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_be_back
this.Control[iCurrent+2]=this.st_encounter_description
this.Control[iCurrent+3]=this.dw_codes
this.Control[iCurrent+4]=this.cb_done
this.Control[iCurrent+5]=this.cb_cancel
end on

on w_svc_billing_code_pick.destroy
call super::destroy
destroy(this.cb_be_back)
destroy(this.st_encounter_description)
destroy(this.dw_codes)
destroy(this.cb_done)
destroy(this.cb_cancel)
end on

event open;call super::open;str_popup_return popup_return
long ll_menu_id
str_encounter_description lstr_encounter
integer li_sts
long ll_xmove
u_ds_data luo_data
string ls_root_procedure_id
string ls_procedure_list
long ll_procedure_count
string lsa_procedure_id[]
string ls_sql_query
long i
boolean lb_allow_multiple
boolean lb_charge_required

popup_return.item_count = 1
popup_return.items[1] = "ERROR"

service = message.powerobjectparm

luo_data = CREATE u_ds_data

ls_root_procedure_id = service.get_attribute("root_procedure_id")
ls_procedure_list = service.get_attribute("procedure_list")
ls_sql_query = service.get_attribute("sql_query")
service.get_attribute("allow_multiple", lb_allow_multiple)
service.get_attribute("charge_required", lb_charge_required)

dw_codes.multiselect = lb_allow_multiple

if isnull(ls_root_procedure_id) and isnull(ls_procedure_list) and isnull(ls_sql_query) then
	log.log(this, "w_svc_billing_code_pick.open.0032", "This service requires either a root_procedure_id, sql_query or procedure_list param", 4)
	closewithreturn(this, popup_return)
	DESTROY luo_data
	return
end if

if len(ls_procedure_list) > 0 then
	ll_procedure_count = f_parse_string(ls_procedure_list, ",", lsa_procedure_id)
elseif len(ls_sql_query) > 0 then
	ll_procedure_count = luo_data.load_query(ls_sql_query)
	if ll_procedure_count < 0 then
		log.log(this, "w_svc_billing_code_pick.open.0032", "Error running SQL", 4)
		closewithreturn(this, popup_return)
		return
	end if
	
	for i = 1 to ll_procedure_count
		lsa_procedure_id[i] = luo_data.object.procedure_id[i]
	next
else
	luo_data.set_dataobject("dw_procedure_extra_charges")
	ll_procedure_count = luo_data.retrieve(ls_root_procedure_id)
	if ll_procedure_count < 0 then
		log.log(this, "w_svc_billing_code_pick.open.0032", "Error loading extra charges", 4)
		closewithreturn(this, popup_return)
		return
	end if
	
	for i = 1 to ll_procedure_count
		lsa_procedure_id[i] = luo_data.object.extra_procedure_id[i]
	next
end if


// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 4
end if

DESTROY luo_data


if ll_procedure_count = 0 then
	log.log(this, "w_svc_billing_code_pick.open.0032", "No procedures found", 3)
	popup_return.items[1] = "CANCEL"
	closewithreturn(this, popup_return)
	return
end if

display_codes(ll_procedure_count, lsa_procedure_id)

center_popup()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_billing_code_pick
integer x = 3113
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_billing_code_pick
end type

type cb_be_back from commandbutton within w_svc_billing_code_pick
integer x = 1193
integer y = 1608
integer width = 443
integer height = 108
integer taborder = 70
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

type st_encounter_description from statictext within w_svc_billing_code_pick
integer width = 2199
integer height = 120
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Add Billing Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_codes from u_dw_pick_list within w_svc_billing_code_pick
integer x = 73
integer y = 160
integer width = 2098
integer height = 1388
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_add_billing_code_pick"
boolean border = false
boolean hsplitscroll = true
end type

type cb_done from commandbutton within w_svc_billing_code_pick
integer x = 1696
integer y = 1608
integer width = 443
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
boolean default = true
end type

event clicked;str_popup_return popup_return
integer li_sts

li_sts = post_new_codes()
if li_sts < 0 then
	openwithparm(w_pop_message, "An error occured posting the new billing code")
	return
end if

if li_sts = 0 then
	openwithparm(w_pop_yes_no, "Are you sure you want to exit without posting a billing code?")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return
end if

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)



end event

type cb_cancel from commandbutton within w_svc_billing_code_pick
integer x = 50
integer y = 1608
integer width = 443
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "CANCEL"
closewithreturn(parent, popup_return)


end event

