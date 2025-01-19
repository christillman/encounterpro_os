
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_Set_Patient_Authority]
Print 'Drop Procedure [dbo].[sp_Set_Patient_Authority]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_Set_Patient_Authority]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_Set_Patient_Authority]
GO

-- Create Procedure [dbo].[sp_Set_Patient_Authority]
Print 'Create Procedure [dbo].[sp_Set_Patient_Authority]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_Set_Patient_Authority (
	@ps_cpr_id varchar(12),
	@pdt_start_date datetime = NULL,
	@pdt_end_date datetime = NULL,
	@pl_authority_sequence int,
	@ps_authority_id varchar(24),
	@ps_user_id varchar(24),
	@ps_created_by varchar(24) )
AS

DECLARE @ls_current_authority_id varchar(24),
		@ls_authority_type varchar(24),
		@ls_status varchar(8)

IF @ps_authority_id IS NULL
	BEGIN
	RAISERROR ('NULL Authority ID',16,-1)
	RETURN
	END

IF @pl_authority_sequence IS NULL
	BEGIN
	RAISERROR ('NULL Authority Sequence',16,-1)
	RETURN
	END

IF @pl_authority_sequence <= 0
	BEGIN
	RAISERROR ('Invalid Authority Sequence (%d)',16,-1, @pl_authority_sequence)
	RETURN
	END

-- Get the authority type
SELECT @ls_authority_type = COALESCE(authority_type,'XXXX')
FROM c_Authority
WHERE authority_id = @ps_authority_id

IF @@ERROR <> 0
	RETURN

IF @ls_authority_type IS NULL
	BEGIN
	RAISERROR ('Authority does not exist (%s)',16,-1, @ps_authority_id)
	RETURN
	END

IF @ls_authority_type = 'XXXX'
	BEGIN
	RAISERROR ('NULL Authority Type (%s)',16,-1, @ps_authority_id)
	RETURN
	END

-- Find out the current authority for this sequence
SELECT @ls_current_authority_id = authority_id,
		@ls_status = status
FROM p_Patient_Authority
WHERE cpr_id = @ps_cpr_id
AND authority_type = @ls_authority_type
AND authority_sequence = @pl_authority_sequence

IF @@ERROR <> 0
	RETURN

IF @ls_current_authority_id IS NOT NULL
	BEGIN
	-- If the existing authority_id is the same then we're done
	IF @ls_current_authority_id = @ps_authority_id
		BEGIN
		IF ISNULL(@ls_status, 'NA') <> 'OK'
			UPDATE p_Patient_Authority
			SET status = 'OK'
			WHERE cpr_id = @ps_cpr_id
			AND authority_type = @ls_authority_type
			AND authority_sequence = @pl_authority_sequence

		RETURN
		END

	-- Delete the existing authority link
	DELETE
	FROM p_Patient_Authority
	WHERE cpr_id = @ps_cpr_id
	AND authority_type = @ls_authority_type
	AND authority_sequence = @pl_authority_sequence

	END

-- Add the new authority link
INSERT INTO p_Patient_Authority (
	cpr_id,
	authority_type,
	authority_sequence,
	authority_id,
	status,
	created,
	created_by)
VALUES (
	@ps_cpr_id,
	@ls_authority_type,
	@pl_authority_sequence,
	@ps_authority_id,
	'OK',
	dbo.get_client_datetime(),
	@ps_created_by)

IF @@ERROR <> 0
	RETURN
	
GO
GRANT EXECUTE
	ON [dbo].[sp_Set_Patient_Authority]
	TO [cprsystem]
GO

