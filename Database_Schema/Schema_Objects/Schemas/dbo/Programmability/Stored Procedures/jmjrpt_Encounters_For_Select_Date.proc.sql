

CREATE PROCEDURE jmjrpt_Encounters_For_Select_Date
	@pdt_select_date Datetime
AS
Declare @select_date Datetime
Select @select_date = @pdt_select_date
SELECT
(p.last_name + ',' + p.first_name) As Patient,
p.billing_id As Bill_ID,
ce.description,
pe.bill_flag As Bill,
Convert(varchar(10),pe.encounter_date,101) As 'StartDate',
cu1.user_short_name AS 'Created_by',
Convert(varchar(10),pe.discharge_date,101) As 'CloseDate',
cu2.user_short_name AS 'Closed_by'
FROM p_Patient_Encounter pe WITH (NOLOCK)
        inner join p_patient p  
        on p.cpr_id = pe.cpr_id
        inner join c_encounter_type ce with (NOLOCK)
        on ce.encounter_type = pe.encounter_type
        inner join p_patient_encounter_progress pep with (NOLOCK)
        on pep.cpr_id = pe.cpr_id
 	AND pep.encounter_id = pe.encounter_id
        AND pep.progress_type = 'Closed'
        inner join c_User cu2 
        ON pep.user_id = cu2.user_id
	inner join c_User cu1 with (NOLOCK)
        on pe.created_by = cu1.user_id 
WHERE
encounter_status = 'CLOSED'
AND pe.discharge_date BETWEEN @select_date  AND DATEADD( day, 1, @select_date )
order by Patient