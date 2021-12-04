$PBExportHeader$w_doc_datawindow.srw
forward
global type w_doc_datawindow from w_window_base
end type
type st_title from statictext within w_doc_datawindow
end type
type cb_ok from commandbutton within w_doc_datawindow
end type
type cb_cancel from commandbutton within w_doc_datawindow
end type
type dw_document from u_dw_pick_list within w_doc_datawindow
end type
type cb_saveas from commandbutton within w_doc_datawindow
end type
end forward

global type w_doc_datawindow from w_window_base
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_title st_title
cb_ok cb_ok
cb_cancel cb_cancel
dw_document dw_document
cb_saveas cb_saveas
end type
global w_doc_datawindow w_doc_datawindow

type variables
u_component_document document

long document_rowcount

str_doc_file_save_params file_save_params



end variables

forward prototypes
public function integer save_to_file ()
public function integer refresh ()
end prototypes

public function integer save_to_file ();blob lbl_rtf_file
integer li_sts
encoding le_encoding
saveastype le_saveastype
blob lbl_document

CHOOSE CASE upper(file_save_params.encoding)
	CASE "ANSI"
		le_encoding = EncodingANSI!
	CASE "UTF-8"
		le_encoding = EncodingUTF8!
	CASE "UTF-16LE"
		le_encoding = EncodingUTF16LE!
	CASE "UTF-16BE"
		le_encoding = EncodingUTF16BE!
	CASE ELSE
		le_encoding = EncodingUTF16LE!
END CHOOSE

CHOOSE CASE lower(file_save_params.file_type)
	CASE "pdf"
		le_saveastype = PDF!
	CASE "txt"
		le_saveastype = Text!
	CASE "csv"
		le_saveastype = CSV!
	CASE "psr"
		le_saveastype = PSReport!
	CASE "html", "htm"
		le_saveastype = HTMLTable!
	CASE "xml"
		le_saveastype = XML!
	CASE "txt"
		le_saveastype = Text!
	CASE "xslfo"
		le_saveastype = XSLFO!
	CASE "xls"
		le_saveastype = Excel8!
	CASE "emf"
		le_saveastype = EMF!
	CASE ELSE
		file_save_params.file_type = "pdf"
		le_saveastype = PDF!
END CHOOSE

if isnull(file_save_params.file_path) or trim(file_save_params.file_path) = "" then
	file_save_params.file_path = f_temp_file(file_save_params.file_type)
end if

li_sts = dw_document.saveas(file_save_params.file_path, le_saveastype, file_save_params.include_column_headings, le_encoding)
if li_sts <= 0 then
	log.log(this, "w_doc_datawindow.save_to_file:0052", "Error saving datawindow to file (" + file_save_params.file_path + ")", 4)
	return -1
end if

li_sts = log.file_read(file_save_params.file_path, lbl_document)
if li_sts <= 0 then
	log.log(this, "w_doc_datawindow.save_to_file:0058", "Error reading temp file (" + file_save_params.file_path + ")", 4)
	return -1
end if


return 1

end function

public function integer refresh ();any laa_argument[]
string ls_datawindow_definition
string ls_error_create
string ls_new_sql
long i
str_datawindow_arguments lstr_arguments
long ll_temp
decimal ldc_temp
string ls_temp
date ld_temp
time lt_temp
datetime ldt_temp
integer li_sts
string ls_sts

ls_datawindow_definition = document.get_attribute("datawindow_definition")
dw_document.Create(ls_datawindow_definition, ls_error_create)
if Len(ls_error_create) > 0 THEN
	if isnull(ls_error_create) then ls_error_create = "<Null>"
	log.log(this, "w_doc_datawindow.refresh:0020", "Error creating datastore (" + ls_error_create + ")", 4)
	close(this)
end if

// Parse the datawindow syntax to find the argument list
lstr_arguments = f_get_datawindow_arguments(ls_datawindow_definition)

for i = 1 to lstr_arguments.argument_count
	CHOOSE CASE lower(lstr_arguments.argument[i].argument_type)
		CASE "number"
			document.get_attribute("argument_" + string(i), ll_temp)
			laa_argument[i] = ll_temp
		CASE "string"
			document.get_attribute("argument_" + string(i), ls_temp)
			laa_argument[i] = ls_temp
		CASE "date"
			document.get_attribute("argument_" + string(i), ls_temp)
			ld_temp = date(ls_temp)
			laa_argument[i] = ld_temp
		CASE "time"
			document.get_attribute("argument_" + string(i), ls_temp)
			lt_temp = time(ls_temp)
			laa_argument[i] = lt_temp
		CASE "datetime"
			document.get_attribute("argument_" + string(i), ls_temp)
			ldt_temp = f_string_to_datetime(ls_temp)
			laa_argument[i] = ldt_temp
		CASE "decimal"
			document.get_attribute("argument_" + string(i), ls_temp)
			ldc_temp = dec(ls_temp)
			laa_argument[i] = ldc_temp
		CASE ELSE
			document.get_attribute("argument_" + string(i), ls_temp)
			laa_argument[i] = ls_temp
	END CHOOSE
next

// If there is a temp stored proc then use it
if len(document.temp_stored_proc) > 0 then
	ls_new_sql = "EXECUTE " + document.temp_stored_proc
	
	if document.temp_stored_proc_argument_count <> lstr_arguments.argument_count then
		log.log(this, "w_doc_datawindow.refresh:0062", "SQL argument count does not match datawindow argument count", 3)
	end if
	
	// Add the arguments found in the sql script
	for i = 1 to lstr_arguments.argument_count
		if i > 1 then ls_new_sql += ","
		ls_new_sql += " :" + lstr_arguments.argument[i].argument_name
	next
	
