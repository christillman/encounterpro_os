$PBExportHeader$u_tabpage_dbmaint_restore.sru
forward
global type u_tabpage_dbmaint_restore from u_tabpage
end type
type mle_comment from multilineedit within u_tabpage_dbmaint_restore
end type
type st_status from statictext within u_tabpage_dbmaint_restore
end type
type sle_pwd from singlelineedit within u_tabpage_dbmaint_restore
end type
type sle_username from singlelineedit within u_tabpage_dbmaint_restore
end type
type st_4 from statictext within u_tabpage_dbmaint_restore
end type
type st_3 from statictext within u_tabpage_dbmaint_restore
end type
type st_sql from statictext within u_tabpage_dbmaint_restore
end type
type st_windows from statictext within u_tabpage_dbmaint_restore
end type
type cb_restore from commandbutton within u_tabpage_dbmaint_restore
end type
type pb_down from u_picture_button within u_tabpage_dbmaint_restore
end type
type pb_up from u_picture_button within u_tabpage_dbmaint_restore
end type
type st_page from statictext within u_tabpage_dbmaint_restore
end type
type st_title from statictext within u_tabpage_dbmaint_restore
end type
type gb_1 from groupbox within u_tabpage_dbmaint_restore
end type
type dw_available from u_dw_pick_list within u_tabpage_dbmaint_restore
end type
end forward

global type u_tabpage_dbmaint_restore from u_tabpage
integer width = 2944
string text = "Restore"
mle_comment mle_comment
st_status st_status
sle_pwd sle_pwd
sle_username sle_username
st_4 st_4
st_3 st_3
st_sql st_sql
st_windows st_windows
cb_restore cb_restore
pb_down pb_down
pb_up pb_up
st_page st_page
st_title st_title
gb_1 gb_1
dw_available dw_available
end type
global u_tabpage_dbmaint_restore u_tabpage_dbmaint_restore

type variables
long restore_row
boolean windows_security = true
string username,pwd,location
end variables

forward prototypes
public function integer initialize ()
public subroutine refresh ()
public function integer load_available_backups ()
public function integer display_backups (string ps_filename, string ps_location_type)
end prototypes

public function integer initialize ();//load_available_backups()

REturn 1
end function

public subroutine refresh ();st_status.text = ""
load_available_backups()

end subroutine

public function integer load_available_backups ();//	The available backups will be found by looking for a file
// named "epro_backup_files.ini" in the following places:
//
// 1) \jmj\backup on every hard drive on the local computer
// 2) \jmj\backup on every cd-rom drive on the local computer
// 3) \\192.168.155.3\CPRFILES-EncounterPRO_Master_4001\Backup
//
//
// The epro_backup_files.ini will have the following format:
//
//
// [Backup Files]
//	filename1
//	filename2
//	filename3
//	...
//
//	[filename1]
//	computername=<computername>
//	server=<servername>
//	database_name=<database name>
//	action=<action>
//	action_date=<action date>
//	action_argument=<action argument>
//	comment=<comment>
//
//	[filename2]
//	...
//
//

string lsa_drives[]
integer li_drive_count
integer li_count
integer i
integer li_drive_type
string ls_filename,ls_location_type
integer li_sts

li_count = 0

li_drive_count = 5
lsa_drives[1] = "C"
lsa_drives[2] = "D"
lsa_drives[3] = "E"
lsa_drives[4] = "F"
lsa_drives[5] = "G"

location = "c:\jmj\backup"
dw_available.reset()
dw_available.dataobject = "dw_restore_candidates"
// First, find and display any local files
for i = 1 to li_drive_count
	li_drive_type = log.get_drive_type(lsa_drives[i])
	// 3 = Hard Drive, 5 = CD Rom Drive
	if li_drive_type = 3 or li_drive_type = 5 then
		ls_filename = lsa_drives[i] + ":\jmj\backup\epro_backup_files.ini"
		If li_drive_type = 3 Then ls_location_type = "Local ("+lsa_drives[i]+":)" Else &
			ls_location_type = "CdRom ("+lsa_drives[i]+")"
		li_sts = display_backups(ls_filename,ls_location_type)
		if li_sts > 0 then
			li_count += li_sts
		end if
	else
		continue
	end if
next

//// Then, display the network file
//location = "\\192.168.155.3\CPRFILES-EncounterPRO_Master_4001\Backup"
//ls_filename = "\\192.168.155.3\CPRFILES-EncounterPRO_Master_4001\Backup\epro_backup_files.ini"
//li_sts = display_backups(ls_filename,'TechServer')
//if li_sts > 0 then
//	li_count += li_sts
//end if

if dw_available.rowcount() > 0 then cb_restore.enabled = true else cb_restore.enabled = false
dw_available.last_page = 0
dw_available.set_page(0,pb_up,pb_down,st_page)
return li_count

end function

public function integer display_backups (string ps_filename, string ps_location_type);Integer 	li_count
String ls_computername
String ls_server
String ls_database_name
String ls_action
String ls_action_date
String ls_action_argument
String ls_comment
String ls_pathname
String ls_filename
String ls_build
String ls_temp
String ls_keys[]
Long   ll_row
Integer li_pos,li_keys,i

