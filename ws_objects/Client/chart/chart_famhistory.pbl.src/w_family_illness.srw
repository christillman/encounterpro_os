$PBExportHeader$w_family_illness.srw
forward
global type w_family_illness from w_window_base
end type
type st_relation from statictext within w_family_illness
end type
type st_2 from statictext within w_family_illness
end type
type st_3 from statictext within w_family_illness
end type
type st_1 from statictext within w_family_illness
end type
type pb_done from u_picture_button within w_family_illness
end type
type pb_cancel from u_picture_button within w_family_illness
end type
type st_name from statictext within w_family_illness
end type
type st_illness from statictext within w_family_illness
end type
type st_4 from statictext within w_family_illness
end type
type sle_age from singlelineedit within w_family_illness
end type
type st_5 from statictext within w_family_illness
end type
type cb_pick_assessment from commandbutton within w_family_illness
end type
type pb_1 from u_pb_help_button within w_family_illness
end type
end forward

global type w_family_illness from w_window_base
integer x = 379
integer y = 236
integer width = 2112
integer height = 1304
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_relation st_relation
st_2 st_2
st_3 st_3
st_1 st_1
pb_done pb_done
pb_cancel pb_cancel
st_name st_name
st_illness st_illness
st_4 st_4
sle_age sle_age
st_5 st_5
cb_pick_assessment cb_pick_assessment
pb_1 pb_1
end type
global w_family_illness w_family_illness

type variables
long family_history_sequence
string assessment_id

end variables

forward prototypes
public function integer load_relative (long pl_family_history_sequence)
end prototypes

public function integer load_relative (long pl_family_history_sequence);string ls_relation
string ls_name

SELECT relation,   
       name
INTO :ls_relation,
     :ls_name
FROM p_Family_History  
WHERE cpr_id = :current_patient.cpr_id
AND family_history_sequence = :pl_family_history_sequence;
if not tf_check() then return -1

st_relation.text = ls_relation
st_name.text = ls_name

return 1

end function

on w_family_illness.create
int iCurrent
call super::create
this.st_relation=create st_relation
this.st_2=create st_2
this.st_3=create st_3
this.st_1=create st_1
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.st_name=create st_name
this.st_illness=create st_illness
this.st_4=create st_4
this.sle_age=create sle_age
this.st_5=create st_5
this.cb_pick_assessment=create cb_pick_assessment
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_relation
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.pb_done
this.Control[iCurrent+6]=this.pb_cancel
this.Control[iCurrent+7]=this.st_name
this.Control[iCurrent+8]=this.st_illness
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.sle_age
this.Control[iCurrent+11]=this.st_5
this.Control[iCurrent+12]=this.cb_pick_assessment
this.Control[iCurrent+13]=this.pb_1
end on

on w_family_illness.destroy
call super::destroy
destroy(this.st_relation)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_1)
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.st_name)
destroy(this.st_illness)
destroy(this.st_4)
destroy(this.sle_age)
destroy(this.st_5)
destroy(this.cb_pick_assessment)
destroy(this.pb_1)
end on

event open;call super::open;str_popup popup
long ll_family_history_sequence
integer li_sts

popup = message.powerobjectparm
if popup.data_row_count <> 1 then
	log.log(this, "w_family_illness:open", "Invalid parameters", 4)
	close(this)
	return
end if
	
ll_family_history_sequence = long(popup.items[1])
if isnull(ll_family_history_sequence) or ll_family_history_sequence <= 0 then
	log.log(this, "w_family_illness:open", "invalid family_history_sequence", 4)
	close(this)
	return
end if

li_sts = load_relative(ll_family_history_sequence)
if li_sts <= 0 then
	close(this)
	return
end if

end event

type pb_epro_help from w_window_base`pb_epro_help within w_family_illness
end type

type st_relation from statictext within w_family_illness
integer x = 576
integer y = 472
integer width = 1152
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_domain_item_nodesc_list"
popup.datacolumn = 3
popup.displaycolumn = 3
popup.argument_count = 1
popup.argument[1] = "RELATION"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm

if popup_return.item_count = 1 then
	text = popup_return.items[1]
end if

end event

type st_2 from statictext within w_family_illness
integer x = 256
integer y = 484
integer width = 274
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Relation:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_family_illness
integer x = 256
integer y = 296
integer width = 274
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Name:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_family_illness
integer width = 2112
integer height = 160
boolean bringtotop = true
integer textsize = -24
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Family Illness"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_done from u_picture_button within w_family_illness
integer x = 1797
integer y = 1040
integer taborder = 0
boolean default = true
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

if isnull(assessment_id) then
	openwithparm(w_pop_message, "You must specify an illness")
	return
end if

popup_return.item_count = 2
popup_return.items[1] = assessment_id
popup_return.items[2] = string(integer(sle_age.text))

closewithreturn(parent, popup_return)

end event

type pb_cancel from u_picture_button within w_family_illness
integer x = 73
integer y = 1040
integer taborder = 0
boolean bringtotop = true
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type st_name from statictext within w_family_illness
integer x = 576
integer y = 280
integer width = 1152
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_illness from statictext within w_family_illness
integer x = 576
integer y = 664
integer width = 1152
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_domain_item_nodesc_list"
popup.datacolumn = 3
popup.displaycolumn = 3
popup.argument_count = 1
popup.argument[1] = "RELATION"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm

if popup_return.item_count = 1 then
	text = popup_return.items[1]
end if

end event

type st_4 from statictext within w_family_illness
integer x = 256
integer y = 676
integer width = 274
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Illness:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_age from singlelineedit within w_family_illness
integer x = 576
integer y = 856
integer width = 251
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_5 from statictext within w_family_illness
integer x = 256
integer y = 868
integer width = 274
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Age:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_pick_assessment from commandbutton within w_family_illness
integer x = 1765
integer y = 660
integer width = 174
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ". . ."
end type

event clicked;string ls_assessment_id
str_popup popup

popup.data_row_count = 2
popup.items[1] = "SICK"
popup.items[2] = "FMHST|FAMILLNESS"
openwithparm(w_find_assessment, popup)
ls_assessment_id = message.stringparm
if isnull(ls_assessment_id) or trim(ls_assessment_id) = "" then return

assessment_id = ls_assessment_id
st_illness.text = datalist.assessment_description(ls_assessment_id)


end event

type pb_1 from u_pb_help_button within w_family_illness
integer x = 960
integer y = 1100
integer taborder = 20
boolean bringtotop = true
end type

