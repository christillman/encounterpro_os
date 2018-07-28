CREATE PROCEDURE sp_get_planned_referrals (
	@ps_cpr_id varchar(12))
AS
SELECT p_Treatment_Item.treatment_id,
	p_Treatment_Item.begin_date,
	c_Specialty.description
FROM p_Treatment_Item,
	c_Specialty
WHERE p_Treatment_Item.cpr_id = @ps_cpr_id
AND p_Treatment_Item.specialty_id = c_Specialty.specialty_id
AND p_Treatment_Item.treatment_type = 'REFERRAL'
AND p_Treatment_Item.treatment_status NOT IN ('CLOSED', 'CANCELLED', 'MODIFIED')


