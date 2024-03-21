$PBExportHeader$u_component_document_receiver_epie.sru
forward
global type u_component_document_receiver_epie from u_component_document_receiver
end type
end forward

global type u_component_document_receiver_epie from u_component_document_receiver
end type
global u_component_document_receiver_epie u_component_document_receiver_epie

type variables
SoapConnection conn // Define SoapConnection
EpieGateway_service EpIE_Gateway // Declare proxy
epiegateway_credentialsheader credentials

long message_count

end variables

forward prototypes
protected function long xx_get_documents ()
public function integer read_jmjmessage (pbdom_element puo_jmjmessage)
end prototypes

protected function long xx_get_documents ();long i
integer li_sts
long ll_owner_id
any la_rtn
long rVal, lLog
real amount
string ls_templog
string ls_customer_id
string ls_results_xml
u_xml_document pbdom_doc
u_xml_document pbdom_new_doc
PBDOM_ELEMENT pbdom_root
PBDOM_ELEMENT pbdom_element_array[]
string ls_root
string ls_testingmessageflag
string ls_document_type
long ll_sts
string ls_usr
string ls_pwd
string ls_options
string ls_ipaddr
string ls_null
long ll_null
string ls_pwd_e

setnull(ls_null)
setnull(ll_null)

conn = create SoapConnection  //Instantiated connection

ls_usr = sqlca.fn_get_preference( "SYSTEM", "epie_user", ls_null, ll_null)
if isnull(ls_usr) or ls_usr = "" then
	log.log(this, "u_component_document_receiver_epie.xx_get_documents:0033", "EpIE User is not set", 4)
	return -1
end if
ls_pwd_e = sqlca.fn_get_preference( "SYSTEM", "epie_pwd", ls_null, ll_null)
if isnull(ls_pwd_e) or ls_pwd_e = "" then
	log.log(this, "u_component_document_receiver_epie.xx_get_documents:0038", "EpIE Password is not set", 4)
	return -1
end if

if common_thread.utilities_ok() then
	// Potentially replace with CrypterObject TDES! type SymmetricDecrypt / SymmetricEncrypt
	TRY
		ls_pwd = common_thread.eprolibnet4.of_decryptstring(ls_pwd_e, common_thread.key())
	CATCH (throwable le_error)
		log.log(this, "u_component_document_receiver_epie.xx_get_documents:0045", "Error getting EpIE credentials: " + le_error.text, 4)
		return -1
	END TRY
else
	log.log(this, "u_component_document_receiver_epie.xx_get_documents:0051", "No EpIE credentials (Utilities not available)", 3)
	return -1
end if


ll_sts = conn.SetSoapLogFile (ls_templog) 

rVal = Conn.CreateInstance(EpIE_Gateway, "EpieGateway_service")
if rVal <> 0 then
	log.log(this, "u_component_document_receiver_epie.xx_get_documents:0054", "Creating SOAP proxy failed (" + string(rVal) + ")", 4)
	destroy conn
	return -1
end if

credentials = CREATE epiegateway_credentialsheader
credentials.user = ls_usr
credentials.password = ls_pwd
setnull(credentials.actor)
setnull(credentials.encodedmustunderstand)
setnull(credentials.encodedmustunderstand12)
setnull(credentials.encodedrelay)
setnull(credentials.role)

EpIE_Gateway.setcredentialsheadervalue(credentials)

// Set the interfaceserviceid = 0.  This will be overridded for each document by the information in the message wrapper
interfaceserviceid = 0
// For now, the transportsequence is zero for all documents that arrive through EpIE
transportsequence = 0

get_attribute("owner_id", ll_owner_id)

ls_customer_id = string(sqlca.customer_id)

get_attribute("document_type", ls_document_type)

message_count = 0

get_attribute("testingmessageflag", ls_testingmessageflag)
if isnull(ls_testingmessageflag) then
	if sqlca.customer_id >= 900 and sqlca.customer_id <= 999 then
		ls_testingmessageflag = "Y"
	else
		ls_testingmessageflag = "N"
	end if
end if

// Get Message Bag
TRY
	la_rtn = EpIE_Gateway.getmessagebag2(ls_customer_id, ls_document_type, ls_testingmessageflag)
	if classname(la_rtn) = "string" then
		ls_results_xml = string(la_rtn)
	else
		ls_results_xml = ""
	end if
CATCH ( SoapException lt_error )
	log.log(this, "u_component_document_receiver_epie.xx_get_documents:0101", "Error calling EpIE download gateway (" + lt_error.text + ")", 4)
	return -1
END TRY


if isnull(ls_results_xml) or ls_results_xml = "" then return 0

li_sts = f_get_xml_document(ls_results_xml, pbdom_doc)
if li_sts <= 0 then return -1

pbdom_root = pbdom_doc.XML_Document.GetRootElement()

ls_root = pbdom_root.GetName()

