
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_convertable_units]
Print 'Drop Procedure [dbo].[sp_get_convertable_units]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_convertable_units]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_convertable_units]
GO

-- Create Procedure [dbo].[sp_get_convertable_units]
Print 'Create Procedure [dbo].[sp_get_convertable_units]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_convertable_units (
	@ps_unit_id varchar(12) )
AS
SELECT	c_Unit.unit_id,
	c_Unit.description,
	selected_flag = 0
FROM	c_Unit_Conversion (NOLOCK)
	JOIN c_Unit (NOLOCK) ON c_Unit_Conversion.unit_from = c_Unit.unit_id
WHERE c_Unit_Conversion.unit_to = @ps_unit_id
UNION
SELECT	c_Unit.unit_id,
	c_Unit.description,
	selected_flag = 0
FROM	c_Unit_Conversion (NOLOCK)
	JOIN c_Unit (NOLOCK) ON c_Unit_Conversion.unit_from = c_Unit.unit_id
WHERE c_Unit_Conversion.unit_from = @ps_unit_id
UNION
SELECT	unit_id,
	description,
	selected_flag = 0
FROM c_Unit (NOLOCK)
WHERE unit_id = @ps_unit_id

GO
GRANT EXECUTE
	ON [dbo].[sp_get_convertable_units]
	TO [cprsystem]
GO

