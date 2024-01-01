
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_coding_componentx]
Print 'Drop Procedure [dbo].[sp_get_coding_componentx]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_coding_componentx]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_coding_componentx]
GO

-- Create Procedure [dbo].[sp_get_coding_componentx]
Print 'Create Procedure [dbo].[sp_get_coding_componentx]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_get_coding_componentx (
	@ps_cpr_id varchar(12))
AS
DECLARE @li_authority_sequence smallint,
	@ps_component_id varchar(24)
	
SELECT @ps_component_id = NULL
-- Assume that minimal sequence number is primary insurance carrier
SELECT @li_authority_sequence = min(authority_sequence)
FROM p_Patient_Authority
WHERE cpr_id = @ps_cpr_id

IF @li_authority_sequence IS NOT NULL
	SELECT @ps_component_id = i.coding_component_id
	FROM c_Authority i
	JOIN  p_Patient_Authority pi ON pi.authority_id = i.authority_id
	WHERE pi.cpr_id = @ps_cpr_id
	AND pi.authority_sequence = @li_authority_sequence

IF @ps_component_id IS NULL
	SELECT @ps_component_id = 'JMJ_STD'
	
	

SELECT @ps_component_id as component_id



GO
GRANT EXECUTE
	ON [dbo].[sp_get_coding_componentx]
	TO [cprsystem]
GO

