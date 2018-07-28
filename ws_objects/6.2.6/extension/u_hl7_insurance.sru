HA$PBExportHeader$u_hl7_insurance.sru
forward
global type u_hl7_insurance from nonvisualobject
end type
end forward

global type u_hl7_insurance from nonvisualobject
end type
global u_hl7_insurance u_hl7_insurance

forward prototypes
public function integer insurance (string is_cpr_id, string is_islandcoast_rule, ref oleobject omsg, ref u_sqlca cprdb)
end prototypes

public function integer insurance (string is_cpr_id, string is_islandcoast_rule, ref oleobject omsg, ref u_sqlca cprdb);long ll_count, ll_count2
long ll_billing_code,ll_auth_count
string ls_insurance_id
string ls_insurance_plan
string ls_insurance_type
string ls_name
string ls_billing_id
string ls_allocation
string ls_cprid
string ls_patient_billing_id
string ls_addr1, ls_addr2, ls_city, ls_state, ls_zip
string ls_groupnumber,ls_plantype,ls_policynumber,ls_workmenscomp
string ls_relationship, ls_insured_lastname, ls_insured_firstname, ls_insured_middlename
string ls_ssn, ls_insured_suffix
setnull(ls_addr1)
setnull(ls_addr2)
setnull(ls_city)
setnull(ls_state)
setnull(ls_zip)
setnull(ls_groupnumber)
setnull(ls_plantype)
setnull(ls_policynumber)
setnull(ls_workmenscomp)
setnull(ls_relationship)
ls_insured_lastname = ''
ls_insured_firstname = ''
ls_insured_middlename = ''
ls_insured_suffix = ''

ll_count = omsg.Group2.Count
if ll_count = 0 then return 1
if isnull(is_cpr_id) then return 1

if ll_count > 0 then
	DELETE p_Patient_Authority
	WHERE cpr_id = :is_cpr_id
	USING cprdb;
	if not cprdb.check() then return -1
end if

int i, j
j = 0
for i = 1 to ll_count
	ls_insurance_plan = omsg.Group2.Item[j].Insurance.InsurancePlanID.Identifier.valuestring
	ll_count2 = omsg.Group2.Item[j].Insurance.InsuranceCompanyID.Count

	If ll_count2 > 0 then
		ls_insurance_id = omsg.Group2.Item[j].Insurance.InsuranceCompanyID.Item[0].ID.valuestring
	end if

	if upper(is_islandcoast_rule) = 'INTERGY' then 
		ls_insurance_id = ls_insurance_plan
	end if

	If isnull(ls_insurance_id) or ls_insurance_id = "" then return 1
	ls_billing_id = ls_insurance_id	
	if IsNumber(ls_insurance_id) then
		ll_billing_code = long(ls_insurance_id)
	else
		setnull(ll_billing_code)
	end if

	ls_insurance_type = omsg.Group2.Item[j].Insurance.PlanType.valuestring

	ll_count2 = omsg.Group2.Item[j].Insurance.InsuranceCompanyName.Count
	if ll_count2 > 0 then
		ls_name = omsg.Group2.Item[j].Insurance.InsuranceCompanyName.Item[0].OrganizationName.valuestring
	end if

	ll_count2 = omsg.Group2.Item[j].Insurance.InsuranceCompanyAddress.Count
	if ll_count2 > 0 then
		ls_addr1 = omsg.Group2.Item[j].Insurance.InsuranceCompanyAddress.Item[0].StreetAddress.valuestring
		ls_addr2 = omsg.Group2.Item[j].Insurance.InsuranceCompanyAddress.Item[0].OtherDesignation.valuestring
		ls_city  = omsg.Group2.Item[j].Insurance.InsuranceCompanyAddress.Item[0].City.valuestring
		ls_state = omsg.Group2.Item[j].Insurance.InsuranceCompanyAddress.Item[0].StateOrProvince.valuestring
		ls_zip   = omsg.Group2.Item[j].Insurance.InsuranceCompanyAddress.Item[0].ZipOrPostalCode.valuestring
	end if	

	ls_groupnumber = omsg.Group2.Item[j].Insurance.GroupNumber.valuestring
	ls_plantype = omsg.Group2.Item[j].Insurance.PlanType.valuestring
	ls_relationship = omsg.Group2.Item[j].Insurance.InsuredsRelationshipToPatient.valuestring
	ls_relationship = right(ls_relationship,1)

	if not (isnull(ls_relationship) or ls_relationship = "" or ls_relationship = "1") then
		ll_count2 = omsg.Group2.Item[j].Insurance.NameofInsured.Count
		if ll_count2 > 0 then
			ls_insured_lastname = omsg.Group2.Item[j].Insurance.NameofInsured.Item[0].FamilyName.valuestring
			ls_insured_firstname = omsg.Group2.Item[j].Insurance.NameofInsured.Item[0].GivenName.valuestring
			ls_insured_middlename = omsg.Group2.Item[j].Insurance.NameofInsured.Item[0].MiddleName.valuestring
		end if
	end if

	ls_workmenscomp = omsg.Group2.Item[j].Insurance.TypeOfAgreementCode.valuestring
	ls_policynumber = omsg.Group2.Item[j].Insurance.PolicyNumber.valuestring

