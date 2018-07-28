/****** Object:  Stored Procedure dbo.sp_update_family_history    Script Date: 7/25/2000 8:44:12 AM ******/
/****** Object:  Stored Procedure dbo.sp_update_family_history    Script Date: 2/16/99 12:01:16 PM ******/
/****** Object:  Stored Procedure dbo.sp_update_family_history    Script Date: 10/26/98 2:20:56 PM ******/
CREATE PROCEDURE sp_update_family_history (
	@ps_cpr_id varchar(12),
	@pl_family_history_sequence int,
	@ps_name varchar(40),
	@ps_relation varchar(40),
	@pi_birth_year smallint,
	@pi_age_at_death smallint,
	@ps_cause_of_death varchar(40) )
AS
UPDATE p_Family_History
SET	name = @ps_name,
	relation = @ps_relation,
	birth_year = @pi_birth_year,
	age_at_death = @pi_age_at_death,
	cause_of_death = @ps_cause_of_death
WHERE cpr_id = @ps_cpr_id
AND family_history_sequence = @pl_family_history_sequence

