

CREATE PROCEDURE jmjrpt_treatment_bydoc
	@ps_user_id varchar(24)
	,@ps_begin_date varchar(10)
	,@ps_end_date varchar(10) 
	,@ps_observation_id varchar(24)     
AS
Declare @user_id varchar(24)
Declare @begin_date varchar(10)
Declare @end_date varchar(10)
Declare @observation_id varchar(24)
Select @user_id = @ps_user_id
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date
Select @observation_id = @ps_observation_id
SELECT DISTINCT
             p.first_name
            ,p.last_name
            ,p.billing_id
            ,et.description As Observation
            ,convert(varchar(10),i.begin_date,101) AS For_Date
            ,cp.risk_level As EM_Risk
            ,COALESCE(usr4.user_full_name,usr1.user_full_name) AS 'Ordered_by'
            ,usr2.user_full_name As 'Attendant'
            ,usr3.user_full_name As 'Supervisor'
 FROM
            p_treatment_item i WITH (NOLOCK) 
INNER JOIN P_patient p WITH (NOLOCK) ON 
            p.cpr_id = i.cpr_id
INNER JOIN c_observation  et WITH (NOLOCK) ON
            et.observation_id = i.observation_id
INNER JOIN p_patient_encounter a WITH (NOLOCK) ON
            a.cpr_id = i.cpr_id 
AND         a.encounter_id = i.open_encounter_id
Left Outer JOIN c_procedure cp WITH (NOLOCK) ON
           cp.procedure_id = i.procedure_id
INNER Join p_patient_wp pwp WITH (NOLOCK) ON
           pwp.cpr_id = i.cpr_id
           AND pwp.encounter_id = i.open_encounter_id
INNER Join c_user usr4 WITH (NOLOCK) ON
           usr4.user_id = i.ordered_by
Left Outer JOIN c_user usr1 WITH (NOLOCK) ON
           usr1.user_id = pwp.ordered_by
Left Outer JOIN c_user usr2 WITH (NOLOCK) ON
           usr2.user_id = a.attending_doctor
Left Outer Join c_user usr3 WITH (NOLOCK) ON
           usr3.user_id = a.supervising_doctor
WHERE
        i.observation_id = @observation_id
AND     i.begin_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date) 
AND     Isnull(i.treatment_status,'Open') <> 'CANCELLED'
AND     (i.ordered_by = @user_id OR a.attending_doctor = @user_id OR a.supervising_doctor = @user_id OR pwp.ordered_by = @user_id )