$PBExportHeader$u_tabpage_incoming_documents_base.sru
forward
global type u_tabpage_incoming_documents_base from u_tabpage
end type
type st_attachment_details from statictext within u_tabpage_incoming_documents_base
end type
type cb_clear_all from commandbutton within u_tabpage_incoming_documents_base
end type
type cb_select_all from commandbutton within u_tabpage_incoming_documents_base
end type
type cb_sort from commandbutton within u_tabpage_incoming_documents_base
end type
type dw_holding_list from u_dw_pick_list within u_tabpage_incoming_documents_base
end type
type uo_picture from u_picture_display within u_tabpage_incoming_documents_base
end type
end forward

global type u_tabpage_incoming_documents_base from u_tabpage
integer width = 2889
integer height = 1616
event patient_posted ( string ps_cpr_id )
st_attachment_details st_attachment_details
cb_clear_all cb_clear_all
cb_select_all cb_select_all
cb_sort cb_sort
dw_holding_list dw_holding_list
uo_picture uo_picture
end type
global u_tabpage_incoming_documents_base u_tabpage_incoming_documents_base

type variables

//u_component_service service
str_attributes attributes

u_ds_attachments attachments

string displayed_actual_file

string list_folder
boolean default_list

long last_selected_attachment_id

boolean initialized = false

long interfaceserviceid = 0

end variables

forward prototypes
public subroutine select_image (long pl_row)
public subroutine delete_temp_files ()
public function string append_selected ()
public subroutine delete_row (long pl_row)
public subroutine delete_selected ()
public function string get_comment_title ()
public function long order_workplan (str_attachment pstr_attachment, long pl_workplan_id, string ps_owned_by)
public function integer scan_more ()
public subroutine refresh ()
public subroutine refresh_tabtext ()
public function integer initialize ()
public subroutine post_attachments (string ps_cpr_id)
public subroutine edit_mappings (long pl_row)
public subroutine set_tab_text (long pl_rows)
end prototypes

public subroutine select_image (long pl_row);Blob 		lbl_attachment
Integer 	li_sts,li_count
String 	ls_filepath,ls_filename
String 	ls_attachment_file_path,ls_extension,ls_attachment_file
string ls_find
long ll_row
string   ls_prev_extension
String	ls_title
string ls_rendered_file
u_component_attachment luo_displayed_attachment
long 		ll_rowcount
long ll_first_row_on_page
long ll_lastrowonpage

ll_rowcount = dw_holding_list.rowcount()
if ll_rowcount <= 0 then return

if pl_row <= 0 then pl_row = 1
if pl_row > ll_rowcount then pl_row = ll_rowcount

//cb_post.enabled = true
//cb_post_last.enabled = true
//cb_delete.enabled = true

last_selected_attachment_id = dw_holding_list.object.attachment_id[pl_row]
ls_extension = dw_holding_list.object.extension[pl_row]

// If we haven't extracted this file yet then get it
ls_rendered_file = dw_holding_list.object.rendered_file[pl_row]
if isnull(ls_rendered_file) then
	li_sts = attachments.attachment(luo_displayed_attachment, last_selected_attachment_id)
	if li_sts <= 0 then
		setnull(displayed_actual_file)
		log.log(this, "u_tabpage_incoming_documents_base.select_image.0034", "Error getting attachment object", 3)
	else
		displayed_actual_file = luo_displayed_attachment.get_attachment()
		dw_holding_list.object.attachment_file[pl_row] = displayed_actual_file
		
		ls_rendered_file = luo_displayed_attachment.render()
		dw_holding_list.object.rendered_file[pl_row] = ls_rendered_file
	end if
	component_manager.destroy_component(luo_displayed_attachment)
else
	displayed_actual_file = dw_holding_list.object.attachment_file[pl_row]
end if
	
// Display the attachment in the browser object
uo_picture.display_picture(ls_rendered_file)

ls_title = "File Attached by "
ls_title += dw_holding_list.object.user_full_name[pl_row]
ls_title += " on " + string(dw_holding_list.object.created[pl_row], "[shortdate] [time]")
st_attachment_details.text = ls_title

ll_first_row_on_page = long(dw_holding_list.object.DataWindow.FirstRowOnPage)
ll_lastrowonpage = long(dw_holding_list.object.DataWindow.LastRowOnPage)
if pl_row < ll_first_row_on_page or pl_row > ll_lastrowonpage then
	dw_holding_list.scrolltorow(pl_row)
