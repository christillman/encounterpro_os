HA$PBExportHeader$w_whos_waiting.srw
forward
global type w_whos_waiting from Window
end type
type uo_whos_waiting from u_whos_waiting within w_whos_waiting
end type
type st_none from statictext within w_whos_waiting
end type
type pb_ok from u_picture_button within w_whos_waiting
end type
type st_1 from statictext within w_whos_waiting
end type
end forward

global type w_whos_waiting from Window
int X=1
int Y=1
int Width=2926
int Height=1833
long BackColor=33538240
WindowType WindowType=response!
uo_whos_waiting uo_whos_waiting
st_none st_none
pb_ok pb_ok
st_1 st_1
end type
global w_whos_waiting w_whos_waiting

on open;uo_whos_waiting.refresh()

timer(30)

end on

on timer;pb_ok.postevent("clicked")
end on

on w_whos_waiting.create
this.uo_whos_waiting=create uo_whos_waiting
this.st_none=create st_none
this.pb_ok=create pb_ok
this.st_1=create st_1
this.Control[]={ this.uo_whos_waiting,&
this.st_none,&
this.pb_ok,&
this.st_1}
end on

on w_whos_waiting.destroy
destroy(this.uo_whos_waiting)
destroy(this.st_none)
destroy(this.pb_ok)
destroy(this.st_1)
end on

type uo_whos_waiting from u_whos_waiting within w_whos_waiting
int X=636
int Y=125
int Width=1747
int Height=1673
int TabOrder=10
boolean VScrollBar=true
end type

type st_none from statictext within w_whos_waiting
int X=878
int Y=741
int Width=1061
int Height=229
boolean Visible=false
boolean Enabled=false
string Text="None"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=33538240
int TextSize=-28
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type pb_ok from u_picture_button within w_whos_waiting
int X=2602
int Y=1545
int TabOrder=20
string PictureName="button26.bmp"
string DisabledName="button26.bmp"
end type

on clicked;call u_picture_button::clicked;str_popup_return popup_return

popup_return.item = "OK"

closewithreturn(parent, popup_return)

end on

type st_1 from statictext within w_whos_waiting
int X=828
int Width=1185
int Height=129
boolean Enabled=false
string Text="Patients Waiting"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=33538240
int TextSize=-18
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

