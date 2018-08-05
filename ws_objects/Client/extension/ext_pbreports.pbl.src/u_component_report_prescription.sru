$PBExportHeader$u_component_report_prescription.sru
forward
global type u_component_report_prescription from u_component_report
end type
end forward

global type u_component_report_prescription from u_component_report
end type
global u_component_report_prescription u_component_report_prescription

forward prototypes
public function integer xx_printreport ()
end prototypes

public function integer xx_printreport ();//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Return: Integer
//
// Modified By:Sumathi Chinnasamy									Modified On:08/12/99
//
// Description:
// Generates prescription report & groups the records by treatment id with page breaks by group.
//	Note: DEA number is printed on report either attr 'always_print_dea' is SET Or dea_number_req 
//       is SET for each drug in c_drug_definition table.
//
//Modified By:Sumathi Chinnasamy									Modified On:08/30/99
//
// Description:
// added a check whether to print dr signature for controlled substances
//
//Modified By: Sumathi Chinnasamy								Modified On:09/21/01
//
// Description:
// Build 4.0 model runs all the reports (client & server) thru service component. so we assume all 
// patient,encounter & treatment objects are already set by service component.
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
String								ls_practice_name, ls_heading, ls_signature_file
String								ls_temp, ls_by_line, ls_default_by_line
String								ls_dataobject, ls_find, ls_brand_necessary
String								ls_always_print_dea, ls_dea_number_required, ls_print_ctrl_substance
string								ls_signing_provider_name,ls_generic_signature
string								ls_signing_provider_license,ls_rx_sig,ls_address
string								ls_signing_provider_npi
Integer								li_sts, i, j, li_count,li_type
Long									ll_row
long 									ll_treatment_id
boolean 								lb_use_stamp,lb_always_use_stamp
boolean								lb_use_supervisor_signature_stamp
string								ls_signature_stamp
long 									ll_bitmap_width,ll_bitmap_height
long									ll_temp
date	ld_prescription_date
any									dr,dl
string ls_pharmacist_instructions
string ls_patient_instructions
boolean lb_provider_dea
string ls_null
str_progress_list lstr_attachments
long ll_height
str_progress lstr_refill_progress
boolean lb_refill_progress_found
long ll_encounter_id
datetime ldt_encounter_date

/* object declartation */
u_component_treatment   		luo_rx
u_component_attachment			luo_sig
u_user								luo_provider, luo_ordered_by
str_treatment_description		lstra_treatments[]

setnull(ls_null)


ll_row = 0
/* get all the attribute values from u_component_report_base_class */
ll_treatment_id				= Long(get_attribute("treatment_id"))
ll_encounter_id				= Long(get_attribute("encounter_id"))
ls_dataobject 					= get_attribute("dataobject")
IF Isnull(ls_dataobject) THEN ls_dataobject = "dw_prescription"
ls_always_print_dea			= Upper(Left(get_attribute("always_print_dea"),1))
ls_print_ctrl_substance		= Upper(Left(get_attribute("print_signature_for_controlled_substance"),1))
If Isnull(ls_print_ctrl_substance) Then ls_print_ctrl_substance = "N"
ls_generic_signature = Upper(Left(get_attribute("generic_signature"),1))
If Isnull(ls_generic_signature) Then ls_generic_signature = "L"
get_attribute("use_supervisor_signature_stamp", lb_use_supervisor_signature_stamp)

// Check for valid patient & enocunter
If isnull(current_patient) Then
	mylog.log(this, "u_component_report_prescription.xx_printreport:0074", "No patient context ", 4)
	Return -1
Elseif isnull(ll_encounter_id) Then
	if isnull(current_patient.open_encounter_id) then
		mylog.log(this, "u_component_report_prescription.xx_printreport:0078", "No encounter context ", 4)
		Return -1
	else
		ll_encounter_id = current_patient.open_encounter_id
	end if
End If 

ldt_encounter_date = current_patient.encounters.encounter_date(ll_encounter_id)

// get the x co-ordinate values for line objects 
SELECT type 
into :li_type
FROM c_Prescription_Format
WHERE dataobject = :ls_dataobject;
If not tf_check() then return -1

If isnull(li_type) or li_type = 0 Then li_type = 1

