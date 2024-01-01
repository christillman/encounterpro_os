
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_secondary_proc_list]
Print 'Drop Procedure [dbo].[sp_get_secondary_proc_list]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_secondary_proc_list]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_secondary_proc_list]
GO

-- Create Procedure [dbo].[sp_get_secondary_proc_list]
Print 'Create Procedure [dbo].[sp_get_secondary_proc_list]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.sp_get_secondary_proc_list    Script Date: 8/17/98 4:16:46 PM ******/
CREATE PROCEDURE sp_get_secondary_proc_list
AS
SELECT	c_Procedure.procedure_id,
	c_Procedure.description,
	sort_sequence = c_Domain.domain_sequence,
	selected_flag=0
FROM	c_Domain
	JOIN c_Procedure ON c_Domain.domain_item = c_Procedure.procedure_id
WHERE	c_Domain.domain_id = 'ENC_SEC_PROC'
ORDER BY c_Domain.domain_sequence

GO
GRANT EXECUTE
	ON [dbo].[sp_get_secondary_proc_list]
	TO [cprsystem]
GO

