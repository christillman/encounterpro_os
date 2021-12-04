$PBExportHeader$w_svc_results_by_treatment_display.srw
forward
global type w_svc_results_by_treatment_display from w_window_base
end type
type dw_parents from u_dw_pick_list within w_svc_results_by_treatment_display
end type
type cb_beback from commandbutton within w_svc_results_by_treatment_display
end type
type cb_finished from commandbutton within w_svc_results_by_treatment_display
end type
type st_page from statictext within w_svc_results_by_treatment_display
end type
type pb_up from picturebutton within w_svc_results_by_treatment_display
end type
type pb_down from picturebutton within w_svc_results_by_treatment_display
end type
type pb_rtf_up from picturebutton within w_svc_results_by_treatment_display
end type
type pb_rtf_down from picturebutton within w_svc_results_by_treatment_display
end type
type cb_clipboard from commandbutton within w_svc_results_by_treatment_display
end type
type st_1 from statictext within w_svc_results_by_treatment_display
end type
type st_2 from statictext within w_svc_results_by_treatment_display
end type
type st_abnormal_results from statictext within w_svc_results_by_treatment_display
end type
type st_all_results from statictext within w_svc_results_by_treatment_display
end type
type tab_1 from tab within w_svc_results_by_treatment_display
end type
type tabpage_history from userobject within tab_1
end type
type rte_history from u_rich_text_edit within tabpage_history
end type
type tabpage_history from userobject within tab_1
rte_history rte_history
end type
type tabpage_attachments from u_results_by_treatment_atchments within tab_1
end type
type tabpage_attachments from u_results_by_treatment_atchments within tab_1
end type
type tab_1 from tab within w_svc_results_by_treatment_display
tabpage_history tabpage_history
tabpage_attachments tabpage_attachments
end type
type st_title from statictext within w_svc_results_by_treatment_display
end type
end forward

global type w_svc_results_by_treatment_display from w_window_base
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string button_type = "COMMAND"
integer max_buttons = 4
dw_parents dw_parents
cb_beback cb_beback
cb_finished cb_finished
st_page st_page
pb_up pb_up
pb_down pb_down
pb_rtf_up pb_rtf_up
pb_rtf_down pb_rtf_down
cb_clipboard cb_clipboard
st_1 st_1
st_2 st_2
st_abnormal_results st_abnormal_results
st_all_results st_all_results
tab_1 tab_1
st_title st_title
end type
global w_svc_results_by_treatment_display w_svc_results_by_treatment_display

type variables
u_component_service service
string observation_type
string treatment_type
long encounter_id
string abnormal_flag = "N"
string edit_service
string comment_service

long display_script_id

long display_script_id_abnormal
long display_script_id_all

end variables

forward prototypes
public function integer load_treatment_type ()
public function integer load_observation_type ()
public function integer load_treatments ()
public function integer load_encounter_id ()
public subroutine history_menu ()
public function integer display_treatment_rtf (long pl_treatment_id)
public function integer refresh ()
end prototypes

public function integer load_treatment_type ();string ls_find
str_treatment_description lstra_treatments[]
integer li_count
long ll_row
long i
string ls_description

dw_parents.reset()

if isnull(treatment_type) then return 0

ls_find = "treatment_type='" + treatment_type + "'"

li_count = current_patient.treatments.get_treatments(ls_find, lstra_treatments)
if li_count <= 0 then return li_count

for i = 1 to li_count
	ls_description = string(lstra_treatments[i].begin_date, date_format_string)
	ls_description += " " + lstra_treatments[i].treatment_description
	ll_row = dw_parents.insertrow(0)
	dw_parents.object.description[ll_row] = ls_description
	dw_parents.object.treatment_id[ll_row] = lstra_treatments[i].treatment_id
	dw_parents.object.begin_date[ll_row] = lstra_treatments[i].begin_date
next

dw_parents.sort()

dw_parents.set_page(1, pb_up, pb_down, st_page)

return 1

end function

