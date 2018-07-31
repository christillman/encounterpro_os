$PBExportHeader$w_pop_which_database.srw
forward
global type w_pop_which_database from window
end type
type cb_1 from commandbutton within w_pop_which_database
end type
type pb_1 from u_pb_help_button within w_pop_which_database
end type
type st_version from statictext within w_pop_which_database
end type
type st_office_id_title from statictext within w_pop_which_database
end type
type st_office_id from statictext within w_pop_which_database
end type
type cb_delete from commandbutton within w_pop_which_database
end type
type cb_edit from commandbutton within w_pop_which_database
end type
type cb_new from commandbutton within w_pop_which_database
end type
type st_db from statictext within w_pop_which_database
end type
type st_server from statictext within w_pop_which_database
end type
type st_db_title from statictext within w_pop_which_database
end type
type st_server_title from statictext within w_pop_which_database
end type
type dw_databases from u_dw_pick_list within w_pop_which_database
end type
type cb_cancel from commandbutton within w_pop_which_database
end type
type cb_ok from commandbutton within w_pop_which_database
end type
type st_dbms_title from statictext within w_pop_which_database
end type
type st_dbms from statictext within w_pop_which_database
end type
end forward

global type w_pop_which_database from window
integer x = 174
integer y = 160
integer width = 2962
integer height = 1472
windowtype windowtype = response!
long backcolor = 33538240
cb_1 cb_1
pb_1 pb_1
st_version st_version
st_office_id_title st_office_id_title
st_office_id st_office_id
cb_delete cb_delete
cb_edit cb_edit
cb_new cb_new
st_db st_db
st_server st_server
st_db_title st_db_title
st_server_title st_server_title
dw_databases dw_databases
cb_cancel cb_cancel
cb_ok cb_ok
st_dbms_title st_dbms_title
st_dbms st_dbms
end type
global w_pop_which_database w_pop_which_database

type variables
string default_database = "<Default>"

string dbkey

string selected_database

end variables

forward prototypes
public subroutine db_selected (long pl_row)
public function integer get_databases ()
public subroutine update_db (string ps_subkey, string ps_dbms, string ps_dbserver, string ps_dbname, string ps_office_id)
public subroutine new_db (string ps_new_database, string ps_dbms, string ps_dbserver, string ps_dbname, string ps_office_id)
end prototypes

public subroutine db_selected (long pl_row);integer li_sts

selected_database = dw_databases.object.database[pl_row]

st_server.text = profilestring(ini_file, selected_database, "dbserver", "")
st_db.text = profilestring(ini_file, selected_database, "dbname", "")
//st_dbms.text = profilestring(ini_file, selected_database, "dbms", "")
st_office_id.text = profilestring(ini_file, selected_database, "office_id", "")

if selected_database = default_database then
	cb_delete.enabled = false
else
	cb_delete.enabled = true
end if

dw_databases.clear_selected()
dw_databases.object.selected_flag[pl_row] = 1


end subroutine

public function integer get_databases ();string ls_sections[]
integer li_section_count
long ll_row
integer li_sts
integer i

li_section_count = f_ini_get_sections(ini_file, ls_sections)

dw_databases.reset()

// Add the default database at the top so it always exists
ll_row = dw_databases.insertrow(0)
dw_databases.object.database[ll_row] = default_database
db_selected(ll_row)

// Now add the other items from EncounterPRO.ini
for i = 1 to li_section_count
	// Don't repeat the default database
	if ls_sections[i] = default_database then continue
	
	// Don't show the <LogSystem>
	if lower(ls_sections[i]) = "<logsystem>" then continue
	
	ll_row = dw_databases.insertrow(0)
	dw_databases.object.database[ll_row] = ls_sections[i]
next


return 1

end function

public subroutine update_db (string ps_subkey, string ps_dbms, string ps_dbserver, string ps_dbname, string ps_office_id);integer li_sts
string ls_find
long ll_row

SetProfileString ( ini_file, selected_database, "dbserver", ps_dbserver )
SetProfileString ( ini_file, selected_database, "dbname", ps_dbname )
//SetProfileString ( ini_file, selected_database, "dbms", ps_dbms )
SetProfileString ( ini_file, selected_database, "office_id", ps_office_id )

get_databases()

if isnull(ps_subkey) then
	db_selected(1)
else
	ls_find = "database='" + ps_subkey + "'"
	ll_row = dw_databases.find(ls_find, 1, dw_databases.rowcount())
	if ll_row <= 0 then return
	
	db_selected(ll_row)
end if

end subroutine

public subroutine new_db (string ps_new_database, string ps_dbms, string ps_dbserver, string ps_dbname, string ps_office_id);integer li_sts
string ls_find
long ll_row


SetProfileString ( ini_file, ps_new_database, "dbserver", ps_dbserver )
SetProfileString ( ini_file, ps_new_database, "dbname", ps_dbname )
SetProfileString ( ini_file, ps_new_database, "dbms", ps_dbms )
SetProfileString ( ini_file, ps_new_database, "office_id", ps_office_id )

get_databases()

ls_find = "database='" + ps_new_database + "'"
ll_row = dw_databases.find(ls_find, 1, dw_databases.rowcount())
if ll_row <= 0 then return

db_selected(ll_row)

end subroutine

