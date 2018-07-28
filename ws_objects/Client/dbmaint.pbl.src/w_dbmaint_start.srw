$PBExportHeader$w_dbmaint_start.srw
forward
global type w_dbmaint_start from window
end type
type st_1 from statictext within w_dbmaint_start
end type
type cb_new from commandbutton within w_dbmaint_start
end type
type dw_databases from u_dw_pick_list within w_dbmaint_start
end type
type cb_cancel from commandbutton within w_dbmaint_start
end type
type st_version from statictext within w_dbmaint_start
end type
end forward

global type w_dbmaint_start from window
integer x = 174
integer y = 160
integer width = 2158
integer height = 1472
windowtype windowtype = response!
long backcolor = 33538240
st_1 st_1
cb_new cb_new
dw_databases dw_databases
cb_cancel cb_cancel
st_version st_version
end type
global w_dbmaint_start w_dbmaint_start

type variables
//string default_database = "<Default>"

//string dbkey

//string selected_database

end variables

forward prototypes
public function integer get_databases ()
public subroutine add_database (string ps_database)
public subroutine add_empty_database (string ps_database)
end prototypes

public function integer get_databases ();string ls_sections[]
integer ll_count
long ll_row
integer li_sts
integer i
string ls_database
string ls_sql
u_ds_data luo_data
long ll_db_count
long ll_is_dbo
integer li_wait_index

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_sysdatabases")
ll_count = luo_data.retrieve()
if ll_count < 0 then return -1


li_wait_index = f_please_wait_open()

f_please_wait_progress_bar(li_wait_index, 0, ll_count)

for i = 1 to ll_count
	ls_database = luo_data.object.name[i]
	
	ls_sql = "USE " + ls_database
	EXECUTE IMMEDIATE :ls_sql;
	if sqlca.sqlcode = 0 then
		
		SELECT count(*)
		INTO :ll_db_count
		FROM sys.tables;
		if sqlca.sqlcode = 0 then
			if ll_db_count = 0 then
				add_empty_database(ls_database)
			else
				SELECT is_member('db_owner')
				INTO :ll_is_dbo
				FROM sys.tables
				WHERE name = 'c_database_status';
				if sqlca.sqlcode = 0 then
					if sqlca.sqlnrows = 1 and ll_is_dbo = 1 then
						add_database(ls_database)
					end if
				end if
			end if
		end if
	end if
	f_please_wait_progress_bar(li_wait_index, i, ll_count)
next

f_please_wait_close(li_wait_index)

return 1

end function

public subroutine add_database (string ps_database);long ll_customer_id
long ll_modification_level
string ls_customername
long ll_row
string ls_practice_user_id

SELECT customer_id, modification_level
INTO :ll_customer_id, :ll_modification_level
FROM c_Database_Status;
if not sqlca.check() then return

if ll_modification_level >= 135 then
	ls_practice_user_id = f_practice_user_id()
end if

if len(ls_practice_user_id) > 0 then
	SELECT user_full_name
	INTO :ls_customername
	FROM c_User
	WHERE user_id = :ls_practice_user_id;
	if not sqlca.check() then return
else
	ls_customername = "Customer # " + string(ll_customer_id)
end if



ll_row = dw_databases.insertrow(0)

dw_databases.object.customername[ll_row] = ls_customername
dw_databases.object.databasename[ll_row] = ps_database
dw_databases.object.modification_level[ll_row] = ll_modification_level
dw_databases.object.customer_id[ll_row] = ll_customer_id


return

end subroutine

public subroutine add_empty_database (string ps_database);long ll_customer_id
long ll_modification_level
string ls_customername
long ll_row


ll_row = dw_databases.insertrow(0)

dw_databases.object.customername[ll_row] = "Empty Database"
dw_databases.object.databasename[ll_row] = ps_database



return

end subroutine

on w_dbmaint_start.create
this.st_1=create st_1
this.cb_new=create cb_new
this.dw_databases=create dw_databases
this.cb_cancel=create cb_cancel
this.st_version=create st_version
this.Control[]={this.st_1,&
this.cb_new,&
this.dw_databases,&
this.cb_cancel,&
this.st_version}
end on

on w_dbmaint_start.destroy
destroy(this.st_1)
destroy(this.cb_new)
destroy(this.dw_databases)
destroy(this.cb_cancel)
destroy(this.st_version)
end on

event open;
dw_databases.settransobject(sqlca)

get_databases()

end event

type st_1 from statictext within w_dbmaint_start
integer width = 1577
integer height = 92
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "EncounterPRO Databases"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_new from commandbutton within w_dbmaint_start
boolean visible = false
integer x = 1618
integer y = 648
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

//new_db(ls_dbkey, popup_return.items[1], popup_return.items[2], popup_return.items[3], popup_return.items[4])

end event

type dw_databases from u_dw_pick_list within w_dbmaint_start
integer x = 178
integer y = 96
integer width = 1317
integer height = 1356
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_epro_database"
boolean vscrollbar = true
boolean border = false
end type

event post_click;call super::post_click;string ls_database
long ll_modification_level
long ll_customer_id
str_popup_return popup_return
integer li_sts
string ls_message

ls_database = object.databasename[clicked_row]
ll_modification_level = object.modification_level[clicked_row]
ll_customer_id = object.customer_id[clicked_row]

li_sts = sqlca.set_database(ls_database)
if li_sts <= 0 then
	openwithparm(w_pop_message, "Error setting database")
	return
end if
if not sqlca.is_dbo then
	ls_message = "You are not logged in as a DBO in the " + ls_database + " database."
	ls_message += "  Only a DBO may use the Database Maintenance utilities."
	openwithparm(w_pop_message, ls_message)
	halt CLOSE
end if


if isnull(ll_modification_level) or isnull(ll_customer_id) then
	// Empty Database
	openwithparm(w_pop_yes_no, "Do you want to install the EncounterPRO objects into the empty database ~"" + ls_database + "~"?")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return
	
	
	openwithparm(w_pop_message, "Not supported yet")
	return
else
	closewithreturn(parent, ls_database)
end if


end event

type cb_cancel from commandbutton within w_dbmaint_start
event clicked pbm_bnclicked
integer x = 1618
integer y = 1256
integer width = 402
integer height = 124
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;closewithreturn(parent, "")

end event

type st_version from statictext within w_dbmaint_start
integer x = 1568
integer y = 12
integer width = 571
integer height = 148
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Version"
alignment alignment = center!
boolean focusrectangle = false
end type

