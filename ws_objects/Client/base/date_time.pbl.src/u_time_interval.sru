$PBExportHeader$u_time_interval.sru
forward
global type u_time_interval from UserObject
end type
type st_1 from statictext within u_time_interval
end type
type st_2 from statictext within u_time_interval
end type
type st_3 from statictext within u_time_interval
end type
type st_4 from statictext within u_time_interval
end type
type st_5 from statictext within u_time_interval
end type
type st_6 from statictext within u_time_interval
end type
type st_7 from statictext within u_time_interval
end type
type st_8 from statictext within u_time_interval
end type
type st_9 from statictext within u_time_interval
end type
type st_10 from statictext within u_time_interval
end type
type st_11 from statictext within u_time_interval
end type
type st_12 from statictext within u_time_interval
end type
type st_13 from statictext within u_time_interval
end type
type st_14 from statictext within u_time_interval
end type
type st_15 from statictext within u_time_interval
end type
type st_16 from statictext within u_time_interval
end type
type st_17 from statictext within u_time_interval
end type
type st_18 from statictext within u_time_interval
end type
type st_19 from statictext within u_time_interval
end type
type st_20 from statictext within u_time_interval
end type
type st_days from statictext within u_time_interval
end type
type st_weeks from statictext within u_time_interval
end type
type st_months from statictext within u_time_interval
end type
type st_years from statictext within u_time_interval
end type
type st_30 from statictext within u_time_interval
end type
type st_29 from statictext within u_time_interval
end type
type st_28 from statictext within u_time_interval
end type
type st_27 from statictext within u_time_interval
end type
type st_26 from statictext within u_time_interval
end type
type st_25 from statictext within u_time_interval
end type
type st_24 from statictext within u_time_interval
end type
type st_23 from statictext within u_time_interval
end type
type st_22 from statictext within u_time_interval
end type
type st_21 from statictext within u_time_interval
end type
type cb_clear from commandbutton within u_time_interval
end type
end forward

global type u_time_interval from UserObject
int Width=2194
int Height=1088
long BackColor=COLOR_BACKGROUND
long PictureMaskColor=536870912
long TabTextColor=33554432
long TabBackColor=67108864
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
st_5 st_5
st_6 st_6
st_7 st_7
st_8 st_8
st_9 st_9
st_10 st_10
st_11 st_11
st_12 st_12
st_13 st_13
st_14 st_14
st_15 st_15
st_16 st_16
st_17 st_17
st_18 st_18
st_19 st_19
st_20 st_20
st_days st_days
st_weeks st_weeks
st_months st_months
st_years st_years
st_30 st_30
st_29 st_29
st_28 st_28
st_27 st_27
st_26 st_26
st_25 st_25
st_24 st_24
st_23 st_23
st_22 st_22
st_21 st_21
cb_clear cb_clear
end type
global u_time_interval u_time_interval

type variables
statictext current_number
statictext current_unit

real amount
string unit

end variables

forward prototypes
public function integer set_time (real pr_amount, string ps_unit)
end prototypes

public function integer set_time (real pr_amount, string ps_unit);amount = pr_amount
unit = ps_unit

CHOOSE CASE int(amount)
	CASE 1
		current_number = st_1
		current_number.triggerevent("clicked")
	CASE 2
		current_number = st_2
		current_number.triggerevent("clicked")
	CASE 3
		current_number = st_3
		current_number.triggerevent("clicked")
	CASE 4
		current_number = st_4
		current_number.triggerevent("clicked")
	CASE 5
		current_number = st_5
		current_number.triggerevent("clicked")
	CASE 6
		current_number = st_6
		current_number.triggerevent("clicked")
	CASE 7
		current_number = st_7
		current_number.triggerevent("clicked")
	CASE 8
		current_number = st_8
		current_number.triggerevent("clicked")
	CASE 9
		current_number = st_9
		current_number.triggerevent("clicked")
	CASE 10
		current_number = st_10
		current_number.triggerevent("clicked")
	CASE 11
		current_number = st_11
		current_number.triggerevent("clicked")
	CASE 12
		current_number = st_12
		current_number.triggerevent("clicked")
	CASE 13
		current_number = st_13
		current_number.triggerevent("clicked")
	CASE 14
		current_number = st_14
		current_number.triggerevent("clicked")
	CASE 15
		current_number = st_15
		current_number.triggerevent("clicked")
	CASE 16
		current_number = st_16
		current_number.triggerevent("clicked")
	CASE 17
		current_number = st_17
		current_number.triggerevent("clicked")
	CASE 18
		current_number = st_18
		current_number.triggerevent("clicked")
	CASE 19
		current_number = st_19
		current_number.triggerevent("clicked")
	CASE 20
		current_number = st_20
		current_number.triggerevent("clicked")
	CASE ELSE
		current_number = st_1
		current_number.triggerevent("clicked")
END CHOOSE

CHOOSE CASE unit
	CASE "DAY"
		current_unit = st_days
		current_unit.triggerevent("clicked")
	CASE "WEEK"
		current_unit = st_weeks
		current_unit.triggerevent("clicked")
	CASE "MONTH"
		current_unit = st_months
		current_unit.triggerevent("clicked")
	CASE "YEAR"
		current_unit = st_years
		current_unit.triggerevent("clicked")
	CASE ELSE
		current_unit = st_days
		current_unit.triggerevent("clicked")
