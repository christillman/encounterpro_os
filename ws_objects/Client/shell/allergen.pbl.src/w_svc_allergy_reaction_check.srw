$PBExportHeader$w_svc_allergy_reaction_check.srw
forward
global type w_svc_allergy_reaction_check from w_window_base
end type
type cb_finished from commandbutton within w_svc_allergy_reaction_check
end type
type cb_be_back from commandbutton within w_svc_allergy_reaction_check
end type
type dw_injections from u_dw_pick_list within w_svc_allergy_reaction_check
end type
type st_page from statictext within w_svc_allergy_reaction_check
end type
type pb_up from picturebutton within w_svc_allergy_reaction_check
end type
type pb_down from picturebutton within w_svc_allergy_reaction_check
end type
type st_no_injections from statictext within w_svc_allergy_reaction_check
end type
type st_1 from statictext within w_svc_allergy_reaction_check
end type
type st_3 from statictext within w_svc_allergy_reaction_check
end type
type st_4 from statictext within w_svc_allergy_reaction_check
end type
type st_2 from statictext within w_svc_allergy_reaction_check
end type
type cb_set_remaining from commandbutton within w_svc_allergy_reaction_check
end type
end forward

global type w_svc_allergy_reaction_check from w_window_base
integer height = 1840
boolean controlmenu = false
windowtype windowtype = response!
string button_type = "COMMAND"
integer max_buttons = 3
cb_finished cb_finished
cb_be_back cb_be_back
dw_injections dw_injections
st_page st_page
pb_up pb_up
pb_down pb_down
st_no_injections st_no_injections
st_1 st_1
st_3 st_3
st_4 st_4
st_2 st_2
cb_set_remaining cb_set_remaining
end type
global w_svc_allergy_reaction_check w_svc_allergy_reaction_check

type variables
u_component_service service


end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();long ll_count


ll_count = dw_injections.retrieve(current_patient.cpr_id,current_patient.open_encounter_id)
if ll_count < 0 then return -1

dw_injections.set_page(1,pb_up,pb_down,st_page)


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
if isnull(service) then
	log.log(this, "w_svc_allergy_reaction_check:open", "No service object", 4)
	closewithreturn(this, popup_return)
	return
end if


// Set the title and sizes
title = current_patient.id_line()

// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 4
end if

ll_menu_id = long(service.get_attribute("menu_id"))
if not isnull(ll_menu_id) then paint_menu(ll_menu_id)

postevent("post_open")
end event

on w_svc_allergy_reaction_check.create
int iCurrent
call super::create
this.cb_finished=create cb_finished
this.cb_be_back=create cb_be_back
this.dw_injections=create dw_injections
this.st_page=create st_page
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_no_injections=create st_no_injections
this.st_1=create st_1
this.st_3=create st_3
this.st_4=create st_4
this.st_2=create st_2
this.cb_set_remaining=create cb_set_remaining
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_finished
this.Control[iCurrent+2]=this.cb_be_back
this.Control[iCurrent+3]=this.dw_injections
this.Control[iCurrent+4]=this.st_page
this.Control[iCurrent+5]=this.pb_up
this.Control[iCurrent+6]=this.pb_down
this.Control[iCurrent+7]=this.st_no_injections
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.st_4
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.cb_set_remaining
end on

on w_svc_allergy_reaction_check.destroy
call super::destroy
destroy(this.cb_finished)
destroy(this.cb_be_back)
destroy(this.dw_injections)
destroy(this.st_page)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_no_injections)
destroy(this.st_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_2)
destroy(this.cb_set_remaining)
end on

event post_open;call super::post_open;str_popup_return		popup_return
integer li_sts

popup_return.item_count = 1
popup_return.items[1] = "ERROR"

li_sts = refresh()
if li_sts < 0 then
	closewithreturn(this,popup_return)
	return
end if


end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_allergy_reaction_check
boolean visible = true
integer x = 2615
integer y = 24
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_allergy_reaction_check
integer x = 46
integer y = 1576
end type

type cb_finished from commandbutton within w_svc_allergy_reaction_check
integer x = 2400
integer y = 1620
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
integer li_sts
string ls_description

//if isnull(consultant_id) then
//	openwithparm(w_pop_yes_no, "Do you wish to exit without selecting a consultant?")
//	popup_return = message.powerobjectparm
//	if popup_return.item = "YES" then
//		popup_return.item_count = 1
//		popup_return.items[1] = "CANCEL"
//		
//		closewithreturn(parent, popup_return)
//	end if
//	return
//end if


popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type cb_be_back from commandbutton within w_svc_allergy_reaction_check
integer x = 1934
integer y = 1620
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

