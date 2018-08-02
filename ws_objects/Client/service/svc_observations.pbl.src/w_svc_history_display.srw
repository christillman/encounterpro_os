$PBExportHeader$w_svc_history_display.srw
forward
global type w_svc_history_display from w_window_base
end type
type cb_beback from commandbutton within w_svc_history_display
end type
type cb_finished from commandbutton within w_svc_history_display
end type
type st_title from statictext within w_svc_history_display
end type
type tab_parents from u_tab_history_parents within w_svc_history_display
end type
type tab_parents from u_tab_history_parents within w_svc_history_display
end type
type st_all_results from statictext within w_svc_history_display
end type
type st_abnormal_results from statictext within w_svc_history_display
end type
type cb_cancel from commandbutton within w_svc_history_display
end type
type dw_results_tree from u_dw_pick_list within w_svc_history_display
end type
type cb_new_results from commandbutton within w_svc_history_display
end type
end forward

global type w_svc_history_display from w_window_base
string title = "History Display"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string button_type = "COMMAND"
cb_beback cb_beback
cb_finished cb_finished
st_title st_title
tab_parents tab_parents
st_all_results st_all_results
st_abnormal_results st_abnormal_results
cb_cancel cb_cancel
dw_results_tree dw_results_tree
cb_new_results cb_new_results
end type
global w_svc_history_display w_svc_history_display

type variables
u_component_service service
u_ds_observation_results results
string observation_id
string abnormal_flag

string format

string edit_service

end variables

forward prototypes
public subroutine pick_observation (string ps_observation_id)
end prototypes

public subroutine pick_observation (string ps_observation_id);long ll_row
string ls_find

//ls_find = "observation_id='" + ps_observation_id + "'"
//ll_row = dw_parents.find(ls_find, 1, dw_parents.rowcount())
//if ll_row > 0 then pick_row(ll_row)

end subroutine

on w_svc_history_display.create
int iCurrent
call super::create
this.cb_beback=create cb_beback
this.cb_finished=create cb_finished
this.st_title=create st_title
this.tab_parents=create tab_parents
this.st_all_results=create st_all_results
this.st_abnormal_results=create st_abnormal_results
this.cb_cancel=create cb_cancel
this.dw_results_tree=create dw_results_tree
this.cb_new_results=create cb_new_results
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_beback
this.Control[iCurrent+2]=this.cb_finished
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.tab_parents
this.Control[iCurrent+5]=this.st_all_results
this.Control[iCurrent+6]=this.st_abnormal_results
this.Control[iCurrent+7]=this.cb_cancel
this.Control[iCurrent+8]=this.dw_results_tree
this.Control[iCurrent+9]=this.cb_new_results
end on

on w_svc_history_display.destroy
call super::destroy
destroy(this.cb_beback)
destroy(this.cb_finished)
destroy(this.st_title)
destroy(this.tab_parents)
destroy(this.st_all_results)
destroy(this.st_abnormal_results)
destroy(this.cb_cancel)
destroy(this.dw_results_tree)
destroy(this.cb_new_results)
end on

event open;call super::open;integer li_count
string ls_dataobject
integer li_sts
long ll_left
long ll_right
string ls_treatment_type
str_popup_return popup_return
long ll_menu_id

popup_return.item_count = 1
popup_return.items[1] = "ERROR"

service = message.powerobjectparm

observation_id = service.root_observation_id()
if isnull(observation_id) then
	log.log(this, "w_svc_history_display.open.0017", "No observation_id", 4)
	closewithreturn(this, popup_return)
	return
end if

title = current_patient.id_line()
st_title.text = datalist.observation_description(observation_id)

format = service.get_attribute("format")
if isnull(format) then format = "fontsize=10,left,margin=0/2200/0"

if service.manual_service then
	cb_finished.text = "OK"
	cb_beback.visible = false
end if

tab_parents.initialize(service, dw_results_tree)

tab_parents.abnormal_flag = upper(left(service.get_attribute("abnormal_flag"), 1))
if isnull(tab_parents.abnormal_flag) then
	SELECT min(treatment_type)
	INTO :ls_treatment_type
	FROM c_Observation_Treatment_Type
	WHERE observation_id = :observation_id;
	if not tf_check() then
		log.log(this, "w_svc_history_display.open.0017", "Error getting observation treatment_type", 4)
		closewithreturn(this, popup_return)
		return
	end if
	
	if lower(ls_treatment_type) = "development" then
		tab_parents.abnormal_flag = "N"
	else
		tab_parents.abnormal_flag = "Y"
	end if
end if

if tab_parents.abnormal_flag = "Y" then
	st_abnormal_results.backcolor = color_object_selected
else
	tab_parents.abnormal_flag = "N"
	st_all_results.backcolor = color_object_selected
end if

if upper(service.cancel_workplan_flag) = "Y" then
	cb_cancel.visible = true
	max_buttons = 2
else
	cb_cancel.visible = false
	max_buttons = 3
end if

ll_menu_id = long(service.get_attribute("menu_id"))
paint_menu(ll_menu_id)

dw_results_tree.object.parent_observation_description.width = dw_results_tree.width - 300

end event

event close;call super::close;if isvalid(results) and not isnull(results) then DESTROY results

end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_history_display
boolean visible = true
integer y = 16
integer width = 256
integer height = 128
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_history_display
end type

type cb_beback from commandbutton within w_svc_history_display
integer x = 1938
integer y = 1604
integer width = 448
integer height = 112
integer taborder = 50
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

type cb_finished from commandbutton within w_svc_history_display
integer x = 2414
integer y = 1604
integer width = 448
integer height = 112
integer taborder = 60
boolean bringtotop = true
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

type st_title from statictext within w_svc_history_display
integer width = 2917
integer height = 120
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "History Display"
alignment alignment = center!
boolean focusrectangle = false
end type

type tab_parents from u_tab_history_parents within w_svc_history_display
integer x = 14
integer y = 128
integer width = 1243
integer height = 1444
integer taborder = 20
end type

type st_all_results from statictext within w_svc_history_display
integer x = 1275
integer y = 1484
integer width = 192
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

tab_parents.abnormal_flag = "N"

tab_parents.refresh()


end event

type st_abnormal_results from statictext within w_svc_history_display
integer x = 1486
integer y = 1484
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

tab_parents.abnormal_flag = "Y"

tab_parents.refresh()


end event

type cb_cancel from commandbutton within w_svc_history_display
integer x = 1463
integer y = 1604
integer width = 448
integer height = 112
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
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

type dw_results_tree from u_dw_pick_list within w_svc_history_display
integer x = 1271
integer y = 128
integer width = 1618
integer height = 1336
integer taborder = 90
boolean bringtotop = true
string dataobject = "dw_pretty_results_tree_2"
boolean vscrollbar = true
end type

event clicked;call super::clicked;openwithparm(w_pop_message, "Clicked")
end event

type cb_new_results from commandbutton within w_svc_history_display
integer x = 1833
integer y = 1472
integer width = 498
integer height = 100
integer taborder = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Info"
end type

event clicked;tab_parents.history_clicked()

end event

