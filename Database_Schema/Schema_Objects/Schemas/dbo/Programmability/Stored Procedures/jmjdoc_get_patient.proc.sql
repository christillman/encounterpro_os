CREATE PROCEDURE jmjdoc_get_patient (
	@ps_cpr_id varchar(24)
)

AS

  SELECT p_Patient.cpr_id as jmjinternalid,
	 p_Patient.billing_id as jmjexternalid,   
         p_Patient.race as race,   
         Convert(varchar(10),p_Patient.date_of_birth,101) as dateofbirth,   
         p_Patient.sex as sex,   
         p_Patient.primary_language as primarylanguage,   
         p_Patient.marital_status as maritalstatus,   
         p_Patient.ssn as ssn,   
         p_Patient.first_name as firstname,   
         p_Patient.last_name as lastname,   
         p_Patient.degree as degree,   
         p_Patient.name_prefix as nameprefix,   
         p_Patient.middle_name as middlename,   
         p_Patient.name_suffix as namesuffix,   
         p_Patient.maiden_name as maidenname,   
         p_Patient.phone_number as phone1,   
         p_Patient.patient_status as patientstatus,   
         p_Patient.address_line_1 as patientaddressaddressline1,   
         p_Patient.address_line_2 as patientaddressaddressline2,   
         p_Patient.city as patientaddresscity,   
         p_Patient.state as patientaddressstate,   
         p_Patient.zip as patientaddresszip,   
         p_Patient.country as patientaddresscountry,   
         p_Patient.religion as religion,   
         p_Patient.nationality as nationality,   
         p_Patient.financial_class as financialclass,   
         p_Patient.employer as employer,   
         p_Patient.employeeID as employerid,   
         p_Patient.department as department,   
         p_Patient.shift as shift,   
         p_Patient.job_description as jobdescription,   
         p_Patient.start_date as startdate,   
         p_Patient.termination_date as terminationdate,   
         p_Patient.employment_status as employmentstatus   
    FROM p_Patient  
   WHERE p_Patient.cpr_id = @ps_cpr_id    



