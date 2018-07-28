HA$PBExportHeader$u_tabpage_dbmaint_utility_scripts.sru
forward
global type u_tabpage_dbmaint_utility_scripts from u_tabpage
end type
type cb_save_as from commandbutton within u_tabpage_dbmaint_utility_scripts
end type
type st_1 from statictext within u_tabpage_dbmaint_utility_scripts
end type
type dw_scripts from u_dw_pick_list within u_tabpage_dbmaint_utility_scripts
end type
type cb_execute from commandbutton within u_tabpage_dbmaint_utility_scripts
end type
type st_script_title from statictext within u_tabpage_dbmaint_utility_scripts
end type
end forward

global type u_tabpage_dbmaint_utility_scripts from u_tabpage
integer width = 2898
string text = "Updates"
cb_save_as cb_save_as
st_1 st_1
dw_scripts dw_scripts
cb_execute cb_execute
st_script_title st_script_title
end type
global u_tabpage_dbmaint_utility_scripts u_tabpage_dbmaint_utility_scripts

type variables
long script_id
string script_name

end variables

forward prototypes
public subroutine refresh ()
end prototypes

public subroutine refresh ();long ll_count
string ls_count
long ll_first_row_on_page
long ll_new_first_row_on_page
long ll_last
long i
datetime ldt_last_scripts_update

dw_scripts.height = this.height - dw_scripts.y - 50

// Utility scripts
ll_first_row_on_page = long(dw_scripts.object.DataWindow.FirstRowOnPage)

dw_scripts.settransobject(sqlca)
ll_count = dw_scripts.retrieve("Utility", sqlca.modification_level)

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


end subroutine

on u_tabpage_dbmaint_utility_scripts.create
int iCurrent
call super::create
this.cb_save_as=create cb_save_as
this.st_1=create st_1
this.dw_scripts=create dw_scripts
this.cb_execute=create cb_execute
this.st_script_title=create st_script_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_save_as
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.dw_scripts
this.Control[iCurrent+4]=this.cb_execute
this.Control[iCurrent+5]=this.st_script_title
end on

on u_tabpage_dbmaint_utility_scripts.destroy
call super::destroy
destroy(this.cb_save_as)
destroy(this.st_1)
destroy(this.dw_scripts)
destroy(this.cb_execute)
destroy(this.st_script_title)
end on

type cb_save_as from commandbutton within u_tabpage_dbmaint_utility_scripts
integer x = 1810
integer y = 1172
integer width = 521
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

type st_1 from statictext within u_tabpage_dbmaint_utility_scripts
integer x = 1714
integer y = 96
integer width = 1001
integer height = 544
integer textsize = -10
integer weight = 700
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

type dw_scripts from u_dw_pick_list within u_tabpage_dbmaint_utility_scripts
integer x = 160
integer y = 168
integer width = 1467
integer height = 956
integer taborder = 40
string dataobject = "dw_database_script_list"
boolean vscrollbar = true
boolean border = false
end type

event unselected;call super::unselected;setnull(script_id)
cb_execute.enabled = false
cb_save_as.enabled = false

end event

event selected;call super::selected;script_id = object.script_id[selected_row]
script_name = object.script_name[selected_row]
cb_execute.enabled = true
cb_save_as.enabled = true

end event

type cb_execute from commandbutton within u_tabpage_dbmaint_utility_scripts
integer x = 1801
integer y = 940
integer width = 521
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

openwithparm(w_pop_yes_no, "Are you sure you want to execute the '" + script_name + "' script?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

li_sts = sqlca.execute_script(script_id)
if li_sts <= 0 then
	openwithparm(w_pop_message, "Executing Script Failed")
else
	openwithparm(w_pop_message, "Executing Script Succeeded")
end if

refresh()


end event

type st_script_title from statictext within u_tabpage_dbmaint_utility_scripts
integer x = 165
integer y = 80
integer width = 1362
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

