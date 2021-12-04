$PBExportHeader$w_patient_data.srw
forward
global type w_patient_data from w_window_base
end type
type cb_be_back from commandbutton within w_patient_data
end type
type cb_finished from commandbutton within w_patient_data
end type
type tab_patient_data from u_tab_patient_data within w_patient_data
end type
type tab_patient_data from u_tab_patient_data within w_patient_data
end type
type cb_cancel from commandbutton within w_patient_data
end type
end forward

global type w_patient_data from w_window_base
string title = "Patient Information"
windowtype windowtype = response!
cb_be_back cb_be_back
cb_finished cb_finished
tab_patient_data tab_patient_data
cb_cancel cb_cancel
end type
global w_patient_data w_patient_data

type variables
u_component_service service
end variables

forward prototypes
public function integer refresh ()
public function integer get_patient_list_item (string ps_list_id, ref string ps_list_item, ref string ps_patient_value)
public function integer set_patient_list_item (string ps_list_id, string ps_list_item, string ps_patient_value)
public function boolean validated ()
end prototypes

public function integer refresh ();tab_patient_data.refresh()

st_config_mode_menu.height = 48
st_config_mode_menu.y = button_top - 48
//st_config_mode_menu.text = ""

st_config_mode_menu.visible = config_mode

return 1

end function

public function integer get_patient_list_item (string ps_list_id, ref string ps_list_item, ref string ps_patient_value);
integer li_item, li_count
boolean lb_found

li_count = UpperBound(current_patient.list_item)
FOR li_item = 1 TO li_count
	IF current_patient.list_item[li_item].list_id = ps_list_id THEN
		IF current_patient.list_item[li_item].list_item = ps_list_item THEN
			lb_found = true
			ps_patient_value = current_patient.list_item[li_item].list_item_patient_data
		ELSEIF ps_list_item = "" THEN
			lb_found = true
			ps_list_item = current_patient.list_item[li_item].list_item
			IF current_patient.list_item[li_item].list_item_patient_data <> "" THEN
				ps_patient_value = current_patient.list_item[li_item].list_item_patient_data
			END IF
		END IF
	END IF
NEXT

IF NOT lb_found THEN
	RETURN -1
END IF

RETURN 0


end function

public function integer set_patient_list_item (string ps_list_id, string ps_list_item, string ps_patient_value);
integer li_item, li_count
boolean lb_found

li_count = UpperBound(current_patient.list_item)
FOR li_item = 1 TO li_count
	IF current_patient.list_item[li_item].list_id = ps_list_id &
			AND current_patient.list_item[li_item].list_item = ps_list_item THEN
		lb_found = true
		current_patient.list_item[li_item].list_item_patient_data = ps_patient_value
	ELSEIF current_patient.list_item[li_item].list_id = ps_list_id &
			AND ps_patient_value = "" THEN
		// Must be a single-value list item, changing values
		current_patient.list_item[li_item].list_item = ps_list_item
	END IF
NEXT

IF NOT lb_found THEN
	current_patient.list_item[li_count+1].list_id = ps_list_id
	current_patient.list_item[li_count+1].list_item = ps_list_item
	current_patient.list_item[li_count+1].list_item_patient_data = ps_patient_value
END IF

RETURN 0


end function

public function boolean validated ();boolean lb_passes_data = true
boolean lb_passes_comm = true

u_tabpage_patient_data tb_data
u_tabpage_patient_communication tb_comm

tb_data = tab_patient_data.tabpage_general
tb_comm = tab_patient_data.tabpage_communication

IF f_is_empty_string(tb_data.st_id_document.text) THEN
	tb_data.highlight_st(tb_data.st_id_document, true)
	if lb_passes_data then
		openwithparm(w_pop_message, "The id document type is required")
	end if
	lb_passes_data = false
ELSE
	tb_data.highlight_st(tb_data.st_id_document, false)
END IF

