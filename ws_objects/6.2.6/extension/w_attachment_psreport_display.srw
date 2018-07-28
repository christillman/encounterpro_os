HA$PBExportHeader$w_attachment_psreport_display.srw
forward
global type w_attachment_psreport_display from w_window_base
end type
type dw_psreport from u_dw_pick_list within w_attachment_psreport_display
end type
type st_title from statictext within w_attachment_psreport_display
end type
type cb_ok from commandbutton within w_attachment_psreport_display
end type
type str_point from structure within w_attachment_psreport_display
end type
end forward

type str_point from structure
	long		x
	long		y
end type

global type w_attachment_psreport_display from w_window_base
boolean visible = false
integer width = 2962
integer height = 1936
string title = ""
windowanimationstyle openanimation = centeranimation!
windowanimationstyle closeanimation = centeranimation!
dw_psreport dw_psreport
st_title st_title
cb_ok cb_ok
end type
global w_attachment_psreport_display w_attachment_psreport_display

type prototypes
SUBROUTINE GetCursorPos( ref str_point lppt ) LIBRARY "USER32.DLL" alias for "GetCursorPos;Ansi"

end prototypes

type variables
u_component_attachment attachment
string display_file

end variables

forward prototypes
public function integer render (ref string ps_temp_file)
public function integer print_datawindow ()
end prototypes

public function integer render (ref string ps_temp_file);integer li_sts

ps_temp_file = f_temp_file("emf")

li_sts = dw_psreport.saveas(ps_temp_file, EMF!, true)
if li_sts <= 0 then
	log.log(this, "render()", "Error saving datawindow to file (" + ps_temp_file + ")", 4)
	return -1
end if

return 1

end function

public function integer print_datawindow ();

dw_psreport.print(false, false)

return 1

end function

event open;call super::open;integer li_count
str_popup popup
str_popup_return popup_return
integer li_sts
string ls_title

attachment = message.powerobjectparm

if len(attachment.attachment_tag) > 0 then
	ls_title = attachment.attachment_tag
else
	ls_title = attachment.extension + " File"
end if

if isvalid(attachment.originator) and not isnull(attachment.originator) then
	ls_title += " Attached by "
	ls_title += attachment.originator.user_full_name
else
end if
if not isnull(attachment.attachment_date) then
	ls_title += " on " + string(attachment.attachment_date, "[shortdate] [time]")
end if

st_title.text = ls_title

display_file = attachment.get_attachment()
if isnull(display_file) then
	log.log(this, "open", "Error getting attachment file", 4)
	close(this)
	return
end if


dw_psreport.dataobject = display_file

end event

on w_attachment_psreport_display.create
int iCurrent
call super::create
this.dw_psreport=create dw_psreport
this.st_title=create st_title
this.cb_ok=create cb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_psreport
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.cb_ok
end on

on w_attachment_psreport_display.destroy
call super::destroy
destroy(this.dw_psreport)
destroy(this.st_title)
destroy(this.cb_ok)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_attachment_psreport_display
integer x = 2866
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_attachment_psreport_display
end type

type dw_psreport from u_dw_pick_list within w_attachment_psreport_display
integer x = 18
integer y = 120
integer width = 2894
integer height = 1536
integer taborder = 10
string dataobject = "dw_pick_generic"
boolean vscrollbar = true
boolean livescroll = false
borderstyle borderstyle = stylelowered!
end type

type st_title from statictext within w_attachment_psreport_display
integer width = 2926
integer height = 100
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_attachment_psreport_display
integer x = 2318
integer y = 1688
integer width = 558
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;
close(parent)

end event

