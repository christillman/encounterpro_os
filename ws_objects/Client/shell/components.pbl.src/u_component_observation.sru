$PBExportHeader$u_component_observation.sru
forward
global type u_component_observation from u_component_base_class
end type
end forward

global type u_component_observation from u_component_base_class
event source_connected ( )
event source_disconnected ( )
end type
global u_component_observation u_component_observation

type variables
public w_observation_base display_window

public integer observation_count
public str_external_observation observations[]

//public long xml_results_count
//public string xml_results[]

public boolean connected

private u_ds_data c_external_observation
private u_ds_data c_external_observation_location
private u_ds_data c_external_observation_result

string external_source
str_external_source external_source_properties

long owner_id

boolean verify_source = true

// Epiehandler instructions common to all attachments
str_epiehandler_type epiehandler_common

integer do_source_status

end variables

forward prototypes
protected function integer base_shutdown ()
protected function integer xx_get_results ()
public subroutine set_connected_status (boolean pb_connected)
public function string get_comment_title (string ps_top_20_code)
public function integer timer_ding ()
protected function integer base_initialize ()
public function integer do_source ()
public function string internal_location (string ps_external_observation_id, string ps_external_location)
public function string internal_observation_id (string ps_external_observation_id)
public function integer internal_result_sequence (string ps_external_observation_id, string ps_external_observation_result)
protected function integer xx_set_processed (string ps_id, integer pi_status)
public function integer set_processed (string ps_external_item_id, integer pi_status)
public function integer read_data (string ps_data, string ps_external_item_id)
public function integer send_attachment (str_external_observation_attachment pstr_attachment, long pl_addressee)
public function string internal_result_unit (string ps_external_observation_id, string ps_external_observation_result, string ps_result_value)
public function integer get_mapped_results (string ps_external_observation_id, string ps_external_observation_result, ref string psa_observation_id[], ref integer pia_result_sequence[])
public function integer process_epiehandler (str_epiehandler_type pstr_epiehandler, str_context pstr_context)
protected function integer xx_do_source () throws exception
protected function integer do_source_2 () throws exception
end prototypes

event source_connected;if not isnull(display_window) and isvalid(display_window) then
	display_window.event post source_connected(this)
end if

end event

event source_disconnected;if not isnull(display_window) and isvalid(display_window) then
	display_window.event post source_disconnected(this)
end if

end event

protected function integer base_shutdown ();DESTROY c_external_observation
DESTROY c_external_observation_location
DESTROY c_external_observation_result

return 1

end function

protected function integer xx_get_results ();integer i, j
string ls_external_observation_id
string ls_observation_id
string ls_result_type
string ls_external_observation_result
integer li_result_sequence
string ls_location
string ls_result_date_time
string ls_result_value
string ls_result_unit
string ls_abnormal_flag
string ls_abnormal_nature
string ls_external_location

if ole_class then
	observation_count = 0
	for i = 1 to ole.observation_count
		ls_external_observation_id = ole.observation[i].observation
		ls_observation_id = internal_observation_id(ls_external_observation_id)
		if not isnull(ls_observation_id) then
			observation_count += 1
			observations[observation_count].observation_id = ls_observation_id
			for j = 1 to ole.observation[i].result_count
				ls_result_type = ole.observation[i].result[j].result_type
				ls_external_observation_result = ole.observation[i].result[j].result
				ls_external_location = ole.observation[i].result[j].location
				ls_result_date_time = ole.observation[i].result[j].result_date_time
				ls_result_value = ole.observation[i].result[j].result_value
				ls_abnormal_flag = ole.observation[i].result[j].abnormal_flag
				ls_abnormal_nature = ole.observation[i].result[j].abnormal_nature
				li_result_sequence = internal_result_sequence(ls_external_observation_id, ls_external_observation_result)
				ls_result_unit = internal_result_unit(ls_external_observation_id, ls_external_observation_result, ls_result_value)
				ls_location = internal_location(ls_external_observation_id, ls_external_location)
				if not isnull(li_result_sequence) then
					observations[observation_count].result_count += 1
					observations[observation_count].result[observations[observation_count].result_count].id_count = 1
					observations[observation_count].result[observations[observation_count].result_count].observation_id[1] = ls_observation_id
					observations[observation_count].result[observations[observation_count].result_count].location = ls_location
					observations[observation_count].result[observations[observation_count].result_count].result_sequence[1] = li_result_sequence
					observations[observation_count].result[observations[observation_count].result_count].result_date_time = datetime(ls_result_date_time)
					observations[observation_count].result[observations[observation_count].result_count].result_value = ls_result_value
					observations[observation_count].result[observations[observation_count].result_count].result_unit = ls_result_unit
					observations[observation_count].result[observations[observation_count].result_count].abnormal_flag = ls_abnormal_flag
					observations[observation_count].result[observations[observation_count].result_count].abnormal_nature = ls_abnormal_nature
				end if
			next
		end if
	next
	return observation_count
