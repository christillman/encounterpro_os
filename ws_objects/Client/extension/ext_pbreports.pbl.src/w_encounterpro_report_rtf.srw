$PBExportHeader$w_encounterpro_report_rtf.srw
forward
global type w_encounterpro_report_rtf from w_window_base
end type
type cb_ok from commandbutton within w_encounterpro_report_rtf
end type
type pb_cancel from u_picture_button within w_encounterpro_report_rtf
end type
type cb_print from commandbutton within w_encounterpro_report_rtf
end type
type cb_edit from commandbutton within w_encounterpro_report_rtf
end type
type cb_attach from commandbutton within w_encounterpro_report_rtf
end type
type st_display_script from statictext within w_encounterpro_report_rtf
end type
type cb_view from commandbutton within w_encounterpro_report_rtf
end type
type rte_report from u_rich_text_edit within w_encounterpro_report_rtf
end type
type cb_refresh from commandbutton within w_encounterpro_report_rtf
end type
type str_reentry_state from structure within w_encounterpro_report_rtf
end type
end forward

global type w_encounterpro_report_rtf from w_window_base
boolean visible = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_ok cb_ok
pb_cancel pb_cancel
cb_print cb_print
cb_edit cb_edit
cb_attach cb_attach
st_display_script st_display_script
cb_view cb_view
rte_report rte_report
cb_refresh cb_refresh
end type
global w_encounterpro_report_rtf w_encounterpro_report_rtf

type variables
u_component_report report

datetime file_updated
string temp_file

string view_mode = "Normal"

string default_attach_file_type
string default_edit_file_type


end variables

forward prototypes
public function string get_report_title ()
public function integer save_to_temp_file ()
public function integer attach ()
public function integer do_template ()
public function integer refresh ()
end prototypes

public function string get_report_title ();str_popup popup
str_popup_return popup_return
string ls_null

setnull(ls_null)

// Set the title
popup.title = "Please enter a report title or select one from the list below"

// Allow an empty string
popup.multiselect = true
popup.item = report.get_attribute("report_title")

popup.argument_count = 1
popup.argument[1] = "RPT|" + report.report_id

openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return ls_null

return popup_return.items[1]


end function

public function integer save_to_temp_file ();integer li_sts
str_file_attributes lstr_file
datetime ldt_updated

li_sts = rte_report.SaveDocument(temp_file)
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
string ls_temp_file

ls_temp_file = f_temp_file(default_attach_file_type)
li_sts = rte_report.savedocument(ls_temp_file)
if li_sts <= 0 then return -1

ls_date_suffix = "_" + string(today(), "yymmdd")

setnull(lstr_new_attachment.attachment_id)
lstr_new_attachment.extension = default_attach_file_type
lstr_new_attachment.attachment_type = "FILE"
lstr_new_attachment.attachment_tag = get_report_title()
if isnull(lstr_new_attachment.attachment_tag) then
	openwithparm(w_pop_message, "You must enter a report title.  Report has NOT been attached.")
	return 0
end if

lstr_new_attachment.attachment_file = lstr_new_attachment.attachment_tag + ls_date_suffix
lstr_new_attachment.attachment_folder = report.get_attribute("attachment_folder")

setnull(lstr_new_attachment.attachment_text)
ls_progress_type = report.get_attribute("progress_type")

lstr_new_attachment.cpr_id = current_patient.cpr_id
report.get_attribute("treatment_id", lstr_new_attachment.treatment_id)
report.get_attribute("problem_id", lstr_new_attachment.problem_id)
report.get_attribute("encounter_id", lstr_new_attachment.encounter_id)
report.get_attribute("observation_sequence", lstr_new_attachment.observation_sequence)

ll_attachment_id = current_patient.attachments.new_attachment(lstr_new_attachment, ls_temp_file, report.report_object, ls_progress_type)
if ll_attachment_id <= 0 then
	log.log(this, "w_encounterpro_report_rtf.attach:0037", "Error creating attachment", 4)
	return -1
end if

openwithparm(w_pop_message, "Report was attached successfully.")

return 1

end function

public function integer do_template ();/////////////////////////////////////////////////////////////////////////////////////////////////////
//	Return: Integer
//
// Create By:Mark									Created On:01/23/02
//
// Description:
// 
//
//
////////////////////////////////////////////////////////////////////////////////////////////////////
integer li_sts
long ll_fieldid
string ls_fielddata
str_service_info lstr_service
str_c_display_script_command lstr_command
long ll_encounter_id
long ll_problem_id
long ll_treatment_id
str_encounter_description lstr_encounter
str_assessment_description lstr_assessment
str_treatment_description lstr_treatment
string ls_temp
long ll_object_key
long ll_template_length
blob lbl_report_template
any la_fielddata
long ll_fieldstart
long ll_fieldend
string ls_fieldtext
string ls_template_file

