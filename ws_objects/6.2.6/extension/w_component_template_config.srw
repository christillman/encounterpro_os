HA$PBExportHeader$w_component_template_config.srw
forward
global type w_component_template_config from w_window_base
end type
type cb_ok from commandbutton within w_component_template_config
end type
type dw_templates from u_dw_pick_list within w_component_template_config
end type
type mle_template from multilineedit within w_component_template_config
end type
type st_template_title from statictext within w_component_template_config
end type
type st_title from statictext within w_component_template_config
end type
type st_templates_list_title from statictext within w_component_template_config
end type
type cb_new_template from commandbutton within w_component_template_config
end type
type cb_save_template from commandbutton within w_component_template_config
end type
type cb_cancel_edit from commandbutton within w_component_template_config
end type
type st_editlocal_helptext from statictext within w_component_template_config
end type
type st_editor_helptext from statictext within w_component_template_config
end type
end forward

global type w_component_template_config from w_window_base
integer width = 2953
integer height = 1928
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
cb_ok cb_ok
dw_templates dw_templates
mle_template mle_template
st_template_title st_template_title
st_title st_title
st_templates_list_title st_templates_list_title
cb_new_template cb_new_template
cb_save_template cb_save_template
cb_cancel_edit cb_cancel_edit
st_editlocal_helptext st_editlocal_helptext
st_editor_helptext st_editor_helptext
end type
global w_component_template_config w_component_template_config

type variables
u_component_document_template document

str_document_templates document_templates

datetime file_updated
string temp_file

string view_mode = "List"
long editing_template_index

string document_description

string report_id

end variables

forward prototypes
public function string get_report_title ()
public function integer save_to_temp_file ()
public function integer attach ()
public subroutine resize_objects ()
public function integer refresh ()
public subroutine template_menu (long pl_row)
public subroutine move_template (long pl_row)
end prototypes

public function string get_report_title ();str_popup popup
str_popup_return popup_return
string ls_null

setnull(ls_null)

// Set the title
popup.title = "Please enter a report title or select one from the list below"

// Allow an empty string
popup.multiselect = true
popup.item = document.get_attribute("report_title")

popup.argument_count = 1
popup.argument[1] = "RPT|" + document.external_source

openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return ls_null

return popup_return.items[1]


end function

public function integer save_to_temp_file ();integer li_sts
str_file_attributes lstr_file
datetime ldt_updated

//li_sts = rte_report.SaveDocument(temp_file)
if li_sts <= 0 then return -1

li_sts = log.file_attributes(temp_file, lstr_file)
if li_sts <= 0 then return -1

file_updated = datetime(lstr_file.lastwritedate, relativetime(lstr_file.lastwritetime, 1))

return 1


end function

public function integer attach ();str_attachment lstr_new_attachment
string ls_date_suffix
long ll_attachment_id
string ls_progress_type
integer li_sts

li_sts = save_to_temp_file()
if li_sts <= 0 then return -1

ls_date_suffix = "_" + string(today(), "yymmdd")

setnull(lstr_new_attachment.attachment_id)
lstr_new_attachment.extension = "rtf"
lstr_new_attachment.attachment_type = "FILE"
lstr_new_attachment.attachment_tag = get_report_title()
if isnull(lstr_new_attachment.attachment_tag) then
	openwithparm(w_pop_message, "You must enter a report title.  Report has NOT been attached.")
	return 0
end if

lstr_new_attachment.attachment_file = lstr_new_attachment.attachment_tag + ls_date_suffix
lstr_new_attachment.attachment_folder = document.get_attribute("attachment_folder")

setnull(lstr_new_attachment.attachment_text)
ls_progress_type = document.get_attribute("progress_type")

lstr_new_attachment.cpr_id = current_patient.cpr_id
document.get_attribute("treatment_id", lstr_new_attachment.treatment_id)
document.get_attribute("problem_id", lstr_new_attachment.problem_id)
document.get_attribute("encounter_id", lstr_new_attachment.encounter_id)
document.get_attribute("observation_sequence", lstr_new_attachment.observation_sequence)

ll_attachment_id = current_patient.attachments.new_attachment(lstr_new_attachment, temp_file, document.context_object, ls_progress_type)
if ll_attachment_id <= 0 then
	log.log(this, "results_posted", "Error creating attachment", 4)
	return -1
end if

openwithparm(w_pop_message, "Report was attached successfully.")

return 1

end function

public subroutine resize_objects ();
st_title.width = width

cb_ok.x = width - cb_ok.width - 50
cb_ok.y = height - cb_ok.height - 150

cb_new_template.x = (width - cb_new_template.width) / 2
cb_new_template.y = (height - cb_new_template.height) / 2