public function integer load_observation_type ();long ll_count
u_ds_data luo_data
long i
long ll_row
string ls_description

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_treatments_of_observation_type")
ll_count = luo_data.retrieve(current_patient.cpr_id, observation_type)

for i = 1 to ll_count
	ls_description = string(date(luo_data.object.begin_date[i]), date_format_string)
	ls_description += " " + string(luo_data.object.treatment_description[i])
	ll_row = dw_parents.insertrow(0)
	dw_parents.object.description[ll_row] = ls_description
	dw_parents.object.treatment_id[ll_row] = luo_data.object.treatment_id[i]
	dw_parents.object.begin_date[ll_row] = luo_data.object.begin_date[i]
next

DESTROY luo_data

dw_parents.sort()

dw_parents.set_page(1, pb_up, pb_down, st_page)

return 1

end function

public function integer load_treatments ();long ll_treatment_id
long ll_treatment_progress_sequence
integer li_sts
long ll_rows
long i

if not isnull(observation_type) then
	li_sts = load_observation_type()
elseif not isnull(treatment_type) then
	li_sts = load_treatment_type()
elseif not isnull(encounter_id) then
	li_sts = load_encounter_id()
else
	return 0
end if

ll_rows = dw_parents.rowcount()
if ll_rows > 0 then
	ll_treatment_id = dw_parents.object.treatment_id[1]
end if

// Mark the ones which are already reviewed
for i = 1 to ll_rows
	ll_treatment_id = dw_parents.object.treatment_id[i]
	if i = 1 then
		dw_parents.object.selected_flag[i] = 1
		display_treatment_rtf(ll_treatment_id)
	end if
	SELECT max(treatment_progress_sequence)
	INTO :ll_treatment_progress_sequence
	FROM p_Treatment_Progress
	WHERE cpr_id = :current_patient.cpr_id
	AND treatment_id = :ll_treatment_id
	AND encounter_id = :service.encounter_id
	AND user_id = :current_user.user_id
	AND progress_type = 'REVIEWED';
	if not tf_check() then return -1
	if not isnull(ll_treatment_progress_sequence) then
		dw_parents.object.reviewed_flag[i] = 1
	end if
next

return li_sts


end function

public function integer load_encounter_id ();string ls_find
str_treatment_description lstra_treatments[]
integer li_count
long ll_row
long i
string ls_description

dw_parents.reset()

if isnull(encounter_id) then return 0

ls_find = "open_encounter_id=" + string(encounter_id)
ls_find += " and not isnull(observation_type)"

li_count = current_patient.treatments.get_treatments(ls_find, lstra_treatments)
if li_count <= 0 then return li_count

for i = 1 to li_count
	ls_description = string(lstra_treatments[i].begin_date, date_format_string)
	ls_description += " " + lstra_treatments[i].treatment_description
	ll_row = dw_parents.insertrow(0)
	dw_parents.object.description[ll_row] = ls_description
	dw_parents.object.treatment_id[ll_row] = lstra_treatments[i].treatment_id
	dw_parents.object.begin_date[ll_row] = lstra_treatments[i].begin_date
next

dw_parents.sort()

dw_parents.set_page(1, pb_up, pb_down, st_page)

return 1

end function

public subroutine history_menu ();str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
integer li_update_flag
string ls_temp
string ls_description
string ls_null
long ll_null
str_attributes lstr_attributes
long ll_row
long ll_treatment_id
string ls_find

u_component_treatment luo_treatment

ll_row = dw_parents.get_selected_row()
if ll_row <= 0 then return

ll_treatment_id = dw_parents.object.treatment_id[ll_row]

setnull(ls_null)
setnull(ll_null)


if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Mark history as reviewed"
	popup.button_titles[popup.button_count] = "Reviewed"
	buttons[popup.button_count] = "REVIEWED"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit history"
	popup.button_titles[popup.button_count] = "Edit"
	buttons[popup.button_count] = "EDIT"
end if

