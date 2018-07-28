HA$PBExportHeader$u_tabpage_dbmaint_script_log.sru
forward
global type u_tabpage_dbmaint_script_log from u_tabpage
end type
type cb_view_script from commandbutton within u_tabpage_dbmaint_script_log
end type
type st_2 from statictext within u_tabpage_dbmaint_script_log
end type
type st_script_comment from statictext within u_tabpage_dbmaint_script_log
end type
type cb_save_as from commandbutton within u_tabpage_dbmaint_script_log
end type
type st_1 from statictext within u_tabpage_dbmaint_script_log
end type
type dw_scripts from u_dw_pick_list within u_tabpage_dbmaint_script_log
end type
type st_script_title from statictext within u_tabpage_dbmaint_script_log
end type
end forward

global type u_tabpage_dbmaint_script_log from u_tabpage
integer width = 2898
string text = "Updates"
cb_view_script cb_view_script
st_2 st_2
st_script_comment st_script_comment
cb_save_as cb_save_as
st_1 st_1
dw_scripts dw_scripts
st_script_title st_script_title
end type
global u_tabpage_dbmaint_script_log u_tabpage_dbmaint_script_log

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

dw_scripts.height = this.height - 250

dw_scripts.settransobject(sqlca)
ll_count = dw_scripts.retrieve()

cb_save_as.enabled = false
cb_view_script.enabled = false
st_script_comment.text = ""

end subroutine

public function integer initialize (string ps_key);

return 1


end function

on u_tabpage_dbmaint_script_log.create
int iCurrent
call super::create
this.cb_view_script=create cb_view_script
this.st_2=create st_2
this.st_script_comment=create st_script_comment
this.cb_save_as=create cb_save_as
this.st_1=create st_1
this.dw_scripts=create dw_scripts
this.st_script_title=create st_script_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_view_script
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_script_comment
this.Control[iCurrent+4]=this.cb_save_as
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.dw_scripts
this.Control[iCurrent+7]=this.st_script_title
end on

on u_tabpage_dbmaint_script_log.destroy
call super::destroy
destroy(this.cb_view_script)
destroy(this.st_2)
destroy(this.st_script_comment)
destroy(this.cb_save_as)
destroy(this.st_1)
destroy(this.dw_scripts)
destroy(this.st_script_title)
end on

type cb_view_script from commandbutton within u_tabpage_dbmaint_script_log
integer x = 2295
integer y = 1148
integer width = 530
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "View Script"
end type

event clicked;blob lbl_script
string ls_filename
integer li_sts
string ls_temp

SELECTBLOB db_script
INTO :lbl_script
FROM c_Database_Script
WHERE script_id = :script_id;
if not tf_check() then return

ls_filename = f_temp_file("sql")
li_sts = log.file_write( lbl_script, ls_filename)
if li_sts <= 0 then
	openwithparm(w_pop_message, "Error saving script to temp file")
	return
end if

f_open_file(ls_filename, false)

	





end event

type st_2 from statictext within u_tabpage_dbmaint_script_log
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

type st_script_comment from statictext within u_tabpage_dbmaint_script_log
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

type cb_save_as from commandbutton within u_tabpage_dbmaint_script_log
integer x = 2290
integer y = 1300
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

type st_1 from statictext within u_tabpage_dbmaint_script_log
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

type dw_scripts from u_dw_pick_list within u_tabpage_dbmaint_script_log
integer x = 41
integer y = 140
integer width = 1527
integer height = 1208
integer taborder = 40
string dataobject = "dw_c_database_script_log_display"
boolean vscrollbar = true
boolean border = false
end type

event unselected;call super::unselected;setnull(script_id)
cb_save_as.enabled = false
cb_view_script.enabled = false

st_script_comment.text = ""

end event

event selected;call super::selected;script_id = object.script_id[selected_row]
script_name = object.script_name[selected_row]
allow_users = object.allow_users[selected_row]
cb_save_as.enabled = true
cb_view_script.enabled = true

st_script_comment.text = ""

SELECT comment
INTO :st_script_comment.text
FROM c_Database_Script
WHERE script_id = :script_id;
if not tf_check() then return

end event

type st_script_title from statictext within u_tabpage_dbmaint_script_log
integer x = 23
integer y = 20
integer width = 1426
integer height = 88
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Executed DB Script Log"
alignment alignment = center!
boolean focusrectangle = false
end type