end if

Return


end subroutine

public subroutine delete_temp_files ();long ll_rows
long i
string ls_file

ll_rows = dw_holding_list.rowcount()
for i = 1 to ll_rows
	ls_file = dw_holding_list.object.attachment_file[i]
	if not isnull(ls_file) then filedelete(ls_file)
next

end subroutine

public function string append_selected ();long ll_row, ll_rowcount, ll_object_sequence
String ls_find,ls_append_file,ls_temp
string ls_temp_file
//u_component_attachment luo_attachment
boolean lb_first_file
oleobject lo_tiffdll
string ls_param
integer li_sts
string ls_null
//long ll_attachment_id
integer li_pages
string ls_extension
long i

setnull(ls_null)

// This combination routine only works with "tif" files!!!!
lo_tiffdll = CREATE oleobject
li_sts = lo_tiffdll.connecttonewobject("TiffDLL50vic.ClsTiffDLL50")
if li_sts < 0 then
	log.log(this, "u_tabpage_incoming_documents_base.append_selected.0021", "Connection to RunTiffDLL failed (" + string(li_sts) + ")", 4)
	return ls_null
end if

lb_first_file = true

ls_find = "selected_flag=1"
ll_rowcount = dw_holding_list.rowcount()
ll_row = dw_holding_list.find(ls_find, 1, ll_rowcount)
DO WHILE ll_row > 0
	ls_extension = dw_holding_list.object.extension[ll_row]
	if upper(ls_extension) = "TIF" then
		// Get the file to be appended
		ls_temp_file = dw_holding_list.object.attachment_file[ll_row]
		
		// Make sure it exists
		if not fileexists(ls_temp_file) then
			log.log(this, "u_tabpage_incoming_documents_base.append_selected.0021", "Temp file doesn't exist (" + ls_temp_file + ")", 4)
		else
			// If this is the first file to be appended, just use it as the appended file
			if lb_first_file then
				ls_append_file = f_temp_file("TIF")
				li_sts = filecopy(ls_temp_file, ls_append_file, true)
				if li_sts <= 0 then
					log.log(this, "u_tabpage_incoming_documents_base.append_selected.0021", "Error copying tif file (" + ls_temp_file + ", " + ls_append_file + ")", 4)
					return ls_null
				end if
				lb_first_file = false
			else
				// Find out how many pages are in the merge file
				ls_param = "in=" + ls_temp_file + ";out=info_p"
				li_pages = lo_tiffdll.runtiffdll(ls_param)
	
				for i = 1 to li_pages
					ls_param = "in=" + ls_temp_file + ";"
					ls_param += "pages=" + string(i) + ";"
					ls_param += "out=" + ls_append_file + ";"
					ls_param += "save=1;"
					
					li_sts = lo_tiffdll.runtiffdll(ls_param)
/*					if li_sts = 0 then
						log.log(this, "u_tabpage_incoming_documents_base.append_selected.0021", "RunTiffDLL returned zero.  Check tiffdll license (" + ls_param + ")", 4)
						return ls_null
					end if */
					if li_sts < 0 then
						log.log(this, "u_tabpage_incoming_documents_base.append_selected.0021", "RunTiffDLL failed (" + string(li_sts) + ", " + ls_param + ")", 4)
						return ls_null
					end if
				next
			end if
		end if
	end if
	
	ll_row = dw_holding_list.find(ls_find, ll_row + 1, ll_rowcount + 1)
LOOP

lo_tiffdll.disconnectobject()
DESTROY lo_tiffdll

return ls_append_file

end function

public subroutine delete_row (long pl_row);String 				ls_null
long ll_attachment_id
string ls_file

setnull(ls_null)

if isnull(pl_row) or pl_row <= 0 or pl_row > dw_holding_list.rowcount() then return

ll_attachment_id = dw_holding_list.object.attachment_id[pl_row]
ls_file = dw_holding_list.object.attachment_file[pl_row]
attachments.add_progress(ll_attachment_id,"DELETED",ls_null)
dw_holding_list.deleterow(pl_row)
if not isnull(ls_file) then filedelete(ls_file)

end subroutine

public subroutine delete_selected ();String 				ls_null,ls_find
Long 					ll_attachment_id
Long					ll_row
long ll_rows
long ll_lastrow
long ll_rowcount

setnull(ls_null)