// Load the template, if any
SELECTBLOB template
INTO :lbl_report_template
FROM c_Report_Definition
WHERE report_id = :report.report_id;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	log.log(this, "w_encounterpro_report_rtf.do_template:0039", "report_id not found (" + report.report_id + ")", 4)
	return -1
end if

ll_template_length = len(lbl_report_template)
if not isnull(lbl_report_template) and ll_template_length > 0 then
	ls_template_file = f_temp_file("rtf")
	li_sts = log.file_write(lbl_report_template, ls_template_file)
	if li_sts >= 0 then
		rte_report.load_document(ls_template_file)
	end if
end if


// Get any available context
ll_object_key = long(report.get_attribute("encounter_id"))
if isnull(ll_object_key) then
	setnull(lstr_encounter.encounter_id)
else
	li_sts = current_patient.encounters.encounter(lstr_encounter, ll_object_key)
end if

ll_object_key = long(report.get_attribute("problem_id"))
if isnull(ll_object_key) then
	setnull(lstr_assessment.problem_id)
else
	li_sts = current_patient.assessments.assessment(lstr_assessment, ll_object_key)
end if

ll_object_key = long(report.get_attribute("treatment_id"))
if isnull(ll_object_key) then
	setnull(lstr_treatment.treatment_id)
else
	li_sts = current_patient.treatments.treatment(lstr_treatment, ll_object_key)
end if

// Turn off the standard footer
rte_report.nested = true

//// First go through all the command fields and execute the corresponding commands
//ll_fieldid = 0
//DO WHILE true
//	ll_fieldid = rte_report.object.fieldnext(ll_fieldid, 0)
//	if ll_fieldid <= 0 then exit
//	
//	rte_report.object.fieldcurrent = ll_fieldid
//	
//	la_fielddata = rte_report.object.fielddata[ll_fieldid]
//	if lower(classname(la_fielddata)) = "string" then
//		ls_fielddata = string(la_fielddata)
//		ll_fieldstart = rte_report.object.fieldstart
//		ll_fieldend = rte_report.object.fieldend
//		ls_fieldtext = rte_report.object.fieldtext
//		
//		lstr_service = f_field_data_to_service(ls_fielddata)
//		f_split_string(lstr_service.service, " ", lstr_command.context_object, lstr_command.display_command)
//		lstr_command.attributes = lstr_service.attributes
//		
//		rte_report.object.selstart = ll_fieldend
//		rte_report.object.sellength = 0
//		rte_report.object.fieldtext = ""
//		rte_report.object.fontunderline = 0
//		rte_report.object.forecolor = color_black
//	
//		rte_report.display_script_command( lstr_command, lstr_encounter, lstr_assessment, lstr_treatment)	
//	end if
//LOOP

// Turn on the standard footer
rte_report.nested = false
	

Return 1


end function

public function integer refresh ();integer li_sts
long ll_display_script_id

rte_report.clear_rtf()

TRY
	li_sts = do_template( )
CATCH (throwable le_error)
	log.log(this, "w_encounterpro_report_rtf.refresh:0009", "Error calling do_template()", 4)
	close(this)
	return -1
END TRY

// Then, if there's a display script, execute it
report.get_attribute("display_script_id", ll_display_script_id)
if not isnull(ll_display_script_id) then
	rte_report.goto_end_of_text()
	rte_report.display_script(ll_display_script_id)
end if

return 1

end function

on w_encounterpro_report_rtf.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.pb_cancel=create pb_cancel
this.cb_print=create cb_print
this.cb_edit=create cb_edit
this.cb_attach=create cb_attach
this.st_display_script=create st_display_script
this.cb_view=create cb_view
this.rte_report=create rte_report
this.cb_refresh=create cb_refresh
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.cb_print
this.Control[iCurrent+4]=this.cb_edit
this.Control[iCurrent+5]=this.cb_attach
this.Control[iCurrent+6]=this.st_display_script
this.Control[iCurrent+7]=this.cb_view
this.Control[iCurrent+8]=this.rte_report
this.Control[iCurrent+9]=this.cb_refresh
end on

on w_encounterpro_report_rtf.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.pb_cancel)
destroy(this.cb_print)
destroy(this.cb_edit)
destroy(this.cb_attach)
destroy(this.st_display_script)
destroy(this.cb_view)
destroy(this.rte_report)
destroy(this.cb_refresh)
end on

