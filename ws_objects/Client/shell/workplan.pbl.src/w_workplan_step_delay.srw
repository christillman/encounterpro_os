$PBExportHeader$w_workplan_step_delay.srw
forward
global type w_workplan_step_delay from w_window_base
end type
type pb_done from u_picture_button within w_workplan_step_delay
end type
type pb_cancel from u_picture_button within w_workplan_step_delay
end type
type st_title from statictext within w_workplan_step_delay
end type
type st_amount_title from statictext within w_workplan_step_delay
end type
type st_unit_title from statictext within w_workplan_step_delay
end type
type st_delay_from_flag_title from statictext within w_workplan_step_delay
end type
type st_amount from statictext within w_workplan_step_delay
end type
type st_unit from statictext within w_workplan_step_delay
end type
type st_delay_from_flag from statictext within w_workplan_step_delay
end type
type st_delay_title from statictext within w_workplan_step_delay
end type
type pb_1 from u_pb_help_button within w_workplan_step_delay
end type
end forward

global type w_workplan_step_delay from w_window_base
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
st_delay_from_flag_title st_delay_from_flag_title
st_amount st_amount
st_unit st_unit
st_delay_from_flag st_delay_from_flag
st_delay_title st_delay_title
pb_1 pb_1
end type
global w_workplan_step_delay w_workplan_step_delay

type variables
long step_delay
string step_delay_unit
string delay_from_flag

u_unit delay_unit

end variables

on w_workplan_step_delay.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.st_title=create st_title
this.st_amount_title=create st_amount_title
this.st_unit_title=create st_unit_title
this.st_delay_from_flag_title=create st_delay_from_flag_title
this.st_amount=create st_amount
this.st_unit=create st_unit
this.st_delay_from_flag=create st_delay_from_flag
this.st_delay_title=create st_delay_title
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.st_amount_title
this.Control[iCurrent+5]=this.st_unit_title
this.Control[iCurrent+6]=this.st_delay_from_flag_title
this.Control[iCurrent+7]=this.st_amount
this.Control[iCurrent+8]=this.st_unit
this.Control[iCurrent+9]=this.st_delay_from_flag
this.Control[iCurrent+10]=this.st_delay_title
this.Control[iCurrent+11]=this.pb_1
end on

on w_workplan_step_delay.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.st_title)
destroy(this.st_amount_title)
destroy(this.st_unit_title)
destroy(this.st_delay_from_flag_title)
destroy(this.st_amount)
destroy(this.st_unit)
destroy(this.st_delay_from_flag)
destroy(this.st_delay_title)
destroy(this.pb_1)
end on

event open;call super::open;str_popup popup
real lr_amount

popup = message.powerobjectparm

st_title.text = popup.title

if popup.data_row_count <> 3 then
	log.log(this, "w_workplan_step_delay:open", "Invalid Parameters", 4)
	close(this)
	return
end if

step_delay = long(popup.items[1])
step_delay_unit = popup.items[2]
delay_from_flag = popup.items[3]


if isnull(step_delay) then
	st_amount.text = "0"
else
	st_amount.text = string(step_delay)
end if

if isnull(step_delay_unit) then
	setnull(delay_unit)
	st_unit.text = "N/A"
else
	delay_unit = unit_list.find_unit(step_delay_unit)
	if isnull(delay_unit) then
		st_unit.text = "N/A"
		setnull(step_delay_unit)
	else
		lr_amount = real(step_delay)
		st_unit.text = delay_unit.pretty_unit(lr_amount)
	end if
end if

if delay_from_flag = "S" then
	st_delay_from_flag.text = "Start of Step"
elseif delay_from_flag = "W" then
	st_delay_from_flag.text = "Start of Workplan"
else
	st_delay_from_flag.text = "N/A"
end if






end event

type pb_done from u_picture_button within w_workplan_step_delay
int X=1897
int Y=1008
int TabOrder=10
string PictureName="button26.bmp"
string DisabledName="b_push26.bmp"
end type

event clicked;call super::clicked;long ll_row
str_popup_return popup_return


popup_return.item_count = 3

popup_return.items[1] = string(step_delay)
popup_return.descriptions[1] = st_amount.text
popup_return.items[2] = step_delay_unit
popup_return.descriptions[2] = st_unit.text
popup_return.items[3] = delay_from_flag
popup_return.descriptions[3] = st_delay_from_flag.text

	
closewithreturn(parent, popup_return)



end event

type pb_cancel from u_picture_button within w_workplan_step_delay
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

type st_title from statictext within w_workplan_step_delay
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

type st_amount_title from statictext within w_workplan_step_delay
int X=658
int Y=320
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

type st_unit_title from statictext within w_workplan_step_delay
int X=1074
int Y=320
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

type st_delay_from_flag_title from statictext within w_workplan_step_delay
int X=690
int Y=692
int Width=814
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="Delay From"
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

type st_amount from statictext within w_workplan_step_delay
int X=658
int Y=400
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

popup.realitem = real(step_delay)

openwithparm(w_number, popup)
popup_return = message.powerobjectparm
if popup_return.item = "CANCEL" then return

if isnull(popup_return.realitem) then
	setnull(step_delay)
	text = "0"
else
	step_delay = long(popup_return.realitem)
	text = string(step_delay)
	if step_delay = 0 then setnull(step_delay)
end if 

if isnull(delay_unit) then
	st_unit.text = "N/A"
	setnull(step_delay_unit)
else
	lr_amount = real(step_delay)
	st_unit.text = delay_unit.pretty_unit(lr_amount)
end if

end event

type st_unit from statictext within w_workplan_step_delay
int X=1074
int Y=400
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
		step_delay_unit = "MINUTE"
	CASE"Hours"
		step_delay_unit = "HOUR"
	CASE"Days"
		step_delay_unit = "DAY"
	CASE"Months"
		step_delay_unit = "MONTH"
	CASE"Years"
		step_delay_unit = "YEAR"
	CASE ELSE
		setnull(step_delay_unit)
		text = "N/A"
END CHOOSE

delay_unit = unit_list.find_unit(step_delay_unit)

if isnull(delay_unit) then
	st_unit.text = "N/A"
	setnull(step_delay_unit)
else
	lr_amount = real(step_delay)
	st_unit.text = delay_unit.pretty_unit(lr_amount)
	if isnull(delay_from_flag) then
		delay_from_flag = "S"
		st_delay_from_flag.text = "Start of Step"
	end if
end if

end event

type st_delay_from_flag from statictext within w_workplan_step_delay
int X=690
int Y=776
int Width=814
int Height=112
boolean BringToTop=true
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="Start of Step"
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

popup.data_row_count = 2
popup.items[1] = "Start of Step"
popup.items[2] = "Start of Workplan"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

text = popup_return.items[1]

CHOOSE CASE popup_return.items[1]
	CASE"Start of Step"
		delay_from_flag = "S"
	CASE"Start of Workplan"
		delay_from_flag = "W"
	CASE ELSE
		setnull(delay_from_flag)
		text = "N/A"
END CHOOSE


end event

type st_delay_title from statictext within w_workplan_step_delay
int X=923
int Y=200
int Width=261
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="Delay"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=33538240
int TextSize=-12
int Weight=700
string FaceName="Arial"
boolean Underline=true
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type pb_1 from u_pb_help_button within w_workplan_step_delay
int X=1632
int Y=1120
int TabOrder=20
boolean BringToTop=true
end type