li_keys = log.profile_keys(ps_filename,'Backup Files',ls_keys[])
For i = 1 to li_keys
	ls_computername = profilestring(ps_filename,ls_keys[i],'computername','')
	ls_server = profilestring(ps_filename,ls_keys[i],'server','')
	ls_database_name = profilestring(ps_filename,ls_keys[i],'database_name','')
	ls_action = profilestring(ps_filename,ls_keys[i],'action','')
	ls_action_date = profilestring(ps_filename,ls_keys[i],'action_date','')
	ls_action_argument = profilestring(ps_filename,ls_keys[i],'action_argument','')
	ls_build = profilestring(ps_filename,ls_keys[i],'build','')
	ls_comment = profilestring(ps_filename,ls_keys[i],'comment','')
	
	// back file and file path
//	ls_temp = reverse(ls_keys[i])
//	li_pos = Pos(ls_temp,"\")
//	ls_filename = Reverse(Mid(ls_temp,1,li_pos - 1))
//	ls_pathname = Reverse(Mid(ls_temp,li_pos+1))
	
	ll_row = dw_available.insertrow(0)
	dw_available.object.location_type[ll_row] = ps_location_type
	dw_available.object.location[ll_row] = location
	dw_available.object.backup_datetime[ll_row] = ls_action_date
	dw_available.object.backup_filename[ll_row] = ls_keys[i] // backupfilename
	dw_available.object.build[ll_row] = ls_build
	dw_available.object.comment[ll_row] = ls_comment
Next

return li_count


end function

on u_tabpage_dbmaint_restore.create
int iCurrent
call super::create
this.mle_comment=create mle_comment
this.st_status=create st_status
this.sle_pwd=create sle_pwd
this.sle_username=create sle_username
this.st_4=create st_4
this.st_3=create st_3
this.st_sql=create st_sql
this.st_windows=create st_windows
this.cb_restore=create cb_restore
this.pb_down=create pb_down
this.pb_up=create pb_up
this.st_page=create st_page
this.st_title=create st_title
this.gb_1=create gb_1
this.dw_available=create dw_available
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.mle_comment
this.Control[iCurrent+2]=this.st_status
this.Control[iCurrent+3]=this.sle_pwd
this.Control[iCurrent+4]=this.sle_username
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.st_sql
this.Control[iCurrent+8]=this.st_windows
this.Control[iCurrent+9]=this.cb_restore
this.Control[iCurrent+10]=this.pb_down
this.Control[iCurrent+11]=this.pb_up
this.Control[iCurrent+12]=this.st_page
this.Control[iCurrent+13]=this.st_title
this.Control[iCurrent+14]=this.gb_1
this.Control[iCurrent+15]=this.dw_available
end on

on u_tabpage_dbmaint_restore.destroy
call super::destroy
destroy(this.mle_comment)
destroy(this.st_status)
destroy(this.sle_pwd)
destroy(this.sle_username)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_sql)
destroy(this.st_windows)
destroy(this.cb_restore)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.st_page)
destroy(this.st_title)
destroy(this.gb_1)
destroy(this.dw_available)
end on

event constructor;call super::constructor;st_windows.backcolor = color_dark_grey
windows_security = true
end event

type mle_comment from multilineedit within u_tabpage_dbmaint_restore
boolean visible = false
integer x = 69
integer y = 1084
integer width = 1975
integer height = 408
integer taborder = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
boolean border = false
boolean displayonly = true
end type

type st_status from statictext within u_tabpage_dbmaint_restore
integer x = 2062
integer y = 1428
integer width = 837
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean focusrectangle = false
end type

type sle_pwd from singlelineedit within u_tabpage_dbmaint_restore
integer x = 2441
integer y = 176
integer width = 407
integer height = 84
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event modified;pwd = sle_pwd.text
end event

type sle_username from singlelineedit within u_tabpage_dbmaint_restore
integer x = 2441
integer y = 76
integer width = 407
integer height = 84
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event modified;username = sle_username.text
end event

type st_4 from statictext within u_tabpage_dbmaint_restore
integer x = 2139
integer y = 188
integer width = 297
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Password:"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within u_tabpage_dbmaint_restore
integer x = 2144
integer y = 92
integer width = 297
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Username:"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_sql from statictext within u_tabpage_dbmaint_restore
integer x = 1202
integer y = 104
integer width = 928
integer height = 104
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "SQL Authentication"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;this.backcolor = color_dark_grey
st_windows.backcolor = color_light_grey
windows_security = false
sle_username.enabled = true
sle_pwd.enabled = true
end event

type st_windows from statictext within u_tabpage_dbmaint_restore
integer x = 210
integer y = 104
integer width = 928
integer height = 104
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Windows Authentication"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;this.backcolor = color_dark_grey
st_sql.backcolor = color_light_grey
windows_security = true
sle_username.enabled = false
sle_pwd.enabled = false
end event

type cb_restore from commandbutton within u_tabpage_dbmaint_restore
integer x = 2331
integer y = 1208
integer width = 567
integer height = 164
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Restore Now"
end type