report_datastore.dataobject = ls_dataobject
If li_type = 2 then
	dr = report_datastore.object.right_signature_line.x1
	dl = report_datastore.object.left_signature_line.x1
End If

ls_temp = datalist.get_preference("PREFERENCES", "rx_use_signature_stamp")
lb_use_stamp = f_string_to_boolean(ls_temp)

ls_temp = datalist.get_preference("PREFERENCES", "rx_always_use_signature_stamp")
lb_always_use_stamp = f_string_to_boolean(ls_temp)

// Calculate the bitmap height and width
ll_bitmap_width = printer_resolution_x * long(report_datastore.describe("signature_image.width")) / 1000
if ll_bitmap_width <= 0 then setnull(ll_bitmap_width)

ll_bitmap_height = printer_resolution_y * long(report_datastore.describe("signature_image.height")) / 1000
if ll_bitmap_height <= 0 then setnull(ll_bitmap_height)

if isnull(ll_treatment_id) then
	// construct a search string
	ls_find = "open_encounter_id=" + string(ll_encounter_id) &
				+ " and treatment_type='MEDICATION'" &
				+ " and Isnull(treatment_status)" &
				+ " and date(begin_date) >= date('" + &
				String(date(ldt_encounter_date), date_format_string) + "')"
else
	ls_find = "treatment_id=" + string(ll_treatment_id)
end if


// Set the date formats
report_datastore.object.dob.format = date_format_string
report_datastore.object.encounter_date.format = date_format_string

// Set the heights
get_attribute("header_height", ll_height)
if ll_height > 0 then
	report_datastore.modify("datawindow.header.height=" + string(ll_height))
end if

get_attribute("patient_data_height", ll_height)
if ll_height > 0 then
	report_datastore.modify("datawindow.header.1.height=" + string(ll_height))
end if


