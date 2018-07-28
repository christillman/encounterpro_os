$PBExportHeader$u_tabpage_dbmaint_scripts.sru
forward
global type u_tabpage_dbmaint_scripts from u_tabpage
end type
type cb_execute_all from commandbutton within u_tabpage_dbmaint_scripts
end type
type cb_execute_new from commandbutton within u_tabpage_dbmaint_scripts
end type
type st_2 from statictext within u_tabpage_dbmaint_scripts
end type
type st_script_comment from statictext within u_tabpage_dbmaint_scripts
end type
type cb_save_as from commandbutton within u_tabpage_dbmaint_scripts
end type
type st_1 from statictext within u_tabpage_dbmaint_scripts
end type
type dw_scripts from u_dw_pick_list within u_tabpage_dbmaint_scripts
end type
type cb_execute from commandbutton within u_tabpage_dbmaint_scripts
end type
type st_script_title from statictext within u_tabpage_dbmaint_scripts
end type
type st_asterisk from statictext within u_tabpage_dbmaint_scripts
end type
type st_do_not_run from statictext within u_tabpage_dbmaint_scripts
end type
end forward

global type u_tabpage_dbmaint_scripts from u_tabpage
integer width = 2898
string text = "Updates"
cb_execute_all cb_execute_all
cb_execute_new cb_execute_new
st_2 st_2
st_script_comment st_script_comment
cb_save_as cb_save_as
st_1 st_1
dw_scripts dw_scripts
cb_execute cb_execute
st_script_title st_script_title
st_asterisk st_asterisk
st_do_not_run st_do_not_run
end type
global u_tabpage_dbmaint_scripts u_tabpage_dbmaint_scripts

type variables
string script_type

long script_id
string script_name
integer allow_users


end variables

forward prototypes
public subroutine refresh ()
public function integer initialize (string ps_key)
end prototypes

public subroutine refresh ();long ll_count
string ls_count
long ll_first_row_on_page
long ll_new_first_row_on_page
long ll_last
long i
datetime ldt_last_scripts_update
long ll_null

setnull(ll_null)

dw_scripts.height = this.height - dw_scripts.y - 170
st_do_not_run.y = this.height - 150
st_asterisk.y = st_do_not_run.y + 8

// Utility scripts
ll_first_row_on_page = long(dw_scripts.object.DataWindow.FirstRowOnPage)

dw_scripts.settransobject(sqlca)
ll_count = dw_scripts.retrieve(Script_type, sqlca.db_script_major_release, sqlca.db_script_database_version, ll_null)

i = 1
DO WHILE true
	i += 1
	ll_new_first_row_on_page = long(dw_scripts.object.DataWindow.FirstRowOnPage)
	if ll_new_first_row_on_page >= ll_first_row_on_page or ll_new_first_row_on_page <= 0 then exit
	if i > 20 and ll_new_first_row_on_page = ll_last then exit
	dw_scripts.scrolltorow(i)
	ll_last = ll_new_first_row_on_page
LOOP


cb_execute.enabled = false
cb_save_as.enabled = false
st_script_comment.text = ""

end subroutine

public function integer initialize (string ps_key);script_type = ps_key

text = wordcap(script_type) + " Scripts"
st_script_title.text = "Available " + text

if lower(script_type) <> "hotfix" then
	cb_execute_new.visible = false
	cb_execute_all.visible = false
	dw_scripts.setsort("script_name a, script_id a")
else
	dw_scripts.setsort("modification_level, script_id a")
end if

return 1


end function

on u_tabpage_dbmaint_scripts.create
int iCurrent
call super::create
this.cb_execute_all=create cb_execute_all
this.cb_execute_new=create cb_execute_new
this.st_2=create st_2
this.st_script_comment=create st_script_comment
this.cb_save_as=create cb_save_as
this.st_1=create st_1
this.dw_scripts=create dw_scripts
this.cb_execute=create cb_execute
this.st_script_title=create st_script_title
this.st_asterisk=create st_asterisk
this.st_do_not_run=create st_do_not_run
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_execute_all
this.Control[iCurrent+2]=this.cb_execute_new
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_script_comment
this.Control[iCurrent+5]=this.cb_save_as
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.dw_scripts
this.Control[iCurrent+8]=this.cb_execute
this.Control[iCurrent+9]=this.st_script_title
this.Control[iCurrent+10]=this.st_asterisk
this.Control[iCurrent+11]=this.st_do_not_run
end on

