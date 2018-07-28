$PBExportHeader$w_splash.srw
forward
global type w_splash from w_window_base
end type
type st_build_number from statictext within w_splash
end type
type p_logo from picture within w_splash
end type
type st_copyright from statictext within w_splash
end type
type p_agpl from picture within w_splash
end type
end forward

global type w_splash from w_window_base
integer x = 69
integer y = 256
integer width = 2747
integer height = 1480
boolean enabled = false
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
boolean border = false
windowtype windowtype = child!
boolean show_more_buttons = false
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
st_build_number st_build_number
p_logo p_logo
st_copyright st_copyright
p_agpl p_agpl
end type
global w_splash w_splash

on w_splash.create
int iCurrent
call super::create
this.st_build_number=create st_build_number
this.p_logo=create p_logo
this.st_copyright=create st_copyright
this.p_agpl=create p_agpl
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_build_number
this.Control[iCurrent+2]=this.p_logo
this.Control[iCurrent+3]=this.st_copyright
this.Control[iCurrent+4]=this.p_agpl
end on

on w_splash.destroy
call super::destroy
destroy(this.st_build_number)
destroy(this.p_logo)
destroy(this.st_copyright)
destroy(this.p_agpl)
end on

event open;call super::open;st_build_number.text = "Version  " + f_app_version()


p_logo.x = (width - p_logo.width) / 2
st_build_number.x = (width - st_build_number.width) / 2
st_copyright.x = (width - st_copyright.width) / 2
p_agpl.x = (width - p_agpl.width) / 2
end event

type pb_epro_help from w_window_base`pb_epro_help within w_splash
integer x = 2688
integer y = 136
integer width = 256
integer height = 128
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_splash
end type

type st_build_number from statictext within w_splash
integer x = 731
integer y = 460
integer width = 1262
integer height = 72
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Build 159"
alignment alignment = center!
boolean focusrectangle = false
end type

type p_logo from picture within w_splash
integer x = 919
integer y = 160
integer width = 1454
integer height = 404
boolean bringtotop = true
boolean originalsize = true
string picturename = "Epro-OS-logo-blk-grn-Transparent.png"
boolean focusrectangle = false
end type

type st_copyright from statictext within w_splash
integer x = 325
integer y = 620
integer width = 2135
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = roman!
string facename = "Times New Roman"
long backcolor = 33538240
boolean enabled = false
string text = "Copyright 2010 The EncounterPRO Foundation, Inc."
alignment alignment = center!
boolean focusrectangle = false
end type

type p_agpl from picture within w_splash
integer x = 1056
integer y = 916
integer width = 709
integer height = 204
boolean bringtotop = true
boolean originalsize = true
string picturename = "agplv3-155x51.png"
boolean focusrectangle = false
end type

