$PBExportHeader$u_tabpage_assessment_acuteness.sru
forward
global type u_tabpage_assessment_acuteness from u_tabpage
end type
type st_1 from statictext within u_tabpage_assessment_acuteness
end type
type st_acuteness from statictext within u_tabpage_assessment_acuteness
end type
type st_acuteness_title from statictext within u_tabpage_assessment_acuteness
end type
type st_auto_close_unit_title from statictext within u_tabpage_assessment_acuteness
end type
type st_auto_close_interval_unit from statictext within u_tabpage_assessment_acuteness
end type
type st_auto_close_amount_title from statictext within u_tabpage_assessment_acuteness
end type
type st_auto_close_interval_amount from statictext within u_tabpage_assessment_acuteness
end type
type st_auto_close_delay from u_st_radio_autoclose_yesno within u_tabpage_assessment_acuteness
end type
type st_no from u_st_radio_autoclose_yesno within u_tabpage_assessment_acuteness
end type
type st_yes from u_st_radio_autoclose_yesno within u_tabpage_assessment_acuteness
end type
end forward

global type u_tabpage_assessment_acuteness from u_tabpage
integer width = 2779
integer height = 1284
st_1 st_1
st_acuteness st_acuteness
st_acuteness_title st_acuteness_title
st_auto_close_unit_title st_auto_close_unit_title
st_auto_close_interval_unit st_auto_close_interval_unit
st_auto_close_amount_title st_auto_close_amount_title
st_auto_close_interval_amount st_auto_close_interval_amount
st_auto_close_delay st_auto_close_delay
st_no st_no
st_yes st_yes
end type
global u_tabpage_assessment_acuteness u_tabpage_assessment_acuteness

type variables
boolean allow_editing

string assessment_id

// Fields managed on this tab
string auto_close
integer auto_close_interval_amount
string auto_close_interval_unit
string acuteness

end variables

forward prototypes
public function integer initialize ()
end prototypes

public function integer initialize ();string ls_temp
integer li_default_interval
string ls_default_interval_unit
string ls_left
string ls_right
u_unit luo_unit

if isnull(acuteness) or len(acuteness) = 0 then 
	st_acuteness.text = ""
else
	st_acuteness.text = acuteness
end if

// If null, initialize interval as configured
ls_temp = datalist.get_preference("PREFERENCES", "assessment_auto_close_interval")
if isnull(ls_temp) then
	li_default_interval = 30
	ls_default_interval_unit = "DAY"
else
	f_split_string(ls_temp, " ", ls_left, ls_right)
	li_default_interval = integer(trim(ls_left))
	if isnull(li_default_interval) or li_default_interval <= 0 then li_default_interval = 30
	
	CHOOSE CASE upper(left(trim(ls_right), 1))
		CASE "M"
			ls_default_interval_unit = "MONTH"
		CASE "Y"
			ls_default_interval_unit = "YEAR"
		CASE ELSE
			ls_default_interval_unit = "DAY"
	END CHOOSE
end if

if isnull(auto_close_interval_amount) then auto_close_interval_amount = li_default_interval
st_auto_close_interval_amount.text = string(auto_close_interval_amount)

if isnull(auto_close_interval_unit) then auto_close_interval_unit = ls_default_interval_unit
luo_unit = unit_list.find_unit(auto_close_interval_unit)
if isnull(luo_unit) then
	auto_close_interval_unit = "DAY"
	st_auto_close_interval_unit.text = "Days"
else
	st_auto_close_interval_unit.text = luo_unit.description + "s"
end if

if auto_close = "Y" then
	st_yes.triggerevent("clicked")
elseif auto_close = "D" then
	st_auto_close_delay.triggerevent("clicked")
else
	st_no.triggerevent("clicked")
end if

if NOT allow_editing then
	st_auto_close_interval_amount.enabled = false
	st_auto_close_interval_unit.enabled = false	
	st_auto_close_delay.enabled = false
	st_yes.enabled = false
	st_no.enabled = false
	st_acuteness.enabled = false
end if

return 1


end function