pbdom_root.GetChildElements(ref pbdom_element_array)
for i = 1 to UpperBound(pbdom_element_array)
	li_sts = read_jmjmessage(pbdom_element_array[i])
next


Return message_count


end function

public function integer read_jmjmessage (pbdom_element puo_jmjmessage);u_xml_document lo_payload_document
pbdom_element pbdom_root
pbdom_element le_element
pbdom_element pbdom_element_array[]
pbdom_attribute pbdom_attribute_array[]
integer li_sts
long i
long ll_owner_id
string ls_document_type
string ls_payload
string ls_element
string ls_temp
string ls_temp2
string ls_description
string ls_xml_description
string ls_extension
string ls_root
string ls_text
long ll_from_interfaceserviceid

str_external_observation_attachment lstr_document

setnull(lstr_document.message_id)
setnull(ll_owner_id)
setnull(ls_document_type)
setnull(ls_payload)
setnull(ls_description)
setnull(ls_xml_description)

setnull(ll_from_interfaceserviceid)

puo_jmjmessage.GetChildElements(ref pbdom_element_array)
for i = 1 to UpperBound(pbdom_element_array)
	ls_element = pbdom_element_array[i].getname()
	ls_temp = pbdom_element_array[i].gettext()
	if len(ls_temp) > 0 then
		CHOOSE CASE lower(ls_element)
			CASE "from"
				le_element =  pbdom_element_array[i].GetChildElement("AddresseeID")
				if not isnull(le_element) then
					ls_temp2 = le_element.gettext()
					if isnumber(ls_temp2) then
						ll_from_interfaceserviceid = long(ls_temp2)
					end if
				end if
			CASE "jmjmessageid"
				lstr_document.message_id = ls_temp
			CASE "ownerid"
				if isnumber(ls_temp) then ll_owner_id = long(ls_temp)
			CASE "documenttype"
				ls_document_type = ls_temp
			CASE "description"
				ls_description = ls_temp
			CASE "payload"
				ls_payload = ls_temp
		END CHOOSE
	end if
next

li_sts = f_get_xml_document(ls_payload , lo_payload_document)
if li_sts > 0 then
	lstr_document.xml_document = lo_payload_document
	
	// Since we have an XML document, see if we can glean some data about it
	pbdom_root = lo_payload_document.XML_Document.GetRootElement()
	
	ls_root = pbdom_root.GetName()
	ls_text = pbdom_root.GetText()
	ls_xml_description = ls_root
	
	if pbdom_root.HasAttributes() then
		// Scan the attributes for an extension and/or a description
		
		pbdom_root.GetAttributes(ref pbdom_attribute_array[])
		
		for i=1 to UpperBound(pbdom_attribute_array)
			choose case lower(pbdom_attribute_array[i].GetName())
				case "extension"
					ls_extension = pbdom_attribute_array[i].GetText()
				case "description"
					ls_xml_description = pbdom_attribute_array[i].GetText()
			end choose
		next
	end if
end if


// Now, figure out the best description for this message from what we have
if isnull(ls_description) then
	if isnull(ls_xml_description) then
		if isnull(ls_document_type) then
			ls_description = "XML Document"
		else
			ls_description = ls_document_type + " Document"
		end if
	else
		ls_description = ls_xml_description
	end if
end if

// Set the rest of the attributes
SELECT filetype
INTO :lstr_document.extension
FROM c_Document_Type
WHERE document_type = :ls_document_type;
if not tf_check() then return -1
if len(lstr_document.extension) = 0 or isnull(lstr_document.extension) then
	lstr_document.extension = "xml"
end if

SELECT default_attachment_type
INTO :lstr_document.attachment_type
FROM c_Attachment_Extension
WHERE extension = :lstr_document.extension;
if not tf_check() then return -1
if len(lstr_document.attachment_type) = 0 or isnull(lstr_document.attachment_type) then
	lstr_document.attachment_type = "XML"
end if

lstr_document.attachment = blob(ls_payload)
lstr_document.attachment_comment_title = ls_description

if isnull(ll_owner_id) and not isnull(ll_from_interfaceserviceid) then
	lstr_document.owner_id = ll_from_interfaceserviceid
elseif not isnull(ll_owner_id) then
	lstr_document.owner_id = ll_owner_id
else
	lstr_document.owner_id = sqlca.customer_id
end if
if isnull(ll_from_interfaceserviceid) then
	lstr_document.interfaceserviceid = interfaceserviceid
else
	lstr_document.interfaceserviceid = ll_from_interfaceserviceid
end if
lstr_document.transportsequence = transportsequence

// The document structure is not populated, so post the attachment
li_sts = new_document(lstr_document)
if li_sts <= 0 then return li_sts

if len(lstr_document.message_id) > 0 then
	EpIE_Gateway.complete(lstr_document.message_id, 1)
end if

message_count++

return 1


end function

on u_component_document_receiver_epie.create
call super::create
end on

on u_component_document_receiver_epie.destroy
call super::destroy
end on