li_count = current_patient.treatments.get_treatments(ls_find, lstra_treatments)
// loop through all treatments
For i = 1 To li_count
	// Initialize the signature file to null
	setnull(ls_signature_file)
	setnull(luo_ordered_by)
	
	ll_treatment_id = sqlca.fn_get_current_treatment(current_patient.cpr_id, lstra_treatments[i].treatment_id)
	if not tf_check() then return -1
	if isnull(ll_treatment_id) or ll_treatment_id <= 0 then ll_treatment_id = lstra_treatments[i].treatment_id
	
	li_sts = current_patient.treatments.treatment(luo_rx, ll_treatment_id)
	If li_sts <= 0 Then Continue

	If luo_rx.dispense_amount <= 0 And Isnull(luo_rx.dose_amount) Then Continue
	ls_rx_sig = luo_rx.treatment_description
	If isnull(ls_rx_sig) Then Continue

	// Get the last refill progress for use in the ordering doc and prescription date calculations
	li_sts = f_get_last_progress( current_patient.cpr_id, "treatment", ll_treatment_id, "Refill", ls_null, lstr_refill_progress)
	if li_sts < 0 then return -1
	if li_sts = 0 then
		lb_refill_progress_found = false
	else
		lb_refill_progress_found = true
	end if
	
	// get special instructions
	ls_pharmacist_instructions = f_get_progress_value(current_patient.cpr_id, 'Treatment', luo_rx.treatment_id, "Instructions", "Pharmacist Instructions")
	if len(ls_pharmacist_instructions) > 0 then
		ls_rx_sig += "~n"+"Pharmacist: "+ls_pharmacist_instructions
	end if
	
	ls_patient_instructions = f_get_progress_value(current_patient.cpr_id, 'Treatment', luo_rx.treatment_id, "Instructions", "Patient Instructions")
	if len(ls_patient_instructions) > 0 then
		ls_rx_sig += "~n"+"Patient: "+ls_patient_instructions
	end if

	// If the Rx is signed, check to see if we should print the signature
	// If dea_number_required = "Y" then the drug is a controlled
	// substance.  If that's the case, the print_ctrl_substance report
	// attribute controls whether or not to print the signature
	Select controlled_substance_flag
	Into :ls_dea_number_required
	From c_drug_definition
	Where drug_id = :luo_rx.drug_id;
	If Not tf_check() Then Return -1
			
	If Upper(Left(ls_dea_number_required,1)) = "Y" then
		ls_dea_number_required = "Y"
	else
		ls_dea_number_required = "N" 
	end if
	
	// Now we have to figure out who ordered this prescription.  The rule is that the last
	// provider to order a refill will be the ordered_by provider.  If no refills have been ordered
	// then the last provider to sign for the prescription will be the ordered_by provider.  If no one
	// has signed for the prescription then the provider who originally ordered the prescription will
	// be the ordered_by provider.
	
	// Get the last signature attachment
	lstr_attachments = current_patient.attachments.get_attachments( "Treatment", luo_rx.treatment_id, "Attachment", "Signature")
	
	If lstr_attachments.progress_count > 0 Then
		li_sts = current_patient.attachments.attachment(luo_sig, lstr_attachments.progress[lstr_attachments.progress_count].attachment_id)
		if li_sts <= 0 then setnull(luo_sig)
	else
		setnull(luo_sig)
	end if
		
	// Get the refill notes
	if lb_refill_progress_found then
		luo_ordered_by = user_list.find_user(lstr_refill_progress.user_id)
		// If the person who ordered the refill isn't the same as the last person to sign, then don't use the signature
		if not isnull(luo_sig) then
			if luo_sig.originator.user_id <> luo_ordered_by.user_id then
				setnull(luo_sig)
			end if
		end if
	else
		// If there were no refills then see who last signed for the prescription
		IF Isnull(luo_sig) THEN
			// If no one signed then see who ordered the prescription
			luo_ordered_by = user_list.find_user(luo_rx.ordered_by)
		ELSE
			// If someone signed then they ordered the prescriptino
			luo_ordered_by = luo_sig.originator
		end if
	end if

	// If we have a signature and we need to print the signature the render it into a bitmap	
	If not isnull(luo_sig) and (ls_print_ctrl_substance = "Y" Or ls_dea_number_required= "N") Then
		li_sts = luo_sig.render(".bmp", ls_signature_file, ll_bitmap_width, ll_bitmap_height)
		if li_sts <= 0 then setnull(ls_signature_file)
	end if

	
	If ls_dea_number_required = 'Y' Or ls_always_print_dea = 'Y' Then 
		lb_provider_dea = true
	else
		lb_provider_dea = false
	end if

	// If no one owns the prescription by now the skip it
	if isnull(luo_ordered_by) then continue
	
	IF Isnull(luo_ordered_by.supervisor) THEN
		if luo_ordered_by.certified = "Y" then
			luo_provider = luo_ordered_by
			ls_by_line = "By:  " + luo_ordered_by.provider_name(lb_provider_dea)
			ls_signing_provider_name = luo_ordered_by.provider_name(false)
			ls_signing_provider_license = luo_ordered_by.license_number
			ls_signing_provider_npi = luo_ordered_by.npi
			ls_signature_stamp = user_list.user_signature_stamp(luo_ordered_by.user_id)
		else
			log.log(this, "u_component_report_prescription.xx_printreport:0258", "the user (" + &
				luo_ordered_by.user_full_name + " is not authorized to write prescriptions and has no supervisor", 3)
			continue
		end if
	ELSE
		luo_provider = luo_ordered_by.supervisor
		IF luo_ordered_by.certified = "Y" THEN
			ls_by_line = "This prescription authorized through " + luo_provider.provider_name(lb_provider_dea) + &
								" by " + luo_ordered_by.provider_name(lb_provider_dea)
			ls_signing_provider_name = luo_ordered_by.provider_name(false)
			ls_signing_provider_license = luo_ordered_by.license_number
			ls_signing_provider_npi = luo_ordered_by.npi
			if lb_use_supervisor_signature_stamp then
				ls_signature_stamp = user_list.user_signature_stamp(luo_provider.user_id)
			else
				ls_signature_stamp = user_list.user_signature_stamp(luo_ordered_by.user_id)
			end if
		ELSE
			ls_by_line = "By:  " + luo_provider.provider_name(lb_provider_dea)
			ls_signing_provider_name = luo_provider.provider_name(false)
			ls_signing_provider_license = luo_provider.license_number
			ls_signing_provider_npi = luo_provider.npi
			ls_signature_stamp = user_list.user_signature_stamp(luo_provider.user_id)
		END IF
	END IF

	IF Isnull(luo_provider) THEN
		mylog.log(this, "u_component_report_prescription.xx_printreport:0285", "No provider for prescription (" + &
							current_patient.cpr_id + ", " + string(ll_encounter_id) + &
							", " + luo_rx.drug_id + ")", 3)
		CONTINUE
	END IF
	
	// Check the signature file and use the stamp if appropriate
	If ls_print_ctrl_substance = "Y" Or ls_dea_number_required= "N" then
		if (isnull(ls_signature_file) AND lb_use_stamp) OR lb_always_use_stamp then
			ls_signature_file = ls_signature_stamp
		end if
	end if

	// Calculate the prescription date
	ls_temp = get_attribute("prescription_date")
	if isdate(ls_temp) then
		ld_prescription_date = date(ls_temp)
	else
		if lb_refill_progress_found then
			ld_prescription_date = date(lstr_refill_progress.progress_date_time)
		else
			if not isnull(ldt_encounter_date) then
				if luo_rx.begin_date > ldt_encounter_date then
					ld_prescription_date = date(luo_rx.begin_date)
				else
					ld_prescription_date = date(ldt_encounter_date)
				end if
			else
				ld_prescription_date = today()
			end if
		end if
	end if


