$PBExportHeader$u_tabpage_dbmaint_backup.sru
forward
global type u_tabpage_dbmaint_backup from u_tabpage
end type
type cb_backup from commandbutton within u_tabpage_dbmaint_backup
end type
type st_filename from statictext within u_tabpage_dbmaint_backup
end type
type st_filename_title from statictext within u_tabpage_dbmaint_backup
end type
type mle_comment from multilineedit within u_tabpage_dbmaint_backup
end type
type st_comment_title from statictext within u_tabpage_dbmaint_backup
end type
type st_by from statictext within u_tabpage_dbmaint_backup
end type
type st_by_title from statictext within u_tabpage_dbmaint_backup
end type
type pb_down from u_picture_button within u_tabpage_dbmaint_backup
end type
type dw_backup from u_dw_pick_list within u_tabpage_dbmaint_backup
end type
type pb_up from u_picture_button within u_tabpage_dbmaint_backup
end type
type st_page from statictext within u_tabpage_dbmaint_backup
end type
type st_backup_title from statictext within u_tabpage_dbmaint_backup
end type
end forward

global type u_tabpage_dbmaint_backup from u_tabpage
integer width = 2834
string text = "Backup"
cb_backup cb_backup
st_filename st_filename
st_filename_title st_filename_title
mle_comment mle_comment
st_comment_title st_comment_title
st_by st_by
st_by_title st_by_title
pb_down pb_down
dw_backup dw_backup
pb_up pb_up
st_page st_page
st_backup_title st_backup_title
end type
global u_tabpage_dbmaint_backup u_tabpage_dbmaint_backup

forward prototypes
public function integer initialize ()
public subroutine refresh ()
end prototypes

public function integer initialize ();dw_backup.settransobject(sqlca)

Return 1
end function

public subroutine refresh ();long ll_rows

// cases where we disconnect and connect to db
// so initialize the trans object every refresh
dw_backup.settransobject(sqlca)
dw_backup.reset()
ll_rows = dw_backup.retrieve('backup')
If ll_rows > 0 Then
	dw_backup.last_page = 0
	dw_backup.set_page(0,pb_up,pb_down,st_page)
	dw_backup.object.selected_flag[1] = 1
	dw_backup.event selected(1)
End If


end subroutine

on u_tabpage_dbmaint_backup.create
int iCurrent
call super::create
this.cb_backup=create cb_backup
this.st_filename=create st_filename
this.st_filename_title=create st_filename_title
this.mle_comment=create mle_comment
this.st_comment_title=create st_comment_title
this.st_by=create st_by
this.st_by_title=create st_by_title
this.pb_down=create pb_down
this.dw_backup=create dw_backup
this.pb_up=create pb_up
this.st_page=create st_page
this.st_backup_title=create st_backup_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_backup
this.Control[iCurrent+2]=this.st_filename
this.Control[iCurrent+3]=this.st_filename_title
this.Control[iCurrent+4]=this.mle_comment
this.Control[iCurrent+5]=this.st_comment_title
this.Control[iCurrent+6]=this.st_by
this.Control[iCurrent+7]=this.st_by_title
this.Control[iCurrent+8]=this.pb_down
this.Control[iCurrent+9]=this.dw_backup
this.Control[iCurrent+10]=this.pb_up
this.Control[iCurrent+11]=this.st_page
this.Control[iCurrent+12]=this.st_backup_title
end on

on u_tabpage_dbmaint_backup.destroy
call super::destroy
destroy(this.cb_backup)
destroy(this.st_filename)
destroy(this.st_filename_title)
destroy(this.mle_comment)
destroy(this.st_comment_title)
destroy(this.st_by)
destroy(this.st_by_title)
destroy(this.pb_down)
destroy(this.dw_backup)
destroy(this.pb_up)
destroy(this.st_page)
destroy(this.st_backup_title)
end on

type cb_backup from commandbutton within u_tabpage_dbmaint_backup
integer x = 1586
integer y = 1272
integer width = 622
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Backup"
end type

event clicked;str_popup			popup

popup.title = "Backup database "+sqlca.database+" from server "+sqlca.servername
openwithparm(w_new_backup, popup)

refresh()

end event

type st_filename from statictext within u_tabpage_dbmaint_backup
integer x = 1650
integer y = 896
integer width = 1097
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type st_filename_title from statictext within u_tabpage_dbmaint_backup
integer x = 1070
integer y = 896
integer width = 567
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Backup Filename:"
alignment alignment = right!
boolean focusrectangle = false
end type

type mle_comment from multilineedit within u_tabpage_dbmaint_backup
integer x = 1650
integer y = 424
integer width = 1074
integer height = 400
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean autovscroll = true
boolean displayonly = true
end type

type st_comment_title from statictext within u_tabpage_dbmaint_backup
integer x = 1070
integer y = 424
integer width = 567
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Comment:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_by from statictext within u_tabpage_dbmaint_backup
integer x = 1650
integer y = 280
integer width = 1074
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type st_by_title from statictext within u_tabpage_dbmaint_backup
integer x = 1070
integer y = 280
integer width = 567
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Backed Up By:"
alignment alignment = right!
boolean focusrectangle = false
end type

type pb_down from u_picture_button within u_tabpage_dbmaint_backup
boolean visible = false
integer x = 777
integer y = 368
integer width = 137
integer height = 116
integer taborder = 20
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_backup.current_page
li_last_page = dw_backup.last_page

dw_backup.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true


end event

type dw_backup from u_dw_pick_list within u_tabpage_dbmaint_backup
integer x = 215
integer y = 232
integer height = 1132
integer taborder = 10
string dataobject = "dw_database_backups"
boolean border = false
end type

event selected(long selected_row);call super::selected;st_by.text = dw_backup.object.logon_id[selected_row]
mle_comment.text = dw_backup.object.comment[selected_row]
st_filename.text = dw_backup.object.action_argument[selected_row]
end event

event unselected(long unselected_row);call super::unselected;st_by.text = ""
mle_comment.text = ""
st_filename.text = ""
end event

type pb_up from u_picture_button within u_tabpage_dbmaint_backup
boolean visible = false
integer x = 777
integer y = 236
integer width = 137
integer height = 116
integer taborder = 10
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_backup.current_page

dw_backup.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type st_page from statictext within u_tabpage_dbmaint_backup
integer x = 773
integer y = 160
integer width = 306
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99/99"
boolean focusrectangle = false
end type

type st_backup_title from statictext within u_tabpage_dbmaint_backup
integer x = 215
integer y = 152
integer width = 558
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Backup History"
alignment alignment = center!
boolean focusrectangle = false
end type

