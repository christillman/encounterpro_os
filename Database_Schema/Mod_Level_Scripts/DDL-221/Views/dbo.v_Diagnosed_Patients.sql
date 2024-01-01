
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop View [dbo].[v_Diagnosed_Patients]
Print 'Drop View [dbo].[v_Diagnosed_Patients]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[v_Diagnosed_Patients]') AND [type]='V'))
DROP VIEW [dbo].[v_Diagnosed_Patients]
GO
-- Create View [dbo].[v_Diagnosed_Patients]
Print 'Create View [dbo].[v_Diagnosed_Patients]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  View dbo.v_Diagnosed_Patients    Script Date: 7/25/2000 8:42:39 AM ******/
CREATE VIEW v_Diagnosed_Patients
AS
SELECT DISTINCT
	p.cpr_id,
	p.date_of_birth,
	p.sex,
	a.problem_id,
	d.description as assessment,
	a.open_encounter_id as encounter_id,
	a.begin_date AS item_date
FROM p_Patient p
JOIN p_Assessment a ON p.cpr_id = a.cpr_id
JOIN c_Assessment_Definition d ON a.assessment_id = d.assessment_id
GO
GRANT SELECT
	ON [dbo].[v_Diagnosed_Patients]
	TO [cprsystem]
GO

