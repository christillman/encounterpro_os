
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop View [dbo].[v_report_display_script]
Print 'Drop View [dbo].[v_report_display_script]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[v_report_display_script]') AND [type]='V'))
DROP VIEW [dbo].[v_report_display_script]
GO
-- Create View [dbo].[v_report_display_script]
Print 'Create View [dbo].[v_report_display_script]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW dbo.v_report_display_script
AS
SELECT d.*
FROM dbo.fn_report_display_scripts() f
	INNER JOIN c_Display_Script d
	ON d.display_script_id = f.display_script_id


GO
GRANT SELECT ON [dbo].[v_report_display_script] TO [public]
GO

