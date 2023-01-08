$PBExportHeader$u_component_send_report.sru
forward
global type u_component_send_report from u_component_base_class
end type
end forward

global type u_component_send_report from u_component_base_class
end type
global u_component_send_report u_component_send_report

type variables
string					report_id
string					description
string					report_type
string					message_type
long						subscription_id
long						display_script_id
u_rich_text_edit		rte
end variables

forward prototypes
public function integer sendreport (string ps_report_id, str_attributes pstr_attributes)
public function integer xx_sendreport ()
public function integer log_message (string ps_text)
protected function integer xx_initialize ()
end prototypes

public function integer sendreport (string ps_report_id, str_attributes pstr_attributes);integer				li_sts
string				ls_report_office_id,ls_description
u_ds_data			report_attributes
str_attributes		lstr_attributes


report_id =	ps_report_id

if isnull(report_id) then
	mylog.log(this, "u_component_send_report.sendreport:0010", "Report not found (" + ps_report_id + ")", 4)
	return -1
end if

SELECT description,report_type
INTO :description,:report_type
FROM c_Report_Definition
WHERE report_id = :report_id
USING cprdb;
If not tf_check() then return -1
If cprdb.sqlcode = 100 then
	mylog.log(this, "u_component_send_report.sendreport:0021", "Report not found (" + report_id + ")", 4)
	return -1
end if

// See if an office_id attribute was passed in
ls_report_office_id = f_attribute_find_attribute(pstr_attributes, "office_id")
if isnull(ls_report_office_id) then ls_report_office_id = gnv_app.office_id

// get attributes from c_report_attribute
report_attributes = Create u_ds_data
report_attributes.Set_dataobject("dw_report_attribute")
report_attributes.Settransobject(sqlca)
li_sts = report_attributes.Retrieve(report_id)
If tf_check() and li_sts > 0  Then
	f_attribute_ds_to_str(report_attributes,lstr_attributes)
End If

// get attributes from o_report_attribute
report_attributes.Set_dataobject("dw_o_report_attribute")
report_attributes.Settransobject(sqlca)
li_sts = report_attributes.Retrieve(report_id, ls_report_office_id)
If tf_check() and li_sts > 0 Then
	f_attribute_ds_to_str(report_attributes,lstr_attributes)
End If

// Add the table attributes
add_attributes(lstr_attributes)

// Add the passed in attributes
add_attributes(pstr_attributes)

display_script_id = long(get_attribute("display_script_id"))
//Choose Case report_type
//	Case "RTF"
		Openwithparm(w_send_report_rtf,this)
//	Case Else
//End Choose

Return li_sts
end function

public function integer xx_sendreport ();Return 100
end function

public function integer log_message (string ps_text);long 					ll_message_id
long 					ll_message_size
blob 					lblb_message
integer 				li_sts,li_count
string 				ls_direction
string 				ls_status

u_ds_data			luo_data

// DECLARE lsp_log_message PROCEDURE FOR dbo.sp_log_message  
//         @pl_subscription_id = :subscription_id,   
//         @ps_message_type = :message_type,   
//         @pl_message_size = :ll_message_size,   
//         @ps_status = :ls_status,
//			@ps_direction = :ls_direction,
//         @pl_message_id = :ll_message_id OUT
//USING cprdb;


lblb_message = blob(ps_text)
ll_message_size = len(lblb_message)
ls_direction = "O"
ls_status = "NEW"

// Get the subscription id based on the message type for this component
// assuming message type MUST be unique 

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_message_subscription_data")
li_count = luo_data.retrieve(message_type, "O")
if li_count < 0 then
	mylog.log(this, "u_component_send_report.log_message:0033", "Error getting subscribers", 4)
	return -1
elseif li_count = 0 then
	mylog.log(this, "u_component_send_report.log_message:0036", "No subscribers for message type.  Message will not be sent (" + message_type + ")", 2)
	return -1
end if

subscription_id = luo_data.object.subscription_id[1]


// First create the log record and get the message_id
cprdb.sp_log_message  ( &
         subscription_id, &
         message_type, &
         ll_message_size, &
         ls_status, &
			ls_direction, &
         ref ll_message_id);
//EXECUTE lsp_log_message;
if not cprdb.check() then return -1
//
//FETCH lsp_log_message INTO :ll_message_id;
//if not cprdb.check() then return -1
//
//CLOSE lsp_log_message;
//
if ll_message_id <= 0 then
	mylog.log(this, "u_component_send_report.log_message:0053", "Error logging report for (" + string(subscription_id) + ")", 4)
	Return -1
end if

// save the blob message
UPDATEBLOB o_Message_Log
SET message = :lblb_message
WHERE message_id = :ll_message_id
USING cprdb;
if not cprdb.check() then return -1

// set the log status as 'STREAMED'
UPDATE o_Message_Log
SET cpr_id = :current_service.cpr_id,
encounter_id = :current_service.encounter_id,
status = 'STREAMED'
WHERE message_id = :ll_message_id
USING cprdb;


Return ll_message_id
end function

protected function integer xx_initialize ();message_type = get_attribute("message_type")

Return 1
end function

on u_component_send_report.create
call super::create
end on

on u_component_send_report.destroy
call super::destroy
end on