dw_templates.x = (width - dw_templates.width) / 2
dw_templates.height = cb_new_template.y - dw_templates.y - 30

st_templates_list_title.x = dw_templates.x

st_template_title.x = 200
st_template_title.y = cb_new_template.y + cb_new_template.height + 50

mle_template.x = st_template_title.x
mle_template.y = st_template_title.y + st_template_title.height + 8
mle_template.height = st_editor_helptext.height
mle_template.width = width - (2 * st_template_title.x)

st_editor_helptext.x = mle_template.x
st_editor_helptext.y = mle_template.y
st_editor_helptext.height = mle_template.height
st_editor_helptext.width = mle_template.width

st_editlocal_helptext.x = (width - st_editlocal_helptext.width) / 2
st_editlocal_helptext.y = mle_template.y - st_editlocal_helptext.height - 20

cb_cancel_edit.x = (width/2) - cb_cancel_edit.width - 30
cb_cancel_edit.y = mle_template.y + mle_template.height + 30

cb_save_template.x = (width/2) + 30
cb_save_template.y = cb_cancel_edit.y


end subroutine

public function integer refresh ();long i
long ll_row

CHOOSE CASE lower(view_mode)
	CASE "editlocal"
		cb_new_template.visible = false
		dw_templates.enabled = false
		st_editlocal_helptext.visible = true
		st_template_title.visible = true
		mle_template.visible = true
		cb_cancel_edit.visible = true
		cb_save_template.visible = true
		st_editor_helptext.visible = false
	CASE "edit"
		// editor has been called
		cb_new_template.visible = false
		dw_templates.enabled = false
		st_editlocal_helptext.visible = false
		st_template_title.visible = false
		mle_template.visible = false
		cb_cancel_edit.visible = true
		cb_save_template.visible = false
		st_editor_helptext.visible = true
	CASE ELSE // List mode
		cb_new_template.visible = true
		st_editlocal_helptext.visible = false
		st_template_title.visible = false
		mle_template.visible = false
		cb_cancel_edit.visible = false
		cb_save_template.visible = false
		st_editor_helptext.visible = false
		
		dw_templates.setredraw(false)
		
		dw_templates.reset()
		
		for i = 1 to document_templates.template_count
			ll_row = dw_templates.insertrow(0)
			dw_templates.object.description[ll_row] = document_templates.template[i].description
			dw_templates.object.filetype[ll_row] = document_templates.template[i].templatefile.filetype
			dw_templates.object.modified[ll_row] = document_templates.template[i].templatefile.modifieddate
			dw_templates.object.sort_sequence[ll_row] = document_templates.template[i].sortsequence
			dw_templates.object.template_index[ll_row] = i
		next
		
		dw_templates.sort()
		dw_templates.setredraw(true)
		
		dw_templates.enabled = true
END CHOOSE



return 1

end function

public subroutine template_menu (long pl_row);long i
long ll_template_index
String		buttons[]
String 		ls_drug_id,ls_temp
String 		ls_description
string		ls_null
String		ls_top_20_code
Integer		button_pressed, li_sts, li_service_count
string		ls_config_object_id
string ls_new_config_object_id
long ll_null
str_config_object_info lstr_config_object_info
window 				lw_pop_buttons
//w_config_object_edit lw_edit_window
w_window_base lw_edit_window
str_popup 			popup
str_popup_return 	popup_return
//w_config_object_display		lw_config_object_display
w_window_base		lw_config_object_display
long ll_installed_version
boolean lb_locally_owned
long ll_production_version
long ll_beta_version
long ll_testing_version

Setnull(ls_null)
Setnull(ll_null)

ll_template_index = dw_templates.object.template_index[pl_row]


if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_edit2.bmp"
	popup.button_helps[popup.button_count] = "Edit template data on screen"
	popup.button_titles[popup.button_count] = "Edit"
	buttons[popup.button_count] = "EDITLOCAL"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_edit2.bmp"
	popup.button_helps[popup.button_count] = "Open template in editor application"
	popup.button_titles[popup.button_count] = "Call Editor"
	buttons[popup.button_count] = "EDIT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonmove.bmp"
	popup.button_helps[popup.button_count] = "Move/Reorder Template"
	popup.button_titles[popup.button_count] = "Move"
	buttons[popup.button_count] = "MOVE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_rename.bmp"
	popup.button_helps[popup.button_count] = "Rename Template"
	popup.button_titles[popup.button_count] = "Rename"
	buttons[popup.button_count] = "RENAME"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Delete Template"
	popup.button_titles[popup.button_count] = "Delete"
	buttons[popup.button_count] = "DELETE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons", this)
	button_pressed = message.doubleparm
	if button_pressed < 1 or button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if

