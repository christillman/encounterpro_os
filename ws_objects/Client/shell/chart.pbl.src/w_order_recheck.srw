$PBExportHeader$w_order_recheck.srw
forward
global type w_order_recheck from window
end type
type st_or2 from statictext within w_order_recheck
end type
type st_or1 from statictext within w_order_recheck
end type
type st_perform_later from statictext within w_order_recheck
end type
type st_perform_now from statictext within w_order_recheck
end type
type st_title from statictext within w_order_recheck
end type
type pb_done from u_picture_button within w_order_recheck
end type
type st_desc from statictext within w_order_recheck
end type
type sle_description from singlelineedit within w_order_recheck
end type
type st_recheck_user from statictext within w_order_recheck
end type
type st_1 from statictext within w_order_recheck
end type
type pb_cancel from u_picture_button within w_order_recheck
end type
end forward

global type w_order_recheck from window
integer x = 174
integer y = 432
integer width = 2505
integer height = 1424
windowtype windowtype = response!
long backcolor = 7191717
st_or2 st_or2
st_or1 st_or1
st_perform_later st_perform_later
st_perform_now st_perform_now
st_title st_title
pb_done pb_done
st_desc st_desc
sle_description sle_description
st_recheck_user st_recheck_user
st_1 st_1
pb_cancel pb_cancel
end type
global w_order_recheck w_order_recheck

type variables
string to_user_id
string mode
string service
string service_description

end variables

on w_order_recheck.create
this.st_or2=create st_or2
this.st_or1=create st_or1
this.st_perform_later=create st_perform_later
this.st_perform_now=create st_perform_now
this.st_title=create st_title
this.pb_done=create pb_done
this.st_desc=create st_desc
this.sle_description=create sle_description
this.st_recheck_user=create st_recheck_user
this.st_1=create st_1
this.pb_cancel=create pb_cancel
this.Control[]={this.st_or2,&
this.st_or1,&
this.st_perform_later,&
this.st_perform_now,&
this.st_title,&
this.pb_done,&
this.st_desc,&
this.sle_description,&
this.st_recheck_user,&
this.st_1,&
this.pb_cancel}
end on

on w_order_recheck.destroy
destroy(this.st_or2)
destroy(this.st_or1)
destroy(this.st_perform_later)
destroy(this.st_perform_now)
destroy(this.st_title)
destroy(this.pb_done)
destroy(this.st_desc)
destroy(this.sle_description)
destroy(this.st_recheck_user)
destroy(this.st_1)
destroy(this.pb_cancel)
end on

event open;call super::open;str_popup popup

if isnull(current_patient.open_encounter) then
	log.log(this, "w_order_recheck:open", "No open encounter", 4)
	close(this)
	return
end if

popup = message.powerobjectparm

if popup.data_row_count <> 2 then
	log.log(this, "w_order_recheck:open", "Invalid Parameters", 4)
	close(this)
	return
end if

service = popup.items[1]
service_description = popup.items[2]

sle_description.text = service_description
st_title.text = "Order " + service_description + " Service"

st_perform_now.backcolor = color_object_selected
mode = "NOW"

sle_description.setfocus()
sle_description.selecttext(1,len(sle_description.text))

end event

type st_or2 from statictext within w_order_recheck
integer x = 1161
integer y = 616
integer width = 165
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "OR"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_or1 from statictext within w_order_recheck
integer x = 1161
integer y = 364
integer width = 165
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "OR"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_perform_later from statictext within w_order_recheck
integer x = 887
integer y = 464
integer width = 718
integer height = 124
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Perform Later"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_recheck_user.backcolor = color_object
st_perform_now.backcolor = color_object
mode = "LATER"

sle_description.setfocus()
sle_description.selecttext(1,len(sle_description.text))

end event

type st_perform_now from statictext within w_order_recheck
integer x = 887
integer y = 212
integer width = 718
integer height = 124
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Perform Now"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_recheck_user.backcolor = color_object
st_perform_later.backcolor = color_object
mode = "NOW"

sle_description.setfocus()
sle_description.selecttext(1,len(sle_description.text))

end event

type st_title from statictext within w_order_recheck
integer width = 2491
integer height = 104
integer textsize = -14
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "Order Recheck Service"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_done from u_picture_button within w_order_recheck
event clicked pbm_bnclicked
event mouse_move pbm_mousemove
integer x = 2130
integer y = 1136
integer taborder = 21
boolean default = true
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;long ll_patient_workplan_item_id
str_popup_return popup_return

CHOOSE CASE mode
	CASE "NOW"
		current_patient.open_encounter.do_service(service)
	CASE "LATER"
		current_patient.open_encounter.order_service(service, sle_description.text, current_user.user_id)
	CASE "FOR"
		if isnull(to_user_id) then 
			openwithparm(w_pop_message, "Please select a user")
			return
		end if
		ll_patient_workplan_item_id = current_patient.open_encounter.order_service(service, sle_description.text, to_user_id)
		if ll_patient_workplan_item_id <= 0 then
			log.log(this, "w_order_recheck.pb_done.clicked:0016", "Error ordering service (" + service + ")", 4)
			return
		end if
END CHOOSE

popup_return.item_count = 1
popup_return.items[1] = string(ll_patient_workplan_item_id)

closewithreturn(parent, popup_return)

end event

on mouse_move;f_cpr_set_msg("Cancel")
end on

type st_desc from statictext within w_order_recheck
integer x = 165
integer y = 920
integer width = 603
integer height = 52
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "Description"
boolean focusrectangle = false
end type

type sle_description from singlelineedit within w_order_recheck
integer x = 155
integer y = 972
integer width = 2176
integer height = 96
integer taborder = 10
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
string text = "Recheck"
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_recheck_user from statictext within w_order_recheck
integer x = 887
integer y = 716
integer width = 718
integer height = 124
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "<None>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string lsa_user_id[]
u_user luo_user


luo_user = user_list.pick_user("ALL")
if isnull(luo_user) then return


text = luo_user.user_short_name
backcolor = luo_user.color
st_perform_now.backcolor = color_object
st_perform_later.backcolor = color_object
mode = "FOR"

to_user_id = luo_user.user_id
sle_description.setfocus()
sle_description.selecttext(1,len(sle_description.text))



end event

type st_1 from statictext within w_order_recheck
integer x = 475
integer y = 744
integer width = 393
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Order For:"
alignment alignment = right!
boolean focusrectangle = false
end type

type pb_cancel from u_picture_button within w_order_recheck
integer x = 114
integer y = 1136
integer taborder = 20
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "button11.bmp"
end type

on mouse_move;f_cpr_set_msg("Cancel")
end on

event clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

