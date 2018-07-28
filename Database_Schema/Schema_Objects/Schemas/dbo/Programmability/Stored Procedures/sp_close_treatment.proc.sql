/****** Object:  Stored Procedure dbo.sp_close_treatment    Script Date: 7/25/2000 8:43:32 AM ******/
/****** Object:  Stored Procedure dbo.sp_close_treatment    Script Date: 2/16/99 12:00:40 PM ******/
CREATE PROCEDURE sp_close_treatment (
	@ps_cpr_id varchar(12),
	@pl_treatment_id integer,
	@pl_encounter_id integer,
	@ps_user_id varchar(24),
	@ps_created_by varchar(24) )
AS
EXECUTE sp_set_treatment_progress
	@ps_cpr_id = @ps_cpr_id,
	@pl_treatment_id = @pl_treatment_id,
	@pl_encounter_id = @pl_encounter_id,
	@ps_progress_type = 'CLOSED',
	@ps_progress = NULL,
	@ps_user_id = @ps_user_id, 	@ps_created_by = @ps_created_by