on u_tabpage_assessment_acuteness.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_acuteness=create st_acuteness
this.st_acuteness_title=create st_acuteness_title
this.st_auto_close_unit_title=create st_auto_close_unit_title
this.st_auto_close_interval_unit=create st_auto_close_interval_unit
this.st_auto_close_amount_title=create st_auto_close_amount_title
this.st_auto_close_interval_amount=create st_auto_close_interval_amount
this.st_auto_close_delay=create st_auto_close_delay
this.st_no=create st_no
this.st_yes=create st_yes
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_acuteness
this.Control[iCurrent+3]=this.st_acuteness_title
this.Control[iCurrent+4]=this.st_auto_close_unit_title
this.Control[iCurrent+5]=this.st_auto_close_interval_unit
this.Control[iCurrent+6]=this.st_auto_close_amount_title
this.Control[iCurrent+7]=this.st_auto_close_interval_amount
this.Control[iCurrent+8]=this.st_auto_close_delay
this.Control[iCurrent+9]=this.st_no
this.Control[iCurrent+10]=this.st_yes
end on

on u_tabpage_assessment_acuteness.destroy
call super::destroy
destroy(this.st_1)
destroy(this.st_acuteness)
destroy(this.st_acuteness_title)
destroy(this.st_auto_close_unit_title)
destroy(this.st_auto_close_interval_unit)
destroy(this.st_auto_close_amount_title)
destroy(this.st_auto_close_interval_amount)
destroy(this.st_auto_close_delay)
destroy(this.st_no)
destroy(this.st_yes)
end on

type st_1 from statictext within u_tabpage_assessment_acuteness
integer x = 722
integer y = 448
integer width = 992
integer height = 116
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = COLOR_BACKGROUND
string text = "Auto Close Rule"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_acuteness from statictext within u_tabpage_assessment_acuteness
integer x = 887
integer y = 220
integer width = 658
integer height = 104
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_null
integer li_sts

setnull(ls_null)

// get the service type
popup.dataobject = "dw_domain_notranslate_list"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = "Acuteness"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

acuteness = popup_return.items[1]
text = acuteness


end event

type st_acuteness_title from statictext within u_tabpage_assessment_acuteness
integer x = 416
integer y = 236
integer width = 439
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Acute/Chronic:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_auto_close_unit_title from statictext within u_tabpage_assessment_acuteness
integer x = 1957
integer y = 744
integer width = 466
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Unit"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_auto_close_interval_unit from statictext within u_tabpage_assessment_acuteness
integer x = 1957
integer y = 820
integer width = 466
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
integer li_index

popup.data_row_count = 3
popup.items[1] = "Days"
popup.items[2] = "Months"
popup.items[3] = "Years"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

li_index = popup_return.item_indexes[1]
if li_index = 1 then
	auto_close_interval_unit = "DAY"
	text = "Days"
elseif li_index = 2 then
	auto_close_interval_unit = "MONTH"
	text = "Months"
else
	auto_close_interval_unit = "YEAR"
	text = "Years"
end if




end event

type st_auto_close_amount_title from statictext within u_tabpage_assessment_acuteness
integer x = 1664
integer y = 744
integer width = 247
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Amount"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_auto_close_interval_amount from statictext within u_tabpage_assessment_acuteness
integer x = 1669
integer y = 820
integer width = 247
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.realitem = real(auto_close_interval_amount)
openwithparm(w_number, popup)
popup_return = message.powerobjectparm
if popup_return.item <> "OK" then return

auto_close_interval_amount = integer(popup_return.realitem)
text = string(auto_close_interval_amount)



end event

type st_auto_close_delay from u_st_radio_autoclose_yesno within u_tabpage_assessment_acuteness
integer x = 914
integer y = 820
integer width = 626
integer height = 92
string text = "After Interval"
end type

event clicked;call super::clicked;auto_close = "D"

st_auto_close_amount_title.visible = true
st_auto_close_unit_title.visible = true
st_auto_close_interval_amount.visible = true
st_auto_close_interval_unit.visible = true

end event

type st_no from u_st_radio_autoclose_yesno within u_tabpage_assessment_acuteness
integer x = 914
integer y = 572
integer width = 626
integer height = 92
integer taborder = 50
boolean bringtotop = true
string text = "None"
end type

event clicked;call super::clicked;auto_close = "N"

st_auto_close_amount_title.visible = false
st_auto_close_unit_title.visible = false
st_auto_close_interval_amount.visible = false
st_auto_close_interval_unit.visible = false

end event

type st_yes from u_st_radio_autoclose_yesno within u_tabpage_assessment_acuteness
integer x = 914
integer y = 696
integer width = 626
integer height = 92
integer taborder = 40
string text = "End of Encounter"
end type

event clicked;call super::clicked;auto_close = "Y"

st_auto_close_amount_title.visible = false
st_auto_close_unit_title.visible = false
st_auto_close_interval_amount.visible = false
st_auto_close_interval_unit.visible = false

end event