event clicked;Integer		li_return,li_errnum
String		ls_errnum, ls_restorefile
String		ls_filepath,ls_file,ls_backupfile
String		ls_backup_build
String		ls_servername,ls_database,ls_dbms
String		ls_computername
String		ls_message
Any			errnum
oleobject  ole_sqlrestore,ole_sqlserver
str_popup_return popup_return



DECLARE lsp_drop_user PROCEDURE FOR dbo.sp_dropuser
	@name_in_db = 'jmjtech'
	using sqlca;

DECLARE lsp_add_user PROCEDURE FOR dbo.sp_adduser
	@loginame = 'jmjtech',
	@name_in_db = 'jmjtech'
	using sqlca;

DECLARE lsp_addrolemember PROCEDURE FOR dbo.sp_addrolemember
	@rolename = 'cprsystem',
	@membername = 'jmjtech'
	using sqlca;

ls_servername = sqlca.servername
ls_database = sqlca.database
ls_dbms = sqlca.dbms

If restore_row > 0 Then

	ole_sqlserver = Create oleobject
	li_return = ole_sqlserver.connecttonewobject('SQLDMO.SQLServer')
	If li_return <> 0 Then
		log.log(this,"clicked","unable to instantiate sqldmo.sqlserver ("+string(li_return)+")",4)
		Return -1
	End If
	If windows_security Then
		ole_sqlserver.LoginSecure = true
	End If

	errnum = ole_sqlserver.Connect(sqlca.servername,username,pwd)
	If not isnull(errnum) then
		CHOOSE CASE ClassName(errnum)
		CASE "integer"
			li_errnum = errnum
			If li_errnum <> 0 then 
				log.log(this,"clicked","error with connection to sqlserver server" + string(li_errnum),4)
				destroy ole_sqlserver
				return -1
			end if
		Case "long"
		
		CASE "string"
			ls_errnum = errnum
			If ls_errnum <> "0" then 
				log.log(this,"clicked",	"error with connection to sqlserver server" + ls_errnum ,4)
				destroy ole_sqlserver
				return -1
			end if
		END CHOOSE
	end if

	ls_backupfile = dw_available.object.backup_filename[restore_row]
	ls_filepath = dw_available.object.location[restore_row]
	ls_backup_build = dw_available.object.build[restore_row]

	ls_file = ls_filepath +"\"+ ls_backupfile

// Restore
	ole_sqlrestore = Create oleobject
	li_return = ole_sqlrestore.connecttonewobject('SQLDMO.Restore')
	
	If li_return = 0 Then // success
		ole_sqlrestore.database = sqlca.database
		Setpointer(hourglass!)
		ole_sqlrestore.files = ls_file
		sqlca.dbdisconnect()
		st_status.text = 'Restoring the database ..'
		errnum = ole_sqlrestore.sqlrestore(ole_sqlserver)
		st_status.text = 'Restore completed successfully ..'
		
// Reconnect using 'SA' login to db
		sqlca.logid = 'sa'
		sqlca.LogPass	 = ''
		sqlca.autocommit = true
		Connect using sqlca;
	
		// drop user & add the user & his role
		EXECUTE lsp_drop_user;
		if not tf_check() then return -1
		EXECUTE lsp_add_user;
		if not tf_check() then return -1
		EXECUTE lsp_addrolemember;
		if not tf_check() then return -1
		
		// add them to c_Database_Maintenance table
		Insert Into c_Database_Maintenance (
			logon_id,
			computername,
			server,
			database_name,
			action,
			action_argument,
			comment
		)
		Values (
			:windows_logon_id,
			:computername,
			:ls_servername,
			:ls_database,
			'restore',
			:ls_file,
			''
		)
		Using sqlca;
		Setpointer(arrow!)
	End If
End If

Destroy ole_sqlserver
Destroy ole_sqlrestore
Return 1
end event

type pb_down from u_picture_button within u_tabpage_dbmaint_restore
boolean visible = false
integer x = 2569
integer y = 640
integer width = 137
integer height = 116
integer taborder = 60
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_available.current_page
li_last_page = dw_available.last_page

dw_available.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true


end event

type pb_up from u_picture_button within u_tabpage_dbmaint_restore
boolean visible = false
integer x = 2569
integer y = 508
integer width = 137
integer height = 116
integer taborder = 50
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_available.current_page

dw_available.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type st_page from statictext within u_tabpage_dbmaint_restore
integer x = 2546
integer y = 436
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
alignment alignment = right!
boolean focusrectangle = false
end type

type st_title from statictext within u_tabpage_dbmaint_restore
integer x = 846
integer y = 304
integer width = 805
integer height = 80
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 33538240
string text = "Available Backup Files"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from groupbox within u_tabpage_dbmaint_restore
integer x = 110
integer y = 24
integer width = 2770
integer height = 256
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 65280
long backcolor = 33538240
string text = "Authorization"
end type

type dw_available from u_dw_pick_list within u_tabpage_dbmaint_restore
integer x = 91
integer y = 416
integer width = 2414
integer height = 612
integer taborder = 60
string dataobject = "dw_restore_candidates"
boolean border = false
end type