ls_find = "selected_flag=1"
ll_row = dw_holding_list.find(ls_find, 1, dw_holding_list.rowcount())
DO WHILE ll_row > 0 and ll_row <= dw_holding_list.rowcount()
	ll_lastrow = ll_row
	delete_row(ll_row)

	ll_row = dw_holding_list.find(ls_find, ll_row, dw_holding_list.rowcount() + 1)
LOOP

ll_rowcount = dw_holding_list.rowcount()

if ll_rowcount <= 0 then
	uo_picture.clear_image()
elseif ll_lastrow > 0 and ll_lastrow <= ll_rowcount then
	select_image(ll_lastrow)
else
	select_image(ll_rowcount)
end if


end subroutine

public function string get_comment_title ();str_popup popup
str_popup_return popup_return
string ls_null

setnull(ls_null)

// Set the title
popup.title = "Please enter a comment title or select one from the list below"

// Allow an empty string
popup.multiselect = true

popup.argument_count = 1
popup.argument[1] = "SRC|" + "JMJ_FILE"

Openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
If popup_return.item_count <> 1 then return ls_null

Return popup_return.items[1]

end function

public function long order_workplan (str_attachment pstr_attachment, long pl_workplan_id, string ps_owned_by);long ll_patient_workplan_id
string ls_in_office_flag
string ls_mode
long ll_parent_patient_workplan_item_id
string ls_dispatch_flag = "Y"
long ll_patient_workplan_item_id

setnull(ls_in_office_flag)
setnull(ls_mode)
setnull(ll_parent_patient_workplan_item_id)


sqlca.sp_order_workplan( &
		current_patient.cpr_id, &
		pl_workplan_id, &
		pstr_attachment.encounter_id, &
		pstr_attachment.problem_id, &
		pstr_attachment.treatment_id, &
		pstr_attachment.observation_sequence, &
		pstr_attachment.attachment_id, &
		pstr_attachment.attachment_tag, &
		current_user.user_id, &
		ps_owned_by, &
		ls_in_office_flag, &
		ls_mode, &
		ll_parent_patient_workplan_item_id, &
		current_scribe.user_id, &
		ls_dispatch_flag, &
		ll_patient_workplan_id)
if not tf_check() then return -1

ll_patient_workplan_item_id = sqlca.sp_get_workplan_auto_perform_service(ll_patient_workplan_id, current_user.user_id)
if ll_patient_workplan_item_id > 0 then
	service_list.do_service(ll_patient_workplan_item_id)
end if

return ll_patient_workplan_id



end function

public function integer scan_more ();integer li_pagecount
str_popup popup
str_popup_return popup_return

f_clear_patient()
//cb_post_last.visible = false

dw_holding_list.clear_selected()

if interfaceserviceid > 0 then
	f_attribute_add_attribute(attributes, "interfaceserviceid", string(interfaceserviceid))
elseif len(list_folder) > 0 then
	f_attribute_add_attribute(attributes, "posting_list", list_folder)
end if

Openwithparm(w_scan_more, attributes)
popup_return = message.powerobjectparm
if popup_return.item_count <= 0 then return 0

li_pagecount = integer(popup_return.items[1])
if li_pagecount <= 0 then return 0

Return li_pagecount

end function

public subroutine refresh ();String 	ls_null
long ll_rows
long i
long ll_row
string ls_filter
long lla_selected_attachments[]
long ll_selected_attachment_count
boolean lb_found
string ls_find
boolean lb_selected
long ll_old_lastrowonpage
long ll_new_lastrowonpage

Setnull(ls_null)

if not initialized then return

// First delete any temp files in the holding list
delete_temp_files()

// Record the selected rows
ll_selected_attachment_count = 0
ll_row = dw_holding_list.get_selected_row()
DO WHILE ll_row > 0
	ll_selected_attachment_count++
	lla_selected_attachments[ll_selected_attachment_count] = dw_holding_list.object.attachment_id[ll_row]
	ll_row = dw_holding_list.get_selected_row(ll_row)
LOOP

ll_old_lastrowonpage = long(dw_holding_list.object.DataWindow.LastRowOnPage)

dw_holding_list.setredraw(false)
dw_holding_list.reset()

if interfaceserviceid = 0 then
	if len(list_folder) > 0 then
		ls_filter = "attachment_folder='" + list_folder + "'"
		if default_list then
			ls_filter += " OR isnull(attachment_folder)"
		end if
		ls_filter = "(" + ls_filter + ") and (isnull(interfaceserviceid) OR interfaceserviceid = 0)"
	else
		// If the interfaceserviceid = 0 and the list_folder is null then we just want to display all attachments
		ls_filter = ""
	end if
