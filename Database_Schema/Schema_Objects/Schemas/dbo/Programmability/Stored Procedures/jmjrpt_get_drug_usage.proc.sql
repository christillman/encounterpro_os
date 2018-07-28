

CREATE PROCEDURE jmjrpt_get_drug_usage @ps_drug_id varchar(24), @ps_begin_date varchar(10), @ps_end_date varchar(10)
AS
Declare @drug_id varchar(24)
Declare @begin_date varchar(10)
Declare @end_date varchar(10)
Select @drug_id = @ps_drug_id
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date
SELECT p_Treatment_Item.treatment_description,
       convert(varchar(10),p_Treatment_Item.begin_date,101) AS RecordDate,
       c_Office.description AS Office,
       convert(varchar(10),p_Patient.date_of_birth,101) AS DOB,
       p_Patient.billing_id AS Bill_Id,
       p_Patient.last_name + ', ' + p_Patient.first_name AS Patient,
       IsNull(p_Treatment_Item.treatment_status,'Open') As Status
FROM p_Treatment_Item WITH (NOLOCK)
INNER JOIN p_Patient_Encounter WITH (NOLOCK)
ON p_Treatment_Item.open_encounter_id = p_Patient_Encounter.encounter_id 
INNER JOIN p_Patient WITH (NOLOCK)
ON p_Treatment_Item.cpr_id = p_Patient.cpr_id
Left Outer JOIN c_Office WITH (NOLOCK)
ON p_Patient_Encounter.office_id = c_Office.office_id
WHERE p_Treatment_Item.drug_id = @drug_id
AND p_Treatment_Item.begin_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date)