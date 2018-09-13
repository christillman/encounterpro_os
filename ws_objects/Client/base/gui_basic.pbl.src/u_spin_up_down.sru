$PBExportHeader$u_spin_up_down.sru
forward
global type u_spin_up_down from UserObject
end type
type p_down from picture within u_spin_up_down
end type
type p_up from picture within u_spin_up_down
end type
type ln_middle from line within u_spin_up_down
end type
end forward

global type u_spin_up_down from UserObject
int Width=97
int Height=165
boolean Border=true
event spinup pbm_custom01
event spindown pbm_custom02
p_down p_down
p_up p_up
ln_middle ln_middle
end type
global u_spin_up_down u_spin_up_down

on u_spin_up_down.create
this.p_down=create p_down
this.p_up=create p_up
this.ln_middle=create ln_middle
this.Control[]={ this.p_down,&
this.p_up,&
this.ln_middle}
end on

on u_spin_up_down.destroy
destroy(this.p_down)
destroy(this.p_up)
destroy(this.ln_middle)
end on

type p_down from picture within u_spin_up_down
int Y=85
int Width=87
int Height=77
string PictureName="spindn.bmp"
boolean FocusRectangle=false
boolean OriginalSize=true
end type

on clicked;parent.triggerevent("spindown")

end on

type p_up from picture within u_spin_up_down
int Width=87
int Height=77
string PictureName="spinup.bmp"
boolean FocusRectangle=false
boolean OriginalSize=true
end type

on clicked;parent.triggerevent("spinup")

end on

type ln_middle from line within u_spin_up_down
boolean Enabled=false
int BeginX=-21
int BeginY=81
int EndX=87
int EndY=81
int LineThickness=9
end type

