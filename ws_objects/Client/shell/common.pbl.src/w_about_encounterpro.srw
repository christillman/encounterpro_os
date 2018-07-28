$PBExportHeader$w_about_encounterpro.srw
forward
global type w_about_encounterpro from w_window_base
end type
type st_build_number from statictext within w_about_encounterpro
end type
type st_license_title from statictext within w_about_encounterpro
end type
type rte_license from richtextedit within w_about_encounterpro
end type
type shl_source from statichyperlink within w_about_encounterpro
end type
type cb_ok from commandbutton within w_about_encounterpro
end type
type shl_foundation from statichyperlink within w_about_encounterpro
end type
type shl_gnu_affero from statichyperlink within w_about_encounterpro
end type
type phl_agpl from picturehyperlink within w_about_encounterpro
end type
type phl_logo from picturehyperlink within w_about_encounterpro
end type
end forward

global type w_about_encounterpro from w_window_base
integer x = 69
integer y = 256
integer width = 3451
integer height = 2100
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean show_more_buttons = false
boolean auto_resize_window = false
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
st_build_number st_build_number
st_license_title st_license_title
rte_license rte_license
shl_source shl_source
cb_ok cb_ok
shl_foundation shl_foundation
shl_gnu_affero shl_gnu_affero
phl_agpl phl_agpl
phl_logo phl_logo
end type
global w_about_encounterpro w_about_encounterpro

on w_about_encounterpro.create
int iCurrent
call super::create
this.st_build_number=create st_build_number
this.st_license_title=create st_license_title
this.rte_license=create rte_license
this.shl_source=create shl_source
this.cb_ok=create cb_ok
this.shl_foundation=create shl_foundation
this.shl_gnu_affero=create shl_gnu_affero
this.phl_agpl=create phl_agpl
this.phl_logo=create phl_logo
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_build_number
this.Control[iCurrent+2]=this.st_license_title
this.Control[iCurrent+3]=this.rte_license
this.Control[iCurrent+4]=this.shl_source
this.Control[iCurrent+5]=this.cb_ok
this.Control[iCurrent+6]=this.shl_foundation
this.Control[iCurrent+7]=this.shl_gnu_affero
this.Control[iCurrent+8]=this.phl_agpl
this.Control[iCurrent+9]=this.phl_logo
end on

on w_about_encounterpro.destroy
call super::destroy
destroy(this.st_build_number)
destroy(this.st_license_title)
destroy(this.rte_license)
destroy(this.shl_source)
destroy(this.cb_ok)
destroy(this.shl_foundation)
destroy(this.shl_gnu_affero)
destroy(this.phl_agpl)
destroy(this.phl_logo)
end on

event open;call super::open;st_build_number.text = "Version  " + f_app_version()


phl_logo.x = (width - phl_logo.width) / 2
st_build_number.x = (width - st_build_number.width) / 2
rte_license.x = (width - rte_license.width) / 2
shl_source.x = (width - shl_source.width) / 2
shl_foundation.x = (width - shl_foundation.width) / 2
shl_gnu_affero.x = (width - shl_gnu_affero.width) / 2
phl_agpl.x = (width - phl_agpl.width) / 2

st_license_title.x = rte_license.x

rte_license.InsertDocument(program_directory + "\Open Source License.rtf", true)
rte_license.displayonly = true

this.center_popup( )


end event

type pb_epro_help from w_window_base`pb_epro_help within w_about_encounterpro
integer x = 2688
integer y = 136
integer width = 256
integer height = 128
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_about_encounterpro
end type

type st_build_number from statictext within w_about_encounterpro
integer x = 965
integer y = 444
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

type st_license_title from statictext within w_about_encounterpro
integer x = 96
integer y = 892
integer width = 402
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = roman!
string facename = "Times New Roman"
long backcolor = 33538240
string text = "License"
boolean focusrectangle = false
end type

type rte_license from richtextedit within w_about_encounterpro
integer x = 91
integer y = 968
integer width = 3241
integer height = 952
integer taborder = 20
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = roman!
string facename = "Times New Roman"
boolean init_vscrollbar = true
boolean init_wordwrap = true
string init_documentname = "EncounterPRO-OS License"
borderstyle borderstyle = stylelowered!
end type

type shl_source from statichyperlink within w_about_encounterpro
integer x = 329
integer y = 1976
integer width = 1792
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = roman!
string facename = "Times New Roman"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 134217856
long backcolor = 33538240
string text = "EncounterPRO-OS on SourceForge"
alignment alignment = center!
boolean focusrectangle = false
string url = "https://sourceforge.net/projects/encounterpro-os/"
end type

type cb_ok from commandbutton within w_about_encounterpro
integer x = 2912
integer y = 1956
integer width = 421
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = roman!
string facename = "Times New Roman"
string text = "OK"
end type

event clicked;close(parent)
end event

type shl_foundation from statichyperlink within w_about_encounterpro
integer x = 969
integer y = 548
integer width = 1280
integer height = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = roman!
string facename = "Times New Roman"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 134217856
long backcolor = 33538240
string text = "Copyright 2010 The EncounterPRO Foundation, Inc."
alignment alignment = center!
boolean focusrectangle = false
string url = "http://encounterpro.org/"
end type

type shl_gnu_affero from statichyperlink within w_about_encounterpro
integer x = 1303
integer y = 648
integer width = 846
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = roman!
string facename = "Times New Roman"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 134217856
long backcolor = 33538240
string text = "Gnu Affero General Public License"
alignment alignment = center!
boolean focusrectangle = false
string url = "http://www.gnu.org/licenses/agpl.html"
end type

type phl_agpl from picturehyperlink within w_about_encounterpro
integer x = 1559
integer y = 768
integer width = 402
integer height = 124
boolean bringtotop = true
string pointer = "HyperLink!"
boolean originalsize = true
string picturename = "agplv3-88x31.png"
boolean focusrectangle = false
string url = "http://www.gnu.org/licenses/agpl.html"
end type

type phl_logo from picturehyperlink within w_about_encounterpro
integer x = 960
integer y = 24
integer width = 1454
integer height = 404
string pointer = "HyperLink!"
string picturename = "Epro-OS-logo-blk-grn-Transparent.png"
boolean focusrectangle = false
string url = "http://encounterpro.org/"
end type

