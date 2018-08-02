$PBExportHeader$w_workplan_item_timeout.srw
forward
global type w_workplan_item_timeout from w_window_base
end type
type pb_done from u_picture_button within w_workplan_item_timeout
end type
type pb_cancel from u_picture_button within w_workplan_item_timeout
end type
type st_title from statictext within w_workplan_item_timeout
end type
type st_amount_title from statictext within w_workplan_item_timeout
end type
type st_unit_title from statictext within w_workplan_item_timeout
end type
type st_escalation_time from statictext within w_workplan_item_timeout
end type
type st_escalation_unit from statictext within w_workplan_item_timeout
end type
type st_delay_title from statictext within w_workplan_item_timeout
end type
type pb_1 from u_pb_help_button within w_workplan_item_timeout
end type
type st_xamount_title from statictext within w_workplan_item_timeout
end type
type st_xunit_title from statictext within w_workplan_item_timeout
end type
type st_expiration_time from statictext within w_workplan_item_timeout
end type
type st_expiration_unit from statictext within w_workplan_item_timeout
end type
type st_expiration_title from statictext within w_workplan_item_timeout
end type
end forward

global type w_workplan_item_timeout from w_window_base
int X=347
int Y=272
int Width=2213
int Height=1280
WindowType WindowType=response!
boolean TitleBar=false
long BackColor=33538240
boolean ControlMenu=false
boolean MinBox=false
boolean MaxBox=false
boolean Resizable=false
pb_done pb_done
pb_cancel pb_cancel
st_title st_title
st_amount_title st_amount_title
st_unit_title st_unit_title
st_escalation_time st_escalation_time
st_escalation_unit st_escalation_unit
st_delay_title st_delay_title
pb_1 pb_1
st_xamount_title st_xamount_title
st_xunit_title st_xunit_title
st_expiration_time st_expiration_time
st_expiration_unit st_expiration_unit
st_expiration_title st_expiration_title
end type
global w_workplan_item_timeout w_workplan_item_timeout

type variables
long escalation_time
string escalation_unit_id
u_unit escalation_unit

long expiration_time
string expiration_unit_id
u_unit expiration_unit

end variables

on w_workplan_item_timeout.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.st_title=create st_title
this.st_amount_title=create st_amount_title
this.st_unit_title=create st_unit_title
this.st_escalation_time=create st_escalation_time
this.st_escalation_unit=create st_escalation_unit
this.st_delay_title=create st_delay_title
this.pb_1=create pb_1
this.st_xamount_title=create st_xamount_title
this.st_xunit_title=create st_xunit_title
this.st_expiration_time=create st_expiration_time
this.st_expiration_unit=create st_expiration_unit
this.st_expiration_title=create st_expiration_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.st_amount_title
this.Control[iCurrent+5]=this.st_unit_title
this.Control[iCurrent+6]=this.st_escalation_time
this.Control[iCurrent+7]=this.st_escalation_unit
this.Control[iCurrent+8]=this.st_delay_title
this.Control[iCurrent+9]=this.pb_1
this.Control[iCurrent+10]=this.st_xamount_title
this.Control[iCurrent+11]=this.st_xunit_title
this.Control[iCurrent+12]=this.st_expiration_time
this.Control[iCurrent+13]=this.st_expiration_unit
this.Control[iCurrent+14]=this.st_expiration_title
end on

on w_workplan_item_timeout.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.st_title)
destroy(this.st_amount_title)
destroy(this.st_unit_title)
destroy(this.st_escalation_time)
destroy(this.st_escalation_unit)
destroy(this.st_delay_title)
destroy(this.pb_1)
destroy(this.st_xamount_title)
destroy(this.st_xunit_title)
destroy(this.st_expiration_time)
destroy(this.st_expiration_unit)
destroy(this.st_expiration_title)
end on

event open;call super::open;str_popup popup
real lr_amount

popup = message.powerobjectparm

st_title.text = popup.title