else
	ls_filter = "interfaceserviceid = " + string(interfaceserviceid)
end if

attachments.setfilter(ls_filter)
attachments.filter()

ll_rows = attachments.rowcount()

for i = 1 to ll_rows
	ll_row = dw_holding_list.insertrow(0)
	dw_holding_list.object.attachment_id[ll_row] = attachments.object.attachment_id[i]
	dw_holding_list.object.attachment_tag[ll_row] = attachments.object.attachment_tag[i]
	dw_holding_list.object.attachment_type[ll_row] = attachments.object.attachment_type[i]
	dw_holding_list.object.extension[ll_row] = attachments.object.extension[i]
	dw_holding_list.object.user_full_name[ll_row] = user_list.user_full_name(string(attachments.object.attached_by[i]))
	dw_holding_list.object.created[ll_row] = attachments.object.created[i]
	dw_holding_list.object.failed_once[ll_row] = attachments.object.failed_once[i]
	dw_holding_list.object.failed_mappings[ll_row] = attachments.object.failed_mappings[i]
next

attachments.setfilter("")
attachments.filter()

ll_rows = dw_holding_list.rowcount()
set_tab_text(ll_rows)

dw_holding_list.sort()

ll_new_lastrowonpage = long(dw_holding_list.object.DataWindow.LastRowOnPage)
if ll_new_lastrowonpage < ll_old_lastrowonpage then
	dw_holding_list.scroll_to_row(ll_old_lastrowonpage)
end if

dw_holding_list.setredraw(true)



parent_tab.postevent( "refresh_buttons")


if ll_rows > 0 then
	lb_found = false
	lb_selected = false
	for i = 1 to ll_selected_attachment_count
		ls_find = "attachment_id=" + string(lla_selected_attachments[i])
		ll_row = dw_holding_list.find(ls_find, 1, ll_rows)
		if ll_row > 0 then
			dw_holding_list.object.selected_flag[ll_row] = 1
			if lla_selected_attachments[i] = last_selected_attachment_id then
				lb_selected = true
			end if
			lb_found = true
		end if
	next
	
	if lb_found then
		if not lb_selected then
			this.function POST select_image(ll_row)
		end if
	else
		// If nothing is selected then select the first row
		dw_holding_list.object.selected_flag[1] = 1
		this.function POST select_image(1)
	end if
end if

end subroutine

public subroutine refresh_tabtext ();long ll_rows
string ls_filter
string ls_new_tab_text
long ll_new_tab_color
boolean lb_this_tab_displayed

if not initialized then return

// If this is the displayed tab then count the displayed attachments
lb_this_tab_displayed = false
if parent_tab.selectedtab > 0 then
	if parent_tab.pages[parent_tab.selectedtab] = this then
		ll_rows = dw_holding_list.rowcount()
		lb_this_tab_displayed = true
	end if
end if

if not lb_this_tab_displayed then
	if interfaceserviceid = 0 then
		if len(list_folder) > 0 then
			ls_filter = "attachment_folder='" + list_folder + "'"
			if default_list then
				ls_filter += " OR isnull(attachment_folder)"
			end if
			ls_filter = "(" + ls_filter + ") and (isnull(interfaceserviceid) OR interfaceserviceid = 0)"
		else
			ls_filter = ""
		end if
	else
		ls_filter = "interfaceserviceid = " + string(interfaceserviceid)
	end if
	attachments.setfilter(ls_filter)
	attachments.filter()
	
	ll_rows = attachments.rowcount()
	
	attachments.setfilter("")
	attachments.filter()
end if

set_tab_text(ll_rows)

end subroutine

public function integer initialize ();
uo_picture.initialize()

initialized = true

return 1

end function

public subroutine post_attachments (string ps_cpr_id);String 			ls_cpr_id, ls_file
String 			ls_attachment_tag,ls_attachment_type
Integer 			li_sts
Long 				ll_row, ll_object_sequence
string ls_extension
str_popup popup
str_popup_return popup_return
str_attachment_context lstr_attachment_context
str_attachment		lstr_attachment
boolean lb_tif
Setnull(ls_attachment_tag)
long ll_selected_count
long ll_post_count
long ll_patient_workplan_id
w_post_attachment lw_post_attachment
str_folder_selection_info lstr_folder_select
boolean lb_interpret
u_xml_document lo_xml_document
str_complete_context lstr_my_context
str_complete_context lstr_document_context
boolean lb_xml
string ls_done_message
long ll_attachment_id
boolean lb_xml_prompt
integer li_choice
u_component_attachment luo_attachment
string ls_rendered_file
boolean lb_my_patient
long ll_count

