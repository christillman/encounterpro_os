
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_billable_provider]
Print 'Drop Procedure [dbo].[sp_get_billable_provider]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_billable_provider]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_billable_provider]
GO

-- Create Procedure [dbo].[sp_get_billable_provider]
Print 'Create Procedure [dbo].[sp_get_billable_provider]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_billable_provider (
	@ps_attending_doctor varchar(24),
	@ps_supervising_doctor varchar(24),
	@ps_primary_provider_id varchar(24),
	@ps_billable_provider varchar(24) OUT
	)

AS

DECLARE @ls_supervisor_user_id varchar(24),
	@ls_billable_provider varchar(24)


SET @ls_billable_provider = NULL
SET @ps_billable_provider = NULL

/* I. Bill Under Supervising Doctor 
IF @ps_supervising_doctor is not null
BEGIN
	SELECT	@ls_billable_provider = billing_id
	FROM c_user  
	WHERE [user_id] = @ps_supervising_doctor
	AND user_status = 'OK'
END */

/* II. Is Attending Doctor Billable??  */
IF @ls_billable_provider is NULL OR len(@ls_billable_provider) = 0
BEGIN
	SELECT	@ls_billable_provider = billing_id,
		@ls_supervisor_user_id = supervisor_user_id 
	FROM c_user  
	WHERE [user_id] = @ps_attending_doctor
	AND user_status = 'OK'
END

/* III. if supervisor is assigned for attending doctor then bill under supervisor;
if a valid PM code is assigned and also assigned supervisor then the charge message
interface will bill under supervisor and also sends the attending doctor to get credits */

IF @ls_billable_provider is NULL OR len(@ls_billable_provider) = 0
BEGIN
	SELECT	@ls_billable_provider = billing_id
	FROM c_user  
	WHERE [user_id] = @ls_supervisor_user_id
	AND user_status = 'OK'
END

/* IV. Bill under PCP(primary care provider) */
IF (@ls_billable_provider is NULL  OR len(@ls_billable_provider) = 0 )AND @ps_primary_provider_id <> '!PHYSICIAN'
BEGIN
	SELECT	@ls_billable_provider = billing_id
	FROM c_user  
	WHERE [user_id] = @ps_primary_provider_id
	AND user_status = 'OK'
END

SELECT @ps_billable_provider = @ls_billable_provider

GO
GRANT EXECUTE
	ON [dbo].[sp_get_billable_provider]
	TO [cprsystem]
GO