if not isnull(comment_service) then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Enter Comments"
	popup.button_titles[popup.button_count] = "Enter Comments"
	buttons[popup.button_count] = "COMMENTS"
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
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	button_pressed = message.doubleparm
	if button_pressed < 1 or button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if

CHOOSE CASE buttons[button_pressed]
	CASE "REVIEWED"
		current_patient.treatments.set_treatment_progress(ll_treatment_id, "REVIEWED")
		dw_parents.object.reviewed_flag[ll_row] = 1
	CASE "EDIT"
		lstr_attributes.attribute_count = 1
		lstr_attributes.attribute[1].attribute = "treatment_id"
		lstr_attributes.attribute[1].value = string(ll_treatment_id)
		current_patient.treatments.treatment(luo_treatment,ll_treatment_id)
		service_list.do_service(current_patient.cpr_id, current_patient.open_encounter_id, edit_service, luo_treatment,lstr_attributes)
		
		li_sts = display_treatment_rtf(ll_treatment_id)
	CASE "COMMENTS"
		lstr_attributes.attribute_count = 1
		lstr_attributes.attribute[1].attribute = "treatment_id"
		lstr_attributes.attribute[1].value = string(ll_treatment_id)
		current_patient.treatments.treatment(luo_treatment,ll_treatment_id)
		service_list.do_service(current_patient.cpr_id, current_patient.open_encounter_id, comment_service, luo_treatment,lstr_attributes)
		
		li_sts = display_treatment_rtf(ll_treatment_id)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end subroutine

public function integer display_treatment_rtf (long pl_treatment_id);long ll_count
str_treatment_description lstr_treatment
integer li_sts
u_ds_observation_results luo_results

tab_1.tabpage_history.rte_history.clear_rtf()

tab_1.tabpage_history.rte_history.display_treatment(pl_treatment_id, display_script_id)

// retrieve attachments for the selected treatment
tab_1.tabpage_attachments.context_object = "Treatment"
tab_1.tabpage_attachments.object_key = pl_treatment_id

// Always update the attachments tab
ll_count = tab_1.tabpage_attachments.display_attachments()

return 1

end function

public function integer refresh ();long ll_row
long ll_treatment_id

ll_row = dw_parents.get_selected_row()
if ll_row <= 0 then return 1

ll_treatment_id = dw_parents.object.treatment_id[ll_row]

display_treatment_rtf(ll_treatment_id)

return 1

end function

on w_svc_results_by_treatment_display.create
int iCurrent
call super::create
this.dw_parents=create dw_parents
this.cb_beback=create cb_beback
this.cb_finished=create cb_finished
this.st_page=create st_page
this.pb_up=create pb_up
this.pb_down=create pb_down
this.pb_rtf_up=create pb_rtf_up
this.pb_rtf_down=create pb_rtf_down
this.cb_clipboard=create cb_clipboard
this.st_1=create st_1
this.st_2=create st_2
this.st_abnormal_results=create st_abnormal_results
this.st_all_results=create st_all_results
this.tab_1=create tab_1
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_parents
this.Control[iCurrent+2]=this.cb_beback
this.Control[iCurrent+3]=this.cb_finished
this.Control[iCurrent+4]=this.st_page
this.Control[iCurrent+5]=this.pb_up
this.Control[iCurrent+6]=this.pb_down
this.Control[iCurrent+7]=this.pb_rtf_up
this.Control[iCurrent+8]=this.pb_rtf_down
this.Control[iCurrent+9]=this.cb_clipboard
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.st_abnormal_results
this.Control[iCurrent+13]=this.st_all_results
this.Control[iCurrent+14]=this.tab_1
this.Control[iCurrent+15]=this.st_title
end on

on w_svc_results_by_treatment_display.destroy
call super::destroy
destroy(this.dw_parents)
destroy(this.cb_beback)
destroy(this.cb_finished)
destroy(this.st_page)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.pb_rtf_up)
destroy(this.pb_rtf_down)
destroy(this.cb_clipboard)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_abnormal_results)
destroy(this.st_all_results)
destroy(this.tab_1)
destroy(this.st_title)
end on

