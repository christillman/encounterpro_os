HA$PBExportHeader$w_new_backup.srw
forward
global type w_new_backup from window
end type
type st_status from statictext within w_new_backup
end type
type cb_backup from commandbutton within w_new_backup
end type
type st_5 from statictext within w_new_backup
end type
type st_backup_file_name from statictext within w_new_backup
end type
type st_6 from statictext within w_new_backup
end type
type st_database from statictext within w_new_backup
end type
type st_server from statictext within w_new_backup
end type
type st_4 from statictext within w_new_backup
end type
type st_3 from statictext within w_new_backup
end type
type st_2 from statictext within w_new_backup
end type
type st_1 from statictext within w_new_backup
end type
type st_sql from statictext within w_new_backup
end type
type st_windows from statictext within w_new_backup
end type
type sle_password from singlelineedit within w_new_backup
end type
type sle_user_name from singlelineedit within w_new_backup
end type
type mle_string from multilineedit within w_new_backup
end type
type st_prompt from statictext within w_new_backup
end type
type pb_ok from u_picture_button within w_new_backup
end type
type gb_1 from groupbox within w_new_backup
end type
type st_7 from statictext within w_new_backup
end type
end forward

global type w_new_backup from window
integer y = 200
integer width = 2921
integer height = 1644
windowtype windowtype = response!
long backcolor = 33538240
st_status st_status
cb_backup cb_backup
st_5 st_5
st_backup_file_name st_backup_file_name
st_6 st_6
st_database st_database
st_server st_server
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
st_sql st_sql
st_windows st_windows
sle_password sle_password
sle_user_name sle_user_name
mle_string mle_string
st_prompt st_prompt
pb_ok pb_ok
gb_1 gb_1
st_7 st_7
end type
global w_new_backup w_new_backup

type variables
boolean windows_security = true
string servername
string username, pwd
string database
end variables

event open;string ls_backup_file
str_popup popup

popup = message.powerobjectparm

st_prompt.text = popup.title

if not isnull(popup.item) and trim(popup.item) <> "" then
	mle_string.text = popup.item
	mle_string.selecttext(1, len(mle_string.text))
end if
servername = sqlca.servername
database = sqlca.database

st_server.text = servername
st_database.text = database

ls_backup_file = sqlca.servername+"_"+sqlca.database+"_"
ls_backup_file += String(Today(), "m-d-yy")+"_"+string(now(),"hh-mm")+".bak" 
st_backup_file_name.text = ls_backup_file
st_windows.backcolor = color_dark_grey
st_status.text = ''
mle_string.setfocus()


end event

on w_new_backup.create
this.st_status=create st_status
this.cb_backup=create cb_backup
this.st_5=create st_5
this.st_backup_file_name=create st_backup_file_name
this.st_6=create st_6
this.st_database=create st_database
this.st_server=create st_server
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.st_sql=create st_sql
this.st_windows=create st_windows
this.sle_password=create sle_password
this.sle_user_name=create sle_user_name
this.mle_string=create mle_string
this.st_prompt=create st_prompt
this.pb_ok=create pb_ok
this.gb_1=create gb_1
this.st_7=create st_7
this.Control[]={this.st_status,&
this.cb_backup,&
this.st_5,&
this.st_backup_file_name,&
this.st_6,&
this.st_database,&
this.st_server,&
this.st_4,&
this.st_3,&
this.st_2,&
this.st_1,&
this.st_sql,&
this.st_windows,&
this.sle_password,&
this.sle_user_name,&
this.mle_string,&
this.st_prompt,&
this.pb_ok,&
this.gb_1,&
this.st_7}
end on

on w_new_backup.destroy
destroy(this.st_status)
destroy(this.cb_backup)
destroy(this.st_5)
destroy(this.st_backup_file_name)
destroy(this.st_6)
destroy(this.st_database)
destroy(this.st_server)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.st_sql)
destroy(this.st_windows)
destroy(this.sle_password)
destroy(this.sle_user_name)
destroy(this.mle_string)
destroy(this.st_prompt)
destroy(this.pb_ok)
destroy(this.gb_1)
destroy(this.st_7)
end on