CHOOSE CASE buttons[button_pressed]
	CASE "EDITLOCAL"
		mle_template.text = f_blob_to_string(document_templates.template[ll_template_index].templatefile.templatedata)
		editing_template_index = ll_template_index
		view_mode = "EditLocal"
		refresh()
	CASE "EDIT"
	CASE "MOVE"
		move_template(pl_row)
	CASE "RENAME"
		popup.title = "Enter new name for this template"
		popup.displaycolumn = 80
		openwithparm(w_pop_prompt_string, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		
		// Make sure no other templates have this name
		for i = 1 to document_templates.template_count
			if i <> ll_template_index &
				and lower(document_templates.template[i].description) = lower(popup_return.items[1]) then
				openwithparm(w_pop_message, "Another template already has that name.  Each template must have a unique name.")
				return
			end if
		next
		
		document_templates.template[ll_template_index].description = popup_return.items[1]
		refresh()
	CASE "DELETE"
		for i = ll_template_index to document_templates.template_count - 1
			document_templates.template[i] = document_templates.template[i + 1]
		next
		document_templates.template_count -= 1
		refresh()
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE



end subroutine

public subroutine move_template (long pl_row);str_popup popup
long i
long ll_template_index
long ll_sort_sequence

if pl_row <= 0 then return

for i = 1 to dw_templates.rowcount()
	dw_templates.object.sort_sequence[i] = i
next

popup.objectparm = dw_templates
openwithparm(w_pick_list_sort, popup, this)

for i = 1 to dw_templates.rowcount()
	ll_template_index = dw_templates.object.template_index[i]
	ll_sort_sequence = dw_templates.object.sort_sequence[i]
	if ll_template_index > 0 then
		document_templates.template[ll_template_index].sortsequence = ll_sort_sequence
	end if
next

return

end subroutine

on w_component_template_config.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.dw_templates=create dw_templates
this.mle_template=create mle_template
this.st_template_title=create st_template_title
this.st_title=create st_title
this.st_templates_list_title=create st_templates_list_title
this.cb_new_template=create cb_new_template
this.cb_save_template=create cb_save_template
this.cb_cancel_edit=create cb_cancel_edit
this.st_editlocal_helptext=create st_editlocal_helptext
this.st_editor_helptext=create st_editor_helptext
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.dw_templates
this.Control[iCurrent+3]=this.mle_template
this.Control[iCurrent+4]=this.st_template_title
this.Control[iCurrent+5]=this.st_title
this.Control[iCurrent+6]=this.st_templates_list_title
this.Control[iCurrent+7]=this.cb_new_template
this.Control[iCurrent+8]=this.cb_save_template
this.Control[iCurrent+9]=this.cb_cancel_edit
this.Control[iCurrent+10]=this.st_editlocal_helptext
this.Control[iCurrent+11]=this.st_editor_helptext
end on

on w_component_template_config.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.dw_templates)
destroy(this.mle_template)
destroy(this.st_template_title)
destroy(this.st_title)
destroy(this.st_templates_list_title)
destroy(this.cb_new_template)
destroy(this.cb_save_template)
destroy(this.cb_cancel_edit)
destroy(this.st_editlocal_helptext)
destroy(this.st_editor_helptext)
end on

event open;call super::open;
document = message.powerobjectparm

title = "Document Template Configuration"

document_templates = document.get_document_templates()

report_id = document.get_attribute("report_id")

SELECT description
INTO :st_title.text
FROM c_Report_Definition
WHERE report_id = :report_id;
if not tf_check() then return

st_editor_helptext.text = "The template file should now be open in another application.  Make changes to the template file in that application and save and exit.  Use curly brackets {} to enclose fields that can later be mapped to clinical data.  If this message does not disappear after exiting the other application, click ~"Cancel Edit~"."

resize_objects()

view_mode = "List"

refresh()


end event

event timer;str_file_attributes lstr_file
integer li_sts
datetime ldt_updated
integer li_file

// Make sure file isn't locked
li_file = FileOpen(temp_file, LineMode!, Read!, LockReadWrite!, Append!)
if li_file < 0 then return
FileClose(li_file)

li_sts = log.file_attributes(temp_file, lstr_file)
if li_sts <= 0 then return

ldt_updated = datetime(lstr_file.lastwritedate, lstr_file.lastwritetime)
if ldt_updated > file_updated then
//	li_sts = rte_report.load_document(temp_file)
	if li_sts > 0 then
		file_updated = datetime(lstr_file.lastwritedate, relativetime(lstr_file.lastwritetime, 1))
	end if
end if


end event

event resize;call super::resize;resize_objects()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_component_template_config
integer x = 2885
integer y = 0
integer height = 116
boolean originalsize = false
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_component_template_config
integer x = 59
integer y = 1408
end type

