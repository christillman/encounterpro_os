$PBExportHeader$u_component_report_immunization.sru
forward
global type u_component_report_immunization from u_component_report
end type
end forward

global type u_component_report_immunization from u_component_report
end type
global u_component_report_immunization u_component_report_immunization

forward prototypes
public function integer xx_printreport ()
end prototypes

public function integer xx_printreport ();string 	ls_dataobject
string 	ls_address1
string 	ls_address2
string 	ls_city
string 	ls_state
string 	ls_zip
string 	ls_zip_plus4
string 	ls_phone
string 	ls_fax
string 	ls_office_description
string 	ls_signature_file
string 	ls_sort_by
string 	ls_sort,ls_find
integer 	li_attachment_sequence
integer 	li_sts
long 		ll_rowcount, i
long 		ll_attachment_id
long 		ll_treatment_id
long 		ll_bitmap_width
long 		ll_bitmap_height
str_progress_list lstr_attachments

u_component_attachment 	luo_attachment

// Check for valid patient & enocunter
If isnull(current_patient) Then
	mylog.log(this, "u_component_report_immunization.xx_printreport:0027", "No patient context ", 4)
	Return -1
End If
ls_sort_by = upper(get_attribute("sort_by"))
If ls_sort_by = "V" then ls_sort = "treatment_description A, begin_date A" Else &
									ls_sort = "begin_date A, treatment_description A"

ls_dataobject = get_attribute("dataobject")
If not isnull(ls_dataobject) then report_datastore.dataobject = ls_dataobject Else &
											report_datastore.dataobject = "dw_immunization_history"

report_datastore.settransobject(sqlca)
report_datastore.setsort(ls_sort)
report_datastore.retrieve(current_patient.cpr_id)

SELECT description,
		 address1,   
       address2,   
       city,   
       state,   
       zip,   
       zip_plus4,   
       phone,   
       fax  
INTO	:ls_office_description,
		:ls_address1,   
      :ls_address2,   
      :ls_city,   
      :ls_state,   
      :ls_zip,   
      :ls_zip_plus4,   
      :ls_phone,   
      :ls_fax  
FROM c_Office
WHERE c_Office.office_id = :office_id
USING cprdb;
If Not cprdb.check() Then Return -1

If sqlca.sqlcode = 100 Then
	mylog.log(this, "u_component_report_immunization.xx_printreport:0066", "No office information", 4)
	Return -1
End if

If not isnull(ls_address2) then ls_address1 += ", " + ls_address2
If not isnull(ls_phone) then
	ls_phone = "Voice: " + ls_phone
Else
	ls_phone = ""
End if

If not isnull(ls_fax) Then
	If ls_phone <> "" Then ls_phone += ",  "
	ls_phone += "Fax: " + ls_fax
End if

// Calculate the bitmap height and width
ll_bitmap_width = printer_resolution_x * long(report_datastore.describe("signature_image.width")) / 1000
If ll_bitmap_width <= 0 Then setnull(ll_bitmap_width)

ll_bitmap_height = printer_resolution_y * long(report_datastore.describe("signature_image.height")) / 1000
If ll_bitmap_height <= 0 Then setnull(ll_bitmap_height)

report_datastore.Modify("practice.text='" + ls_office_description + "'")
report_datastore.Modify("address.text='" + ls_address1 + "'")
report_datastore.Modify("city_state_zip.text='" + ls_city + ", " + ls_state + "  " + ls_zip + "'")
report_datastore.Modify("phone_fax.text='" + ls_phone + "'")

report_datastore.Modify("patient.text='Patient: " + current_patient.name() + "'")
report_datastore.Modify("date_of_birth.text='Date of Birth: " + string(current_patient.date_of_birth, date_format_string) + "'")
report_datastore.Modify("billing_id.text='Patient ID: " + current_patient.billing_id + "'")

ll_rowcount = report_datastore.rowcount()
For i = 1 To ll_rowcount

	ll_treatment_id = report_datastore.object.treatment_id[i]
	
	lstr_attachments = current_patient.attachments.get_attachments( "Treatment", ll_treatment_id, "Attachment", "Signature")
	
	If lstr_attachments.progress_count > 0 Then
		li_sts = current_patient.attachments.attachment(luo_attachment, lstr_attachments.progress[lstr_attachments.progress_count].attachment_id)
		If li_sts <= 0 Then
			setnull(luo_attachment)
		Else
			li_sts = luo_attachment.render(".bmp",ls_signature_file,ll_bitmap_width,ll_bitmap_height)
			If li_sts <= 0 Then Setnull(ls_signature_file)
			report_datastore.object.signature_bitmap[i] = ls_signature_file
		End If
		if isvalid(luo_attachment) and not isnull(luo_attachment) then DESTROY luo_attachment
	end if
Next

print_datastore()

return 1
end function

on u_component_report_immunization.create
call super::create
end on

on u_component_report_immunization.destroy
call super::destroy
end on

