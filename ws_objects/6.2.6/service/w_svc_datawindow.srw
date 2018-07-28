HA$PBExportHeader$w_svc_datawindow.srw
forward
global type w_svc_datawindow from w_window_base
end type
type cb_finished from commandbutton within w_svc_datawindow
end type
type cb_be_back from commandbutton within w_svc_datawindow
end type
type dw_datawindow from u_dw_display within w_svc_datawindow
end type
end forward

global type w_svc_datawindow from w_window_base
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string button_type = "COMMAND"
integer max_buttons = 3
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
cb_finished cb_finished
cb_be_back cb_be_back
dw_datawindow dw_datawindow
end type
global w_svc_datawindow w_svc_datawindow

type variables
u_component_service	service

string datawindow_config_object_id

end variables
forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();dw_datawindow.refresh()

return 1

end function

on w_svc_datawindow.create
int iCurrent
call super::create
this.cb_finished=create cb_finished
this.cb_be_back=create cb_be_back
this.dw_datawindow=create dw_datawindow
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_finished
this.Control[iCurrent+2]=this.cb_be_back
this.Control[iCurrent+3]=this.dw_datawindow
end on

on w_svc_datawindow.destroy
call super::destroy
destroy(this.cb_finished)
destroy(this.cb_be_back)
destroy(this.dw_datawindow)
end on

event open;call super::open;long ll_menu_id
string lsa_title[]
long lla_display_script_id[]
integer li_count
string ls_suffix
string ls_title
long ll_display_script_id
str_popup_return popup_return
u_tabpage_rtf_service lo_tabpage
integer i
string ls_tab_location

popup_return.item_count = 1
popup_return.items[1] = "ERROR"

service = message.powerobjectparm

// Set the title and sizes
If isvalid(current_patient) and not isnull(current_patient) Then
	title = current_patient.id_line()
End If

// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_be_back.visible = false
	max_buttons += 1
end if

ll_menu_id = long(service.get_attribute("menu_id"))
paint_menu(ll_menu_id)

datawindow_config_object_id = service.get_attribute("datawindow_config_object_id")

if isnull(datawindow_config_object_id) then
	log.log(this, "open", "No datawindow_config_object_id defined", 4)
	closewithreturn(this, popup_return)
	return
end if

dw_datawindow.attributes = service.get_attributes()
dw_datawindow.set_datawindow_config_object(datawindow_config_object_id)


refresh()


end event

event resize;call super::resize;cb_finished.x = width - cb_finished.width - 50
cb_finished.y = height - cb_finished.height - 150

cb_be_back.x = cb_finished.x - cb_be_back.width - 30
cb_be_back.y = cb_finished.y

dw_datawindow.width = width
dw_datawindow.height = cb_finished.y - 50

end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_datawindow
integer x = 2857
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_datawindow
integer x = 14
integer y = 1588
end type

type cb_finished from commandbutton within w_svc_datawindow
integer x = 2427
integer y = 1612
integer width = 443
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)
end event

type cb_be_back from commandbutton within w_svc_datawindow
integer x = 1961
integer y = 1612
integer width = 443
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 0
closewithreturn(parent, popup_return)
end event

type dw_datawindow from u_dw_display within w_svc_datawindow
integer taborder = 11
boolean bringtotop = true
end type