if popup.data_row_count <> 4 then
	log.log(this, "w_workplan_item_timeout.open.0009", "Invalid Parameters", 4)
	close(this)
	return
end if

escalation_time = long(popup.items[1])
escalation_unit_id = popup.items[2]

expiration_time = long(popup.items[3])
expiration_unit_id = popup.items[4]

if isnull(escalation_time) then
	st_escalation_time.text = "0"
else
	st_escalation_time.text = string(escalation_time)
end if

if isnull(escalation_unit_id) then
	setnull(escalation_unit)
	st_escalation_unit.text = "N/A"
else
	escalation_unit = unit_list.find_unit(escalation_unit_id)
	if isnull(escalation_unit) then
		st_escalation_unit.text = "N/A"
		setnull(escalation_unit)
	else
		lr_amount = real(escalation_time)
		st_escalation_unit.text = escalation_unit.pretty_unit(lr_amount)
	end if
end if

if isnull(expiration_time) then
	st_expiration_time.text = "0"
else
	st_expiration_time.text = string(expiration_time)
end if

if isnull(expiration_unit_id) then
	setnull(expiration_unit)
	st_expiration_unit.text = "N/A"
else
	expiration_unit = unit_list.find_unit(expiration_unit_id)
	if isnull(expiration_unit) then
		st_expiration_unit.text = "N/A"
		setnull(expiration_unit)
	else
		lr_amount = real(expiration_time)
		st_expiration_unit.text = expiration_unit.pretty_unit(lr_amount)
	end if
end if



end event

type pb_done from u_picture_button within w_workplan_item_timeout
int X=1897
int Y=1008
int TabOrder=10
string PictureName="button26.bmp"
string DisabledName="b_push26.bmp"
end type

event clicked;call super::clicked;long ll_row
str_popup_return popup_return


popup_return.item_count = 4

popup_return.items[1] = string(escalation_time)
popup_return.descriptions[1] = st_escalation_time.text
popup_return.items[2] = escalation_unit_id
popup_return.descriptions[2] = st_escalation_unit.text
popup_return.items[3] = string(expiration_time)
popup_return.descriptions[3] = st_expiration_time.text
popup_return.items[4] = expiration_unit_id
popup_return.descriptions[4] = st_expiration_unit.text

	
closewithreturn(parent, popup_return)



end event

type pb_cancel from u_picture_button within w_workplan_item_timeout
int X=78
int Y=1008
int TabOrder=20
boolean BringToTop=true
string PictureName="button11.bmp"
string DisabledName="b_push11.bmp"
boolean Cancel=true
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)


end event

type st_title from statictext within w_workplan_item_timeout
int Width=2208
int Height=132
boolean Enabled=false
boolean BringToTop=true
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=33538240
int TextSize=-16
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_amount_title from statictext within w_workplan_item_timeout
int X=901
int Y=312
int Width=261
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="Amount"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=33538240
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_unit_title from statictext within w_workplan_item_timeout
int X=1317
int Y=312
int Width=466
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="Unit"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=33538240
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_escalation_time from statictext within w_workplan_item_timeout
int X=901
int Y=392
int Width=261
int Height=112
boolean BringToTop=true
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="99"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;str_popup popup
str_popup_return popup_return
real lr_amount

popup.realitem = real(escalation_time)

openwithparm(w_number, popup)
popup_return = message.powerobjectparm
if popup_return.item = "CANCEL" then return

if isnull(popup_return.realitem) then
	setnull(escalation_time)
	text = "0"
else
	escalation_time = long(popup_return.realitem)
	text = string(escalation_time)
	if escalation_time = 0 then setnull(escalation_time)
end if 

if isnull(escalation_unit) then
	st_escalation_unit.text = "N/A"
	setnull(escalation_unit_id)
else
	lr_amount = real(escalation_time)
	st_escalation_unit.text = escalation_unit.pretty_unit(lr_amount)
end if

end event

type st_escalation_unit from statictext within w_workplan_item_timeout
int X=1317
int Y=392
int Width=466
int Height=112
boolean BringToTop=true
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="Days"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;str_popup popup
str_popup_return popup_return
real lr_amount