//	li_sts = dw_document.setsqlselect(ls_new_sql)
	ls_sts = dw_document.Modify("DataWindow.Table.Select=~"" + ls_new_sql + "~"")
	if len(ls_sts) > 0 then
		log.log(this, "w_doc_datawindow.refresh:0074", "Setting the datawindow SQL failed:  " + ls_sts + "~r~n" + ls_new_sql, 4)
		return -1
	end if
end if

// Execute the datawindow
dw_document.settransobject(sqlca)

CHOOSE CASE lstr_arguments.argument_count
	CASE 0
		document_rowcount = dw_document.retrieve()
	CASE 1
		document_rowcount = dw_document.retrieve(laa_argument[1])
	CASE 2
		document_rowcount = dw_document.retrieve(laa_argument[1], laa_argument[2])
	CASE 3
		document_rowcount = dw_document.retrieve(laa_argument[1], laa_argument[2], laa_argument[3])
	CASE 4
		document_rowcount = dw_document.retrieve(laa_argument[1], laa_argument[2], laa_argument[3], laa_argument[4])
	CASE 5
		document_rowcount = dw_document.retrieve(laa_argument[1], laa_argument[2], laa_argument[3], laa_argument[4], laa_argument[5])
	CASE 6
		document_rowcount = dw_document.retrieve(laa_argument[1], laa_argument[2], laa_argument[3], laa_argument[4], laa_argument[5], laa_argument[6])
	CASE 7
		document_rowcount = dw_document.retrieve(laa_argument[1], laa_argument[2], laa_argument[3], laa_argument[4], laa_argument[5], laa_argument[6], laa_argument[7])
	CASE 8
		document_rowcount = dw_document.retrieve(laa_argument[1], laa_argument[2], laa_argument[3], laa_argument[4], laa_argument[5], laa_argument[6], laa_argument[7], laa_argument[8])
END CHOOSE

if document_rowcount < 0 then return -1

return 1

end function

on w_doc_datawindow.create
int iCurrent
call super::create
this.st_title=create st_title
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.dw_document=create dw_document
this.cb_saveas=create cb_saveas
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.dw_document
this.Control[iCurrent+5]=this.cb_saveas
end on

on w_doc_datawindow.destroy
call super::destroy
destroy(this.st_title)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.dw_document)
destroy(this.cb_saveas)
end on

event open;call super::open;string ls_datawindow_definition
string ls_error_create
long ll_count
boolean lb_show_user_interface

document = message.powerobjectparm

document.get_attribute("show_user_interface", lb_show_user_interface, false)


file_save_params.file_type = document.get_attribute("return_file_type")
if isnull(file_save_params.file_type) then
	file_save_params.file_type = "pdf"
end if

file_save_params.encoding = document.get_attribute("document_encoding")
if isnull(file_save_params.encoding) then
	file_save_params.encoding = "UTF-16LE"
end if

document.get_attribute("include_column_headings", file_save_params.include_column_headings, true)


refresh()


if not lb_show_user_interface then
	visible = false
	cb_OK.event POST clicked()
end if

end event

type pb_epro_help from w_window_base`pb_epro_help within w_doc_datawindow
boolean visible = true
integer x = 2857
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_doc_datawindow
end type

type st_title from statictext within w_doc_datawindow
integer width = 2930
integer height = 116
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Datawindow Document"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_doc_datawindow
integer x = 2478
integer y = 1608
integer width = 402
integer height = 112
integer taborder = 30
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

event clicked;integer li_sts
blob lbl_document

li_sts = save_to_file()
if li_sts <= 0 then
	if this.visible and gnv_app.cpr_mode = "CLIENT" then
		openwithparm(w_pop_message, "Save to file failed")
		return
	else
		closewithreturn(parent, "ERROR")
		return
	end if
end if

li_sts = log.file_read(file_save_params.file_path, lbl_document)
if li_sts <= 0 then
	if this.visible and gnv_app.cpr_mode = "CLIENT" then
		openwithparm(w_pop_message, "Reading saved file failed (" + file_save_params.file_path + ")")
		return
	else
		closewithreturn(parent, "ERROR")
		return
	end if
end if

document.observation_count = 1
document.observations[1].result_count = 0
document.observations[1].attachment_list.attachment_count = 1
document.observations[1].attachment_list.attachments[1].attachment_type = "FILE"
document.observations[1].attachment_list.attachments[1].extension = file_save_params.file_type
document.observations[1].attachment_list.attachments[1].attachment_comment_title = document.get_attribute("document_description")
document.observations[1].attachment_list.attachments[1].attachment = lbl_document

document.observations[1].attachment_list.attachments[1].attached_by_user_id = current_user.user_id


closewithreturn(parent, "OK")

end event

type cb_cancel from commandbutton within w_doc_datawindow
integer x = 27
integer y = 1608
integer width = 402
integer height = 112
integer taborder = 40
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

event clicked;closewithreturn(parent, "CANCEL")

end event

type dw_document from u_dw_pick_list within w_doc_datawindow
integer x = 32
integer y = 132
integer width = 2839
integer height = 1436
integer taborder = 11
boolean bringtotop = true
end type

type cb_saveas from commandbutton within w_doc_datawindow
integer x = 1216
integer y = 1608
integer width = 498
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Save As"
boolean default = true
end type

event clicked;integer li_sts
str_popup_return popup_return
string ls_message

openwithparm(w_doc_datawindow, file_save_params)
popup_return = message.powerobjectparm
if popup_return.item = "OK" then
	file_save_params = popup_return.returnobject
else
	return
end if

li_sts = save_to_file()
if li_sts <= 0 then
	ls_message = "Error saving file (" + file_save_params.file_path + ")"
else
	ls_message = "Succefully saved file (" + file_save_params.file_path + ")"
end if
openwithparm(w_pop_message, ls_message)


end event