if isnull(current_patient) then
	lb_my_patient = true
else
	lb_my_patient = false
end if

// First see if they're all TIF Files
lb_tif = true
lb_xml = true
ll_selected_count = 0
ll_row = dw_holding_list.get_selected_row()
DO WHILE ll_row > 0
	ll_selected_count += 1
	ls_extension = dw_holding_list.object.extension[ll_row]
	if upper(ls_extension) <> "TIF" then
		lb_tif = false
	end if
	if upper(ls_extension) <> "XML" then
		lb_xml = false
	end if
	ll_row = dw_holding_list.get_selected_row(ll_row)
LOOP

if lb_tif and ll_selected_count > 1 then
	popup.title = "All of the selected files are TIF files.  Do you wish to:"
	popup.data_row_count = 2
	popup.items[1] = "Merge into a single document"
	popup.items[2] = "Post as separate documents"
	openwithparm(w_pop_choices_2, popup)
	li_sts = message.doubleparm
	if li_sts = 1 then
		ls_file = append_selected()
		ls_rendered_file = ls_file
		ll_selected_count = 1
	else
		// The user wants separate documents so treat them like non-tifs
		lb_tif = false
	end if
else
	lb_tif = false
end if

// Set the patient context
if lb_xml then
//	setnull(last_cpr_id)
//	cb_post_last.visible = false
	
	lb_xml_prompt = f_string_to_boolean(f_attribute_find_attribute(attributes, "prompt_for_xml_disposition"))
	
	if lb_xml_prompt then
		popup.title = "The files you selected are all XML files.  You may attempt to interpret each attachment as patient data, or simply post each attachment without interpreting it."
		popup.data_row_count = 2
		popup.items[1] = "Interpret the XML Data"
		popup.items[2] = "Don't Interpret the XML Data"
		openwithparm(w_pop_choices_3, popup)
		if int(message.doubleparm) = 1 then
			lb_interpret = true
		else
			lb_interpret = false
		end if
	else
		lb_interpret = true
	end if
else
	lb_interpret = false
end if

// See if a cpr_id was passed in
if len(ps_cpr_id) > 0 then
	ls_cpr_id = ps_cpr_id
else
	setnull(ls_cpr_id)
end if