END CHOOSE

return 1

end function

on u_time_interval.create
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.st_6=create st_6
this.st_7=create st_7
this.st_8=create st_8
this.st_9=create st_9
this.st_10=create st_10
this.st_11=create st_11
this.st_12=create st_12
this.st_13=create st_13
this.st_14=create st_14
this.st_15=create st_15
this.st_16=create st_16
this.st_17=create st_17
this.st_18=create st_18
this.st_19=create st_19
this.st_20=create st_20
this.st_days=create st_days
this.st_weeks=create st_weeks
this.st_months=create st_months
this.st_years=create st_years
this.st_30=create st_30
this.st_29=create st_29
this.st_28=create st_28
this.st_27=create st_27
this.st_26=create st_26
this.st_25=create st_25
this.st_24=create st_24
this.st_23=create st_23
this.st_22=create st_22
this.st_21=create st_21
this.cb_clear=create cb_clear
this.Control[]={this.st_1,&
this.st_2,&
this.st_3,&
this.st_4,&
this.st_5,&
this.st_6,&
this.st_7,&
this.st_8,&
this.st_9,&
this.st_10,&
this.st_11,&
this.st_12,&
this.st_13,&
this.st_14,&
this.st_15,&
this.st_16,&
this.st_17,&
this.st_18,&
this.st_19,&
this.st_20,&
this.st_days,&
this.st_weeks,&
this.st_months,&
this.st_years,&
this.st_30,&
this.st_29,&
this.st_28,&
this.st_27,&
this.st_26,&
this.st_25,&
this.st_24,&
this.st_23,&
this.st_22,&
this.st_21,&
this.cb_clear}
end on

on u_time_interval.destroy
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.st_7)
destroy(this.st_8)
destroy(this.st_9)
destroy(this.st_10)
destroy(this.st_11)
destroy(this.st_12)
destroy(this.st_13)
destroy(this.st_14)
destroy(this.st_15)
destroy(this.st_16)
destroy(this.st_17)
destroy(this.st_18)
destroy(this.st_19)
destroy(this.st_20)
destroy(this.st_days)
destroy(this.st_weeks)
destroy(this.st_months)
destroy(this.st_years)
destroy(this.st_30)
destroy(this.st_29)
destroy(this.st_28)
destroy(this.st_27)
destroy(this.st_26)
destroy(this.st_25)
destroy(this.st_24)
destroy(this.st_23)
destroy(this.st_22)
destroy(this.st_21)
destroy(this.cb_clear)
end on

type st_1 from statictext within u_time_interval
int X=59
int Y=60
int Width=187
int Height=120
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="1"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_number.backcolor = color_object

backcolor = color_object_selected

current_number = this

amount = 1

end event

type st_2 from statictext within u_time_interval
int X=270
int Y=60
int Width=187
int Height=120
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="2"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_number.backcolor = color_object

backcolor = color_object_selected

current_number = this

amount = 2

end event

type st_3 from statictext within u_time_interval
int X=480
int Y=60
int Width=187
int Height=120
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="3"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_number.backcolor = color_object

backcolor = color_object_selected

current_number = this

amount = 3

end event

type st_4 from statictext within u_time_interval
int X=690
int Y=60
int Width=187
int Height=120
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="4"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_number.backcolor = color_object

backcolor = color_object_selected

current_number = this

amount = 4

end event

type st_5 from statictext within u_time_interval
int X=901
int Y=60
int Width=187
int Height=120
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="5"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_number.backcolor = color_object

backcolor = color_object_selected

current_number = this

amount = 5

end event

type st_6 from statictext within u_time_interval
int X=1111
int Y=60
int Width=187
int Height=120
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="6"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_number.backcolor = color_object

backcolor = color_object_selected

current_number = this

amount = 6

end event

type st_7 from statictext within u_time_interval
int X=1321
int Y=60
int Width=187
int Height=120
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="7"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_number.backcolor = color_object

backcolor = color_object_selected

current_number = this

amount = 7

end event

type st_8 from statictext within u_time_interval
int X=1531
int Y=60
int Width=187
int Height=120
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="8"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_number.backcolor = color_object

backcolor = color_object_selected

current_number = this

amount = 8
end event

type st_9 from statictext within u_time_interval
int X=1742
int Y=60
int Width=187
int Height=120
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="9"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_number.backcolor = color_object

backcolor = color_object_selected

current_number = this

amount = 9

end event

type st_10 from statictext within u_time_interval
int X=1952
int Y=60
int Width=187
int Height=120
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="10"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_number.backcolor = color_object

backcolor = color_object_selected

current_number = this

amount = 10

end event

type st_11 from statictext within u_time_interval
int X=59
int Y=264
int Width=187
int Height=120
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="11"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_number.backcolor = color_object

backcolor = color_object_selected

current_number = this

amount = 11

end event

type st_12 from statictext within u_time_interval
int X=270
int Y=264
int Width=187
int Height=120
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="12"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_number.backcolor = color_object