else
	return 100
end if


end function

public subroutine set_connected_status (boolean pb_connected);

if connected and not pb_connected then
	this.event POST source_disconnected()
elseif not connected and pb_connected then
	this.event POST source_connected()
end if

connected = pb_connected

end subroutine

public function string get_comment_title (string ps_top_20_code);str_popup popup
str_popup_return popup_return
string ls_null

setnull(ls_null)

// Set the title
popup.title = "Please enter a comment title or select one from the list below"

// Allow an empty string
popup.multiselect = true

if isnull(ps_top_20_code) or trim(ps_top_20_code) = "" then
	popup.argument_count = 1
	popup.argument[1] = "SRC|" + external_source
else
	popup.argument_count = 2
	popup.argument[1] = ps_top_20_code
	popup.argument[2] = "SRC|" + external_source
end if

openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return ls_null

return popup_return.items[1]


end function

public function integer timer_ding ();integer li_sts

if not connected then
end if

TRY
	li_sts = do_source_2()
	if li_sts <= 0 then return 0
CATCH (exception le_error)
	return 0
END TRY

if not isnull(display_window) and isvalid(display_window) then
	display_window.event post results_posted(this)
end if

return 1

end function

protected function integer base_initialize ();real lr_timer
integer li_sts
u_ds_data luo_attributes
str_attributes lstr_attributes


external_source = get_attribute("external_source")
if isnull(external_source) then
	external_source = "NA"
	return 1
end if

li_sts = common_thread.get_external_source(external_source, external_source_properties)
if li_sts <= 0 then
	mylog.log(this, "u_component_observation.base_initialize:0015", "External Source not found (" + external_source + ")", 4)
	return -1
end if

// Load the source-specific attributes
luo_attributes = CREATE u_ds_data
luo_attributes.set_dataobject("dw_c_external_source_attribute")
li_sts = luo_attributes.retrieve(external_source)
if li_sts < 0 then
	mylog.log(this, "u_component_observation.base_initialize:0024", "error getting external source attributes (" + external_source + ")", 4)
	return -1
end if
f_attribute_ds_to_str(luo_attributes, lstr_attributes)

// Load the source-specific attributes
luo_attributes.set_dataobject("dw_o_external_source_attribute")
li_sts = luo_attributes.retrieve(external_source, computer_id, office_id)
if li_sts < 0 then
	mylog.log(this, "u_component_observation.base_initialize:0033", "error getting external source attributes (" + external_source + ")", 4)
	return -1
end if
f_attribute_ds_to_str(luo_attributes, lstr_attributes)

// Add the attributes to the component
add_attributes(lstr_attributes)


DESTROY luo_attributes

c_external_observation = CREATE u_ds_data
c_external_observation_location = CREATE u_ds_data
c_external_observation_result = CREATE u_ds_data


c_external_observation.set_dataobject("dw_c_external_observation", cprdb)
c_external_observation_location.set_dataobject("dw_c_external_observation_location", cprdb)
c_external_observation_result.set_dataobject("dw_c_external_observation_result", cprdb)


li_sts = c_external_observation.retrieve(external_source)
if li_sts < 0 then
	mylog.log(this, "u_component_observation.base_initialize:0056", "Error retrieving observations", 4)
	return -1
end if

li_sts = c_external_observation_location.retrieve(external_source)
if li_sts < 0 then
	mylog.log(this, "u_component_observation.base_initialize:0062", "Error retrieving locations", 4)
	return -1
end if

li_sts = c_external_observation_result.retrieve(external_source)
if li_sts < 0 then
	mylog.log(this, "u_component_observation.base_initialize:0068", "Error retrieving results", 4)
	return -1
end if

get_attribute("owner_id", owner_id)
if isnull(owner_id) then owner_id = 0

get_attribute("timer_interval", lr_timer)
if not isnull(lr_timer) and lr_timer > 0 then
	set_timer(lr_timer)
end if

connected = false

return 1

end function

public function integer do_source ();integer li_sts
string ls_comment_title
boolean lb_comment_title_prompt
boolean lb_current_service_window_enabled
long ll_whandle
long i
long j
long ll_patient_workplan_item_id
string ls_null
long ll_null

setnull(ls_null)
setnull(ll_null)

lb_current_service_window_enabled = false