// Now loop through the files and post them
lstr_attachment_context.apply_to_all = false
ll_post_count = 0
ll_row = dw_holding_list.get_selected_row()
DO WHILE ll_row > 0
	ll_post_count += 1
	
	// If we're working with a combined tif document, then we already have the file so don't get it
	// from the structure
	if not lb_tif then
		ls_file = dw_holding_list.object.attachment_file[ll_row]
		ls_rendered_file = dw_holding_list.object.rendered_file[ll_row]
	end if

	// If the file doesn't exist then try to get it
	If isnull(ls_file) or not fileexists(ls_file) then
		ll_attachment_id = dw_holding_list.object.attachment_id[ll_row]

		li_sts = attachments.attachment(luo_attachment, ll_attachment_id)
		if li_sts <= 0 then
			setnull(ls_file)
			log.log(this, "u_tabpage_incoming_documents_base.select_image.0034", "Error getting attachment object", 3)
			return
		else
			ls_file = luo_attachment.get_attachment()
			ls_rendered_file = luo_attachment.render()
		end if

		If isnull(ls_file) or not fileexists(ls_file) then
			openwithparm(w_pop_message, "Unable to process attachment ~"" + string(dw_holding_list.object.attachment_tag[ll_row]) + "~".  Please reimport it and try again.")
			ll_row = dw_holding_list.get_selected_row(ll_row)
			continue
		end if
	end if

	// If this is a combined tif file, then only process the first record.  Otherwise process all selected files.
	if not lb_tif or ll_post_count = 1 then
		// Get some properties into local variables
		ll_attachment_id = dw_holding_list.object.attachment_id[ll_row]
		ls_extension = dw_holding_list.object.extension[ll_row]
		ls_attachment_tag = dw_holding_list.object.attachment_tag[ll_row]
		ls_attachment_type = dw_holding_list.object.attachment_type[ll_row]
		
		if lb_interpret then
			li_sts = f_get_xml_document_from_file(ls_file, lo_xml_document)
			if li_sts < 0 then return
			
			lstr_my_context = f_empty_context()
			lstr_my_context.attachment_id = ll_attachment_id
			li_sts = lo_xml_document.interpret(lstr_my_context, lstr_document_context)
			if li_sts <= 0 then
				log.log(this, "u_tabpage_incoming_documents_base.post_attachments.0156", "Error processing document", 4)
				
				SELECT count(*)
				INTO :ll_count
				FROM p_Attachment_Progress p
				WHERE p.attachment_id = :ll_attachment_id
				AND p.progress_type = 'Failed Mappings'
				AND p.current_flag = 'Y';
				if not tf_check() then return
				if ll_count > 0 then
					dw_holding_list.object.failed_mappings[ll_row] = 1
				end if
				
				dw_holding_list.object.failed_once[ll_row] = 1
				
				if ll_count > 0 then
					openwithparm(w_pop_yes_no, "This document contains data elements that do not correspond to EncounterPRO objects.  Do you wish to map these elements now?")
					popup_return = message.powerobjectparm
					if popup_return.item = "YES" then
						edit_mappings(ll_row)
					end if
				else
					openwithparm(w_pop_message, "An error occured while processing this document.  Please correct the error and post the document again.")
				end if

				return
			end if
		end if
		

		// Now post the attachment
		
		// If the document context was explicitely "General" then just delete the document
		if lower(lstr_document_context.context_object) = "general" then
			delete_row(ll_row)
			ll_row = dw_holding_list.get_selected_row(ll_row)
			continue
		end if
		
		// If the document has a patient context then use it
		if len(lstr_document_context.cpr_id) > 0 then
			ls_cpr_id = lstr_document_context.cpr_id
		end if

		// If we don't have a patient context yet, prompt the user for one
		if trim(ls_cpr_id) = "" or isnull(ls_cpr_id) then
			f_clear_patient()
			Open(w_patient_select)
			popup_return = message.powerobjectparm
		
			if popup_return.item_count <> 1 then return
		
			ls_cpr_id = popup_return.items[1]
		end if

		if not isnull(ls_cpr_id) then
			if isnull(current_patient) then
				li_sts = f_set_patient(ls_cpr_id)
				if li_sts <= 0 then return
				
				current_patient.encounters.last_encounter()
			elseif current_patient.cpr_id = ls_cpr_id then
				// Already OK
			else
				log.log(this, "u_tabpage_incoming_documents_base.post_attachments.0220", "The current patient does not match the patient found for this XML document.", 4)
				openwithparm(w_pop_message, "The current patient does not match the desired patient context for this attachment.  EncounterPRO is unable to process this attachment.")
				return
			end if
		end if

		// Set the quick-post button so the user can easily select this patient again
//		parent_lists.event POST patient_posted(current_patient.cpr_id, current_patient.name())
		this.event POST patient_posted(current_patient.cpr_id)
		
		// Get the attachment context
		if not lstr_attachment_context.apply_to_all then
			// Open the folder selection window with information about this attachment
			lstr_folder_select.filepath = ls_file
			lstr_folder_select.rendered_filepath = ls_rendered_file
			lstr_folder_select.context_object = 'Patient'
			setnull(lstr_folder_select.context_object_type)
			lstr_folder_select.attachment_type = ls_attachment_type
			lstr_folder_select.extension = ls_extension
			lstr_folder_select.description = ls_attachment_tag
			if (ll_selected_count - ll_post_count) > 0 then
				lstr_folder_select.apply_to_all_flag = "N"
			else
				// Hide the "Apply to all" options
				lstr_folder_select.apply_to_all_flag = "X"
			end if
			// Hide the "Remove" options
			lstr_folder_select.remove_flag = "Y"
		
			Openwithparm(lw_post_attachment, lstr_folder_select, "w_post_attachment")
			lstr_attachment_context = message.powerobjectparm
			if lstr_attachment_context.user_cancelled then return
		end if
		
		// Set the attachment properties
		lstr_attachment.cpr_id = ls_cpr_id
		lstr_attachment.attachment_folder = lstr_attachment_context.folder
		lstr_attachment.attachment_tag = lstr_attachment_context.description
