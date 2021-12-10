$PBExportHeader$w_route_web_upload.srw
forward
global type w_route_web_upload from w_window_base
end type
type cb_sent from commandbutton within w_route_web_upload
end type
type dw_files from u_dw_pick_list within w_route_web_upload
end type
type st_files_title from statictext within w_route_web_upload
end type
type st_web_site_title from statictext within w_route_web_upload
end type
type p_web_site_copy from picture within w_route_web_upload
end type
type shl_web_site from statichyperlink within w_route_web_upload
end type
type st_recipient from statictext within w_route_web_upload
end type
type cb_beback from commandbutton within w_route_web_upload
end type
type cb_open_folder from commandbutton within w_route_web_upload
end type
type str_working_file from structure within w_route_web_upload
end type
end forward

type str_working_file from structure
	string		attribute
	string		value
	str_patient_material		material
	string		working_file
	str_file_attributes		working_file_attributes
	boolean		working_file_updated
	unsignedlong		process_id
end type

global type w_route_web_upload from w_window_base
integer x = 439
integer y = 592
integer width = 2610
integer height = 1624
string title = "Web Upload Document Route"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
event putonclipboard ( string ps_string )
cb_sent cb_sent
dw_files dw_files
st_files_title st_files_title
st_web_site_title st_web_site_title
p_web_site_copy p_web_site_copy
shl_web_site shl_web_site
st_recipient st_recipient
cb_beback cb_beback
cb_open_folder cb_open_folder
end type
global w_route_web_upload w_route_web_upload

type variables
u_component_wp_item_document document

str_document_files document_files

string filepath

boolean file_done[]

end variables

forward prototypes
public function integer refresh ()
end prototypes

event putonclipboard(string ps_string);
clipboard(ps_string)

end event

public function integer refresh ();string ls_url
long ll_row
integer li_sts
long i

ls_url = document.get_attribute("URL")

st_recipient.text = user_list.user_full_name(document.ordered_for)

shl_web_site.text = ls_url
shl_web_site.url = ls_url

dw_files.reset()

for i = 1 to document_files.file_count
	ll_row = dw_files.insertrow(0)
	dw_files.object.description[ll_row] = document_files.file[i].filedescription
	dw_files.object.filename[ll_row] = document_files.file[i].Filename + "." + document_files.file[i].filetype
	if file_done[i] then
		dw_files.object.done[ll_row] = 1
	end if
next

cb_sent.enabled = true
for i = 1 to document_files.file_count
	if not file_done[i] then
		cb_sent.enabled = false
	end if
next

return 1

end function

event open;call super::open;integer li_sts
str_document_file lstr_file
long i

document = message.powerobjectparm

li_sts = document.get_document(lstr_file)
if li_sts <= 0 then
	log.log(this, "w_route_web_upload:open", "Error getting document file (" + string(document.patient_workplan_item_id) + ")", 4)
	close(this)
	return
end if

// If the document is zipped then it may be more than one file
if lower(lstr_file.filetype) = "zip" then
	li_sts = f_uncompress_documents(lstr_file, document_files, filepath)
	if li_sts < 0 then
		log.log(this, "w_route_web_upload:open", "Error uncompressing document file (" + string(document.patient_workplan_item_id) + ")", 4)
		close(this)
		return
	end if
