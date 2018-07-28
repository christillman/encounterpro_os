/****** Object:  Stored Procedure dbo.sp_new_family_history    Script Date: 7/25/2000 8:44:00 AM ******/
/****** Object:  Stored Procedure dbo.sp_new_family_history    Script Date: 2/16/99 12:00:59 PM ******/
/****** Object:  Stored Procedure dbo.sp_new_family_history    Script Date: 10/26/98 2:20:44 PM ******/
CREATE PROCEDURE sp_new_family_history (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer,
	@ps_name varchar(40),
	@ps_relation varchar(40),
	@pi_birth_year smallint,
	@pi_age_at_death smallint,
	@ps_cause_of_death varchar(40) )
AS
INSERT INTO p_Family_History (
	cpr_id,
	encounter_id, 	name,
	relation,
	birth_year,
	age_at_death,
	cause_of_death )
VALUES (
	@ps_cpr_id,
	@pl_encounter_id,
	@ps_name,
	@ps_relation,
	@pi_birth_year,
	@pi_age_at_death,
	@ps_cause_of_death )

