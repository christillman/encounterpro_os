$PBExportHeader$w_new_box.srw
forward
global type w_new_box from w_window_base
end type
type st_1 from statictext within w_new_box
end type
type sle_description from singlelineedit within w_new_box
end type
type cbx_close_current from checkbox within w_new_box
end type
type pb_done from u_picture_button within w_new_box
end type
type pb_cancel from u_picture_button within w_new_box
end type
type st_2 from statictext within w_new_box
end type
end forward

global type w_new_box from w_window_base
int X=462
int Y=425
int Width=1998
int Height=989
WindowType WindowType=response!
long BackColor=33538240
boolean MinBox=false
boolean MaxBox=false
boolean Resizable=false
st_1 st_1
sle_description sle_description
cbx_close_current cbx_close_current
pb_done pb_done
pb_cancel pb_cancel
st_2 st_2
end type
global w_new_box w_new_box

event open;call super::open;str_popup popup

popup = message.powerobjectparm
sle_description.text = popup.item

end event

on w_new_box.create
int iCurrent
call w_window_base::create
this.st_1=create st_1
this.sle_description=create sle_description
this.cbx_close_current=create cbx_close_current
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=st_1
this.Control[iCurrent+2]=sle_description
this.Control[iCurrent+3]=cbx_close_current
this.Control[iCurrent+4]=pb_done
this.Control[iCurrent+5]=pb_cancel
this.Control[iCurrent+6]=st_2
end on

on w_new_box.destroy
call w_window_base::destroy
destroy(this.st_1)
destroy(this.sle_description)
destroy(this.cbx_close_current)
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.st_2)
end on

type st_1 from statictext within w_new_box
int X=179
int Y=297
int Width=343
int Height=77
boolean Enabled=false
boolean BringToTop=true
string Text="Description:"
Alignment Alignment=Right!
boolean FocusRectangle=false
long BackColor=33538240
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_description from singlelineedit within w_new_box
int X=554
int Y=285
int Width=1313
int Height=93
int TabOrder=10
boolean BringToTop=true
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long BackColor=16777215
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cbx_close_current from checkbox within w_new_box
int X=732
int Y=457
int Width=609
int Height=77
boolean BringToTop=true
string Text="Close Current Box"
boolean Checked=true
long BackColor=33538240
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type pb_done from u_picture_button within w_new_box
int X=1637
int Y=625
int TabOrder=20
string PictureName="button26.bmp"
string DisabledName="b_push26.bmp"
boolean Default=true
end type

event clicked;call super::clicked;str_popup_return popup_return

if isnull(sle_description.text) or sle_description.text = "" then
	openwithparm(w_pop_message, "You must enter a description")
	return
end if

popup_return.item_count = 2
popup_return.items[1] = sle_description.text
if cbx_close_current.checked then
	popup_return.items[2] = "TRUE"
else
	popup_return.items[2] = "FALSE"
end if

closewithreturn(parent, popup_return)

end event

type pb_cancel from u_picture_button within w_new_box
int X=92
int Y=625
int TabOrder=3
boolean BringToTop=true
string PictureName="button11.bmp"
string DisabledName="b_push11.bmp"
boolean Cancel=true
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type st_2 from statictext within w_new_box
int Width=1994
int Height=161
boolean Enabled=false
boolean BringToTop=true
string Text="New Box"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=33538240
int TextSize=-22
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

