HA$PBExportHeader$w_svc_config_database.srw
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
end forward

global type w_svc_config_database from w_window_base
integer width = 3950
integer height = 2504
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

type variables
u_sqlca dbo_connection
boolean display_only = true



end variables

forward prototypes
public function integer refresh ()
public function long load_schema_file (string ps_rootpath)
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

public function long load_schema_file (string ps_rootpath);string ls_left
string ls_right
string ls_id
string ls_url
long ll_from_material_id
string ls_parent_config_object_id
long ll_count
long ll_file_count
long i
long ll_subdir_index
string lsa_files[]
string lsa_paths[]
str_filepath lstr_rootpath
str_filepath lstr_filepath
string ls_sql_files
integer li_sts
str_file_attributes lstr_file_attributes
long ll_filebytes
blob lbl_file
string ls_file_script
string ls_owner
string ls_object
string ls_objecttype
long ll_modification_level
long ll_category
string ls_title
long ll_material_id
integer li_success_count
string ls_user_id

ll_modification_level = sqlca.modification_level + 1

if lower(right(ps_rootpath, 6)) = ".mdlvl" then
	ls_sql_files = ps_rootpath
	lstr_rootpath = f_parse_filepath2(ps_rootpath)
else
	// assume no file is specified and add one so it will parse correctly
	lstr_rootpath = f_parse_filepath2(ps_rootpath + "\dummy.sql")
	ls_sql_files = lstr_rootpath.drive + lstr_rootpath.filepath + "\*-" + string(ll_modification_level) + ".mdlvl"
end if

ll_file_count = log.get_all_files(ls_sql_files, lsa_files)
for i = 1 to ll_file_count
	lsa_paths[i] = lstr_rootpath.drive + lstr_rootpath.filepath + "\" + lsa_files[i]
next

li_success_count = 0

for i = 1 to ll_file_count
	// Skip the shorthand directories
	if lsa_files[i] = "." or lsa_files[i] = ".." then continue
	
	// Skip the file if we can't get its properties
	li_sts = log.file_attributes(lsa_paths[i], lstr_file_attributes)
	if li_sts <= 0 then continue
	
	// Skip the directories
	if lstr_file_attributes.subdirectory then continue
	
	
	lstr_filepath = f_parse_filepath2(lsa_paths[i])
	
	// Read the file
	li_sts = log.file_read(lsa_paths[i], lbl_file)
	if li_sts <= 0 then
		log.log(this, "f_generate_object_rebuild_script()", "Error reading file (" + lsa_paths[i] + ")", 4)
		return -1
	end if
	
	ls_id = f_new_guid()
	setnull(ls_url)
	setnull(ll_from_material_id)
	setnull(ll_category)
	setnull(ls_parent_config_object_id)
	
	if isnull(current_scribe) then
		ls_user_id = "SYSTEM"
	else
		ls_user_id = current_scribe.user_id
	end if

//	f_split_string(lstr_filepath.filename, "-", ls_left, ls_right)
//	if isnumber(ls_right) then
//		ll_modification_level = long(ls_right)
//	else
//		log.log(this, "load_schema_file()", "badly formed filename - could not find mod level (" + lstr_filepath.filename + ")", 4)
//		return -1
//	end if
//
	ls_title = "EncounterPRO OS Schema - Mod Level " + string(ll_modification_level)
	
	INSERT INTO c_Patient_Material (
		title ,
		category ,
		status ,
		extension ,
		created_by ,
		id,
		version,
		url,
		owner_id,
		filename,
		document_id
		)
	VALUES (
		:ls_title,
		:ll_category,
		'ML',
		:lstr_filepath.extension,
		:ls_user_id,
		:ls_id,
		1,
		:ls_url,
		0,
		:lstr_filepath.filename,
		:ls_id
		);
	if not tf_check() then return -1

//	ll_material_id = sqlca.jmj_new_material(ls_title, ll_category, "ML", lstr_filepath.extension, ls_id, ls_url, ls_user_id, lstr_filepath.filename, ll_from_material_id, ls_parent_config_object_id)
//	if not tf_check() then return -1

	SELECT scope_identity()
	INTO :ll_material_id
	FROM c_1_record;
	if not tf_check() then return -1
	
	if isnull(ll_material_id) or ll_material_id <= 0 then
		log.log(this,"clicked","Error creating new material",4)
		return -1
	end if
		
	Update c_patient_material
	Set version = :ll_modification_level 
	Where material_id = :ll_material_id;
	If not tf_check() Then return -1

	// Update the blob column
	UpdateBlob c_patient_material
	Set object = :lbl_file 
	Where material_id = :ll_material_id;
	If not tf_check() Then return -1

	return ll_material_id
next
	
//openwithparm(w_pop_message, "Successfully imported " + string(li_success_count) + " schema file(s)")
return 0


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
	log.log(this, "xx_do_service()", "Error Connecting to Database", 4)
	
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
integer x = 3424
integer y = 2264
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
integer width = 3945
integer height = 120
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Configure Database"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_not_dbo from statictext within w_svc_config_database
integer y = 128
integer width = 3945
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 33538240
string text = "Display Only (Not DBO)"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_svc_config_database
integer x = 727
integer y = 432
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
long backcolor = 33538240
string text = "Current Database Mod Level:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_mod_level from statictext within w_svc_config_database
integer x = 1824
integer y = 432
integer width = 457
integer height = 84
boolean bringtotop = true
integer textsize = -11
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
integer x = 2423
integer y = 420
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
	openwithparm(w_pop_message, "Successfullty upgraded mod level.  EncounterPRO will exit now.")

	popup_return.item_count = 1
	popup_return.items[1] = "OK"
	
	closewithreturn(parent, popup_return)
end if



end event

type cb_load_dbschema from commandbutton within w_svc_config_database
integer x = 1582
integer y = 1048
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
blob lbl_schema

li_sts = GetFileOpenName ("Select DB Schema File", ls_filepath, ls_filename ,"mdlvl", "DB Mod Level (*.mdlvl),*.mdlvl")
If li_sts <= 0 Then return


li_sts = load_schema_file(ls_filepath)
if li_sts <= 0 then
	openwithparm(w_pop_message, "Error loading schema file")
	return
end if

refresh()

end event

