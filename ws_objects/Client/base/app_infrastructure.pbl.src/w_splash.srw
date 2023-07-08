$PBExportHeader$w_splash.srw
forward
global type w_splash from w_window_base
end type
type st_build_number from statictext within w_splash
end type
type st_copyright from statictext within w_splash
end type
type p_logo from picture within w_splash
end type
end forward

global type w_splash from w_window_base
integer x = 69
integer y = 256
integer width = 2670
integer height = 1652
boolean enabled = false
boolean titlebar = false
string title = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
boolean border = false
windowtype windowtype = popup!
boolean show_more_buttons = false
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
st_build_number st_build_number
st_copyright st_copyright
p_logo p_logo
end type
global w_splash w_splash

on w_splash.create
int iCurrent
call super::create
this.st_build_number=create st_build_number
this.st_copyright=create st_copyright
this.p_logo=create p_logo
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_build_number
this.Control[iCurrent+2]=this.st_copyright
this.Control[iCurrent+3]=this.p_logo
end on

on w_splash.destroy
call super::destroy
destroy(this.st_build_number)
destroy(this.st_copyright)
destroy(this.p_logo)
end on

event open;call super::open;st_build_number.text = f_app_version()

//
//p_logo.x = (width - p_logo.width) / 2
//st_build_number.x = (width - st_build_number.width) / 2
//st_copyright.x = (width - st_copyright.width) / 2
//p_agpl.x = (width - p_agpl.width) / 2

timer( 5 ) // 35 seconds
this.bringtotop = TRUE
end event

event timer;call super::timer;
close( this )
return 0
end event

event close;call super::close;
timer( 0, w_splash )
return 0
end event

event closequery;call super::closequery;
timer( 0, w_splash )
return 0
end event

type pb_epro_help from w_window_base`pb_epro_help within w_splash
integer x = 2688
integer y = 136
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_splash
boolean visible = true
integer x = 1179
integer y = 872
integer height = 60
long backcolor = 553648127
end type

type st_build_number from statictext within w_splash
integer x = 32
integer y = 1480
integer width = 965
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = roman!
string facename = "Times New Roman"
long backcolor = 7191717
boolean enabled = false
string text = "Build 159"
boolean focusrectangle = false
end type

type st_copyright from statictext within w_splash
integer x = 32
integer y = 1564
integer width = 1426
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = roman!
string facename = "Times New Roman"
long backcolor = 7191717
boolean enabled = false
string text = "Copyright 2010-2022 The EncounterPRO Foundation, Inc."
alignment alignment = center!
boolean focusrectangle = false
end type

type p_logo from picture within w_splash
integer width = 2674
integer height = 1652
string picturename = "greenolivehr-background.png"
boolean focusrectangle = false
end type

