

CREATE PROCEDURE jmjrpt_vaccine_pt_count
AS
Declare @Count1 integer, @Count3 integer
SELECT @Count1 = (SELECT COUNT(p.cpr_id)
     FROM p_patient p WITH (NOLOCK)
     where cpr_id in (select cpr_id from p_Treatment_Item i WITH (NOLOCK)
        where
        i.treatment_type IN ('IMMUNIZATION', 'PASTIMMUN')
        and i.treatment_status = 'CLOSED')
        and p.patient_status = 'ACTIVE'
       )
-- No vaccine 
SELECT @Count3 = (SELECT COUNT(p.cpr_id)
     FROM p_patient p WITH (NOLOCK)
     WHERE
        p.patient_status = 'ACTIVE' 
        AND p.cpr_id Not IN
        (Select i.cpr_id
         From p_Treatment_Item i WITH (NOLOCK)
        WHERE p.cpr_id = i.cpr_id
        AND i.treatment_type IN ('IMMUNIZATION', 'PASTIMMUN')
        and i.treatment_status = 'CLOSED'))

SELECT @Count1 AS Pts_with_Vac_record,
       @Count3 As Pts_with_no_Vac_record