backcolor = color_object_selected

current_number = this

amount = 12

end event

type st_13 from statictext within u_time_interval
int X=480
int Y=264
int Width=187
int Height=120
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="13"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_number.backcolor = color_object

backcolor = color_object_selected

current_number = this

amount = 13

end event

type st_14 from statictext within u_time_interval
int X=690
int Y=264
int Width=187
int Height=120
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="14"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_number.backcolor = color_object

backcolor = color_object_selected

current_number = this

amount = 14

end event

type st_15 from statictext within u_time_interval
int X=901
int Y=264
int Width=187
int Height=120
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="15"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_number.backcolor = color_object

backcolor = color_object_selected

current_number = this

amount = 15

end event

type st_16 from statictext within u_time_interval
int X=1111
int Y=264
int Width=187
int Height=120
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="16"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_number.backcolor = color_object

backcolor = color_object_selected

current_number = this

amount = 16

end event

type st_17 from statictext within u_time_interval
int X=1321
int Y=264
int Width=187
int Height=120
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="17"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_number.backcolor = color_object

backcolor = color_object_selected

current_number = this

amount = 17

end event

type st_18 from statictext within u_time_interval
int X=1531
int Y=264
int Width=187
int Height=120
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="18"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_number.backcolor = color_object

backcolor = color_object_selected

current_number = this

amount = 18
end event

type st_19 from statictext within u_time_interval
int X=1742
int Y=264
int Width=187
int Height=120
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="19"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_number.backcolor = color_object

backcolor = color_object_selected

current_number = this

amount = 19

end event

type st_20 from statictext within u_time_interval
int X=1952
int Y=264
int Width=187
int Height=120
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="20"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_number.backcolor = color_object

backcolor = color_object_selected

current_number = this

amount = 20

end event

type st_days from statictext within u_time_interval
int X=242
int Y=720
int Width=352
int Height=120
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="Days"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_unit.backcolor = color_object

backcolor = color_object_selected

current_unit = this

unit = "DAY"


end event

type st_weeks from statictext within u_time_interval
int X=695
int Y=720
int Width=352
int Height=120
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="Weeks"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_unit.backcolor = color_object

backcolor = color_object_selected

current_unit = this

unit = "WEEK"


end event

type st_months from statictext within u_time_interval
int X=1147
int Y=720
int Width=352
int Height=120
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="Months"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_unit.backcolor = color_object

backcolor = color_object_selected

current_unit = this

unit = "MONTH"


end event

type st_years from statictext within u_time_interval
int X=1600
int Y=720
int Width=352
int Height=120
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="Years"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_unit.backcolor = color_object

backcolor = color_object_selected

current_unit = this

unit = "YEAR"


end event

type st_30 from statictext within u_time_interval
int X=1952
int Y=468
int Width=187
int Height=120
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="30"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_number.backcolor = color_object

backcolor = color_object_selected

current_number = this

amount = 30

end event

type st_29 from statictext within u_time_interval
int X=1742
int Y=468
int Width=187
int Height=120
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="29"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_number.backcolor = color_object

backcolor = color_object_selected

current_number = this

amount = 29

end event

type st_28 from statictext within u_time_interval
int X=1531
int Y=468
int Width=187
int Height=120
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="28"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_number.backcolor = color_object

backcolor = color_object_selected

current_number = this

amount = 28
end event

type st_27 from statictext within u_time_interval
int X=1321
int Y=468
int Width=187
int Height=120
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="27"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_number.backcolor = color_object

backcolor = color_object_selected

current_number = this

amount = 27

end event

type st_26 from statictext within u_time_interval
int X=1111
int Y=468
int Width=187
int Height=120
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="26"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_number.backcolor = color_object

backcolor = color_object_selected

current_number = this

amount = 26

end event

type st_25 from statictext within u_time_interval
int X=901
int Y=468
int Width=187
int Height=120
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="25"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_number.backcolor = color_object

backcolor = color_object_selected

current_number = this

amount = 25

end event

type st_24 from statictext within u_time_interval
int X=690
int Y=468
int Width=187
int Height=120
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="24"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_number.backcolor = color_object

backcolor = color_object_selected

current_number = this

amount = 24

end event

type st_23 from statictext within u_time_interval
int X=480
int Y=468
int Width=187
int Height=120
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="23"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_number.backcolor = color_object

backcolor = color_object_selected

current_number = this

amount = 23

end event

type st_22 from statictext within u_time_interval
int X=270
int Y=468
int Width=187
int Height=120
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="22"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_number.backcolor = color_object

backcolor = color_object_selected

current_number = this

amount = 22

end event

type st_21 from statictext within u_time_interval
int X=59
int Y=468
int Width=187
int Height=120
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="21"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_number.backcolor = color_object

backcolor = color_object_selected

current_number = this

amount = 21

end event

type cb_clear from commandbutton within u_time_interval
int X=942
int Y=944
int Width=302
int Height=108
int TabOrder=10
string Text="Clear"
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;current_number.backcolor = color_object
current_unit.backcolor = color_object

setnull(amount)
setnull(unit)

end event

