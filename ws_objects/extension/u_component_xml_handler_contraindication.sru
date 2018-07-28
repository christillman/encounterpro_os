HA$PBExportHeader$u_component_xml_handler_contraindication.sru
forward
global type u_component_xml_handler_contraindication from u_component_xml_handler_base
end type
end forward

global type u_component_xml_handler_contraindication from u_component_xml_handler_base
end type
global u_component_xml_handler_contraindication u_component_xml_handler_contraindication

type variables
str_contraindications contraindications


end variables

forward prototypes
protected function integer xx_interpret_xml ()
end prototypes

protected function integer xx_interpret_xml ();PBDOM_ELEMENT lo_root
PBDOM_ELEMENT lo_elem[]
datetime ldt_result_expected_date
integer li_sts
long ll_owner_id
int i
string ls_root
string ls_tag
long ll_count
boolean lb_haschildren
string ls_temp
str_contraindication_type lstr_contraindication
str_element lstr_element
str_id_instance lstr_objectid
str_actor_type lstr_actor

TRY
	lo_root = xml.XML_Document.GetRootElement()
	ls_root = lo_root.getname()
	
	lo_root.GetChildElements(ref lo_elem)
	ll_count = UpperBound(lo_elem)
	
CATCH (pbdom_exception lo_error)
	log.log(this, "process_xml", "Error - " + lo_error.text, 4)
	return -1
END TRY

if isnull(ls_root) or lower(ls_root) <> "jmjcontraindication" then
	log.log(this, "xx_interpret_xml()", "Error - Document root is not 'JMJContraindication'", 4)
	return -1
end if

for i = 1 to ll_count
	ls_tag = lo_elem[i].getname()
	
	CHOOSE CASE lower(ls_tag)
		CASE "customerid"
			ls_temp = lo_elem[i].gettexttrim( )
			owner_id = long(ls_temp)
		CASE "patientid"
			lstr_element = get_element(lo_elem[i])
			lstr_objectid = get_objectid_type(lstr_element)
			if lstr_objectid.epro_domain = "cpr_id" then
				contraindications.cpr_id = lstr_objectid.epro_value
			end if
		CASE "assessmentid"
			lstr_element = get_element(lo_elem[i])
			lstr_objectid = get_objectid_type(lstr_element)
			if lstr_objectid.epro_domain = "assessment_id" then
				contraindications.assessment_id = lstr_objectid.epro_value
			end if
		CASE "user"
			lstr_element = get_element(lo_elem[i])
			lstr_actor = get_actor_type(lstr_element)
			contraindications.user_id = lstr_actor.user_id
	END CHOOSE
next

// Now process all the "contraindication" elements
contraindications.contraindication_count = 0
for i = 1 to ll_count
	ls_tag = lo_elem[i].getname()
	if lower(ls_tag) = "contraindication" then
		lstr_element = get_element(lo_elem[i])
		lstr_contraindication = get_contraindication_type(lstr_element)
		if not isnull(lstr_contraindication.treatmenttype) then
			contraindications.contraindication_count += 1
			contraindications.contraindication[contraindications.contraindication_count] = lstr_contraindication
		end if
	end if
next

document_payload = contraindications

return 1


end function

on u_component_xml_handler_contraindication.create
call super::create
end on

on u_component_xml_handler_contraindication.destroy
call super::destroy
end on

