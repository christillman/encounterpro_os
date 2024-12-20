﻿$PBExportHeader$w_svc_config_database.srw
forward
global type w_svc_config_database from w_window_base
end type
type cb_finished from commandbutton within w_svc_config_database
end type
type st_title from statictext within w_svc_config_database
end type
type st_not_dbo from statictext within w_svc_config_database
end type
type st_1 from statictext within w_svc_config_database
end type
type st_mod_level from statictext within w_svc_config_database
end type
type cb_upgrade from commandbutton within w_svc_config_database
end type
type cb_load_dbschema from commandbutton within w_svc_config_database
end type
type os_filedatetime from structure within w_svc_config_database
end type
type os_fileopeninfo from structure within w_svc_config_database
end type
type os_finddata from structure within w_svc_config_database
end type
type os_securityattributes from structure within w_svc_config_database
end type
type os_systemtime from structure within w_svc_config_database
end type
end forward

type os_filedatetime from structure
	unsignedlong		ul_lowdatetime
	unsignedlong		ul_highdatetime
end type

type os_fileopeninfo from structure
	character		c_length
	character		c_fixed_disk
	unsignedinteger		ui_dos_error
	unsignedinteger		ui_na1
	unsignedinteger		ui_na2
	character		c_pathname[128]
end type

type os_finddata from structure
	unsignedlong		ul_fileattributes
	os_filedatetime		str_creationtime
	os_filedatetime		str_lastaccesstime
	os_filedatetime		str_lastwritetime
	unsignedlong		ul_filesizehigh
	unsignedlong		ul_filesizelow
	unsignedlong		ul_reserved0
	unsignedlong		ul_reserved1
	character		ch_filename[260]
	character		ch_alternatefilename[14]
end type

type os_securityattributes from structure
	unsignedlong		ul_length
	character		ch_description
	boolean		b_inherit
end type

type os_systemtime from structure
	unsignedinteger		ui_wyear
	unsignedinteger		ui_wmonth
	unsignedinteger		ui_wdayofweek
	unsignedinteger		ui_wday
	unsignedinteger		ui_whour
	unsignedinteger		ui_wminute
	unsignedinteger		ui_wsecond
	unsignedinteger		ui_wmilliseconds
end type

global type w_svc_config_database from w_window_base
integer width = 2747
integer height = 1052
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_finished cb_finished
st_title st_title
st_not_dbo st_not_dbo
st_1 st_1
st_mod_level st_mod_level
cb_upgrade cb_upgrade
cb_load_dbschema cb_load_dbschema
end type
global w_svc_config_database w_svc_config_database

type prototypes

end prototypes

type variables
u_sqlca dbo_connection
boolean display_only = true



end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();

if display_only then
	st_not_dbo.visible = true
else
	st_not_dbo.visible = false
end if

st_mod_level.text = string(sqlca.modification_level)



return 1

end function

on w_svc_config_database.create
int iCurrent
call super::create
this.cb_finished=create cb_finished
this.st_title=create st_title
this.st_not_dbo=create st_not_dbo
this.st_1=create st_1
this.st_mod_level=create st_mod_level
this.cb_upgrade=create cb_upgrade
this.cb_load_dbschema=create cb_load_dbschema
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_finished
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.st_not_dbo
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_mod_level
this.Control[iCurrent+6]=this.cb_upgrade
this.Control[iCurrent+7]=this.cb_load_dbschema
end on

on w_svc_config_database.destroy
call super::destroy
destroy(this.cb_finished)
destroy(this.st_title)
destroy(this.st_not_dbo)
destroy(this.st_1)
destroy(this.st_mod_level)
destroy(this.cb_upgrade)
destroy(this.cb_load_dbschema)
end on

event open;call super::open;integer li_sts
str_popup_return popup_return


dbo_connection = CREATE u_sqlca
dbo_connection.connect_approle = false
li_sts = dbo_connection.dbconnect("EproOSDBConfig")
if li_sts <= 0 then
	openwithparm(w_pop_message, "Error connecting to database.  See event viewer for more information.")
	log.log(this, "w_svc_config_database:open", "Error Connecting to Database", 4)
	
	popup_return.item_count = 1
	popup_return.items[1] = "ERROR"
	closewithreturn(this, popup_return)
end if


// Make Sure we're a DBO
if dbo_connection.is_dbo then
	display_only = false
else
	display_only = true
end if	

refresh()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_config_database
integer x = 3872
integer y = 316
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_config_database
integer x = 32
integer y = 2208
end type

type cb_finished from commandbutton within w_svc_config_database
integer x = 1134
integer y = 764
integer width = 443
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)
end event

type st_title from statictext within w_svc_config_database
integer width = 2862
integer height = 120
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Configure Database"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_not_dbo from statictext within w_svc_config_database
integer y = 128
integer width = 2862
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 7191717
string text = "Display Only (Not DBO)"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_svc_config_database
integer x = 201
integer y = 472
integer width = 1038
integer height = 84
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Current Database Mod Level:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_mod_level from statictext within w_svc_config_database
integer x = 1298
integer y = 464
integer width = 457
integer height = 96
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "none"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type cb_upgrade from commandbutton within w_svc_config_database
integer x = 1897
integer y = 452
integer width = 608
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Upgrade Now"
end type

event clicked;str_popup_return popup_return
integer li_sts

li_sts = dbo_connection.upgrade_database()
if li_sts <= 0 then
	openwithparm(w_pop_message, "Error upgrading mod level")
else
	openwithparm(w_pop_message, "Successfully upgraded mod level. " + gnv_app.product_name + " will exit now.")

	popup_return.item_count = 1
	popup_return.items[1] = "OK"
	
	closewithreturn(parent, popup_return)
end if



end event

type cb_load_dbschema from commandbutton within w_svc_config_database
integer x = 297
integer y = 288
integer width = 823
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Load DBSchema"
end type

event clicked;integer li_sts
string ls_filepath
string ls_filename
long ll_material_id, ll_modification_level


li_sts = GetFileOpenName ("Select DB Schema File", ls_filepath, ls_filename ,"mdlvl", "DB Mod Level (*.mdlvl),*.mdlvl")
If li_sts <= 0 Then return

ll_modification_level = sqlca.modification_level + 1

ll_material_id = sqlca.load_schema_file(ls_filepath, ll_modification_level, ls_filename)
if ll_material_id > 0 then
	openwithparm(w_pop_message, "Successfully imported schema file " + ls_filename)
	return ll_material_id
else	
	openwithparm(w_pop_message, "Error loading schema file")
	return
end if

refresh()

end event

