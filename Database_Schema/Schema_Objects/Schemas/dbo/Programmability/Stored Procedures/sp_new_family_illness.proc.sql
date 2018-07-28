/****** Object:  Stored Procedure dbo.sp_new_family_illness    Script Date: 7/25/2000 8:44:00 AM ******/
/****** Object:  Stored Procedure dbo.sp_new_family_illness    Script Date: 2/16/99 12:01:00 PM ******/
/****** Object:  Stored Procedure dbo.sp_new_family_illness    Script Date: 10/26/98 2:20:44 PM ******/
CREATE PROCEDURE sp_new_family_illness (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer,
	@pl_family_history_sequence integer,
	@ps_assessment_id varchar(24),
	@pi_age smallint )
AS
INSERT INTO p_Family_Illness (
	cpr_id,
	encounter_id,
	family_history_sequence,
	assessment_id,
	age )
VALUES (
	@ps_cpr_id,
	@pl_encounter_id,
	@pl_family_history_sequence,
	@ps_assessment_id,
	@pi_age )