if cpr_mode = "CLIENT" then
	// See if the current service has the enabled window.
	if not isnull(current_service) and isvalid(current_service) then
		if not isnull(current_service.service_window) and isvalid(current_service.service_window) then
			ll_whandle = handle(current_service.service_window)
			if IsWindowEnabled(ll_whandle) then lb_current_service_window_enabled = true
		end if
	end if
	
	get_attribute("comment_title_prompt", lb_comment_title_prompt)
	if lb_comment_title_prompt then
		// First see if a comment_title has already been provided
		ls_comment_title = get_attribute("comment_title")
		if isnull(ls_comment_title) Then
			// If not then prompt the user for a comment_title
			ls_comment_title = get_comment_title(get_attribute("comment_title_top_20_code"))
			// If null is returned then the user pressed "Cancel"
			if isnull(ls_comment_title) then Return 0
		end if
		// If an empty string was returned, then use a null instead
		If trim(ls_comment_title) = "" then setnull(ls_comment_title)
		
		if not isnull(ls_comment_title) then
			add_attribute("comment_title", ls_comment_title)
		end if
	end if
end if

TRY
	li_sts = do_source_2()
CATCH (exception le_error)
	get_attribute("document_patient_workplan_item_id", ll_patient_workplan_item_id)
	if ll_patient_workplan_item_id > 0 then
		// Then save the attribute to the database
		sqlca.sp_add_workplan_item_attribute( &
				ls_null, &
				ll_null, &
				ll_patient_workplan_item_id, &
				"error_message", &
				le_error.text, &
				current_scribe.user_id, &
				current_user.user_id)
		if not tf_check() then return -1
		
	end if
	li_sts = -1
END TRY


// If the current service had the enabled window before, make sure it still does
if lb_current_service_window_enabled then
	if not IsWindowEnabled(ll_whandle) then
		EnableWindow(ll_whandle, true)
	end if
end if

if not isnull(display_window) and isvalid(display_window) then
	display_window.event post results_posted(this)
end if

do_source_status = li_sts

return li_sts

end function

public function string internal_location (string ps_external_observation_id, string ps_external_location);string ls_find
long ll_row
long ll_rowcount
string ls_location

ll_rowcount = c_external_observation_location.rowcount()

ls_find = "external_observation='" + ps_external_observation_id + "'"
ls_find += " and external_observation_location='" + ps_external_location + "'"
ll_row = c_external_observation_location.find(ls_find, 1, ll_rowcount)
if ll_row > 0 then
	ls_location = c_external_observation_location.object.location[ll_row]
	if isnull(ls_location) then ls_location = "NA"
else
	ls_location = "NA"
end if

return ls_location

end function

public function string internal_observation_id (string ps_external_observation_id);string ls_find
long ll_row
long ll_rowcount
string ls_observation_id

ll_rowcount = c_external_observation.rowcount()

ls_find = "external_observation='" + ps_external_observation_id + "'"
ll_row = c_external_observation.find(ls_find, 1, ll_rowcount)
if ll_row > 0 then
	ls_observation_id = c_external_observation.object.observation_id[ll_row]
else
	setnull(ls_observation_id)
end if

return ls_observation_id

end function

public function integer internal_result_sequence (string ps_external_observation_id, string ps_external_observation_result);string ls_find
long ll_row
long ll_rowcount
integer li_result_sequence

ll_rowcount = c_external_observation_result.rowcount()

ls_find = "external_observation='" + ps_external_observation_id + "'"
ls_find += " and external_observation_result='" + ps_external_observation_result + "'"
ll_row = c_external_observation_result.find(ls_find, 1, ll_rowcount)
if ll_row > 0 then
	li_result_sequence = c_external_observation_result.object.result_sequence[ll_row]
else
	setnull(li_result_sequence)
end if

return li_result_sequence

end function

protected function integer xx_set_processed (string ps_id, integer pi_status);string lsa_attributes[]
string lsa_values[]
integer li_count
integer li_sts

li_count = get_attributes(lsa_attributes, lsa_values)

if not ole_class then return 0

li_sts = ole.set_processed(external_source, ps_id, pi_status)
if li_sts < 0 then return -1
if li_sts = 0 then return 0


return 1

end function

public function integer set_processed (string ps_external_item_id, integer pi_status);//
//
// ps_external_item_id 	ID which was provided by the external source when do_source() was performed
// pi_status				1 = Success
//								-1 = Error	
//
//
integer li_sts

li_sts = xx_set_processed(ps_external_item_id, pi_status)

return li_sts


end function

public function integer read_data (string ps_data, string ps_external_item_id);str_external_observation lstr_observation
string ls_beginning

