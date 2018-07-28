CREATE PROCEDURE sp_add_workplan_item_attribute
	(
	@ps_cpr_id varchar(12) = NULL,
	@pl_patient_workplan_id int = NULL,
	@pl_patient_workplan_item_id int,
	@ps_attribute varchar(64),
	@ps_value text = NULL,
	@ps_created_by varchar(24),
	@ps_user_id varchar(24) = NULL,
	@pdt_created datetime = NULL
	)
AS

DECLARE @ll_length int,
	@ls_value_short varchar(50),
	@ll_actor_id int

IF @ps_user_id IS NULL
	SET @ps_user_id = @ps_created_by

SELECT @ll_actor_id = actor_id
FROM c_User
WHERE user_id = @ps_user_id

IF @pdt_created IS NULL
	SET @pdt_created = getdate()

IF (@ps_cpr_id IS NULL) OR (@pl_patient_workplan_id IS NULL)
	BEGIN
	SELECT @ps_cpr_id = cpr_id,
		@pl_patient_workplan_id = patient_workplan_id
	FROM p_Patient_WP_Item
	WHERE patient_workplan_item_id = @pl_patient_workplan_item_id

	IF @@rowcount <> 1
		BEGIN
		RAISERROR ('No such workplan item (%d)',16,-1, @pl_patient_workplan_item_id)
		ROLLBACK TRANSACTION
		RETURN
		END
	END


-- First add the progress record.  If the length of @ps_progress is <= 40 then
-- store the value in [progress_value].  Otherwise store it in [progress].
SELECT @ll_length = LEN(CONVERT(varchar(500), @ps_value))

IF @ll_length <= 50
	BEGIN
	SELECT @ls_value_short = CONVERT(varchar(50), @ps_value)

	INSERT INTO p_Patient_WP_Item_Attribute
		(
		cpr_id,
		patient_workplan_id,
		patient_workplan_item_id,
		attribute,
		value_short,
		actor_id,
		created_by,
		created)
	VALUES	(
		@ps_cpr_id,
		@pl_patient_workplan_id,
		@pl_patient_workplan_item_id,
		@ps_attribute,
		@ls_value_short,
		@ll_actor_id,
		@ps_created_by,
		@pdt_created)
	END
ELSE
	BEGIN
	INSERT INTO p_Patient_WP_Item_Attribute
		(
		cpr_id,
		patient_workplan_id,
		patient_workplan_item_id,
		attribute,
		message,
		actor_id,
		created_by,
		created)
	VALUES	(
		@ps_cpr_id,
		@pl_patient_workplan_id,
		@pl_patient_workplan_item_id,
		@ps_attribute,
		@ps_value,
		@ll_actor_id,
		@ps_created_by,
		@pdt_created)
	END

IF @@rowcount <> 1
	BEGIN
	RAISERROR ('Could not insert record into p_Patient_WP_Item_Attribute',16,-1)
	ROLLBACK TRANSACTION
	RETURN
	END


