$PBExportHeader$w_treatment_vs_results.srw
forward
global type w_treatment_vs_results from w_window_base
end type
type pb_done from u_picture_button within w_treatment_vs_results
end type
type pb_cancel from u_picture_button within w_treatment_vs_results
end type
type uo_display from u_treatment_vs_results within w_treatment_vs_results
end type
type cb_ok from commandbutton within w_treatment_vs_results
end type
type st_title from statictext within w_treatment_vs_results
end type
end forward

global type w_treatment_vs_results from w_window_base
integer x = 0
integer y = 0
integer width = 2926
integer height = 1832
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = 33538240
pb_done pb_done
pb_cancel pb_cancel
uo_display uo_display
cb_ok cb_ok
st_title st_title
end type
global w_treatment_vs_results w_treatment_vs_results

type variables
long problem_id
string observation_id
end variables

on w_treatment_vs_results.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.uo_display=create uo_display
this.cb_ok=create cb_ok
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.uo_display
this.Control[iCurrent+4]=this.cb_ok
this.Control[iCurrent+5]=this.st_title
end on

on w_treatment_vs_results.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.uo_display)
destroy(this.cb_ok)
destroy(this.st_title)
end on

event open;call super::open;str_popup popup
str_popup_return popup_return

popup = message.powerobjectparm

if popup.data_row_count <> 2 then
	log.log(this, "open", "Invalid Arguments", 4)
	close(this)
	return
end if

problem_id = long(popup.items[1])
observation_id = popup.items[2]
st_title.text = popup.title

uo_display.initialize(problem_id, observation_id)

postevent("post_open")



end event

event post_open;
uo_display.refresh()


end event

type pb_done from u_picture_button within w_treatment_vs_results
boolean visible = false
integer x = 2569
integer y = 1552
integer taborder = 10
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;close(parent)

end event

type pb_cancel from u_picture_button within w_treatment_vs_results
boolean visible = false
integer x = 82
integer y = 1552
integer taborder = 30
boolean bringtotop = true
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

type uo_display from u_treatment_vs_results within w_treatment_vs_results
integer x = 169
integer y = 112
integer height = 1528
integer taborder = 20
boolean bringtotop = true
end type

on uo_display.destroy
call u_treatment_vs_results::destroy
end on

type cb_ok from commandbutton within w_treatment_vs_results
integer x = 2587
integer y = 1676
integer width = 247
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;close(parent)

end event

type st_title from statictext within w_treatment_vs_results
integer width = 2926
integer height = 96
boolean bringtotop = true
integer textsize = -14
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "none"
alignment alignment = center!
boolean focusrectangle = false
end type