on w_pop_which_database.create
this.cb_1=create cb_1
this.pb_1=create pb_1
this.st_version=create st_version
this.st_office_id_title=create st_office_id_title
this.st_office_id=create st_office_id
this.cb_delete=create cb_delete
this.cb_edit=create cb_edit
this.cb_new=create cb_new
this.st_db=create st_db
this.st_server=create st_server
this.st_db_title=create st_db_title
this.st_server_title=create st_server_title
this.dw_databases=create dw_databases
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.st_dbms_title=create st_dbms_title
this.st_dbms=create st_dbms
this.Control[]={this.cb_1,&
this.pb_1,&
this.st_version,&
this.st_office_id_title,&
this.st_office_id,&
this.cb_delete,&
this.cb_edit,&
this.cb_new,&
this.st_db,&
this.st_server,&
this.st_db_title,&
this.st_server_title,&
this.dw_databases,&
this.cb_cancel,&
this.cb_ok,&
this.st_dbms_title,&
this.st_dbms}
end on

on w_pop_which_database.destroy
destroy(this.cb_1)
destroy(this.pb_1)
destroy(this.st_version)
destroy(this.st_office_id_title)
destroy(this.st_office_id)
destroy(this.cb_delete)
destroy(this.cb_edit)
destroy(this.cb_new)
destroy(this.st_db)
destroy(this.st_server)
destroy(this.st_db_title)
destroy(this.st_server_title)
destroy(this.dw_databases)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.st_dbms_title)
destroy(this.st_dbms)
end on

event open;st_version.text = "Version  " + f_app_version()

dbkey = registry_key + "\Database"

get_databases()

end event

type cb_1 from commandbutton within w_pop_which_database
integer x = 1646
integer y = 1116
integer width = 329
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Other DB"
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_dbkey

popup.data_row_count = 0

popup.title = "Other Database"

openwithparm(w_new_db, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 4 then return

ls_dbkey = popup_return.items[2] + "|" + popup_return.items[3]

closewithreturn(parent, ls_dbkey)

end event

type pb_1 from u_pb_help_button within w_pop_which_database
integer x = 2025
integer y = 1304
integer width = 247
integer height = 120
integer taborder = 50
end type

type st_version from statictext within w_pop_which_database
integer x = 1426
integer y = 24
integer width = 992
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Version"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_office_id_title from statictext within w_pop_which_database
integer x = 1285
integer y = 444
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
string text = "Office ID:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_office_id from statictext within w_pop_which_database
integer x = 1673
integer y = 444
integer width = 1166
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type cb_delete from commandbutton within w_pop_which_database
integer x = 2057
integer y = 996
integer width = 402
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete DB"
end type

event clicked;str_popup_return popup_return
string ls_key
integer li_sts

ls_key = dbkey
if selected_database <> default_database then
	ls_key += "\" + selected_database
end if


openwithparm(w_pop_yes_no, "Are you sure you wish to delete '" + selected_database + "'?")
popup_return = message.powerobjectparm
if isnull(popup_return.item) or popup_return.item <> "YES" then return

li_sts = f_ini_delete_section(ini_file, selected_database)

setnull(selected_database)
get_databases()

end event

type cb_edit from commandbutton within w_pop_which_database
integer x = 2057
integer y = 856
integer width = 402
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Edit DB"
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.data_row_count = 4


popup.items[1] = st_dbms.text
popup.items[2] = st_server.text
popup.items[3] = st_db.text
popup.items[4] = st_office_id.text

popup.title = selected_database

openwithparm(w_new_db, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 4 then return

update_db(selected_database, popup_return.items[1], popup_return.items[2], popup_return.items[3], popup_return.items[4])

end event

type cb_new from commandbutton within w_pop_which_database
integer x = 2057
integer y = 716
integer width = 402
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New DB"
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_dbkey

popup.data_row_count = 0


popup.title = "Enter Database Description"
popup.item = ""
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count < 1 then return

ls_dbkey = popup_return.items[1]

popup.title = ls_dbkey

openwithparm(w_new_db, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 4 then return

new_db(ls_dbkey, popup_return.items[1], popup_return.items[2], popup_return.items[3], popup_return.items[4])

end event

type st_db from statictext within w_pop_which_database
integer x = 1673
integer y = 316
integer width = 1166
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_server from statictext within w_pop_which_database
integer x = 1673
integer y = 188
integer width = 1166
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_db_title from statictext within w_pop_which_database
integer x = 1285
integer y = 316
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
string text = "Database:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_server_title from statictext within w_pop_which_database
integer x = 1285
integer y = 188
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

type dw_databases from u_dw_pick_list within w_pop_which_database
integer x = 14
integer y = 16
integer width = 1253
integer height = 1408
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_database_list"
boolean vscrollbar = true
boolean border = false
end type

event post_click;call super::post_click;db_selected(lastrow)

end event

type cb_cancel from commandbutton within w_pop_which_database
event clicked pbm_bnclicked
integer x = 1701
integer y = 1296
integer width = 251
integer height = 124
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;closewithreturn(parent, "")

end event

type cb_ok from commandbutton within w_pop_which_database
integer x = 2336
integer y = 1296
integer width = 430
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

event clicked;
closewithreturn(parent, selected_database)

end event

type st_dbms_title from statictext within w_pop_which_database
integer x = 1285
integer y = 572
integer width = 325
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "DBMS:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_dbms from statictext within w_pop_which_database
integer x = 1673
integer y = 572
integer width = 1166
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "SQL Native Client"
boolean border = true
boolean focusrectangle = false
end type

