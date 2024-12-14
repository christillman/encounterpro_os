
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_icd_version]
Print 'Drop Function [dbo].[fn_icd_version]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_icd_version]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_icd_version]
GO

-- Create Function [dbo].[fn_icd_version]
Print 'Create Function [dbo].[fn_icd_version]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION dbo.fn_icd_version ()

RETURNS varchar(24)

AS
BEGIN
DECLARE @ls_icd_version varchar(24)

SET @ls_icd_version = NULL

SELECT @ls_icd_version = [current_version]
FROM [c_Database_System]
WHERE [system_id] = 'Assessments ICD'
AND [system_type] = 'Version'

RETURN @ls_icd_version

-- Currently valid values: 
--	'ICD10-CM' for USA only 
	-- reference icd10_code column 
--	'ICD10-WHO' for African countries around Rwanda 
	-- reference icd10_who and icd10_who_code column (active = 'Y')
--	'Rwanda' ... they have their own standard derived from earlier ICD-WHO
	-- reference icd10_who_code column but only those in icd10_rwanda table
	-- (includes a couple hundred where active = 'N' in icd10_who)

END

GO
GRANT EXECUTE
	ON [dbo].[fn_icd_version]
	TO [cprsystem]
GO