event open;call super::open;integer li_count
string ls_dataobject
integer li_sts
long ll_left
long ll_right,ll_treatment_id
str_popup_return popup_return
string ls_description
string ls_component_id
long ll_menu_id

popup_return.item_count = 0

service = message.powerobjectparm

if isnull(current_patient) then
	title = "History Display"
else
	title = current_patient.id_line()
end if

service.get_attribute("display_script_id", display_script_id_all)
service.get_attribute("display_script_id_abnormal", display_script_id_abnormal)
if isnull(display_script_id_abnormal) then
	st_all_results.visible = false
	st_abnormal_results.visible = false
end if

setnull(encounter_id)
observation_type = service.get_attribute("observation_type")
if isnull(observation_type) then
	treatment_type = service.get_attribute("treatment_type")
	if isnull(treatment_type) then
		if not isnull(current_service) then encounter_id = current_service.encounter_id
	else
		ls_description = datalist.treatment_type_description(treatment_type)
	end if
else
	ls_description = observation_type
	setnull(treatment_type)
end if

if isnull(observation_type) and isnull(treatment_type) and isnull(encounter_id) then
	openwithparm(w_pop_message, "Nothing to display")
	popup_return.item_count = 1
	popup_return.items[1] = "COMPLETE"
	closewithreturn(this, popup_return)
	return
end if

edit_service = service.get_attribute("edit_service")
if isnull(edit_service) then
	ls_component_id = datalist.treatment_type_component(treatment_type)
	if ls_component_id = "TREAT_TEST" then
		edit_service = "EDIT_TREATMENT_RESULTS"
	else
		edit_service = "TREATMENT_REVIEW"
	end if
end if

comment_service = service.get_attribute("comment_service")
if isnull(comment_service) then
	ls_component_id = datalist.treatment_type_component(treatment_type)
	if ls_component_id = "TREAT_TEST" then
		comment_service = "FREEHISTORY"
	else
		setnull(comment_service)
	end if
end if

// initialize attachments
Setnull(ll_treatment_id)
tab_1.tabpage_attachments.initialize("treatment",ll_treatment_id)

st_all_results.backcolor = color_object_selected
display_script_id = display_script_id_all

li_sts = load_treatments()
if li_sts = 0 then
	openwithparm(w_pop_message, "No " + ls_description + " histories to display")
	popup_return.item_count = 1
	popup_return.items[1] = "COMPLETE"
	closewithreturn(this, popup_return)
	return
elseif li_sts < 0 then
	log.log(this, "w_svc_results_by_treatment_display:open", "Error loading treatments", 4)
	closewithreturn(this, popup_return)
	return
end if

if service.manual_service then
	cb_finished.text = "OK"
	cb_beback.visible = false
	max_buttons = 3
end if

ll_menu_id = long(service.get_attribute("menu_id"))
if not isnull(ll_menu_id) then paint_menu(ll_menu_id)


dw_parents.object.description.width = dw_parents.width - 118
tab_1.tabpage_history.rte_history.width = tab_1.tabpage_history.width
tab_1.tabpage_history.rte_history.height = tab_1.tabpage_history.height






end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_results_by_treatment_display
boolean visible = true
integer x = 2309
integer width = 256
integer height = 128
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_results_by_treatment_display
integer x = 315
integer y = 1544
integer width = 864
end type

type dw_parents from u_dw_pick_list within w_svc_results_by_treatment_display
integer x = 18
integer y = 132
integer width = 1129
integer height = 1332
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_treatment_display_list"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event selected;long ll_treatment_id

ll_treatment_id = object.treatment_id[selected_row]
display_treatment_rtf(ll_treatment_id)


end event

type cb_beback from commandbutton within w_svc_results_by_treatment_display
integer x = 1746
integer y = 1604
integer width = 539
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
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

type cb_finished from commandbutton within w_svc_results_by_treatment_display
integer x = 2322
integer y = 1604
integer width = 539
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'m Finished"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "COMPLETE"

closewithreturn(parent, popup_return)


end event

