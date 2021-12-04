$PBExportHeader$u_cpr_page_base.sru
forward
global type u_cpr_page_base from userobject
end type
type cb_configure_tab from commandbutton within u_cpr_page_base
end type
end forward

global type u_cpr_page_base from userobject
integer width = 2875
integer height = 1272
long backcolor = COLOR_BACKGROUND
long tabtextcolor = 33554432
long tabbackcolor = 16777215
long picturemaskcolor = 536870912
event tablostfocus ( )
event finished ( )
event repaint ( )
event refresh ( )
cb_configure_tab cb_configure_tab
end type
global u_cpr_page_base u_cpr_page_base

type variables
u_cpr_section this_section
integer this_page

boolean refresh_on_display = true
boolean displayed = false

w_pop_please_wait wait_window
w_cpr_main chart_window

boolean resize_objects = true

end variables

forward prototypes
public subroutine refresh ()
public subroutine initialize (u_cpr_section puo_section, integer pi_page)
public subroutine losefocus ()
public subroutine refresh_tab ()
public subroutine finished ()
public function integer size_and_position_window ()
public subroutine minimize ()
public subroutine key_down (keycode key, unsignedlong keyflags)
public function string chart_page_attribute (string ps_attribute)
public function string chart_page_attribute (string ps_attribute, ref string ps_value)
public function string chart_page_attribute (string ps_attribute, ref long pl_value)
end prototypes

event tablostfocus;losefocus()

end event

event finished;finished()

end event

event refresh();parent.postevent("refresh")

end event

public subroutine refresh ();
end subroutine

public subroutine initialize (u_cpr_section puo_section, integer pi_page);this_section = puo_section
this_page = pi_page





end subroutine

public subroutine losefocus ();
end subroutine

public subroutine refresh_tab ();
end subroutine

public subroutine finished ();
end subroutine

public function integer size_and_position_window ();return 1

end function

public subroutine minimize ();return

end subroutine

public subroutine key_down (keycode key, unsignedlong keyflags);
end subroutine

public function string chart_page_attribute (string ps_attribute);

return this_section.get_attribute(this_section.page[this_page].page_id, ps_attribute)

end function

public function string chart_page_attribute (string ps_attribute, ref string ps_value);

ps_value = this_section.get_attribute(this_section.page[this_page].page_id, ps_attribute)

return ps_value


end function

public function string chart_page_attribute (string ps_attribute, ref long pl_value);string ls_temp

setnull(pl_value)

ls_temp = this_section.get_attribute(this_section.page[this_page].page_id, ps_attribute)
if isnumber(ls_temp) then
	pl_value = long(ls_temp)
end if

return ls_temp


end function

on u_cpr_page_base.create
this.cb_configure_tab=create cb_configure_tab
this.Control[]={this.cb_configure_tab}
end on

on u_cpr_page_base.destroy
destroy(this.cb_configure_tab)
end on

event constructor;if config_mode then
	cb_configure_tab.visible = true
else
	cb_configure_tab.visible = false
end if

end event

type cb_configure_tab from commandbutton within u_cpr_page_base
boolean visible = false
integer width = 562
integer height = 56
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Configure Tab"
end type

event clicked;f_configure_chart_page(this_section.chart_id, this_section.section_id, this_section.page[this_page].page_id)

end event

