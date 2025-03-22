
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmj_Set_Patient_IDValue]
Print 'Drop Procedure [dbo].[jmj_Set_Patient_IDValue]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_Set_Patient_IDValue]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_Set_Patient_IDValue]
GO

-- Create Procedure [dbo].[jmj_Set_Patient_IDValue]
Print 'Create Procedure [dbo].[jmj_Set_Patient_IDValue]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE jmj_Set_Patient_IDValue (
	@ps_cpr_id varchar(24),
	@pl_owner_id int,
	@ps_IDDomain varchar(30),
	@ps_IDValue varchar(255),
	@ps_created_by varchar(24) )
AS

DECLARE @ll_length int,
	@ls_progress_value varchar(40),
	@ls_progress_key varchar(40),
	@ll_customer_id int,
	@ls_current_value varchar(255),
	@ll_encounter_id int,
	@ls_other_cpr_id varchar(12)

SET @ll_encounter_id = NULL

IF @ps_cpr_id IS NULL
	BEGIN
	RAISERROR ('Null cpr_id',16,-1)
	RETURN -1
	END

IF @ps_IDDomain IS NULL
	BEGIN
	RAISERROR ('Null IDDomain',16,-1)
	RETURN -1
	END

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

IF @pl_owner_id IS NULL
	SET @pl_owner_id = @ll_customer_id

IF @ll_customer_id = @pl_owner_id
	SET @ls_progress_key = @ps_IDDomain
ELSE
	SET @ls_progress_key = CAST(@pl_owner_id AS varchar(9)) + '^' + @ps_IDDomain

-- Make sure this represents a change
SET @ls_current_value = dbo.fn_lookup_patient_ID(@ps_cpr_id, @pl_owner_id, @ps_IDDomain)

IF @@ERROR <> 0
	RETURN -1

IF @ls_current_value = @ps_IDValue
	RETURN 1

-- Make sure that this ID is not assigned to another patient
SET @ls_other_cpr_id = dbo.fn_lookup_patient2(@pl_owner_id, @ps_IDDomain, @ps_IDValue)

IF @@ERROR <> 0
	RETURN -1

IF LEN(@ls_other_cpr_id) > 0 AND @ls_other_cpr_id <> @ps_cpr_id
	BEGIN
	RAISERROR ('Cannot assign ID Value (%d, %s, %s) to patient (%s) because it already belongs to a different patient (%s)',16,-1, @pl_owner_id, @ps_IDDomain, @ps_IDValue, @ps_cpr_id, @ls_other_cpr_id)
	RETURN -1
	END


SELECT @ll_length = LEN(@ps_IDValue)

-- Add the progress record
IF @ll_length <= 40
	BEGIN

	SELECT @ls_progress_value = CONVERT(varchar(40), @ps_IDValue)

	INSERT INTO p_Patient_Progress (
		cpr_id,
		encounter_id,
		user_id,
		progress_date_time,
		progress_type,
		progress_key,
		progress_value,
		patient_workplan_item_id,
		risk_level,
		attachment_id,
		created,
		created_by)
	VALUES (@ps_cpr_id,
		@ll_encounter_id,
		@ps_created_by,
		dbo.get_client_datetime(),
		'ID',
		@ls_progress_key,
		@ls_progress_value,
		NULL,
		NULL,
		NULL,
		dbo.get_client_datetime(),
		@ps_created_by )
	END
ELSE
	INSERT INTO p_Patient_Progress (
		cpr_id,
		encounter_id,
		user_id,
		progress_date_time,
		progress_type,
		progress_key,
		progress,
		patient_workplan_item_id,
		risk_level,
		attachment_id,
		created,
		created_by)
	VALUES (@ps_cpr_id,
		@ll_encounter_id,
		@ps_created_by,
		dbo.get_client_datetime(),
		'ID',
		@ls_progress_key,
		@ps_IDValue,
		NULL,
		NULL,
		NULL,
		dbo.get_client_datetime(),
		@ps_created_by )



GO
GRANT EXECUTE
	ON [dbo].[jmj_Set_Patient_IDValue]
	TO [cprsystem]
GO