event open;call super::open;str_external_observation_attachment lstr_document
boolean lb_full_screen
string ls_path
string ls_temp

string ls_destination
long ll_line
string ls_message
string ls_office_id
integer li_sts
long ll_display_script_id
string ls_display_script
string ls_printer
long ll_page_width
long ll_page_height


report = message.powerobjectparm

report.get_attribute("full_screen", lb_full_screen)
if lb_full_screen then
	windowstate = Maximized!
end if

if not isnull(current_patient) then
	title = current_patient.id_line()
else
	title = "Report"
end if

rte_report.set_report_attributes(report.get_attributes())
rte_report.reader_user_id = report.get_attribute("reader_user_id")

rte_report.set_background_color(rgb(255, 255, 255))

if isnull(report.report_object) then
	cb_attach.visible = false
end if

default_attach_file_type = report.get_attribute("default_attach_file_type")
if isnull(default_attach_file_type) then default_attach_file_type = "pdf"

default_edit_file_type = report.get_attribute("default_edit_file_type")
if isnull(default_edit_file_type) then default_edit_file_type = "doc"

if isnull(temp_file) or trim(temp_file) = "" then
	temp_file = f_temp_file(default_edit_file_type)
end if

// Then, if there's a display script, execute it
report.get_attribute("display_script_id", ll_display_script_id)
if isnull(ll_display_script_id) then
	ls_display_script = "<None>"
else
	ls_display_script = datalist.display_script_description(ll_display_script_id)
end if

refresh()

// Make this window visible now if we're doing screen mode
ls_destination = upper(report.get_attribute("DESTINATION"))
if ls_destination = "SCREEN" then
	//visible = true
end if

report.get_attribute("page_width", ll_page_width)
if ll_page_width > 0 then rte_report.set_page_width(ll_page_width)

report.get_attribute("page_height", ll_page_height)
if ll_page_height > 0 then rte_report.set_page_height(ll_page_height)

if ls_destination = "SCREEN" then
	// Scroll back to the top
	rte_report.goto_top()
	visible = true
elseif ls_destination = "FILE" then
	report.get_attribute("extension", lstr_document.extension)
	if isnull(lstr_document.extension) then lstr_document.extension = default_attach_file_type

	ls_path = f_temp_file(lstr_document.extension)

	li_sts = rte_report.savedocument(ls_path)
	if li_sts <= 0 then
		log.log(this, "w_encounterpro_report_rtf:open", "Save to file failed (" + ls_path + ")", 4)
		setnull(lstr_document.attachment)
		closewithreturn(this, lstr_document)
	end if
	
	li_sts = log.file_read(ls_path, lstr_document.attachment)
	if li_sts <= 0 then
		log.log(this, "w_encounterpro_report_rtf:open", "Error reading file (" + ls_path + ")", 4)
		setnull(lstr_document.attachment)
		closewithreturn(this, lstr_document)
	end if
	
	lstr_document.attachment_type = f_attachment_type_from_object_type(lstr_document.extension)
	setnull(lstr_document.filename)
	setnull(lstr_document.attachment_comment)
	lstr_document.attachment_comment_title = datalist.display_script_description(ll_display_script_id)
	
	closewithreturn(this, lstr_document)
	return
else
	ls_message = "Report_id = " + report.report_id
	
	ls_message += "~nDisplay Script = " + ls_display_script

	ls_message += "~nPrinter = "
	ls_message += common_thread.current_printer()
	
	ls_message += "~nOffice_id = "
	ls_office_id = report.get_attribute("office_id")
	if isnull(ls_office_id) then
		ls_message += "<None>"
	else
		ls_message += ls_office_id
	end if

	log.log_db(this, "w_encounterpro_report_rtf:open", "Print Command Starting~n" + ls_message, 2)
	li_sts = rte_report.Print(1, "", false, true)
	if li_sts <= 0 then
		log.log(this, "w_encounterpro_report_rtf:open", "Print Command Failed~n" + ls_message, 4)
	else
		log.log_db(this, "w_encounterpro_report_rtf:open", "Print Command Succeeded~n" + ls_message, 2)
	end if
	close(this)
	return
end if

if config_mode then
	st_display_script.visible = true
	st_display_script.text = ls_display_script
else
	st_display_script.visible = false
end if

postevent("post_open")

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
	li_sts = rte_report.load_document(temp_file)
	if li_sts > 0 then
		file_updated = datetime(lstr_file.lastwritedate, relativetime(lstr_file.lastwritetime, 1))
	end if
end if


end event

event post_open;call super::post_open;
// The view_mode must be set after the RTF display script runs