else
	filepath = temp_path + "\" + f_new_guid()
	li_sts = createdirectory(filepath)
	if li_sts <= 0 then
		log.log(this, "w_route_web_upload:open", "Error creating temp directory (" + filepath + ")", 4)
		close(this)
		return
	end if
	
	li_sts = log.file_write(lstr_file.filedata, filepath + "\" + lstr_file.filename + "." + lstr_file.filetype)
	if li_sts < 0 then
		log.log(this, "w_route_web_upload:open", "Error writing document file (" + string(document.patient_workplan_item_id) + ")", 4)
		close(this)
		return
	end if
	
	document_files.file_count = 1
	document_files.file[1] = lstr_file
end if

for i = 1 to document_files.file_count
	file_done[i] = false
next

title = "Web Upload Document Route"

refresh()


end event

on w_route_web_upload.create
int iCurrent
call super::create
this.cb_sent=create cb_sent
this.dw_files=create dw_files
this.st_files_title=create st_files_title
this.st_web_site_title=create st_web_site_title
this.p_web_site_copy=create p_web_site_copy
this.shl_web_site=create shl_web_site
this.st_recipient=create st_recipient
this.cb_beback=create cb_beback
this.cb_open_folder=create cb_open_folder
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_sent
this.Control[iCurrent+2]=this.dw_files
this.Control[iCurrent+3]=this.st_files_title
this.Control[iCurrent+4]=this.st_web_site_title
this.Control[iCurrent+5]=this.p_web_site_copy
this.Control[iCurrent+6]=this.shl_web_site
this.Control[iCurrent+7]=this.st_recipient
this.Control[iCurrent+8]=this.cb_beback
this.Control[iCurrent+9]=this.cb_open_folder
end on

on w_route_web_upload.destroy
call super::destroy
destroy(this.cb_sent)
destroy(this.dw_files)
destroy(this.st_files_title)
destroy(this.st_web_site_title)
destroy(this.p_web_site_copy)
destroy(this.shl_web_site)
destroy(this.st_recipient)
destroy(this.cb_beback)
destroy(this.cb_open_folder)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_route_web_upload
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_route_web_upload
end type

type cb_sent from commandbutton within w_route_web_upload
integer x = 1993
integer y = 1376
integer width = 521
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "All Files Sent"
end type

event clicked;closewithreturn(parent, "OK")


end event

type dw_files from u_dw_pick_list within w_route_web_upload
integer x = 219
integer y = 524
integer width = 2126
integer height = 780
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_route_web_upload_files"
boolean vscrollbar = true
end type

event clicked;call super::clicked;string ls_filename
Integer li_sts
string lsa_paths[]
string lsa_files[]
string ls_filter
integer li_count
string ls_tempfile
string ls_thisfile
string ls_button
long i

ls_button = dwo.name

if row <= 0 or row > document_files.file_count then return

ls_thisfile = filepath + "\" + document_files.file[row].filename + "." + document_files.file[row].filetype

CHOOSE CASE lower(ls_button)
	CASE "p_copy_filename"
		parent.event POST putonclipboard(ls_thisfile)
	CASE "p_save_as"
		ls_filter = upper(document_files.file[row].filetype) + " Files (*." + lower(document_files.file[row].filetype) + "), *." + lower(document_files.file[row].filetype)
		
		ls_filename = document_files.file[row].filename + "." + document_files.file[row].filetype
		
		ls_filename = windows_api.comdlg32.getsavefilename( handle(w_main), &
																	"Save Document File", &
																	ls_filter, &
																	ls_filename)
		if isnull(ls_filename) then return
		
		if lower(right(ls_filename, len(document_files.file[row].filetype))) <> lower(document_files.file[row].filetype) then
			ls_filename += "." + document_files.file[row].filetype
		end if
		
		FileCopy(ls_thisfile, ls_filename, true)
	CASE "p_done"
		file_done[row] = true
		object.done[row] = 1
		for i = 1 to document_files.file_count
			if not file_done[i] then
				cb_sent.enabled = false
				return
			end if
		next
		cb_sent.enabled = true
	CASE "p_preview"
		ls_tempfile = f_temp_file(document_files.file[row].filetype)
		FileCopy(ls_thisfile, ls_tempfile, true)
		f_open_file(ls_tempfile, false)
	CASE "p_not_done"
		file_done[row] = false
		object.done[row] = 0
		cb_sent.enabled = false
END CHOOSE


return


end event

type st_files_title from statictext within w_route_web_upload
integer x = 219
integer y = 456
integer width = 2126
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Files to Upload"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_web_site_title from statictext within w_route_web_upload
integer x = 73
integer y = 188
integer width = 320
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Web Site:"
boolean focusrectangle = false
end type

type p_web_site_copy from picture within w_route_web_upload
integer x = 2350
integer y = 256
integer width = 165
integer height = 144
boolean bringtotop = true
string picturename = "button_copy.bmp"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;clipboard(shl_web_site.url)

end event

type shl_web_site from statichyperlink within w_route_web_upload
integer x = 73
integer y = 256
integer width = 2263
integer height = 144
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 134217856
long backcolor = 12632256
string text = "http://"
boolean border = true
boolean focusrectangle = false
end type

type st_recipient from statictext within w_route_web_upload
integer y = 20
integer width = 2587
integer height = 88
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Recipient"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_beback from commandbutton within w_route_web_upload
integer x = 73
integer y = 1376
integer width = 521
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
end type

event clicked;closewithreturn(parent, "BEBACK")

end event

type cb_open_folder from commandbutton within w_route_web_upload
integer x = 1029
integer y = 1316
integer width = 503
integer height = 84
integer taborder = 21
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Open Folder"
end type

event clicked;f_open_file(filepath, false)

end event

