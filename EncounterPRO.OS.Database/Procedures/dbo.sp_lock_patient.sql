
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_lock_patient]
Print 'Drop Procedure [dbo].[sp_lock_patient]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_lock_patient]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_lock_patient]
GO

-- Create Procedure [dbo].[sp_lock_patient]
Print 'Create Procedure [dbo].[sp_lock_patient]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_lock_patient (
	@ps_cpr_id varchar(12),
	@ps_user_id varchar(24),
	@ps_locked_by varchar(24) OUTPUT )
AS
UPDATE p_Patient
SET locked_by = @ps_user_id
WHERE cpr_id = @ps_cpr_id
AND locked_by IS null

SELECT @ps_locked_by = null
SELECT @ps_locked_by = locked_by
FROM p_Patient
WHERE cpr_id = @ps_cpr_id

GO
GRANT EXECUTE
	ON [dbo].[sp_lock_patient]
	TO [cprsystem]
GO