on u_tabpage_dbmaint_scripts.destroy
call super::destroy
destroy(this.cb_execute_all)
destroy(this.cb_execute_new)
destroy(this.st_2)
destroy(this.st_script_comment)
destroy(this.cb_save_as)
destroy(this.st_1)
destroy(this.dw_scripts)
destroy(this.cb_execute)
destroy(this.st_script_title)
destroy(this.st_asterisk)
destroy(this.st_do_not_run)
end on

type cb_execute_all from commandbutton within u_tabpage_dbmaint_scripts
integer x = 2272
integer y = 1260
integer width = 530
integer height = 112
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Execute All"
end type

event clicked;str_popup_return popup_return
integer li_sts
string ls_message
datetime ldt_last_executed
long ll_script_id
long i
integer li_allow_users

ls_message = "This will execute all hotfix scripts.  Are you sure you wish to do this?"
openwithparm(w_pop_yes_no, ls_message)
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

// See if there's a script that might lock out users
for i = 1 to dw_scripts.rowcount()
	li_allow_users = dw_scripts.object.allow_users[i]
	if li_allow_users = 0 then
		ls_message = "                                  *** WARNING ***~r~n"
		ls_message +=  "ONE OF THESE SCRIPT PERFORMS OPERATIONS WHICH MIGHT SERIOUSLY AFFECT THE PERFORMANCE OF ENCOUNTERPRO"
		ls_message += " AND SHOULD NOT BE EXECUTED WHILE USERS ARE IN THE SYSTEM.  ARE YOU ABSOLUTELY SURE YOU WANT"
		ls_message += " TO EXECUTE THESE SCRIPTS SCRIPT NOW?"
		openwithparm(w_pop_yes_no, ls_message)
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		exit
	end if
next

li_sts = sqlca.run_hotfixes(false)

if li_sts <= 0 then
	openwithparm(w_pop_message, "Executing Scripts Failed")
else
	openwithparm(w_pop_message, "Executing Scripts Succeeded")
end if

refresh()

end event

type cb_execute_new from commandbutton within u_tabpage_dbmaint_scripts
integer x = 2267
integer y = 1116
integer width = 530
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Execute All New"
end type

event clicked;str_popup_return popup_return
integer li_sts
string ls_message
datetime ldt_last_executed
long ll_script_id
long i
integer li_allow_users

ls_message = "This will execute all hotfix scripts which have not yet been executed.  Are you sure you wish to do this?"
openwithparm(w_pop_yes_no, ls_message)
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

// See if there's a script that might lock out users
for i = 1 to dw_scripts.rowcount()
	ldt_last_executed = dw_scripts.object.last_executed[i]
	li_allow_users = dw_scripts.object.allow_users[i]
	if isnull(ldt_last_executed) and li_allow_users = 0 then
		ls_message = "                                  *** WARNING ***~r~n"
		ls_message +=  "ONE OF THESE SCRIPT PERFORMS OPERATIONS WHICH MIGHT SERIOUSLY AFFECT THE PERFORMANCE OF ENCOUNTERPRO"
		ls_message += " AND SHOULD NOT BE EXECUTED WHILE USERS ARE IN THE SYSTEM.  ARE YOU ABSOLUTELY SURE YOU WANT"
		ls_message += " TO EXECUTE THESE SCRIPTS SCRIPT NOW?"
		openwithparm(w_pop_yes_no, ls_message)
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		exit
	end if
next

li_sts = sqlca.run_hotfixes(true)

if li_sts <= 0 then
	openwithparm(w_pop_message, "Executing Scripts Failed")
else
	openwithparm(w_pop_message, "Executing Scripts Succeeded")
end if

refresh()


end event

type st_2 from statictext within u_tabpage_dbmaint_scripts
integer x = 1682
integer y = 424
integer width = 480
integer height = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Script Comment"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_script_comment from statictext within u_tabpage_dbmaint_scripts
integer x = 1682
integer y = 496
integer width = 1161
integer height = 584
integer textsize = -9
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

