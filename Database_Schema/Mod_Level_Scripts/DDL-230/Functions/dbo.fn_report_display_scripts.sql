
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_report_display_scripts]
Print 'Drop Function [dbo].[fn_report_display_scripts]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_report_display_scripts]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_report_display_scripts]
GO

-- Create Function [dbo].[fn_report_display_scripts]
Print 'Create Function [dbo].[fn_report_display_scripts]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_report_display_scripts ()

RETURNS @report_display_script TABLE (
	[display_script_id] [int] NULL,
	[id] uniqueidentifier NULL )

AS

BEGIN

DECLARE @ll_count int

INSERT INTO @report_display_script (
	[display_script_id])
SELECT DISTINCT CAST(value AS int)
FROM c_Report_Attribute
WHERE attribute LIKE '%display_script_id'
AND ISNUMERIC(value) = 1

SET @ll_count = 1
WHILE @ll_count > 0
	BEGIN
	INSERT INTO @report_display_script (
		[display_script_id])
	SELECT DISTINCT CAST(a.value AS int) AS display_script_id
	FROM c_Display_Script_Cmd_Attribute a
		INNER JOIN @report_display_script r
		ON r.display_script_id = a.display_script_id
	WHERE a.attribute LIKE '%display_script_id'
	AND ISNUMERIC(a.value) = 1
	AND CAST(a.value AS int) NOT IN (
		SELECT display_script_id
		FROM @report_display_script)
	
	SET @ll_count = @@ROWCOUNT
	END

UPDATE r
SET id = d.id
FROM @report_display_script r
	INNER JOIN c_Display_Script d
	ON r.display_script_id = d.display_script_id

DELETE @report_display_script
WHERE id IS NULL

RETURN
END

GO
GRANT SELECT ON [dbo].[fn_report_display_scripts] TO [public]
GO