//		setnull(lstr_attachment.attachment_tag)
		lstr_attachment.attachment_type = ls_attachment_type
		lstr_attachment.extension = ls_extension
		CHOOSE CASE lower(lstr_attachment_context.context_object)
			CASE "encounter"
				lstr_attachment.encounter_id = lstr_attachment_context.object_key
			CASE "assessment"
				lstr_attachment.problem_id = lstr_attachment_context.object_key
			CASE "treatment"
				lstr_attachment.treatment_id = lstr_attachment_context.object_key
		END CHOOSE
	
		// Create the attachment
		ll_attachment_id = current_patient.attachments.new_attachment(lstr_attachment, ls_file, lstr_attachment_context.context_object)
		if ll_attachment_id <= 0 then
			log.log(this, "u_tabpage_incoming_documents_base.post_attachments.0156", "Error posting document", 4)
			openwithparm(w_pop_message, "An error occured while posting this document.  Please correct the error and post the document again, or contact EncounterPRO customer support for assistance.")
			return
		end if
	
		// Order the workplan
		if not isnull(lstr_attachment_context.workplan_id) then
			ll_patient_workplan_id = order_workplan(lstr_attachment, lstr_attachment_context.workplan_id, lstr_attachment_context.user_id)
		end if
	end if

	If lstr_attachment_context.remove then
		delete_row(ll_row)
		ll_row -= 1
	End if
	
	ll_row = dw_holding_list.get_selected_row(ll_row)
LOOP

// If this is a tiff file then delete the concatenation file
If lb_tif then
	filedelete(ls_file)
End if

ll_row = dw_holding_list.get_selected_row()
if ll_row <= 0 and dw_holding_list.rowcount() > 0 then
	dw_holding_list.object.selected_flag[1] = 1
	select_image(1)
end if

if len(ls_done_message) > 0 then
	openwithparm(w_pop_message, ls_done_message)
end if

if lb_my_patient then
	f_clear_patient()
end if

refresh_tabtext()

parent_tab.postevent("refresh_buttons")



end subroutine

public subroutine edit_mappings (long pl_row);long ll_attachment_id
str_service_info lstr_service
long ll_owner_id
integer li_sts

ll_attachment_id = dw_holding_list.object.attachment_id[pl_row]

SELECT owner_id
INTO :ll_owner_id
FROM p_Attachment
WHERE attachment_id = :ll_attachment_id;
if not tf_check() then return

if isnull(ll_owner_id) then 
	openwithparm(w_pop_message, "EncounterPRO could not determine the owner of this document.  Mapping cannot be performed.")
	return
end if

lstr_service.service = "Code Mappings"
f_attribute_add_attribute(lstr_service.attributes, "interfaceserviceid", string(ll_owner_id))
f_attribute_add_attribute(lstr_service.attributes, "mapping_attachment_id", string(ll_attachment_id))

li_sts = service_list.do_service(lstr_service)

end subroutine

public subroutine set_tab_text (long pl_rows);string ls_filter
string ls_new_tab_text
long ll_new_tab_color

if not initialized then return

if len(list_folder) > 0 then
	ls_new_tab_text = list_folder
else
	ls_new_tab_text = "Incoming"
end if

ls_new_tab_text += "  (" + string(pl_rows) + ")"

if interfaceserviceid = 0 then
	ll_new_tab_color = color_text_normal
elseif pl_rows > 0 then
	ll_new_tab_color = color_text_error
else
	ll_new_tab_color = color_text_normal
end if

// updating the visible property is expensive on terminal servers so only do it if it has changed
if text <> ls_new_tab_text then text = ls_new_tab_text
if tabtextcolor <> ll_new_tab_color then tabtextcolor = ll_new_tab_color

end subroutine

on u_tabpage_incoming_documents_base.create
int iCurrent
call super::create
this.st_attachment_details=create st_attachment_details
this.cb_clear_all=create cb_clear_all
this.cb_select_all=create cb_select_all
this.cb_sort=create cb_sort
this.dw_holding_list=create dw_holding_list
this.uo_picture=create uo_picture
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_attachment_details
this.Control[iCurrent+2]=this.cb_clear_all
this.Control[iCurrent+3]=this.cb_select_all
this.Control[iCurrent+4]=this.cb_sort
this.Control[iCurrent+5]=this.dw_holding_list
this.Control[iCurrent+6]=this.uo_picture
end on

on u_tabpage_incoming_documents_base.destroy
call super::destroy
destroy(this.st_attachment_details)
destroy(this.cb_clear_all)
destroy(this.cb_select_all)
destroy(this.cb_sort)
destroy(this.dw_holding_list)
destroy(this.uo_picture)
end on

