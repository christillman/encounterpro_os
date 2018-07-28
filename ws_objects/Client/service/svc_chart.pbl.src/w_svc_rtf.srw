$PBExportHeader$w_svc_rtf.srw
forward
global type w_svc_rtf from w_window_base
end type
type cb_finished from commandbutton within w_svc_rtf
end type
type cb_be_back from commandbutton within w_svc_rtf
end type
type ole_rtf from u_rich_text_edit within w_svc_rtf
end type
type tab_rtf from u_tab_rtf_service within w_svc_rtf
end type
type tab_rtf from u_tab_rtf_service within w_svc_rtf
end type
end forward

global type w_svc_rtf from w_window_base
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string button_type = "COMMAND"
integer max_buttons = 3
cb_finished cb_finished
cb_be_back cb_be_back
ole_rtf ole_rtf
tab_rtf tab_rtf
end type
global w_svc_rtf w_svc_rtf

type variables
u_component_service	service

long display_script_id

end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();if ole_rtf.visible then
	ole_rtf.clear_rtf()
	ole_rtf.display_script(display_script_id)
end if

return 1

end function

on w_svc_rtf.create
int iCurrent
call super::create
this.cb_finished=create cb_finished
this.cb_be_back=create cb_be_back
this.ole_rtf=create ole_rtf
this.tab_rtf=create tab_rtf
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_finished
this.Control[iCurrent+2]=this.cb_be_back
this.Control[iCurrent+3]=this.ole_rtf
this.Control[iCurrent+4]=this.tab_rtf
end on

on w_svc_rtf.destroy
call super::destroy
destroy(this.cb_finished)
destroy(this.cb_be_back)
destroy(this.ole_rtf)
destroy(this.tab_rtf)
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

li_count = 0

DO WHILE true
	ls_suffix = "_" + string(li_count + 1)
	ls_title = service.get_attribute("display_title" + ls_suffix)
	ll_display_script_id = long(service.get_attribute("display_script_id" + ls_suffix))
	
	if not isnull(ls_title) and not isnull(ll_display_script_id) then
		li_count += 1
		lsa_title[li_count] = ls_title
		lla_display_script_id[li_count] = ll_display_script_id
	else
		exit
	end if
LOOP

// If we don't have an array, then just get the display_script_id
if li_count = 0 then
	display_script_id = long(service.get_attribute("display_script_id"))
	
	if isnull(display_script_id) then
		log.log(this, "open", "No display script defined", 4)
		closewithreturn(this, popup_return)
		return
	else
		tab_rtf.visible = false
		ole_rtf.visible = true
	end if
else
	tab_rtf.visible = true
	ole_rtf.visible = false

	ls_tab_location = service.get_attribute("tab_location")
	CHOOSE CASE upper(left(ls_tab_location, 1))
		CASE "R"
			tab_rtf.tabposition = TabsOnRight!
			tab_rtf.raggedright = true
			tab_rtf.perpendiculartext = true
		CASE "B"
			tab_rtf.tabposition = TabsOnBottom!
			tab_rtf.raggedright = false
			tab_rtf.perpendiculartext = false
		CASE "L"
			tab_rtf.tabposition = TabsOnLeft!
			tab_rtf.raggedright = true
			tab_rtf.perpendiculartext = true
		CASE ELSE
			// Default is on top
			tab_rtf.tabposition = TabsOnTop!
			tab_rtf.raggedright = false
			tab_rtf.perpendiculartext = false
	END CHOOSE

	for i = 1 to li_count
		lo_tabpage = tab_rtf.open_page("u_tabpage_rtf_service")
		lo_tabpage.text = lsa_title[i]
		lo_tabpage.initialize(string(lla_display_script_id[i]))
	next
end if

service.get_attribute("debug_mode", ole_rtf.debug_mode, false)

postevent("post_open")

end event

event post_open;call super::post_open;
refresh()

// Make sure the focus stays here
enable_window()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_rtf
integer x = 2857
integer y = 0
integer width = 256
integer height = 128
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_rtf
integer x = 14
integer y = 1588
end type

type cb_finished from commandbutton within w_svc_rtf
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

type cb_be_back from commandbutton within w_svc_rtf
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

type ole_rtf from u_rich_text_edit within w_svc_rtf
integer width = 2926
integer height = 1584
integer taborder = 20
boolean init_vscrollbar = true
boolean init_headerfooter = false
borderstyle borderstyle = styleraised!
end type

type tab_rtf from u_tab_rtf_service within w_svc_rtf
integer width = 2930
integer height = 1588
end type

