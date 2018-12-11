$PBExportHeader$w_service_exception.srw
forward
global type w_service_exception from w_window_base
end type
type cb_ok from commandbutton within w_service_exception
end type
type st_created from statictext within w_service_exception
end type
type st_created_title from statictext within w_service_exception
end type
type st_title from statictext within w_service_exception
end type
type st_service from statictext within w_service_exception
end type
type st_extension_title from statictext within w_service_exception
end type
type st_description from statictext within w_service_exception
end type
type st_attachment_type_title from statictext within w_service_exception
end type
type st_ordered_for from statictext within w_service_exception
end type
type st_attachment_folder_title from statictext within w_service_exception
end type
type st_ordered_by from statictext within w_service_exception
end type
type st_7 from statictext within w_service_exception
end type
type st_context_object_title from statictext within w_service_exception
end type
type st_object_description_title from statictext within w_service_exception
end type
type st_object_description from statictext within w_service_exception
end type
type st_context_object from statictext within w_service_exception
end type
type st_1 from statictext within w_service_exception
end type
type st_2 from statictext within w_service_exception
end type
type st_4 from statictext within w_service_exception
end type
type st_3 from statictext within w_service_exception
end type
type cb_cancel from commandbutton within w_service_exception
end type
type cb_forward from commandbutton within w_service_exception
end type
type cb_nothing from commandbutton within w_service_exception
end type
end forward

global type w_service_exception from w_window_base
string title = "EncounterPRO Service Exception"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_ok cb_ok
st_created st_created
st_created_title st_created_title
st_title st_title
st_service st_service
st_extension_title st_extension_title
st_description st_description
st_attachment_type_title st_attachment_type_title
st_ordered_for st_ordered_for
st_attachment_folder_title st_attachment_folder_title
st_ordered_by st_ordered_by
st_7 st_7
st_context_object_title st_context_object_title
st_object_description_title st_object_description_title
st_object_description st_object_description
st_context_object st_context_object
st_1 st_1
st_2 st_2
st_4 st_4
st_3 st_3
cb_cancel cb_cancel
cb_forward cb_forward
cb_nothing cb_nothing
end type
global w_service_exception w_service_exception

type variables
u_component_service service



end variables

on w_service_exception.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.st_created=create st_created
this.st_created_title=create st_created_title
this.st_title=create st_title
this.st_service=create st_service
this.st_extension_title=create st_extension_title
this.st_description=create st_description
this.st_attachment_type_title=create st_attachment_type_title
this.st_ordered_for=create st_ordered_for
this.st_attachment_folder_title=create st_attachment_folder_title
this.st_ordered_by=create st_ordered_by
this.st_7=create st_7
this.st_context_object_title=create st_context_object_title
this.st_object_description_title=create st_object_description_title
this.st_object_description=create st_object_description
this.st_context_object=create st_context_object
this.st_1=create st_1
this.st_2=create st_2
this.st_4=create st_4
this.st_3=create st_3
this.cb_cancel=create cb_cancel
this.cb_forward=create cb_forward
this.cb_nothing=create cb_nothing
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.st_created
this.Control[iCurrent+3]=this.st_created_title
this.Control[iCurrent+4]=this.st_title
this.Control[iCurrent+5]=this.st_service
this.Control[iCurrent+6]=this.st_extension_title
this.Control[iCurrent+7]=this.st_description
this.Control[iCurrent+8]=this.st_attachment_type_title
this.Control[iCurrent+9]=this.st_ordered_for
this.Control[iCurrent+10]=this.st_attachment_folder_title
this.Control[iCurrent+11]=this.st_ordered_by
this.Control[iCurrent+12]=this.st_7
this.Control[iCurrent+13]=this.st_context_object_title
this.Control[iCurrent+14]=this.st_object_description_title
this.Control[iCurrent+15]=this.st_object_description
this.Control[iCurrent+16]=this.st_context_object
this.Control[iCurrent+17]=this.st_1
this.Control[iCurrent+18]=this.st_2
this.Control[iCurrent+19]=this.st_4
this.Control[iCurrent+20]=this.st_3
this.Control[iCurrent+21]=this.cb_cancel
this.Control[iCurrent+22]=this.cb_forward
this.Control[iCurrent+23]=this.cb_nothing
end on

on w_service_exception.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.st_created)
destroy(this.st_created_title)
destroy(this.st_title)
destroy(this.st_service)
destroy(this.st_extension_title)
destroy(this.st_description)
destroy(this.st_attachment_type_title)
destroy(this.st_ordered_for)
destroy(this.st_attachment_folder_title)
destroy(this.st_ordered_by)
destroy(this.st_7)
destroy(this.st_context_object_title)
destroy(this.st_object_description_title)
destroy(this.st_object_description)
destroy(this.st_context_object)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.cb_cancel)
destroy(this.cb_forward)
destroy(this.cb_nothing)
end on

event open;call super::open;
service = message.powerobjectparm

if not isnull(current_patient) then
	title = current_patient.id_line()