type st_status from statictext within w_new_backup
integer x = 37
integer y = 1444
integer width = 1797
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_backup from commandbutton within w_new_backup
integer x = 2043
integer y = 976
integer width = 603
integer height = 200
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Start Backup"
end type

event clicked;Integer		li_return,li_errnum
String		action_date
String		ls_errnum, ls_backupfile
String		ls_inifile='c:\jmj\backup\epro_backup_files.ini'
String		ls_backup_path = 'c:\jmj\backup\'
String 		ls_build,ls_build_version,ls_version
String		ls_current_dir
Integer		li_Filenum
Any			errnum
oleobject  ole_sqlbackup,ole_sqlserver


st_status.text = ''
ls_current_dir = getcurrentdirectory()

If servername = 'techserver' Then
	ls_inifile = "\\192.168.155.3\CPRFILES-EncounterPRO_Master_4001\Backup\epro_backup_files.ini"
	ls_backup_path = "\\192.168.155.3\CPRFILES-EncounterPRO_Master_4001\Backup\"
End If

// Check for 'C:\jmj\backup' directory existance
if not log.of_directoryexists('c:\jmj') Then
	Changedirectory('c:\')
	If createdirectory('jmj') <> 1 then
		log.log(this,"clicked","unable to create 'c:\jmj' directory",4)
		return 
	end if
end if
if not log.of_directoryexists('c:\jmj\backup') Then
	Changedirectory('c:\jmj')
	If createdirectory('backup') <> 1 then
		log.log(this,"clicked","unable to create 'c:\jmj\backup' directory",4)
		return 
	end if
end if

ole_sqlserver = Create oleobject
li_return = ole_sqlserver.connecttonewobject('SQLDMO.SQLServer')
If li_return <> 0 Then
	log.log(this,"clicked","unable to instantiate sqldmo.sqlserver ("+string(li_return)+")",4)
	Return -1
End If
If windows_security Then
	ole_sqlserver.LoginSecure = true
End If

errnum = ole_sqlserver.Connect(servername,username,pwd)
If not isnull(errnum) then
	CHOOSE CASE ClassName(errnum)
	CASE "integer"
		li_errnum = errnum
		If li_errnum <> 0 then 
			log.log(this,"clicked","error with connection to sqlserver server" + string(li_errnum),4)
			return -1
		end if
	Case "long"
		
	CASE "string"
		ls_errnum = errnum
		If ls_errnum <> "0" then 
			log.log(this,"clicked",	"error with connection to sqlserver server" + ls_errnum ,4)
			return -1
		end if
	END CHOOSE
end if

ole_sqlbackup = Create oleobject
li_return = ole_sqlbackup.connecttonewobject('SQLDMO.Backup')
ls_backupfile = st_backup_file_name.text

If li_return = 0 Then // success
	ole_sqlbackup.database = database
	Setpointer(hourglass!)
	st_status.text = 'Backup in progress ..'
	ole_sqlbackup.files = ls_backup_path+ls_backupfile
	errnum = ole_sqlbackup.sqlbackup(ole_sqlserver)
	Setpointer(arrow!)
End If

SELECT domain_item_description
INTO :ls_version
FROM c_Domain
WHERE domain_item = 'version';
if not tf_check() then return

SELECT domain_item_description
INTO :ls_build
FROM c_Domain
WHERE domain_item = 'build';
if not tf_check() then return

ls_build_version = trim(ls_version)+"."+trim(ls_build)
// add the backup info into INI file
If FileExists(ls_backup_path+ls_backupfile) Then
	If not FileExists(ls_inifile) Then
		li_FileNum = Fileopen(ls_inifile,LineMode!,Write!)
		If li_FileNum <= 0 Or isnull(li_Filenum) Then
			log.log(this,"clicked","unable to create 'INI' file",4)
			Return -1
		End If
		FileClose(li_Filenum)
	End If
	action_date = string(today(),"[shortdate] [time]")
	SetprofileString(ls_inifile,'Backup Files',ls_backupfile,'')
	SetprofileString(ls_inifile,ls_backupfile,'computername',computername)
	SetprofileString(ls_inifile,ls_backupfile,'server',servername)
	SetprofileString(ls_inifile,ls_backupfile,'database_name',database)
	Setprofilestring(ls_inifile,ls_backupfile,'action_date',action_date)
	SetprofileString(ls_inifile,ls_backupfile,'action','backup')
	SetprofileString(ls_inifile,ls_backupfile,'action_argument','')
	Setprofilestring(ls_inifile,ls_backupfile,'build',ls_build_version)
	SetprofileString(ls_inifile,ls_backupfile,'comment',mle_string.text)
End If

// add them to c_Database_Maintenance table
Insert into c_Database_Maintenance (
	logon_id,
	computername,
	server,
	database_name,
	action,
	action_argument,
	build,
	comment
	)
Values (
	:windows_logon_id,
	:computername,
	:servername,
	:database,
	'backup',
	:ls_backupfile,
	:ls_build_version,
	:mle_string.text
	)
using sqlca;

Changedirectory(ls_current_dir)
Openwithparm(w_pop_message,"Backup completed successfully")
Close(Parent)
end event

type st_5 from statictext within w_new_backup
integer x = 233
integer y = 564
integer width = 357
integer height = 64
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Comments:"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_backup_file_name from statictext within w_new_backup
integer x = 617
integer y = 444
integer width = 1202
integer height = 100
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_6 from statictext within w_new_backup
integer x = 69
integer y = 448
integer width = 526
integer height = 64
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Backup File Name:"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_database from statictext within w_new_backup
integer x = 622
integer y = 316
integer width = 1193
integer height = 100
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_server from statictext within w_new_backup
integer x = 622
integer y = 192
integer width = 1179
integer height = 100
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_4 from statictext within w_new_backup
integer y = 336
integer width = 613
integer height = 64
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Database To Backup:"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_new_backup
integer x = 251
integer y = 204
integer width = 357
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Connection:"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_new_backup
integer x = 1938
integer y = 612
integer width = 329
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Password"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_new_backup
integer x = 1938
integer y = 484
integer width = 329
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Login Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_sql from statictext within w_new_backup
integer x = 1957
integer y = 320
integer width = 768
integer height = 100
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Use SQL Authentication"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
boolean disabledlook = true
end type

event clicked;windows_security = false
this.backcolor = color_dark_grey
st_windows.backcolor = color_light_grey

sle_user_name.enabled = true
sle_password.enabled = true
end event

type st_windows from statictext within w_new_backup
integer x = 1957
integer y = 200
integer width = 768
integer height = 100
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Use Windows Authentication"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;windows_security = true
this.backcolor = color_dark_grey
st_sql.backcolor = color_light_grey

sle_user_name.enabled = false
sle_password.enabled = false
end event

type sle_password from singlelineedit within w_new_backup
integer x = 2277
integer y = 596
integer width = 439
integer height = 96
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event modified;pwd = sle_password.text
end event

type sle_user_name from singlelineedit within w_new_backup
integer x = 2281
integer y = 460
integer width = 439
integer height = 96
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean enabled = false
string text = "sa"
borderstyle borderstyle = stylelowered!
end type

event modified;username = sle_user_name.text
end event

type mle_string from multilineedit within w_new_backup
integer x = 32
integer y = 652
integer width = 1797
integer height = 636
integer taborder = 10
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean vscrollbar = true
boolean autohscroll = true
borderstyle borderstyle = stylelowered!
end type

type st_prompt from statictext within w_new_backup
integer x = 55
integer y = 28
integer width = 2537
integer height = 72
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 33538240
boolean enabled = false
boolean focusrectangle = false
end type

type pb_ok from u_picture_button within w_new_backup
integer x = 2542
integer y = 1396
integer taborder = 20
boolean default = true
string picturename = "button11.bmp"
string disabledname = "button11.bmp"
end type

event clicked;call super::clicked;Close(Parent)

end event

type gb_1 from groupbox within w_new_backup
integer x = 1870
integer y = 124
integer width = 910
integer height = 612
integer taborder = 10
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 65280
long backcolor = 33538240
string text = "Authorization"
end type

type st_7 from statictext within w_new_backup
boolean visible = false
integer x = 32
integer y = 1000
integer width = 224
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16776960
long backcolor = 33538240
string text = "Status"
boolean focusrectangle = false
end type

