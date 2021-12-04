$PBExportHeader$w_svc_config_practice.srw
forward
global type w_svc_config_practice from w_window_base
end type
type st_title from statictext within w_svc_config_practice
end type
type cb_ok from commandbutton within w_svc_config_practice
end type
type tv_practice_config from u_tv_configuration within w_svc_config_practice
end type
end forward

global type w_svc_config_practice from w_window_base
integer width = 2898
integer height = 1808
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
st_title st_title
cb_ok cb_ok
tv_practice_config tv_practice_config
end type
global w_svc_config_practice w_svc_config_practice

type variables
u_component_service service

boolean allow_editing

end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();integer li_sts

li_sts = tv_practice_config.display_root(allow_editing)

return li_sts

end function

on w_svc_config_practice.create
int iCurrent
call super::create
this.st_title=create st_title
this.cb_ok=create cb_ok
this.tv_practice_config=create tv_practice_config
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.tv_practice_config
end on

on w_svc_config_practice.destroy
call super::destroy
destroy(this.st_title)
destroy(this.cb_ok)
destroy(this.tv_practice_config)
end on

event open;call super::open;str_popup_return popup_return
integer li_sts

service = message.powerobjectparm

allow_editing = current_user.check_privilege("Configure Practice")

tv_practice_config.width = width - 41
tv_practice_config.height = height - 416

st_title.width = width

cb_ok.x = tv_practice_config.x + tv_practice_config.width - cb_ok.width
cb_ok.y = height - cb_ok.height - 112


li_sts = refresh()
if li_sts <= 0 then
	popup_return.item_count = 1
	popup_return.items[1] = "ERROR"
	
	closewithreturn(this, popup_return)
end if



end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_config_practice
integer x = 2830
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_config_practice
end type

type st_title from statictext within w_svc_config_practice
integer width = 2898
integer height = 104
boolean bringtotop = true
integer textsize = -16
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Practice Configuration"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_svc_config_practice
integer x = 2363
integer y = 1592
integer width = 485
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;str_popup_return popup_return

// Flush all caches
datalist.clear_cache("attachment_types")
datalist.clear_cache("offices")

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type tv_practice_config from u_tv_configuration within w_svc_config_practice
integer x = 9
integer y = 128
integer width = 2875
integer height = 1436
integer taborder = 30
long backcolor = 12632256
end type

