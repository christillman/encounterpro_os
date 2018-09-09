$PBExportHeader$w_get_string.srw
forward
global type w_get_string from Window
end type
type sle_text from singlelineedit within w_get_string
end type
type st_prompt from statictext within w_get_string
end type
type cb_cancel from commandbutton within w_get_string
end type
type cb_ok from commandbutton within w_get_string
end type
end forward

global type w_get_string from Window
int X=823
int Y=360
int Width=1408
int Height=820
boolean TitleBar=true
string Title="Untitled"
long BackColor=79741120
boolean ControlMenu=true
WindowType WindowType=response!
event ue_cancel ( )
event ue_ok ( )
sle_text sle_text
st_prompt st_prompt
cb_cancel cb_cancel
cb_ok cb_ok
end type
global w_get_string w_get_string

event ue_cancel;string ls_null

setnull(ls_null)

closewithreturn(this, ls_null)

end event

event ue_ok;closewithreturn(this, sle_text.text)
end event

event open;st_prompt.text = message.stringparm
sle_text.text = ""
end event

on w_get_string.create
this.sle_text=create sle_text
this.st_prompt=create st_prompt
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.Control[]={this.sle_text,&
this.st_prompt,&
this.cb_cancel,&
this.cb_ok}
end on

on w_get_string.destroy
destroy(this.sle_text)
destroy(this.st_prompt)
destroy(this.cb_cancel)
destroy(this.cb_ok)
end on

type sle_text from singlelineedit within w_get_string
int X=151
int Y=340
int Width=1074
int Height=92
int TabOrder=10
boolean BringToTop=true
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long BackColor=16777215
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_prompt from statictext within w_get_string
int X=41
int Y=48
int Width=1275
int Height=208
boolean Enabled=false
boolean BringToTop=true
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_cancel from commandbutton within w_get_string
int X=73
int Y=500
int Width=247
int Height=108
int TabOrder=20
string Text="Cancel"
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;parent.postevent("ue_cancel")
end event

type cb_ok from commandbutton within w_get_string
int X=1047
int Y=492
int Width=247
int Height=108
int TabOrder=10
string Text="OK"
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;parent.postevent("ue_ok")
end event