event resize_tabpage;call super::resize_tabpage;// Resize stuff
dw_holding_list.width = (width / 2) - 142
dw_holding_list.height = height - 168
dw_holding_list.object.t_back.width = dw_holding_list.width - 110

cb_sort.x = dw_holding_list.width - 366

uo_picture.x = dw_holding_list.x + dw_holding_list.width + 20
uo_picture.width = width - uo_picture.x - 24
uo_picture.height = height - 96

st_attachment_details.y = dw_holding_list.y + dw_holding_list.height + 12
st_attachment_details.width = width - 50

end event

type st_attachment_details from statictext within u_tabpage_incoming_documents_base
integer x = 5
integer y = 1540
integer width = 2537
integer height = 64
boolean bringtotop = true
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

type cb_clear_all from commandbutton within u_tabpage_incoming_documents_base
integer x = 320
integer y = 12
integer width = 265
integer height = 68
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear All"
end type

event clicked;dw_holding_list.clear_selected()

end event

type cb_select_all from commandbutton within u_tabpage_incoming_documents_base
integer x = 32
integer y = 12
integer width = 265
integer height = 68
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select All"
end type

event clicked;long i

for i = 1 to dw_holding_list.rowcount()
	dw_holding_list.object.selected_flag[i] = 1
next

//cb_post.enabled = true
//cb_post_last.enabled = true
//cb_delete.enabled = true

parent_tab.postevent("refresh_buttons")

end event

type cb_sort from commandbutton within u_tabpage_incoming_documents_base
integer x = 937
integer y = 12
integer width = 306
integer height = 68
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Descending"
end type

event clicked;if text = "Ascending" then
	text = "Descending"
	dw_holding_list.setsort("created D")
else
	text = "Ascending"
	dw_holding_list.setsort("created A")
end if

dw_holding_list.clear_selected()
dw_holding_list.sort()
//cb_scan_more.setfocus()

end event

type dw_holding_list from u_dw_pick_list within u_tabpage_incoming_documents_base
integer x = 18
integer y = 80
integer width = 1303
integer height = 1448
integer taborder = 40
string dataobject = "dw_holding_attachments"
boolean vscrollbar = true
boolean border = false
boolean livescroll = false
boolean multiselect = true
boolean multiselect_ctrl = true
end type

event constructor;call super::constructor;multiselect = true
settransobject(sqlca)

end event

event unselected;if lastcolumnname = "t_failed_mappings" then
	edit_mappings(unselected_row)
end if

parent_tab.postevent( "refresh_buttons")


end event

event selected;select_image(selected_row)

if lastcolumnname = "t_failed_mappings" then
	edit_mappings(selected_row)
end if

parent_tab.postevent( "refresh_buttons")


end event

type uo_picture from u_picture_display within u_tabpage_incoming_documents_base
event destroy ( )
integer x = 1486
integer y = 16
integer width = 1367
integer height = 1520
integer taborder = 30
boolean bringtotop = true
boolean border = true
end type

on uo_picture.destroy
call u_picture_display::destroy
end on

event picture_clicked;call super::picture_clicked;integer li_sts
string ls_drive1
string ls_directory1
string ls_file1
string ls_extension1
string ls_drive2
string ls_directory2
string ls_file2
string ls_extension2
boolean lb_show_original
str_popup popup

f_parse_filepath(displayed_actual_file, ls_drive1, ls_directory1, ls_file1, ls_extension1)
f_parse_filepath(picture_file, ls_drive2, ls_directory2, ls_file2, ls_extension2)

if lower(ls_extension1) = lower(ls_extension2) then
	lb_show_original = true
elseif left(lower(ls_extension1), 3) = "tif" then
	lb_show_original = true
else
	popup.title = "The attachment has been converted to display on the screen."
	popup.title += "  Do you wish to open the original ~"" + ls_extension1 + "~" file"
	popup.title += " or the converted ~"" + ls_extension2 + "~" file?"
	
	popup.data_row_count = 2
	popup.items[1] = "Open the original ~"" + ls_extension1 + "~" file"
	popup.items[2] = "Open the converted ~"" + ls_extension2 + "~" file"
	
	openwithparm(w_pop_choices_2, popup)
	if message.doubleparm = 1 then
		lb_show_original = true
	else
		lb_show_original = false
	end if
	
end if

if lb_show_original then
	li_sts = f_open_file(displayed_actual_file, false)
else
	li_sts = f_open_file(picture_file, false)
end if

return

end event

