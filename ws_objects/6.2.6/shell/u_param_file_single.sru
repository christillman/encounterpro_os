HA$PBExportHeader$u_param_file_single.sru
forward
global type u_param_file_single from u_param_base
end type
type st_script from statictext within u_param_file_single
end type
type cb_edit from commandbutton within u_param_file_single
end type
end forward

global type u_param_file_single from u_param_base
st_script st_script
cb_edit cb_edit
end type
global u_param_file_single u_param_file_single

type variables
string script
str_external_observation_attachment param_file

string filters

end variables

forward prototypes
public function integer check_required ()
public function integer x_initialize ()
public function integer pick_param ()
end prototypes

public function integer check_required ();//////////////////////////////////////////////////////////////////////////////////////
//
//	Return: Integer [ -1 - required column missing  1 - validation success
//
//	Description: validates whether it's required column
//
// Created By:Sumathi Chinnasamy										Creation dt: 10/14/99
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////
if upper(param_wizard.params.params[param_index].required_flag) = "Y" then
	If Isnull(script) Or Len(script) = 0 Then
		Openwithparm(w_pop_message,"Please enter a " + st_title.text)
		Return -1
	End if
End If

Return 1
end function

public function integer x_initialize ();//////////////////////////////////////////////////////////////////////////////////////
//
//	Return: Integer
//
// Description:If no values defined then initialize the fields with initial values
//
// Created By:Sumathi Chinnasamy										Creation dt: 10/14/99
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////
string ls_intitial_value
integer li_sts

filters = param_wizard.params.params[param_index].query

ls_intitial_value = get_initial_value(1)

If trim(ls_intitial_value) <> "" and not isnull(ls_intitial_value) and not preference_in_use Then
	script = ls_intitial_value
	li_sts = f_get_attachment_structure_from_xml(script, param_file)
	if li_sts <= 0 then
		setnull(script)
	end if
Else
	setnull(script)
end if

if len(script) > 0 then
	st_script.text = param_file.filename + "." + param_file.extension
else
	st_script.text = ""
end if


return 1

end function

public function integer pick_param ();str_popup popup
str_popup_return popup_return
string ls_extensions[]
integer li_extension_count
string ls_filter
long i
integer li_sts
string lsa_paths[]
string lsa_files[]
str_file_attributes lstr_file_attributes
long ll_filebytes
blob lbl_file
long ll_count
str_external_observation_attachment lstr_new_param_file
str_filepath lstr_filepath
string ls_new_script


li_extension_count = f_parse_string(filters, ",", ls_extensions)
ls_filter = ""
for i = 1 to li_extension_count
	if i > 1 then ls_filter += ","
	ls_filter += ls_extensions[i] + " files (*." + ls_extensions[i] + "), *." + ls_extensions[i]
next

li_sts = windows_api.comdlg32.getopenfilename( handle(w_main), &
															"Select " + st_title.text + " File", &
															lsa_paths, &
															lsa_files, &
															ls_filter)
if li_sts < 0 then return 0

ll_count = upperbound(lsa_paths)
if isnull(ll_count) or ll_count <= 0 then return 0

if ll_count > 1 then
	openwithparm(w_pop_message, "Multiple files selected.  Please select only one file.")
	return 0
end if

for i = 1 to ll_count
	// Skip the shorthand directories
	if lsa_files[i] = "." or lsa_files[i] = ".." then continue
	
	// Skip the file if we can't get its properties
	li_sts = log.file_attributes(lsa_paths[i], lstr_file_attributes)
	if li_sts <= 0 then continue
	
	// Skip the directories
	if lstr_file_attributes.subdirectory then continue
	
	ll_filebytes = log.file_read2(lsa_paths[i], lbl_file, false)
	if ll_filebytes > 0 then
		// We have a file, now create an attachment structure
		lstr_filepath = f_parse_filepath2(lsa_paths[i])
		lstr_new_param_file.filename = lstr_filepath.filename
		lstr_new_param_file.extension = lstr_filepath.extension
		lstr_new_param_file.attachment_comment_title = st_title.text
		lstr_new_param_file.attachment = lbl_file
		
		ls_new_script = f_get_xml_from_attachment_structure(lstr_new_param_file)
		exit
	end if
next

if isnull(ls_new_script) or len(ls_new_script) = 0 then
	return 0
end if

script = ls_new_script
param_file = lstr_new_param_file

update_param(param_wizard.params.params[param_index].token1, script)

if st_required.visible and not isnull(script) then
	param_wizard.event POST ue_required(true)
end if

st_script.text = param_file.filename + "." + param_file.extension

return 1

end function

on u_param_file_single.create
int iCurrent
call super::create
this.st_script=create st_script
this.cb_edit=create cb_edit
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_script
this.Control[iCurrent+2]=this.cb_edit
end on

on u_param_file_single.destroy
call super::destroy
destroy(this.st_script)
destroy(this.cb_edit)
end on

type st_preference from u_param_base`st_preference within u_param_file_single
end type

type st_preference_title from u_param_base`st_preference_title within u_param_file_single
end type

type cb_clear from u_param_base`cb_clear within u_param_file_single
integer y = 988
integer taborder = 30
end type

event cb_clear::clicked;call super::clicked;st_script.text = ""
setnull(script)

f_attribute_remove_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				param_wizard.params.id )


end event

type st_required from u_param_base`st_required within u_param_file_single
integer x = 1358
integer y = 424
end type

type st_helptext from u_param_base`st_helptext within u_param_file_single
end type

type st_title from u_param_base`st_title within u_param_file_single
integer y = 480
end type

type st_script from statictext within u_param_file_single
integer x = 1349
integer y = 476
integer width = 1184
integer height = 116
integer textsize = -11
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;pick_param()

param_wizard.bringtotop = true

end event

type cb_edit from commandbutton within u_param_file_single
integer x = 1755
integer y = 612
integer width = 366
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Edit"
end type