view_mode = report.get_attribute("default_view_mode")
if isnull(view_mode) then
	// In version 4 this attribute was called "display_mode" with domain "SCREEN" or "PAGE"
	CHOOSE CASE upper(report.get_attribute("display_mode"))
		CASE "SCREEN"
			view_mode = "Normal"
		CASE "PAGE"
			view_mode = "Page"
		CASE "NORMAL"
			view_mode = "Normal"
		CASE ELSE
			view_mode = "Normal"
	END CHOOSE
end if

rte_report.set_view_mode(view_mode)
end event

type pb_epro_help from w_window_base`pb_epro_help within w_encounterpro_report_rtf
integer x = 2245
integer y = 1608
integer height = 116
boolean originalsize = false
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_encounterpro_report_rtf
end type

type cb_ok from commandbutton within w_encounterpro_report_rtf
integer x = 2514
integer y = 1608
integer width = 352
integer height = 116
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;close(parent)

end event

type pb_cancel from u_picture_button within w_encounterpro_report_rtf
boolean visible = false
integer x = 443
integer y = 1360
integer width = 256
integer height = 224
integer taborder = 30
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0
closewithreturn(parent, popup_return)

end event

type cb_print from commandbutton within w_encounterpro_report_rtf
integer x = 645
integer y = 1608
integer width = 242
integer height = 116
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print"
end type

event clicked;window lw_wait
string ls_printer

ls_printer = common_thread.select_printer()
// If the user didn't select a printer then don't do anything
if isnull(ls_printer) then return


open(lw_wait, "w_pop_please_wait", parent)

common_thread.set_printer(ls_printer)
rte_report.Print(1, "", false, true)
common_thread.set_default_printer()

close(lw_wait)

end event

type cb_edit from commandbutton within w_encounterpro_report_rtf
integer x = 910
integer y = 1608
integer width = 242
integer height = 116
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Edit"
end type

event clicked;integer li_sts
string ls_command

li_sts = save_to_temp_file()
if li_sts <= 0 then return

ls_command = 'cmd /c start "' + report.description + '" "' + temp_file + '"'
run(ls_command)

//ole_control.initialize(temp_file, parent, false)
//
//ole_control.activate(OffSite!)



timer(2)

end event

type cb_attach from commandbutton within w_encounterpro_report_rtf
integer x = 1509
integer y = 1608
integer width = 329
integer height = 116
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Save To..."
end type

event clicked;str_popup popup
str_popup_return popup_return
integer li_sts
string ls_path
string ls_file
string ls_filter
string ls_choices = "PDF Files (*.PDF), *.PDF, RTF Files (*.RTF), *.RTF, Doc Files (*.DOC), *.DOC,Text Files (*.TXT),*.TXT"

popup.title = "Save To..."
popup.data_row_count = 2
popup.items[1] = "File"
popup.items[2] = "Patient Folder"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.item_indexes[1] = 1 then
	ls_filter = datalist.get_preference("PREFERENCES", "rtf_save_file_filter", ls_choices)
	li_sts = GetFileSaveName("Select File", ls_path, ls_file, default_attach_file_type, ls_filter)
	if li_sts > 0 then
		rte_report.savedocument(ls_path)
	end if
else
	attach()
end if


end event

type st_display_script from statictext within w_encounterpro_report_rtf
integer x = 14
integer y = 1584
integer width = 608
integer height = 132
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean focusrectangle = false
end type

type cb_view from commandbutton within w_encounterpro_report_rtf
integer x = 1221
integer y = 1608
integer width = 210
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "View"
end type

event clicked;real lr_x_factor
real lr_y_factor
long ll_oldwidth
long ll_oldheight


ll_oldwidth = parent.width
ll_oldheight = parent.height

if view_mode = "Page" then
	view_mode = "Normal"
	rte_report.set_view_mode(view_mode)
else
	view_mode = "Page"
	rte_report.set_view_mode(view_mode)
end if


end event

type rte_report from u_rich_text_edit within w_encounterpro_report_rtf
integer x = 14
integer y = 20
integer width = 2885
integer height = 1548
integer taborder = 40
boolean bringtotop = true
end type

type cb_refresh from commandbutton within w_encounterpro_report_rtf
integer x = 1906
integer y = 1608
integer width = 297
integer height = 116
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Refresh"
end type

event clicked;string ls_save_view_mode

ls_save_view_mode = view_mode
if ls_save_view_mode = "Page" then
// To prevent Japanese-looking script results during refresh, the Preview mode must be OFF.
	rte_report.set_view_mode("Normal")
end if

refresh()

if ls_save_view_mode = "Page" then
	rte_report.set_view_mode(ls_save_view_mode)
end if

end event

