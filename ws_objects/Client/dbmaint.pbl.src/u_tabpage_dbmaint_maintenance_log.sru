$PBExportHeader$u_tabpage_dbmaint_maintenance_log.sru
forward
global type u_tabpage_dbmaint_maintenance_log from u_tabpage
end type
type dw_scripts from u_dw_pick_list within u_tabpage_dbmaint_maintenance_log
end type
type st_title from statictext within u_tabpage_dbmaint_maintenance_log
end type
end forward

global type u_tabpage_dbmaint_maintenance_log from u_tabpage
integer width = 2898
string text = "Updates"
dw_scripts dw_scripts
st_title st_title
end type
global u_tabpage_dbmaint_maintenance_log u_tabpage_dbmaint_maintenance_log

type variables
string script_type

long script_id
string script_name
integer allow_users


end variables

forward prototypes
public subroutine refresh ()
public function integer initialize ()
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


end subroutine

public function integer initialize ();if sqlca.modification_level < 141 then
	visible = false
end if

return 1

end function

on u_tabpage_dbmaint_maintenance_log.create
int iCurrent
call super::create
this.dw_scripts=create dw_scripts
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_scripts
this.Control[iCurrent+2]=this.st_title
end on

on u_tabpage_dbmaint_maintenance_log.destroy
call super::destroy
destroy(this.dw_scripts)
destroy(this.st_title)
end on

type dw_scripts from u_dw_pick_list within u_tabpage_dbmaint_maintenance_log
integer x = 41
integer y = 140
integer width = 2779
integer height = 1208
integer taborder = 40
string dataobject = "dw_c_database_maintenance"
boolean vscrollbar = true
boolean border = false
end type

type st_title from statictext within u_tabpage_dbmaint_maintenance_log
integer width = 2907
integer height = 88
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Database Maintenance Log"
alignment alignment = center!
boolean focusrectangle = false
end type

