


CREATE PROCEDURE jmjrpt_Service_Avg_Times
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


SELECT c_User.user_short_name as Provider
,o_Service.description as service_description
,Avg(datediff(minute,p_Patient_WP_Item.begin_date,p_Patient_WP_Item.end_date)) AS Avg_Minutes
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
o_Service.service = p_Patient_WP_Item.ordered_service AND
p_Patient_WP_Item.ordered_service LIKE @SERVICE AND
p_Patient_WP_Item.item_type = 'Service' AND
p_Patient_WP_Item.Status = 'COMPLETED' AND
p_Patient_Encounter.encounter_date >= @begin_date AND
p_Patient_Encounter.encounter_date < DATEADD(day, 1, @end_date)
Group by c_User.user_short_name,o_Service.description
Order by Provider asc