end if

st_description.text = service.description
st_service.text = datalist.service_description(service.service)

st_ordered_by.text = user_list.user_full_name(service.ordered_by)
st_ordered_for.text = user_list.user_full_name(service.ordered_for)
st_ordered_by.backcolor = user_list.user_color(service.ordered_by)
st_ordered_for.backcolor = user_list.user_color(service.ordered_for)

st_created.text = string(service.created)


st_context_object.text = wordcap(service.context_object)
st_object_description.text = service.context_description






end event

type pb_epro_help from w_window_base`pb_epro_help within w_service_exception
integer x = 2670
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_service_exception
integer x = 32
integer y = 1472
end type

type cb_ok from commandbutton within w_service_exception
integer x = 1568
integer y = 1564
integer width = 608
integer height = 104
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Perform Service"
end type

event clicked;closewithreturn(parent, 1)

end event

type st_created from statictext within w_service_exception
integer x = 896
integer y = 732
integer width = 818
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_created_title from statictext within w_service_exception
integer x = 274
integer y = 732
integer width = 599
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Date Ordered:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_title from statictext within w_service_exception
integer width = 2921
integer height = 120
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Service Exception"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_service from statictext within w_service_exception
integer x = 896
integer y = 628
integer width = 818
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_extension_title from statictext within w_service_exception
integer x = 265
integer y = 628
integer width = 608
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Type of Service:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_description from statictext within w_service_exception
integer x = 896
integer y = 448
integer width = 1605
integer height = 152
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_attachment_type_title from statictext within w_service_exception
integer x = 485
integer y = 448
integer width = 389
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Description:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_ordered_for from statictext within w_service_exception
integer x = 896
integer y = 940
integer width = 818
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_attachment_folder_title from statictext within w_service_exception
integer x = 379
integer y = 940
integer width = 494
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Ordered For:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_ordered_by from statictext within w_service_exception
integer x = 896
integer y = 836
integer width = 818
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_7 from statictext within w_service_exception
integer x = 379
integer y = 836
integer width = 494
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Ordered By:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_context_object_title from statictext within w_service_exception
integer x = 389
integer y = 1040
integer width = 485
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Context:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_object_description_title from statictext within w_service_exception
integer x = 274
integer y = 1144
integer width = 599
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Context Description:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_object_description from statictext within w_service_exception
integer x = 896
integer y = 1148
integer width = 1605
integer height = 152
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_context_object from statictext within w_service_exception
integer x = 896
integer y = 1044
integer width = 818
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_1 from statictext within w_service_exception
integer x = 215
integer y = 180
integer width = 2491
integer height = 96
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "EncounterPRO was unable to determine who this service should go to."
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_service_exception
integer x = 631
integer y = 1424
integer width = 1673
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
string text = "Please select one of the following options:"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_service_exception
integer x = 256
integer y = 372
integer width = 2341
integer height = 988
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean border = true
boolean focusrectangle = false
end type

type st_3 from statictext within w_service_exception
integer x = 1088
integer y = 300
integer width = 745
integer height = 84
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Service Details"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_service_exception
integer x = 87
integer y = 1564
integer width = 603
integer height = 104
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel Service"
end type

event clicked;string ls_status
str_popup_return popup_return
datetime ldt_progress_date_time
string ls_message
str_popup popup
long ll_choice

setnull(ldt_progress_date_time)

ls_message = ""
if not isnull(service.treatment) then
	if isnull(service.treatment.treatment_status) or upper(service.treatment.treatment_status) = "OPEN" then
		ls_message = "This service is associated with an open treatment (" + st_object_description.text + ").  Cancelling the service may close or cancel the treatment depending on the workflow settings.  "
	end if
end if
ls_message += "Are you sure you want to cancel this service?"

openwithparm(w_pop_yes_no, "Are you sure you want to cancel this service?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

ls_status = "CANCELLED"
sqlca.sp_complete_workplan_item( &
		service.patient_workplan_item_id, &
		current_user.user_id, &
		ls_status, &
		ldt_progress_date_time, &
		current_scribe.user_id)
if not tf_check() then return

closewithreturn(parent, 0)

end event

type cb_forward from commandbutton within w_service_exception
integer x = 773
integer y = 1564
integer width = 713
integer height = 104
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Forward Service To..."
end type

event clicked;u_user luo_user
datetime ldt_null

setnull(ldt_null)

luo_user = user_list.pick_user( true, false, false)
if isnull(luo_user) then return


sqlca.sp_set_workplan_item_progress(service.patient_workplan_item_id, &
												luo_user.user_id, &
												"Change Owner", &
												ldt_null, &
												current_scribe.user_id, &
												gnv_app.computer_id)
if not tf_check() then return

closewithreturn(parent, 0)

end event

type cb_nothing from commandbutton within w_service_exception
integer x = 2258
integer y = 1564
integer width = 539
integer height = 104
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Do Nothing"
end type

event clicked;closewithreturn(parent, 0)

end event

