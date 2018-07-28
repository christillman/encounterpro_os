HA$PBExportHeader$w_pop_display_sql_results.srw
forward
global type w_pop_display_sql_results from w_window_base
end type
type dw_pick from u_dw_pick_list within w_pop_display_sql_results
end type
type st_title from statictext within w_pop_display_sql_results
end type
type cb_ok from commandbutton within w_pop_display_sql_results
end type
type mle_error from multilineedit within w_pop_display_sql_results
end type
type st_rowcount from statictext within w_pop_display_sql_results
end type
type cb_final_sql from commandbutton within w_pop_display_sql_results
end type
type str_point from structure within w_pop_display_sql_results
end type
end forward

type str_point from structure
	long		x
	long		y
end type

global type w_pop_display_sql_results from w_window_base
integer width = 2962
integer height = 1864
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
dw_pick dw_pick
st_title st_title
cb_ok cb_ok
mle_error mle_error
st_rowcount st_rowcount
cb_final_sql cb_final_sql
end type
global w_pop_display_sql_results w_pop_display_sql_results

type prototypes
SUBROUTINE GetCursorPos( ref str_point lppt ) LIBRARY "USER32.DLL" alias for "GetCursorPos;Ansi"

end prototypes

type variables
str_sql_context sql_context
end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();integer li_sts
blob lbl_report
long ll_count

ll_count = f_resolve_sql(sql_context)

st_title.text = sql_context.script_name
st_rowcount.text = string(ll_count)
mle_error.text = sql_context.error

if not isnull(sql_context.data) and isvalid(sql_context.data) then
	li_sts = sql_context.data.getfullstate(lbl_report)
	if li_sts < 0 then
		log.log(this, "display_report()", "Error getting report state", 4)
		mle_error.text = "Error getting datawindow state"
		return -1
	end if
	
	dw_pick.setfullstate(lbl_report)
else
	dw_pick.reset()
end if


end function

event open;call super::open;
sql_context = message.powerobjectparm

postevent("post_open")

end event

on w_pop_display_sql_results.create
int iCurrent
call super::create
this.dw_pick=create dw_pick
this.st_title=create st_title
this.cb_ok=create cb_ok
this.mle_error=create mle_error
this.st_rowcount=create st_rowcount
this.cb_final_sql=create cb_final_sql
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_pick
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.cb_ok
this.Control[iCurrent+4]=this.mle_error
this.Control[iCurrent+5]=this.st_rowcount
this.Control[iCurrent+6]=this.cb_final_sql
end on

on w_pop_display_sql_results.destroy
call super::destroy
destroy(this.dw_pick)
destroy(this.st_title)
destroy(this.cb_ok)
destroy(this.mle_error)
destroy(this.st_rowcount)
destroy(this.cb_final_sql)
end on

event post_open;call super::post_open;

refresh()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_pop_display_sql_results
integer x = 2866
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pop_display_sql_results
end type

type dw_pick from u_dw_pick_list within w_pop_display_sql_results
integer x = 18
integer y = 120
integer width = 2894
integer height = 1308
integer taborder = 10
string dataobject = "dw_pick_generic"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
borderstyle borderstyle = stylelowered!
end type

type st_title from statictext within w_pop_display_sql_results
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

type cb_ok from commandbutton within w_pop_display_sql_results
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

type mle_error from multilineedit within w_pop_display_sql_results
integer x = 18
integer y = 1444
integer width = 2267
integer height = 352
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean vscrollbar = true
boolean autovscroll = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_rowcount from statictext within w_pop_display_sql_results
integer x = 2400
integer y = 1440
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean focusrectangle = false
end type

type cb_final_sql from commandbutton within w_pop_display_sql_results
integer x = 2409
integer y = 1520
integer width = 389
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Final SQL"
end type

event clicked;string ls_file
integer li_sts
blob lbl_sql

ls_file = f_temp_file("sql")

lbl_sql = f_string_to_blob(sql_context.final_sql, "UTF-8")

li_sts = log.file_write(lbl_sql, ls_file)

f_open_file(ls_file, false)

end event

