
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_document_wpi_for_object]
Print 'Drop Function [dbo].[fn_document_wpi_for_object]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_document_wpi_for_object]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_document_wpi_for_object]
GO

-- Create Function [dbo].[fn_document_wpi_for_object]
Print 'Create Function [dbo].[fn_document_wpi_for_object]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_document_wpi_for_object (
	@ps_context_object varchar(24),
	@ps_cpr_id varchar(12),
	@pl_object_key int,
	@pdt_begin_date datetime,
	@pdt_end_date datetime)

RETURNS @wpi TABLE (
	patient_workplan_item_id int NOT NULL,
	status varchar(12) NULL
)
AS
BEGIN

/* 7.2.1.9: Extracted from fn_documents_for_object_2 for use in fn_count_documents_for_object */
DECLARE @ldt_begin_date datetime,
		@ldt_end_date datetime

IF @pdt_begin_date IS NULL OR @pdt_begin_date > getdate()
	SET @ldt_begin_date = DATEADD(day, -30, dbo.fn_date_truncate(getdate(), 'Day'))
ELSE
	SET @ldt_begin_date = dbo.fn_date_truncate(@pdt_begin_date, 'Day')

IF @pdt_end_date IS NULL OR @pdt_end_date > getdate()
	SET @ldt_end_date = DATEADD(day, 1, dbo.fn_date_truncate(getdate(), 'Day'))
ELSE
	SET @ldt_end_date = DATEADD(day, 1, dbo.fn_date_truncate(@pdt_end_date, 'Day'))


IF @ps_context_object = 'General'
	INSERT INTO @wpi (
		patient_workplan_item_id,
		status)
	SELECT patient_workplan_item_id,
		status
	FROM p_Patient_WP_Item i WITH (NOLOCK)
	WHERE i.item_type = 'Document'
	AND i.context_object = @ps_context_object
	AND created >= @ldt_begin_date
	AND created < @ldt_end_date


IF @ps_context_object = 'Patient'
	INSERT INTO @wpi (
		patient_workplan_item_id,
		status)
	SELECT patient_workplan_item_id,
		status
	FROM p_Patient_WP_Item i WITH (NOLOCK)
	WHERE 	i.cpr_id = @ps_cpr_id
	AND 	i.item_type = 'Document'

IF @ps_context_object = 'Encounter'
	INSERT INTO @wpi (
		patient_workplan_item_id,
		status)
	SELECT patient_workplan_item_id,
		status
	FROM p_Patient_WP_Item i WITH (NOLOCK)
	WHERE 	i.cpr_id = @ps_cpr_id
	AND 	i.item_type = 'Document'
	AND i.encounter_id = @pl_object_key

IF @ps_context_object = 'Assessment'
	INSERT INTO @wpi (
		patient_workplan_item_id,
		status)
	SELECT patient_workplan_item_id,
		status
	FROM p_Patient_WP_Item i WITH (NOLOCK)
	WHERE 	i.cpr_id = @ps_cpr_id
	AND 	i.item_type = 'Document'
	AND i.problem_id = @pl_object_key
	UNION
	SELECT patient_workplan_item_id,
		status
	FROM p_Patient_WP_Item i WITH (NOLOCK)
		INNER JOIN p_Assessment_Treatment at
		ON i.cpr_id = at.cpr_id
		AND i.treatment_id = at.treatment_id
	WHERE 	i.cpr_id = @ps_cpr_id
	AND 	i.item_type = 'Document'
	AND at.cpr_id = @ps_cpr_id
	AND at.problem_id = @pl_object_key

IF @ps_context_object = 'Treatment'
	INSERT INTO @wpi (
		patient_workplan_item_id,
		status)
	SELECT patient_workplan_item_id,
		status
	FROM p_Patient_WP_Item i WITH (NOLOCK)
	WHERE 	i.cpr_id = @ps_cpr_id
	AND 	i.item_type = 'Document'
	AND i.treatment_id = @pl_object_key

IF @ps_context_object = 'Document'
	INSERT INTO @wpi (
		patient_workplan_item_id,
		status)
	SELECT patient_workplan_item_id,
		status
	FROM p_Patient_WP_Item i WITH (NOLOCK)
	WHERE 	i.item_type = 'Document'
	AND i.patient_workplan_item_id = @pl_object_key

RETURN

END

GO
GRANT SELECT ON [dbo].[fn_document_wpi_for_object] TO [cprsystem]
GO