type st_page from statictext within w_svc_results_by_treatment_display
integer x = 320
integer y = 1480
integer width = 197
integer height = 56
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "99 of 99"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_up from picturebutton within w_svc_results_by_treatment_display
integer x = 23
integer y = 1476
integer width = 137
integer height = 116
integer taborder = 60
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

li_page = dw_parents.current_page

dw_parents.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from picturebutton within w_svc_results_by_treatment_display
integer x = 174
integer y = 1476
integer width = 137
integer height = 116
integer taborder = 90
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

li_page = dw_parents.current_page
li_last_page = dw_parents.last_page

dw_parents.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type pb_rtf_up from picturebutton within w_svc_results_by_treatment_display
integer x = 2569
integer y = 12
integer width = 137
integer height = 116
integer taborder = 70
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

event clicked;tab_1.tabpage_history.rte_history.Scroll_up()
end event

type pb_rtf_down from picturebutton within w_svc_results_by_treatment_display
integer x = 2725
integer y = 12
integer width = 137
integer height = 116
integer taborder = 100
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

event clicked;tab_1.tabpage_history.rte_history.Scroll_down()
end event

type cb_clipboard from commandbutton within w_svc_results_by_treatment_display
boolean visible = false
integer x = 1970
integer y = 1504
integer width = 251
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clipboard"
end type

event clicked;tab_1.tabpage_history.rte_history.copy_to_clipboard(true)

end event

type st_1 from statictext within w_svc_results_by_treatment_display
integer x = 809
integer y = 1492
integer width = 50
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "R"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_svc_results_by_treatment_display
integer x = 873
integer y = 1492
integer width = 283
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "= Reviewed"
boolean focusrectangle = false
end type

type st_abnormal_results from statictext within w_svc_results_by_treatment_display
integer x = 2624
integer y = 1500
integer width = 261
integer height = 84
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Abnormal"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_all_results.backcolor = color_object

abnormal_flag = "Y"
display_script_id = display_script_id_abnormal

refresh()


end event

type st_all_results from statictext within w_svc_results_by_treatment_display
integer x = 2341
integer y = 1500
integer width = 261
integer height = 84
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "All"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_abnormal_results.backcolor = color_object

abnormal_flag = "N"
display_script_id = display_script_id_all

refresh()


end event

type tab_1 from tab within w_svc_results_by_treatment_display
integer x = 1193
integer y = 136
integer width = 1719
integer height = 1456
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
tabposition tabposition = tabsonbottom!
integer selectedtab = 1
tabpage_history tabpage_history
tabpage_attachments tabpage_attachments
end type

on tab_1.create
this.tabpage_history=create tabpage_history
this.tabpage_attachments=create tabpage_attachments
this.Control[]={this.tabpage_history,&
this.tabpage_attachments}
end on

on tab_1.destroy
destroy(this.tabpage_history)
destroy(this.tabpage_attachments)
end on

event selectionchanged;if newindex = 2 then
	pb_rtf_up.visible = false
	pb_rtf_down.visible = false
else
	pb_rtf_up.visible = true
	pb_rtf_down.visible = true
end if

end event

type tabpage_history from userobject within tab_1
integer x = 18
integer y = 16
integer width = 1682
integer height = 1328
long backcolor = COLOR_BACKGROUND
string text = "History"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
rte_history rte_history
end type

on tabpage_history.create
this.rte_history=create rte_history
this.Control[]={this.rte_history}
end on

on tabpage_history.destroy
destroy(this.rte_history)
end on

type rte_history from u_rich_text_edit within tabpage_history
integer width = 1682
integer height = 1320
integer taborder = 30
borderstyle borderstyle = styleraised!
end type

event lbuttondown;call super::lbuttondown;history_menu()

dw_parents.setfocus()

end event

type tabpage_attachments from u_results_by_treatment_atchments within tab_1
integer x = 18
integer y = 16
integer width = 1682
integer height = 1328
string text = "Attachments"
end type