type cb_save_as from commandbutton within u_tabpage_dbmaint_scripts
integer x = 1714
integer y = 1260
integer width = 530
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Save As"
end type

event clicked;blob lbl_script
string ls_description
string ls_filename
integer li_sts
string ls_temp

SELECTBLOB db_script
INTO :lbl_script
FROM c_Database_Script
WHERE script_id = :script_id;
if not tf_check() then return

SELECT description
INTO :ls_description
FROM c_Database_Script
WHERE script_id = :script_id;
if not tf_check() then return


if mid(ls_description, len(ls_description) - 3, 1) = "." then
	if mid(ls_description, len(ls_description) - 6, 3) <> string(sqlca.modification_level) then
		ls_temp = left(ls_description, len(ls_description) - 4)
		ls_temp += " " + string(sqlca.modification_level)
		ls_temp += right(ls_description, 4)
	end if
else
	ls_description += " " + string(sqlca.modification_level) + ".sql"
end if

li_sts = GetFileSaveName ( "Save Database Script", &
									ls_description,&
									ls_filename)

if li_sts > 0 then
	log.file_write( lbl_script, ls_description)
end if



end event

type st_1 from statictext within u_tabpage_dbmaint_scripts
integer x = 1682
integer y = 36
integer width = 1161
integer height = 344
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "These utility scripts are intended for use during advanced EncounterPro maintenance and troubleshooting.  Please do not perform any of these scripts unless told to do so by an authorized EncounterPRO Support person."
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type dw_scripts from u_dw_pick_list within u_tabpage_dbmaint_scripts
integer x = 160
integer y = 168
integer width = 1467
integer height = 956
integer taborder = 40
string dataobject = "dw_jmj_latest_scripts"
boolean vscrollbar = true
boolean border = false
end type

event unselected;call super::unselected;setnull(script_id)
cb_execute.enabled = false
cb_save_as.enabled = false

st_script_comment.text = ""

end event

event selected;call super::selected;script_id = object.script_id[selected_row]
script_name = object.script_name[selected_row]
allow_users = object.allow_users[selected_row]
cb_execute.enabled = true
cb_save_as.enabled = true
st_script_comment.text = object.comment[selected_row]
end event

type cb_execute from commandbutton within u_tabpage_dbmaint_scripts
integer x = 1714
integer y = 1116
integer width = 530
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Execute"
end type

event clicked;str_popup_return popup_return
integer li_sts
string ls_message


ls_message = "Are you sure you want to execute the '" + script_name + "' script?"
openwithparm(w_pop_yes_no, ls_message)
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

if allow_users = 0 then
	ls_message = "                                  *** WARNING ***~r~n"
	ls_message +=  "THIS SCRIPT PERFORMS OPERATIONS WHICH MIGHT SERIOUSLY AFFECT THE PERFORMANCE OF ENCOUNTERPRO"
	ls_message += " AND SHOULD NOT BE EXECUTED WHILE USERS ARE IN THE SYSTEM.  ARE YOU ABSOLUTELY SURE YOU WANT"
	ls_message += " TO EXECUTE THIS SCRIPT NOW?"
	openwithparm(w_pop_yes_no, ls_message)
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return
end if

li_sts = sqlca.execute_script(script_id)
if li_sts <= 0 then
	openwithparm(w_pop_message, "Executing Script Failed")
else
	openwithparm(w_pop_message, "Executing Script Succeeded")
end if

refresh()


end event

type st_script_title from statictext within u_tabpage_dbmaint_scripts
integer x = 46
integer y = 80
integer width = 1623
integer height = 88
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Available Utility Scripts"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_asterisk from statictext within u_tabpage_dbmaint_scripts
integer x = 197
integer y = 1240
integer width = 59
integer height = 64
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "*"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_do_not_run from statictext within u_tabpage_dbmaint_scripts
integer x = 265
integer y = 1232
integer width = 974
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "= Do Not Run During Office Hours"
alignment alignment = center!
boolean focusrectangle = false
end type