// First determine what kind of data we have

// See if it's XML data
ls_beginning = left(trim(ps_data), 8)
if pos(ls_beginning, "<") > 0 and (pos(ps_data, "</") > 0 or pos(ps_data, "/>") > 0) then
	return f_observation_read_xml_documents(this, ps_data, ps_external_item_id)
end if

// If it's not XML, then treat it as a text result
lstr_observation.external_item_id = ps_external_item_id
setnull(lstr_observation.observation_id)
lstr_observation.result_count = 1
lstr_observation.result[1].id_count = 0
lstr_observation.result[1].result_type = "PERFORM"
setnull(lstr_observation.result[1].location)
lstr_observation.result[1].result_date_time = datetime(today(), now())
lstr_observation.result[1].result_value = ps_data
lstr_observation.result[1].result_unit = "Text"
setnull(lstr_observation.result[1].abnormal_flag)
setnull(lstr_observation.result[1].abnormal_nature)

observation_count += 1
observations[observation_count] = lstr_observation

return 1


end function

public function integer send_attachment (str_external_observation_attachment pstr_attachment, long pl_addressee);integer li_sts
string ls_document_type
str_c_xml_class lstr_xml_class
string ls_null
string ls_test_message_flag
str_patient lstr_patient

setnull(ls_null)

ls_test_message_flag = get_attribute("test_message_flag")
if isnull(current_service) or not isvalid(current_service) then
	ls_test_message_flag = "N"
else
	ls_test_message_flag = current_service.get_attribute("test_message_flag")
	if isnull(ls_test_message_flag) then
		if isnull(current_service.cpr_id) then
			ls_test_message_flag = "N"
		else
			li_sts = f_get_patient(current_service.cpr_id, lstr_patient)
			if li_sts <= 0 then
				ls_test_message_flag = "N"
			elseif lstr_patient.test_patient then
				ls_test_message_flag = "Y"
			else
				ls_test_message_flag = "N"
			end if
		end if
	end if
end if

if isvalid(pstr_attachment.xml_document) and not isnull(pstr_attachment.xml_document) then
	lstr_xml_class = pstr_attachment.xml_document.get_xml_class()
	if len(lstr_xml_class.xml_class) > 0 then
		ls_document_type = "XML." + lstr_xml_class.xml_class
	else
		ls_document_type = "XML."
	end if
	
	// If the attachment is and xml document, then send it directly
	li_sts = f_send_document(ls_document_type, pl_addressee, "XML", pstr_attachment.xml_document.xml_string, ls_null, ls_null, ls_null, f_string_to_boolean(ls_test_message_flag))
else
	// Otherwise, send it as a blob
	if len(pstr_attachment.extension) > 0 then
		ls_document_type = "FILE." + pstr_attachment.extension
	else
		ls_document_type = "FILE."
	end if
	li_sts = f_send_document_blob(ls_document_type, pl_addressee, pstr_attachment.attachment, ls_null, ls_null, ls_null, f_string_to_boolean(ls_test_message_flag))
end if

if li_sts <= 0 then
	return li_sts
end if

// The document was sent successfully so now process the epiehandler instructions
li_sts = process_epiehandler(pstr_attachment.epiehandler, f_current_context())
if li_sts < 0 then
	log.log(this, "u_component_observation.send_attachment:0058", "Error processing EpIEHandler instructions", 4)
	return -1
end if

return 1


end function

public function string internal_result_unit (string ps_external_observation_id, string ps_external_observation_result, string ps_result_value);string ls_find
long ll_row
long ll_rowcount
string ls_result_unit

ll_rowcount = c_external_observation_result.rowcount()

setnull(ls_result_unit)

ls_find = "external_observation='" + ps_external_observation_id + "'"
ls_find += " and external_observation_result='" + ps_external_observation_result + "'"
ll_row = c_external_observation_result.find(ls_find, 1, ll_rowcount)
if ll_row > 0 then
	ls_result_unit = c_external_observation_result.object.result_unit[ll_row]
end if

if isnull(ls_result_unit) then
	if isnumber(ps_result_value) then
		ls_result_unit = "NA"
	else
		ls_result_unit = "TEXT"
	end if
end if

return ls_result_unit

end function

public function integer get_mapped_results (string ps_external_observation_id, string ps_external_observation_result, ref string psa_observation_id[], ref integer pia_result_sequence[]);string ls_find
long ll_row
long ll_rowcount
integer li_result_sequence
integer li_mapping_count

ll_rowcount = c_external_observation_result.rowcount()
li_mapping_count = 0