popup.data_row_count = 5
popup.items[1] = "Minutes"
popup.items[2] = "Hours"
popup.items[3] = "Days"
popup.items[4] = "Months"
popup.items[5] = "Years"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

text = popup_return.items[1]

CHOOSE CASE popup_return.items[1]
	CASE"Minutes"
		escalation_unit_id = "MINUTE"
	CASE"Hours"
		escalation_unit_id = "HOUR"
	CASE"Days"
		escalation_unit_id = "DAY"
	CASE"Months"
		escalation_unit_id = "MONTH"
	CASE"Years"
		escalation_unit_id = "YEAR"
	CASE ELSE
		setnull(escalation_unit_id)
		text = "N/A"
END CHOOSE

escalation_unit = unit_list.find_unit(escalation_unit_id)

if isnull(escalation_unit) then
	st_escalation_unit.text = "N/A"
	setnull(escalation_unit_id)
else
	lr_amount = real(escalation_time)
	st_escalation_unit.text = escalation_unit.pretty_unit(lr_amount)
end if

end event

type st_delay_title from statictext within w_workplan_item_timeout
int X=370
int Y=408
int Width=411
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="Escalation:"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=33538240
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type pb_1 from u_pb_help_button within w_workplan_item_timeout
int X=1632
int Y=1120
int TabOrder=30
boolean BringToTop=true
end type

type st_xamount_title from statictext within w_workplan_item_timeout
int X=901
int Y=624
int Width=261
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="Amount"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=33538240
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_xunit_title from statictext within w_workplan_item_timeout
int X=1317
int Y=624
int Width=466
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="Unit"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=33538240
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_expiration_time from statictext within w_workplan_item_timeout
int X=901
int Y=704
int Width=261
int Height=112
boolean BringToTop=true
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="99"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;str_popup popup
str_popup_return popup_return
real lr_amount

popup.realitem = real(expiration_time)

openwithparm(w_number, popup)
popup_return = message.powerobjectparm
if popup_return.item = "CANCEL" then return

if isnull(popup_return.realitem) then
	setnull(expiration_time)
	text = "0"
else
	expiration_time = long(popup_return.realitem)
	text = string(expiration_time)
	if expiration_time = 0 then setnull(expiration_time)
end if 

if isnull(expiration_unit) then
	st_expiration_unit.text = "N/A"
	setnull(expiration_unit_id)
else
	lr_amount = real(expiration_time)
	st_expiration_unit.text = expiration_unit.pretty_unit(lr_amount)
end if

end event

type st_expiration_unit from statictext within w_workplan_item_timeout
int X=1317
int Y=704
int Width=466
int Height=112
boolean BringToTop=true
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="Days"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;str_popup popup
str_popup_return popup_return
real lr_amount

popup.data_row_count = 5
popup.items[1] = "Minutes"
popup.items[2] = "Hours"
popup.items[3] = "Days"
popup.items[4] = "Months"
popup.items[5] = "Years"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

text = popup_return.items[1]

CHOOSE CASE popup_return.items[1]
	CASE"Minutes"
		expiration_unit_id = "MINUTE"
	CASE"Hours"
		expiration_unit_id = "HOUR"
	CASE"Days"
		expiration_unit_id = "DAY"
	CASE"Months"
		expiration_unit_id = "MONTH"
	CASE"Years"
		expiration_unit_id = "YEAR"
	CASE ELSE
		setnull(expiration_unit_id)
		text = "N/A"
END CHOOSE

expiration_unit = unit_list.find_unit(expiration_unit_id)

if isnull(expiration_unit) then
	st_expiration_unit.text = "N/A"
	setnull(expiration_unit_id)
else
	lr_amount = real(expiration_time)
	st_expiration_unit.text = expiration_unit.pretty_unit(lr_amount)
end if

end event

type st_expiration_title from statictext within w_workplan_item_timeout
int X=370
int Y=720
int Width=411
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="Expiration:"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=33538240
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