type cb_ok from commandbutton within w_component_template_config
integer x = 2423
integer y = 1680
integer width = 475
integer height = 116
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;integer li_sts

li_sts = document.save_document_templates(document_templates)

if li_sts < 0 then
	openwithparm(w_pop_message, "Error saving template changes")
	return
end if

closewithreturn(parent, "OK")

end event

type dw_templates from u_dw_pick_list within w_component_template_config
integer x = 302
integer y = 244
integer width = 2345
integer height = 616
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_component_template_edit"
boolean vscrollbar = true
end type

event buttonclicked;call super::buttonclicked;
if lower(view_mode) = "list" then template_menu(row)

end event

type mle_template from multilineedit within w_component_template_config
integer x = 233
integer y = 1092
integer width = 2487
integer height = 396
integer taborder = 21
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean hscrollbar = true
boolean vscrollbar = true
boolean autohscroll = true
boolean autovscroll = true
borderstyle borderstyle = stylelowered!
end type

type st_template_title from statictext within w_component_template_config
integer x = 233
integer y = 1024
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Template"
boolean focusrectangle = false
end type

type st_title from statictext within w_component_template_config
integer width = 2949
integer height = 128
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Document Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_templates_list_title from statictext within w_component_template_config
integer x = 302
integer y = 172
integer width = 485
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Template Files"
boolean focusrectangle = false
end type

type cb_new_template from commandbutton within w_component_template_config
integer x = 1152
integer y = 904
integer width = 645
integer height = 112
integer taborder = 21
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Template File"
end type

event clicked;str_popup popup
str_popup_return popup_return
long ll_choice
str_document_template lstr_template
long ll_row
long i

popup.data_row_count = 3
popup.title = "Do you wish to ..."
popup.items[1] = "Import Template File"
popup.items[2] = "Create Template on Screen"
popup.items[3] = "Cancel"
openwithparm(w_pop_choices_3, popup)
ll_choice = message.doubleparm

if isnull(ll_choice) or ll_choice < 1 or ll_choice > 2 then return

popup.data_row_count = 0
popup.title = "Enter the name of the new template"
popup.displaycolumn = 80
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

// Make sure no other templates have this name
for i = 1 to document_templates.template_count
	if lower(document_templates.template[i].description) = lower(popup_return.items[1]) then
		openwithparm(w_pop_message, "Another template already has that name.  Each template must have a unique name.")
		return
	end if
next

lstr_template.description = popup_return.items[1]
lstr_template.sortsequence = dw_templates.rowcount() + 1
setnull(lstr_template.templatefile.filename)
setnull(lstr_template.templatefile.modifieddate)

if ll_choice = 2 then
	popup.data_row_count = 0
	popup.title = "Enter the filetype of the new template"
	popup.displaycolumn = 24
	openwithparm(w_pop_prompt_string, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return
	
	lstr_template.templatefile.filetype = popup_return.items[1]
	
	document_templates.template_count += 1
	document_templates.template[document_templates.template_count] = lstr_template
	
	ll_row = dw_templates.insertrow(0)
	dw_templates.object.description[ll_row] = lstr_template.description
	dw_templates.object.filetype[ll_row] = lstr_template.templatefile.filetype
	dw_templates.object.modified[ll_row] = lstr_template.templatefile.modifieddate
	dw_templates.object.sort_sequence[ll_row] = lstr_template.sortsequence
	dw_templates.object.template_index[ll_row] = document_templates.template_count
	dw_templates.scrolltorow(ll_row)
	dw_templates.object.selected_flag[ll_row] = 1
	
	editing_template_index = document_templates.template_count
	view_mode = "EditLocal"
	refresh()
	return
end if


end event

type cb_save_template from commandbutton within w_component_template_config
integer x = 1559
integer y = 1516
integer width = 526
integer height = 112
integer taborder = 31
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Save Changes"
end type

event clicked;
document_templates.template[editing_template_index].templatefile.templatedata = blob(mle_template.text)
document_templates.template[editing_template_index].templatefile.modifieddate = datetime(today(), now())

view_mode = "List"

refresh()

end event

type cb_cancel_edit from commandbutton within w_component_template_config
integer x = 965
integer y = 1516
integer width = 526
integer height = 112
integer taborder = 41
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel Edit"
end type

event clicked;
view_mode = "List"

refresh()


end event

type st_editlocal_helptext from statictext within w_component_template_config
integer x = 613
integer y = 944
integer width = 1719
integer height = 140
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Edit the contents of this template file.  Use curly brackets {} to enclose fields that can later be mapped to clinical data"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_editor_helptext from statictext within w_component_template_config
integer x = 233
integer y = 1092
integer width = 2487
integer height = 396
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
alignment alignment = center!
boolean focusrectangle = false
end type