// Insert the row into datastore
	ls_address = current_patient.address()
	ll_row = report_datastore.insertrow(0)
	report_datastore.Setitem(ll_row, "signature", ls_rx_sig)
	report_datastore.Setitem(ll_row, "signature_bitmap", ls_signature_file)
	report_datastore.Setitem(ll_row, "name", current_patient.name())
	report_datastore.setitem(ll_row,"dob",current_patient.date_of_birth)
	report_datastore.setitem(ll_row,"address",ls_address)
	report_datastore.Setitem(ll_row, "encounter_date", ld_prescription_date)
	report_datastore.Setitem(ll_row, "billing_id", current_patient.billing_id)
	report_datastore.Setitem(ll_row, "by_line", ls_by_line)
	report_datastore.Setitem(ll_row,"treatment_id",luo_rx.treatment_id)

	If li_type = 2 Then // check where to print signature only for 2-line rx
	// Check if brand name necessary is enabled
		If luo_rx.brand_name_required = "Y" Then
			If ls_generic_signature = "L" Then
				report_datastore.object.print_signature[ll_row] = long(dr)
			Else
				report_datastore.object.print_signature[ll_row] = long(dl)
			End If
		Else
			If ls_generic_signature = "L" Then
				report_datastore.object.print_signature[ll_row] = long(dl)
			Else
				report_datastore.object.print_signature[ll_row] = long(dr)
			End If
		End If
	End If
	If isvalid(luo_rx) Then destroy luo_rx
Next
// recalculate group & sort
report_datastore.sort()
report_datastore.groupcalc()

add_attribute("%SIGNING_PROVIDER%", ls_signing_provider_name)

If isnull(ls_signing_provider_license) Or trim(ls_signing_provider_license) = "" Then
	ls_temp = ls_signing_provider_name
Else
	ls_temp = ls_signing_provider_name + ", Lic# " + ls_signing_provider_license
End if
add_attribute("%SIGNING_PROVIDER_LICENSE%", ls_temp)

If isnull(ls_signing_provider_npi) Or trim(ls_signing_provider_npi) = "" Then
	ls_temp = ls_signing_provider_name
Else
	ls_temp = ls_signing_provider_name + ", NPI: " + ls_signing_provider_npi
End if
add_attribute("%SIGNING_PROVIDER_NPI%", ls_temp)

ls_temp = ls_signing_provider_name
If len(ls_signing_provider_license) > 0 Then
	ls_temp += ", Lic# " + ls_signing_provider_license
End if
If len(ls_signing_provider_npi) > 0 Then
	ls_temp += ", NPI: " + ls_signing_provider_npi
End if
add_attribute("%SIGNING_PROVIDER_LICENSE_NPI%", ls_temp)

If report_datastore.rowcount() > 0 Then
	print_datastore()
Else
	mylog.log(this, "u_component_report_prescription.xx_printreport:0382", "No prescriptions for this encounter (" + &
					current_patient.cpr_id + ", " + string(ll_encounter_id) + ")", 2)
End if

Return 1
end function

on u_component_report_prescription.create
call super::create
end on

on u_component_report_prescription.destroy
call super::destroy
end on

