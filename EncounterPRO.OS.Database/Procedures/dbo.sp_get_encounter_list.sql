
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_encounter_list]
Print 'Drop Procedure [dbo].[sp_get_encounter_list]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_encounter_list]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_encounter_list]
GO

-- Create Procedure [dbo].[sp_get_encounter_list]
Print 'Create Procedure [dbo].[sp_get_encounter_list]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_encounter_list (
	@ps_cpr_id varchar(12),
	@ps_encounter_type varchar(24) = NULL,
	@ps_indirect_flag varchar(12) = NULL,
	@ps_encounter_status varchar(8) = NULL )
AS

IF @ps_encounter_type IS NULL
	SET @ps_encounter_type = '%'

IF @ps_indirect_flag IS NULL
	SET @ps_indirect_flag = '%'

IF @ps_encounter_status IS NULL
	SET @ps_encounter_status = '%'

;WITH doc_status AS (
	SELECT cpr_id, encounter_id,
		sum(case when status IN ('Ordered', 'Created', 'Error') then 1 else 0 end) as not_sent,
		sum(case when status NOT IN ('Ordered', 'Created', 'Error') then 1 else 0 end) as sent_or_cancelled
	FROM p_Patient_WP_Item
	WHERE cpr_id = @ps_cpr_id
	AND item_type = 'Document'
	AND status IS NOT NULL
	GROUP BY cpr_id, encounter_id
)
SELECT e.cpr_id,   
         e.encounter_id,   
         e.encounter_type, 
         e.encounter_status,
         COALESCE(e.encounter_description, t.description) as encounter_description,
         e.encounter_date,
         e.attending_doctor,
         u.user_short_name,
         u.color,
         t.description as encounter_type_description,
         COALESCE(o.description, e.office_id) as office_description,
         selected_flag=0,
         t.icon as encounter_type_icon,
		--		0 = No documents
		--		1 = Documents, but all are sent or cancelled
		--		2 = Documents, at least one has not been sent
		 CASE WHEN s.encounter_id IS NULL THEN 0 
			WHEN s.not_sent > 0 THEN 2
			WHEN s.sent_or_cancelled > 0 THEN 1
			END AS document_status
		--dbo.fn_patient_object_document_status(e.cpr_id, 'Encounter', e.encounter_id) as document_status
FROM	p_Patient_Encounter e
	LEFT OUTER JOIN c_Encounter_Type t ON e.encounter_type = t.encounter_type
	LEFT OUTER JOIN c_User u ON e.attending_doctor = u.user_id
	LEFT OUTER JOIN c_Office o ON e.office_id = o.office_id
	LEFT JOIN doc_status s ON s.cpr_id = e.cpr_id AND s.encounter_id = e.encounter_id
WHERE e.cpr_id = @ps_cpr_id
AND	e.encounter_type like @ps_encounter_type
AND	e.indirect_flag like @ps_indirect_flag
AND	e.encounter_status like @ps_encounter_status
ORDER BY e.encounter_date DESC,   
         e.encounter_id DESC

GO
GRANT EXECUTE
	ON [dbo].[sp_get_encounter_list]
	TO [cprsystem]
GO