type dw_injections from u_dw_pick_list within w_svc_allergy_reaction_check
integer x = 18
integer y = 348
integer width = 2843
integer height = 1044
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_allergy_injections"
boolean border = false
boolean livescroll = false
end type

event constructor;call super::constructor;settransobject(Sqlca)
end event

event selected;call super::selected;string	ls_reaction
long   			ll_null
datetime 		ldt_null
string ls_previouos_reaction

str_popup			popup
str_popup_return  popup_return
long ll_treatment_id
string ls_no_reaction
string ls_patient_left

setnull(ldt_null)
setnull(ll_null)

ll_treatment_id = object.treatment_id[selected_row]
ls_previouos_reaction = object.reaction[selected_row]

ls_no_reaction = service.get_attribute("no_reaction_progress")
if isnull(ls_no_reaction) then ls_no_reaction = "No Reaction"

ls_patient_left = service.get_attribute("patient_left_progress")
if isnull(ls_patient_left) then ls_patient_left = "Patient left before reaction check"

popup.data_row_count = 3
popup.items[1] = "Reaction"
popup.items[2] = ls_no_reaction
popup.items[3] = ls_patient_left
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

CHOOSE CASE popup_return.item_indexes[1]
	CASE 1
		// Call progress note edit to get the comments
		popup.data_row_count = 3
		popup.items[1] = "REACTION_CHECK"
		popup.items[2] = "REACTION_CHECK"
		popup.items[3] = ls_previouos_reaction
		
		Openwithparm(w_progress_note_edit,popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count = 0 then return
		
		ls_reaction = popup_return.items[1]
	CASE 2
		ls_reaction = ls_no_reaction
	CASE 3
		ls_reaction = ls_patient_left
END CHOOSE

if len(ls_reaction) > 0 then
	f_set_progress(current_patient.cpr_id, &
                        "Treatment", &
                        ll_treatment_id, &
                        'Property', &
                        'Reaction', &
                        ls_reaction, &
                        ldt_null, &
                        ll_null, &
                        ll_null, &
                        ll_null)
End If

clear_selected()
refresh()

end event

type st_page from statictext within w_svc_allergy_reaction_check
integer x = 2245
integer y = 1412
integer width = 142
integer height = 108
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean focusrectangle = false
end type

type pb_up from picturebutton within w_svc_allergy_reaction_check
integer x = 2560
integer y = 1412
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

li_page = dw_injections.current_page

dw_injections.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from picturebutton within w_svc_allergy_reaction_check
integer x = 2409
integer y = 1412
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

li_page = dw_injections.current_page
li_last_page = dw_injections.last_page

dw_injections.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type st_no_injections from statictext within w_svc_allergy_reaction_check
integer x = 974
integer y = 412
integer width = 1193
integer height = 188
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "No allergy Injections"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_svc_allergy_reaction_check
integer x = 279
integer y = 276
integer width = 640
integer height = 68
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Injection"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_svc_allergy_reaction_check
integer x = 1243
integer y = 276
integer width = 416
integer height = 64
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Location"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_svc_allergy_reaction_check
integer x = 2039
integer y = 276
integer width = 416
integer height = 64
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Reaction"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_svc_allergy_reaction_check
integer width = 2889
integer height = 124
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Allergy Reaction Check"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_set_remaining from commandbutton within w_svc_allergy_reaction_check
integer x = 864
integer y = 1436
integer width = 1193
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Set Remaining Items To ~"No Reaction~""
end type

event clicked;long   			ll_null
datetime 		ldt_null
string ls_previouos_reaction
long ll_treatment_id
string ls_no_reaction
long ll_rowcount
long ll_row
long i
integer li_sts

setnull(ldt_null)
setnull(ll_null)


ls_no_reaction = service.get_attribute("no_reaction_progress")
if isnull(ls_no_reaction) then ls_no_reaction = "No Reaction"

ll_rowcount = dw_injections.rowcount()

for i = 1 to ll_rowcount
	ll_treatment_id = dw_injections.object.treatment_id[i]
	ls_previouos_reaction = dw_injections.object.reaction[i]
	
	if len(ls_previouos_reaction) > 0 then continue
	
	li_sts = f_set_progress(current_patient.cpr_id, &
									"Treatment", &
									ll_treatment_id, &
									'Property', &
									'Reaction', &
									ls_no_reaction, &
									ldt_null, &
									ll_null, &
									ll_null, &
									ll_null)

	dw_injections.object.reaction[i] = ls_no_reaction
next

cb_finished.event POST clicked()


end event

