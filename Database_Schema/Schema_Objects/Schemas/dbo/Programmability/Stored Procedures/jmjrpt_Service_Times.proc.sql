


CREATE PROCEDURE jmjrpt_Service_Times
        @ps_SERVICE varchar(24)   
	,@ps_begin_date varchar(10)
	,@ps_end_date varchar(10)
AS
Declare @begin_date varchar(10)
Declare @end_date varchar(10)
Declare @SERVICE varchar(24)
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date
Select @SERVICE = @ps_SERVICE
SELECT distinct 
c_user.user_short_name as Provider	 
,convert(varchar(10),p_Patient_Encounter.encounter_date,101) AS For_Date 
,DATEDIFF(minute,p_Patient_WP_Item.begin_date,p_Patient_WP_Item.end_date) AS Minutes_Wait
,p_patient.first_name + ', ' + p_patient.last_name AS Patient
,p_Patient_Encounter.encounter_description As Encounter
FROM
c_Encounter_Type (NOLOCK),
c_User (NOLOCK),
o_Service (NOLOCK),
p_Patient (NOLOCK),
p_Patient_Encounter (NOLOCK),
p_Patient_WP_Item (NOLOCK)
WHERE
c_User.user_id = p_Patient_WP_Item.owned_by AND
p_Patient.cpr_id = p_Patient_WP_Item.cpr_id AND
c_Encounter_Type.encounter_type = p_Patient_Encounter.encounter_type AND
p_Patient_Encounter.cpr_id = p_Patient_WP_Item.cpr_id AND
p_Patient_Encounter.encounter_id = p_Patient_WP_Item.encounter_id AND
p_Patient_WP_Item.ordered_service Like @SERVICE AND
p_Patient_WP_Item.item_type = 'Service' AND
p_Patient_WP_Item.Status = 'COMPLETED' AND
p_Patient_Encounter.encounter_date >= @begin_date AND
p_Patient_Encounter.encounter_date < DATEADD(day, 1, @end_date)
ORDER BY
Provider,For_Date,Minutes_Wait,Patient,Encounter