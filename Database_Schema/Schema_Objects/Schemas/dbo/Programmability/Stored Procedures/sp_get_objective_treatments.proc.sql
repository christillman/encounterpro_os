/****** Object:  Stored Procedure dbo.sp_get_objective_treatments    Script Date: 7/25/2000 8:43:49 AM ******/
/****** Object:  Stored Procedure dbo.sp_get_objective_treatments    Script Date: 2/16/99 12:00:50 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_objective_treatments    Script Date: 10/26/98 2:20:36 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_objective_treatments    Script Date: 10/4/98 6:28:10 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_objective_treatments    Script Date: 9/24/98 3:06:03 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_objective_treatments    Script Date: 8/17/98 4:16:42 PM ******/
CREATE PROCEDURE sp_get_objective_treatments (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer,
	@ps_treatment_type varchar(24))
AS
SELECT	p_treatment_item.treatment_id,
	p_treatment_item.begin_date,
	c_user.user_id,
	c_user.user_short_name
FROM p_treatment_item (NOLOCK),
c_user (NOLOCK)
WHERE p_treatment_item.cpr_id = @ps_cpr_id
AND p_treatment_item.open_encounter_id = @pl_encounter_id
AND p_treatment_item.ordered_by = c_user.user_id
AND p_treatment_item.treatment_type = @ps_treatment_type
ORDER BY p_treatment_item.treatment_id

