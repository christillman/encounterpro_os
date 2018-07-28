HA$PBExportHeader$w_connect_to_server.srw
forward
global type w_connect_to_server from window
end type
type cb_cancel from commandbutton within w_connect_to_server
end type
type st_title from statictext within w_connect_to_server
end type
type sle_pw from singlelineedit within w_connect_to_server
end type
type st_1 from statictext within w_connect_to_server
end type
type sle_username from singlelineedit within w_connect_to_server
end type
type rb_sql from radiobutton within w_connect_to_server
end type
type rb_windows from radiobutton within w_connect_to_server
end type
type st_db_title from statictext within w_connect_to_server
end type
type st_server_title from statictext within w_connect_to_server
end type
type cb_ok from commandbutton within w_connect_to_server
end type
type ddlb_servers from dropdownlistbox within w_connect_to_server
end type
end forward

global type w_connect_to_server from window
integer x = 174
integer y = 160
integer width = 1614
integer height = 1016
windowtype windowtype = response!
long backcolor = 33538240
cb_cancel cb_cancel
st_title st_title
sle_pw sle_pw
st_1 st_1
sle_username sle_username
rb_sql rb_sql
rb_windows rb_windows
st_db_title st_db_title
st_server_title st_server_title
cb_ok cb_ok
ddlb_servers ddlb_servers
end type
global w_connect_to_server w_connect_to_server

type variables
string serverfile

end variables

forward prototypes
public function integer connect_to_server ()
public subroutine get_servers ()
end prototypes

public function integer connect_to_server ();integer li_sts
long ll_is_dbo

if rb_windows.checked then
	li_sts = sqlca.dbmaint_connect_windows(ddlb_servers.text)
else
	li_sts = sqlca.dbmaint_connect_sql(ddlb_servers.text, sle_username.text, sle_pw.text)
end if

if li_sts <= 0 then
	openwithparm(w_pop_message, "Connection failed")
	return li_sts
end if

return 1



end function

public subroutine get_servers ();string ls_sections[]
integer li_section_count
long ll_row
integer li_sts
integer i
string ls_lastused
datetime ldt_date
datetime ldt_most_recent_date
string ls_most_recent_server

setnull(ldt_most_recent_date)

serverfile = program_directory + "\servers.ini"
if not fileexists(serverfile) then return

li_section_count = f_ini_get_sections(serverfile, ls_sections)

// Load the previously used servers
for i = 1 to li_section_count
	ddlb_servers.additem(ls_sections[i])
	ls_lastused = profilestring(serverfile, ls_sections[i], "lastused", "1/1/1900")
	ldt_date = f_string_to_datetime(ls_lastused)
	if ldt_date > ldt_most_recent_date or isnull(ldt_most_recent_date) then
		ldt_most_recent_date = ldt_date
		ls_most_recent_server = ls_sections[i]
	end if
next

ddlb_servers.text = ls_most_recent_server


end subroutine

on w_connect_to_server.create
this.cb_cancel=create cb_cancel
this.st_title=create st_title
this.sle_pw=create sle_pw
this.st_1=create st_1
this.sle_username=create sle_username
this.rb_sql=create rb_sql
this.rb_windows=create rb_windows
this.st_db_title=create st_db_title
this.st_server_title=create st_server_title
this.cb_ok=create cb_ok
this.ddlb_servers=create ddlb_servers
this.Control[]={this.cb_cancel,&
this.st_title,&
this.sle_pw,&
this.st_1,&
this.sle_username,&
this.rb_sql,&
this.rb_windows,&
this.st_db_title,&
this.st_server_title,&
this.cb_ok,&
this.ddlb_servers}
end on

on w_connect_to_server.destroy
destroy(this.cb_cancel)
destroy(this.st_title)
destroy(this.sle_pw)
destroy(this.st_1)
destroy(this.sle_username)
destroy(this.rb_sql)
destroy(this.rb_windows)
destroy(this.st_db_title)
destroy(this.st_server_title)
destroy(this.cb_ok)
destroy(this.ddlb_servers)
end on

event open;
get_servers()

end event

type cb_cancel from commandbutton within w_connect_to_server
integer x = 114
integer y = 840
integer width = 585
integer height = 124
integer taborder = 30
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;close(parent)

end event

type st_title from statictext within w_connect_to_server
integer width = 1614
integer height = 120
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Connect to Server"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_pw from singlelineedit within w_connect_to_server
integer x = 462
integer y = 664
integer width = 864
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
boolean password = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_connect_to_server
integer x = 123
integer y = 676
integer width = 325
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Password:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_username from singlelineedit within w_connect_to_server
integer x = 462
integer y = 508
integer width = 864
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type rb_sql from radiobutton within w_connect_to_server
integer x = 457
integer y = 376
integer width = 722
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "SQL Authentication"
end type

event clicked;if checked then
	sle_username.enabled = true
	sle_pw.enabled = true
	sle_username.selecttext( 1, len(sle_username.text))
	sle_username.setfocus()
else
	sle_username.enabled = false
	sle_pw.enabled = false
end if

end event

type rb_windows from radiobutton within w_connect_to_server
integer x = 457
integer y = 264
integer width = 722
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Windows Authentication"
boolean checked = true
end type

event clicked;if checked then
	sle_username.enabled = false
	sle_pw.enabled = false
else
	sle_username.enabled = true
	sle_pw.enabled = true
end if

end event

type st_db_title from statictext within w_connect_to_server
integer x = 128
integer y = 528
integer width = 325
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Username:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_server_title from statictext within w_connect_to_server
integer x = 128
integer y = 144
integer width = 325
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Server:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_connect_to_server
integer x = 905
integer y = 840
integer width = 585
integer height = 124
integer taborder = 20
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;blob lbl_file

if connect_to_server() > 0 then
	if not fileexists(serverfile) then
		lbl_file = blob("")
		log.file_write(lbl_file, serverfile)
	end if
	
	SetProfileString ( serverfile, sqlca.servername, "lastused", string(datetime(today(), now())) )
	close(parent)
end if


end event

type ddlb_servers from dropdownlistbox within w_connect_to_server
integer x = 462
integer y = 136
integer width = 864
integer height = 668
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean allowedit = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

