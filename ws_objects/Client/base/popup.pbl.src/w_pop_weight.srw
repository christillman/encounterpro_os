$PBExportHeader$w_pop_weight.srw
forward
global type w_pop_weight from Window
end type
type uo_100 from u_spin_up_down within w_pop_weight
end type
type uo_10 from u_spin_up_down within w_pop_weight
end type
type uo_1 from u_spin_up_down within w_pop_weight
end type
type cb_2 from commandbutton within w_pop_weight
end type
type st_patient_weight from statictext within w_pop_weight
end type
type st_one from statictext within w_pop_weight
end type
type st_ten from statictext within w_pop_weight
end type
type st_hundred from statictext within w_pop_weight
end type
type cb_1 from commandbutton within w_pop_weight
end type
type rb_kg from radiobutton within w_pop_weight
end type
type rb_pounds from radiobutton within w_pop_weight
end type
type st_2 from statictext within w_pop_weight
end type
type st_1 from statictext within w_pop_weight
end type
type gb_1 from groupbox within w_pop_weight
end type
end forward

global type w_pop_weight from Window
int X=87
int Y=537
int Width=1811
int Height=1337
long BackColor=COLOR_BACKGROUND
boolean ControlMenu=true
WindowType WindowType=response!
uo_100 uo_100
uo_10 uo_10
uo_1 uo_1
cb_2 cb_2
st_patient_weight st_patient_weight
st_one st_one
st_ten st_ten
st_hundred st_hundred
cb_1 cb_1
rb_kg rb_kg
rb_pounds rb_pounds
st_2 st_2
st_1 st_1
gb_1 gb_1
end type
global w_pop_weight w_pop_weight

type variables
real patient_weight
end variables

on open;patient_weight = 10
st_patient_weight.text = string(patient_weight)
end on

on w_pop_weight.create
this.uo_100=create uo_100
this.uo_10=create uo_10
this.uo_1=create uo_1
this.cb_2=create cb_2
this.st_patient_weight=create st_patient_weight
this.st_one=create st_one
this.st_ten=create st_ten
this.st_hundred=create st_hundred
this.cb_1=create cb_1
this.rb_kg=create rb_kg
this.rb_pounds=create rb_pounds
this.st_2=create st_2
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={ this.uo_100,&
this.uo_10,&
this.uo_1,&
this.cb_2,&
this.st_patient_weight,&
this.st_one,&
this.st_ten,&
this.st_hundred,&
this.cb_1,&
this.rb_kg,&
this.rb_pounds,&
this.st_2,&
this.st_1,&
this.gb_1}
end on

on w_pop_weight.destroy
destroy(this.uo_100)
destroy(this.uo_10)
destroy(this.uo_1)
destroy(this.cb_2)
destroy(this.st_patient_weight)
destroy(this.st_one)
destroy(this.st_ten)
destroy(this.st_hundred)
destroy(this.cb_1)
destroy(this.rb_kg)
destroy(this.rb_pounds)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.gb_1)
end on

type uo_100 from u_spin_up_down within w_pop_weight
int X=1267
int Y=441
int Width=87
int Height=157
int TabOrder=40
end type

on spindown;call u_spin_up_down::spindown;if patient_weight - 100 >= 1 then
	patient_weight = patient_weight - 100
	st_patient_weight.text = string(patient_weight)
end if

end on

on spinup;call u_spin_up_down::spinup;patient_weight = patient_weight + 100
st_patient_weight.text = string(patient_weight)

end on

on uo_100.destroy
call u_spin_up_down::destroy
end on

type uo_10 from u_spin_up_down within w_pop_weight
int X=851
int Y=441
int Width=87
int Height=157
int TabOrder=10
end type

on spinup;call u_spin_up_down::spinup;patient_weight = patient_weight + 10
st_patient_weight.text = string(patient_weight)

end on

on spindown;call u_spin_up_down::spindown;if patient_weight - 10 >= 1 then
	patient_weight = patient_weight - 10
	st_patient_weight.text = string(patient_weight)
end if

end on

on uo_10.destroy
call u_spin_up_down::destroy
end on

type uo_1 from u_spin_up_down within w_pop_weight
int X=453
int Y=441
int TabOrder=30
end type

on spindown;call u_spin_up_down::spindown;if patient_weight - 1 >= 1 then
	patient_weight = patient_weight - 1
	st_patient_weight.text = string(patient_weight)
end if

end on

on spinup;call u_spin_up_down::spinup;patient_weight = patient_weight + 1
st_patient_weight.text = string(patient_weight)

end on

on uo_1.destroy
call u_spin_up_down::destroy
end on

type cb_2 from commandbutton within w_pop_weight
int X=988
int Y=1121
int Width=247
int Height=109
int TabOrder=60
string Text="Cancel"
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;closewithreturn(parent,-1)
end on

type st_patient_weight from statictext within w_pop_weight
int X=275
int Y=745
int Width=695
int Height=153
boolean Enabled=false
boolean Border=true
BorderStyle BorderStyle=StyleLowered!
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-20
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_one from statictext within w_pop_weight
int X=334
int Y=457
int Width=133
int Height=121
boolean Enabled=false
string Text="1"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=COLOR_BACKGROUND
int TextSize=-20
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_ten from statictext within w_pop_weight
int X=663
int Y=457
int Width=165
int Height=121
boolean Enabled=false
string Text="10"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=COLOR_BACKGROUND
int TextSize=-20
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_hundred from statictext within w_pop_weight
int X=1011
int Y=457
int Width=234
int Height=121
boolean Enabled=false
string Text="100"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=COLOR_BACKGROUND
int TextSize=-20
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_1 from commandbutton within w_pop_weight
int X=535
int Y=1121
int Width=247
int Height=109
int TabOrder=50
string Text="OK"
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;if rb_pounds.checked then
	patient_weight = patient_weight / 2.2
end if
closewithreturn(parent,patient_weight)

end on

type rb_kg from radiobutton within w_pop_weight
int X=1194
int Y=857
int Width=348
int Height=73
string Text="Kilograms"
boolean Checked=true
long BackColor=COLOR_BACKGROUND
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type rb_pounds from radiobutton within w_pop_weight
int X=1198
int Y=729
int Width=284
int Height=73
string Text="Pounds"
long BackColor=COLOR_BACKGROUND
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_2 from statictext within w_pop_weight
int X=225
int Y=261
int Width=1230
int Height=73
boolean Enabled=false
string Text="Please enter the patient's weight:"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=COLOR_BACKGROUND
int TextSize=-12
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_1 from statictext within w_pop_weight
int X=74
int Y=105
int Width=1665
int Height=73
boolean Enabled=false
string Text="The patient's weight is not available at this time."
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=COLOR_BACKGROUND
int TextSize=-12
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type gb_1 from groupbox within w_pop_weight
int X=1121
int Y=633
int Width=494
int Height=361
int TabOrder=20
long BackColor=COLOR_BACKGROUND
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

