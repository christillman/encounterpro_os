/****** Object:  Stored Procedure dbo.sp_update_family_illness    Script Date: 7/25/2000 8:44:12 AM ******/
/****** Object:  Stored Procedure dbo.sp_update_family_illness    Script Date: 2/16/99 12:01:16 PM ******/
/****** Object:  Stored Procedure dbo.sp_update_family_illness    Script Date: 10/26/98 2:20:56 PM ******/
/****** Object:  Stored Procedure dbo.sp_update_family_illness    Script Date: 10/4/98 6:28:25 PM ******/
/****** Object:  Stored Procedure dbo.sp_update_family_illness    Script Date: 9/24/98 3:06:19 PM ******/
/****** Object:  Stored Procedure dbo.sp_update_family_illness    Script Date: 8/17/98 4:17:00 PM ******/
CREATE PROCEDURE sp_update_family_illness (
	@ps_cpr_id varchar(12),
	@pl_family_history_sequence int,
	@pl_family_illness_sequence int,
	@ps_assessment_id varchar(24),
	@pi_age smallint )
AS
UPDATE p_Family_Illness
SET	assessment_id = @ps_assessment_id,
	age = @pi_age
WHERE cpr_id = @ps_cpr_id
AND family_history_sequence = @pl_family_history_sequence
AND family_illness_sequence = @pl_family_illness_sequence

