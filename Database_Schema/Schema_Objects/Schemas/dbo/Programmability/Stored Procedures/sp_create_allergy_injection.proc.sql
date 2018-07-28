CREATE PROCEDURE sp_create_allergy_injection (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer,
	@pl_parent_treatment_id integer,
	@ps_ordered_by varchar(24) = NULL,
	@ps_created_by varchar(24) = NULL,
	@ps_description varchar(80) = NULL,
	@pl_treatment_id int OUTPUT
)

AS

DECLARE @ll_count int

IF @ps_description is null
	BEGIN
	RAISERROR ('ERROR treatment description cannot be null',16,-1)
	ROLLBACK TRANSACTION
	RETURN
	END

INSERT INTO p_treatment_item
(
	cpr_id,
	open_encounter_id,
	treatment_type,
	treatment_description,
	begin_date,
	treatment_status,
	parent_treatment_id,
	ordered_by,
	created_by,
	end_date,
	close_encounter_id,
	completed_by
)
Values
(
	@ps_cpr_id,
	@pl_encounter_id,
	'AllergyInjection',
	@ps_description,
	getdate(),
	'CLOSED',
	@pl_parent_treatment_id,
	@ps_ordered_by,
	@ps_created_by,
	getdate(),
	@pl_encounter_id,
	@ps_ordered_by
)

SELECT @pl_treatment_id = @@IDENTITY

