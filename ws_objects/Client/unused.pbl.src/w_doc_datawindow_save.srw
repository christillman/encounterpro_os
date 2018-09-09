$PBExportHeader$w_doc_datawindow_save.srw
forward
global type w_doc_datawindow_save from w_window_base
end type
type st_title from statictext within w_doc_datawindow_save
end type
type cb_ok from commandbutton within w_doc_datawindow_save
end type
type cb_cancel from commandbutton within w_doc_datawindow_save
end type
type st_1 from statictext within w_doc_datawindow_save
end type
type sle_filepath from singlelineedit within w_doc_datawindow_save
end type
type cb_pick_file from commandbutton within w_doc_datawindow_save
end type
type st_encoding_title from statictext within w_doc_datawindow_save
end type
type st_include_headings from statictext within w_doc_datawindow_save
end type
type st_include_yes from statictext within w_doc_datawindow_save
end type
type st_include_no from statictext within w_doc_datawindow_save
end type
type st_encoding from statictext within w_doc_datawindow_save
end type
end forward

global type w_doc_datawindow_save from w_window_base
integer width = 2080
integer height = 1120
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean auto_resize_window = false
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
st_title st_title
cb_ok cb_ok
cb_cancel cb_cancel
st_1 st_1
sle_filepath sle_filepath
cb_pick_file cb_pick_file
st_encoding_title st_encoding_title
st_include_headings st_include_headings
st_include_yes st_include_yes
st_include_no st_include_no
st_encoding st_encoding
end type
global w_doc_datawindow_save w_doc_datawindow_save

type variables

str_doc_file_save_params file_save_params

end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();str_filepath lstr_filepath

sle_filepath.text = file_save_params.file_path

if len(file_save_params.file_path) > 0 then
	lstr_filepath = f_parse_filepath2(file_save_params.file_path)
	file_save_params.file_type = lstr_filepath.extension
else
	setnull(file_save_params.file_path)
	setnull(file_save_params.file_type)
end if


st_encoding.text = file_save_params.encoding
if file_save_params.include_column_headings then
	st_include_yes.backcolor = color_object_selected
	st_include_no.backcolor = color_object
else
	st_include_yes.backcolor = color_object
	st_include_no.backcolor = color_object_selected
end if

CHOOSE CASE lower(file_save_params.file_type)
	CASE "txt", "csv", "sql", "htm", "html", "dif"
		st_encoding.visible = true
		st_encoding_title.visible = true
	CASE ELSE
		st_encoding.visible = false
		st_encoding_title.visible = false
END CHOOSE

CHOOSE CASE lower(file_save_params.file_type)
	CASE "txt", "csv", "xls"
		st_include_yes.visible = true
		st_include_no.visible = true
		st_include_headings.visible = true
	CASE ELSE
		st_include_yes.visible = false
		st_include_no.visible = false
		st_include_headings.visible = false
END CHOOSE

return 1

end function

on w_doc_datawindow_save.create
int iCurrent
call super::create
this.st_title=create st_title
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.st_1=create st_1
this.sle_filepath=create sle_filepath
this.cb_pick_file=create cb_pick_file
this.st_encoding_title=create st_encoding_title
this.st_include_headings=create st_include_headings
this.st_include_yes=create st_include_yes
this.st_include_no=create st_include_no
this.st_encoding=create st_encoding
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.sle_filepath
this.Control[iCurrent+6]=this.cb_pick_file
this.Control[iCurrent+7]=this.st_encoding_title
this.Control[iCurrent+8]=this.st_include_headings
this.Control[iCurrent+9]=this.st_include_yes
this.Control[iCurrent+10]=this.st_include_no
this.Control[iCurrent+11]=this.st_encoding
end on

on w_doc_datawindow_save.destroy
call super::destroy
destroy(this.st_title)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.st_1)
destroy(this.sle_filepath)
destroy(this.cb_pick_file)
destroy(this.st_encoding_title)
destroy(this.st_include_headings)
destroy(this.st_include_yes)
destroy(this.st_include_no)
destroy(this.st_encoding)
end on

event open;call super::open;
x = main_window.x + ((main_window.width - width) / 2)
y = main_window.y + ((main_window.height - height) / 2)

file_save_params = message.powerobjectparm

refresh()


end event

type pb_epro_help from w_window_base`pb_epro_help within w_doc_datawindow_save
boolean visible = true
integer x = 3013
integer y = 0
integer taborder = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_doc_datawindow_save
end type

type st_title from statictext within w_doc_datawindow_save
integer width = 2071
integer height = 116
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Save Datawindow"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_doc_datawindow_save
integer x = 1618
integer y = 892
integer width = 402
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;str_popup_return popup_return

popup_return.returnobject = file_save_params
popup_return.item = "OK"

closewithreturn(parent, popup_return)


end event

type cb_cancel from commandbutton within w_doc_datawindow_save
integer x = 37
integer y = 892
integer width = 402
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;str_popup_return popup_return

popup_return.returnobject = file_save_params
popup_return.item = "CANCEL"

closewithreturn(parent, popup_return)


end event

type st_1 from statictext within w_doc_datawindow_save
integer x = 50
integer y = 328
integer width = 411
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "File Location:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_filepath from singlelineedit within w_doc_datawindow_save
integer x = 512
integer y = 324
integer width = 1317
integer height = 116
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
borderstyle borderstyle = stylelowered!
end type

type cb_pick_file from commandbutton within w_doc_datawindow_save
integer x = 1838
integer y = 332
integer width = 151
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_popup popup
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
string ls_file_types

ls_file_types = "pdf,psr,xls,txt,csv,xml,html,xslfo,xls"

li_extension_count = f_parse_string(ls_file_types, ",", ls_extensions)
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
	
	file_save_params.file_path = lsa_paths[i]
	refresh()
	exit
next



end event

type st_encoding_title from statictext within w_doc_datawindow_save
integer x = 590
integer y = 708
integer width = 411
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Encoding:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_include_headings from statictext within w_doc_datawindow_save
integer x = 165
integer y = 540
integer width = 837
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Include Column Headings:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_include_yes from statictext within w_doc_datawindow_save
integer x = 1051
integer y = 532
integer width = 206
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;file_save_params.include_column_headings = true
refresh()


end event

type st_include_no from statictext within w_doc_datawindow_save
integer x = 1326
integer y = 532
integer width = 206
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;file_save_params.include_column_headings = false
refresh()

end event

type st_encoding from statictext within w_doc_datawindow_save
integer x = 1051
integer y = 696
integer width = 480
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "UTF-16LE"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

// First get the actor class
popup.dataobject = "dw_domain_notranslate_list"
popup.argument_count = 1
popup.argument[1] = "TextEncoding"
popup.datacolumn = 2
popup.displaycolumn = 2
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return


file_save_params.encoding = popup_return.items[1]

refresh()

end event

