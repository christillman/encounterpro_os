$PBExportHeader$w_config_shortlists.srw
forward
global type w_config_shortlists from w_window_base
end type
type uo_top_20_edit from u_top_20_list_edit within w_config_shortlists
end type
type pb_ok from u_picture_button within w_config_shortlists
end type
end forward

global type w_config_shortlists from w_window_base
string title = "ShortLists"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
uo_top_20_edit uo_top_20_edit
pb_ok pb_ok
end type
global w_config_shortlists w_config_shortlists

on w_config_shortlists.create
int iCurrent
call super::create
this.uo_top_20_edit=create uo_top_20_edit
this.pb_ok=create pb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_top_20_edit
this.Control[iCurrent+2]=this.pb_ok
end on

on w_config_shortlists.destroy
call super::destroy
destroy(this.uo_top_20_edit)
destroy(this.pb_ok)
end on

event post_open;call super::post_open;String				top_20_code
Integer				li_sts

str_popup			popup
str_popup_return	popup_return


popup.dataobject = "dw_get_domain_items"
popup.argument_count = 1
popup.argument[1] = "TOP_20_CODE"
popup.displaycolumn = 3
popup.datacolumn = 2
		
Openwithparm(w_pop_pick, popup)
popup_return = Message.Powerobjectparm
		
If popup_return.item_count = 0 then return 1
top_20_code = popup_return.items[1]
		
li_sts = uo_top_20_edit.initialize(top_20_code)
end event

event open;call super::open;Postevent("post_open")
end event

type pb_epro_help from w_window_base`pb_epro_help within w_config_shortlists
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_config_shortlists
end type

type uo_top_20_edit from u_top_20_list_edit within w_config_shortlists
integer x = 32
integer y = 28
integer width = 2382
integer taborder = 20
boolean bringtotop = true
end type

on uo_top_20_edit.destroy
call u_top_20_list_edit::destroy
end on

type pb_ok from u_picture_button within w_config_shortlists
integer x = 2578
integer y = 1460
integer taborder = 11
boolean bringtotop = true
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;uo_top_20_edit.save_changes()
Close(parent)
end event