//	if is_islandcoast_rule = 'Y' then
//		if not isnull(omsg.patientvisit) then
//			ll_count2 = omsg.PatientVisit.FinancialClass.Count
//			if ll_count2 > 0 then
//				ls_name += ' ' + omsg.PatientVisit.FinancialClass.Item[0].FinancialClass.valuestring
//			end if
//		end if	
//	end if	
	long ll_pos
	if ls_insurance_type = ''  or isnull(ls_insurance_type) then
		if POS(upper(ls_name),'MEDICARE') > 0 then
			ls_insurance_type = 'Medicare'
		elseif POS(upper(ls_name),'MEDICAID') > 0 then
			ls_insurance_type = 'Medicaid'
		elseif POS(upper(ls_name),'HMO') > 0 then
			ls_insurance_type = 'StandardHMO'	
		else
			ls_insurance_type = 'StandardPOS'
		end if
	end if	

	ls_ssn = omsg.PatientIdentification.PatientSSN.valuestring
	if len(ls_ssn) > 9 then
		ll_pos = POS(ls_ssn,'-')
		if ll_pos > 0 then
			ls_ssn = left(ls_ssn,ll_pos - 1) + mid(ls_ssn,ll_pos + 1)
			ll_pos = POS(ls_ssn,'-')
			if ll_pos > 0 then
				ls_ssn = left(ls_ssn,ll_pos - 1) + mid(ls_ssn,ll_pos + 1)
			end if
		end if
	end if	

	if ls_ssn = '000000000' then ls_ssn = ' '
	ls_insurance_id = left(ls_insurance_id,24)

	SELECT COUNT(*) 
	into :ll_auth_count
	FROM c_Authority
	WHERE authority_id = :ls_insurance_id
	USING cprdb;
	if not cprdb.check() then return -1
	if ll_auth_count > 1 then
		delete from c_authority
		WHERE authority_id = :ls_insurance_id
		USING cprdb;
		if not cprdb.check() then return -1
	end if

	SELECT authority_id
		INTO :ls_insurance_id
		FROM c_Authority
		WHERE authority_id = :ls_insurance_id
		USING cprdb;
		if not cprdb.check() then return -1
	
	ls_insurance_type = left(ls_insurance_type,24)
	ls_name = left(ls_name,50)
	ls_addr1 = left(ls_addr1,40)
	ls_addr2 = left(ls_addr2,40)
	ls_city = left(ls_city,40)
	ls_state = left(ls_state,2)
	ls_zip = left(ls_zip,12)
	if cprdb.sqlcode = 100 then
		INSERT INTO c_Authority (
				authority_id,
				authority_type,
				authority_category,
				name,
				coding_component_id,
				status,
				authority_address_line_1,
				authority_address_line_2,
				authority_city,
				authority_state,
				authority_zip
				)
		VALUES (
				:ls_insurance_id,
				'PAYOR',
				:ls_insurance_type,
				:ls_name,
				null,
				'OK',
				:ls_addr1,
				:ls_addr2,
				:ls_city,
				:ls_state,
				:ls_zip)
		USING cprdb;			
		if not cprdb.check() then return -1
	else
		update c_Authority
		Set 	name = :ls_name
		WHERE authority_id = :ls_insurance_id
		USING cprdb;
		if not cprdb.check() then return -1
	end if

	setnull(ls_allocation)
	
	ls_insured_lastname = left(ls_insured_lastname,16)
	ls_insured_firstname = left(ls_insured_firstname,16)
	ls_insured_middlename = left(ls_insured_middlename,16)
	ls_insured_suffix = left(ls_insured_suffix,8)
	ls_policynumber = left(ls_policynumber,24)
	ls_ssn = left(ls_ssn,9)
	ls_workmenscomp = left(ls_workmenscomp,1)
	
	INSERT INTO p_Patient_Authority  
         ( cpr_id,  
			  authority_type,	
           authority_sequence,   
           authority_id,   
           notes,   
           created,   
           created_by,   
           modified_by,
			  insureds_last_name,
			  insureds_first_name,
			  insureds_middle_name,
			  insureds_suffix,
			  pm_insureds_id,
			  insureds_ssn,
			  workers_comp_flag)
	  VALUES ( :is_cpr_id,
  				'PAYOR',
           :i,
           :ls_insurance_id,   
           null,   
           getdate(),
           :system_user_id,
			  :system_user_id,
			  :ls_insured_lastname,
			  :ls_insured_firstname,
			  :ls_insured_middlename,
			  :ls_insured_suffix,
			  :ls_policynumber,
			  :ls_ssn,
			  :ls_workmenscomp)		
		USING cprdb;
		if not cprdb.check() then return -1
		j++
NEXT
Return 1
end function

on u_hl7_insurance.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_hl7_insurance.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