IF f_is_empty_string(tb_data.sle_id_number.text) THEN
	tb_data.highlight_sle(tb_data.sle_id_number, true)
	if lb_passes_data then
		openwithparm(w_pop_message, "The id document number is required")
	end if
	lb_passes_data = false
ELSE
	tb_data.highlight_sle(tb_data.sle_id_number, false)
END IF

IF f_is_empty_string(tb_data.st_country.text) THEN
	tb_data.highlight_st(tb_data.st_country, true)
	if lb_passes_data then
		openwithparm(w_pop_message, "The issuing country is required")
	end if
	lb_passes_data = false
ELSE
	tb_data.highlight_st(tb_data.st_country, false)
END IF

IF tb_comm.sle_locality_1.visible AND f_is_empty_string(tb_comm.sle_locality_1.text) THEN
	tb_comm.highlight_sle(tb_comm.sle_locality_1, true)
	if lb_passes_comm then
		openwithparm(w_pop_message, "The " + tb_comm.st_locality_1_t.text + " is required")
	end if
	lb_passes_comm = false
ELSE
	tb_comm.highlight_sle(tb_comm.sle_locality_1, false)
END IF

IF tb_comm.sle_locality_2.visible AND f_is_empty_string(tb_comm.sle_locality_2.text) THEN
	tb_comm.highlight_sle(tb_comm.sle_locality_2, true)
	if lb_passes_comm then
		openwithparm(w_pop_message, "The " + tb_comm.st_locality_2_t.text + " is required")
	end if
	lb_passes_comm = false
ELSE
	tb_comm.highlight_sle(tb_comm.sle_locality_2, false)
END IF

IF tb_comm.sle_locality_3.visible AND f_is_empty_string(tb_comm.sle_locality_3.text) THEN
	tb_comm.highlight_sle(tb_comm.sle_locality_3, true)
	if lb_passes_comm then
		openwithparm(w_pop_message, "The " + tb_comm.st_locality_3_t.text + " is required")
	end if
	lb_passes_comm = false
ELSE
	tb_comm.highlight_sle(tb_comm.sle_locality_3, false)
END IF

IF tb_comm.sle_locality_4.visible AND f_is_empty_string(tb_comm.sle_locality_4.text) THEN
	tb_comm.highlight_sle(tb_comm.sle_locality_4, true)
	if lb_passes_comm then
		openwithparm(w_pop_message, "The " + tb_comm.st_locality_4_t.text + " is required")
	end if
	lb_passes_comm = false
ELSE
	tb_comm.highlight_sle(tb_comm.sle_locality_4, false)
END IF

IF tb_comm.sle_locality_5.visible AND f_is_empty_string(tb_comm.sle_locality_5.text) THEN
	tb_comm.highlight_sle(tb_comm.sle_locality_5, true)
	if lb_passes_comm then
		openwithparm(w_pop_message, "The " + tb_comm.st_locality_5_t.text + " is required")
	end if
	lb_passes_comm = false
ELSE
	tb_comm.highlight_sle(tb_comm.sle_locality_5, false)
END IF

IF tb_comm.sle_locality_6.visible AND f_is_empty_string(tb_comm.sle_locality_6.text) THEN
	tb_comm.highlight_sle(tb_comm.sle_locality_6, true)
	if lb_passes_comm then
		openwithparm(w_pop_message, "The " + tb_comm.st_locality_6_t.text + " is required")
	end if
	lb_passes_comm = false
ELSE
	tb_comm.highlight_sle(tb_comm.sle_locality_6, false)
END IF

if NOT lb_passes_comm then
	tab_patient_data.SelectTab(3)
end if
if NOT lb_passes_data then
	tab_patient_data.SelectTab(1)
end if


RETURN lb_passes_comm AND lb_passes_data

end function

event open;call super::open;str_popup popup
str_popup_return popup_return
integer li_sts
long ll_menu_id
string ls_null

setnull(ls_null)

popup_return.item_count = 1
popup_return.items[1] = "ERROR"

