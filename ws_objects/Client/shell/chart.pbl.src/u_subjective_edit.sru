$PBExportHeader$u_subjective_edit.sru
forward
global type u_subjective_edit from UserObject
end type
type mle_new from multilineedit within u_subjective_edit
end type
type cb_down from commandbutton within u_subjective_edit
end type
type cb_up from commandbutton within u_subjective_edit
end type
type dw_subjective from u_dw_pick_list within u_subjective_edit
end type
end forward

global type u_subjective_edit from UserObject
int Width=2469
int Height=1273
long BackColor=33538240
long PictureMaskColor=536870912
long TabBackColor=16777215
mle_new mle_new
cb_down cb_down
cb_up cb_up
dw_subjective dw_subjective
end type
global u_subjective_edit u_subjective_edit

on u_subjective_edit.create
this.mle_new=create mle_new
this.cb_down=create cb_down
this.cb_up=create cb_up
this.dw_subjective=create dw_subjective
this.Control[]={ this.mle_new,&
this.cb_down,&
this.cb_up,&
this.dw_subjective}
end on

on u_subjective_edit.destroy
destroy(this.mle_new)
destroy(this.cb_down)
destroy(this.cb_up)
destroy(this.dw_subjective)
end on

type mle_new from multilineedit within u_subjective_edit
int X=23
int Y=965
int Width=2049
int Height=297
int TabOrder=4
BorderStyle BorderStyle=StyleLowered!
long BackColor=15793151
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_down from commandbutton within u_subjective_edit
int X=2149
int Y=205
int Width=247
int Height=109
int TabOrder=10
string Text="Down"
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_up from commandbutton within u_subjective_edit
int X=2149
int Y=57
int Width=247
int Height=109
int TabOrder=30
string Text="Up"
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type dw_subjective from u_dw_pick_list within u_subjective_edit
int X=19
int Y=13
int Width=2049
int Height=937
int TabOrder=20
string DataObject="dw_subjective_list"
end type