type st_title from statictext within w_svc_results_by_treatment_display
integer width = 2917
integer height = 120
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "History Display"
alignment alignment = center!
boolean focusrectangle = false
end type


Start of PowerBuilder Binary Data Section : Do NOT Edit
0Cw_svc_results_by_treatment_display.bin 
2500001800e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd00000008fffffffe0000000400000005000000060000000700000009fffffffe0000000afffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff0000000300000000000000000000000000000000000000000000000000000000fcd819a001ca361e0000000300000cc00000000000500003004c004200430049004e0045004500530045004b000000590000000000000000000000000000000000000000000000000000000000000000000000000002001cffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000001a0000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000002001affffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000010000087b00000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000101001a00000002000000010000000426bd990111dde7d0130041aa7c6650d300000000fcd819a001ca361efcd819a001ca361e000000000000000000000000fffffffe00000002000000030000000400000005000000060000000700000008000000090000000a0000000b0000000c0000000d0000000e0000000f000000100000001100000012000000130000001400000015000000160000001700000018000000190000001a0000001b0000001c0000001d0000001e0000001f000000200000002100000022fffffffe0000002400000025000000260000002700000028000000290000002a0000002b0000002c0000002d0000002e0000002f000000300000003100000032fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
2Cffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff005000540036002d003100340036003200390037003100360065003900420072006900750064006c0072006500310020002e0031003b0030003a00430050005c0000fffe0002020526bd990111dde7d0130041aa7c6650d300000001fb8f0821101b01640008ed8413c72e2b000000300000084b0000003a00000100000001d800000101000001e000000102000001e800000103000001f000000104000001f8000001050000020000000106000002080000010700000210000001080000021800000109000002200000010a000002280000010b000002300000010c000002380000010d000002400000010e000002480000010f00000250000001100000025800000111000002600000011200000268000001130000027000000114000002ac00000115000002b400000116000002bc00000117000002c400000118000002cc00000119000002d40000011a000002dc0000011b000002e40000011c000002ec0000011d000002f40000011e000002fc0000011f0000030c0000012000000314000001210000031c0000012200000324000001230000032c0000012400000334000001250000033c0000012600000344000001270000034c0000012800000354000001290000035c0000012a000003640000012b0000036c0000012c000003740000012d0000037c0000012e000003840000012f0000038c0000013000000394000001310000039c00000132000003a800000133000003b000000134000003b800000135000003c000000136000003c800000137000003d000000138000003d800000000000003e000000003000200000000000300002609000000030000221b00000003000000490000000200000001000000020000000100000002000000010000000b0000000000000002000000000000000b0000ffff0000000b0000ffff0000000200000000000000020000006400000002000000030000000b000000000000000b0000ffff00000002000000000000000b0000ffff0000000b000000000000000800000031505c3a4352474f525c317e4149454854317e414d5458545c7e5458455c302e325c6e694252454d414e4143494454562e0000000000000002000000030000000300002fd00000000300003de000000003000005a000000003000005a000000003000005a000000003000005a000000002000000640000000b000000000000000b0000ffff0000000800000006616972410000006c000000020000000c0000000b000000000000000b000000000000000b000000000000000b0000000000000002000000000000000300ffffff0000000200000000000000020000006400000002000000000000000200000020000000020000000000000002000000140000000200000000000000020000000000000002000000000000000200000000000000020000000000000008000000010000000000000002000000010000000b0000ffff0000000b0000ffff0000000b000000000000000200000000000000020000000100000002000000000000003a00000000000000010001330000000a006c6c61006e75776f32006f640d000001770000007764726f6d7061720065646f00000112000000106d726f66657374617463656c006e6f69000001090000000e65646968656c65736f6974630108006e00090000646500006f6d7469280065640d0000016c00000073656e69696361700074676e000001190000000c656761706772616d00726e69000001070000000d746e6f63636c6f727372616800012d0000000800646e690072746e6500011e00000009006e6f66006d616e74011a0065000c000061700000616d65676e696772010e0062000d00006c6300006863706972646c6930006e6508000001690000006e65646e180062740c000001700000006d656761696772611500746e0a00000170000000776567616874646900010b0000000d00756f6d006f70657365746e6901060072000a00006162000074736b6300656c790000013400000015747865746d61726672616d656c72656b73656e6900012f0000000800646e690074746e650001270000000c006e696c0061707365676e696300010c0000000b006f6f7a006361666d00726f740000010a0000000e65736e696f697472646f6d6e012a0065000e00007266000064656d61617473690065636e000001130000001270737476646c6c656974636972616e6f01030079000c0000735f00006b636f74706f7270013600730010000061700000726f6567746e65696f6974610135006e00170000696600006c646c65746b6e696567726172616d747372656b0001210000000b006e6f6600617469740063696c0000011000000009657a697365646f6d0001050000000c00726f620073726564656c79740001370000000e006761700065697665797473772600656c0a000001610000006e67696c746e656d0001240000000900736162006e696c6501160065000b00006170000065686567746867690001250000000c0078657400636b6274726f6c6f0001230000000e006e6f6600646e7574696c72652200656e0f0000016600000073746e6f6b69727472687465011f0075000900006f6600006973746e1100657a0700000174000000656b6261012b0079000f0000726600006c656d6177656e69687464690001290000000b0061726600
267473656d00656c7900000101000000097478655f78746e6500012000000009006e6f66006c6f62740102006400090000655f00006e657478380079740d0000016600000073746e6f697474650073676e0000011d0000000c6e6972706c6f63740073726f000001170000000c656761706772616d006c6e690000010d000000097765697665646f6d00012c0000000800646e69006c746e6500012e0000000900646e690066746e650131006c00050000657400001c0074780c00000170000000746e69727366666f1b0074650a00000170000000746e69726d6f6f7a0001140000000b0072637300626c6c6f007372610000010400000009676e616c65676175000100000000090065765f006f697372010f006e000d00006c630000697370696e696c62000073670063006100020000000026090000221b000000490000000000ffffff0100010100000100010100000064000001000003000100005c3a4330474f5250317e41524548545c7e414d4958545c3154584554302e327e6e69425c454d415c4143495254562e4e03000044002fd000003de0000005a0000005a0000005a0000005a00000006400724105010c6c616900000000ff0000000000ffff000064000000200000001400000000000000000001000000010100010100000020000000dc0000030e0001050000000000000000020000005c000000010000010100010000000100000000009f000000010001000000000000000000000000000000000000ff1050000000000001900000000000412202006c616972000000000000000000000000000000000000000000000000010000000100010000000000000000000000000020006400006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000023000003db000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001400046e01000108dc01b8010d4a16260111011a940170011f0227de0123012c4c01280130ba39960135003e040100000000000000000000000041000000690072006c0061000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e4000000010000040900010000010006002e000000ffffb7000000000000000000000000010000000000000000000000000000000000000000000100000000000000000000000000010000000100010000000100000000000000000000000000000000005400000030000001000000000000000000000000000000000000000000400000000000000100000000000000000000000000000024000000010000010000000000ff1000000000000001900000000000410202006c6169720000000000000000000000000000000000000000000000000000000000000000000000000000000041000000690072006c006100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000005000000000000000002000640000000f00046e01000108dc01b8010d4a16260111011a940170011f0227de0123012c4c01280130ba39960135013e04010900010000010006002e000000ffffb700000000000000000000000000000000000012000000000000000000000000000000000000000000000000004e005b0072006f0061006d005d006c000100000000004e0000003200000000003700000037023702d0023702e000002fa000003da005a0052005a00500800f020000000001000000000000001b0000000000000100000000000000000000000000000000000000000000000000720041006100690020006c00740049006c006100630069000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000740049006c006100630069000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
210000000000750054006b00720073006900000068000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080076640000000000000000201fff1e000000240000001d0000000700000004000000010000000e0000003400000190000000000000006000000060fffc00200020001f270000ff000000a20024000100000800000008f000000388000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1Cw_svc_results_by_treatment_display.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