service = message.powerobjectparm

if isnull(current_patient) then
	log.log(this, "w_patient_data:open", "No current patient", 4)
	closewithreturn(this, popup_return)
	return
end if

title = current_patient.id_line()

// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 8
end if

ll_menu_id = f_get_context_menu("Chart", ls_null)
if isnull(ll_menu_id) then
	ll_menu_id = long(service.get_attribute("menu_id"))
end if
paint_menu(ll_menu_id)

tab_patient_data.resize_tabs(width - 30, button_top - 40)

postevent("post_open")


end event

on w_patient_data.create
int iCurrent
call super::create
this.cb_be_back=create cb_be_back
this.cb_finished=create cb_finished
this.tab_patient_data=create tab_patient_data
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_be_back
this.Control[iCurrent+2]=this.cb_finished
this.Control[iCurrent+3]=this.tab_patient_data
this.Control[iCurrent+4]=this.cb_cancel
end on

on w_patient_data.destroy
call super::destroy
destroy(this.cb_be_back)
destroy(this.cb_finished)
destroy(this.tab_patient_data)
destroy(this.cb_cancel)
end on

event post_open;call super::post_open;long ll_display_script_id
u_tabpage_patient_rtf luo_rtf
string ls_title
string ls_script_attribute
string ls_title_attribute
string ls_suffix
integer i

// See if we need to open an RTF page
i = 0
ls_script_attribute = "rtf_display_script_id"
ls_title_attribute = "rtf_display_script_title"
ls_suffix = ""
DO WHILE true
	if i > 0 then ls_suffix = "_" + string(i)
	
	service.get_attribute(ls_script_attribute + ls_suffix, ll_display_script_id)
	if isnull(ll_display_script_id) then exit

	ls_title = service.get_attribute(ls_title_attribute + ls_suffix)
	if isnull(ls_title) then ls_title = "Report"
	
	luo_rtf = tab_patient_data.open_page("u_tabpage_patient_rtf", false)
	if not isnull(luo_rtf) then
		luo_rtf.display_script_id = ll_display_script_id
		luo_rtf.text = ls_title
	end if
	
	i += 1
LOOP

service.get_attribute("followup_display_script_id", ll_display_script_id)
if isnull(ll_display_script_id) then ll_display_script_id = 2759
tab_patient_data.tabpage_followups.display_script_id = ll_display_script_id

service.get_attribute("referral_display_script_id", ll_display_script_id)
if isnull(ll_display_script_id) then ll_display_script_id = 2760
tab_patient_data.tabpage_referrals.display_script_id = ll_display_script_id

tab_patient_data.initialize()

tab_patient_data.tabpage_general.w_container = this
tab_patient_data.tabpage_communication.w_container = this


tab_patient_data.selecttab(1)


end event

event button_pressed;call super::button_pressed;tab_patient_data.refresh()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_patient_data
boolean visible = true
integer x = 2638
integer y = 1352
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_patient_data
end type

type cb_be_back from commandbutton within w_patient_data
integer x = 1966
integer y = 1600
integer width = 443
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
end type

event clicked;
if not validated() then return
f_update_patient_list_items(current_patient.cpr_id, current_patient.list_item)

str_popup_return popup_return

popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type cb_finished from commandbutton within w_patient_data
integer x = 2432
integer y = 1600
integer width = 443
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;
if not validated() then return
f_update_patient_list_items(current_patient.cpr_id, current_patient.list_item)

str_popup_return popup_return
integer li_sts

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type tab_patient_data from u_tab_patient_data within w_patient_data
integer width = 2917
integer height = 1300
long backcolor = COLOR_BACKGROUND
tabposition tabposition = tabsonbottom!
end type

type cb_cancel from commandbutton within w_patient_data
integer x = 1554
integer y = 1600
integer width = 402
integer height = 104
integer taborder = 310
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

popup_return.item = "CANCEL"

closewithreturn(parent, popup_return)

end event