ls_find = "external_observation='" + ps_external_observation_id + "'"
ls_find += " and external_observation_result='" + ps_external_observation_result + "'"
ll_row = c_external_observation_result.find(ls_find, 1, ll_rowcount)
DO WHILE ll_row > 0 and ll_row <= ll_rowcount
	li_mapping_count += 1
	psa_observation_id[li_mapping_count] = c_external_observation_result.object.observation_id[ll_row]
	pia_result_sequence[li_mapping_count] = c_external_observation_result.object.result_sequence[ll_row]

	ll_row = c_external_observation_result.find(ls_find, ll_row + 1, ll_rowcount + 1)
LOOP

return li_mapping_count

end function

public function integer process_epiehandler (str_epiehandler_type pstr_epiehandler, str_context pstr_context);long ll_propertyset_count
long i
string ls_progress_type
integer li_sts
datetime ldt_null
long ll_null

setnull(ldt_null)
setnull(ll_null)

ll_propertyset_count = upperbound(pstr_epiehandler.propertyset)
for i = 1 to ll_propertyset_count
	ls_progress_type = pstr_epiehandler.propertyset[i].propertytype
	if isnull(ls_progress_type) or trim(ls_progress_type) = "" then
		ls_progress_type = "Property"
	end if
	
	li_sts = f_set_progress(pstr_epiehandler.propertyset[i].cprid, &
								pstr_epiehandler.propertyset[i].contextobject, &
								pstr_epiehandler.propertyset[i].objectkey, &
								ls_progress_type, &
								pstr_epiehandler.propertyset[i].property, &
								pstr_epiehandler.propertyset[i].value, &
								ldt_null, &
								ll_null, &
								ll_null, &
								ll_null)
	if li_sts < 0 then return -1
next

return 1

end function

protected function integer xx_do_source () throws exception;string lsa_attributes[]
string lsa_values[]
integer li_count
integer li_sts

li_count = get_attributes(lsa_attributes, lsa_values)

if not ole_class then return 0

li_sts = ole.do_source(external_source, li_count, lsa_attributes, lsa_values)
if li_sts < 0 then return -1
if li_sts = 0 then return 0


return 1

end function

protected function integer do_source_2 () throws exception;integer li_sts
long i
long j
string ls_xml
string ls_xml_class
string ls_xml_root_element
string ls_xml_attribute_name

observation_count = 0

// Generate an XML data file if requested
ls_xml_class = get_attribute("param_xml_class")
if len(ls_xml_class) > 0 then
	get_attribute("param_attribute_name", ls_xml_attribute_name)
	if isnull(ls_xml_attribute_name) then ls_xml_attribute_name = "xml_data"
	
	ls_xml = f_get_xml_document_from_class(ls_xml_class, get_attributes())
	
	if len(ls_xml) > 0 then
		add_attribute(ls_xml_attribute_name, ls_xml)
	end if
end if

TRY
	li_sts = xx_do_source()
CATCH (exception le_error)
	log.log(this, "u_component_observation.do_source_2:0027", "Error calling xx_do_source (" + le_error.text + ")", 4)
	THROW le_error
END TRY


// If there is one unmapped observation and one XML attachment and no results, 
// and there is not message ID, then run the XML through the "read_data" method
if observation_count = 1 then
	if observations[1].result_count = 0 and observations[1].attachment_list.attachment_count = 1 then
		if lower(observations[1].attachment_list.attachments[1].extension) = "xml" then
			if isnull(observations[1].external_item_id) or observations[1].external_item_id = "" then
				observation_count = 0
				ls_xml = f_blob_to_string(observations[1].attachment_list.attachments[1].attachment)
				li_sts = read_data(ls_xml, "")
				if li_sts < 0 then
					log.log(this, "u_component_observation.do_source_2:0042", "Error reading xml documents", 4)
					return -1
				end if
			end if
		end if
	end if
end if

// If xml documents were returned as attachments, make them XML documents
for i = 1 to observation_count
	for j = 1 to observations[i].attachment_list.attachment_count
		if (isnull(observations[i].attachment_list.attachments[j].xml_document) &
		    or not isvalid(observations[i].attachment_list.attachments[j].xml_document)) &
			and lower(observations[i].attachment_list.attachments[j].extension) = "xml" then

			// The attachment has an extension of "xml", but the external source component
			// did not supply a document object.  So make one.
			li_sts = f_get_xml_document(f_blob_to_string(observations[i].attachment_list.attachments[j].attachment) , observations[i].attachment_list.attachments[j].xml_document)

		end if
	next
next


return 1

end function

on u_component_observation.create
call super::create
end on

on u_component_observation.destroy
call super::destroy
end on

